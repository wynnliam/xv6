
_testsetuid:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	83 ec 10             	sub    $0x10,%esp
  12:	89 cb                	mov    %ecx,%ebx
  int rc;

  printf(1, "***** In %s: my uid is %d\n\n", argv[0], getuid());
  14:	e8 23 05 00 00       	call   53c <getuid>
  19:	89 c2                	mov    %eax,%edx
  1b:	8b 43 04             	mov    0x4(%ebx),%eax
  1e:	8b 00                	mov    (%eax),%eax
  20:	52                   	push   %edx
  21:	50                   	push   %eax
  22:	68 1c 0a 00 00       	push   $0xa1c
  27:	6a 01                	push   $0x1
  29:	e8 35 06 00 00       	call   663 <printf>
  2e:	83 c4 10             	add    $0x10,%esp
  printf(1, "***** In %s: my gid is %d\n\n", argv[0], getgid());
  31:	e8 0e 05 00 00       	call   544 <getgid>
  36:	89 c2                	mov    %eax,%edx
  38:	8b 43 04             	mov    0x4(%ebx),%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	52                   	push   %edx
  3e:	50                   	push   %eax
  3f:	68 38 0a 00 00       	push   $0xa38
  44:	6a 01                	push   $0x1
  46:	e8 18 06 00 00       	call   663 <printf>
  4b:	83 c4 10             	add    $0x10,%esp
  printf(1, "***** In %s: my ppid is %d\n\n", argv[0], getppid());
  4e:	e8 f9 04 00 00       	call   54c <getppid>
  53:	89 c2                	mov    %eax,%edx
  55:	8b 43 04             	mov    0x4(%ebx),%eax
  58:	8b 00                	mov    (%eax),%eax
  5a:	52                   	push   %edx
  5b:	50                   	push   %eax
  5c:	68 54 0a 00 00       	push   $0xa54
  61:	6a 01                	push   $0x1
  63:	e8 fb 05 00 00       	call   663 <printf>
  68:	83 c4 10             	add    $0x10,%esp

  rc = setuid(324);
  6b:	83 ec 0c             	sub    $0xc,%esp
  6e:	68 44 01 00 00       	push   $0x144
  73:	e8 dc 04 00 00       	call   554 <setuid>
  78:	83 c4 10             	add    $0x10,%esp
  7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(rc == 0)
  7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  82:	75 1a                	jne    9e <main+0x9e>
    printf(1, "New uid: %d\n", getuid());
  84:	e8 b3 04 00 00       	call   53c <getuid>
  89:	83 ec 04             	sub    $0x4,%esp
  8c:	50                   	push   %eax
  8d:	68 71 0a 00 00       	push   $0xa71
  92:	6a 01                	push   $0x1
  94:	e8 ca 05 00 00       	call   663 <printf>
  99:	83 c4 10             	add    $0x10,%esp
  9c:	eb 12                	jmp    b0 <main+0xb0>
  else
    printf(1, "Failed to set uid\n");
  9e:	83 ec 08             	sub    $0x8,%esp
  a1:	68 7e 0a 00 00       	push   $0xa7e
  a6:	6a 01                	push   $0x1
  a8:	e8 b6 05 00 00       	call   663 <printf>
  ad:	83 c4 10             	add    $0x10,%esp

  rc = setuid(-1);
  b0:	83 ec 0c             	sub    $0xc,%esp
  b3:	6a ff                	push   $0xffffffff
  b5:	e8 9a 04 00 00       	call   554 <setuid>
  ba:	83 c4 10             	add    $0x10,%esp
  bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(rc == -1)
  c0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  c4:	75 14                	jne    da <main+0xda>
    printf(1, "Successfully kept uid from being < 0!\n");
  c6:	83 ec 08             	sub    $0x8,%esp
  c9:	68 94 0a 00 00       	push   $0xa94
  ce:	6a 01                	push   $0x1
  d0:	e8 8e 05 00 00       	call   663 <printf>
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	eb 12                	jmp    ec <main+0xec>
  else
    printf(1, "Something's not right with setuid. Was able to set it to < 0\n");
  da:	83 ec 08             	sub    $0x8,%esp
  dd:	68 bc 0a 00 00       	push   $0xabc
  e2:	6a 01                	push   $0x1
  e4:	e8 7a 05 00 00       	call   663 <printf>
  e9:	83 c4 10             	add    $0x10,%esp

  rc = setuid(32768);
  ec:	83 ec 0c             	sub    $0xc,%esp
  ef:	68 00 80 00 00       	push   $0x8000
  f4:	e8 5b 04 00 00       	call   554 <setuid>
  f9:	83 c4 10             	add    $0x10,%esp
  fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(rc == -1)
  ff:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 103:	75 14                	jne    119 <main+0x119>
    printf(1, "Successfully kept uid from being > 32767!\n");
 105:	83 ec 08             	sub    $0x8,%esp
 108:	68 fc 0a 00 00       	push   $0xafc
 10d:	6a 01                	push   $0x1
 10f:	e8 4f 05 00 00       	call   663 <printf>
 114:	83 c4 10             	add    $0x10,%esp
 117:	eb 12                	jmp    12b <main+0x12b>
  else
    printf(1, "Something's not right with setuid. Was able to set it to > 32767\n");
 119:	83 ec 08             	sub    $0x8,%esp
 11c:	68 28 0b 00 00       	push   $0xb28
 121:	6a 01                	push   $0x1
 123:	e8 3b 05 00 00       	call   663 <printf>
 128:	83 c4 10             	add    $0x10,%esp

  rc = setgid(1776);
 12b:	83 ec 0c             	sub    $0xc,%esp
 12e:	68 f0 06 00 00       	push   $0x6f0
 133:	e8 24 04 00 00       	call   55c <setgid>
 138:	83 c4 10             	add    $0x10,%esp
 13b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(rc == 0)
 13e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 142:	75 1a                	jne    15e <main+0x15e>
    printf(1, "New gid: %d\n", getgid());
 144:	e8 fb 03 00 00       	call   544 <getgid>
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	50                   	push   %eax
 14d:	68 6a 0b 00 00       	push   $0xb6a
 152:	6a 01                	push   $0x1
 154:	e8 0a 05 00 00       	call   663 <printf>
 159:	83 c4 10             	add    $0x10,%esp
 15c:	eb 12                	jmp    170 <main+0x170>
  else
    printf(1, "Failed to set gid\n");
 15e:	83 ec 08             	sub    $0x8,%esp
 161:	68 77 0b 00 00       	push   $0xb77
 166:	6a 01                	push   $0x1
 168:	e8 f6 04 00 00       	call   663 <printf>
 16d:	83 c4 10             	add    $0x10,%esp

  rc = setgid(-1);
 170:	83 ec 0c             	sub    $0xc,%esp
 173:	6a ff                	push   $0xffffffff
 175:	e8 e2 03 00 00       	call   55c <setgid>
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(rc == -1)
 180:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 184:	75 14                	jne    19a <main+0x19a>
    printf(1, "Successfully kept gid from being < 0!\n");
 186:	83 ec 08             	sub    $0x8,%esp
 189:	68 8c 0b 00 00       	push   $0xb8c
 18e:	6a 01                	push   $0x1
 190:	e8 ce 04 00 00       	call   663 <printf>
 195:	83 c4 10             	add    $0x10,%esp
 198:	eb 12                	jmp    1ac <main+0x1ac>
  else
    printf(1, "Something's not right with setgid. Was able to set it to < 0\n");
 19a:	83 ec 08             	sub    $0x8,%esp
 19d:	68 b4 0b 00 00       	push   $0xbb4
 1a2:	6a 01                	push   $0x1
 1a4:	e8 ba 04 00 00       	call   663 <printf>
 1a9:	83 c4 10             	add    $0x10,%esp

  rc = setuid(32768);
 1ac:	83 ec 0c             	sub    $0xc,%esp
 1af:	68 00 80 00 00       	push   $0x8000
 1b4:	e8 9b 03 00 00       	call   554 <setuid>
 1b9:	83 c4 10             	add    $0x10,%esp
 1bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(rc == -1)
 1bf:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 1c3:	75 14                	jne    1d9 <main+0x1d9>
    printf(1, "Successfully kept gid from being > 32767!\n");
 1c5:	83 ec 08             	sub    $0x8,%esp
 1c8:	68 f4 0b 00 00       	push   $0xbf4
 1cd:	6a 01                	push   $0x1
 1cf:	e8 8f 04 00 00       	call   663 <printf>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	eb 12                	jmp    1eb <main+0x1eb>
  else
    printf(1, "Something's not right with setgid. Was able to set it to > 32767\n");
 1d9:	83 ec 08             	sub    $0x8,%esp
 1dc:	68 20 0c 00 00       	push   $0xc20
 1e1:	6a 01                	push   $0x1
 1e3:	e8 7b 04 00 00       	call   663 <printf>
 1e8:	83 c4 10             	add    $0x10,%esp

  exit();
 1eb:	e8 9c 02 00 00       	call   48c <exit>

