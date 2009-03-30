Given /^the file (.*)$/ do |relative_path|
  @path = File.expand_path(File.join(File.dirname(__FILE__), "..", "support", relative_path))
  unless File.exist?(@path)
    raise "could not find file at #{@path}"
  end
end

Given /^the following spec:$/ do |code|
  create_file("current_example.rb", code)
end

Given %r{^the following spec named "([^"]+)"$} do |file_name, code|
  create_file(file_name, code)
end

Given /^a file named (.*) with:$/ do |file_name, content|
  create_file(file_name, content)
end

When /^I run it with the (.*)$/ do |interpreter|
  case(interpreter)
    when /^ruby interpreter/
      args = interpreter.gsub('ruby interpreter','')
      ruby("#{@path}#{args}")
    when /^spec command/
      args = interpreter.gsub('spec command','')
      spec("#{@path}#{args}")
    when 'CommandLine object' then cmdline(@path)
    else raise "Unknown interpreter: #{interpreter}"
  end
end

When %r{^I run "spec ([^"]+)"$} do |file_and_args|
  spec(file_and_args)
end

Then /^the (.*) should match (.*)$/ do |stream, string_or_regex|
  written = case(stream)
    when 'stdout' then last_stdout
    when 'stderr' then last_stderr
    else raise "Unknown stream: #{stream}"
  end
  written.should smart_match(string_or_regex)
end

Then /^the (.*) should not match (.*)$/ do |stream, string_or_regex|
  written = case(stream)
    when 'stdout' then last_stdout
    when 'stderr' then last_stderr
    else raise "Unknown stream: #{stream}"
  end
  written.should_not smart_match(string_or_regex)
end

Then /^the exit code should be (\d+)$/ do |exit_code|
  if last_exit_code != exit_code.to_i
    raise "Did not exit with #{exit_code}, but with #{last_exit_code}. Standard error:\n#{last_stderr}"
  end
end
