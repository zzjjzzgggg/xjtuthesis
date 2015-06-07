ENTRY
  { address
    author
    booktitle
    chapter
    edition
    editor
    howpublished
    institution
    journal
    key
	lang
    month
    note
    number
    organization
    pages
    publisher
    school
    series
    title
    type
    url
    volume
    year
  }
  {}
  { label extra.label sort.label short.list }

INTEGERS {output.state before.all mid.sentence after.sentence after.block}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {format.date}
{ year empty$
    { month empty$
    { "" }
    { "there's a month but no year in " cite$ * warning$
      month
    }
      if$
    }
    { month empty$
    'year
    { month ", " * year * }
      if$
    }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { new.block 
    "\url{" url * "}" * }
  if$
}
FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
}

STRINGS { s t }

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
    { add.period$ write$
      newline$
      "\newblock " write$
    }
    { output.state before.all =
        'write$
        { add.period$ " " * write$ }
      if$
    }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}
 
FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {output.year.month.check}
{ year empty$
    { "empty year in " cite$ * warning$ }
    { add.period$ write$
      month empty$
        { " " year * extra.label * "." *
          after.sentence 'output.state :=
        }
        { " " year * extra.label * " (" * month * ")." *
          after.sentence 'output.state :=
        }
      if$
    }
  if$
}

