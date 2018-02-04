
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <print_mode>:
#ifdef CS333_P5
// this is an ugly series of if statements but it works
void
print_mode(struct stat* st)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
  switch (st->type) {
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	0f b7 00             	movzwl (%eax),%eax
   c:	98                   	cwtl   
   d:	83 f8 02             	cmp    $0x2,%eax
  10:	74 1e                	je     30 <print_mode+0x30>
  12:	83 f8 03             	cmp    $0x3,%eax
  15:	74 2d                	je     44 <print_mode+0x44>
  17:	83 f8 01             	cmp    $0x1,%eax
  1a:	75 3c                	jne    58 <print_mode+0x58>
    case T_DIR: printf(1, "d"); break;
  1c:	83 ec 08             	sub    $0x8,%esp
  1f:	68 51 0e 00 00       	push   $0xe51
  24:	6a 01                	push   $0x1
  26:	e8 70 0a 00 00       	call   a9b <printf>
  2b:	83 c4 10             	add    $0x10,%esp
  2e:	eb 3a                	jmp    6a <print_mode+0x6a>
    case T_FILE: printf(1, "-"); break;
  30:	83 ec 08             	sub    $0x8,%esp
  33:	68 53 0e 00 00       	push   $0xe53
  38:	6a 01                	push   $0x1
  3a:	e8 5c 0a 00 00       	call   a9b <printf>
  3f:	83 c4 10             	add    $0x10,%esp
  42:	eb 26                	jmp    6a <print_mode+0x6a>
    case T_DEV: printf(1, "c"); break;
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 55 0e 00 00       	push   $0xe55
  4c:	6a 01                	push   $0x1
  4e:	e8 48 0a 00 00       	call   a9b <printf>
  53:	83 c4 10             	add    $0x10,%esp
  56:	eb 12                	jmp    6a <print_mode+0x6a>
    default: printf(1, "?");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 57 0e 00 00       	push   $0xe57
  60:	6a 01                	push   $0x1
  62:	e8 34 0a 00 00       	call   a9b <printf>
  67:	83 c4 10             	add    $0x10,%esp
  }

  if (st->mode.flags.u_r)
  6a:	8b 45 08             	mov    0x8(%ebp),%eax
  6d:	0f b6 40 15          	movzbl 0x15(%eax),%eax
  71:	83 e0 01             	and    $0x1,%eax
  74:	84 c0                	test   %al,%al
  76:	74 14                	je     8c <print_mode+0x8c>
    printf(1, "r");
  78:	83 ec 08             	sub    $0x8,%esp
  7b:	68 59 0e 00 00       	push   $0xe59
  80:	6a 01                	push   $0x1
  82:	e8 14 0a 00 00       	call   a9b <printf>
  87:	83 c4 10             	add    $0x10,%esp
  8a:	eb 12                	jmp    9e <print_mode+0x9e>
  else
    printf(1, "-");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 53 0e 00 00       	push   $0xe53
  94:	6a 01                	push   $0x1
  96:	e8 00 0a 00 00       	call   a9b <printf>
  9b:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.u_w)
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	0f b6 40 14          	movzbl 0x14(%eax),%eax
  a5:	83 e0 80             	and    $0xffffff80,%eax
  a8:	84 c0                	test   %al,%al
  aa:	74 14                	je     c0 <print_mode+0xc0>
    printf(1, "w");
  ac:	83 ec 08             	sub    $0x8,%esp
  af:	68 5b 0e 00 00       	push   $0xe5b
  b4:	6a 01                	push   $0x1
  b6:	e8 e0 09 00 00       	call   a9b <printf>
  bb:	83 c4 10             	add    $0x10,%esp
  be:	eb 12                	jmp    d2 <print_mode+0xd2>
  else
    printf(1, "-");
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 53 0e 00 00       	push   $0xe53
  c8:	6a 01                	push   $0x1
  ca:	e8 cc 09 00 00       	call   a9b <printf>
  cf:	83 c4 10             	add    $0x10,%esp

  if ((st->mode.flags.u_x) & (st->mode.flags.setuid))
  d2:	8b 45 08             	mov    0x8(%ebp),%eax
  d5:	0f b6 40 14          	movzbl 0x14(%eax),%eax
  d9:	c0 e8 06             	shr    $0x6,%al
  dc:	83 e0 01             	and    $0x1,%eax
  df:	0f b6 d0             	movzbl %al,%edx
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 40 15          	movzbl 0x15(%eax),%eax
  e9:	d0 e8                	shr    %al
  eb:	83 e0 01             	and    $0x1,%eax
  ee:	0f b6 c0             	movzbl %al,%eax
  f1:	21 d0                	and    %edx,%eax
  f3:	85 c0                	test   %eax,%eax
  f5:	74 14                	je     10b <print_mode+0x10b>
    printf(1, "S");
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 5d 0e 00 00       	push   $0xe5d
  ff:	6a 01                	push   $0x1
 101:	e8 95 09 00 00       	call   a9b <printf>
 106:	83 c4 10             	add    $0x10,%esp
 109:	eb 34                	jmp    13f <print_mode+0x13f>
  else if (st->mode.flags.u_x)
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 112:	83 e0 40             	and    $0x40,%eax
 115:	84 c0                	test   %al,%al
 117:	74 14                	je     12d <print_mode+0x12d>
    printf(1, "x");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 5f 0e 00 00       	push   $0xe5f
 121:	6a 01                	push   $0x1
 123:	e8 73 09 00 00       	call   a9b <printf>
 128:	83 c4 10             	add    $0x10,%esp
 12b:	eb 12                	jmp    13f <print_mode+0x13f>
  else
    printf(1, "-");
 12d:	83 ec 08             	sub    $0x8,%esp
 130:	68 53 0e 00 00       	push   $0xe53
 135:	6a 01                	push   $0x1
 137:	e8 5f 09 00 00       	call   a9b <printf>
 13c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_r)
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 146:	83 e0 20             	and    $0x20,%eax
 149:	84 c0                	test   %al,%al
 14b:	74 14                	je     161 <print_mode+0x161>
    printf(1, "r");
 14d:	83 ec 08             	sub    $0x8,%esp
 150:	68 59 0e 00 00       	push   $0xe59
 155:	6a 01                	push   $0x1
 157:	e8 3f 09 00 00       	call   a9b <printf>
 15c:	83 c4 10             	add    $0x10,%esp
 15f:	eb 12                	jmp    173 <print_mode+0x173>
  else
    printf(1, "-");
 161:	83 ec 08             	sub    $0x8,%esp
 164:	68 53 0e 00 00       	push   $0xe53
 169:	6a 01                	push   $0x1
 16b:	e8 2b 09 00 00       	call   a9b <printf>
 170:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_w)
 173:	8b 45 08             	mov    0x8(%ebp),%eax
 176:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 17a:	83 e0 10             	and    $0x10,%eax
 17d:	84 c0                	test   %al,%al
 17f:	74 14                	je     195 <print_mode+0x195>
    printf(1, "w");
 181:	83 ec 08             	sub    $0x8,%esp
 184:	68 5b 0e 00 00       	push   $0xe5b
 189:	6a 01                	push   $0x1
 18b:	e8 0b 09 00 00       	call   a9b <printf>
 190:	83 c4 10             	add    $0x10,%esp
 193:	eb 12                	jmp    1a7 <print_mode+0x1a7>
  else
    printf(1, "-");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 53 0e 00 00       	push   $0xe53
 19d:	6a 01                	push   $0x1
 19f:	e8 f7 08 00 00       	call   a9b <printf>
 1a4:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.g_x)
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 1ae:	83 e0 08             	and    $0x8,%eax
 1b1:	84 c0                	test   %al,%al
 1b3:	74 14                	je     1c9 <print_mode+0x1c9>
    printf(1, "x");
 1b5:	83 ec 08             	sub    $0x8,%esp
 1b8:	68 5f 0e 00 00       	push   $0xe5f
 1bd:	6a 01                	push   $0x1
 1bf:	e8 d7 08 00 00       	call   a9b <printf>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb 12                	jmp    1db <print_mode+0x1db>
  else
    printf(1, "-");
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	68 53 0e 00 00       	push   $0xe53
 1d1:	6a 01                	push   $0x1
 1d3:	e8 c3 08 00 00       	call   a9b <printf>
 1d8:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_r)
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 1e2:	83 e0 04             	and    $0x4,%eax
 1e5:	84 c0                	test   %al,%al
 1e7:	74 14                	je     1fd <print_mode+0x1fd>
    printf(1, "r");
 1e9:	83 ec 08             	sub    $0x8,%esp
 1ec:	68 59 0e 00 00       	push   $0xe59
 1f1:	6a 01                	push   $0x1
 1f3:	e8 a3 08 00 00       	call   a9b <printf>
 1f8:	83 c4 10             	add    $0x10,%esp
 1fb:	eb 12                	jmp    20f <print_mode+0x20f>
  else
    printf(1, "-");
 1fd:	83 ec 08             	sub    $0x8,%esp
 200:	68 53 0e 00 00       	push   $0xe53
 205:	6a 01                	push   $0x1
 207:	e8 8f 08 00 00       	call   a9b <printf>
 20c:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_w)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 216:	83 e0 02             	and    $0x2,%eax
 219:	84 c0                	test   %al,%al
 21b:	74 14                	je     231 <print_mode+0x231>
    printf(1, "w");
 21d:	83 ec 08             	sub    $0x8,%esp
 220:	68 5b 0e 00 00       	push   $0xe5b
 225:	6a 01                	push   $0x1
 227:	e8 6f 08 00 00       	call   a9b <printf>
 22c:	83 c4 10             	add    $0x10,%esp
 22f:	eb 12                	jmp    243 <print_mode+0x243>
  else
    printf(1, "-");
 231:	83 ec 08             	sub    $0x8,%esp
 234:	68 53 0e 00 00       	push   $0xe53
 239:	6a 01                	push   $0x1
 23b:	e8 5b 08 00 00       	call   a9b <printf>
 240:	83 c4 10             	add    $0x10,%esp

  if (st->mode.flags.o_x)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 40 14          	movzbl 0x14(%eax),%eax
 24a:	83 e0 01             	and    $0x1,%eax
 24d:	84 c0                	test   %al,%al
 24f:	74 14                	je     265 <print_mode+0x265>
    printf(1, "x");
 251:	83 ec 08             	sub    $0x8,%esp
 254:	68 5f 0e 00 00       	push   $0xe5f
 259:	6a 01                	push   $0x1
 25b:	e8 3b 08 00 00       	call   a9b <printf>
 260:	83 c4 10             	add    $0x10,%esp
  else
    printf(1, "-");

  return;
 263:	eb 13                	jmp    278 <print_mode+0x278>
    printf(1, "-");

  if (st->mode.flags.o_x)
    printf(1, "x");
  else
    printf(1, "-");
 265:	83 ec 08             	sub    $0x8,%esp
 268:	68 53 0e 00 00       	push   $0xe53
 26d:	6a 01                	push   $0x1
 26f:	e8 27 08 00 00       	call   a9b <printf>
 274:	83 c4 10             	add    $0x10,%esp

  return;
 277:	90                   	nop
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <fmtname>:
#include "print_mode.c"
#endif