000001f0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	57                   	push   %edi
 1f4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1f8:	8b 55 10             	mov    0x10(%ebp),%edx
 1fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fe:	89 cb                	mov    %ecx,%ebx
 200:	89 df                	mov    %ebx,%edi
 202:	89 d1                	mov    %edx,%ecx
 204:	fc                   	cld    
 205:	f3 aa                	rep stos %al,%es:(%edi)
 207:	89 ca                	mov    %ecx,%edx
 209:	89 fb                	mov    %edi,%ebx
 20b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 20e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 211:	90                   	nop
 212:	5b                   	pop    %ebx
 213:	5f                   	pop    %edi
 214:	5d                   	pop    %ebp
 215:	c3                   	ret    

00000216 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 216:	55                   	push   %ebp
 217:	89 e5                	mov    %esp,%ebp
 219:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 21c:	8b 45 08             	mov    0x8(%ebp),%eax
 21f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 222:	90                   	nop
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8d 50 01             	lea    0x1(%eax),%edx
 229:	89 55 08             	mov    %edx,0x8(%ebp)
 22c:	8b 55 0c             	mov    0xc(%ebp),%edx
 22f:	8d 4a 01             	lea    0x1(%edx),%ecx
 232:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 235:	0f b6 12             	movzbl (%edx),%edx
 238:	88 10                	mov    %dl,(%eax)
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	84 c0                	test   %al,%al
 23f:	75 e2                	jne    223 <strcpy+0xd>
    ;
  return os;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 249:	eb 08                	jmp    253 <strcmp+0xd>
    p++, q++;
 24b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 24f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	84 c0                	test   %al,%al
 25b:	74 10                	je     26d <strcmp+0x27>
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	0f b6 10             	movzbl (%eax),%edx
 263:	8b 45 0c             	mov    0xc(%ebp),%eax
 266:	0f b6 00             	movzbl (%eax),%eax
 269:	38 c2                	cmp    %al,%dl
 26b:	74 de                	je     24b <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	0f b6 d0             	movzbl %al,%edx
 276:	8b 45 0c             	mov    0xc(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	0f b6 c0             	movzbl %al,%eax
 27f:	29 c2                	sub    %eax,%edx
 281:	89 d0                	mov    %edx,%eax
}
 283:	5d                   	pop    %ebp
 284:	c3                   	ret    

