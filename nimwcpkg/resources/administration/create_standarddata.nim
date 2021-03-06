import
  os, strutils, rdstdin, logging,
  ../utils/logging_nimwc

when defined(postgres): import db_postgres
else:                   import db_sqlite


const
  title = "Nim Website Creator"

  head* = """
  <meta charset="utf-8">
  <title>Nim Website Creator</title>
  <meta name="generator" content="Nim Website Creator">
  <meta name="description" content="Nim Website Creator">
  <meta name="keywords" content="Nim Website Creator">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="shortcut icon" href="/favicon.ico">
  <link rel="icon" type="image/png" href="/images/logo/favicon-16x16.png" sizes="16x16">
  <link rel="icon" type="image/png" href="/images/logo/favicon-32x32.png" sizes="32x32">
  <link rel="icon" type="image/png" href="/images/logo/favicon-192x192.png" sizes="192x192">
  <link rel="apple-touch-icon" sizes="180x180" href="/images/logo/favicon-180x180.png">

  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bulma/0.7.2/css/bulma.min.css">

  <link rel="stylesheet" href="/css/style.css">
  <link rel="stylesheet" href="/css/style_custom.css">

  <script src="/js/js.js" defer></script>
  <script src="/js/js_custom.js" defer></script>
  """

  headClean = """
  <meta charset="utf-8">
  <title></title>
  <meta name="generator" content="">
  <meta name="description" content="">
  <meta name="keywords" content="">
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link rel="stylesheet" href="/css/style.css">
  <link rel="stylesheet" href="/css/style_custom.css">

  <script src="/js/js.js" defer></script>
  <script src="/js/js_custom.js" defer></script>
  """

  headBootstrap = """
  <meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="shortcut icon" href="/images/logo/favicon.ico">
  <link rel="icon" type="image/png" href="/images/logo/favicon-16x16.png" sizes="16x16">
  <link rel="icon" type="image/png" href="/images/logo/favicon-32x32.png" sizes="32x32">
  <link rel="icon" type="image/png" href="/images/logo/favicon-192x192.png" sizes="192x192">
  <link rel="apple-touch-icon" sizes="180x180" href="/images/logo/favicon-180x180.png">
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO" crossorigin="anonymous">
  <link rel="stylesheet" href="/css/style.css">
  <link rel="stylesheet" href="/css/style_custom.css">
  <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.3/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
  <script src="/js/js.js" defer></script>
  <script src="/js/js_custom.js" defer></script>
  """

  navbar* = """
  <nav class="navbar is-transparent is-fixed-top" role="navigation" aria-label="main navigation">
    <div class="navbar-brand">
      <a class="navbar-item logo" href="/">
        <img src="/images/logo/NimWC_logo_blue.png" title="Nim Website Creator" />
      </a>

      <a role="button" class="navbar-burger burger" aria-label="menu" aria-expanded="false" data-target="navbarMain">
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
        <span aria-hidden="true"></span>
      </a>
    </div>

    <div id="navbarMain" class="navbar-menu">
      <div class="navbar-start">
        <hr class="navbar-divider">
        <a class="nav-link navbar-item is-hoverable" href="/">Home</a>
        <hr class="navbar-divider">
        <a class="nav-link navbar-item is-hoverable" href="/blog">Blog</a>
        <hr class="navbar-divider">
        <a class="nav-link navbar-item is-hoverable" href="/p/about">About</a>
        <hr class="navbar-divider">
        <a class="nav-link navbar-item is-hoverable is-hidden-tablet" href="/login">Login</a>
        <hr class="navbar-divider is-hidden-tablet">
      </div>

      <div class="navbar-end is-hidden-mobile">
        <div class="navbar-item">
          <div class="buttons">
            <a class="button is-small is-outlined" href="/login">Login</a>
          </div>
        </div>
      </div>

    </div>
  </nav>
  """

  navbarClean = """
  <nav class="navbar is-transparent is-fixed-top" role="navigation" aria-label="main navigation">
    <div class="navbar-brand">
      <a class="navbar-item logo" href="/">Home</a>
      <a class="navbar-item logo" href="/blog">Blog</a>
      <a class="button is-small is-outlined" href="/login">Login</a>
    </div>
  </nav>
  """

  navbarBootstrap = """
  <nav id="navbar" class="navbar navbar-expand-md navbar-light">
    <div id="navbarInside">
      <a class="navbar-brand" href="/">
        <img src="/images/logo/NimWC_logo_blue.png" />
        <div>Nim Website Creator</div>
      </a>
      <div class="navbar-toggler mainMenu">
        <div class="baricon bar1"></div>
        <div class="baricon bar2"></div>
        <div class="baricon bar3"></div>
      </div>
      <div class="menu" id="mainMenu">
        <ul class="navbar-nav">
          <li class="nav-item">
            <a class="nav-link" href="/">Frontpage</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/blog">Blog</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/p/about">About</a>
          </li>
        </ul>
      </div>
      <div class="menu hidden" id="mobileMenu">
        <div class="navbar-toggler">
          <div class="baricon bar1"></div>
          <div class="baricon bar2"></div>
          <div class="baricon bar3"></div>
        </div>
        <ul class="navbar-nav">
          <li class="nav-item">
            <a class="nav-link" href="/">Frontpage</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/blog">Blog</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/p/about">About</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/login">Login</a>
          </li>
        </ul>
      </div>
    </div>
  </nav>
  """

  footerClean = """
  <footer class="footer">
    <div id="footerInside" class="content has-text-centered">
      <p> &#169; 2019</p>
    </div>
  </footer>
  """

  footer* = """
  <div id="footerInside" class="content has-text-centered">
    <div class="container-fluid">
      <div class="columns row">
        <div class="column col-12 col-md-3 footerLeft">
          <h5>
            Copyright
          </h5>
          <p>
            <p>&#169; 2019 - <a href="https://ttj.dk"><u>Thomas T. Jarløv</u></a> & <a href="https://github.com/juancarlospaco"><u>Juan Carlos</u></a></p>
          </p>
        </div>
        <div class="column col-12 col-md-6 footerMiddle">
        </div>
        <div class="column col-12 col-md-3 footerRight">
          <h5>
            Nim Website Creator
          </h5>
          <p>
            <p>License: GPLv3 - <a href="https://github.com/ThomasTJdev/nim_websitecreator"><u>Github</u></a></p>
          </p>
        </div>
      </div>
    </div>
  </div>
  """

  about = """
  <div id="about">
    <div class="title reveal reveal-bottom">
      <h1>Learn more about NimWC
      </h1>
      <h2>Get involved.
      </h2>
    </div>
    <div class="text1">
      <h2>Flexibility
      </h2>
      <div class="text1container">
        <div class="container-fluid">
          <div class="columns row">
            <div class="column col-12 col-md-6">
              <div class="text1element">
                <h4>Customizable
                </h4>
                <p>
                  NimWC is designed for users who have a little knowledge about HTML, CSS and JS.
                  It is possible to customize the frontend code for all pages or for specific pages.
                  This flexibility gives the user the power instead of given the power to the platform.
                </p>
              </div>
            </div>
            <div class="column col-12 col-md-6">
              <div class="text1element">
                <h4>Wordpress
                </h4>
                <p>
                  NimWC is not a replacement for Wordpress but an alternative.
                  NimWC is a self-hosted solution with a minimum of requirements
                  which also ensures, that there are fewer dependencies.
                </p>
              </div>
            </div>
          </div>
          <div class="columns row">
            <div class="column col-12 col-md-6">
              <div class="text1element">
                <h4>Self-hosting
                </h4>
                <p>
                  By utilizing the powerful language Nim, NimWC is compiled to C code,
                  which is runnable on almost all platforms. This further more makes it incredibly easy
                  to host NimWC on e.g. Amazon or on a Raspberry Pi.
                </p>
              </div>
            </div>
            <div class="column col-12 col-md-6">
              <div class="text1element">
                <h4>Open source
                </h4>
                <p>
                  All of NimWC code is available to the public. Any Nim programmer can contribute with
                  improvements and new features. The codebase is built upon modules, which makes it
                  easy to add new features and plugins.
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="spacer">
    </div>
  </div>
  """

  frontpageClean = """
  <style>#background{background-image:none}</style>
  <h1>Frontpage</h1>
  <p>Login to edit</p>
  """

  frontpage = """
  <div id="frontpage">
    <div class="title">
      <h1 class="reveal reveal-bottom">Nim Website Creator
      </h1>
      <h2 class="reveal reveal-bottom">Websites on the fly
      </h2>
      <h2 class="reveal reveal-bottom seemore">
        <a href="#start" class="jump">See more</a>
      </h2>
    </div>
    <div id="start" class="text2 reveal reveal-bottom">
      <h2>NimWC is a new tool for
        <br>generating websites on the fly
      </h2>
    </div>
    <div class="text3">
      <div class="container-fluid">
        <div class="columns row">
          <div class="column col-12 col-md-4">
            <div class="text3element">
              <h4>One click install
              </h4>
              <p>Install with Nim's <a href="http://nimble.directory">package manager Nimble</a> or compile yourself. Just run the file, and your website is up and running.
              </p>
            </div>
          </div>
          <div class="column col-12 col-md-4">
            <div class="text3element">
              <h4>Plugins
              </h4>
              <p>Install plugins within the browser, e.g. <a href="https://github.com/ThomasTJdev/nimwc_backup">backup function</a>, <a href="https://github.com/ThomasTJdev/nimwc_themes">themes</a>, etc. <a href="https://github.com/ThomasTJdev/nimwc_plugins#contribute">Easy development of new plugins</a>.
              </p>
            </div>
          </div>
          <div class="column col-12 col-md-4">
            <div class="text3element">
              <h4>Speed and security
              </h4>
              <p>NimWC is developed with <a href="https://nim-lang.org">the programming language Nim</a> to <a href="https://nim-lang.org/features.html">ensure high speed and stability</a>.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="text4">
      <h2>Installation
      </h2>
      <div class="text4container">
        <div class="container-fluid">
          <div class="columns row">
            <div class="column col-12 col-md-6">
              <div class="text4element">
                <h4>Nimble
                </h4>
                <p style="margin-bottom: 0rem;">
                  <label style="width: 70px;">Install:</label>
                  <kbd>nimble install nimwc</kbd>
                </p>
                <p>
                  <label style="width: 70px;">Run:</label>
                  <kbd>nimwc</kbd>
                </p>
              </div>
            </div>
            <div class="column col-12 col-md-6">
              <div class="text4element">
                <h4>Compile
                </h4>
                <p style="margin-bottom: 0rem;">
                  <label style="width: 70px;">Clone:</label>
                  <kbd>git clone https://git.io/f4AfL</kbd>
                </p>
                <p>
                  <label style="width: 70px;">Compile:</label>
                  <kbd>nim c -r nimwc.nim</kbd>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="text5">
      <h2 class="sub1 reveal reveal-bottom">NimWC is 100% free
      </h2>
      <h2 class="sub2 reveal reveal-bottom">NimWC is 100% open source
      </h2>
    </div>
    <div class="text6">
      <h2>Next step
      </h2>
      <div class="text6container">
        <div class="container-fluid">
          <div class="columns row">
            <div class="column col-12 col-md-6">
              <div class="text6element">
                <h4>Try NimWC
                </h4>
                <p style="margin-bottom: 0.3rem;">Try the test user without registration
                </p>
                <p>Go to
                  <a href="/login">the login page</a> and login with the test user.
                </p>
              </div>
            </div>
            <div class="column col-12 col-md-6">
              <div class="text6element">
                <h4>Learn more
                </h4>
                <p style="margin-bottom: 0.3rem;">You can visit the
                  <a href="https://git.io/f4AfL">Github page</a> to see the code
                </p>
                <p>Checkout the features and see the examples on how to use NimWC
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="spacer">
    </div>
  </div>
  """

  blogpost1 = """
  <div id="mainContainer" class="blogpage">
    <h1>Insert blog title</h1>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
    <hr/>
    <h2>Section 2</h2>
    <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
    <h2>Section 3</h2>
    <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
    <hr>
    <h4>Section 4</h4>
    <p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>
  </div>
  """

  blogpost2 = """
  <style>
    body [class*="para_"] {
      position: relative;
      height: 300px;
      background-attachment: fixed;
      background-position: top center;
      background-size: cover;
    }
    body [class*="para_"]:nth-child(2n) {
      box-shadow: inset 0 0 1em #111;
    }
    body .para {
      height: 100vh;
    }
    body .para_foo {
      background-image: url(/images/par1b.jpeg);
    }
    body .para_bar {
      background-image: url(/images/par2b.jpeg);
    }
    body .para_baz {
      background-image: url(/images/par3b.jpeg);
    }
  </style>
  <div>
    <div class="para para_foo">
      <div style="padding-top: 100px;max-width: 200px;margin-left: auto;margin-right: auto;">
        <div class="animated bounceInRight go reveal reveal-left" style="background: black;color: white;padding: 20px;border-radius: 10px;text-align: center;">
          <h1>First parallax</h1>
        </div>
      </div>
    </div>
    <div class="para para_bar">
      <div style="background: white;color: black;padding: 20px;border-radius: 10px;text-align: center;max-width: 200px;margin-left: auto;margin-right: auto;">
          <h1>Second parallax</h1>
        </div>
    </div>
    <div class="para para_baz">
      <div style="background: white;color: black;padding: 20px;border-radius: 10px;text-align: center;max-width: 200px;margin-left: auto;margin-right: auto;">
        <h1>Third parallax</h1>
      </div>
    </div>
  </div>
  """

  blogpost3 = """
  <div style="background: white; color: black; padding: 20px; max-width: 1200px; padding: 20px; border-radius: 10px; margin-left: auto; margin-right: auto; margin-top: 100px;">
    <h1>Standard blog
    </h1>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    </p>
    <p>
      <br>
    </p>
    <div>
      <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
        <br>
      </p>
    </div>
  </div>
  <div style="height: 50px; background: transparent;">
  </div>
  <div class="container-fluid" style="max-width: 1200px; margin-left: auto; margin-right: auto;">
    <div class="columns row">
      <div class="column col-12 col-sm-6">
        <div style="background: white; color: black; padding: 25px; border-radius: 10px;">
          <h2 style="text-align: center;">UNO
          </h2>
        </div>
      </div>
      <div class="column col-12 col-sm-6">
        <div style="background: white; color: black; padding: 25px; border-radius: 10px;">
          <h2 style="text-align: center;">DUO
          </h2>
        </div>
      </div>
    </div>
  </div>
  <div style="height: 50px; background: transparent;">
  </div>
  <div style="background: white; color: black; padding: 20px; max-width: 1200px; padding: 20px; border-radius: 10px; margin-left: auto; margin-right: auto; margin-bottom: 150px; text-align: right;">
    <h1 style="text-align: right;">Standard blog
    </h1>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    </p>
    <p>
      <br>
    </p>
    <div>
      <p>Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
        <br>
      </p>
    </div>
  </div>
  """


