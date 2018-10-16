NoMESS database setup
===

Written by Graeme Bell & Lars Opsahl, NIBIO.

This system provides data to the NoMess Web/App view via the 'lappmo' system (see other repo).

This repo is presented as a code skeleton/template that can be re-used for similar projects.

If you are interested in extending NO-MESS itself, feel welcome to contact us.

IMPORTANT NOTE
===

Throughout this repo you will see 'REMOVED' sections. This is where data,code, comments or identifiers had to be removed in order to respect data privacy policies of NIBIO. Because of this, the code cannot be compiled immediately from this repository.

However, 99% of the code is here and the overall design can be used as a template/framework for further work or related types of work.


INSTALLATION
------

Steps to install the database and needed datasets (REMOVED).

Summary: clone the GIS database containing geometry to a local database. Important for performance during 
rebuilds.

Next, install the nomess software to the local filesystem. (REMOVED)

Summary: e.g. git clone nomess_database_public.git

Next, install any special or additional local GIS datasets to the database. (REMOVED).

Summary: git clone nomess_datasets.git, run installer

Now, setup is complete. 

To run the build of the nomess output layers, you use:

./build.sh

