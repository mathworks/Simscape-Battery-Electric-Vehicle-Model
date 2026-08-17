# Using MATLAB Project

The files and folders of the BEV model are managed
by [MATLAB project][url-mlprj].

[url-mlprj]: https://www.mathworks.com/help/matlab/projects.html

## Project Path

With MATLAB Project,
you can manage MATLAB paths as [project paths][url-path]
relative to the project root folder,
which makes it easy to open or run scripts and models
anywhere in the project.

[url-path]: https://www.mathworks.com/help/matlab/matlab_prog/automate-startup-and-shutdown-tasks.html#mw_0fd5cb6e-635d-4670-a31f-73f7b20fd353

> **Tip**: Avoid using folder paths in your scripts and models.
> Using MATLAB project makes it possible to refer to models and scripts without folder paths,
> and it guarantees that models and scripts continue to work
> after moving them around within the project.

## Dependency management

### Project-assisted refactoring

MATLAB Project analyzes dependecy relationships among files
registered in the project and helps you work with them.
For example, when you change the name of a MATLAB function
in the Project window (not in the Current Folder window),
the project finds locations in other files
where the function is called
and [automatically updates them][url-auto-update].

[url-auto-update]: https://www.mathworks.com/help/matlab/matlab_prog/manage-project-files.html#:~:text=see%20Revert%20Changes.-,Automatic%20Updates%20When%20Renaming%2C%20Deleting%2C%20or%20Removing%20Files,-When%20you%20rename

### Finding dependencies

You can find which files depend on which other files.
In the Project window, right-click a file or folder in the project tree,
and select **Find Dependencies**.
It opens [Dependency Analyzer][url-dep-analyzer] showing the graph of file dependencies.

[url-dep-analyzer]: https://www.mathworks.com/help/matlab/ref/dependencyanalyzer-app.html

### Exporting subset of files from the project

From the Dependency Analyzer, you can export a subset of files and folders
to a separate project archive file or a zip file.
To do so, first find the dependencies as described above,
then select **Export** in the Analyzer toolstrip,
and select **Package As Archive**.

## Source Control Integration

MATLAB Project supports source control tools
such as [Git](https://git-scm.com/).
For details, see the documentation
about [Source Control Integration][url-src-ctl].

[url-src-ctl]: https://www.mathworks.com/help/matlab/source-control.html

### Adding local git to an existing project

#### Setup

If you downloaded a zip file of a project from File Exchange or GitHub,
it does not include git data.
You can add git to the project locally in your machine by following the steps below.
(Using a remote git service such as GitHub or GitLab needs further steps,
which you can do later.)
Make sure to complete all these steps before making any changes to the project.
For more information about using git in MATLAB,
see [Use Git in MATLAB][url-use-git].
For more information about using source control with projects,
see [Use Source Control with Projects][url-add-git].

1. Open the project in MATLAB.
2. In the Project toolstrip, click **Use Source Control**.
3. Click **Add Project to Source Control...**.
4. Click **Convert**.
   This creates the `.git` folder at the project root folder.
5. Click **Open Project**.
   Then **Git** column appears in the project window and the Current Folder window.
6. In the Project toolstrip, click **Commit**.
   This opens the **Enter a Commit** dialog.
7. Enter a comment such as "Initial commit." and click **Submit**.

At this point, the project must have the following states,
and you are good to go to make changes to the project.

- In the Project toolstrip, **Commit** button is disabled.
- All the files are not modified, which is indicated as **Modified (0)**
  right above the Project folder tree area.

#### Git branch management

Click **Branches** button in the Project toolstrip to see commit history
or create/switch/delete a branch.

Notes on cloud storage

_For folders managed by git, it is safe to avoid using a cloud service._
Switching a branch locally in git is fast, even if
it involves many changes in the folder structures and file contents.
On the other hand, cloud storage services tend to be slow
because it involves file transfer over the network.
Thus, switching git branches can cause synchronization issue for the cloud service,
which may corrupt the state of some folders.

#### Regular workflow

For your day-to-day development activities in a project with local git,
take the following steps after you edit your files and folders.

1. In the Project toolstrip, in the Project tab,
   click **Check Project** and make sure no issue is identified.
2. Click **Commit**.
   This opens the **Enter a Comment** dialog.
3. Enter a comment and click **Submit**.

### Using a remote git service

**Fetch**, **Push**, **Pull**, and **Remote** buttons in the Project tab
work with a remote git service,
and you need an account for the remote service site
(such as a GitHub account for github.com).
For more information about creating an account for a git service,
visit the respective git service website.

As an example, if you have an account at github.com,
create an empty repository at GitHub,
and set the repository URL from **Remote** button in the Project tab.
When you want to upload the changes in your local repository
to the remote repository,
first click **Check Project** and make sure the project is in good shape.
Second, click **Commit** and make sure you have **Modified (0)**.
And third, click **Push** to upload.
Push can trigger authentication to access GitHub.
For a streamlined user experience, you might want to
use [GitHub Desktop](https://github.com/apps/desktop) to push.

[url-add-git]: https://www.mathworks.com/help/matlab/matlab_prog/use-source-control-with-projects.html
[url-use-git]: https://www.mathworks.com/help/matlab/matlab_prog/use-git-in-matlab.html

<hr>

Go to [README](../README.md) at the project top folder.

*Copyright 2022-2024 The MathWorks, Inc.*
