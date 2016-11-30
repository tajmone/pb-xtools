PBHGENX
=======

«PureBasic Header Generator X» is a fork of 00laboratories’s PBHGEN.

------------------------------------------------------------------------

<!-- #toc -->
-   [About PBHGEN](#about-pbhgen)
-   [Why PBHGEN(X)?](#why-pbhgenx)
    -   [1. Undesirable ubiquitousness](#1-undesirable-ubiquitousness)
        -   [PBHGENX Solution](#pbhgenx-solution)
    -   [2. No support for `*.pbi`/`*.sbi` source files](#2-no-support-for-pbisbi-source-files)
        -   [PBHGENX Solution](#pbhgenx-solution-1)
            -   [Different naming scheme: `filename.pbheader.pbi`](#different-naming-scheme-filenamepbheaderpbi)
            -   [Headers on Demand](#headers-on-demand)
    -   [3. Git hostility](#3--git-hostility)
        -   [PBHGENX Solution](#pbhgenx-solution-2)

<!-- /toc -->

------------------------------------------------------------------------

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

Why PBHGEN(X)?
==============

The main reasons why I decided to fork the original PBHGEN are:

1.  Undesirable ubiquitousness
2.  No support for `*.pbi`/`*.sbi` source files
3.  Git hostility
4.  Inclusion in [**PB-XTools**](https://github.com/tajmone/pb-xtools)

The first two have to do with its default behavior, the last one with a personal project I’m working on.

1. Undesirable ubiquitousness
-----------------------------

PBHGEN will *always* create a corresponding header file, even if you don’t need one. This behaviour might lead to undesired result:

-   PBHGEN will overwrite any existing `filename.pbi`, which in some cases (especially with 3rd party projects) it amounts to destroying a manually created header- or include-file which happens to use the same naming convention.

### PBHGENX Solution

PBHGENX solves this by adopting a different extension for the generated header files: `filename.pbheader.pbi`. This extension is a specif-enough to render extremely unlinkely any conflicts with pre-exisitng header- or include-files.

Also, files with this extension are reckognizable at a glance as PBHGENX auto-generated header files.

PBHGENX only creates a header-file when it finds a corresponding `filename.pbheader.pbi` – if the header-file doesn’t exist, it assumes you don’t need his services.

2. No support for `*.pbi`/`*.sbi` source files
----------------------------------------------

PBHGEN doesn’t create header files for source files with extension `*.pbi`/`*.sbi`. The use of `*.pbi` extension in PureBASIC doesn’t fall under stricts rules, it’s just a way to distinguish non-standalone files intended for inclusion by other project files.

Libraries, modules, and all sort of shared code are good candidates for this kind of extension; and quite often develepoment of such files would benefit from PBHGEN functionality to solve the Procedures Declaration nightmare.

Due to its header-files naming convention, PBHGEN can’t handle these cases — a `MyLibrary.pbi` source can’t create a `MyLibrary.pbi` header file! So PBHGEN ignored source files with `*.pbi`/`*.sbi` extension.

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

This case shouldn’t really be a problem, but in future updates of PBHGENX I shall add a futher check: if two such files exist, only create a header file for one of them (which one, I still have to decide it yet).

#### Headers on Demand

Instead of assuming that you always want/need a header file created, whenever you save your soruce file PBHGENX will check if a corresponding `filename.pbheader.pbi` (or `filename.pbheader.sbi` for a SB source) exists: if it does, it will create the header-file.

This additional check-phase shifts from PBHGEN’s default ubiquitousness to an «on-demand» approach to header-files generation.

All the user needs to do to put a given source file under PBHGENX’s control is to create an empty file with the same name plus `.pbheader.pbi` extension.

3. Git hostility
----------------

The following aspects of PBHGEN add complexity in Git controlled projects:

1.  Creation of unneeded (spurious) header files
2.  Inclusion of PBHGEN version number and header creation date in the final header files.

Point (1) can be worked around by adding to a `.gitingore` file all the spurious header files automatically generated by PBHGEN.

Point (2) is more problematic because it induces Git to consider (otherwise identical) files as modified because of date changes. This is how a typical PBHGENerated header starts:

``` nohighlight
;- PBHGEN V5.43 [http://00laboratories.com/]
;- 'Entry.pb' header, generated at 11:38:31 29.11.2016.
```

When I cloned PBHGEN from its official [Bitbucket repo](https://bitbucket.org/Henry00/pbhgen) and started experimenting on it code, the first thing I noticed was that each time I saved one of its source files, Git status would reported its corresponding header file as being modified.

This forces you to chose between blindly commiting these irrelevant changes, or having to go through the changes diff before each commit, to check whether it’s only a timestamp change or if the actual declations have changed.

Blindly commiting timestamp changes results in more deltas (and more disk usage) and a cluttered repo history. Blindly ignoring modified header files could mean overlooking an actual change in declarations contents.

Of course, the problem grows exponentially as more users commit to the same project – and even if you manage to commit timestamp-only changes, you might face pushes and pull requests containing such trivial file changes.

This problem also affects branch switching and other checkout or merge operations because it makes it difficoult to keep a clean state at any time.

### PBHGENX Solution

I’ve decided that having PBHGEN’s version and a header-creation timestamp are not worth the collaterals they cause in Git, so I removed them and opted for a different header-files comments heading in PBHGENX:

``` nohighlight
; =============================================================================
;- "Entry.pb" header file.
; Autogenerated by PBHGENX -> https://github.com/tajmone/pb-xtools
; -----------------------------------------------------------------------------
; WARNING: This file is automatically recreated with each save of its main file.
; Any manual changes to this file will be permanently lost!
; =============================================================================
```

Even if the header file is recreated at each save operation of its corrispective source file, as long as its contents remain the same Git will consider it unchanged because it will have the same SHA1 hash.

I’ve also added a clear warning about the auto-generated/overwritable nature of the header file (for the benefit of those who might not know about PBHGEN).


## 4.  Inclusion in PB-XTools

Another determining factor in my decision to fork from the original PBHGEN project was that I've been working for a while on some other PB-IDE tools, and would like to release them as a single package.

Some of these tools will also be invoked by the "Sourcecode saved" Tools-trigger, so I thought of creating a centralized binary file to handle all triger calls.

This is the reason why I placed outside of PBHGENX's main source the code that checks if a  header exists. I've placed it instead in `PBHGENX_Runner.pb`, a dummy code meant for testing purposes, which in __PB-XTools__ will become part of the general code invoked at sourcecode save time.

This simplifies managing external tools, by reducing the number of applications invoked by triggers, and offers more granular control on their behavior and order of execution -- and of course, for the  __PB-XTools__ I have some added functionalities in mind, like a CPanel, and a dialog to automatically enable PBHGENX on source files (create the `IncludeFile` directive in the source file, and the required header file to put PBHGENX into motion)