char*
fmtname(char *path)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	53                   	push   %ebx
 27e:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
 281:	83 ec 0c             	sub    $0xc,%esp
 284:	ff 75 08             	pushl  0x8(%ebp)
 287:	e8 31 04 00 00       	call   6bd <strlen>
 28c:	83 c4 10             	add    $0x10,%esp
 28f:	89 c2                	mov    %eax,%edx
 291:	8b 45 08             	mov    0x8(%ebp),%eax
 294:	01 d0                	add    %edx,%eax
 296:	89 45 f4             	mov    %eax,-0xc(%ebp)
 299:	eb 04                	jmp    29f <fmtname+0x25>
 29b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a2:	3b 45 08             	cmp    0x8(%ebp),%eax
 2a5:	72 0a                	jb     2b1 <fmtname+0x37>
 2a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2aa:	0f b6 00             	movzbl (%eax),%eax
 2ad:	3c 2f                	cmp    $0x2f,%al
 2af:	75 ea                	jne    29b <fmtname+0x21>
    ;
  p++;
 2b1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
 2b5:	83 ec 0c             	sub    $0xc,%esp
 2b8:	ff 75 f4             	pushl  -0xc(%ebp)
 2bb:	e8 fd 03 00 00       	call   6bd <strlen>
 2c0:	83 c4 10             	add    $0x10,%esp
 2c3:	83 f8 0d             	cmp    $0xd,%eax
 2c6:	76 05                	jbe    2cd <fmtname+0x53>
    return p;
 2c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cb:	eb 60                	jmp    32d <fmtname+0xb3>
  memmove(buf, p, strlen(p));
 2cd:	83 ec 0c             	sub    $0xc,%esp
 2d0:	ff 75 f4             	pushl  -0xc(%ebp)
 2d3:	e8 e5 03 00 00       	call   6bd <strlen>
 2d8:	83 c4 10             	add    $0x10,%esp
 2db:	83 ec 04             	sub    $0x4,%esp
 2de:	50                   	push   %eax
 2df:	ff 75 f4             	pushl  -0xc(%ebp)
 2e2:	68 00 12 00 00       	push   $0x1200
 2e7:	e8 93 05 00 00       	call   87f <memmove>
 2ec:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
 2ef:	83 ec 0c             	sub    $0xc,%esp
 2f2:	ff 75 f4             	pushl  -0xc(%ebp)
 2f5:	e8 c3 03 00 00       	call   6bd <strlen>
 2fa:	83 c4 10             	add    $0x10,%esp
 2fd:	ba 0e 00 00 00       	mov    $0xe,%edx
 302:	89 d3                	mov    %edx,%ebx
 304:	29 c3                	sub    %eax,%ebx
 306:	83 ec 0c             	sub    $0xc,%esp
 309:	ff 75 f4             	pushl  -0xc(%ebp)
 30c:	e8 ac 03 00 00       	call   6bd <strlen>
 311:	83 c4 10             	add    $0x10,%esp
 314:	05 00 12 00 00       	add    $0x1200,%eax
 319:	83 ec 04             	sub    $0x4,%esp
 31c:	53                   	push   %ebx
 31d:	6a 20                	push   $0x20
 31f:	50                   	push   %eax
 320:	e8 bf 03 00 00       	call   6e4 <memset>
 325:	83 c4 10             	add    $0x10,%esp
  return buf;
 328:	b8 00 12 00 00       	mov    $0x1200,%eax
}
 32d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <printheader>:

#ifdef CS333_P5
void
printheader()
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 08             	sub    $0x8,%esp
  printf(1, "%s	   %s		  %s	%s		%s		%s\n", "mode", "name", "uid", "gid", "inode", "size");
 338:	68 61 0e 00 00       	push   $0xe61
 33d:	68 66 0e 00 00       	push   $0xe66
 342:	68 6c 0e 00 00       	push   $0xe6c
 347:	68 70 0e 00 00       	push   $0xe70
 34c:	68 74 0e 00 00       	push   $0xe74
 351:	68 79 0e 00 00       	push   $0xe79
 356:	68 7e 0e 00 00       	push   $0xe7e
 35b:	6a 01                	push   $0x1
 35d:	e8 39 07 00 00       	call   a9b <printf>
 362:	83 c4 20             	add    $0x20,%esp
}
 365:	90                   	nop
 366:	c9                   	leave  
 367:	c3                   	ret    

00000368 <doprint>:

void
doprint(char* toprint, struct stat* st)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	57                   	push   %edi
 36c:	56                   	push   %esi
 36d:	53                   	push   %ebx
 36e:	83 ec 1c             	sub    $0x1c,%esp
    printf(1, " %s %d	%d		%d		%d\n", fmtname(toprint), st->uid, st->gid, st->ino, st->size);
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	8b 40 18             	mov    0x18(%eax),%eax
 377:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	8b 78 08             	mov    0x8(%eax),%edi
 380:	8b 45 0c             	mov    0xc(%ebp),%eax
 383:	0f b7 40 10          	movzwl 0x10(%eax),%eax
 387:	0f b7 f0             	movzwl %ax,%esi
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	0f b7 40 0e          	movzwl 0xe(%eax),%eax
 391:	0f b7 d8             	movzwl %ax,%ebx
 394:	83 ec 0c             	sub    $0xc,%esp
 397:	ff 75 08             	pushl  0x8(%ebp)
 39a:	e8 db fe ff ff       	call   27a <fmtname>
 39f:	83 c4 10             	add    $0x10,%esp
 3a2:	83 ec 04             	sub    $0x4,%esp
 3a5:	ff 75 e4             	pushl  -0x1c(%ebp)
 3a8:	57                   	push   %edi
 3a9:	56                   	push   %esi
 3aa:	53                   	push   %ebx
 3ab:	50                   	push   %eax
 3ac:	68 99 0e 00 00       	push   $0xe99
 3b1:	6a 01                	push   $0x1
 3b3:	e8 e3 06 00 00       	call   a9b <printf>
 3b8:	83 c4 20             	add    $0x20,%esp
}
 3bb:	90                   	nop
 3bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3bf:	5b                   	pop    %ebx
 3c0:	5e                   	pop    %esi
 3c1:	5f                   	pop    %edi
 3c2:	5d                   	pop    %ebp
 3c3:	c3                   	ret    

000003c4 <ls>:
#endif

void
ls(char *path)
{
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	81 ec 48 02 00 00    	sub    $0x248,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
 3cd:	83 ec 08             	sub    $0x8,%esp
 3d0:	6a 00                	push   $0x0
 3d2:	ff 75 08             	pushl  0x8(%ebp)
 3d5:	e8 2a 05 00 00       	call   904 <open>
 3da:	83 c4 10             	add    $0x10,%esp
 3dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3e4:	79 1a                	jns    400 <ls+0x3c>
    printf(2, "ls: cannot open %s\n", path);
 3e6:	83 ec 04             	sub    $0x4,%esp
 3e9:	ff 75 08             	pushl  0x8(%ebp)
 3ec:	68 ac 0e 00 00       	push   $0xeac
 3f1:	6a 02                	push   $0x2
 3f3:	e8 a3 06 00 00       	call   a9b <printf>
 3f8:	83 c4 10             	add    $0x10,%esp
    return;
 3fb:	e9 c2 01 00 00       	jmp    5c2 <ls+0x1fe>
  }
  
  if(fstat(fd, &st) < 0){
 400:	83 ec 08             	sub    $0x8,%esp
 403:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 409:	50                   	push   %eax
 40a:	ff 75 f4             	pushl  -0xc(%ebp)
 40d:	e8 0a 05 00 00       	call   91c <fstat>
 412:	83 c4 10             	add    $0x10,%esp
 415:	85 c0                	test   %eax,%eax
 417:	79 28                	jns    441 <ls+0x7d>
    printf(2, "ls: cannot stat %s\n", path);
 419:	83 ec 04             	sub    $0x4,%esp
 41c:	ff 75 08             	pushl  0x8(%ebp)
 41f:	68 c0 0e 00 00       	push   $0xec0
 424:	6a 02                	push   $0x2
 426:	e8 70 06 00 00       	call   a9b <printf>
 42b:	83 c4 10             	add    $0x10,%esp
    close(fd);
 42e:	83 ec 0c             	sub    $0xc,%esp
 431:	ff 75 f4             	pushl  -0xc(%ebp)
 434:	e8 b3 04 00 00       	call   8ec <close>
 439:	83 c4 10             	add    $0x10,%esp
    return;
 43c:	e9 81 01 00 00       	jmp    5c2 <ls+0x1fe>
  }

  #ifdef CS333_P5
  printheader();
 441:	e8 ec fe ff ff       	call   332 <printheader>
  #endif

  switch(st.type){
 446:	0f b7 85 c4 fd ff ff 	movzwl -0x23c(%ebp),%eax
 44d:	98                   	cwtl   
 44e:	83 f8 01             	cmp    $0x1,%eax
 451:	74 35                	je     488 <ls+0xc4>
 453:	83 f8 02             	cmp    $0x2,%eax
 456:	0f 85 58 01 00 00    	jne    5b4 <ls+0x1f0>
  case T_FILE:
    #ifdef CS333_P5
	print_mode(&st);
 45c:	83 ec 0c             	sub    $0xc,%esp
 45f:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 465:	50                   	push   %eax
 466:	e8 95 fb ff ff       	call   0 <print_mode>
 46b:	83 c4 10             	add    $0x10,%esp
    doprint(path, &st);
 46e:	83 ec 08             	sub    $0x8,%esp
 471:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 477:	50                   	push   %eax
 478:	ff 75 08             	pushl  0x8(%ebp)
 47b:	e8 e8 fe ff ff       	call   368 <doprint>
 480:	83 c4 10             	add    $0x10,%esp
    #else
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
    #endif
    break;
 483:	e9 2c 01 00 00       	jmp    5b4 <ls+0x1f0>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 488:	83 ec 0c             	sub    $0xc,%esp
 48b:	ff 75 08             	pushl  0x8(%ebp)
 48e:	e8 2a 02 00 00       	call   6bd <strlen>
 493:	83 c4 10             	add    $0x10,%esp
 496:	83 c0 10             	add    $0x10,%eax
 499:	3d 00 02 00 00       	cmp    $0x200,%eax
 49e:	76 17                	jbe    4b7 <ls+0xf3>
      printf(1, "ls: path too long\n");
 4a0:	83 ec 08             	sub    $0x8,%esp
 4a3:	68 d4 0e 00 00       	push   $0xed4
 4a8:	6a 01                	push   $0x1
 4aa:	e8 ec 05 00 00       	call   a9b <printf>
 4af:	83 c4 10             	add    $0x10,%esp
      break;
 4b2:	e9 fd 00 00 00       	jmp    5b4 <ls+0x1f0>
    }
    strcpy(buf, path);
 4b7:	83 ec 08             	sub    $0x8,%esp
 4ba:	ff 75 08             	pushl  0x8(%ebp)
 4bd:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
 4c3:	50                   	push   %eax
 4c4:	e8 85 01 00 00       	call   64e <strcpy>
 4c9:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 4cc:	83 ec 0c             	sub    $0xc,%esp
 4cf:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
 4d5:	50                   	push   %eax
 4d6:	e8 e2 01 00 00       	call   6bd <strlen>
 4db:	83 c4 10             	add    $0x10,%esp
 4de:	89 c2                	mov    %eax,%edx
 4e0:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
 4e6:	01 d0                	add    %edx,%eax
 4e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    *p++ = '/';
 4eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4ee:	8d 50 01             	lea    0x1(%eax),%edx
 4f1:	89 55 f0             	mov    %edx,-0x10(%ebp)
 4f4:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 4f7:	e9 97 00 00 00       	jmp    593 <ls+0x1cf>
      if(de.inum == 0)
 4fc:	0f b7 85 e0 fd ff ff 	movzwl -0x220(%ebp),%eax
 503:	66 85 c0             	test   %ax,%ax
 506:	75 05                	jne    50d <ls+0x149>
        continue;
 508:	e9 86 00 00 00       	jmp    593 <ls+0x1cf>
      memmove(p, de.name, DIRSIZ);
 50d:	83 ec 04             	sub    $0x4,%esp
 510:	6a 0e                	push   $0xe
 512:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 518:	83 c0 02             	add    $0x2,%eax
 51b:	50                   	push   %eax
 51c:	ff 75 f0             	pushl  -0x10(%ebp)
 51f:	e8 5b 03 00 00       	call   87f <memmove>
 524:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 527:	8b 45 f0             	mov    -0x10(%ebp),%eax
 52a:	83 c0 0e             	add    $0xe,%eax
 52d:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 530:	83 ec 08             	sub    $0x8,%esp
 533:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 539:	50                   	push   %eax
 53a:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
 540:	50                   	push   %eax
 541:	e8 5a 02 00 00       	call   7a0 <stat>
 546:	83 c4 10             	add    $0x10,%esp
 549:	85 c0                	test   %eax,%eax
 54b:	79 1b                	jns    568 <ls+0x1a4>
        printf(1, "ls: cannot stat %s\n", buf);
 54d:	83 ec 04             	sub    $0x4,%esp
 550:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
 556:	50                   	push   %eax
 557:	68 c0 0e 00 00       	push   $0xec0
 55c:	6a 01                	push   $0x1
 55e:	e8 38 05 00 00       	call   a9b <printf>
 563:	83 c4 10             	add    $0x10,%esp
        continue;
 566:	eb 2b                	jmp    593 <ls+0x1cf>
      }
      #ifdef CS333_P5
	  print_mode(&st);
 568:	83 ec 0c             	sub    $0xc,%esp
 56b:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 571:	50                   	push   %eax
 572:	e8 89 fa ff ff       	call   0 <print_mode>
 577:	83 c4 10             	add    $0x10,%esp
      doprint(buf, &st);
 57a:	83 ec 08             	sub    $0x8,%esp
 57d:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 583:	50                   	push   %eax
 584:	8d 85 f0 fd ff ff    	lea    -0x210(%ebp),%eax
 58a:	50                   	push   %eax
 58b:	e8 d8 fd ff ff       	call   368 <doprint>
 590:	83 c4 10             	add    $0x10,%esp
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 593:	83 ec 04             	sub    $0x4,%esp
 596:	6a 10                	push   $0x10
 598:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 59e:	50                   	push   %eax
 59f:	ff 75 f4             	pushl  -0xc(%ebp)
 5a2:	e8 35 03 00 00       	call   8dc <read>
 5a7:	83 c4 10             	add    $0x10,%esp
 5aa:	83 f8 10             	cmp    $0x10,%eax
 5ad:	0f 84 49 ff ff ff    	je     4fc <ls+0x138>
      doprint(buf, &st);
      #else
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
      #endif
    }
    break;
 5b3:	90                   	nop
  }
  close(fd);
 5b4:	83 ec 0c             	sub    $0xc,%esp
 5b7:	ff 75 f4             	pushl  -0xc(%ebp)
 5ba:	e8 2d 03 00 00       	call   8ec <close>
 5bf:	83 c4 10             	add    $0x10,%esp
}
 5c2:	c9                   	leave  
 5c3:	c3                   	ret    

