---
layout: post
title:  "Using HAML with Jekyll Layouts"
date:   2015-03-28 16:23:51
tags:   tech web jekyll git rake
categories: tech
---

I dislike writing HTML by hand if I can avoid it (opening/closing tags feel very
verbose). Luckily, there are cool languages like [HAML][haml] that make it a lot
lighter and faster to write. Unfortunately, it seems that Jekyll doesn't have
any built in support for HAML.

I searched around for several solutions, but none of them worked quite how I
wanted them to. I tried the [jekyll-haml][jekyll-haml] gem, but I had issues
getting it to work in a layout and it seemed to be unmaintained. I also found a
[2009 blog post by Raphael Stolt][stolt], but it seemed a bit involved for what
I was trying to accomplish.

I eventually decided to make my own Rake tasks that would take care of this for
me. This Rakefile finds any `*.html.haml` files in the project and then
generates normal HTML. You can find it on the bottom of this post, or a possibly
more up to date copy on the [GitHub repo for this blog][github].

One downside of this approach is that we are introducing a new tool and building
our site involves more than just jekyll, which can be an issue if you plan to
host on something like GitHub pages. This isn't a big deal to me since I'll be
hosting on my own server. Also an issue is that there isn't a good way to tell
VCS like Git to ignore HTML files generated from HAML.

To solve this problem use the rake task `gitignore`. This task will search for
`*.html.haml` files in your project, and then add the name of the generated
files to your `.gitignore` if not already present.

The Rakefile:

{%highlight ruby %}
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
    # Exclude vendor
    if path.start_with? './vendor'
      Find.prune
    end

    # Only run on files
    if File::file? path
      if /\.html.haml$/.match path
        yield path
      end
    end
  end
end
{% endhighlight %}

[haml]: http://haml.info/
[jekyll-haml]: https://github.com/samvincent/jekyll-haml
[stolt]: http://raphaelstolt.blogspot.com/2009/03/using-haml-sass-from-rake-task.html
[github]: https://github.com/oslerw/blog
