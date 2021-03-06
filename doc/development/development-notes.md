known bugs
==============================

upgrade to latest thinking sphinx

deleting a page tag causes the discussions to get loaded for the ajax request.
this should not be the case.

destroying groups
  needs a lot of work
  what to do with orphaned pages?
  all the pages that have cached the owner_name should get cleared out.
    (or maybe not, instead link to 'anonymous'?)
  what about everywhere else? create GroupGhost with the same id but with no content?

when notices are rendered as pages, they still fade.

i18n blows up if the session language is set to swedish.

alert messages don't stack for modalbox

confirmation before destroy contact

page search:
  should be 'watching' instead of 'watched'
  once active, needs to indicate i clicked on 'my pages -> own'.
  need ajaxy history

the split panel is not something that we should keep, unless it can
  be made to work when the screen gets small.

wiki:
  need history

pages:
  need 'show print' option.

remote processing
==============================

what happens when we do remote_job.destroy?
  what happens to the background thread on the cg-processor doing the work?
  what happens to the files it spits out?

assets & documents
=======================

integrate documentcloud.org for displaying pdfs and docs.

things to work on
============================

Misc Quick
* grouphome: summary links break left column formatting
* remove details from page feeds for now

Misc
* banner width problems: https://labs.riseup.net/code/issues/4360
* Speed Problems Across App
* Search

Pages
* gallery > show formatting problems
* tasklist text doesnt line up with checkboxes
* survey page formatting and error message: https://labs.riseup.net/code/issues/4362
* wiki - versioning is a mess, full page edit form is too narrow, trying to open multiple sections for editing isnt working (see issue)

groups
* destroying group
* request to expell

directory
* group
* person

account
* reset lost password
* cracklib

sphinx
* new sphinx
* better fields for sphinx
* get rid of page_terms

pages
* history
* text page
* poll page
* asset page
* folder page

plugins
* write new plugin system

themes
* add more themes

tests
* minitest
* write more tests

i18n
* identify used and unused keys
* a system to translate
* better en.yml organization

misc
* replace backgroundrb - kclair
* clean up css class usage for tabs - bootstrap and cg use different ones now - azul

new features
* issues
* notices

rails 3
============================

to support dirty, include this:
http://api.rubyonrails.org/classes/ActiveModel/Dirty.html

internet explorer
============================

http://code.google.com/p/ie7-js/
make ie behave like a modern browser.

page changes
============================

assets for pages are not modular and should be defined in extensions/pages, instead of public/images.

schema changes
============================

todo:
  remove pages.message_count
  add pages.edits_count
  add page_terms.updated_by_ids
  add page_terms.watched_by_ids
  add page_terms.owner_id

it is really random what columns are indexed by page_terms and pages:

 pages:
   type, flow, created_at, updated_at, owner_name, name.

 page_terms:
   title, created_by_login, updated_by_login, owner_name, page_created_at,
   page_updated_at, created_by_id, updated_by_id, views_count, stars_count.

this should be cleaned up. i think a lot of these are unused, yet others may be needed. why do we have
created_by_login as a sortable index, but not contributors_count? do we really use the owner_name
indexes?

mailing list integration
=============================

two main problems:

  (1) queuing and processing incoming messages
  (2) queuing outgoing messages

for incoming:

  Mailman (no, not that mailman, a ruby mailman)
  http://github.com/titanous/mailman
  http://rubydoc.info/github/titanous/mailman/master/file/USER_GUIDE.md
  point it at a maildir, and build easy routes based on conditions in the messages.

for outgoing:

  ARMailer: http://seattlerb.rubyforge.org/ar_mailer/
  ActionMailer::Queue: http://github.com/beam/action-mailer-queue/

  I think both do two phase delivery: when you send, it queues to db, then a bg process
  reads the queue and delivers the messages.

for background processing:

  starling for bg email processing: http://railscasts.com/episodes/128-starling-and-workling
  bj: http://codeforpeople.rubyforge.org/svn/bj/trunk/README

address formats:

  cgdev@we.riseup.net
  - new subject: create new discussion page in cgdev
  - old subject: append comment to existing page in cgdev

  cgdev+ui@we.riseup.net (for committees)

  cgdev+ui+70984@we.riseup.net
  - encode the page id in the return address. this way, we won't have problems parsing the subject. will this conflict with committee names? can committee names be just numbers?

requests
============================================

the queries that we seem to do the most for requests are slow with how the schema for requests works.

in particular, i think we might be doing a lot of queries for all the requests that relate to a given person or group, either as a creator or a recipient. the problem is that this requires a slow OR conditions, or a UNION.

it would make more sense to give requests just a column for user and a column for people, then use some other method to determine who the creator and recipient are...


jabber integration
==========================

openfire has a REST integration module:
https://we.riseup.net/cgdev/openfire-integration

here is a way to send jabber IMs via rails:
https://github.com/cheald/jabberish

VOIP
===========================

a library to control murmer (mumble server) via ruby through ice:
https://github.com/cheald/murmur-manager

calendars
======================================

https://github.com/vinsol/fullcalendar_rails
https://github.com/elevation/event_calendar

http://tenderapp.com/tour/ (not sure what this is)

documentation
=================================

http://yardoc.org/


delayed database updates
================================

