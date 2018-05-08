# Copyright 2018 - Thomas T. Jarløv

import os, strutils, db_sqlite, rdstdin


const title = "Nim Website Creator"

const head* = """
<meta name="description" content="Nim Website Creator">
<meta charset="UTF-8" name="viewport" content="width=device-width, initial-scale=1.0" />

<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">
<link rel="stylesheet" href="/css/style.css">



<!--<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous" defer></script>-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.3.1/jquery.min.js" integrity="sha256-FgpCb/KJQlLNfOu91ta32o/NMZxltwRo8QtmkMRdAu8=" crossorigin="anonymous" defer></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous" defer></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous" defer></script>
<script src="/js/js.js" defer></script>
"""

const navbar* = """
<div id="navbar" class="container-fluid">
  <div class="row">
    <div class="col-12 col-md-12">
      <h3>
        Nim Website Creator
      </h3>
      <ul class="nav nav-tabs">
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
  </div>
</div>
"""


const footer* = """
<div class="container-fluid">
  <div class="row">
    <div class="col-12 col-md-3">
      <h5>
        Copyright
      </h5>
      <p>
        <p>&#169; 2018 - <a href="https://ttj.dk" style="color: black;"><u>Thomas T. Jarløv</u></a></p>
      </p>
    </div>
    <div class="col-12 col-md-6">
    </div>
    <div class="col-12 col-md-3">
      <h5>
        Nim Website Creator
      </h5>
      <p>
        <p>License: MIT - Download at: <a href="https://github.com/ThomasTJdev" style="color: black;"><u>Github</u></a></p>
      </p>
    </div>
  </div>
</div>
"""


const about = """
<h4 class="text-center">
  Nim Website Creator
</h4>
<div class="container-fluid" style="text-align: center;">
  <div class="row">
    <div class="col-3 col-md-3">
    </div>
    <div class="col-6 col-md-6">
    <dl>
      <dt>
        What
      </dt>
      <dd>
        A small and quick website creator.
      </dd>
      <dt>
        Why
      </dt>
      <dd>
        Quick setup of a website with custom configuration
      </dd>
      <dt>
        How
      </dt>
      <dd>
        Clone the GIT repo and you're ready to go!
      </dd>
    </dl>
    </div>
    <div class="col-3 col-md-3">
    </div>
  </div>
</div>
"""

const frontpage = """<h1 style="text-align: center;">Welcome</h1>"""


proc standardDataSettings*(db: DbConn) =
  # Settings
  let settingsExists = getValue(db, sql"SELECT id FROM settings WHERE id = ?", "1")
  if settingsExists != "":
    exec(db, sql"DELETE FROM settings WHERE id = ?", "1")

  discard insertID(db, sql"INSERT INTO settings (title, head, navbar, footer) VALUES (?, ?, ?, ?)", title, head, navbar, footer)


proc standardDataFrontpage*(db: DbConn) =
  # Frontpage
  let frontpageExists = getValue(db, sql"SELECT id FROM pages WHERE url = ?", "frontpage")
  if frontpageExists != "":
    exec(db, sql"DELETE FROM pages WHERE url = ?", "frontpage")

  discard insertID(db, sql"INSERT INTO pages (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "frontpage", "Frontpage", frontpage, "1", "1", "1")


proc standardDataAbout*(db: DbConn) =
  # About
  let aboutExists = getValue(db, sql"SELECT id FROM pages WHERE url = ?", "about")
  if aboutExists != "":
    exec(db, sql"DELETE FROM pages WHERE url = ?", "about")

  discard insertID(db, sql"INSERT INTO pages (author_id, status, url, name, description, standardhead, standardnavbar, standardfooter) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", "1", "2", "about", "About", about, "1", "1", "1")


proc createStandardData*(db: DbConn) =
  ## Insert basic data
  standardDataSettings(db)
  standardDataFrontpage(db)
  standardDataAbout(db)
  
  