00000285 <strlen>:

uint
strlen(char *s)
{
 285:	55                   	push   %ebp
 286:	89 e5                	mov    %esp,%ebp
 288:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 28b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 292:	eb 04                	jmp    298 <strlen+0x13>
 294:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 298:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	01 d0                	add    %edx,%eax
 2a0:	0f b6 00             	movzbl (%eax),%eax
 2a3:	84 c0                	test   %al,%al
 2a5:	75 ed                	jne    294 <strlen+0xf>
    ;
  return n;
 2a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 2af:	8b 45 10             	mov    0x10(%ebp),%eax
 2b2:	50                   	push   %eax
 2b3:	ff 75 0c             	pushl  0xc(%ebp)
 2b6:	ff 75 08             	pushl  0x8(%ebp)
 2b9:	e8 32 ff ff ff       	call   1f0 <stosb>
 2be:	83 c4 0c             	add    $0xc,%esp
  return dst;
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <strchr>:

char*
strchr(const char *s, char c)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 04             	sub    $0x4,%esp
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d2:	eb 14                	jmp    2e8 <strchr+0x22>
    if(*s == c)
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	0f b6 00             	movzbl (%eax),%eax
 2da:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2dd:	75 05                	jne    2e4 <strchr+0x1e>
      return (char*)s;
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	eb 13                	jmp    2f7 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e8:	8b 45 08             	mov    0x8(%ebp),%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	84 c0                	test   %al,%al
 2f0:	75 e2                	jne    2d4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <gets>:

char*
gets(char *buf, int max)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 306:	eb 42                	jmp    34a <gets+0x51>
    cc = read(0, &c, 1);
 308:	83 ec 04             	sub    $0x4,%esp
 30b:	6a 01                	push   $0x1
 30d:	8d 45 ef             	lea    -0x11(%ebp),%eax
 310:	50                   	push   %eax
 311:	6a 00                	push   $0x0
 313:	e8 8c 01 00 00       	call   4a4 <read>
 318:	83 c4 10             	add    $0x10,%esp
 31b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 31e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 322:	7e 33                	jle    357 <gets+0x5e>
      break;
    buf[i++] = c;
 324:	8b 45 f4             	mov    -0xc(%ebp),%eax
 327:	8d 50 01             	lea    0x1(%eax),%edx
 32a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 32d:	89 c2                	mov    %eax,%edx
 32f:	8b 45 08             	mov    0x8(%ebp),%eax
 332:	01 c2                	add    %eax,%edx
 334:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 338:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 33a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33e:	3c 0a                	cmp    $0xa,%al
 340:	74 16                	je     358 <gets+0x5f>
 342:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 346:	3c 0d                	cmp    $0xd,%al
 348:	74 0e                	je     358 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 34d:	83 c0 01             	add    $0x1,%eax
 350:	3b 45 0c             	cmp    0xc(%ebp),%eax
 353:	7c b3                	jl     308 <gets+0xf>
 355:	eb 01                	jmp    358 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 357:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 358:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	01 d0                	add    %edx,%eax
 360:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 363:	8b 45 08             	mov    0x8(%ebp),%eax
}
 366:	c9                   	leave  
 367:	c3                   	ret    

00000368 <stat>:

int
stat(char *n, struct stat *st)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36e:	83 ec 08             	sub    $0x8,%esp
 371:	6a 00                	push   $0x0
 373:	ff 75 08             	pushl  0x8(%ebp)
 376:	e8 51 01 00 00       	call   4cc <open>
 37b:	83 c4 10             	add    $0x10,%esp
 37e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 381:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 385:	79 07                	jns    38e <stat+0x26>
    return -1;
 387:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 38c:	eb 25                	jmp    3b3 <stat+0x4b>
  r = fstat(fd, st);
 38e:	83 ec 08             	sub    $0x8,%esp
 391:	ff 75 0c             	pushl  0xc(%ebp)
 394:	ff 75 f4             	pushl  -0xc(%ebp)
 397:	e8 48 01 00 00       	call   4e4 <fstat>
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a2:	83 ec 0c             	sub    $0xc,%esp
 3a5:	ff 75 f4             	pushl  -0xc(%ebp)
 3a8:	e8 07 01 00 00       	call   4b4 <close>
 3ad:	83 c4 10             	add    $0x10,%esp
  return r;
 3b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <atoi>:

int
atoi(const char *s)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
 3b8:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 3bb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 3c2:	eb 04                	jmp    3c8 <atoi+0x13>
 3c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	3c 20                	cmp    $0x20,%al
 3d0:	74 f2                	je     3c4 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 3d2:	8b 45 08             	mov    0x8(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	3c 2d                	cmp    $0x2d,%al
 3da:	75 07                	jne    3e3 <atoi+0x2e>
 3dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 3e1:	eb 05                	jmp    3e8 <atoi+0x33>
 3e3:	b8 01 00 00 00       	mov    $0x1,%eax
 3e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 3eb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ee:	0f b6 00             	movzbl (%eax),%eax
 3f1:	3c 2b                	cmp    $0x2b,%al
 3f3:	74 0a                	je     3ff <atoi+0x4a>
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	3c 2d                	cmp    $0x2d,%al
 3fd:	75 2b                	jne    42a <atoi+0x75>
    s++;
 3ff:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 403:	eb 25                	jmp    42a <atoi+0x75>
    n = n*10 + *s++ - '0';
 405:	8b 55 fc             	mov    -0x4(%ebp),%edx
 408:	89 d0                	mov    %edx,%eax
 40a:	c1 e0 02             	shl    $0x2,%eax
 40d:	01 d0                	add    %edx,%eax
 40f:	01 c0                	add    %eax,%eax
 411:	89 c1                	mov    %eax,%ecx
 413:	8b 45 08             	mov    0x8(%ebp),%eax
 416:	8d 50 01             	lea    0x1(%eax),%edx
 419:	89 55 08             	mov    %edx,0x8(%ebp)
 41c:	0f b6 00             	movzbl (%eax),%eax
 41f:	0f be c0             	movsbl %al,%eax
 422:	01 c8                	add    %ecx,%eax
 424:	83 e8 30             	sub    $0x30,%eax
 427:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	0f b6 00             	movzbl (%eax),%eax
 430:	3c 2f                	cmp    $0x2f,%al
 432:	7e 0a                	jle    43e <atoi+0x89>
 434:	8b 45 08             	mov    0x8(%ebp),%eax
 437:	0f b6 00             	movzbl (%eax),%eax
 43a:	3c 39                	cmp    $0x39,%al
 43c:	7e c7                	jle    405 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 43e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 441:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 445:	c9                   	leave  
 446:	c3                   	ret    

00000447 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 447:	55                   	push   %ebp
 448:	89 e5                	mov    %esp,%ebp
 44a:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 459:	eb 17                	jmp    472 <memmove+0x2b>
    *dst++ = *src++;
 45b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 45e:	8d 50 01             	lea    0x1(%eax),%edx
 461:	89 55 fc             	mov    %edx,-0x4(%ebp)
 464:	8b 55 f8             	mov    -0x8(%ebp),%edx
 467:	8d 4a 01             	lea    0x1(%edx),%ecx
 46a:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 46d:	0f b6 12             	movzbl (%edx),%edx
 470:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 472:	8b 45 10             	mov    0x10(%ebp),%eax
 475:	8d 50 ff             	lea    -0x1(%eax),%edx
 478:	89 55 10             	mov    %edx,0x10(%ebp)
 47b:	85 c0                	test   %eax,%eax
 47d:	7f dc                	jg     45b <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
}
 482:	c9                   	leave  
 483:	c3                   	ret    

00000484 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 484:	b8 01 00 00 00       	mov    $0x1,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <exit>:
SYSCALL(exit)
 48c:	b8 02 00 00 00       	mov    $0x2,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <wait>:
SYSCALL(wait)
 494:	b8 03 00 00 00       	mov    $0x3,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <pipe>:
SYSCALL(pipe)
 49c:	b8 04 00 00 00       	mov    $0x4,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <read>:
SYSCALL(read)
 4a4:	b8 05 00 00 00       	mov    $0x5,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <write>:
SYSCALL(write)
 4ac:	b8 10 00 00 00       	mov    $0x10,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <close>:
SYSCALL(close)
 4b4:	b8 15 00 00 00       	mov    $0x15,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <kill>:
SYSCALL(kill)
 4bc:	b8 06 00 00 00       	mov    $0x6,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <exec>:
SYSCALL(exec)
 4c4:	b8 07 00 00 00       	mov    $0x7,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <open>:
SYSCALL(open)
 4cc:	b8 0f 00 00 00       	mov    $0xf,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <mknod>:
SYSCALL(mknod)
 4d4:	b8 11 00 00 00       	mov    $0x11,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <unlink>:
SYSCALL(unlink)
 4dc:	b8 12 00 00 00       	mov    $0x12,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <fstat>:
SYSCALL(fstat)
 4e4:	b8 08 00 00 00       	mov    $0x8,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <link>:
SYSCALL(link)
 4ec:	b8 13 00 00 00       	mov    $0x13,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <mkdir>:
SYSCALL(mkdir)
 4f4:	b8 14 00 00 00       	mov    $0x14,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <chdir>:
SYSCALL(chdir)
 4fc:	b8 09 00 00 00       	mov    $0x9,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <dup>:
SYSCALL(dup)
 504:	b8 0a 00 00 00       	mov    $0xa,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <getpid>:
SYSCALL(getpid)
 50c:	b8 0b 00 00 00       	mov    $0xb,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <sbrk>:
SYSCALL(sbrk)
 514:	b8 0c 00 00 00       	mov    $0xc,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <sleep>:
SYSCALL(sleep)
 51c:	b8 0d 00 00 00       	mov    $0xd,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <uptime>:
SYSCALL(uptime)
 524:	b8 0e 00 00 00       	mov    $0xe,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <halt>:
SYSCALL(halt)
 52c:	b8 16 00 00 00       	mov    $0x16,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <date>:
SYSCALL(date)
 534:	b8 17 00 00 00       	mov    $0x17,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <getuid>:
SYSCALL(getuid)
 53c:	b8 18 00 00 00       	mov    $0x18,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <getgid>:
SYSCALL(getgid)
 544:	b8 19 00 00 00       	mov    $0x19,%eax
 549:	cd 40                	int    $0x40
 54b:	c3                   	ret    

0000054c <getppid>:
SYSCALL(getppid)
 54c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 551:	cd 40                	int    $0x40
 553:	c3                   	ret    

00000554 <setuid>:
SYSCALL(setuid)
 554:	b8 1b 00 00 00       	mov    $0x1b,%eax
 559:	cd 40                	int    $0x40
 55b:	c3                   	ret    

0000055c <setgid>:
SYSCALL(setgid)
 55c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 561:	cd 40                	int    $0x40
 563:	c3                   	ret    

00000564 <getprocs>:
SYSCALL(getprocs)
 564:	b8 1d 00 00 00       	mov    $0x1d,%eax
 569:	cd 40                	int    $0x40
 56b:	c3                   	ret    

0000056c <setpriority>:
SYSCALL(setpriority)
 56c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 571:	cd 40                	int    $0x40
 573:	c3                   	ret    

00000574 <chmod>:
SYSCALL(chmod)
 574:	b8 1f 00 00 00       	mov    $0x1f,%eax
 579:	cd 40                	int    $0x40
 57b:	c3                   	ret    

0000057c <chown>:
SYSCALL(chown)
 57c:	b8 20 00 00 00       	mov    $0x20,%eax
 581:	cd 40                	int    $0x40
 583:	c3                   	ret    

00000584 <chgrp>:
SYSCALL(chgrp)
 584:	b8 21 00 00 00       	mov    $0x21,%eax
 589:	cd 40                	int    $0x40
 58b:	c3                   	ret    

0000058c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 58c:	55                   	push   %ebp
 58d:	89 e5                	mov    %esp,%ebp
 58f:	83 ec 18             	sub    $0x18,%esp
 592:	8b 45 0c             	mov    0xc(%ebp),%eax
 595:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 598:	83 ec 04             	sub    $0x4,%esp
 59b:	6a 01                	push   $0x1
 59d:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5a0:	50                   	push   %eax
 5a1:	ff 75 08             	pushl  0x8(%ebp)
 5a4:	e8 03 ff ff ff       	call   4ac <write>
 5a9:	83 c4 10             	add    $0x10,%esp
}
 5ac:	90                   	nop
 5ad:	c9                   	leave  
 5ae:	c3                   	ret    

000005af <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5af:	55                   	push   %ebp
 5b0:	89 e5                	mov    %esp,%ebp
 5b2:	53                   	push   %ebx
 5b3:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5b6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5bd:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5c1:	74 17                	je     5da <printint+0x2b>
 5c3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5c7:	79 11                	jns    5da <printint+0x2b>
    neg = 1;
 5c9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d3:	f7 d8                	neg    %eax
 5d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d8:	eb 06                	jmp    5e0 <printint+0x31>
  } else {
    x = xx;
 5da:	8b 45 0c             	mov    0xc(%ebp),%eax
 5dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5e7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5ea:	8d 41 01             	lea    0x1(%ecx),%eax
 5ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5f0:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f6:	ba 00 00 00 00       	mov    $0x0,%edx
 5fb:	f7 f3                	div    %ebx
 5fd:	89 d0                	mov    %edx,%eax
 5ff:	0f b6 80 b8 0e 00 00 	movzbl 0xeb8(%eax),%eax
 606:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 60a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 60d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 610:	ba 00 00 00 00       	mov    $0x0,%edx
 615:	f7 f3                	div    %ebx
 617:	89 45 ec             	mov    %eax,-0x14(%ebp)
 61a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 61e:	75 c7                	jne    5e7 <printint+0x38>
  if(neg)
 620:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 624:	74 2d                	je     653 <printint+0xa4>
    buf[i++] = '-';
 626:	8b 45 f4             	mov    -0xc(%ebp),%eax
 629:	8d 50 01             	lea    0x1(%eax),%edx
 62c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 62f:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 634:	eb 1d                	jmp    653 <printint+0xa4>
    putc(fd, buf[i]);
 636:	8d 55 dc             	lea    -0x24(%ebp),%edx
 639:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63c:	01 d0                	add    %edx,%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	83 ec 08             	sub    $0x8,%esp
 647:	50                   	push   %eax
 648:	ff 75 08             	pushl  0x8(%ebp)
 64b:	e8 3c ff ff ff       	call   58c <putc>
 650:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 653:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 657:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65b:	79 d9                	jns    636 <printint+0x87>
    putc(fd, buf[i]);
}
 65d:	90                   	nop
 65e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 661:	c9                   	leave  
 662:	c3                   	ret    

