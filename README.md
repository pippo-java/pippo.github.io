[Pippo](http://pippo.ro) site repository.

How to build
-------------------
Requirements: 
- [Git](http://git-scm.com/) 
- [Jekyll](http://jekyllrb.com/)

Steps:
- create a local clone of this repository (with `git clone https://github.com/decebals/pippo-site.git`)
- go to project's folder (with `cd pippo-site`) 
- make some modifications (see below sections)
- test on your computer the modifications (see below sections)
- commit and push the modifications on github

Install Jekyll
-------------------
- [Linux](http://antoine-schellenberger.com/linux/2013/11/07/install_jekyll_on_ubuntu_1204.html)
- [Windows](http://www.madhur.co.in/blog/2011/09/01/runningjekyllwindows.html)

Create new page
-------------------
We are using [jekyll-docs-template](https://github.com/bruth/jekyll-docs-template) to generate the site. This is  a customized Jekyll project template optimized for flexible, multi-page documentation.  

The template follows a very simple convention of defining categories that correspond to sections in the navigation. Here are the default ones (they are listed in the `_config.yml`):

- `doc` - Documentation
- `ref` - Reference
- `tut` - Tutorial
- `dev` - Developers
- `post` - Posts

Since Jekyll is more geared towards blog posts, specifiying a date and setting up the front-matter can get tedious. Supplied in the `bin` directory is a simple Ruby scripy for creating a new _page_:

```bash
./bin/jekyll-page title category [filename] [--edit]
```

where `title` is the title of page, `category` is one of the categories defined in the `_config.yml`. By default the `filename` will be derived from the `title`, but you can specify an explicit filename (without the date) by passing the third agument. Finally the `--edit` (or just `-e`) will launch the editor defined by the `$EDITOR` environment variable.

Example:

```bash
./bin/jekyll-page "My New Page" ref
```

Will produce a file `_posts/2013-06-05-my-new-page.md` with the [front-matter](http://jekyllrb.com/docs/frontmatter/) already defined:

```html
---
layout: page
title: "My New Page"
category: ref
date: 2013-06-05 12:00:00
---
```

Simply add an `order` attribute to the front-matter of the page and the navigation links will be sorted accordingly (within it's section).

```html
---
layout: page
title: "My New Page"
category: ref
date: 2013-06-05 12:00:00
order: 1
---
```

For convenience, a new directory will be created called `_pages` which contains symlinks to the posts without the data prefix, e.g. `2013-04-13-foo.md` &rarr; `foo.md`. This makes it a tad easier when opening files to edit.

Edit page
-------------------
Go to `pages` folder and edit the desired file with your favourite text editor. 

Start the server
-------------------
Start the server with: `jekyll serve --watch`.  
Open local site with: `http://localhost:4000`. 

Contributing
-------------------

Any contribution is welcome. Please fork the repository and submit a Pull Request.
