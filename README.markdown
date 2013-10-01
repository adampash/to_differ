## To Differ

To Differ is a webapp that fetches the article text of a web page and then watches for changes to the text. Any time the text has changed, a new version of the article is saved. The user can then view the article's changes in a diff.

## To use:
```bash
git clone git@github.com:adampash/to_differ.github    # clones the repository
cd to_differ
bundle install                                        # installs gems
rake db:migrate                                       # sets up database
rails s                                               # runs server
guard                                                 # run automated tests
```