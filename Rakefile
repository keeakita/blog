require 'find'
require 'haml'

task default: %w[haml gitignore build]

# Generate haml files
task :haml do
  forall_haml do |path|
    outfile = File.new(path[0..-6], 'w')
    engine = Haml::Engine.new(File.read(path))
    outfile.write(engine.render)
    outfile.close
  end
end

# Update gitignore to ignore html files generated from haml files
task :gitignore do
  orig_gitignore = File.read('./.gitignore')
  outfile = File.new('./.gitignore', 'a')

  forall_haml do |path|
    ignore_path = path[2..-6]
    unless orig_gitignore.include? ignore_path
      outfile.puts ignore_path
    end

    outfile.close
  end
end

# Build the site with jekyll
task :build do
  `bundle exec jekyll build`
end

def forall_haml
  Find.find('./') do |path|
    # Only run on files
    if File::file? path
      if /\.html.haml$/.match path
        yield path
      end
    end
  end
end
