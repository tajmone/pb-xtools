PBHGENX
=======

    PBHGENX v5.50a (= PBHGEN v5.43)

«PureBasic Header Generator X» is a fork of [00laboratories’s PBHGEN](#about-pbhgen).

License: [Creative Commons Attribution 4.0 International](https://creativecommons.org/licenses/by/4.0/) (CC-BY 4.0)

------------------------------------------------------------------------

<!-- #toc -->
-   [Setup](#setup)
-   [Usage](#usage)
    -   [Example](#example)
-   [Running PBHGENX Along PBHGEN](#running-pbhgenx-along-pbhgen)
-   [About PBHGEN](#about-pbhgen)
-   [PBHGEN vs PBHGENX](#pbhgen-vs-pbhgenx)
-   [Why PBHGEN(X)?](#why-pbhgenx)
    -   [1. Undesirable ubiquitousness](#1-undesirable-ubiquitousness)
        -   [PBHGENX Solution](#pbhgenx-solution)
    -   [2. No support for `*.pbi`/`*.sbi` source files](#2-no-support-for-pbisbi-source-files)
        -   [PBHGENX Solution](#pbhgenx-solution-1)
            -   [Different naming scheme: `filename.pbheader.pbi`](#different-naming-scheme-filenamepbheaderpbi)
            -   [Headers on Demand](#headers-on-demand)
    -   [3. Git hostility](#3-git-hostility)
        -   [PBHGENX Solution](#pbhgenx-solution-2)
    -   [4. Inclusion in PB-XTools](#4-inclusion-in-pb-xtools)
-   [Version Numbering Scheme](#version-numbering-scheme)
-   [History](#history)

<!-- /toc -->

------------------------------------------------------------------------

Setup
=====

If you are using **PBHGENX** outside of [**PB-XTools**](https://github.com/tajmone/pb-xtools), you can manually set it up following the instructions below. If you are instead using the **PB-XTools** suite, follow the setup instructions provide therein.

(these instructions refer to Windows: with other OSs, binary file extension will vary)

Open `PBHGEN.pbp` project and compile both `Entry.pb` and `PBHGENX_Runner.pb` – it will yield two executables in `build/` folder: `PBHGENX.exe` and `PBHGENX_Runner.exe`.

Under “**Tools**” in the PureBasic IDE add a new tool called “`PBHGENX`”:

-   In “**Commandline**” field select your copy of `PBHGENX_Runner.exe`.
-   In “**Arguments**” field type `"%FILE"` (with quotes).
-   In “**Event to trigger the tool**” menu select “**Sourcecode Saved**”.

Usage
=====

**PBHGENX** will generate header files only if it finds a corresponding header file named `filename.pbheader.pbi` (where `filename` will be your actual sourcefile name). So if you want to start tracking a sourcefile with **PBHGENX**, just create an empty header file for it.

Then make sure you include your header-file in the Source by inserting an `IncludeFile` directive. Example:

``` {.purebasic}
IncludeFile "filename.pbheader.pbi" ;- PBHGEN
```

To use automatic header generation also in modules use:

``` {.purebasic}
Module MyModule
  IncludeFile "filename.pbheader.pbi"" ;- PBHGEN
EndModule
```

Example
-------

Your sourcefile is called `fibonacci.pb`.

1.  create in the same folder an empty new file called `fibonacci.pbheader.pbi`

2.  add at the beginning of `fibonacci.pb` source code the following line:

    ``` {.purebasic}
    IncludeFile "fibonacci.pbheader.pbi" ;- PBHGEN
    ```

From now on, whenever you save `fibonacci.pb`, the contents of `fibonacci.pbheader.pbi` will be automatically updated (regenerated).

Running PBHGENX Along PBHGEN
============================

You don’t have to remove **PBHGEN** in order to use **PBHGENX** – the two can coexist peacefully.

So, if you are wish to use the original **PBHGEN** version for some projects you have, you can. **PBHGENX** *will not* create header files in your **PBHGEN** controlled projects, but **PBHGEN** *will* create header files whenever you save a `*.pb` source.

But since the produced header files have different name conventions, they will not intefere with each other – what counts is the `IncludeFile` directive used in your sourcefile. Source files with a **PBHGEN** styled `IncludeFile` directive will still refer to PBHGENerated headers:

``` {.purebasic}
IncludeFile #PB_Compiler_File + "i" ;- PBHGEN
```

Also, remember that the actual contents of the final headers *are the same* in both **PBHGENX** and **PBHGEN**. Migrating from one tool to the other only requires changing the `IncludeFile` directive in the sourcefiles, and renaming the header-files.

About PBHGEN
============

-   [PBHGEN homepage](http://00laboratories.com/downloads/programming/purebasic-header-generator) (00laboratories)
-   [PBHGEN on Bitbucket](https://bitbucket.org/Henry00/pbhgen)
-   [PBHGEN thread on PB Forums](http://www.purebasic.fr/english/viewtopic.php?f=27&t=53414)

PBHGEN (PureBasic Header Generator) is a [CC-BY 4.0 licensed](https://bitbucket.org/Henry00/pbhgen/src/e5828286b22ca59ec6168e49c57a1c51718978b4/LICENSE?at=master&fileviewer=file-view-default) PB/SB-IDE tool by [Henry de Jongh](https://00laboratories.com/about/henry-de-jongh) (from 00laboratories). The author states:

> PureBasic is a great language but I was always annoyed about the fact I could never choose where I would locate my Procedures. If I wished to use a Procedure somewhere I would have to move it above of the Procedure that was going to call it.

> The Declare statement allows to tell the compiler specific Procedures are going to exist and to find them but writing them over and over and fixing arguments is not only a pain but makes your source look like a mess. That’s the reason I required an automatic header generator for PureBasic. I hope you too will enjoy the new freedom thanks to this little tool!

Every time you save a source file in the IDE, PBHGEN will automatically create a corresponding header file (with all the required `Declare` statements therein):

| LANGUAGE    | SOURCE FILE   | HEADER FILE    |
|-------------|---------------|----------------|
| PureBASIC   | `filename.pb` | `filename.pbi` |
| SpiderBASIC | `filename.sb` | `filename.sbi` |

This is a very handy tool that speeds up the developement workflow and spares a lot of headaches.

PBHGEN vs PBHGENX
=================

Please note that, apart from these differences in behavior, **PBHGENX** relies enterily on Henry de Jongh’s original **PBHGEN** code – they accomplish the same task and produce the same headers code, they just differ in the way the tie into the workflow, and in some minor conventions.

|                           | PBHGEN          | PBHGENX                         |
|---------------------------|-----------------|---------------------------------|
| header-file generation    | always          | on demand                       |
| header-file extension     | `.pbi` / `.sbi` | `.pbhgen.pbi` / `.pbhgen.sbi`   |
| supported source files    | `.pb` / `.sb`   | `.pb` / `.pbi` / `.sb` / `.sbi` |
| steps for usage in source | single-step     | one extra step                  |
| Git integration           | hostile         | friendly                        |

Why PBHGEN(X)?
==============

The main reasons why I decided to fork the original PBHGEN are:

1.  Undesirable ubiquitousness
2.  No support for `*.pbi`/`*.sbi` source files
3.  Git hostility
4.  Inclusion in [**PB-XTools**](https://github.com/tajmone/pb-xtools)

The first three reasons pertain to its default behavior, the last one regards a project I’m working on.

1. Undesirable ubiquitousness
-----------------------------

PBHGEN will *always* create a corresponding header file, even if you don’t need/want one – and you can’t prevent this, except by disabling PBHGEN from the **Tools** menu. This behaviour might lead to undesired results:

-   PBHGEN will overwrite any existing `filename.pbi`, which in some cases (especially with 3rd party projects) it amounts to destroying a manually created header- or include-file which happens to use the same naming convention.

PBHGEN is meant as a “*set it and forget it*” tool. But when PBHGEN’s naming convention crosses paths with another project, things could turn out nasty – and the “*forget it*” part of the motto backlash at you unheededly!

In addition to this:

-   Your projects’ folders get cluttered with unwanted/unused header files.

### PBHGENX Solution

PBHGENX solves this by adopting a different extension for the generated header files: `filename.pbheader.pbi`. This extension is specif enough to render extremely unlinkely any conflicts with pre-exisitng header- or include-files.

Files with this extension are also reckognizable at a glance as PBHGENX auto-generated header files – you won’t be headless about which files are automatically overwritten and which aren’t.

Furthermore, PBHGENX only creates a header-file when it finds a corresponding `filename.pbheader.pbi` – if a header-file doesn’t exist, PBHGENX makes an educated guess and assumes you don’t need his services. Which means … no more unwanted/unused header files to cleanup.

2. No support for `*.pbi`/`*.sbi` source files
----------------------------------------------

PBHGEN doesn’t create header files for sources with extension `*.pbi`/`*.sbi`. The use of `*.pbi` extension in PureBASIC doesn’t fall under stricts rules, it’s just a way to distinguish non-standalone files intended for inclusion by other project files. Libraries, modules, and all sort of shared code are good candidates for this kind of extension; and quite often develepoment of such files would benefit from PBHGEN functionality to solve the Procedures Declaration nightmare.

Due to its header-files naming convention, PBHGEN can’t handle these cases — a `MyLibrary.pbi` source can’t create a `MyLibrary.pbi` header file! So PBHGEN ignores source files with `*.pbi`/`*.sbi` extension.

### PBHGENX Solution

#### Different naming scheme: `filename.pbheader.pbi`

PBHGENX’s header-file naming scheme (`filename.pbheader.pbi`) accepts `*.pbi`/`*.sbi` source files:

| LANGUAGE    | SOURCE FILE    | HEADER FILE             |
|-------------|----------------|-------------------------|
| PureBASIC   | `filename.pb`  | `filename.pbheader.pbi` |
| PureBASIC   | `filename.pbi` | `filename.pbheader.pbi` |
| SpiderBASIC | `filename.sb`  | `filename.pbheader.sbi` |
| SpiderBASIC | `filename.sbi` | `filename.pbheader.sbi` |

The only thing which you can’t have is two source files with the same name but different extension: if you create `SomeFile.pb` and `SomeFile.pbi` in the same folder, PBHGENX will keep creating a common `SomeFile.pbhgen.pbi` header file for both of them – overwriting each other at each file save.

This case shouldn’t really be a problem, but in future updates of PBHGENX I shall add a further check system: if two similar-named files exist, PBHGENX should create a header file for only one of them (which one, I still have to decide though).

#### Headers on Demand

Instead of assuming that you always want/need the creation of a header file, whenever you save your sourcefile PBHGENX will check if a corresponding `filename.pbheader.pbi` (or `filename.pbheader.sbi` for a SB source) exists: if it does, it will create the header-file.

This additional check-phase shifts from PBHGEN’s default ubiquitousness to an «on-demand» approach to header-files generation.

All a user needs to do to place a given source file under PBHGENX’s control is to create an empty file with the same name plus `.pbheader.pbi` extension.

3. Git hostility
----------------

The following aspects of PBHGEN add complexity in Git controlled projects:

1.  Creation of unneeded header files
2.  Inclusion of PBHGEN version number and header creation timestamp in the generated header files.

Point (1) can be worked around by adding to a `.gitingore` file all the unwanted header files automatically generated by PBHGEN.

Point (2) is more problematic because it induces Git to consider (otherwise identical) files as modified because of timestamp changes. This is how a typical PBHGENerated header starts:

``` nohighlight
;- PBHGEN V5.43 [http://00laboratories.com/]
;- 'Entry.pb' header, generated at 11:38:31 29.11.2016.
```

When I cloned PBHGEN from its official [Bitbucket repo](https://bitbucket.org/Henry00/pbhgen) and started experimenting with its code, the first thing I noticed was that each time I saved one of its source files, Git status would report its corresponding header file as “modified.”

This forces you to chose between blindly commiting these irrelevant changes, or having to sift the diff before each commit, to check whether it’s only a timestamp change or if the actual header declarations have changed.

Blindly commiting timestamp changes results in more deltas — which eventually mounts up on data storage bloating — and a cluttered repo history. Blindly ignoring modified header files could mean overlooking an actual change in declarations contents.

Of course, the problem grows exponentially as more users commit to the same project – and even if you manage to workaround commiting timestamp changes yourself, collaborators might still push and make pull requests containing such trivial file changes.

This problem also affects branch switching and other checkout or merge operations because it makes it difficoult to keep a clean state at any time – stashing, discarding, reverting … what seemed a small issue at first, soon starts to popup at all times and in all places, transforming simple file-save operations into a complex and entangled web of implications for your repo’s status.

### PBHGENX Solution

Since all the Git-related pains boiled down to a single feature — ie: having PBHGEN place its version number and a timestamp in the header’s comments – the question was: Is it important to have this info? After all, automatically generated headers are not intended for scrutiny.

I’ve decided that having PBHGEN’s version and a header-creation timestamp are not worth the collaterals they cause in Git, so I removed them and opted for different comments in PBHGENX header-files:

``` nohighlight
; =============================================================================
;- "Entry.pb" header file.
; Autogenerated by PBHGENX -> https://github.com/tajmone/pb-xtools
; -----------------------------------------------------------------------------
; WARNING: This file is automatically recreated with each save of its main file.
; Any manual changes to this file will be permanently lost!
; =============================================================================
```

Even if the header file is recreated each time its corrispective source file is saved, as long as its contents remain the same Git will consider it unchanged because it will have the same SHA1 hash. And if it did change, it is because the code changed and therefore needs to be commited.

PBHGENX version number was also omitted, for the same reasons – an update of PBHGENX, or collaborators using different versions of PBHGENX, would result in trivial file changes.

I’ve also added a clear warning about the auto-generated/overwritable nature of the header file (for the benefit of those who might not know about PBHGEN).

4. Inclusion in PB-XTools
-------------------------

Another determining factor in my decision to fork from the original PBHGEN project was that I’ve been working for a while on some other PB-IDE tools, and would like to release them as a single package.

Some of these tools will also be invoked by the “Sourcecode saved” **Tools**-trigger, so I thought of creating a single binary file to handle all triger calls in a centralized manner.

This is the reason why I’ve placed outside of PBHGENX’s main source the code that checks if a header-file exists: it’s to be found in `PBHGENX_Runner.pb`, a bolierplate code meant mainly for isolated testing purposes — and in **PB-XTools** will be replaced by some code common to all tools, a sort of centralized tools-triggering manager.

This simplifies managing external tools, by reducing the number of applications invoked by triggers, and offers more granular control over their behavior and order of execution – and of course, for the **PB-XTools** I have some added functionalities in mind – like a CPanel, and a dialog to automatically enable PBHGENX on porject files (inject the `IncludeFile` directive in the source file, and create the required header file to put PBHGENX into motion); and more.

Version Numbering Scheme
========================

PBHGENX is versioned according the PureBASIC release at the time of its compiling, followed by a letter indicating revision updates within the same PB release range. PBHGENX is followed by the the last version of PBHGEN source merged-in (inside parentheses and preceded by an `=` sign).

Example:

    PBHGENX v5.50a (= PBHGEN v5.43)

Means: PBHGENX was last compiled using PureBASIC version 5.50, and it is the first (“**a**”) revision among the PB 5.50 releases, and its using as a base code PBHGEN v5.42.

This arbitrary scheme is simple enough to allow understanding at a glance which version of PBHGENX is the latest, and it also gives an estimate of its compatiblity with the latest current PureBASIC version. The `(= PBHGEN vX.XX)` part is useful for checking if PBHGENX is lagging behind its upstream source (PBHGEN).

PBHGENX was created as part of the PB-XTools project, and proper versioning will be dealt with in the context of that project.

History
=======

-   `2016-11-30` – First release: PBHGENX v5.50a (= PBHGEN v5.43)

