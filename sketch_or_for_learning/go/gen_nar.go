package main

import (
	"fmt"
	"os"
	"bufio"
	"io"
	"unicode"
	"regexp"
	"strings"
)

func check(e error) {
	if e!=nil {
		panic(e)
	}
}

type STRF func(rune) bool

type TOK int
const(
	EOF=iota
	ERR
	SYM
	OR
	AND
	MUL
	MORE
	NUM
	NSYM
	INS
	NOT
	DOL
	NOTDOL
	DNOT
	DDOL
	DVO
)

var toks=[]string{
	EOF:"EOF",
	ERR:"ERR",
	SYM:"SYM",
	OR:"OR",
	AND:"AND",
	MUL:"MUL",
	MORE:"MORE",
	NUM:"NUM",
	NSYM:"NSYM",
	INS:"INS",
	NOT:"NOT",
	DOL:"DOL",
	NOTDOL:"NOTDOL",
	DNOT:"DNOT",
	DDOL:"DDOL",
	DVO:"DVO",
}

func (t TOK) String() string {
	return toks[t];
}

type POS struct {
	lin int
	col int
}

type LEX struct {
	p POS
	r *bufio.Reader
}

func NewLEX(reader io.Reader) *LEX {
	return &LEX{
		p: POS{lin:1,col:0},
		r: bufio.NewReader(reader),
	}
}

func (l *LEX) resetPOS() {
	l.p.lin++
	l.p.col=0
}

func (l *LEX) lexWhile(f STRF) string {
	var lit string
	for {
		r,_,e:=l.r.ReadRune()
		if e==io.EOF{
			return lit
		}
		l.p.col++
		if f(r){
			lit=lit+string(r)
		} else {
			l.back()
			return lit
		}

	}
}

func (l *LEX) lexBrace() string {
	var lit string
	i:=1
	t,_,e:=l.r.ReadRune()
	check(e)
	o:=map[rune]int{'{':1,'}':-1, '(':1,')':-1}
	v:=map[rune]rune{'{':'{','}':'{', '(':'(',')':'('}
	for {
		r,_,e:=l.r.ReadRune()
		if e==io.EOF{
			return lit
		}
		l.p.col++
		if t==v[r] {
			i=i+o[r]
		}
		if i==0{
			return lit
		} else {
			lit=lit+string(r)
		}
	}
}

func (l *LEX) back() {
	e:=l.r.UnreadRune()
	check(e)
	l.p.col++
}

func isNote(r rune) bool {
	return strings.ContainsRune("abcdefgh,'0123456789",r)
}

func (l *LEX) ntok() (POS,TOK,string) {
	nota,e:=regexp.Compile("^[a-h][,']*$")
	check(e)
	notd,e:=regexp.Compile("^[a-h][,']*[0-9]+$")
	check(e)
	for {
		r,_,e:=l.r.ReadRune()
		if e==io.EOF{
			return l.p,EOF,""
		} else {
			check(e)
		}
		l.p.col++
		switch r {
			case '\n': l.resetPOS()
			case '|': return l.p,OR,"|"
			case '*': return l.p,MUL,"*"
			case '&': return l.p,AND,"&"
			case '%': return l.p,MORE,"%"
			case ':': return l.p,DVO,":"
			case '+','-':
				sp:=l.p
				k,_,e:=l.r.ReadRune()
				check(e)
				p,_,e:=l.r.ReadRune()
				check(e)
				lit:=l.lexWhile(unicode.IsDigit)
				if k=='n' {
					return sp,DNOT,string(p)+lit
				} else {
					return sp,DDOL,string(p)+lit
				}
			case 'd':
				sp:=l.p
				lit:=l.lexWhile(unicode.IsDigit)
				return sp,DOL,lit
			case '(','{':
				sp:=l.p
				l.back()
				lit:=l.lexBrace()
				if r=='(' {
					return sp,NSYM,lit
				} else {
					return sp,INS,lit
				}
			default:
				if unicode.IsSpace(r) {
					continue
				} else if unicode.IsDigit(r) {
					sp:=l.p
					l.back()
					lit:=l.lexWhile(unicode.IsDigit)
					return sp,NUM,lit
				} else if unicode.IsLetter(r) {
					sp:=l.p
					l.back()
					if isNote(r) {
						lit:=l.lexWhile(isNote)
						if nota.MatchString(lit) {
							return sp,NOT,lit
						} else if notd.MatchString(lit) {
							return sp,NOTDOL,lit
						} else {
							return sp,SYM,lit
						}
					} else {
						lit:=l.lexWhile(unicode.IsLetter)
						return sp,SYM,lit
					}
				} else {
					return l.p,ERR,""
				}
		}
	}
}

func main() {
	for _,a:=range os.Args[1:] {
		f,e:=os.Open(a)
		check(e)
		l:=NewLEX(f)
		for{
			p,tok,lit:=l.ntok()
			if tok==EOF{
				break
			}
			fmt.Printf("%d:%d\t%s\t%s\n",p.lin,p.col,tok,lit);
		}
	}
}