000005c4 <main>:

int
main(int argc, char *argv[])
{
 5c4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 5c8:	83 e4 f0             	and    $0xfffffff0,%esp
 5cb:	ff 71 fc             	pushl  -0x4(%ecx)
 5ce:	55                   	push   %ebp
 5cf:	89 e5                	mov    %esp,%ebp
 5d1:	53                   	push   %ebx
 5d2:	51                   	push   %ecx
 5d3:	83 ec 10             	sub    $0x10,%esp
 5d6:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 5d8:	83 3b 01             	cmpl   $0x1,(%ebx)
 5db:	7f 15                	jg     5f2 <main+0x2e>
    ls(".");
 5dd:	83 ec 0c             	sub    $0xc,%esp
 5e0:	68 e7 0e 00 00       	push   $0xee7
 5e5:	e8 da fd ff ff       	call   3c4 <ls>
 5ea:	83 c4 10             	add    $0x10,%esp
    exit();
 5ed:	e8 d2 02 00 00       	call   8c4 <exit>
  }
  for(i=1; i<argc; i++)
 5f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 5f9:	eb 21                	jmp    61c <main+0x58>
    ls(argv[i]);
 5fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 605:	8b 43 04             	mov    0x4(%ebx),%eax
 608:	01 d0                	add    %edx,%eax
 60a:	8b 00                	mov    (%eax),%eax
 60c:	83 ec 0c             	sub    $0xc,%esp
 60f:	50                   	push   %eax
 610:	e8 af fd ff ff       	call   3c4 <ls>
 615:	83 c4 10             	add    $0x10,%esp

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 618:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 61c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 61f:	3b 03                	cmp    (%ebx),%eax
 621:	7c d8                	jl     5fb <main+0x37>
    ls(argv[i]);
  exit();
 623:	e8 9c 02 00 00       	call   8c4 <exit>

00000628 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 628:	55                   	push   %ebp
 629:	89 e5                	mov    %esp,%ebp
 62b:	57                   	push   %edi
 62c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 62d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 630:	8b 55 10             	mov    0x10(%ebp),%edx
 633:	8b 45 0c             	mov    0xc(%ebp),%eax
 636:	89 cb                	mov    %ecx,%ebx
 638:	89 df                	mov    %ebx,%edi
 63a:	89 d1                	mov    %edx,%ecx
 63c:	fc                   	cld    
 63d:	f3 aa                	rep stos %al,%es:(%edi)
 63f:	89 ca                	mov    %ecx,%edx
 641:	89 fb                	mov    %edi,%ebx
 643:	89 5d 08             	mov    %ebx,0x8(%ebp)
 646:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 649:	90                   	nop
 64a:	5b                   	pop    %ebx
 64b:	5f                   	pop    %edi
 64c:	5d                   	pop    %ebp
 64d:	c3                   	ret    

0000064e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 64e:	55                   	push   %ebp
 64f:	89 e5                	mov    %esp,%ebp
 651:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 65a:	90                   	nop
 65b:	8b 45 08             	mov    0x8(%ebp),%eax
 65e:	8d 50 01             	lea    0x1(%eax),%edx
 661:	89 55 08             	mov    %edx,0x8(%ebp)
 664:	8b 55 0c             	mov    0xc(%ebp),%edx
 667:	8d 4a 01             	lea    0x1(%edx),%ecx
 66a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 66d:	0f b6 12             	movzbl (%edx),%edx
 670:	88 10                	mov    %dl,(%eax)
 672:	0f b6 00             	movzbl (%eax),%eax
 675:	84 c0                	test   %al,%al
 677:	75 e2                	jne    65b <strcpy+0xd>
    ;
  return os;
 679:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 67c:	c9                   	leave  
 67d:	c3                   	ret    

0000067e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 67e:	55                   	push   %ebp
 67f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 681:	eb 08                	jmp    68b <strcmp+0xd>
    p++, q++;
 683:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 687:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	0f b6 00             	movzbl (%eax),%eax
 691:	84 c0                	test   %al,%al
 693:	74 10                	je     6a5 <strcmp+0x27>
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	0f b6 10             	movzbl (%eax),%edx
 69b:	8b 45 0c             	mov    0xc(%ebp),%eax
 69e:	0f b6 00             	movzbl (%eax),%eax
 6a1:	38 c2                	cmp    %al,%dl
 6a3:	74 de                	je     683 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 6a5:	8b 45 08             	mov    0x8(%ebp),%eax
 6a8:	0f b6 00             	movzbl (%eax),%eax
 6ab:	0f b6 d0             	movzbl %al,%edx
 6ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b1:	0f b6 00             	movzbl (%eax),%eax
 6b4:	0f b6 c0             	movzbl %al,%eax
 6b7:	29 c2                	sub    %eax,%edx
 6b9:	89 d0                	mov    %edx,%eax
}
 6bb:	5d                   	pop    %ebp
 6bc:	c3                   	ret    

