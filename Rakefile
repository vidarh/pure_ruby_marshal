require "bundler/gem_tasks"

task :spec do
  sh "rspec ."
end

task :stb do
  File.open("mruby_marshal.rb", "w") do |f|
    files = ["lib/mruby_prelude.rb"]
    files.concat(Dir.glob("lib/pure_ruby_marshal/*.rb"))
    files << "lib/pure_ruby_marshal.rb"
    files.each do |fname|
      file = File.read(fname)
      file.gsub!(/^require ['"]pure_ruby_marshal\/.*$/, "")
      f.puts ("\n# #{fname}\n")
      f.write(file)
    end
  end
end
