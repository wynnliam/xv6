
_time:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

void print_total_ticks(uint total_ticks);

int
main(int argc, char** argv)
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
  int pid;
  uint start_ticks, total_ticks;

  if(argc <= 1)
  14:	83 3b 01             	cmpl   $0x1,(%ebx)
  17:	7f 17                	jg     30 <main+0x30>
  {
    printf(1, "ran in 0.00 seconds\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 50 09 00 00       	push   $0x950
  21:	6a 01                	push   $0x1
  23:	e8 72 05 00 00       	call   59a <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 93 03 00 00       	call   3c3 <exit>
  }

  pid = fork();
  30:	e8 86 03 00 00       	call   3bb <fork>
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // If we are the parent
  if(pid > 0)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7e 46                	jle    84 <main+0x84>
  {
    start_ticks = uptime();
  3e:	e8 18 04 00 00       	call   45b <uptime>
  43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    pid = wait();
  46:	e8 80 03 00 00       	call   3cb <wait>
  4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    total_ticks = uptime() - start_ticks;
  4e:	e8 08 04 00 00       	call   45b <uptime>
  53:	2b 45 f0             	sub    -0x10(%ebp),%eax
  56:	89 45 ec             	mov    %eax,-0x14(%ebp)

    printf(1, "%s ran in ", argv[1]);
  59:	8b 43 04             	mov    0x4(%ebx),%eax
  5c:	83 c0 04             	add    $0x4,%eax
  5f:	8b 00                	mov    (%eax),%eax
  61:	83 ec 04             	sub    $0x4,%esp
  64:	50                   	push   %eax
  65:	68 65 09 00 00       	push   $0x965
  6a:	6a 01                	push   $0x1
  6c:	e8 29 05 00 00       	call   59a <printf>
  71:	83 c4 10             	add    $0x10,%esp
    print_total_ticks(total_ticks);
  74:	83 ec 0c             	sub    $0xc,%esp
  77:	ff 75 ec             	pushl  -0x14(%ebp)
  7a:	e8 5a 00 00 00       	call   d9 <print_total_ticks>
  7f:	83 c4 10             	add    $0x10,%esp
  82:	eb 50                	jmp    d4 <main+0xd4>
  }

  // If we are the child.
  else if(pid == 0)
  84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  88:	75 38                	jne    c2 <main+0xc2>
  {
    exec(argv[1], &argv[1]);
  8a:	8b 43 04             	mov    0x4(%ebx),%eax
  8d:	8d 50 04             	lea    0x4(%eax),%edx
  90:	8b 43 04             	mov    0x4(%ebx),%eax
  93:	83 c0 04             	add    $0x4,%eax
  96:	8b 00                	mov    (%eax),%eax
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	52                   	push   %edx
  9c:	50                   	push   %eax
  9d:	e8 59 03 00 00       	call   3fb <exec>
  a2:	83 c4 10             	add    $0x10,%esp
    // Should never get here unless exec failed.
    printf(1, "%s is an invalid command\n", argv[1]);
  a5:	8b 43 04             	mov    0x4(%ebx),%eax
  a8:	83 c0 04             	add    $0x4,%eax
  ab:	8b 00                	mov    (%eax),%eax
  ad:	83 ec 04             	sub    $0x4,%esp
  b0:	50                   	push   %eax
  b1:	68 70 09 00 00       	push   $0x970
  b6:	6a 01                	push   $0x1
  b8:	e8 dd 04 00 00       	call   59a <printf>
  bd:	83 c4 10             	add    $0x10,%esp
  c0:	eb 12                	jmp    d4 <main+0xd4>
  }

  // We have a problem
  else
    printf(1, "problem\n");
  c2:	83 ec 08             	sub    $0x8,%esp
  c5:	68 8a 09 00 00       	push   $0x98a
  ca:	6a 01                	push   $0x1
  cc:	e8 c9 04 00 00       	call   59a <printf>
  d1:	83 c4 10             	add    $0x10,%esp


  exit();
  d4:	e8 ea 02 00 00       	call   3c3 <exit>

000000d9 <print_total_ticks>:
}

