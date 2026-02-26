1) Remove as much windows software default as possible
2) https://mirrors.ibiblio.org/gnu/emacs/windows/emacs-30/ -> install to c:/emacs
3) https://github.com/miketu/.emacs/blob/main/.emacs -> copy and paste over ~/.emacs
	M-x package-list
		Helm
		Howm
		calfw-howm
		calfw-ical
		calfw-org
	[Update F2 command with google photos directory in .emacs]
	Choose leuven-dark theme 

4) Install grep for windows https://gnuwin32.sourceforge.net/packages/grep.htm
	- Alter PATH variable in windows to be able to install this

3) Download dropbox https://www.dropbox.com/desktop -> save to c:/Dropbox/
4) Choose your microsoft windows license  for office
5) Restore old right click menu (source: https://learn.microsoft.com/en-us/answers/questions/2287432/(article)-restore-old-right-click-context-menu-in)
	reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve

7)  Download R https://cran.r-project.org/mirrors.html
	Download Rtools
	Download Rstudio (argh... this is so big!) very lame..
	Tools -> Options -> Disable all those temp files
	install.packages("tidyverse")
	
8) Python
	install using installer form python.org
	py -m pip install --user pipx
	py -m pipx ensurepath

9) Euphoria Language
	https://github.com/OpenEuphoria/euphoria/releases
	https://jmeubank.github.io/tdm-gcc/
 	https://github.com/OpenEuphoria/editors/tree/master/emacs