FUNCTION {output.year.check}
{ year empty$
    { "empty year in " cite$ * warning$ }
    { year }
  if$
  extra.label *
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem[" write$
  label write$
  "]{" write$
  cite$ write$
  "}" write$
  newline$
  ""
  before.all 'output.state :=
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {boldface}
{ duplicate$ empty$
    { pop$ "" }
    { "{\bf " swap$ * "}" * }
  if$
}

Function{upcase}
{ duplicate$ empty$
    { pop$ "" }
    { "u" change.case$ }
  if$
}
FUNCTION {bib.name.font}
{}
FUNCTION {bib.fname.font}
{ bib.name.font }

INTEGERS { nameptr namesleft numnames }

FUNCTION {capitalize}
{ "u" change.case$ "t" change.case$ }

STRINGS {z}
FUNCTION {remove.dots}
{ 'z :=
  ""
  { z empty$ not}
  { z #1 #1 substring$
    z #2 global.max$ substring$ 'z :=
    duplicate$ "." = 'pop$
      { * }
    if$
  }
  while$

}

FUNCTION {format.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{ f{~}}{ jj}"
    format.name$
    remove.dots
     't :=
      nameptr #1 >
        { nameptr #3
          #1 + = numnames #3
          > and
            { "others" 't := #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            { numnames #2 >
              { "" * }
              'skip$
              if$
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                { bib.name.font ", et al." * }
                { ", " * t * } 
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
  t "others" =
    'skip$
    { bib.name.font }
  if$
}

FUNCTION {format.normal.names}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{ f{~}}{, jj}"
    format.name$
    remove.dots
     't :=
      nameptr #1 >
        { 
          nameptr #3
          #1 + =
          numnames #3
          > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            { numnames #2 >
              { "" * }
              'skip$
              if$
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                 { ", et al." * }
                {", " * t * } 
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.normal.cnames}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr "{vv~}{ll}{ f{~}}{ jj}" format.name$ 
    remove.dots
    't :=
      nameptr #1 >
        {
          nameptr #3
          #1 + =
          numnames #3
          > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            { numnames #2 >
              { "" * }
              'skip$
              if$
              s nameptr "{ll}" format.name$ duplicate$ "others" =
                { 't := }
                { pop$ }
              if$
              t "others" =
                 { ",等" * }
                {", " * t * } 
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    {author format.names }
  if$
}

FUNCTION {format.key}
{ empty$
    { key field.or.null }
    { "" }
  if$
}

FUNCTION {format.editors}
{ editor empty$
    { "" }
	{editor format.names
      editor num.names$ #1 >
        { "" * }
        { "" * }
      if$
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title }
  if$
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
               { "-" *
                 t #2 global.max$ substring$ 't :=
               }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
        if$
    }
  while$
}

FUNCTION {format.btitle}
{ title empty$
   { "" }
   {booktitle}
   if$
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.numberinseries}
{ number empty$
    { "" }
    { number multi.page.check
        { ", nos. " number n.dashify tie.or.space.connect }
        { ", no. "  number tie.or.space.connect }
      if$
    }
  if$
}

FUNCTION {booklike.series.volume.number}
{ series empty$
    { volume empty$
      { " " }
      { " Vol. " volume * }
      if$
    }
    {
      volume empty$
        { number empty$
            { series }
            { series format.numberinseries * }
          if$
        }
        { number empty$
            { series ", vol. " volume * * }
            { series ", vol. " * volume * format.numberinseries * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { ":" pages n.dashify tie.or.space.connect * }
        { ":" pages tie.or.space.connect  * }
      if$
    }
  if$
}

FUNCTION {incollectionlike.series.volume.number.pages}
{ series empty$
    { volume empty$
        { pages empty$
           'skip$
           { duplicate$ empty$
              { pop$ format.pages }
              { ":" * pages n.dashify * "" *}
             if$
           }
         if$
	    }
        { "，" * volume * "" *
            pages empty$
              'skip$
              { duplicate$ empty$
                  { pop$ format.pages }
                  { ":" * pages n.dashify * "" *}
                if$
              }
            if$
	    }
      if$
    }
    { new.block
      volume empty$
        { number empty$
            { series }
            { series format.numberinseries * }
          if$
        }
        { number empty$
            { series ", vol. " * volume * }
            { series ", vol. " * volume * format.numberinseries * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {cincollectionlike.series.volume.number.pages}
{ series empty$
    { volume empty$
      {  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ":" * pages n.dashify * "" *}
      if$
    }
  if$}
      { "，第" volume * "卷" *
        pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ":" * pages n.dashify * "" *}
      if$
    }
  if$}
      if$
    }
    { new.block
      volume empty$
        { number empty$
            { series }
            { series format.numberinseries * }
          if$
        }
        { number empty$
            { series ", vol. " * volume * }
            { series ", vol. " * volume * format.numberinseries * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
		{ edition "l" change.case$ " ed." * }
		{ edition "t" change.case$ " ed." * }
      if$
    }
  if$
}

FUNCTION {format.pagesinbook}
{ pages empty$
    { "" }
    { pages multi.page.check
        { ":" pages n.dashify tie.or.space.connect }
        { ":" pages tie.or.space.connect }
      if$
    }
  if$
}

                                                            
FUNCTION {format.vol.num.date.pages}
{volume empty$
    'skip$
    {volume
    }
  if$
  number empty$
    'skip$
    { "(" number * ")" *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ":" * pages n.dashify * "" *}
      if$
    }
  if$
}

FUNCTION {format.article.vol.num.date.pages}
{
volume empty$
    'skip$
    {volume
    }
  if$
number empty$
    'skip$
    { "(" number * ")" * *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ":" * pages n.dashify * "" *}
      if$
    }
  if$       
}

FUNCTION {format.chapter.pages.inbook}
{ chapter empty$
    'format.pagesinbook
    { type empty$
        { "Chap." }
        { type }
      if$
      chapter tie.or.space.connect
      pages empty$
        'skip$
        { ", " * format.pagesinbook "l" change.case$ * }
      if$
    }
  if$
}

FUNCTION {format.chapter.pages.incoll}
{ chapter empty$
    { pages empty$
        { "In " }
        { "{\em " format.pagesinbook " of:} " * * }
      if$
    }
    { type empty$
        { "{\em Chap. " chapter * }
        { "{\em " type * " " * chapter * }
      if$
      pages empty$
        { " of:} " * }
        { ", " * format.pagesinbook "l" change.case$ " of:} " * * }
      if$
    }
  if$
}

FUNCTION {format.in.ed.booktitle}
{ booktitle empty$
    { "" }
    { editor empty$
        { booktitle new.block }
        { new.block
		  format.editors  "author and editor" output.check
		  editor format.key output
		  new.block
		  format.btitle "booktitle" output.check  
		}
	  if$
    }
  if$
}
 
FUNCTION {format.in.proceedings.booktitle}
{ booktitle empty$
    { "" }
    {format.btitle "booktitle" output.check   }
  if$
}
 
FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { "Tech. rept."  }
    'type
  if$
  number empty$
    {                  }
    { number tie.or.space.connect }
  if$
}

FUNCTION {format.address.publisher}
{ address empty$
    { publisher empty$
    { "" }
    { "there's a publisher but no address in " cite$ * warning$
      publisher
    }
      if$
    }
    { publisher empty$
    'address
    { address ": " * publisher * }
      if$
    }
  if$
}

FUNCTION {format.addr.institution}
{ institution empty$
    {address empty$
        { "  " *}
        { address ":  " * }
      if$
    }
    { address empty$
        { "  " * }
        { address ": " * }
      if$
      institution *
    }
    
  if$
}

FUNCTION {format.school.pub}
{ school empty$
    {address empty$
        { "  " }
        { address ":  " * }
      if$
    }
    { address empty$
        { "  " * }
        { address ": " * }
      if$
      school *
    }
  if$
}

FUNCTION {format.cschool.pub}
{school empty$
    {address empty$
        { "[地址不详]：[学校不详]" }
        { address ":[学校不详]" * }
      if$
    }
    { address empty$
        { ".[学校不详]：" * }
        { address ": " * }
      if$
      school *
    }
    
  if$
}

FUNCTION {format.inproceedings.addr.pub}
{ address empty$
	{ " " }
	{ publisher empty$ 
		{ address ": " *}
		{ address ": " * publisher *}
	  if$
	}
  if$
}

FUNCTION {format.address.publisher.org}
{ address empty$
  { " " * publisher * ", for " * organization * }
  { address ": " * publisher * ", for " * organization * }
  if$
}

FUNCTION {format.addr.inst}
{ address empty$
  { institution empty$
    { " " }
    { " " * institution *}
    if$
  }
  { institution empty$
    { "" }
    { institution ", " * }
    if$
    address *
  }
  if$
}

FUNCTION {format.addr.org}
{ address empty$
  { organization empty$
    { "" }
    { organization }
    if$
  }
  { organization empty$
    { "" }
    { organization ", " * }
    if$
    address *
  }
  if$
}

FUNCTION {format.article.crossref}
{ "In "
  " \cite{" * crossref * "}" *
}

FUNCTION {format.book.crossref}
{ volume empty$
    { "empty volume in " cite$ * "'s crossref of " * crossref * warning$
      "In "
    }
    { " Vol." volume tie.or.space.connect
      " of " *
    }
  if$
  "\cite{" * crossref * "}" *
}

FUNCTION {format.incoll.inproc.crossref}
{ "In "
  " \cite{" * crossref * "}" *
}

FUNCTION {article.type}
{ lang empty$
	{ "[J]" }
	{ "" }
  if$
}

FUNCTION {article}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block  
  format.title article.type * output 
  new.block
  crossref missing$
    { journal
  	"journal" output.check
  	%output.article.year.check output
	format.date output
  	format.article.vol.num.date.pages output
  
    }
    { format.article.crossref output.nonnull
  	format.pages output
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {book.type}
{ lang empty$
	{ "[M]" }
	{ "" }
  if$
}

FUNCTION {book}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.title book.type * output
  new.block
  crossref missing$
    { 
      new.block
      booklike.series.volume.number output
    }
    { format.book.crossref output.nonnull }
  if$
  format.edition output
  format.address.publisher "publisher" output.check
  pages empty$
    { format.date "year" output.check }
    { format.date ":" * format.pages * output }
  if$  
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  format.authors output
  author format.key output
  output.year.month.check
  new.block
  format.btitle "title" output.check
  new.block
  howpublished output
  address output
  output.year.check
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.title book.type * output  
  new.block
  crossref missing$
    { format.edition output
      booklike.series.volume.number output
      new.block
      format.address.publisher "publisher" output.check
      output.year.check output
      format.pages output
    }
    { format.book.crossref output.nonnull
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  author empty$
    { format.editors "editor" output.check
      editor format.key output             }
    { format.authors "author" output.check
      author format.key output             }
  if$
  new.block
  format.title book.type * output  
  crossref missing$
    {
    format.in.ed.booktitle output
      format.edition output
      new.block
      format.address.publisher "publisher" output.check
      output.year.check 
      incollectionlike.series.volume.number.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      new.block
    }
  if$

  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {conference.type}
{ lang empty$
	{ "[C]" }
	{ "" }
  if$
}

FUNCTION {inproceedings}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  new.block
  format.title conference.type * output
  new.block
  crossref missing$
    {
      format.in.ed.booktitle output
      format.edition output
      output.year.check
      incollectionlike.series.volume.number.pages output
    }
    { format.incoll.inproc.crossref output.nonnull
      new.block
    }
  if$
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {techreport}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.title "[R]" * "title" output.check
  new.block
  crossref missing$
    { format.edition output
      booklike.series.volume.number output
      new.block
      format.addr.institution "publisher" output.check
      output.year.check output
      format.pages output
    }
    { format.book.crossref output.nonnull
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.title "[D]" * "title" output.check
  new.block
  crossref missing$
    { format.edition output
      booklike.series.volume.number output
      new.block

      format.school.pub "publisher" output.check
      output.year.check output
      format.pages output
    }
    { format.book.crossref output.nonnull
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.title "[D]" * "title" output.check
  new.block
  crossref missing$
    { format.edition output
      booklike.series.volume.number output
      new.block

      format.school.pub "publisher" output.check
      output.year.check output
      format.pages output
    }
    { format.book.crossref output.nonnull
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.title conference.type output  
  new.block
  crossref missing$
    { format.edition output
      booklike.series.volume.number output
      new.block
      format.address.publisher "publisher" output.check
      output.year.check output
      format.pages output
    }
    { format.book.crossref output.nonnull
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {manual}
{ output.bibitem
  author empty$
    { format.editors "author and editor" output.check
      editor format.key output
    }
    { format.authors output.nonnull
      crossref missing$
        { "author and editor" editor either.or.check }
        'skip$
      if$
    }
  if$
  new.block
  format.btitle "[OL]" * "title" output.check
  new.block
  crossref missing$
    { format.edition output
      booklike.series.volume.number output
      new.block
      format.address.publisher "publisher" output.check
      output.year.check output
      format.pages output
    }
    { format.book.crossref output.nonnull
    }
  if$
  new.block
  format.url output
  new.block
  note output
  fin.entry
}

FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {misc.type}
{ lang empty$
	{ "[OL]" }
	{ "" }
  if$
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.block.checkb
  format.title output
  howpublished new.block.checka
  howpublished misc.type * output
  new.block
  format.date output
  format.url output
  new.block
  note output
  fin.entry
  empty.misc.check
}

FUNCTION {unpublished}
{ output.bibitem
  format.authors "author" output.check
  author format.key output
  output.year.month.check
  new.block
  format.btitle "title" output.check
  new.block
  note "note" output.check
  fin.entry
}


FUNCTION {default.type} { book }   
MACRO {jan} {"Jan."}
MACRO {feb} {"Feb."}
MACRO {mar} {"Mar."}
MACRO {apr} {"Apr."}
MACRO {may} {"May"}
MACRO {jun} {"June"}
MACRO {jul} {"July"}
MACRO {aug} {"Aug."}
MACRO {sep} {"Sept."}
MACRO {oct} {"Oct."}
MACRO {nov} {"Nov."}
MACRO {dec} {"Dec."}
MACRO {acmcs} {"ACM Computing Surveys"}
MACRO {acta} {"Acta Informatica"}
MACRO {cacm} {"Communications of the ACM"}
MACRO {ibmjrd} {"IBM Journal of Research and Development"}
MACRO {ibmsj} {"IBM Systems Journal"}
MACRO {ieeese} {"IEEE Transactions on Software Engineering"}
MACRO {ieeetc} {"IEEE Transactions on Computers"}
MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}
MACRO {ipl} {"Information Processing Letters"}
MACRO {jacm} {"Journal of the ACM"}
MACRO {jcss} {"Journal of Computer and System Sciences"}
MACRO {scp} {"Science of Computer Programming"}
MACRO {sicomp} {"SIAM Journal on Computing"}
MACRO {tocs} {"ACM Transactions on Computer Systems"}
MACRO {tods} {"ACM Transactions on Database Systems"}
MACRO {tog} {"ACM Transactions on Graphics"}
MACRO {toms} {"ACM Transactions on Mathematical Software"}
MACRO {toois} {"ACM Transactions on Office Information Systems"}
MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}
MACRO {tcs} {"Theoretical Computer Science"}
READ

FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {format.lab.names}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ " et al." * }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " {\em et~al.}" * }
            { " and " * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {format.lab.cnames}
{ 's :=
  s #1 "{vv~}{ll}" format.name$
  s num.names$ duplicate$
  #2 >
    { pop$ "~等" * }
    { #2 <
        'skip$
        { s #2 "{ff }{vv }{ll}{ jj}" format.name$ "others" =
            { " {\em et~al.}" * }
            { "和" * s #2 "{vv~}{ll}" format.name$ * }
          if$
        }
      if$
    }
  if$
}

FUNCTION {author.key.label}
{ author empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
     {lang empty$
      {author format.lab.names}
      {author format.lab.cnames}
      if$}

  if$
}

FUNCTION {author.editor.key.label}
{ author empty$
    { editor empty$
        { key empty$
            { cite$ #1 #3 substring$ }
            'key
          if$
        }
     {lang empty$
      {editor format.lab.names}
      {editor format.lab.cnames}
      if$}
 
      if$
    }
     {lang empty$
      {author format.lab.names}
      {author format.lab.cnames}
      if$}

  if$
}

FUNCTION {editor.key.label}
{ editor empty$
    { key empty$
        { cite$ #1 #3 substring$ }
        'key
      if$
    }
     {lang empty$
      {editor format.lab.names}
      {editor format.lab.cnames}
      if$}

  if$
}

FUNCTION {author.key.organization.label}
{ author empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { author format.lab.names }
  if$
}

FUNCTION {editor.key.organization.label}
{ editor empty$
    { key empty$
        { organization empty$
            { cite$ #1 #3 substring$ }
            { "The " #4 organization chop.word #3 text.prefix$ }
          if$
        }
        'key
      if$
    }
    { editor format.lab.names }
  if$
}

FUNCTION {calc.short.authors}
{ type$ "book" =
  type$ "inbook" =
  or
    'author.editor.key.label
    { type$ "proceedings" =
        'editor.key.organization.label
        { type$ "manual" =
            'author.key.organization.label
            'author.key.label
          if$
        }
      if$
    }
  if$
  'short.list :=
}

FUNCTION {calc.label}
{ calc.short.authors
  short.list
  "("
  *
  year duplicate$ empty$
  short.list key field.or.null = or
     { pop$ ""}
     'skip$
  if$
  * ")" * 
  'label :=
}

INTEGERS { seq.num }

FUNCTION {init.seq}
{ #0 'seq.num :=}

EXECUTE {init.seq}

FUNCTION {int.to.fix}
{ "000000000" swap$ int.to.str$ *
  #-1 #10 substring$
}


FUNCTION {presort}
{ calc.label
  label sortify
  "    "
  *
  seq.num #1 + 'seq.num :=
  seq.num  int.to.fix
  'sort.label :=
  sort.label *
  #1 entry.max$ substring$
  'sort.key$ :=
}

ITERATE {presort}

SORT

STRINGS { longest.label last.label next.extra }

INTEGERS { longest.label.width last.extra.num number.label }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #0 int.to.chr$ 'last.label :=
  "" 'next.extra :=
  #0 'longest.label.width :=
  #0 'last.extra.num :=
  #0 'number.label :=
}

FUNCTION {forward.pass}
{ last.label label =
    { last.extra.num #1 + 'last.extra.num :=
      last.extra.num int.to.chr$ 'extra.label :=
    }
    { "a" chr.to.int$ 'last.extra.num :=
      "" 'extra.label :=
      label 'last.label :=
    }
  if$
  number.label #1 + 'number.label :=
}

FUNCTION {reverse.pass}
{ next.extra "b" =
    { "a" 'extra.label := }
    'skip$
  if$
  extra.label 'next.extra :=
  extra.label
  duplicate$ empty$
    'skip$
    { "{\natexlab{" swap$ * "}}" * }
  if$
  'extra.label :=
  label extra.label * 'label :=
}

EXECUTE {initialize.longest.label}

ITERATE {forward.pass}

REVERSE {reverse.pass}

FUNCTION {bib.sort.order}
{ sort.label  'sort.key$ :=
}

ITERATE {bib.sort.order}

SORT

FUNCTION {begin.bib}
{   preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
  "\begin{thebibliography}{" number.label int.to.str$ * "}" *
  write$ newline$
  "\providecommand{\natexlab}[1]{#1}"
  write$ newline$
  "\providecommand{\url}[1]{\texttt{#1}}"
  write$ newline$
  "\expandafter\ifx\csname urlstyle\endcsname\relax"
  write$ newline$
  "  \providecommand{\doi}[1]{doi: #1}\else"
  write$ newline$
  "  \providecommand{\doi}{doi: \begingroup \urlstyle{rm}\Url}\fi"
  write$ newline$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}