void
print_total_ticks(uint total_ticks)
{
  d9:	55                   	push   %ebp
  da:	89 e5                	mov    %esp,%ebp
  dc:	83 ec 18             	sub    $0x18,%esp
  uint sec, millisec;

  sec = total_ticks / 1000;
  df:	8b 45 08             	mov    0x8(%ebp),%eax
  e2:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  e7:	f7 e2                	mul    %edx
  e9:	89 d0                	mov    %edx,%eax
  eb:	c1 e8 06             	shr    $0x6,%eax
  ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  millisec = total_ticks % 1000;
  f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f4:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
  f9:	89 c8                	mov    %ecx,%eax
  fb:	f7 e2                	mul    %edx
  fd:	89 d0                	mov    %edx,%eax
  ff:	c1 e8 06             	shr    $0x6,%eax
 102:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 108:	29 c1                	sub    %eax,%ecx
 10a:	89 c8                	mov    %ecx,%eax
 10c:	89 45 f0             	mov    %eax,-0x10(%ebp)

  printf(1, "%d.%d\n", sec, millisec);
 10f:	ff 75 f0             	pushl  -0x10(%ebp)
 112:	ff 75 f4             	pushl  -0xc(%ebp)
 115:	68 93 09 00 00       	push   $0x993
 11a:	6a 01                	push   $0x1
 11c:	e8 79 04 00 00       	call   59a <printf>
 121:	83 c4 10             	add    $0x10,%esp
}
 124:	90                   	nop
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	57                   	push   %edi
 12b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 12c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 12f:	8b 55 10             	mov    0x10(%ebp),%edx
 132:	8b 45 0c             	mov    0xc(%ebp),%eax
 135:	89 cb                	mov    %ecx,%ebx
 137:	89 df                	mov    %ebx,%edi
 139:	89 d1                	mov    %edx,%ecx
 13b:	fc                   	cld    
 13c:	f3 aa                	rep stos %al,%es:(%edi)
 13e:	89 ca                	mov    %ecx,%edx
 140:	89 fb                	mov    %edi,%ebx
 142:	89 5d 08             	mov    %ebx,0x8(%ebp)
 145:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 148:	90                   	nop
 149:	5b                   	pop    %ebx
 14a:	5f                   	pop    %edi
 14b:	5d                   	pop    %ebp
 14c:	c3                   	ret    

