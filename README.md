## Step one: build your image
- docker build . -t your_company:1.0.0

## Console Simulator

Simple console to handle files and folders by entering commands by keyboard, similar to
Bash, for example.
All resources must be kept in memory and not persisted to disk.
User system with several roles:

Super users (super): can read and create files. They are also the only ones that can create and
Delete users.
Normal users (regular): they can read and create files and can edit their own password.
Read-only users (read_only): Only existing files can be read. They can't edit their
own password.

By default, files, folders and users are kept only in memory, so they should
be generated again at the beginning of the application and are removed on exit. To persist the information, a parameter with the file name must be sent.

Look at the [Wiki](https://gitlab.com/angelszymczak/console/-/wikis/00---Home) for more details of the operation.
