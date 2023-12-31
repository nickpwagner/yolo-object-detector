%
% ISS Poster Class 'issposter.cls' v 1.0, 2013/04/12
%
% Author: Florian Liebgott
%
% Derived from `sciposter.cls' v 1.18, 2006/08/18 (Authors Michael H.F. Wilkinson and Alle Meije Wink)
%
% v 1.0 2013/04/12
%	- Hardcoded ISS logo, university logo and background
%	- Changed itemize labels to match the presentation template
%	- Changed / preset some lengths and colors
%	- Added new section style "fancy" (uses tikz)
% 
\ProvidesClass{issposter}[2013/04/12 v1.0 ISS Poster class]
\NeedsTeXFormat{LaTeX2e}[1995/06/01]
\LoadClass{article}
\RequirePackage{ifthen}
\RequirePackage{lettrine}

\newcommand{\papertype}{a0}
\newcommand{\requestpointsize}{25pt}
\newcommand{\fontpointsize}{25pt}
\newlength{\papermargin}


\newcommand{\setpspagesize}{% for default size A0
  \ifthenelse{\equal{\orientation}{portrait}}{
    \special{papersize=83.96cm,118.82cm}
    }{\special{papersize=118.82cm,83.96cm}
    }
  }

\newcommand{\sectionsize}{\normalsize}
\newcommand{\subsectionsize}{\large}

\newboolean{pointsizeset}

\newboolean{largeletters}

\newboolean{userightlogo}
\newboolean{useleftlogo}

\newcommand{\orientation}{portrait}
\newcommand{\printstyle}{final}
\newcommand{\secstyle}{fancy}

\DeclareOption{largefonts}{
\setboolean{largeletters}{true}
}

\DeclareOption{boxedsections}{
\renewcommand{\secstyle}{boxed}
}
\DeclareOption{ruledsections}{
\renewcommand{\secstyle}{ruled}
\renewcommand{\sectionsize}{\Large}
\renewcommand{\subsectionsize}{\large}
}
\DeclareOption{plainsections}{
\renewcommand{\secstyle}{plain}
\renewcommand{\sectionsize}{\Large}
\renewcommand{\subsectionsize}{\large}
}
\DeclareOption{plainboxedsections}{
\renewcommand{\secstyle}{plainboxed}
}

% BUILT IN ISO paper size support
\DeclareOption{a0}{% ISO A0 paper
  \renewcommand{\papertype}{a0}
  \renewcommand{\fontpointsize}{25pt}
  \setlength{\paperwidth}{83.96cm}
  \setlength{\paperheight}{118.82cm}
  \renewcommand{\setpspagesize}{% not really necessary
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=83.96cm,118.82cm}
      }{\special{papersize=118.82cm,83.96cm}
      }
    }
  }
\DeclareOption{a1}{% ISO A1 paper
  \renewcommand{\papertype}{a1}
  \renewcommand{\fontpointsize}{20pt}
  \setlength{\paperwidth}{59.4cm}
  \setlength{\paperheight}{83.96cm}
  \renewcommand{\setpspagesize}{
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=59.4cm,83.96cm}
      }{\special{papersize=83.96cm,59.4cm}
      }
    }
  }
\DeclareOption{a2}{% ISO A2 paper
  \renewcommand{\papertype}{a2}
  \renewcommand{\fontpointsize}{17pt}
  \setlength{\paperwidth}{41.98cm}
  \setlength{\paperheight}{59.4cm}
  \renewcommand{\setpspagesize}{
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=41.98cm,59.4cm}
      }{\special{papersize=59.4cm,41.98cm}
      }
    }
  }
\DeclareOption{a3}{% ISO A3 
  \renewcommand{\papertype}{a3}
  \renewcommand{\fontpointsize}{14pt}
  \setlength{\paperwidth}{29.7cm}
  \setlength{\paperheight}{41.98cm}
  \renewcommand{\setpspagesize}{
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=29.7cm,41.98cm}
      }{\special{papersize=41.98cm,29.7cm}
      }
    }
  }
%%%%% New Options for US page sizes
\DeclareOption{ansiE}{% ANSI E, 34"x44"
  \renewcommand{\papertype}{ansiE}
  \renewcommand{\fontpointsize}{25pt}
  \setlength{\paperwidth}{86.36cm}
  \setlength{\paperheight}{111.76cm}
  \renewcommand{\setpspagesize}{
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=86.36cm,111.76cm}
      }{\special{papersize=111.76cm,86.36cm}
      }
    }
}
\DeclareOption{ansiD}{% ANSI D, 22"x34"
  \renewcommand{\papertype}{ansiD}
  \renewcommand{\fontpointsize}{20pt}
  \setlength{\paperwidth}{55.88cm}
  \setlength{\paperheight}{86.36cm}
  \renewcommand{\setpspagesize}{
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=55.88cm,86.36cm}
      }{\special{papersize=86.36cm,55.88cm}
      }
    }
}
\DeclareOption{ansiC}{% ANSI C, 17"x22"
  \renewcommand{\papertype}{ansiC}
  \renewcommand{\fontpointsize}{17pt}
  \setlength{\paperwidth}{43.18cm}
  \setlength{\paperheight}{55.88cm}
  \renewcommand{\setpspagesize}{
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=43.18cm,55.88cm}
      }{\special{papersize=55.88cm,43.18cm}
      }
    }
}
\DeclareOption{tabloid}{% Tabloid AKA ledger AKA ANSI B, 11"x17"
  \renewcommand{\papertype}{tabloid}
  \renewcommand{\fontpointsize}{14pt}
  \setlength{\paperwidth}{27.94cm}
  \setlength{\paperheight}{43.18cm}
  \renewcommand{\setpspagesize}{
    \ifthenelse{\equal{\orientation}{portrait}}{
      \special{papersize=27.94cm,43.18cm}
      }{\special{papersize=43.18cm,27.94cm}
      }
    }
}
\DeclareOption{landscape}{
\renewcommand{\orientation}{landscape}
}
\DeclareOption{portrait}{
\renewcommand{\orientation}{portrait}
}
\DeclareOption{draft}{
\renewcommand{\printstyle}{draft}
}
\DeclareOption{final}{
\renewcommand{\printstyle}{final}
}
\DeclareOption{36pt}{
\renewcommand{\requestpointsize}{36pt}
\setboolean{pointsizeset}{true}
}
\DeclareOption{30pt}{
\renewcommand{\requestpointsize}{30pt}
\setboolean{pointsizeset}{true}
}
\DeclareOption{25pt}{
\renewcommand{\requestpointsize}{25pt}
\setboolean{pointsizeset}{true}
}
\DeclareOption{20pt}{
\renewcommand{\requestpointsize}{20pt}
\setboolean{pointsizeset}{true}
}
\DeclareOption{17pt}{
\renewcommand{\requestpointsize}{17pt}
\setboolean{pointsizeset}{true}
}
\DeclareOption{14pt}{
\renewcommand{\requestpointsize}{14pt}
\setboolean{pointsizeset}{true}
}


\DeclareOption*{\InputIfFileExists{paper\CurrentOption.cfg}{}{\PackageWarning{poster}{Unknown option \CurrentOption}}}

\ExecuteOptions{portrait,a0,final}
\ProcessOptions\relax


\ifthenelse{\equal{\orientation}{landscape}}{
  \newlength{\tempsize}
  \setlength{\tempsize}{\paperwidth}
  \setlength{\paperwidth}{\paperheight}
  \setlength{\paperheight}{\tempsize}
  }{}


\ifthenelse{\boolean{pointsizeset}}{
  \renewcommand{\fontpointsize}{\requestpointsize}}{
  \ifthenelse{\boolean{largeletters}}{
    \ifthenelse{\equal{\fontpointsize}{20pt}}{
      \renewcommand{\fontpointsize}{25pt}
      }{ \ifthenelse{\equal{\fontpointsize}{17pt}}{
        \renewcommand{\fontpointsize}{20pt}
        }{ \ifthenelse{\equal{\fontpointsize}{14pt}}{
          \renewcommand{\fontpointsize}{17pt}
          }{\renewcommand{\fontpointsize}{30pt}
          }
        }
      }
    }{
    }
  }

\RequirePackage{graphics}
\RequirePackage{xcolor}
\RequirePackage{shadow}
\RequirePackage{a0size}
\RequirePackage{times}
\RequirePackage{boxedminipage}

\newlength{\titlewidth}
\newlength{\logowidth}


\newcommand{\setmargins}[1][]{
  \ifthenelse{\equal{#1}{}}{
    \ifthenelse{\equal{\orientation}{landscape}}{
      \setlength{\papermargin}{0.06\paperheight}
    }{
      \setlength{\papermargin}{0.06\paperwidth}
    }
  }{\setlength{\papermargin}{#1}}
  \setlength{\textwidth}{\paperwidth}
  \addtolength{\textwidth}{-2\papermargin}
  \setlength{\textheight}{\paperheight}
  \addtolength{\textheight}{-1.2\papermargin}
  
  \setlength{\voffset}{-2.54cm}
  \addtolength{\voffset}{0.4\papermargin}
  \setlength{\hoffset}{-2.54cm}
  \addtolength{\hoffset}{\papermargin}
  \setlength{\headheight}{0 cm}
  \setlength{\headsep}{0 cm}
  \setlength{\topmargin}{0 cm}
  \setlength{\oddsidemargin}{0 cm}
  \setlength{\footskip}{0.5\papermargin}

  \ifthenelse{\equal{\orientation}{landscape}}{
    \setlength{\logowidth}{0.12\textheight}
    }{
    \setlength{\logowidth}{0.12\textwidth}
    }
  \setlength{\titlewidth}{\textwidth}
  \addtolength{\titlewidth}{-2\logowidth}

}

\setmargins

\ifthenelse{\equal{\fontpointsize}{20pt}}{
  \renewcommand{\tiny}{\fontsize{10}{12}\selectfont}
  \renewcommand{\scriptsize}{\fontsize{12}{14}\selectfont}
  \renewcommand{\footnotesize}{\fontsize{14.4}{18}\selectfont}   
  \renewcommand{\small}{\fontsize{17.28}{22}\selectfont}
  \renewcommand{\normalsize}{\fontsize{20.74}{25}\selectfont}
  \renewcommand{\large}{\fontsize{24.88}{30}\selectfont}
  \renewcommand{\Large}{\fontsize{29.86}{37}\selectfont}
  \renewcommand{\LARGE}{\fontsize{35.83}{45}\selectfont}
  \renewcommand{\huge}{\fontsize{43}{54}\selectfont}
  \renewcommand{\Huge}{\fontsize{51.6}{64}\selectfont}
  \newcommand{\veryHuge}{\fontsize{61.92}{77}\selectfont}
  \newcommand{\VeryHuge}{\fontsize{74.3}{93}\selectfont}
  \newcommand{\VERYHuge}{\fontsize{89.16}{112}\selectfont}
  \newcommand{\titlesize}{\veryHuge}
  \newcommand{\authorsize}{\LARGE}
  \newcommand{\instsize}{\Large}

  \setlength\smallskipamount{5pt plus 2pt minus 2pt}
  \setlength\medskipamount{10pt plus 3pt minus 3pt}
  \setlength\bigskipamount{20pt plus 7pt minus 7pt}
  \setlength\abovecaptionskip{20pt}
  \setlength\belowcaptionskip{0pt}
  \setlength\abovedisplayskip{20pt plus 5pt minus 13 pt}
  \setlength\abovedisplayshortskip{0pt plus 5pt}
  \setlength\belowdisplayshortskip{10pt plus 6pt minus 5pt}
}{\ifthenelse{\equal{\fontpointsize}{17pt}}{
    \renewcommand{\tiny}{\fontsize{8.3}{10}\selectfont}
    \renewcommand{\scriptsize}{\fontsize{10}{12}\selectfont}
    \renewcommand{\footnotesize}{\fontsize{12}{14}\selectfont}
    \renewcommand{\small}{\fontsize{14.4}{18}\selectfont}   
    \renewcommand{\normalsize}{\fontsize{17.28}{22}\selectfont}
    \renewcommand{\large}{\fontsize{20.74}{25}\selectfont}
    \renewcommand{\Large}{\fontsize{24.88}{30}\selectfont}
    \renewcommand{\LARGE}{\fontsize{29.86}{37}\selectfont}
    \renewcommand{\huge}{\fontsize{35.83}{45}\selectfont}
    \renewcommand{\Huge}{\fontsize{43}{54}\selectfont}
    \newcommand{\veryHuge}{\fontsize{51.6}{64}\selectfont}
    \newcommand{\VeryHuge}{\fontsize{61.92}{77}\selectfont}
    \newcommand{\VERYHuge}{\fontsize{74.3}{93}\selectfont}
    \newcommand{\titlesize}{\Huge}
    \newcommand{\authorsize}{\LARGE}
    \newcommand{\instsize}{\Large}
    

    \setlength\smallskipamount{4.5pt plus 2pt minus 2pt}
    \setlength\medskipamount{9pt plus 3pt minus 3pt}
    \setlength\bigskipamount{18pt plus 6pt minus 6pt}
    \setlength\abovecaptionskip{17pt}
    \setlength\belowcaptionskip{0pt}
    \setlength\abovedisplayskip{17pt plus 4pt minus 11 pt}
    \setlength\abovedisplayshortskip{0pt plus 4pt}
    \setlength\belowdisplayshortskip{8pt plus 5pt minus 4pt}

  }{\ifthenelse{\equal{\fontpointsize}{14pt}}{
      \renewcommand{\tiny}{\fontsize{8.3}{10}\selectfont}
      \renewcommand{\scriptsize}{\fontsize{8.3}{10}\selectfont}
      \renewcommand{\footnotesize}{\fontsize{10}{12}\selectfont}
      \renewcommand{\small}{\fontsize{12}{14}\selectfont}
      \renewcommand{\normalsize}{\fontsize{14.4}{18}\selectfont}   
      \renewcommand{\large}{\fontsize{17.28}{22}\selectfont}
      \renewcommand{\Large}{\fontsize{20.74}{25}\selectfont}
      \renewcommand{\LARGE}{\fontsize{24.88}{30}\selectfont}
      \renewcommand{\huge}{\fontsize{29.86}{37}\selectfont}
      \renewcommand{\Huge}{\fontsize{35.83}{45}\selectfont}
      \newcommand{\veryHuge}{\fontsize{43}{54}\selectfont}
      \newcommand{\VeryHuge}{\fontsize{51.6}{64}\selectfont}
      \newcommand{\VERYHuge}{\fontsize{61.92}{77}\selectfont}
      \newcommand{\titlesize}{\huge}
      \newcommand{\authorsize}{\LARGE}
      \newcommand{\instsize}{\Large}

      \setlength\smallskipamount{3.5pt plus 1pt minus 1pt}
      \setlength\medskipamount{7.5pt plus 2pt minus 2pt}
      \setlength\bigskipamount{15pt plus 5pt minus 5pt}

      \setlength\abovecaptionskip{14pt}
      \setlength\belowcaptionskip{0pt}
      \setlength\abovedisplayskip{14pt plus 4pt minus 9 pt}
      \setlength\abovedisplayshortskip{0pt plus 4pt}
      \setlength\belowdisplayshortskip{7pt plus 5pt minus 4pt}

    }{\ifthenelse{\equal{\fontpointsize}{25pt}}{
        \renewcommand{\tiny}{\fontsize{12}{14}\selectfont}
        \renewcommand{\scriptsize}{\fontsize{14.4}{18}\selectfont}   
        \renewcommand{\footnotesize}{\fontsize{17.28}{22}\selectfont}
        \renewcommand{\small}{\fontsize{20.74}{25}\selectfont}
        \renewcommand{\normalsize}{\fontsize{24.88}{30}\selectfont}
        \renewcommand{\large}{\fontsize{29.86}{37}\selectfont}
        \renewcommand{\Large}{\fontsize{35.83}{45}\selectfont}
        \renewcommand{\LARGE}{\fontsize{43}{54}\selectfont}
        \renewcommand{\huge}{\fontsize{51.6}{64}\selectfont}
        \renewcommand{\Huge}{\fontsize{61.92}{77}\selectfont}
        \newcommand{\veryHuge}{\fontsize{74.3}{93}\selectfont}
        \newcommand{\VeryHuge}{\fontsize{89.16}{212}\selectfont}
        \newcommand{\VERYHuge}{\fontsize{107}{134}\selectfont}

        \newcommand{\titlesize}{\VeryHuge}
        \newcommand{\authorsize}{\LARGE}
        \newcommand{\instsize}{\Large}
       
        \setlength\smallskipamount{6pt plus 2pt minus 2pt}
        \setlength\medskipamount{12pt plus 4pt minus 4pt}
        \setlength\bigskipamount{24pt plus 8pt minus 8pt}
        \setlength\abovecaptionskip{25pt}
        \setlength\belowcaptionskip{0pt}
        \setlength\abovedisplayskip{25pt plus 6pt minus 15 pt}
        \setlength\abovedisplayshortskip{0pt plus 6pt}
        \setlength\belowdisplayshortskip{13pt plus 7pt minus 6pt}

      }{\ifthenelse{\equal{\fontpointsize}{30pt}}{
        \renewcommand{\tiny}{\fontsize{14.4}{18}\selectfont}   
        \renewcommand{\scriptsize}{\fontsize{17.28}{22}\selectfont}
        \renewcommand{\footnotesize}{\fontsize{20.74}{25}\selectfont}
        \renewcommand{\small}{\fontsize{24.88}{30}\selectfont}
        \renewcommand{\normalsize}{\fontsize{29.86}{37}\selectfont}
        \renewcommand{\large}{\fontsize{35.83}{45}\selectfont}
        \renewcommand{\Large}{\fontsize{43}{54}\selectfont}
        \renewcommand{\LARGE}{\fontsize{51.6}{64}\selectfont}
        \renewcommand{\huge}{\fontsize{61.92}{77}\selectfont}
        \renewcommand{\Huge}{\fontsize{74.3}{93}\selectfont}
        \newcommand{\veryHuge}{\fontsize{89.16}{112}\selectfont}
        \newcommand{\VeryHuge}{\fontsize{107}{134}\selectfont}
        \newcommand{\VERYHuge}{\fontsize{107}{134}\selectfont}

        \newcommand{\titlesize}{\veryHuge}
        \newcommand{\authorsize}{\Large}
        \newcommand{\instsize}{\large}
       
        \setlength\smallskipamount{8pt plus 2pt minus 2pt}
        \setlength\medskipamount{14pt plus 5pt minus 5pt}
        \setlength\bigskipamount{29pt plus 9pt minus 9pt}

        \setlength\abovecaptionskip{25pt}
        \setlength\belowcaptionskip{0pt}
        \setlength\abovedisplayskip{25pt plus 6pt minus 15 pt}
        \setlength\abovedisplayshortskip{0pt plus 6pt}
        \setlength\belowdisplayshortskip{13pt plus 7pt minus 6pt}

        }{
        \renewcommand{\tiny}{\fontsize{17.28}{22}\selectfont}
        \renewcommand{\scriptsize}{\fontsize{20.74}{25}\selectfont}
        \renewcommand{\footnotesize}{\fontsize{24.88}{30}\selectfont}
        \renewcommand{\small}{\fontsize{29.86}{37}\selectfont}
        \renewcommand{\normalsize}{\fontsize{35.83}{45}\selectfont}
        \renewcommand{\large}{\fontsize{43}{54}\selectfont}
        \renewcommand{\Large}{\fontsize{51.6}{64}\selectfont}
        \renewcommand{\LARGE}{\fontsize{61.92}{77}\selectfont}
        \renewcommand{\huge}{\fontsize{74.3}{93}\selectfont}
        \renewcommand{\Huge}{\fontsize{89.16}{112}\selectfont}
        \newcommand{\veryHuge}{\fontsize{107}{134}\selectfont}
        \newcommand{\VeryHuge}{\fontsize{107}{134}\selectfont}
        \newcommand{\VERYHuge}{\fontsize{107}{134}\selectfont}


        \newcommand{\titlesize}{\Huge}
        \newcommand{\authorsize}{\Large}
        \newcommand{\instsize}{\large}
       
        \setlength\smallskipamount{10pt plus 2pt minus 2pt}
        \setlength\medskipamount{18pt plus 6pt minus 6pt}
        \setlength\bigskipamount{36pt plus 11pt minus 11pt}

        \setlength\abovecaptionskip{25pt}
        \setlength\belowcaptionskip{0pt}
        \setlength\abovedisplayskip{25pt plus 6pt minus 15 pt}
        \setlength\abovedisplayshortskip{0pt plus 6pt}
        \setlength\belowdisplayshortskip{13pt plus 7pt minus 6pt}

        }
      }
    }
  }
}


\setlength\belowdisplayskip\abovedisplayskip
\normalsize
\newlength{\parstartskip}
\setlength\parstartskip{2\baselineskip}
\setboolean{useleftlogo}{true}
\setboolean{userightlogo}{true}

% Definition of Colors
% Background- and Text-color
\definecolor{mainCol}{rgb}{1,1,1}
\definecolor{BoxCol}{rgb}{1,1,1}        % white background
\definecolor{TextCol}{rgb}{0,0,0}
\definecolor{SectionCol}{rgb}{0,0,0.4}  % ISS blue
\definecolor{TitleCol}{rgb}{0,0,0.4}  % ISS blue


\AtBeginDocument{
  \typeout{-- Paper type set to \papertype.}

 \@ifundefined{pdfoutput}{% standard LaTeX
    \setpspagesize
    }{}
  \pagestyle{empty}
  \setfooter
  \pagecolor{mainCol} 
  }
%


\newlength{\figtopskip}
\newlength{\figbotskip}
\newlength{\secskip}
\newlength{\titleskip}
\ifthenelse{\equal{\orientation}{landscape}}{
  \setlength{\titleskip}{0.0142\textheight}
}{
  \setlength{\titleskip}{0.015\textwidth}
}
\setlength{\secskip}{\smallskipamount}
\setlength{\figtopskip}{\secskip}
\setlength{\figbotskip}{\secskip}
%%%% Defines default institute
\newcommand{\theinstitute}{%
}

\newcommand{\printemail}{}
%
\newcommand{\printleftlogo}{%
  \begin{center}
    \hspace*{0.6\textwidth}
  \end{center}
}
\newcommand{\printrightlogo}{%
  \begin{center}
    \hspace*{0.6\textwidth}
  \end{center}
}
%
%
%
\newboolean{footlogo@leftside}
%
\newcommand{\LEFTSIDEfootlogo}[1][true]{%
  \setboolean{footlogo@leftside}{#1}
  \setfooter
} 
%
\newcommand{\footlogo}{}
\newcommand{\@conference}{}
%
\newcommand{\setfooter}{%
  \ifthenelse{\boolean{footlogo@leftside}}{%
    \renewcommand{\@oddfoot}{\footlogo \hfill \@conference\\}
  }{%
    \renewcommand{\@oddfoot}{\@conference \hfill \footlogo\\}
  }
}
%
%
\newcommand{\conference}[1]{% arg:name of conference 
\makeatletter
\renewcommand{\@conference}{\footnotesize #1}
\setfooter
}

\renewcommand{\maketitle}{%
  \ifthenelse{\boolean{useleftlogo}}{%
  \begin{minipage}[c]{\logowidth}
     \printleftlogo
  \end{minipage}
  }{}
  \begin{minipage}[c]{\titlewidth}
    \begin{center}
      \renewcommand{\baselinestretch}{2.75}\normalsize
      {\titlesize \bf \textcolor{TitleCol}{\@title}}\par
      \renewcommand{\baselinestretch}{1.0}\normalsize            
      \vspace{0.4\titleskip}
      {\authorsize {\bf\@author} \par}
      {\instsize
       \vspace{0.2\titleskip}
       \theinstitute \par
       \ifthenelse{\equal{\printemail}{}}{%nothing
         }{%
         \vspace{0.2\titleskip}
         \texttt{\printemail}
         }
      }
    \end{center}
  \end{minipage}%}}
  \ifthenelse{\boolean{userightlogo}}{%
  \begin{minipage}[c]{\logowidth}
     \printrightlogo
  \end{minipage}
  }{}
\vspace{\titleskip}
}


% Fancy boxes around section titles
\ifthenelse{\equal{\secstyle}{fancy}}{
	\RequirePackage{tikz}
	\usetikzlibrary{shadows}
	\tikzset{fancyBox/.style={
		rounded corners=3mm,
		draw,
		inner sep=1mm,
		minimum height=10mm,
		line width=3pt,
		drop shadow,
		path picture={\node at (path picture bounding box.center) {\includegraphics[width=1.1\columnwidth]{issposter_section_background}};}
	}}
}{}

\newcommand{\FancySection}[2][?]{
	\vspace{\secskip}
	\refstepcounter{section}
	\begin{center}
		\begin{tikzpicture}
			\node[fancyBox]{
				\begin{minipage}[t]{.96\columnwidth}
					\centering {\bf\sectionsize\textcolor{SectionCol}{\arabic{section}.~#2}}
				\end{minipage}
			};
		\end{tikzpicture}
	\end{center}
	\par\vspace{0.375\secskip}
}

\newcommand{\sFancySection}[1]{
	\vspace{\secskip}
	\begin{center}
		\begin{tikzpicture}
			\node[fancyBox]{
				\begin{minipage}[t]{.96\columnwidth}
					\centering {\bf\sectionsize\textcolor{SectionCol}{#1}}
				\end{minipage}
			};
		\end{tikzpicture}
	\end{center}
	\par\vspace{0.375\secskip}
}


\newlength{\secboxwidth}
%%% \replacement for \section
% with colored section-title and automatic numbering
\newcommand{\Section}[2][?]{
  \vspace{\secskip}
  \refstepcounter{section}
  \begin{center}
    \setlength{\secboxwidth}{\columnwidth}
    \addtolength{\secboxwidth}{-1cm}
    \shabox{\colorbox{BoxCol}{
      \begin{minipage}[c]{\secboxwidth}
        \vspace{1.1ex}
        \begin{center}
          {\bf\sectionsize\textcolor{SectionCol}{\arabic{section}.~#2}}
        \end{center}
        \vspace{0.2ex}
      \end{minipage}
    }}
  \end{center}
  \par\vspace{0.375\secskip}
}
%
\newcommand{\sSection}[1]{
  \vspace{\secskip}
  \begin{center}
    \setlength{\secboxwidth}{\columnwidth}
    \addtolength{\secboxwidth}{-1cm}
    \shabox{\colorbox{BoxCol}{
      \begin{minipage}[c]{\secboxwidth}
        \vspace{1.1ex}
        \begin{center}
          {\bf\sectionsize\textcolor{SectionCol}{#1}}
        \end{center}
        \vspace{0.2ex}
      \end{minipage}
    }}
  \end{center}
  \par\vspace{0.375\secskip}
}
%
%
%%% \PlainSection - replacement for \section
\newcommand{\PlainSection}[2][?]{
  \refstepcounter{section}
  \vspace{\secskip}
  \begin{center}
  {\bf\sectionsize\textcolor{SectionCol}{\arabic{section}.~#2}}
  \end{center}
  \par\vspace{0.375\secskip}
}
%
%%% \sPlainSection - replacement for \section
\newcommand{\sPlainSection}[1]{
  \vspace{\secskip}
  \begin{center}
  {\bf \sectionsize \textcolor{SectionCol}{#1}}
  \end{center}
  \par\vspace{0.375\secskip}
}
%
%%% \RuledSection - replacement for \section
\newcommand{\RuledSection}[2][?]{
  \vspace{0.3\secskip}
  \rule{\columnwidth}{\secrulewidth}
  \refstepcounter{section}
  \vspace{0.7\secskip}
  \begin{center}
  {\bf\sectionsize\textcolor{SectionCol}{\arabic{section}.~#2}}
  \end{center}
  \par\vspace{0.375\secskip}
}
%
%%% \sRuledSection - replacement for \section
\newcommand{\sRuledSection}[1]{
  \ifthenelse{\equal{\arabic{section}}{0}}{}{
     \vspace{0.3\secskip}
     \rule{\columnwidth}{\secrulewidth}
  }
  \vspace{0.7\secskip}
  \begin{center}
  {\bf \sectionsize \textcolor{SectionCol}{#1}}
  \end{center}
  \par\vspace{0.375\secskip}
}
%%% \replacement for \section
% with colored section-title and automatic numbering
\newcommand{\PlainBoxSection}[2][?]{
  \vspace{\secskip}
  \refstepcounter{section}
  \begin{center}
    \setlength{\secboxwidth}{\columnwidth}
    \addtolength{\secboxwidth}{-1cm}
    \setlength{\fboxrule}{2pt}
    \setlength{\fboxsep}{0pt}
    \fbox{\colorbox{BoxCol}{
      \begin{minipage}[c]{\secboxwidth}
        \vspace{1.1ex}
        \begin{center}
          {\bf\sectionsize\textcolor{SectionCol}{\arabic{section}.~#2}}
        \end{center}
        \vspace{0.2ex}
      \end{minipage}
    }}
  \end{center}
  \par\vspace{0.375\secskip}
}
%
\newcommand{\sPlainBoxSection}[1]{
  \vspace{\secskip}
  \begin{center}
    \setlength{\secboxwidth}{\columnwidth}
    \addtolength{\secboxwidth}{-1cm}
    \setlength{\fboxrule}{2pt}
    \setlength{\fboxsep}{0pt}
    \fbox{\colorbox{BoxCol}{
      \begin{minipage}[c]{\secboxwidth}
        \vspace{1.1ex}
        \begin{center}
          {\bf\sectionsize\textcolor{SectionCol}{#1}}
        \end{center}
        \vspace{0.2ex}
      \end{minipage}
    }}
  \end{center}
  \par\vspace{0.375\secskip}
}
%
%
%
%
%
\ifthenelse{\equal{\secstyle}{ruled}}{
  \renewcommand{\section}{\secdef\RuledSection\sRuledSection}
}{
  \ifthenelse{\equal{\secstyle}{plain}}{
    \renewcommand{\section}{\secdef\PlainSection\sPlainSection}
  }{  
    \ifthenelse{\equal{\secstyle}{plainboxed}}{
      \renewcommand{\section}{\secdef\PlainBoxSection\sPlainBoxSection}
    }{
      \ifthenelse{\equal{\secstyle}{boxed}}{
        \renewcommand{\section}{\secdef\Section\sSection}
      }{
        \renewcommand{\section}{\secdef\FancySection\sFancySection}
      }
    }
  }
}
%%% \SubSection - replacement for \subsection
\newcommand{\SubSection}[2][?]{
  \vspace{0.5\secskip}
  \refstepcounter{subsection}
  {\bf \subsectionsize \textcolor{SectionCol}{\arabic{section}.\arabic{subsection}~#2}}
  \par\vspace{0.375\secskip}
}
%%% \sSubSection - replacement for \subsection
\newcommand{\sSubSection}[1]{
  \vspace{0.5\secskip}
  {\bf \subsectionsize \textcolor{SectionCol}{#1}}
  \par\vspace{0.375\secskip}
}
%
\renewcommand{\subsection}{\secdef\SubSection\sSubSection}
%%%
\renewenvironment{abstract}
{\section*{\abstractname}\it}
{}
%%%
%%%
\newcounter{subfig}[figure]
\renewcommand{\thesubfig}{\thefigure(\alph{subfig})}
\newcommand{\capstart}{}
\newcommand{\capfirstskip}{}
\newcommand{\caplastskip}{}
\newcommand{\subfigure}[2][]{
\refstepcounter{subfig}
\begin{tabular}{c}
 #2 \\(\alph{subfig}) #1\\
\end{tabular}
}

%%% caption formatting commands
\newcommand{\mastercapstartstyle}[1]{\textbf{#1}}
\newcommand{\mastercapbodystyle}{\itshape}
\newcommand{\capbodystyle}{\mastercapbodystyle}

\newcommand{\figcapstartstyle}[1]{\mastercapstartstyle{#1}}
\newcommand{\figcapbodystyle}{\mastercapbodystyle}
\newcommand{\tablecapstartstyle}[1]{\mastercapstartstyle{#1}}
\newcommand{\tablecapbodystyle}{\mastercapbodystyle}
\newcommand{\algcapstartstyle}[1]{\mastercapstartstyle{#1}}
\newcommand{\algcapbodystyle}{\mastercapbodystyle}

%%% replacement for standard figure environment
\renewenvironment{figure}[1][h]
{\vspace{\figtopskip}
 \refstepcounter{figure}
 \renewcommand{\capstart}{%
    \figcapstartstyle{\figurename\nobreakspace\thefigure:}%
 }
 \renewcommand{\capfirstskip}{\vspace{0.5\figtopskip}\par}
 \renewcommand{\caplastskip}{}
 \noindent%
 \begin{minipage}{\columnwidth}
 \renewcommand{\capbodystyle}{\figcapbodystyle}
}
{\end{minipage}
\vspace{\figbotskip}}

\newcommand{\algorithmname}{Algorithm}
\newcounter{algorithm}
%%% replacement for algorithm environment
\newenvironment{algorithm}[1][h]
{\vspace{\figtopskip}
 \refstepcounter{algorithm}
 \renewcommand{\capstart}{%
   \algcapstartstyle{\algorithmname\nobreakspace\thealgorithm:}%
 }
 \renewcommand{\capfirstskip}{\vspace{0.5\figtopskip}\par}
 \renewcommand{\caplastskip}{}
 \noindent%
 \begin{boxedminipage}{\columnwidth}
 \renewcommand{\capbodystyle}{\algcapbodystyle}
}
{\end{boxedminipage}
\vspace{\figbotskip}}
%%% replacement for standard table environment
\renewenvironment{table}[1][h]
{\vspace{\figtopskip}
 \refstepcounter{table}
 \renewcommand{\capstart}{%
   \tablecapstartstyle{\tablename\nobreakspace\thetable:}%
 }
 \renewcommand{\caplastskip}{\vspace{0.5\figtopskip}\par}
 \renewcommand{\capfirstskip}{}
 \noindent%
 \begin{minipage}{\columnwidth}
 \renewcommand{\capbodystyle}{\tablecapbodystyle}
 }
 {\end{minipage}\vspace{\figbotskip}}
%%% replacement for standard \caption
\renewcommand{\caption}[2][1]{
  \capfirstskip
  \begin{minipage}{#1\columnwidth}
    \renewcommand{\baselinestretch}{1}
    \setbox0=\hbox{\capstart\nobreakspace\capbodystyle #2}
    \ifdim\wd0>\hsize
      {\capstart\nobreakspace\capbodystyle #2}
    \else
      \centerline{\box0}
    \fi
    \par 
  \end{minipage}
  \caplastskip
}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
\setlength{\sboxrule}{2pt}
\setlength{\sboxsep}{0pt}
%
\ifthenelse{\equal{\orientation}{landscape}}{
  \setlength{\columnsep}{0.0365\textheight}
  \setlength{\columnseprule}{0.0025\textheight}
}{
  \setlength{\columnsep}{0.0385\textwidth}
  \setlength{\columnseprule}{0.0025\textwidth}
}
\setlength{\parindent}{0.0cm}
\newlength{\secrulewidth}
\setlength{\secrulewidth}{0.3\columnseprule}

%
%
\renewcommand{\familydefault}{\sfdefault}

\newcommand{\leftlogo}[2][0.9]{%
\ifthenelse{\equal{#2}{}}{%
 \renewcommand{\printleftlogo}{%
   \begin{center}
     \hspace*{0.6\textwidth}
   \end{center}
   }
 }
 {\renewcommand{\printleftlogo}{%
      \begin{center}
      \resizebox{#1\textwidth}{!}{\includegraphics{#2}}
    \end{center}
 }}
}
%
\newcommand{\rightlogo}[2][0.9]{%
\ifthenelse{\equal{#2}{}}{%
 \renewcommand{\printrightlogo}{%
   \begin{center}
     \hspace*{0.6\textwidth}
   \end{center}
   }
 }
 {\renewcommand{\printrightlogo}{%
     \begin{center}
       \resizebox{#1\textwidth}{!}{\includegraphics{#2}}
     \end{center}
 }}
}
%
\newcommand{\email}[1]{%
\renewcommand{\printemail}{#1}
}
%
\newcommand{\institute}[1]{%
\renewcommand{\theinstitute}{#1}
}
%
\newcommand{\norightlogo}{
\setboolean{userightlogo}{false}
\setlength{\titlewidth}{\textwidth}
\ifthenelse{\boolean{useleftlogo}}{
\addtolength{\titlewidth}{-\logowidth}
}{}
}
\newcommand{\noleftlogo}{
\setboolean{useleftlogo}{false}
\setlength{\titlewidth}{\textwidth}
\ifthenelse{\boolean{userightlogo}}{
\addtolength{\titlewidth}{-\logowidth}
}{}
}
\newcommand{\nologos}{
\setboolean{useleftlogo}{false}
\setboolean{userightlogo}{false}
\setlength{\titlewidth}{\textwidth}
}

%
%%% \PARstart command redefined using lettrine package of Danial Flipo
%%  only included here for backwards compatibility 

\newcommand{\PARstart}[2]{\lettrine{#1}{#2}}


% ISS-style labels for itemize (from presentation template) and appropriate margins
\setlength{\labelsep}{.5em}
\renewcommand{\labelitemi}{\raisebox{.25ex}{\footnotesize\color{SectionCol}\ensuremath\blacksquare}} % smaller square than in the presentation template
\setlength{\leftmargini}{1.25em}
\renewcommand{\labelitemii}{\raisebox{.2ex}{\color{SectionCol}\ensuremath\bullet}}
\setlength{\leftmarginii}{1.25em}
\renewcommand{\labelitemiii}{\raisebox{.4ex}{\footnotesize\color{SectionCol}\ensuremath\blacktriangleright}}
\setlength{\leftmarginiii}{1.25em}
\renewcommand{\labelitemiv}{\raisebox{.4ex}{\small\color{SectionCol}\ensuremath -}}
\setlength{\leftmarginiv}{1.25em}

% Set background image depending on orientation
\RequirePackage{wallpaper}
\setlength{\wpYoffset}{\voffset}
\ifthenelse{\equal{\orientation}{landscape}}{
    \CenterWallPaper{1}{issposter_background_landscape}
}{
    \CenterWallPaper{1}{issposter_background_portrait}
}

% Print logos
\renewcommand{\printleftlogo}{\includegraphics[width=0.8\logowidth]{unilogo_hochkant}\vspace{2ex}}
\renewcommand{\printrightlogo}{\includegraphics[width=\logowidth]{isslogocolor}\vspace{2ex}}

\setlength{\columnseprule}{8pt}

\endinput

\color{TextCol}

%% 
%% End of file `issposter.cls'.