Most of the database updates that are slow for the user are things that don't
need to be done right away. For example, you change one tiny thing about a page
and it kicks of tons and tons of database updates, but these are just for searching
and could be delayed.

A huge speed improvement can be acheived by running these, and the sphinx indexing,
in background tasks.

background tasks
=====================

There is an incredible number of background processing options in rails.

What we want:

* ability to run maint tasks at regular intervals
* ability to queue long running background tasks that we can guarentee will get run (some persistent data storage)

api library
  https://github.com/wireframe/backgrounded -- provides a common api to delayed_job and resque, etc.

job/message queues
  https://github.com/collectiveidea/delayed_job -- most popular
    checks the database every five seconds for pending jobs
    https://www.ruby-toolbox.com/projects/delayed_job
    https://github.com/stympy/delayed_job -- a fork of delayed_job but with autoscaling.

  http://kr.github.com/beanstalkd/
  http://ap4r.rubyforge.org/wiki/wiki.pl?HomePage
  https://github.com/starling/starling

networked job queues:
  https://github.com/ivanvanderbyl/cloudist (rabbitmq)
  https://github.com/defunkt/resque (reddit)
  http://mperham.github.com/sidekiq/ (faster than resque, api compatible)

backgrounding long running code:
  https://github.com/tra/spawn
  https://github.com/Try2Code/jobQueue
  http://code.google.com/p/asynchronous/
  https://github.com/imedo/background_lite

cron-like scheduling
  http://github.com/javan/whenever -- ruby sugar around crontab
  https://github.com/adamwiggins/clockwork-rails-dj
  rufus-scheduler

event driven programming
  https://github.com/eventmachine/eventmachine (has a spawn ability too)

On linux, fixes thread timeout problems:
  http://systemtimer.rubyforge.org/

Unsorted links:
  http://code.google.com/p/activemessaging/wiki/ActiveMessaging
  http://codeforpeople.rubyforge.org/svn/bj/trunk/README
  https://github.com/barttenbrinke/worker_queue/
  https://github.com/starling/active_queue




Profile
=================================

Type A List

* summary about myself - hmmm... i would like to have different summaries to display to my friends, my peers and people of that group. then this is not type A.
* place
* avatar
* display name
* login
* online status
* you friend/ groups / networks

Type B List

Only visible on the profile page of a user, but there can be Multiple or non at all.

* pictures, may be multiple.
* contact info
** email
** phone
** instant message
** snail mail address
* pages
* status updates
* homepage
* social change interests and the like...

Javascript Applications
=============================

http://sheetster.com/ -- GPL java server for web spreadsheets, REST API.


Rails Applications
===============================

http://noosfero.org


Uploading
=========================

This library has a method of remembering the uploaded file between views of the form:
https://github.com/cheald/carrierwave

Rails CMSs
=================

list: https://gist.github.com/244863

full cms:
  http://refinerycms.com
  http://locomotivecms.com

light weight:
  http://nestacms.com/
  http://www.caseincms.com/
  https://github.com/desaperados/seed
  https://github.com/comfy/comfortable-mexican-sofa

static:
  comparison - http://mindspill.net/computing/cross-platform-notes/review-of-ruby-static-site-generators/
  https://github.com/mojombo/jekyll
  http://nanoc.stoneship.org/


Multi-user field editing
==============================

https://github.com/josephg/ShareJS

questions
===================

* Why rails v3.0 and not v3.x?

  We still have a lot of rails 2.3 code in crabgrass.
  Rails 3.0 deprecated this but still supports it. We will have
  to get rid of it all for rails 3.1 and 3.2 and have focussed
  on other things so far. However in particular for security reasons
  moving on to rails 3.2 is very much desired.
  This would be a great place to contribute.
* Why github for rails in Gemfile? (huge extra overhead to pull in entire rails repo, versus the gem)

  The github repo has seen a few security fixes since the release of 3.0.20.
  Rails 3.0 is not maintained anymore - so there will be no new release.
  But if people care enough to fix things they are merged in the 3-0-stable branch.
  see https://github.com/rails/rails/commits/3-0-stable


WIKIS
===========================

clicking 'show' leaves :document locked.

w.reload.section_locks.all_sections
w.section_locks.locks
w.break_locks!
w.lock!(section, user)

w = Wiki.last
u1 = User.find 4
u2 = User.find 5
w.section_locks.locks

test 1
  w.lock!(:document, u1)
  w.lock!(:document, u1)

test 2
  w.lock!(:document, u1)
  w.lock!(:document, u2)

sections
----------------

- #- if @wiki.section_open_for?(@section || :document, current_user)

todo
-----

* new page creation tab is 'show' should be 'edit'


scenarios
---------------

[x] user tries to edit page that is locked
    w.lock!(:document, u2)

[x] user force unlocks page and saves
    w.lock!(:document, u2)

[ ] user tries to saves, but someone as broken lock
    w.unlock!(:document, u2, :break => true)
    w.lock!(:document, u2)

[ ] user visits page that is empty but locked

[ ] user saves but new version already exists

[ ] user clicks away from edit field without hiting save or cancel

[x] force unlocking a subsection while remove locks on that tree path.

[x] edit section
[x] edit section that is locked

[ ] prevent multiple section edits at once (for now)