proc standardDataSettings*(db: DbConn, dataStyle: string) =
  ## Settings
  info"Standard data: Inserting settings-data."
  exec(db, sql"DELETE FROM settings")

  if dataStyle == "bootstrap":
    discard insertID(db, sql"INSERT INTO settings (title, head, navbar, footer) VALUES (?, ?, ?, ?)", title, headBootstrap, navbarBootstrap, footer)
  elif dataStyle == "clean":
    discard insertID(db, sql"INSERT INTO settings (title, head, navbar, footer) VALUES (?, ?, ?, ?)", title, headClean, navbarClean, footerClean)
  else:
    discard insertID(db, sql"INSERT INTO settings (title, head, navbar, footer) VALUES (?, ?, ?, ?)", title, head, navbar, footer)


proc standardDataFrontpage*(db: DbConn, dataStyle = "") =
  ## Frontpage
  info"Standard data: Inserting frontpage-data."
  let frontpageExists = getValue(db, sql"SELECT id FROM pages WHERE url = ?", "frontpage")
  if frontpageExists != "":
    exec(db, sql"DELETE FROM pages WHERE id = ?", frontpageExists)

  if dataStyle == "clean":
    discard insertID(db, sql"INSERT INTO pages (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter, title, metadescription, metakeywords) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "frontpage", "Frontpage", frontpageClean, "1", "1", "1", "", "", "")
  else:
      discard insertID(db, sql"INSERT INTO pages (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter, title, metadescription, metakeywords) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "frontpage", "Frontpage", frontpage, "1", "1", "1", "NimWC Nim Website Creator", "NimWC is an online webpage editor for users with little HTML knowledge, but it also offers experienced users a freedom to customize everything.", "website,blog,nim,nimwc")


proc standardDataAbout*(db: DbConn) =
  ## About
  info"Standard data: Inserting about-data."
  let aboutExists = getValue(db, sql"SELECT id FROM pages WHERE url = ?", "about")
  if aboutExists != "":
    exec(db, sql"DELETE FROM pages WHERE id = ?", aboutExists)

  discard insertID(db, sql"INSERT INTO pages (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter, title, metadescription, metakeywords) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "about", "About", about, "1", "1", "1", "About Nim Website Creator", "NimWC is an online webpage editor for users with little HTML knowledge, but it also offers experienced users a freedom to customize everything.", "website,blog,nim,nimwc")


proc standardDataBlogpost1*(db: DbConn) =
  ## Blog post
  info"Standard data: Inserting blog post-data"
  let blogExists = getValue(db, sql"SELECT id FROM blog WHERE url = ?", "standardpost")
  if blogExists != "":
    exec(db, sql"DELETE FROM blog WHERE id = ?", blogExists)

  discard insertID(db, sql"INSERT INTO blog (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter, title, metadescription, metakeywords) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "standardpost", "Standard blogpost", blogpost1, "1", "1", "1", "NimWC Example blogpost", "This is an example blogpost using the default styling.", "website,blog,nim,nimwc")


proc standardDataBlogpost2*(db: DbConn) =
  ## Blog post
  info"Standard data: Inserting blog post-data."
  let blogExists = getValue(db, sql"SELECT id FROM blog WHERE url = ?", "standardpostv2")
  if blogExists != "":
    exec(db, sql"DELETE FROM blog WHERE id = ?", blogExists)

  discard insertID(db, sql"INSERT INTO blog (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter, title, metadescription, metakeywords) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "standardpostv2", "Parallax post v2", blogpost2, "1", "1", "1", "NimWC Example blogpost parallax", "This is an example blogpost using parallax created with NimWC.", "website,blog,nim,nimwc,parallax")


proc standardDataBlogpost3*(db: DbConn) =
  ## Blog post
  info"Standard data: Inserting blog post-data."
  let blogExists = getValue(db, sql"SELECT id FROM blog WHERE url = ?", "standardpostv3")
  if blogExists != "":
    exec(db, sql"DELETE FROM blog WHERE id = ?", blogExists)

  discard insertID(db, sql"INSERT INTO blog (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter, title, metadescription, metakeywords) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "standardpostv3", "Custom styling", blogpost3, "1", "1", "1", "NimWC Example blogpost custom", "This is an example blogpost using custom styling.", "website,blog,nim,nimwc")


proc createStandardData*(db: DbConn, dataStyle = "bulma") =
  ## Insert basic data
  info"Standard data: Inserting standard data."
  standardDataSettings(db, dataStyle)
  standardDataFrontpage(db, dataStyle)
  if dataStyle != "clean":
    standardDataAbout(db)
    standardDataBlogpost1(db)
    standardDataBlogpost2(db)
    standardDataBlogpost3(db)