0000014d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 14d:	55                   	push   %ebp
 14e:	89 e5                	mov    %esp,%ebp
 150:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 159:	90                   	nop
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	8d 50 01             	lea    0x1(%eax),%edx
 160:	89 55 08             	mov    %edx,0x8(%ebp)
 163:	8b 55 0c             	mov    0xc(%ebp),%edx
 166:	8d 4a 01             	lea    0x1(%edx),%ecx
 169:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 16c:	0f b6 12             	movzbl (%edx),%edx
 16f:	88 10                	mov    %dl,(%eax)
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	84 c0                	test   %al,%al
 176:	75 e2                	jne    15a <strcpy+0xd>
    ;
  return os;
 178:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 180:	eb 08                	jmp    18a <strcmp+0xd>
    p++, q++;
 182:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 186:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 18a:	8b 45 08             	mov    0x8(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	84 c0                	test   %al,%al
 192:	74 10                	je     1a4 <strcmp+0x27>
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 10             	movzbl (%eax),%edx
 19a:	8b 45 0c             	mov    0xc(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	38 c2                	cmp    %al,%dl
 1a2:	74 de                	je     182 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	0f b6 00             	movzbl (%eax),%eax
 1aa:	0f b6 d0             	movzbl %al,%edx
 1ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	0f b6 c0             	movzbl %al,%eax
 1b6:	29 c2                	sub    %eax,%edx
 1b8:	89 d0                	mov    %edx,%eax
}
 1ba:	5d                   	pop    %ebp
 1bb:	c3                   	ret    

000001bc <strlen>:

uint
strlen(char *s)
{
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c9:	eb 04                	jmp    1cf <strlen+0x13>
 1cb:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1cf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
 1d5:	01 d0                	add    %edx,%eax
 1d7:	0f b6 00             	movzbl (%eax),%eax
 1da:	84 c0                	test   %al,%al
 1dc:	75 ed                	jne    1cb <strlen+0xf>
    ;
  return n;
 1de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1e1:	c9                   	leave  
 1e2:	c3                   	ret    

000001e3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1e6:	8b 45 10             	mov    0x10(%ebp),%eax
 1e9:	50                   	push   %eax
 1ea:	ff 75 0c             	pushl  0xc(%ebp)
 1ed:	ff 75 08             	pushl  0x8(%ebp)
 1f0:	e8 32 ff ff ff       	call   127 <stosb>
 1f5:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1fb:	c9                   	leave  
 1fc:	c3                   	ret    

000001fd <strchr>:

char*
strchr(const char *s, char c)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 04             	sub    $0x4,%esp
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 209:	eb 14                	jmp    21f <strchr+0x22>
    if(*s == c)
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	0f b6 00             	movzbl (%eax),%eax
 211:	3a 45 fc             	cmp    -0x4(%ebp),%al
 214:	75 05                	jne    21b <strchr+0x1e>
      return (char*)s;
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	eb 13                	jmp    22e <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 21b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	84 c0                	test   %al,%al
 227:	75 e2                	jne    20b <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 229:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22e:	c9                   	leave  
 22f:	c3                   	ret    

00000230 <gets>:

char*
gets(char *buf, int max)
{
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 236:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23d:	eb 42                	jmp    281 <gets+0x51>
    cc = read(0, &c, 1);
 23f:	83 ec 04             	sub    $0x4,%esp
 242:	6a 01                	push   $0x1
 244:	8d 45 ef             	lea    -0x11(%ebp),%eax
 247:	50                   	push   %eax
 248:	6a 00                	push   $0x0
 24a:	e8 8c 01 00 00       	call   3db <read>
 24f:	83 c4 10             	add    $0x10,%esp
 252:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 255:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 259:	7e 33                	jle    28e <gets+0x5e>
      break;
    buf[i++] = c;
 25b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 25e:	8d 50 01             	lea    0x1(%eax),%edx
 261:	89 55 f4             	mov    %edx,-0xc(%ebp)
 264:	89 c2                	mov    %eax,%edx
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	01 c2                	add    %eax,%edx
 26b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26f:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 271:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 275:	3c 0a                	cmp    $0xa,%al
 277:	74 16                	je     28f <gets+0x5f>
 279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 0e                	je     28f <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	83 c0 01             	add    $0x1,%eax
 287:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28a:	7c b3                	jl     23f <gets+0xf>
 28c:	eb 01                	jmp    28f <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28f:	8b 55 f4             	mov    -0xc(%ebp),%edx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	01 d0                	add    %edx,%eax
 297:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29d:	c9                   	leave  
 29e:	c3                   	ret    

0000029f <stat>:

int
stat(char *n, struct stat *st)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
 2a2:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a5:	83 ec 08             	sub    $0x8,%esp
 2a8:	6a 00                	push   $0x0
 2aa:	ff 75 08             	pushl  0x8(%ebp)
 2ad:	e8 51 01 00 00       	call   403 <open>
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bc:	79 07                	jns    2c5 <stat+0x26>
    return -1;
 2be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c3:	eb 25                	jmp    2ea <stat+0x4b>
  r = fstat(fd, st);
 2c5:	83 ec 08             	sub    $0x8,%esp
 2c8:	ff 75 0c             	pushl  0xc(%ebp)
 2cb:	ff 75 f4             	pushl  -0xc(%ebp)
 2ce:	e8 48 01 00 00       	call   41b <fstat>
 2d3:	83 c4 10             	add    $0x10,%esp
 2d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d9:	83 ec 0c             	sub    $0xc,%esp
 2dc:	ff 75 f4             	pushl  -0xc(%ebp)
 2df:	e8 07 01 00 00       	call   3eb <close>
 2e4:	83 c4 10             	add    $0x10,%esp
  return r;
 2e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2ea:	c9                   	leave  
 2eb:	c3                   	ret    

000002ec <atoi>:

int
atoi(const char *s)
{
 2ec:	55                   	push   %ebp
 2ed:	89 e5                	mov    %esp,%ebp
 2ef:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2f2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2f9:	eb 04                	jmp    2ff <atoi+0x13>
 2fb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	0f b6 00             	movzbl (%eax),%eax
 305:	3c 20                	cmp    $0x20,%al
 307:	74 f2                	je     2fb <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 309:	8b 45 08             	mov    0x8(%ebp),%eax
 30c:	0f b6 00             	movzbl (%eax),%eax
 30f:	3c 2d                	cmp    $0x2d,%al
 311:	75 07                	jne    31a <atoi+0x2e>
 313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 318:	eb 05                	jmp    31f <atoi+0x33>
 31a:	b8 01 00 00 00       	mov    $0x1,%eax
 31f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	0f b6 00             	movzbl (%eax),%eax
 328:	3c 2b                	cmp    $0x2b,%al
 32a:	74 0a                	je     336 <atoi+0x4a>
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	3c 2d                	cmp    $0x2d,%al
 334:	75 2b                	jne    361 <atoi+0x75>
    s++;
 336:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 33a:	eb 25                	jmp    361 <atoi+0x75>
    n = n*10 + *s++ - '0';
 33c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33f:	89 d0                	mov    %edx,%eax
 341:	c1 e0 02             	shl    $0x2,%eax
 344:	01 d0                	add    %edx,%eax
 346:	01 c0                	add    %eax,%eax
 348:	89 c1                	mov    %eax,%ecx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	8d 50 01             	lea    0x1(%eax),%edx
 350:	89 55 08             	mov    %edx,0x8(%ebp)
 353:	0f b6 00             	movzbl (%eax),%eax
 356:	0f be c0             	movsbl %al,%eax
 359:	01 c8                	add    %ecx,%eax
 35b:	83 e8 30             	sub    $0x30,%eax
 35e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	0f b6 00             	movzbl (%eax),%eax
 367:	3c 2f                	cmp    $0x2f,%al
 369:	7e 0a                	jle    375 <atoi+0x89>
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	0f b6 00             	movzbl (%eax),%eax
 371:	3c 39                	cmp    $0x39,%al
 373:	7e c7                	jle    33c <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 375:	8b 45 f8             	mov    -0x8(%ebp),%eax
 378:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 37c:	c9                   	leave  
 37d:	c3                   	ret    

0000037e <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 37e:	55                   	push   %ebp
 37f:	89 e5                	mov    %esp,%ebp
 381:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 390:	eb 17                	jmp    3a9 <memmove+0x2b>
    *dst++ = *src++;
 392:	8b 45 fc             	mov    -0x4(%ebp),%eax
 395:	8d 50 01             	lea    0x1(%eax),%edx
 398:	89 55 fc             	mov    %edx,-0x4(%ebp)
 39b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 39e:	8d 4a 01             	lea    0x1(%edx),%ecx
 3a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3a4:	0f b6 12             	movzbl (%edx),%edx
 3a7:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3a9:	8b 45 10             	mov    0x10(%ebp),%eax
 3ac:	8d 50 ff             	lea    -0x1(%eax),%edx
 3af:	89 55 10             	mov    %edx,0x10(%ebp)
 3b2:	85 c0                	test   %eax,%eax
 3b4:	7f dc                	jg     392 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3b9:	c9                   	leave  
 3ba:	c3                   	ret    

000003bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3bb:	b8 01 00 00 00       	mov    $0x1,%eax
 3c0:	cd 40                	int    $0x40
 3c2:	c3                   	ret    

000003c3 <exit>:
SYSCALL(exit)
 3c3:	b8 02 00 00 00       	mov    $0x2,%eax
 3c8:	cd 40                	int    $0x40
 3ca:	c3                   	ret    

000003cb <wait>:
SYSCALL(wait)
 3cb:	b8 03 00 00 00       	mov    $0x3,%eax
 3d0:	cd 40                	int    $0x40
 3d2:	c3                   	ret    

000003d3 <pipe>:
SYSCALL(pipe)
 3d3:	b8 04 00 00 00       	mov    $0x4,%eax
 3d8:	cd 40                	int    $0x40
 3da:	c3                   	ret    

000003db <read>:
SYSCALL(read)
 3db:	b8 05 00 00 00       	mov    $0x5,%eax
 3e0:	cd 40                	int    $0x40
 3e2:	c3                   	ret    

000003e3 <write>:
SYSCALL(write)
 3e3:	b8 10 00 00 00       	mov    $0x10,%eax
 3e8:	cd 40                	int    $0x40
 3ea:	c3                   	ret    

000003eb <close>:
SYSCALL(close)
 3eb:	b8 15 00 00 00       	mov    $0x15,%eax
 3f0:	cd 40                	int    $0x40
 3f2:	c3                   	ret    

000003f3 <kill>:
SYSCALL(kill)
 3f3:	b8 06 00 00 00       	mov    $0x6,%eax
 3f8:	cd 40                	int    $0x40
 3fa:	c3                   	ret    

000003fb <exec>:
SYSCALL(exec)
 3fb:	b8 07 00 00 00       	mov    $0x7,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret    

00000403 <open>:
SYSCALL(open)
 403:	b8 0f 00 00 00       	mov    $0xf,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret    

0000040b <mknod>:
SYSCALL(mknod)
 40b:	b8 11 00 00 00       	mov    $0x11,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <unlink>:
SYSCALL(unlink)
 413:	b8 12 00 00 00       	mov    $0x12,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <fstat>:
SYSCALL(fstat)
 41b:	b8 08 00 00 00       	mov    $0x8,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <link>:
SYSCALL(link)
 423:	b8 13 00 00 00       	mov    $0x13,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <mkdir>:
SYSCALL(mkdir)
 42b:	b8 14 00 00 00       	mov    $0x14,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <chdir>:
SYSCALL(chdir)
 433:	b8 09 00 00 00       	mov    $0x9,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <dup>:
SYSCALL(dup)
 43b:	b8 0a 00 00 00       	mov    $0xa,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <getpid>:
SYSCALL(getpid)
 443:	b8 0b 00 00 00       	mov    $0xb,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <sbrk>:
SYSCALL(sbrk)
 44b:	b8 0c 00 00 00       	mov    $0xc,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <sleep>:
SYSCALL(sleep)
 453:	b8 0d 00 00 00       	mov    $0xd,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <uptime>:
SYSCALL(uptime)
 45b:	b8 0e 00 00 00       	mov    $0xe,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <halt>:
SYSCALL(halt)
 463:	b8 16 00 00 00       	mov    $0x16,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <date>:
SYSCALL(date)
 46b:	b8 17 00 00 00       	mov    $0x17,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <getuid>:
SYSCALL(getuid)
 473:	b8 18 00 00 00       	mov    $0x18,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <getgid>:
SYSCALL(getgid)
 47b:	b8 19 00 00 00       	mov    $0x19,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <getppid>:
SYSCALL(getppid)
 483:	b8 1a 00 00 00       	mov    $0x1a,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <setuid>:
SYSCALL(setuid)
 48b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <setgid>:
SYSCALL(setgid)
 493:	b8 1c 00 00 00       	mov    $0x1c,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <getprocs>:
SYSCALL(getprocs)
 49b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <setpriority>:
SYSCALL(setpriority)
 4a3:	b8 1e 00 00 00       	mov    $0x1e,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <chmod>:
SYSCALL(chmod)
 4ab:	b8 1f 00 00 00       	mov    $0x1f,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <chown>:
SYSCALL(chown)
 4b3:	b8 20 00 00 00       	mov    $0x20,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <chgrp>:
SYSCALL(chgrp)
 4bb:	b8 21 00 00 00       	mov    $0x21,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c3:	55                   	push   %ebp
 4c4:	89 e5                	mov    %esp,%ebp
 4c6:	83 ec 18             	sub    $0x18,%esp
 4c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cc:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4cf:	83 ec 04             	sub    $0x4,%esp
 4d2:	6a 01                	push   $0x1
 4d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4d7:	50                   	push   %eax
 4d8:	ff 75 08             	pushl  0x8(%ebp)
 4db:	e8 03 ff ff ff       	call   3e3 <write>
 4e0:	83 c4 10             	add    $0x10,%esp
}
 4e3:	90                   	nop
 4e4:	c9                   	leave  
 4e5:	c3                   	ret    

000004e6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e6:	55                   	push   %ebp
 4e7:	89 e5                	mov    %esp,%ebp
 4e9:	53                   	push   %ebx
 4ea:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4f4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f8:	74 17                	je     511 <printint+0x2b>
 4fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4fe:	79 11                	jns    511 <printint+0x2b>
    neg = 1;
 500:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 507:	8b 45 0c             	mov    0xc(%ebp),%eax
 50a:	f7 d8                	neg    %eax
 50c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 50f:	eb 06                	jmp    517 <printint+0x31>
  } else {
    x = xx;
 511:	8b 45 0c             	mov    0xc(%ebp),%eax
 514:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 517:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 51e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 521:	8d 41 01             	lea    0x1(%ecx),%eax
 524:	89 45 f4             	mov    %eax,-0xc(%ebp)
 527:	8b 5d 10             	mov    0x10(%ebp),%ebx
 52a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52d:	ba 00 00 00 00       	mov    $0x0,%edx
 532:	f7 f3                	div    %ebx
 534:	89 d0                	mov    %edx,%eax
 536:	0f b6 80 10 0c 00 00 	movzbl 0xc10(%eax),%eax
 53d:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 541:	8b 5d 10             	mov    0x10(%ebp),%ebx
 544:	8b 45 ec             	mov    -0x14(%ebp),%eax
 547:	ba 00 00 00 00       	mov    $0x0,%edx
 54c:	f7 f3                	div    %ebx
 54e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 551:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 555:	75 c7                	jne    51e <printint+0x38>
  if(neg)
 557:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 55b:	74 2d                	je     58a <printint+0xa4>
    buf[i++] = '-';
 55d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 560:	8d 50 01             	lea    0x1(%eax),%edx
 563:	89 55 f4             	mov    %edx,-0xc(%ebp)
 566:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 56b:	eb 1d                	jmp    58a <printint+0xa4>
    putc(fd, buf[i]);
 56d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 570:	8b 45 f4             	mov    -0xc(%ebp),%eax
 573:	01 d0                	add    %edx,%eax
 575:	0f b6 00             	movzbl (%eax),%eax
 578:	0f be c0             	movsbl %al,%eax
 57b:	83 ec 08             	sub    $0x8,%esp
 57e:	50                   	push   %eax
 57f:	ff 75 08             	pushl  0x8(%ebp)
 582:	e8 3c ff ff ff       	call   4c3 <putc>
 587:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 58a:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 58e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 592:	79 d9                	jns    56d <printint+0x87>
    putc(fd, buf[i]);
}
 594:	90                   	nop
 595:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 598:	c9                   	leave  
 599:	c3                   	ret    

0000059a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 59a:	55                   	push   %ebp
 59b:	89 e5                	mov    %esp,%ebp
 59d:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5a0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5a7:	8d 45 0c             	lea    0xc(%ebp),%eax
 5aa:	83 c0 04             	add    $0x4,%eax
 5ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5b7:	e9 59 01 00 00       	jmp    715 <printf+0x17b>
    c = fmt[i] & 0xff;
 5bc:	8b 55 0c             	mov    0xc(%ebp),%edx
 5bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5c2:	01 d0                	add    %edx,%eax
 5c4:	0f b6 00             	movzbl (%eax),%eax
 5c7:	0f be c0             	movsbl %al,%eax
 5ca:	25 ff 00 00 00       	and    $0xff,%eax
 5cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5d6:	75 2c                	jne    604 <printf+0x6a>
      if(c == '%'){
 5d8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5dc:	75 0c                	jne    5ea <printf+0x50>
        state = '%';
 5de:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5e5:	e9 27 01 00 00       	jmp    711 <printf+0x177>
      } else {
        putc(fd, c);
 5ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ed:	0f be c0             	movsbl %al,%eax
 5f0:	83 ec 08             	sub    $0x8,%esp
 5f3:	50                   	push   %eax
 5f4:	ff 75 08             	pushl  0x8(%ebp)
 5f7:	e8 c7 fe ff ff       	call   4c3 <putc>
 5fc:	83 c4 10             	add    $0x10,%esp
 5ff:	e9 0d 01 00 00       	jmp    711 <printf+0x177>
      }
    } else if(state == '%'){
 604:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 608:	0f 85 03 01 00 00    	jne    711 <printf+0x177>
      if(c == 'd'){
 60e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 612:	75 1e                	jne    632 <printf+0x98>
        printint(fd, *ap, 10, 1);
 614:	8b 45 e8             	mov    -0x18(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	6a 01                	push   $0x1
 61b:	6a 0a                	push   $0xa
 61d:	50                   	push   %eax
 61e:	ff 75 08             	pushl  0x8(%ebp)
 621:	e8 c0 fe ff ff       	call   4e6 <printint>
 626:	83 c4 10             	add    $0x10,%esp
        ap++;
 629:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 62d:	e9 d8 00 00 00       	jmp    70a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 632:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 636:	74 06                	je     63e <printf+0xa4>
 638:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 63c:	75 1e                	jne    65c <printf+0xc2>
        printint(fd, *ap, 16, 0);
 63e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 641:	8b 00                	mov    (%eax),%eax
 643:	6a 00                	push   $0x0
 645:	6a 10                	push   $0x10
 647:	50                   	push   %eax
 648:	ff 75 08             	pushl  0x8(%ebp)
 64b:	e8 96 fe ff ff       	call   4e6 <printint>
 650:	83 c4 10             	add    $0x10,%esp
        ap++;
 653:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 657:	e9 ae 00 00 00       	jmp    70a <printf+0x170>
      } else if(c == 's'){
 65c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 660:	75 43                	jne    6a5 <printf+0x10b>
        s = (char*)*ap;
 662:	8b 45 e8             	mov    -0x18(%ebp),%eax
 665:	8b 00                	mov    (%eax),%eax
 667:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 66a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 66e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 672:	75 25                	jne    699 <printf+0xff>
          s = "(null)";
 674:	c7 45 f4 9a 09 00 00 	movl   $0x99a,-0xc(%ebp)
        while(*s != 0){
 67b:	eb 1c                	jmp    699 <printf+0xff>
          putc(fd, *s);
 67d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 680:	0f b6 00             	movzbl (%eax),%eax
 683:	0f be c0             	movsbl %al,%eax
 686:	83 ec 08             	sub    $0x8,%esp
 689:	50                   	push   %eax
 68a:	ff 75 08             	pushl  0x8(%ebp)
 68d:	e8 31 fe ff ff       	call   4c3 <putc>
 692:	83 c4 10             	add    $0x10,%esp
          s++;
 695:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 699:	8b 45 f4             	mov    -0xc(%ebp),%eax
 69c:	0f b6 00             	movzbl (%eax),%eax
 69f:	84 c0                	test   %al,%al
 6a1:	75 da                	jne    67d <printf+0xe3>
 6a3:	eb 65                	jmp    70a <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6a5:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6a9:	75 1d                	jne    6c8 <printf+0x12e>
        putc(fd, *ap);
 6ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ae:	8b 00                	mov    (%eax),%eax
 6b0:	0f be c0             	movsbl %al,%eax
 6b3:	83 ec 08             	sub    $0x8,%esp
 6b6:	50                   	push   %eax
 6b7:	ff 75 08             	pushl  0x8(%ebp)
 6ba:	e8 04 fe ff ff       	call   4c3 <putc>
 6bf:	83 c4 10             	add    $0x10,%esp
        ap++;
 6c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c6:	eb 42                	jmp    70a <printf+0x170>
      } else if(c == '%'){
 6c8:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6cc:	75 17                	jne    6e5 <printf+0x14b>
        putc(fd, c);
 6ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d1:	0f be c0             	movsbl %al,%eax
 6d4:	83 ec 08             	sub    $0x8,%esp
 6d7:	50                   	push   %eax
 6d8:	ff 75 08             	pushl  0x8(%ebp)
 6db:	e8 e3 fd ff ff       	call   4c3 <putc>
 6e0:	83 c4 10             	add    $0x10,%esp
 6e3:	eb 25                	jmp    70a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6e5:	83 ec 08             	sub    $0x8,%esp
 6e8:	6a 25                	push   $0x25
 6ea:	ff 75 08             	pushl  0x8(%ebp)
 6ed:	e8 d1 fd ff ff       	call   4c3 <putc>
 6f2:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6f8:	0f be c0             	movsbl %al,%eax
 6fb:	83 ec 08             	sub    $0x8,%esp
 6fe:	50                   	push   %eax
 6ff:	ff 75 08             	pushl  0x8(%ebp)
 702:	e8 bc fd ff ff       	call   4c3 <putc>
 707:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 70a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 711:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 715:	8b 55 0c             	mov    0xc(%ebp),%edx
 718:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71b:	01 d0                	add    %edx,%eax
 71d:	0f b6 00             	movzbl (%eax),%eax
 720:	84 c0                	test   %al,%al
 722:	0f 85 94 fe ff ff    	jne    5bc <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 728:	90                   	nop
 729:	c9                   	leave  
 72a:	c3                   	ret    

0000072b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 72b:	55                   	push   %ebp
 72c:	89 e5                	mov    %esp,%ebp
 72e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 731:	8b 45 08             	mov    0x8(%ebp),%eax
 734:	83 e8 08             	sub    $0x8,%eax
 737:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 73a:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 73f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 742:	eb 24                	jmp    768 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 744:	8b 45 fc             	mov    -0x4(%ebp),%eax
 747:	8b 00                	mov    (%eax),%eax
 749:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74c:	77 12                	ja     760 <free+0x35>
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 754:	77 24                	ja     77a <free+0x4f>
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 75e:	77 1a                	ja     77a <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 00                	mov    (%eax),%eax
 765:	89 45 fc             	mov    %eax,-0x4(%ebp)
 768:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76e:	76 d4                	jbe    744 <free+0x19>
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 778:	76 ca                	jbe    744 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 787:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78a:	01 c2                	add    %eax,%edx
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	39 c2                	cmp    %eax,%edx
 793:	75 24                	jne    7b9 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 795:	8b 45 f8             	mov    -0x8(%ebp),%eax
 798:	8b 50 04             	mov    0x4(%eax),%edx
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	8b 00                	mov    (%eax),%eax
 7a0:	8b 40 04             	mov    0x4(%eax),%eax
 7a3:	01 c2                	add    %eax,%edx
 7a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ae:	8b 00                	mov    (%eax),%eax
 7b0:	8b 10                	mov    (%eax),%edx
 7b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b5:	89 10                	mov    %edx,(%eax)
 7b7:	eb 0a                	jmp    7c3 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8b 10                	mov    (%eax),%edx
 7be:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c1:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c6:	8b 40 04             	mov    0x4(%eax),%eax
 7c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d3:	01 d0                	add    %edx,%eax
 7d5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7d8:	75 20                	jne    7fa <free+0xcf>
    p->s.size += bp->s.size;
 7da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dd:	8b 50 04             	mov    0x4(%eax),%edx
 7e0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e3:	8b 40 04             	mov    0x4(%eax),%eax
 7e6:	01 c2                	add    %eax,%edx
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7eb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f1:	8b 10                	mov    (%eax),%edx
 7f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f6:	89 10                	mov    %edx,(%eax)
 7f8:	eb 08                	jmp    802 <free+0xd7>
  } else
    p->s.ptr = bp;
 7fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 800:	89 10                	mov    %edx,(%eax)
  freep = p;
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	a3 2c 0c 00 00       	mov    %eax,0xc2c
}
 80a:	90                   	nop
 80b:	c9                   	leave  
 80c:	c3                   	ret    

0000080d <morecore>:

static Header*
morecore(uint nu)
{
 80d:	55                   	push   %ebp
 80e:	89 e5                	mov    %esp,%ebp
 810:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 813:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 81a:	77 07                	ja     823 <morecore+0x16>
    nu = 4096;
 81c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 823:	8b 45 08             	mov    0x8(%ebp),%eax
 826:	c1 e0 03             	shl    $0x3,%eax
 829:	83 ec 0c             	sub    $0xc,%esp
 82c:	50                   	push   %eax
 82d:	e8 19 fc ff ff       	call   44b <sbrk>
 832:	83 c4 10             	add    $0x10,%esp
 835:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 838:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 83c:	75 07                	jne    845 <morecore+0x38>
    return 0;
 83e:	b8 00 00 00 00       	mov    $0x0,%eax
 843:	eb 26                	jmp    86b <morecore+0x5e>
  hp = (Header*)p;
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 84e:	8b 55 08             	mov    0x8(%ebp),%edx
 851:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 854:	8b 45 f0             	mov    -0x10(%ebp),%eax
 857:	83 c0 08             	add    $0x8,%eax
 85a:	83 ec 0c             	sub    $0xc,%esp
 85d:	50                   	push   %eax
 85e:	e8 c8 fe ff ff       	call   72b <free>
 863:	83 c4 10             	add    $0x10,%esp
  return freep;
 866:	a1 2c 0c 00 00       	mov    0xc2c,%eax
}
 86b:	c9                   	leave  
 86c:	c3                   	ret    

0000086d <malloc>:

void*
malloc(uint nbytes)
{
 86d:	55                   	push   %ebp
 86e:	89 e5                	mov    %esp,%ebp
 870:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 873:	8b 45 08             	mov    0x8(%ebp),%eax
 876:	83 c0 07             	add    $0x7,%eax
 879:	c1 e8 03             	shr    $0x3,%eax
 87c:	83 c0 01             	add    $0x1,%eax
 87f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 882:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 887:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88e:	75 23                	jne    8b3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 890:	c7 45 f0 24 0c 00 00 	movl   $0xc24,-0x10(%ebp)
 897:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89a:	a3 2c 0c 00 00       	mov    %eax,0xc2c
 89f:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 8a4:	a3 24 0c 00 00       	mov    %eax,0xc24
    base.s.size = 0;
 8a9:	c7 05 28 0c 00 00 00 	movl   $0x0,0xc28
 8b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c4:	72 4d                	jb     913 <malloc+0xa6>
      if(p->s.size == nunits)
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 40 04             	mov    0x4(%eax),%eax
 8cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cf:	75 0c                	jne    8dd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d4:	8b 10                	mov    (%eax),%edx
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	89 10                	mov    %edx,(%eax)
 8db:	eb 26                	jmp    903 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	8b 40 04             	mov    0x4(%eax),%eax
 8e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e6:	89 c2                	mov    %eax,%edx
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	8b 40 04             	mov    0x4(%eax),%eax
 8f4:	c1 e0 03             	shl    $0x3,%eax
 8f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 900:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 903:	8b 45 f0             	mov    -0x10(%ebp),%eax
 906:	a3 2c 0c 00 00       	mov    %eax,0xc2c
      return (void*)(p + 1);
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	83 c0 08             	add    $0x8,%eax
 911:	eb 3b                	jmp    94e <malloc+0xe1>
    }
    if(p == freep)
 913:	a1 2c 0c 00 00       	mov    0xc2c,%eax
 918:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 91b:	75 1e                	jne    93b <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 91d:	83 ec 0c             	sub    $0xc,%esp
 920:	ff 75 ec             	pushl  -0x14(%ebp)
 923:	e8 e5 fe ff ff       	call   80d <morecore>
 928:	83 c4 10             	add    $0x10,%esp
 92b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 92e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 932:	75 07                	jne    93b <malloc+0xce>
        return 0;
 934:	b8 00 00 00 00       	mov    $0x0,%eax
 939:	eb 13                	jmp    94e <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 941:	8b 45 f4             	mov    -0xc(%ebp),%eax
 944:	8b 00                	mov    (%eax),%eax
 946:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 949:	e9 6d ff ff ff       	jmp    8bb <malloc+0x4e>
}
 94e:	c9                   	leave  
 94f:	c3                   	ret    