000006bd <strlen>:

uint
strlen(char *s)
{
 6bd:	55                   	push   %ebp
 6be:	89 e5                	mov    %esp,%ebp
 6c0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 6c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 6ca:	eb 04                	jmp    6d0 <strlen+0x13>
 6cc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 6d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	01 d0                	add    %edx,%eax
 6d8:	0f b6 00             	movzbl (%eax),%eax
 6db:	84 c0                	test   %al,%al
 6dd:	75 ed                	jne    6cc <strlen+0xf>
    ;
  return n;
 6df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6e2:	c9                   	leave  
 6e3:	c3                   	ret    

000006e4 <memset>:

void*
memset(void *dst, int c, uint n)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 6e7:	8b 45 10             	mov    0x10(%ebp),%eax
 6ea:	50                   	push   %eax
 6eb:	ff 75 0c             	pushl  0xc(%ebp)
 6ee:	ff 75 08             	pushl  0x8(%ebp)
 6f1:	e8 32 ff ff ff       	call   628 <stosb>
 6f6:	83 c4 0c             	add    $0xc,%esp
  return dst;
 6f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6fc:	c9                   	leave  
 6fd:	c3                   	ret    

000006fe <strchr>:

char*
strchr(const char *s, char c)
{
 6fe:	55                   	push   %ebp
 6ff:	89 e5                	mov    %esp,%ebp
 701:	83 ec 04             	sub    $0x4,%esp
 704:	8b 45 0c             	mov    0xc(%ebp),%eax
 707:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 70a:	eb 14                	jmp    720 <strchr+0x22>
    if(*s == c)
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	0f b6 00             	movzbl (%eax),%eax
 712:	3a 45 fc             	cmp    -0x4(%ebp),%al
 715:	75 05                	jne    71c <strchr+0x1e>
      return (char*)s;
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	eb 13                	jmp    72f <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 71c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 720:	8b 45 08             	mov    0x8(%ebp),%eax
 723:	0f b6 00             	movzbl (%eax),%eax
 726:	84 c0                	test   %al,%al
 728:	75 e2                	jne    70c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 72a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 72f:	c9                   	leave  
 730:	c3                   	ret    

00000731 <gets>:

char*
gets(char *buf, int max)
{
 731:	55                   	push   %ebp
 732:	89 e5                	mov    %esp,%ebp
 734:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 737:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 73e:	eb 42                	jmp    782 <gets+0x51>
    cc = read(0, &c, 1);
 740:	83 ec 04             	sub    $0x4,%esp
 743:	6a 01                	push   $0x1
 745:	8d 45 ef             	lea    -0x11(%ebp),%eax
 748:	50                   	push   %eax
 749:	6a 00                	push   $0x0
 74b:	e8 8c 01 00 00       	call   8dc <read>
 750:	83 c4 10             	add    $0x10,%esp
 753:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 756:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75a:	7e 33                	jle    78f <gets+0x5e>
      break;
    buf[i++] = c;
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8d 50 01             	lea    0x1(%eax),%edx
 762:	89 55 f4             	mov    %edx,-0xc(%ebp)
 765:	89 c2                	mov    %eax,%edx
 767:	8b 45 08             	mov    0x8(%ebp),%eax
 76a:	01 c2                	add    %eax,%edx
 76c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 770:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 772:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 776:	3c 0a                	cmp    $0xa,%al
 778:	74 16                	je     790 <gets+0x5f>
 77a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 77e:	3c 0d                	cmp    $0xd,%al
 780:	74 0e                	je     790 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 782:	8b 45 f4             	mov    -0xc(%ebp),%eax
 785:	83 c0 01             	add    $0x1,%eax
 788:	3b 45 0c             	cmp    0xc(%ebp),%eax
 78b:	7c b3                	jl     740 <gets+0xf>
 78d:	eb 01                	jmp    790 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 78f:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 790:	8b 55 f4             	mov    -0xc(%ebp),%edx
 793:	8b 45 08             	mov    0x8(%ebp),%eax
 796:	01 d0                	add    %edx,%eax
 798:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 79b:	8b 45 08             	mov    0x8(%ebp),%eax
}
 79e:	c9                   	leave  
 79f:	c3                   	ret    

000007a0 <stat>:

int
stat(char *n, struct stat *st)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7a6:	83 ec 08             	sub    $0x8,%esp
 7a9:	6a 00                	push   $0x0
 7ab:	ff 75 08             	pushl  0x8(%ebp)
 7ae:	e8 51 01 00 00       	call   904 <open>
 7b3:	83 c4 10             	add    $0x10,%esp
 7b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7bd:	79 07                	jns    7c6 <stat+0x26>
    return -1;
 7bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7c4:	eb 25                	jmp    7eb <stat+0x4b>
  r = fstat(fd, st);
 7c6:	83 ec 08             	sub    $0x8,%esp
 7c9:	ff 75 0c             	pushl  0xc(%ebp)
 7cc:	ff 75 f4             	pushl  -0xc(%ebp)
 7cf:	e8 48 01 00 00       	call   91c <fstat>
 7d4:	83 c4 10             	add    $0x10,%esp
 7d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7da:	83 ec 0c             	sub    $0xc,%esp
 7dd:	ff 75 f4             	pushl  -0xc(%ebp)
 7e0:	e8 07 01 00 00       	call   8ec <close>
 7e5:	83 c4 10             	add    $0x10,%esp
  return r;
 7e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7eb:	c9                   	leave  
 7ec:	c3                   	ret    

000007ed <atoi>:

int
atoi(const char *s)
{
 7ed:	55                   	push   %ebp
 7ee:	89 e5                	mov    %esp,%ebp
 7f0:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 7f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 7fa:	eb 04                	jmp    800 <atoi+0x13>
 7fc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	0f b6 00             	movzbl (%eax),%eax
 806:	3c 20                	cmp    $0x20,%al
 808:	74 f2                	je     7fc <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 80a:	8b 45 08             	mov    0x8(%ebp),%eax
 80d:	0f b6 00             	movzbl (%eax),%eax
 810:	3c 2d                	cmp    $0x2d,%al
 812:	75 07                	jne    81b <atoi+0x2e>
 814:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 819:	eb 05                	jmp    820 <atoi+0x33>
 81b:	b8 01 00 00 00       	mov    $0x1,%eax
 820:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 823:	8b 45 08             	mov    0x8(%ebp),%eax
 826:	0f b6 00             	movzbl (%eax),%eax
 829:	3c 2b                	cmp    $0x2b,%al
 82b:	74 0a                	je     837 <atoi+0x4a>
 82d:	8b 45 08             	mov    0x8(%ebp),%eax
 830:	0f b6 00             	movzbl (%eax),%eax
 833:	3c 2d                	cmp    $0x2d,%al
 835:	75 2b                	jne    862 <atoi+0x75>
    s++;
 837:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 83b:	eb 25                	jmp    862 <atoi+0x75>
    n = n*10 + *s++ - '0';
 83d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 840:	89 d0                	mov    %edx,%eax
 842:	c1 e0 02             	shl    $0x2,%eax
 845:	01 d0                	add    %edx,%eax
 847:	01 c0                	add    %eax,%eax
 849:	89 c1                	mov    %eax,%ecx
 84b:	8b 45 08             	mov    0x8(%ebp),%eax
 84e:	8d 50 01             	lea    0x1(%eax),%edx
 851:	89 55 08             	mov    %edx,0x8(%ebp)
 854:	0f b6 00             	movzbl (%eax),%eax
 857:	0f be c0             	movsbl %al,%eax
 85a:	01 c8                	add    %ecx,%eax
 85c:	83 e8 30             	sub    $0x30,%eax
 85f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 862:	8b 45 08             	mov    0x8(%ebp),%eax
 865:	0f b6 00             	movzbl (%eax),%eax
 868:	3c 2f                	cmp    $0x2f,%al
 86a:	7e 0a                	jle    876 <atoi+0x89>
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
 86f:	0f b6 00             	movzbl (%eax),%eax
 872:	3c 39                	cmp    $0x39,%al
 874:	7e c7                	jle    83d <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 876:	8b 45 f8             	mov    -0x8(%ebp),%eax
 879:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 87d:	c9                   	leave  
 87e:	c3                   	ret    

0000087f <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 87f:	55                   	push   %ebp
 880:	89 e5                	mov    %esp,%ebp
 882:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 885:	8b 45 08             	mov    0x8(%ebp),%eax
 888:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 88b:	8b 45 0c             	mov    0xc(%ebp),%eax
 88e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 891:	eb 17                	jmp    8aa <memmove+0x2b>
    *dst++ = *src++;
 893:	8b 45 fc             	mov    -0x4(%ebp),%eax
 896:	8d 50 01             	lea    0x1(%eax),%edx
 899:	89 55 fc             	mov    %edx,-0x4(%ebp)
 89c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 89f:	8d 4a 01             	lea    0x1(%edx),%ecx
 8a2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 8a5:	0f b6 12             	movzbl (%edx),%edx
 8a8:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8aa:	8b 45 10             	mov    0x10(%ebp),%eax
 8ad:	8d 50 ff             	lea    -0x1(%eax),%edx
 8b0:	89 55 10             	mov    %edx,0x10(%ebp)
 8b3:	85 c0                	test   %eax,%eax
 8b5:	7f dc                	jg     893 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8ba:	c9                   	leave  
 8bb:	c3                   	ret    

000008bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8bc:	b8 01 00 00 00       	mov    $0x1,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <exit>:
SYSCALL(exit)
 8c4:	b8 02 00 00 00       	mov    $0x2,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <wait>:
SYSCALL(wait)
 8cc:	b8 03 00 00 00       	mov    $0x3,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <pipe>:
SYSCALL(pipe)
 8d4:	b8 04 00 00 00       	mov    $0x4,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <read>:
SYSCALL(read)
 8dc:	b8 05 00 00 00       	mov    $0x5,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <write>:
SYSCALL(write)
 8e4:	b8 10 00 00 00       	mov    $0x10,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <close>:
SYSCALL(close)
 8ec:	b8 15 00 00 00       	mov    $0x15,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <kill>:
SYSCALL(kill)
 8f4:	b8 06 00 00 00       	mov    $0x6,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <exec>:
SYSCALL(exec)
 8fc:	b8 07 00 00 00       	mov    $0x7,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <open>:
SYSCALL(open)
 904:	b8 0f 00 00 00       	mov    $0xf,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <mknod>:
SYSCALL(mknod)
 90c:	b8 11 00 00 00       	mov    $0x11,%eax
 911:	cd 40                	int    $0x40
 913:	c3                   	ret    

00000914 <unlink>:
SYSCALL(unlink)
 914:	b8 12 00 00 00       	mov    $0x12,%eax
 919:	cd 40                	int    $0x40
 91b:	c3                   	ret    

0000091c <fstat>:
SYSCALL(fstat)
 91c:	b8 08 00 00 00       	mov    $0x8,%eax
 921:	cd 40                	int    $0x40
 923:	c3                   	ret    

00000924 <link>:
SYSCALL(link)
 924:	b8 13 00 00 00       	mov    $0x13,%eax
 929:	cd 40                	int    $0x40
 92b:	c3                   	ret    

0000092c <mkdir>:
SYSCALL(mkdir)
 92c:	b8 14 00 00 00       	mov    $0x14,%eax
 931:	cd 40                	int    $0x40
 933:	c3                   	ret    

00000934 <chdir>:
SYSCALL(chdir)
 934:	b8 09 00 00 00       	mov    $0x9,%eax
 939:	cd 40                	int    $0x40
 93b:	c3                   	ret    

0000093c <dup>:
SYSCALL(dup)
 93c:	b8 0a 00 00 00       	mov    $0xa,%eax
 941:	cd 40                	int    $0x40
 943:	c3                   	ret    

00000944 <getpid>:
SYSCALL(getpid)
 944:	b8 0b 00 00 00       	mov    $0xb,%eax
 949:	cd 40                	int    $0x40
 94b:	c3                   	ret    

0000094c <sbrk>:
SYSCALL(sbrk)
 94c:	b8 0c 00 00 00       	mov    $0xc,%eax
 951:	cd 40                	int    $0x40
 953:	c3                   	ret    

00000954 <sleep>:
SYSCALL(sleep)
 954:	b8 0d 00 00 00       	mov    $0xd,%eax
 959:	cd 40                	int    $0x40
 95b:	c3                   	ret    

0000095c <uptime>:
SYSCALL(uptime)
 95c:	b8 0e 00 00 00       	mov    $0xe,%eax
 961:	cd 40                	int    $0x40
 963:	c3                   	ret    

00000964 <halt>:
SYSCALL(halt)
 964:	b8 16 00 00 00       	mov    $0x16,%eax
 969:	cd 40                	int    $0x40
 96b:	c3                   	ret    

0000096c <date>:
SYSCALL(date)
 96c:	b8 17 00 00 00       	mov    $0x17,%eax
 971:	cd 40                	int    $0x40
 973:	c3                   	ret    

00000974 <getuid>:
SYSCALL(getuid)
 974:	b8 18 00 00 00       	mov    $0x18,%eax
 979:	cd 40                	int    $0x40
 97b:	c3                   	ret    

0000097c <getgid>:
SYSCALL(getgid)
 97c:	b8 19 00 00 00       	mov    $0x19,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <getppid>:
SYSCALL(getppid)
 984:	b8 1a 00 00 00       	mov    $0x1a,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <setuid>:
SYSCALL(setuid)
 98c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <setgid>:
SYSCALL(setgid)
 994:	b8 1c 00 00 00       	mov    $0x1c,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <getprocs>:
SYSCALL(getprocs)
 99c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <setpriority>:
SYSCALL(setpriority)
 9a4:	b8 1e 00 00 00       	mov    $0x1e,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <chmod>:
SYSCALL(chmod)
 9ac:	b8 1f 00 00 00       	mov    $0x1f,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <chown>:
SYSCALL(chown)
 9b4:	b8 20 00 00 00       	mov    $0x20,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <chgrp>:
SYSCALL(chgrp)
 9bc:	b8 21 00 00 00       	mov    $0x21,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    

000009c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 9c4:	55                   	push   %ebp
 9c5:	89 e5                	mov    %esp,%ebp
 9c7:	83 ec 18             	sub    $0x18,%esp
 9ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 9cd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9d0:	83 ec 04             	sub    $0x4,%esp
 9d3:	6a 01                	push   $0x1
 9d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9d8:	50                   	push   %eax
 9d9:	ff 75 08             	pushl  0x8(%ebp)
 9dc:	e8 03 ff ff ff       	call   8e4 <write>
 9e1:	83 c4 10             	add    $0x10,%esp
}
 9e4:	90                   	nop
 9e5:	c9                   	leave  
 9e6:	c3                   	ret    

000009e7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9e7:	55                   	push   %ebp
 9e8:	89 e5                	mov    %esp,%ebp
 9ea:	53                   	push   %ebx
 9eb:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 9ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 9f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9f9:	74 17                	je     a12 <printint+0x2b>
 9fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9ff:	79 11                	jns    a12 <printint+0x2b>
    neg = 1;
 a01:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a08:	8b 45 0c             	mov    0xc(%ebp),%eax
 a0b:	f7 d8                	neg    %eax
 a0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a10:	eb 06                	jmp    a18 <printint+0x31>
  } else {
    x = xx;
 a12:	8b 45 0c             	mov    0xc(%ebp),%eax
 a15:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a1f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a22:	8d 41 01             	lea    0x1(%ecx),%eax
 a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a28:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a2e:	ba 00 00 00 00       	mov    $0x0,%edx
 a33:	f7 f3                	div    %ebx
 a35:	89 d0                	mov    %edx,%eax
 a37:	0f b6 80 ec 11 00 00 	movzbl 0x11ec(%eax),%eax
 a3e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a42:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a45:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a48:	ba 00 00 00 00       	mov    $0x0,%edx
 a4d:	f7 f3                	div    %ebx
 a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a56:	75 c7                	jne    a1f <printint+0x38>
  if(neg)
 a58:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a5c:	74 2d                	je     a8b <printint+0xa4>
    buf[i++] = '-';
 a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a61:	8d 50 01             	lea    0x1(%eax),%edx
 a64:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a67:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a6c:	eb 1d                	jmp    a8b <printint+0xa4>
    putc(fd, buf[i]);
 a6e:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	01 d0                	add    %edx,%eax
 a76:	0f b6 00             	movzbl (%eax),%eax
 a79:	0f be c0             	movsbl %al,%eax
 a7c:	83 ec 08             	sub    $0x8,%esp
 a7f:	50                   	push   %eax
 a80:	ff 75 08             	pushl  0x8(%ebp)
 a83:	e8 3c ff ff ff       	call   9c4 <putc>
 a88:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a8b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 a8f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a93:	79 d9                	jns    a6e <printint+0x87>
    putc(fd, buf[i]);
}
 a95:	90                   	nop
 a96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 a99:	c9                   	leave  
 a9a:	c3                   	ret    

00000a9b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a9b:	55                   	push   %ebp
 a9c:	89 e5                	mov    %esp,%ebp
 a9e:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 aa1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 aa8:	8d 45 0c             	lea    0xc(%ebp),%eax
 aab:	83 c0 04             	add    $0x4,%eax
 aae:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 ab1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 ab8:	e9 59 01 00 00       	jmp    c16 <printf+0x17b>
    c = fmt[i] & 0xff;
 abd:	8b 55 0c             	mov    0xc(%ebp),%edx
 ac0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac3:	01 d0                	add    %edx,%eax
 ac5:	0f b6 00             	movzbl (%eax),%eax
 ac8:	0f be c0             	movsbl %al,%eax
 acb:	25 ff 00 00 00       	and    $0xff,%eax
 ad0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 ad3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ad7:	75 2c                	jne    b05 <printf+0x6a>
      if(c == '%'){
 ad9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 add:	75 0c                	jne    aeb <printf+0x50>
        state = '%';
 adf:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 ae6:	e9 27 01 00 00       	jmp    c12 <printf+0x177>
      } else {
        putc(fd, c);
 aeb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 aee:	0f be c0             	movsbl %al,%eax
 af1:	83 ec 08             	sub    $0x8,%esp
 af4:	50                   	push   %eax
 af5:	ff 75 08             	pushl  0x8(%ebp)
 af8:	e8 c7 fe ff ff       	call   9c4 <putc>
 afd:	83 c4 10             	add    $0x10,%esp
 b00:	e9 0d 01 00 00       	jmp    c12 <printf+0x177>
      }
    } else if(state == '%'){
 b05:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b09:	0f 85 03 01 00 00    	jne    c12 <printf+0x177>
      if(c == 'd'){
 b0f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b13:	75 1e                	jne    b33 <printf+0x98>
        printint(fd, *ap, 10, 1);
 b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b18:	8b 00                	mov    (%eax),%eax
 b1a:	6a 01                	push   $0x1
 b1c:	6a 0a                	push   $0xa
 b1e:	50                   	push   %eax
 b1f:	ff 75 08             	pushl  0x8(%ebp)
 b22:	e8 c0 fe ff ff       	call   9e7 <printint>
 b27:	83 c4 10             	add    $0x10,%esp
        ap++;
 b2a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b2e:	e9 d8 00 00 00       	jmp    c0b <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 b33:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b37:	74 06                	je     b3f <printf+0xa4>
 b39:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b3d:	75 1e                	jne    b5d <printf+0xc2>
        printint(fd, *ap, 16, 0);
 b3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b42:	8b 00                	mov    (%eax),%eax
 b44:	6a 00                	push   $0x0
 b46:	6a 10                	push   $0x10
 b48:	50                   	push   %eax
 b49:	ff 75 08             	pushl  0x8(%ebp)
 b4c:	e8 96 fe ff ff       	call   9e7 <printint>
 b51:	83 c4 10             	add    $0x10,%esp
        ap++;
 b54:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b58:	e9 ae 00 00 00       	jmp    c0b <printf+0x170>
      } else if(c == 's'){
 b5d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b61:	75 43                	jne    ba6 <printf+0x10b>
        s = (char*)*ap;
 b63:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b66:	8b 00                	mov    (%eax),%eax
 b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b6b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b73:	75 25                	jne    b9a <printf+0xff>
          s = "(null)";
 b75:	c7 45 f4 e9 0e 00 00 	movl   $0xee9,-0xc(%ebp)
        while(*s != 0){
 b7c:	eb 1c                	jmp    b9a <printf+0xff>
          putc(fd, *s);
 b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b81:	0f b6 00             	movzbl (%eax),%eax
 b84:	0f be c0             	movsbl %al,%eax
 b87:	83 ec 08             	sub    $0x8,%esp
 b8a:	50                   	push   %eax
 b8b:	ff 75 08             	pushl  0x8(%ebp)
 b8e:	e8 31 fe ff ff       	call   9c4 <putc>
 b93:	83 c4 10             	add    $0x10,%esp
          s++;
 b96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9d:	0f b6 00             	movzbl (%eax),%eax
 ba0:	84 c0                	test   %al,%al
 ba2:	75 da                	jne    b7e <printf+0xe3>
 ba4:	eb 65                	jmp    c0b <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ba6:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 baa:	75 1d                	jne    bc9 <printf+0x12e>
        putc(fd, *ap);
 bac:	8b 45 e8             	mov    -0x18(%ebp),%eax
 baf:	8b 00                	mov    (%eax),%eax
 bb1:	0f be c0             	movsbl %al,%eax
 bb4:	83 ec 08             	sub    $0x8,%esp
 bb7:	50                   	push   %eax
 bb8:	ff 75 08             	pushl  0x8(%ebp)
 bbb:	e8 04 fe ff ff       	call   9c4 <putc>
 bc0:	83 c4 10             	add    $0x10,%esp
        ap++;
 bc3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bc7:	eb 42                	jmp    c0b <printf+0x170>
      } else if(c == '%'){
 bc9:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bcd:	75 17                	jne    be6 <printf+0x14b>
        putc(fd, c);
 bcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bd2:	0f be c0             	movsbl %al,%eax
 bd5:	83 ec 08             	sub    $0x8,%esp
 bd8:	50                   	push   %eax
 bd9:	ff 75 08             	pushl  0x8(%ebp)
 bdc:	e8 e3 fd ff ff       	call   9c4 <putc>
 be1:	83 c4 10             	add    $0x10,%esp
 be4:	eb 25                	jmp    c0b <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 be6:	83 ec 08             	sub    $0x8,%esp
 be9:	6a 25                	push   $0x25
 beb:	ff 75 08             	pushl  0x8(%ebp)
 bee:	e8 d1 fd ff ff       	call   9c4 <putc>
 bf3:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 bf6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bf9:	0f be c0             	movsbl %al,%eax
 bfc:	83 ec 08             	sub    $0x8,%esp
 bff:	50                   	push   %eax
 c00:	ff 75 08             	pushl  0x8(%ebp)
 c03:	e8 bc fd ff ff       	call   9c4 <putc>
 c08:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 c0b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c12:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 c16:	8b 55 0c             	mov    0xc(%ebp),%edx
 c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c1c:	01 d0                	add    %edx,%eax
 c1e:	0f b6 00             	movzbl (%eax),%eax
 c21:	84 c0                	test   %al,%al
 c23:	0f 85 94 fe ff ff    	jne    abd <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c29:	90                   	nop
 c2a:	c9                   	leave  
 c2b:	c3                   	ret    

00000c2c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c2c:	55                   	push   %ebp
 c2d:	89 e5                	mov    %esp,%ebp
 c2f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c32:	8b 45 08             	mov    0x8(%ebp),%eax
 c35:	83 e8 08             	sub    $0x8,%eax
 c38:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c3b:	a1 18 12 00 00       	mov    0x1218,%eax
 c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c43:	eb 24                	jmp    c69 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c48:	8b 00                	mov    (%eax),%eax
 c4a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c4d:	77 12                	ja     c61 <free+0x35>
 c4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c52:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c55:	77 24                	ja     c7b <free+0x4f>
 c57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5a:	8b 00                	mov    (%eax),%eax
 c5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c5f:	77 1a                	ja     c7b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c64:	8b 00                	mov    (%eax),%eax
 c66:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c6c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c6f:	76 d4                	jbe    c45 <free+0x19>
 c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c74:	8b 00                	mov    (%eax),%eax
 c76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c79:	76 ca                	jbe    c45 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7e:	8b 40 04             	mov    0x4(%eax),%eax
 c81:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c88:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8b:	01 c2                	add    %eax,%edx
 c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c90:	8b 00                	mov    (%eax),%eax
 c92:	39 c2                	cmp    %eax,%edx
 c94:	75 24                	jne    cba <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c96:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c99:	8b 50 04             	mov    0x4(%eax),%edx
 c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9f:	8b 00                	mov    (%eax),%eax
 ca1:	8b 40 04             	mov    0x4(%eax),%eax
 ca4:	01 c2                	add    %eax,%edx
 ca6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 caf:	8b 00                	mov    (%eax),%eax
 cb1:	8b 10                	mov    (%eax),%edx
 cb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb6:	89 10                	mov    %edx,(%eax)
 cb8:	eb 0a                	jmp    cc4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbd:	8b 10                	mov    (%eax),%edx
 cbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc7:	8b 40 04             	mov    0x4(%eax),%eax
 cca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd4:	01 d0                	add    %edx,%eax
 cd6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cd9:	75 20                	jne    cfb <free+0xcf>
    p->s.size += bp->s.size;
 cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cde:	8b 50 04             	mov    0x4(%eax),%edx
 ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce4:	8b 40 04             	mov    0x4(%eax),%eax
 ce7:	01 c2                	add    %eax,%edx
 ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cec:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf2:	8b 10                	mov    (%eax),%edx
 cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cf7:	89 10                	mov    %edx,(%eax)
 cf9:	eb 08                	jmp    d03 <free+0xd7>
  } else
    p->s.ptr = bp;
 cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d01:	89 10                	mov    %edx,(%eax)
  freep = p;
 d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d06:	a3 18 12 00 00       	mov    %eax,0x1218
}
 d0b:	90                   	nop
 d0c:	c9                   	leave  
 d0d:	c3                   	ret    

00000d0e <morecore>:

static Header*
morecore(uint nu)
{
 d0e:	55                   	push   %ebp
 d0f:	89 e5                	mov    %esp,%ebp
 d11:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d14:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d1b:	77 07                	ja     d24 <morecore+0x16>
    nu = 4096;
 d1d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d24:	8b 45 08             	mov    0x8(%ebp),%eax
 d27:	c1 e0 03             	shl    $0x3,%eax
 d2a:	83 ec 0c             	sub    $0xc,%esp
 d2d:	50                   	push   %eax
 d2e:	e8 19 fc ff ff       	call   94c <sbrk>
 d33:	83 c4 10             	add    $0x10,%esp
 d36:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d39:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d3d:	75 07                	jne    d46 <morecore+0x38>
    return 0;
 d3f:	b8 00 00 00 00       	mov    $0x0,%eax
 d44:	eb 26                	jmp    d6c <morecore+0x5e>
  hp = (Header*)p;
 d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d4f:	8b 55 08             	mov    0x8(%ebp),%edx
 d52:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d58:	83 c0 08             	add    $0x8,%eax
 d5b:	83 ec 0c             	sub    $0xc,%esp
 d5e:	50                   	push   %eax
 d5f:	e8 c8 fe ff ff       	call   c2c <free>
 d64:	83 c4 10             	add    $0x10,%esp
  return freep;
 d67:	a1 18 12 00 00       	mov    0x1218,%eax
}
 d6c:	c9                   	leave  
 d6d:	c3                   	ret    

00000d6e <malloc>:

void*
malloc(uint nbytes)
{
 d6e:	55                   	push   %ebp
 d6f:	89 e5                	mov    %esp,%ebp
 d71:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d74:	8b 45 08             	mov    0x8(%ebp),%eax
 d77:	83 c0 07             	add    $0x7,%eax
 d7a:	c1 e8 03             	shr    $0x3,%eax
 d7d:	83 c0 01             	add    $0x1,%eax
 d80:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d83:	a1 18 12 00 00       	mov    0x1218,%eax
 d88:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d8b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d8f:	75 23                	jne    db4 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 d91:	c7 45 f0 10 12 00 00 	movl   $0x1210,-0x10(%ebp)
 d98:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d9b:	a3 18 12 00 00       	mov    %eax,0x1218
 da0:	a1 18 12 00 00       	mov    0x1218,%eax
 da5:	a3 10 12 00 00       	mov    %eax,0x1210
    base.s.size = 0;
 daa:	c7 05 14 12 00 00 00 	movl   $0x0,0x1214
 db1:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 db7:	8b 00                	mov    (%eax),%eax
 db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbf:	8b 40 04             	mov    0x4(%eax),%eax
 dc2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dc5:	72 4d                	jb     e14 <malloc+0xa6>
      if(p->s.size == nunits)
 dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dca:	8b 40 04             	mov    0x4(%eax),%eax
 dcd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dd0:	75 0c                	jne    dde <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd5:	8b 10                	mov    (%eax),%edx
 dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dda:	89 10                	mov    %edx,(%eax)
 ddc:	eb 26                	jmp    e04 <malloc+0x96>
      else {
        p->s.size -= nunits;
 dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de1:	8b 40 04             	mov    0x4(%eax),%eax
 de4:	2b 45 ec             	sub    -0x14(%ebp),%eax
 de7:	89 c2                	mov    %eax,%edx
 de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dec:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 def:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df2:	8b 40 04             	mov    0x4(%eax),%eax
 df5:	c1 e0 03             	shl    $0x3,%eax
 df8:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 dfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e01:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e07:	a3 18 12 00 00       	mov    %eax,0x1218
      return (void*)(p + 1);
 e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e0f:	83 c0 08             	add    $0x8,%eax
 e12:	eb 3b                	jmp    e4f <malloc+0xe1>
    }
    if(p == freep)
 e14:	a1 18 12 00 00       	mov    0x1218,%eax
 e19:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e1c:	75 1e                	jne    e3c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 e1e:	83 ec 0c             	sub    $0xc,%esp
 e21:	ff 75 ec             	pushl  -0x14(%ebp)
 e24:	e8 e5 fe ff ff       	call   d0e <morecore>
 e29:	83 c4 10             	add    $0x10,%esp
 e2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e2f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e33:	75 07                	jne    e3c <malloc+0xce>
        return 0;
 e35:	b8 00 00 00 00       	mov    $0x0,%eax
 e3a:	eb 13                	jmp    e4f <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e45:	8b 00                	mov    (%eax),%eax
 e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e4a:	e9 6d ff ff ff       	jmp    dbc <malloc+0x4e>
}
 e4f:	c9                   	leave  
 e50:	c3                   	ret    