00000663 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 663:	55                   	push   %ebp
 664:	89 e5                	mov    %esp,%ebp
 666:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 669:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 670:	8d 45 0c             	lea    0xc(%ebp),%eax
 673:	83 c0 04             	add    $0x4,%eax
 676:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 679:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 680:	e9 59 01 00 00       	jmp    7de <printf+0x17b>
    c = fmt[i] & 0xff;
 685:	8b 55 0c             	mov    0xc(%ebp),%edx
 688:	8b 45 f0             	mov    -0x10(%ebp),%eax
 68b:	01 d0                	add    %edx,%eax
 68d:	0f b6 00             	movzbl (%eax),%eax
 690:	0f be c0             	movsbl %al,%eax
 693:	25 ff 00 00 00       	and    $0xff,%eax
 698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 69b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 69f:	75 2c                	jne    6cd <printf+0x6a>
      if(c == '%'){
 6a1:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6a5:	75 0c                	jne    6b3 <printf+0x50>
        state = '%';
 6a7:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 6ae:	e9 27 01 00 00       	jmp    7da <printf+0x177>
      } else {
        putc(fd, c);
 6b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b6:	0f be c0             	movsbl %al,%eax
 6b9:	83 ec 08             	sub    $0x8,%esp
 6bc:	50                   	push   %eax
 6bd:	ff 75 08             	pushl  0x8(%ebp)
 6c0:	e8 c7 fe ff ff       	call   58c <putc>
 6c5:	83 c4 10             	add    $0x10,%esp
 6c8:	e9 0d 01 00 00       	jmp    7da <printf+0x177>
      }
    } else if(state == '%'){
 6cd:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6d1:	0f 85 03 01 00 00    	jne    7da <printf+0x177>
      if(c == 'd'){
 6d7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6db:	75 1e                	jne    6fb <printf+0x98>
        printint(fd, *ap, 10, 1);
 6dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6e0:	8b 00                	mov    (%eax),%eax
 6e2:	6a 01                	push   $0x1
 6e4:	6a 0a                	push   $0xa
 6e6:	50                   	push   %eax
 6e7:	ff 75 08             	pushl  0x8(%ebp)
 6ea:	e8 c0 fe ff ff       	call   5af <printint>
 6ef:	83 c4 10             	add    $0x10,%esp
        ap++;
 6f2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f6:	e9 d8 00 00 00       	jmp    7d3 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 6fb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6ff:	74 06                	je     707 <printf+0xa4>
 701:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 705:	75 1e                	jne    725 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 707:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70a:	8b 00                	mov    (%eax),%eax
 70c:	6a 00                	push   $0x0
 70e:	6a 10                	push   $0x10
 710:	50                   	push   %eax
 711:	ff 75 08             	pushl  0x8(%ebp)
 714:	e8 96 fe ff ff       	call   5af <printint>
 719:	83 c4 10             	add    $0x10,%esp
        ap++;
 71c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 720:	e9 ae 00 00 00       	jmp    7d3 <printf+0x170>
      } else if(c == 's'){
 725:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 729:	75 43                	jne    76e <printf+0x10b>
        s = (char*)*ap;
 72b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 72e:	8b 00                	mov    (%eax),%eax
 730:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 733:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 737:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 73b:	75 25                	jne    762 <printf+0xff>
          s = "(null)";
 73d:	c7 45 f4 62 0c 00 00 	movl   $0xc62,-0xc(%ebp)
        while(*s != 0){
 744:	eb 1c                	jmp    762 <printf+0xff>
          putc(fd, *s);
 746:	8b 45 f4             	mov    -0xc(%ebp),%eax
 749:	0f b6 00             	movzbl (%eax),%eax
 74c:	0f be c0             	movsbl %al,%eax
 74f:	83 ec 08             	sub    $0x8,%esp
 752:	50                   	push   %eax
 753:	ff 75 08             	pushl  0x8(%ebp)
 756:	e8 31 fe ff ff       	call   58c <putc>
 75b:	83 c4 10             	add    $0x10,%esp
          s++;
 75e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 762:	8b 45 f4             	mov    -0xc(%ebp),%eax
 765:	0f b6 00             	movzbl (%eax),%eax
 768:	84 c0                	test   %al,%al
 76a:	75 da                	jne    746 <printf+0xe3>
 76c:	eb 65                	jmp    7d3 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 76e:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 772:	75 1d                	jne    791 <printf+0x12e>
        putc(fd, *ap);
 774:	8b 45 e8             	mov    -0x18(%ebp),%eax
 777:	8b 00                	mov    (%eax),%eax
 779:	0f be c0             	movsbl %al,%eax
 77c:	83 ec 08             	sub    $0x8,%esp
 77f:	50                   	push   %eax
 780:	ff 75 08             	pushl  0x8(%ebp)
 783:	e8 04 fe ff ff       	call   58c <putc>
 788:	83 c4 10             	add    $0x10,%esp
        ap++;
 78b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 78f:	eb 42                	jmp    7d3 <printf+0x170>
      } else if(c == '%'){
 791:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 795:	75 17                	jne    7ae <printf+0x14b>
        putc(fd, c);
 797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 79a:	0f be c0             	movsbl %al,%eax
 79d:	83 ec 08             	sub    $0x8,%esp
 7a0:	50                   	push   %eax
 7a1:	ff 75 08             	pushl  0x8(%ebp)
 7a4:	e8 e3 fd ff ff       	call   58c <putc>
 7a9:	83 c4 10             	add    $0x10,%esp
 7ac:	eb 25                	jmp    7d3 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ae:	83 ec 08             	sub    $0x8,%esp
 7b1:	6a 25                	push   $0x25
 7b3:	ff 75 08             	pushl  0x8(%ebp)
 7b6:	e8 d1 fd ff ff       	call   58c <putc>
 7bb:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 7be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7c1:	0f be c0             	movsbl %al,%eax
 7c4:	83 ec 08             	sub    $0x8,%esp
 7c7:	50                   	push   %eax
 7c8:	ff 75 08             	pushl  0x8(%ebp)
 7cb:	e8 bc fd ff ff       	call   58c <putc>
 7d0:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 7d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 7da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7de:	8b 55 0c             	mov    0xc(%ebp),%edx
 7e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e4:	01 d0                	add    %edx,%eax
 7e6:	0f b6 00             	movzbl (%eax),%eax
 7e9:	84 c0                	test   %al,%al
 7eb:	0f 85 94 fe ff ff    	jne    685 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 7f1:	90                   	nop
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7fa:	8b 45 08             	mov    0x8(%ebp),%eax
 7fd:	83 e8 08             	sub    $0x8,%eax
 800:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 803:	a1 d4 0e 00 00       	mov    0xed4,%eax
 808:	89 45 fc             	mov    %eax,-0x4(%ebp)
 80b:	eb 24                	jmp    831 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	8b 00                	mov    (%eax),%eax
 812:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 815:	77 12                	ja     829 <free+0x35>
 817:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 81d:	77 24                	ja     843 <free+0x4f>
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 827:	77 1a                	ja     843 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 829:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82c:	8b 00                	mov    (%eax),%eax
 82e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 831:	8b 45 f8             	mov    -0x8(%ebp),%eax
 834:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 837:	76 d4                	jbe    80d <free+0x19>
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	8b 00                	mov    (%eax),%eax
 83e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 841:	76 ca                	jbe    80d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 843:	8b 45 f8             	mov    -0x8(%ebp),%eax
 846:	8b 40 04             	mov    0x4(%eax),%eax
 849:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 850:	8b 45 f8             	mov    -0x8(%ebp),%eax
 853:	01 c2                	add    %eax,%edx
 855:	8b 45 fc             	mov    -0x4(%ebp),%eax
 858:	8b 00                	mov    (%eax),%eax
 85a:	39 c2                	cmp    %eax,%edx
 85c:	75 24                	jne    882 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	8b 50 04             	mov    0x4(%eax),%edx
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	8b 40 04             	mov    0x4(%eax),%eax
 86c:	01 c2                	add    %eax,%edx
 86e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 871:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
 877:	8b 00                	mov    (%eax),%eax
 879:	8b 10                	mov    (%eax),%edx
 87b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87e:	89 10                	mov    %edx,(%eax)
 880:	eb 0a                	jmp    88c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	8b 10                	mov    (%eax),%edx
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 899:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89c:	01 d0                	add    %edx,%eax
 89e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8a1:	75 20                	jne    8c3 <free+0xcf>
    p->s.size += bp->s.size;
 8a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a6:	8b 50 04             	mov    0x4(%eax),%edx
 8a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ac:	8b 40 04             	mov    0x4(%eax),%eax
 8af:	01 c2                	add    %eax,%edx
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	8b 10                	mov    (%eax),%edx
 8bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bf:	89 10                	mov    %edx,(%eax)
 8c1:	eb 08                	jmp    8cb <free+0xd7>
  } else
    p->s.ptr = bp;
 8c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8c9:	89 10                	mov    %edx,(%eax)
  freep = p;
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	a3 d4 0e 00 00       	mov    %eax,0xed4
}
 8d3:	90                   	nop
 8d4:	c9                   	leave  
 8d5:	c3                   	ret    

000008d6 <morecore>:

static Header*
morecore(uint nu)
{
 8d6:	55                   	push   %ebp
 8d7:	89 e5                	mov    %esp,%ebp
 8d9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8dc:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8e3:	77 07                	ja     8ec <morecore+0x16>
    nu = 4096;
 8e5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8ec:	8b 45 08             	mov    0x8(%ebp),%eax
 8ef:	c1 e0 03             	shl    $0x3,%eax
 8f2:	83 ec 0c             	sub    $0xc,%esp
 8f5:	50                   	push   %eax
 8f6:	e8 19 fc ff ff       	call   514 <sbrk>
 8fb:	83 c4 10             	add    $0x10,%esp
 8fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 901:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 905:	75 07                	jne    90e <morecore+0x38>
    return 0;
 907:	b8 00 00 00 00       	mov    $0x0,%eax
 90c:	eb 26                	jmp    934 <morecore+0x5e>
  hp = (Header*)p;
 90e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 911:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 914:	8b 45 f0             	mov    -0x10(%ebp),%eax
 917:	8b 55 08             	mov    0x8(%ebp),%edx
 91a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	83 c0 08             	add    $0x8,%eax
 923:	83 ec 0c             	sub    $0xc,%esp
 926:	50                   	push   %eax
 927:	e8 c8 fe ff ff       	call   7f4 <free>
 92c:	83 c4 10             	add    $0x10,%esp
  return freep;
 92f:	a1 d4 0e 00 00       	mov    0xed4,%eax
}
 934:	c9                   	leave  
 935:	c3                   	ret    

00000936 <malloc>:

void*
malloc(uint nbytes)
{
 936:	55                   	push   %ebp
 937:	89 e5                	mov    %esp,%ebp
 939:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93c:	8b 45 08             	mov    0x8(%ebp),%eax
 93f:	83 c0 07             	add    $0x7,%eax
 942:	c1 e8 03             	shr    $0x3,%eax
 945:	83 c0 01             	add    $0x1,%eax
 948:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 94b:	a1 d4 0e 00 00       	mov    0xed4,%eax
 950:	89 45 f0             	mov    %eax,-0x10(%ebp)
 953:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 957:	75 23                	jne    97c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 959:	c7 45 f0 cc 0e 00 00 	movl   $0xecc,-0x10(%ebp)
 960:	8b 45 f0             	mov    -0x10(%ebp),%eax
 963:	a3 d4 0e 00 00       	mov    %eax,0xed4
 968:	a1 d4 0e 00 00       	mov    0xed4,%eax
 96d:	a3 cc 0e 00 00       	mov    %eax,0xecc
    base.s.size = 0;
 972:	c7 05 d0 0e 00 00 00 	movl   $0x0,0xed0
 979:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97f:	8b 00                	mov    (%eax),%eax
 981:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	8b 40 04             	mov    0x4(%eax),%eax
 98a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 98d:	72 4d                	jb     9dc <malloc+0xa6>
      if(p->s.size == nunits)
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	8b 40 04             	mov    0x4(%eax),%eax
 995:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 998:	75 0c                	jne    9a6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 99a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99d:	8b 10                	mov    (%eax),%edx
 99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a2:	89 10                	mov    %edx,(%eax)
 9a4:	eb 26                	jmp    9cc <malloc+0x96>
      else {
        p->s.size -= nunits;
 9a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a9:	8b 40 04             	mov    0x4(%eax),%eax
 9ac:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9af:	89 c2                	mov    %eax,%edx
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	8b 40 04             	mov    0x4(%eax),%eax
 9bd:	c1 e0 03             	shl    $0x3,%eax
 9c0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9c9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9cf:	a3 d4 0e 00 00       	mov    %eax,0xed4
      return (void*)(p + 1);
 9d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d7:	83 c0 08             	add    $0x8,%eax
 9da:	eb 3b                	jmp    a17 <malloc+0xe1>
    }
    if(p == freep)
 9dc:	a1 d4 0e 00 00       	mov    0xed4,%eax
 9e1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e4:	75 1e                	jne    a04 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 9e6:	83 ec 0c             	sub    $0xc,%esp
 9e9:	ff 75 ec             	pushl  -0x14(%ebp)
 9ec:	e8 e5 fe ff ff       	call   8d6 <morecore>
 9f1:	83 c4 10             	add    $0x10,%esp
 9f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9fb:	75 07                	jne    a04 <malloc+0xce>
        return 0;
 9fd:	b8 00 00 00 00       	mov    $0x0,%eax
 a02:	eb 13                	jmp    a17 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	8b 00                	mov    (%eax),%eax
 a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a12:	e9 6d ff ff ff       	jmp    984 <malloc+0x4e>
}
 a17:	c9                   	leave  
 a18:	c3                   	ret    
