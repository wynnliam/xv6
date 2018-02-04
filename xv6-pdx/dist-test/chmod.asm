
_chmod:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#ifdef CS333_P5
#include "types.h"
#include "user.h"
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
  char* path;
  int mode;
  int rc;

  if(argc != 3)
  14:	83 3b 03             	cmpl   $0x3,(%ebx)
  17:	74 17                	je     30 <main+0x30>
  {
    printf(2, "Run like so: chmod PATH MODE\n");
  19:	83 ec 08             	sub    $0x8,%esp
  1c:	68 1a 09 00 00       	push   $0x91a
  21:	6a 02                	push   $0x2
  23:	e8 3c 05 00 00       	call   564 <printf>
  28:	83 c4 10             	add    $0x10,%esp
    exit();
  2b:	e8 5d 03 00 00       	call   38d <exit>
  }

  if(strlen(argv[1]) != 4)
  30:	8b 43 04             	mov    0x4(%ebx),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	83 ec 0c             	sub    $0xc,%esp
  3b:	50                   	push   %eax
  3c:	e8 45 01 00 00       	call   186 <strlen>
  41:	83 c4 10             	add    $0x10,%esp
  44:	83 f8 04             	cmp    $0x4,%eax
  47:	74 17                	je     60 <main+0x60>
  {
    printf(2, "Invalid mode\n");
  49:	83 ec 08             	sub    $0x8,%esp
  4c:	68 38 09 00 00       	push   $0x938
  51:	6a 02                	push   $0x2
  53:	e8 0c 05 00 00       	call   564 <printf>
  58:	83 c4 10             	add    $0x10,%esp
    exit();
  5b:	e8 2d 03 00 00       	call   38d <exit>
  }

  path = argv[2];
  60:	8b 43 04             	mov    0x4(%ebx),%eax
  63:	8b 40 08             	mov    0x8(%eax),%eax
  66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  mode = atoi(argv[1]);
  69:	8b 43 04             	mov    0x4(%ebx),%eax
  6c:	83 c0 04             	add    $0x4,%eax
  6f:	8b 00                	mov    (%eax),%eax
  71:	83 ec 0c             	sub    $0xc,%esp
  74:	50                   	push   %eax
  75:	e8 3c 02 00 00       	call   2b6 <atoi>
  7a:	83 c4 10             	add    $0x10,%esp
  7d:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Validate and set the correct representation for the mode
  if(0 > mode || mode > 1777)
  80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  84:	78 09                	js     8f <main+0x8f>
  86:	81 7d f0 f1 06 00 00 	cmpl   $0x6f1,-0x10(%ebp)
  8d:	7e 17                	jle    a6 <main+0xa6>
  {
    printf(2, "Invalid mode\n");
  8f:	83 ec 08             	sub    $0x8,%esp
  92:	68 38 09 00 00       	push   $0x938
  97:	6a 02                	push   $0x2
  99:	e8 c6 04 00 00       	call   564 <printf>
  9e:	83 c4 10             	add    $0x10,%esp
    exit();
  a1:	e8 e7 02 00 00       	call   38d <exit>
  }

  rc = chmod(path, mode);
  a6:	83 ec 08             	sub    $0x8,%esp
  a9:	ff 75 f0             	pushl  -0x10(%ebp)
  ac:	ff 75 f4             	pushl  -0xc(%ebp)
  af:	e8 c1 03 00 00       	call   475 <chmod>
  b4:	83 c4 10             	add    $0x10,%esp
  b7:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if(rc == -1)
  ba:	83 7d ec ff          	cmpl   $0xffffffff,-0x14(%ebp)
  be:	75 14                	jne    d4 <main+0xd4>
    printf(2, "Failed to change mode\n");
  c0:	83 ec 08             	sub    $0x8,%esp
  c3:	68 46 09 00 00       	push   $0x946
  c8:	6a 02                	push   $0x2
  ca:	e8 95 04 00 00       	call   564 <printf>
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	eb 18                	jmp    ec <main+0xec>
  else if(rc == -2)
  d4:	83 7d ec fe          	cmpl   $0xfffffffe,-0x14(%ebp)
  d8:	75 12                	jne    ec <main+0xec>
    printf(2, "Bad path\n");
  da:	83 ec 08             	sub    $0x8,%esp
  dd:	68 5d 09 00 00       	push   $0x95d
  e2:	6a 02                	push   $0x2
  e4:	e8 7b 04 00 00       	call   564 <printf>
  e9:	83 c4 10             	add    $0x10,%esp

  exit();
  ec:	e8 9c 02 00 00       	call   38d <exit>

000000f1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  f1:	55                   	push   %ebp
  f2:	89 e5                	mov    %esp,%ebp
  f4:	57                   	push   %edi
  f5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  f9:	8b 55 10             	mov    0x10(%ebp),%edx
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	89 cb                	mov    %ecx,%ebx
 101:	89 df                	mov    %ebx,%edi
 103:	89 d1                	mov    %edx,%ecx
 105:	fc                   	cld    
 106:	f3 aa                	rep stos %al,%es:(%edi)
 108:	89 ca                	mov    %ecx,%edx
 10a:	89 fb                	mov    %edi,%ebx
 10c:	89 5d 08             	mov    %ebx,0x8(%ebp)
 10f:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 112:	90                   	nop
 113:	5b                   	pop    %ebx
 114:	5f                   	pop    %edi
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    

00000117 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 123:	90                   	nop
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	8d 50 01             	lea    0x1(%eax),%edx
 12a:	89 55 08             	mov    %edx,0x8(%ebp)
 12d:	8b 55 0c             	mov    0xc(%ebp),%edx
 130:	8d 4a 01             	lea    0x1(%edx),%ecx
 133:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 136:	0f b6 12             	movzbl (%edx),%edx
 139:	88 10                	mov    %dl,(%eax)
 13b:	0f b6 00             	movzbl (%eax),%eax
 13e:	84 c0                	test   %al,%al
 140:	75 e2                	jne    124 <strcpy+0xd>
    ;
  return os;
 142:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 145:	c9                   	leave  
 146:	c3                   	ret    

00000147 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 147:	55                   	push   %ebp
 148:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 14a:	eb 08                	jmp    154 <strcmp+0xd>
    p++, q++;
 14c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 150:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	0f b6 00             	movzbl (%eax),%eax
 15a:	84 c0                	test   %al,%al
 15c:	74 10                	je     16e <strcmp+0x27>
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	0f b6 10             	movzbl (%eax),%edx
 164:	8b 45 0c             	mov    0xc(%ebp),%eax
 167:	0f b6 00             	movzbl (%eax),%eax
 16a:	38 c2                	cmp    %al,%dl
 16c:	74 de                	je     14c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	0f b6 00             	movzbl (%eax),%eax
 174:	0f b6 d0             	movzbl %al,%edx
 177:	8b 45 0c             	mov    0xc(%ebp),%eax
 17a:	0f b6 00             	movzbl (%eax),%eax
 17d:	0f b6 c0             	movzbl %al,%eax
 180:	29 c2                	sub    %eax,%edx
 182:	89 d0                	mov    %edx,%eax
}
 184:	5d                   	pop    %ebp
 185:	c3                   	ret    

00000186 <strlen>:

uint
strlen(char *s)
{
 186:	55                   	push   %ebp
 187:	89 e5                	mov    %esp,%ebp
 189:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 18c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 193:	eb 04                	jmp    199 <strlen+0x13>
 195:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 199:	8b 55 fc             	mov    -0x4(%ebp),%edx
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	01 d0                	add    %edx,%eax
 1a1:	0f b6 00             	movzbl (%eax),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	75 ed                	jne    195 <strlen+0xf>
    ;
  return n;
 1a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1ab:	c9                   	leave  
 1ac:	c3                   	ret    

000001ad <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ad:	55                   	push   %ebp
 1ae:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1b0:	8b 45 10             	mov    0x10(%ebp),%eax
 1b3:	50                   	push   %eax
 1b4:	ff 75 0c             	pushl  0xc(%ebp)
 1b7:	ff 75 08             	pushl  0x8(%ebp)
 1ba:	e8 32 ff ff ff       	call   f1 <stosb>
 1bf:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c5:	c9                   	leave  
 1c6:	c3                   	ret    

000001c7 <strchr>:

char*
strchr(const char *s, char c)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
 1ca:	83 ec 04             	sub    $0x4,%esp
 1cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d0:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d3:	eb 14                	jmp    1e9 <strchr+0x22>
    if(*s == c)
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	0f b6 00             	movzbl (%eax),%eax
 1db:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1de:	75 05                	jne    1e5 <strchr+0x1e>
      return (char*)s;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	eb 13                	jmp    1f8 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ec:	0f b6 00             	movzbl (%eax),%eax
 1ef:	84 c0                	test   %al,%al
 1f1:	75 e2                	jne    1d5 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <gets>:

char*
gets(char *buf, int max)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 200:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 207:	eb 42                	jmp    24b <gets+0x51>
    cc = read(0, &c, 1);
 209:	83 ec 04             	sub    $0x4,%esp
 20c:	6a 01                	push   $0x1
 20e:	8d 45 ef             	lea    -0x11(%ebp),%eax
 211:	50                   	push   %eax
 212:	6a 00                	push   $0x0
 214:	e8 8c 01 00 00       	call   3a5 <read>
 219:	83 c4 10             	add    $0x10,%esp
 21c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 21f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 223:	7e 33                	jle    258 <gets+0x5e>
      break;
    buf[i++] = c;
 225:	8b 45 f4             	mov    -0xc(%ebp),%eax
 228:	8d 50 01             	lea    0x1(%eax),%edx
 22b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 22e:	89 c2                	mov    %eax,%edx
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	01 c2                	add    %eax,%edx
 235:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 239:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 23b:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 23f:	3c 0a                	cmp    $0xa,%al
 241:	74 16                	je     259 <gets+0x5f>
 243:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 247:	3c 0d                	cmp    $0xd,%al
 249:	74 0e                	je     259 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 24b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24e:	83 c0 01             	add    $0x1,%eax
 251:	3b 45 0c             	cmp    0xc(%ebp),%eax
 254:	7c b3                	jl     209 <gets+0xf>
 256:	eb 01                	jmp    259 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 258:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 259:	8b 55 f4             	mov    -0xc(%ebp),%edx
 25c:	8b 45 08             	mov    0x8(%ebp),%eax
 25f:	01 d0                	add    %edx,%eax
 261:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 264:	8b 45 08             	mov    0x8(%ebp),%eax
}
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <stat>:

int
stat(char *n, struct stat *st)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
 26c:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 26f:	83 ec 08             	sub    $0x8,%esp
 272:	6a 00                	push   $0x0
 274:	ff 75 08             	pushl  0x8(%ebp)
 277:	e8 51 01 00 00       	call   3cd <open>
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 286:	79 07                	jns    28f <stat+0x26>
    return -1;
 288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28d:	eb 25                	jmp    2b4 <stat+0x4b>
  r = fstat(fd, st);
 28f:	83 ec 08             	sub    $0x8,%esp
 292:	ff 75 0c             	pushl  0xc(%ebp)
 295:	ff 75 f4             	pushl  -0xc(%ebp)
 298:	e8 48 01 00 00       	call   3e5 <fstat>
 29d:	83 c4 10             	add    $0x10,%esp
 2a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2a3:	83 ec 0c             	sub    $0xc,%esp
 2a6:	ff 75 f4             	pushl  -0xc(%ebp)
 2a9:	e8 07 01 00 00       	call   3b5 <close>
 2ae:	83 c4 10             	add    $0x10,%esp
  return r;
 2b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2b4:	c9                   	leave  
 2b5:	c3                   	ret    

000002b6 <atoi>:

int
atoi(const char *s)
{
 2b6:	55                   	push   %ebp
 2b7:	89 e5                	mov    %esp,%ebp
 2b9:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 2bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 2c3:	eb 04                	jmp    2c9 <atoi+0x13>
 2c5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2c9:	8b 45 08             	mov    0x8(%ebp),%eax
 2cc:	0f b6 00             	movzbl (%eax),%eax
 2cf:	3c 20                	cmp    $0x20,%al
 2d1:	74 f2                	je     2c5 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	0f b6 00             	movzbl (%eax),%eax
 2d9:	3c 2d                	cmp    $0x2d,%al
 2db:	75 07                	jne    2e4 <atoi+0x2e>
 2dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e2:	eb 05                	jmp    2e9 <atoi+0x33>
 2e4:	b8 01 00 00 00       	mov    $0x1,%eax
 2e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	0f b6 00             	movzbl (%eax),%eax
 2f2:	3c 2b                	cmp    $0x2b,%al
 2f4:	74 0a                	je     300 <atoi+0x4a>
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	0f b6 00             	movzbl (%eax),%eax
 2fc:	3c 2d                	cmp    $0x2d,%al
 2fe:	75 2b                	jne    32b <atoi+0x75>
    s++;
 300:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 304:	eb 25                	jmp    32b <atoi+0x75>
    n = n*10 + *s++ - '0';
 306:	8b 55 fc             	mov    -0x4(%ebp),%edx
 309:	89 d0                	mov    %edx,%eax
 30b:	c1 e0 02             	shl    $0x2,%eax
 30e:	01 d0                	add    %edx,%eax
 310:	01 c0                	add    %eax,%eax
 312:	89 c1                	mov    %eax,%ecx
 314:	8b 45 08             	mov    0x8(%ebp),%eax
 317:	8d 50 01             	lea    0x1(%eax),%edx
 31a:	89 55 08             	mov    %edx,0x8(%ebp)
 31d:	0f b6 00             	movzbl (%eax),%eax
 320:	0f be c0             	movsbl %al,%eax
 323:	01 c8                	add    %ecx,%eax
 325:	83 e8 30             	sub    $0x30,%eax
 328:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	0f b6 00             	movzbl (%eax),%eax
 331:	3c 2f                	cmp    $0x2f,%al
 333:	7e 0a                	jle    33f <atoi+0x89>
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	3c 39                	cmp    $0x39,%al
 33d:	7e c7                	jle    306 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 33f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 342:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 346:	c9                   	leave  
 347:	c3                   	ret    

00000348 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 354:	8b 45 0c             	mov    0xc(%ebp),%eax
 357:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 35a:	eb 17                	jmp    373 <memmove+0x2b>
    *dst++ = *src++;
 35c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35f:	8d 50 01             	lea    0x1(%eax),%edx
 362:	89 55 fc             	mov    %edx,-0x4(%ebp)
 365:	8b 55 f8             	mov    -0x8(%ebp),%edx
 368:	8d 4a 01             	lea    0x1(%edx),%ecx
 36b:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 36e:	0f b6 12             	movzbl (%edx),%edx
 371:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 373:	8b 45 10             	mov    0x10(%ebp),%eax
 376:	8d 50 ff             	lea    -0x1(%eax),%edx
 379:	89 55 10             	mov    %edx,0x10(%ebp)
 37c:	85 c0                	test   %eax,%eax
 37e:	7f dc                	jg     35c <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 380:	8b 45 08             	mov    0x8(%ebp),%eax
}
 383:	c9                   	leave  
 384:	c3                   	ret    

00000385 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 385:	b8 01 00 00 00       	mov    $0x1,%eax
 38a:	cd 40                	int    $0x40
 38c:	c3                   	ret    

0000038d <exit>:
SYSCALL(exit)
 38d:	b8 02 00 00 00       	mov    $0x2,%eax
 392:	cd 40                	int    $0x40
 394:	c3                   	ret    

00000395 <wait>:
SYSCALL(wait)
 395:	b8 03 00 00 00       	mov    $0x3,%eax
 39a:	cd 40                	int    $0x40
 39c:	c3                   	ret    

0000039d <pipe>:
SYSCALL(pipe)
 39d:	b8 04 00 00 00       	mov    $0x4,%eax
 3a2:	cd 40                	int    $0x40
 3a4:	c3                   	ret    

000003a5 <read>:
SYSCALL(read)
 3a5:	b8 05 00 00 00       	mov    $0x5,%eax
 3aa:	cd 40                	int    $0x40
 3ac:	c3                   	ret    

000003ad <write>:
SYSCALL(write)
 3ad:	b8 10 00 00 00       	mov    $0x10,%eax
 3b2:	cd 40                	int    $0x40
 3b4:	c3                   	ret    

000003b5 <close>:
SYSCALL(close)
 3b5:	b8 15 00 00 00       	mov    $0x15,%eax
 3ba:	cd 40                	int    $0x40
 3bc:	c3                   	ret    

000003bd <kill>:
SYSCALL(kill)
 3bd:	b8 06 00 00 00       	mov    $0x6,%eax
 3c2:	cd 40                	int    $0x40
 3c4:	c3                   	ret    

000003c5 <exec>:
SYSCALL(exec)
 3c5:	b8 07 00 00 00       	mov    $0x7,%eax
 3ca:	cd 40                	int    $0x40
 3cc:	c3                   	ret    

000003cd <open>:
SYSCALL(open)
 3cd:	b8 0f 00 00 00       	mov    $0xf,%eax
 3d2:	cd 40                	int    $0x40
 3d4:	c3                   	ret    

000003d5 <mknod>:
SYSCALL(mknod)
 3d5:	b8 11 00 00 00       	mov    $0x11,%eax
 3da:	cd 40                	int    $0x40
 3dc:	c3                   	ret    

000003dd <unlink>:
SYSCALL(unlink)
 3dd:	b8 12 00 00 00       	mov    $0x12,%eax
 3e2:	cd 40                	int    $0x40
 3e4:	c3                   	ret    

000003e5 <fstat>:
SYSCALL(fstat)
 3e5:	b8 08 00 00 00       	mov    $0x8,%eax
 3ea:	cd 40                	int    $0x40
 3ec:	c3                   	ret    

000003ed <link>:
SYSCALL(link)
 3ed:	b8 13 00 00 00       	mov    $0x13,%eax
 3f2:	cd 40                	int    $0x40
 3f4:	c3                   	ret    

000003f5 <mkdir>:
SYSCALL(mkdir)
 3f5:	b8 14 00 00 00       	mov    $0x14,%eax
 3fa:	cd 40                	int    $0x40
 3fc:	c3                   	ret    

000003fd <chdir>:
SYSCALL(chdir)
 3fd:	b8 09 00 00 00       	mov    $0x9,%eax
 402:	cd 40                	int    $0x40
 404:	c3                   	ret    

00000405 <dup>:
SYSCALL(dup)
 405:	b8 0a 00 00 00       	mov    $0xa,%eax
 40a:	cd 40                	int    $0x40
 40c:	c3                   	ret    

0000040d <getpid>:
SYSCALL(getpid)
 40d:	b8 0b 00 00 00       	mov    $0xb,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <sbrk>:
SYSCALL(sbrk)
 415:	b8 0c 00 00 00       	mov    $0xc,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <sleep>:
SYSCALL(sleep)
 41d:	b8 0d 00 00 00       	mov    $0xd,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <uptime>:
SYSCALL(uptime)
 425:	b8 0e 00 00 00       	mov    $0xe,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <halt>:
SYSCALL(halt)
 42d:	b8 16 00 00 00       	mov    $0x16,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <date>:
SYSCALL(date)
 435:	b8 17 00 00 00       	mov    $0x17,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <getuid>:
SYSCALL(getuid)
 43d:	b8 18 00 00 00       	mov    $0x18,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <getgid>:
SYSCALL(getgid)
 445:	b8 19 00 00 00       	mov    $0x19,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <getppid>:
SYSCALL(getppid)
 44d:	b8 1a 00 00 00       	mov    $0x1a,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <setuid>:
SYSCALL(setuid)
 455:	b8 1b 00 00 00       	mov    $0x1b,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <setgid>:
SYSCALL(setgid)
 45d:	b8 1c 00 00 00       	mov    $0x1c,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <getprocs>:
SYSCALL(getprocs)
 465:	b8 1d 00 00 00       	mov    $0x1d,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <setpriority>:
SYSCALL(setpriority)
 46d:	b8 1e 00 00 00       	mov    $0x1e,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <chmod>:
SYSCALL(chmod)
 475:	b8 1f 00 00 00       	mov    $0x1f,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <chown>:
SYSCALL(chown)
 47d:	b8 20 00 00 00       	mov    $0x20,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <chgrp>:
SYSCALL(chgrp)
 485:	b8 21 00 00 00       	mov    $0x21,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	83 ec 18             	sub    $0x18,%esp
 493:	8b 45 0c             	mov    0xc(%ebp),%eax
 496:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 499:	83 ec 04             	sub    $0x4,%esp
 49c:	6a 01                	push   $0x1
 49e:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4a1:	50                   	push   %eax
 4a2:	ff 75 08             	pushl  0x8(%ebp)
 4a5:	e8 03 ff ff ff       	call   3ad <write>
 4aa:	83 c4 10             	add    $0x10,%esp
}
 4ad:	90                   	nop
 4ae:	c9                   	leave  
 4af:	c3                   	ret    

000004b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	53                   	push   %ebx
 4b4:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4be:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4c2:	74 17                	je     4db <printint+0x2b>
 4c4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4c8:	79 11                	jns    4db <printint+0x2b>
    neg = 1;
 4ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d4:	f7 d8                	neg    %eax
 4d6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d9:	eb 06                	jmp    4e1 <printint+0x31>
  } else {
    x = xx;
 4db:	8b 45 0c             	mov    0xc(%ebp),%eax
 4de:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4e8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4eb:	8d 41 01             	lea    0x1(%ecx),%eax
 4ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4f7:	ba 00 00 00 00       	mov    $0x0,%edx
 4fc:	f7 f3                	div    %ebx
 4fe:	89 d0                	mov    %edx,%eax
 500:	0f b6 80 bc 0b 00 00 	movzbl 0xbbc(%eax),%eax
 507:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 50b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 511:	ba 00 00 00 00       	mov    $0x0,%edx
 516:	f7 f3                	div    %ebx
 518:	89 45 ec             	mov    %eax,-0x14(%ebp)
 51b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 51f:	75 c7                	jne    4e8 <printint+0x38>
  if(neg)
 521:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 525:	74 2d                	je     554 <printint+0xa4>
    buf[i++] = '-';
 527:	8b 45 f4             	mov    -0xc(%ebp),%eax
 52a:	8d 50 01             	lea    0x1(%eax),%edx
 52d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 530:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 535:	eb 1d                	jmp    554 <printint+0xa4>
    putc(fd, buf[i]);
 537:	8d 55 dc             	lea    -0x24(%ebp),%edx
 53a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53d:	01 d0                	add    %edx,%eax
 53f:	0f b6 00             	movzbl (%eax),%eax
 542:	0f be c0             	movsbl %al,%eax
 545:	83 ec 08             	sub    $0x8,%esp
 548:	50                   	push   %eax
 549:	ff 75 08             	pushl  0x8(%ebp)
 54c:	e8 3c ff ff ff       	call   48d <putc>
 551:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 554:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 558:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 55c:	79 d9                	jns    537 <printint+0x87>
    putc(fd, buf[i]);
}
 55e:	90                   	nop
 55f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 562:	c9                   	leave  
 563:	c3                   	ret    

00000564 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 56a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 571:	8d 45 0c             	lea    0xc(%ebp),%eax
 574:	83 c0 04             	add    $0x4,%eax
 577:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 57a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 581:	e9 59 01 00 00       	jmp    6df <printf+0x17b>
    c = fmt[i] & 0xff;
 586:	8b 55 0c             	mov    0xc(%ebp),%edx
 589:	8b 45 f0             	mov    -0x10(%ebp),%eax
 58c:	01 d0                	add    %edx,%eax
 58e:	0f b6 00             	movzbl (%eax),%eax
 591:	0f be c0             	movsbl %al,%eax
 594:	25 ff 00 00 00       	and    $0xff,%eax
 599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 59c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5a0:	75 2c                	jne    5ce <printf+0x6a>
      if(c == '%'){
 5a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5a6:	75 0c                	jne    5b4 <printf+0x50>
        state = '%';
 5a8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5af:	e9 27 01 00 00       	jmp    6db <printf+0x177>
      } else {
        putc(fd, c);
 5b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b7:	0f be c0             	movsbl %al,%eax
 5ba:	83 ec 08             	sub    $0x8,%esp
 5bd:	50                   	push   %eax
 5be:	ff 75 08             	pushl  0x8(%ebp)
 5c1:	e8 c7 fe ff ff       	call   48d <putc>
 5c6:	83 c4 10             	add    $0x10,%esp
 5c9:	e9 0d 01 00 00       	jmp    6db <printf+0x177>
      }
    } else if(state == '%'){
 5ce:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5d2:	0f 85 03 01 00 00    	jne    6db <printf+0x177>
      if(c == 'd'){
 5d8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5dc:	75 1e                	jne    5fc <printf+0x98>
        printint(fd, *ap, 10, 1);
 5de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e1:	8b 00                	mov    (%eax),%eax
 5e3:	6a 01                	push   $0x1
 5e5:	6a 0a                	push   $0xa
 5e7:	50                   	push   %eax
 5e8:	ff 75 08             	pushl  0x8(%ebp)
 5eb:	e8 c0 fe ff ff       	call   4b0 <printint>
 5f0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5f3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f7:	e9 d8 00 00 00       	jmp    6d4 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 5fc:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 600:	74 06                	je     608 <printf+0xa4>
 602:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 606:	75 1e                	jne    626 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 608:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60b:	8b 00                	mov    (%eax),%eax
 60d:	6a 00                	push   $0x0
 60f:	6a 10                	push   $0x10
 611:	50                   	push   %eax
 612:	ff 75 08             	pushl  0x8(%ebp)
 615:	e8 96 fe ff ff       	call   4b0 <printint>
 61a:	83 c4 10             	add    $0x10,%esp
        ap++;
 61d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 621:	e9 ae 00 00 00       	jmp    6d4 <printf+0x170>
      } else if(c == 's'){
 626:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 62a:	75 43                	jne    66f <printf+0x10b>
        s = (char*)*ap;
 62c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 62f:	8b 00                	mov    (%eax),%eax
 631:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 634:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 63c:	75 25                	jne    663 <printf+0xff>
          s = "(null)";
 63e:	c7 45 f4 67 09 00 00 	movl   $0x967,-0xc(%ebp)
        while(*s != 0){
 645:	eb 1c                	jmp    663 <printf+0xff>
          putc(fd, *s);
 647:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64a:	0f b6 00             	movzbl (%eax),%eax
 64d:	0f be c0             	movsbl %al,%eax
 650:	83 ec 08             	sub    $0x8,%esp
 653:	50                   	push   %eax
 654:	ff 75 08             	pushl  0x8(%ebp)
 657:	e8 31 fe ff ff       	call   48d <putc>
 65c:	83 c4 10             	add    $0x10,%esp
          s++;
 65f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 663:	8b 45 f4             	mov    -0xc(%ebp),%eax
 666:	0f b6 00             	movzbl (%eax),%eax
 669:	84 c0                	test   %al,%al
 66b:	75 da                	jne    647 <printf+0xe3>
 66d:	eb 65                	jmp    6d4 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 673:	75 1d                	jne    692 <printf+0x12e>
        putc(fd, *ap);
 675:	8b 45 e8             	mov    -0x18(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	83 ec 08             	sub    $0x8,%esp
 680:	50                   	push   %eax
 681:	ff 75 08             	pushl  0x8(%ebp)
 684:	e8 04 fe ff ff       	call   48d <putc>
 689:	83 c4 10             	add    $0x10,%esp
        ap++;
 68c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 690:	eb 42                	jmp    6d4 <printf+0x170>
      } else if(c == '%'){
 692:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 696:	75 17                	jne    6af <printf+0x14b>
        putc(fd, c);
 698:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 69b:	0f be c0             	movsbl %al,%eax
 69e:	83 ec 08             	sub    $0x8,%esp
 6a1:	50                   	push   %eax
 6a2:	ff 75 08             	pushl  0x8(%ebp)
 6a5:	e8 e3 fd ff ff       	call   48d <putc>
 6aa:	83 c4 10             	add    $0x10,%esp
 6ad:	eb 25                	jmp    6d4 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6af:	83 ec 08             	sub    $0x8,%esp
 6b2:	6a 25                	push   $0x25
 6b4:	ff 75 08             	pushl  0x8(%ebp)
 6b7:	e8 d1 fd ff ff       	call   48d <putc>
 6bc:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 6bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	83 ec 08             	sub    $0x8,%esp
 6c8:	50                   	push   %eax
 6c9:	ff 75 08             	pushl  0x8(%ebp)
 6cc:	e8 bc fd ff ff       	call   48d <putc>
 6d1:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6db:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6df:	8b 55 0c             	mov    0xc(%ebp),%edx
 6e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6e5:	01 d0                	add    %edx,%eax
 6e7:	0f b6 00             	movzbl (%eax),%eax
 6ea:	84 c0                	test   %al,%al
 6ec:	0f 85 94 fe ff ff    	jne    586 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6f2:	90                   	nop
 6f3:	c9                   	leave  
 6f4:	c3                   	ret    

000006f5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6fb:	8b 45 08             	mov    0x8(%ebp),%eax
 6fe:	83 e8 08             	sub    $0x8,%eax
 701:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 709:	89 45 fc             	mov    %eax,-0x4(%ebp)
 70c:	eb 24                	jmp    732 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 711:	8b 00                	mov    (%eax),%eax
 713:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 716:	77 12                	ja     72a <free+0x35>
 718:	8b 45 f8             	mov    -0x8(%ebp),%eax
 71b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 71e:	77 24                	ja     744 <free+0x4f>
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 728:	77 1a                	ja     744 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72d:	8b 00                	mov    (%eax),%eax
 72f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 732:	8b 45 f8             	mov    -0x8(%ebp),%eax
 735:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 738:	76 d4                	jbe    70e <free+0x19>
 73a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73d:	8b 00                	mov    (%eax),%eax
 73f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 742:	76 ca                	jbe    70e <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 744:	8b 45 f8             	mov    -0x8(%ebp),%eax
 747:	8b 40 04             	mov    0x4(%eax),%eax
 74a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 751:	8b 45 f8             	mov    -0x8(%ebp),%eax
 754:	01 c2                	add    %eax,%edx
 756:	8b 45 fc             	mov    -0x4(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	39 c2                	cmp    %eax,%edx
 75d:	75 24                	jne    783 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 75f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 762:	8b 50 04             	mov    0x4(%eax),%edx
 765:	8b 45 fc             	mov    -0x4(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	8b 40 04             	mov    0x4(%eax),%eax
 76d:	01 c2                	add    %eax,%edx
 76f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 772:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 775:	8b 45 fc             	mov    -0x4(%ebp),%eax
 778:	8b 00                	mov    (%eax),%eax
 77a:	8b 10                	mov    (%eax),%edx
 77c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77f:	89 10                	mov    %edx,(%eax)
 781:	eb 0a                	jmp    78d <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 45 f8             	mov    -0x8(%ebp),%eax
 78b:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 40 04             	mov    0x4(%eax),%eax
 793:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	01 d0                	add    %edx,%eax
 79f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a2:	75 20                	jne    7c4 <free+0xcf>
    p->s.size += bp->s.size;
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 50 04             	mov    0x4(%eax),%edx
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	8b 40 04             	mov    0x4(%eax),%eax
 7b0:	01 c2                	add    %eax,%edx
 7b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bb:	8b 10                	mov    (%eax),%edx
 7bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c0:	89 10                	mov    %edx,(%eax)
 7c2:	eb 08                	jmp    7cc <free+0xd7>
  } else
    p->s.ptr = bp;
 7c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c7:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ca:	89 10                	mov    %edx,(%eax)
  freep = p;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	a3 d8 0b 00 00       	mov    %eax,0xbd8
}
 7d4:	90                   	nop
 7d5:	c9                   	leave  
 7d6:	c3                   	ret    

000007d7 <morecore>:

static Header*
morecore(uint nu)
{
 7d7:	55                   	push   %ebp
 7d8:	89 e5                	mov    %esp,%ebp
 7da:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7dd:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7e4:	77 07                	ja     7ed <morecore+0x16>
    nu = 4096;
 7e6:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7ed:	8b 45 08             	mov    0x8(%ebp),%eax
 7f0:	c1 e0 03             	shl    $0x3,%eax
 7f3:	83 ec 0c             	sub    $0xc,%esp
 7f6:	50                   	push   %eax
 7f7:	e8 19 fc ff ff       	call   415 <sbrk>
 7fc:	83 c4 10             	add    $0x10,%esp
 7ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 802:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 806:	75 07                	jne    80f <morecore+0x38>
    return 0;
 808:	b8 00 00 00 00       	mov    $0x0,%eax
 80d:	eb 26                	jmp    835 <morecore+0x5e>
  hp = (Header*)p;
 80f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 812:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 815:	8b 45 f0             	mov    -0x10(%ebp),%eax
 818:	8b 55 08             	mov    0x8(%ebp),%edx
 81b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 81e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 821:	83 c0 08             	add    $0x8,%eax
 824:	83 ec 0c             	sub    $0xc,%esp
 827:	50                   	push   %eax
 828:	e8 c8 fe ff ff       	call   6f5 <free>
 82d:	83 c4 10             	add    $0x10,%esp
  return freep;
 830:	a1 d8 0b 00 00       	mov    0xbd8,%eax
}
 835:	c9                   	leave  
 836:	c3                   	ret    

00000837 <malloc>:

void*
malloc(uint nbytes)
{
 837:	55                   	push   %ebp
 838:	89 e5                	mov    %esp,%ebp
 83a:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 83d:	8b 45 08             	mov    0x8(%ebp),%eax
 840:	83 c0 07             	add    $0x7,%eax
 843:	c1 e8 03             	shr    $0x3,%eax
 846:	83 c0 01             	add    $0x1,%eax
 849:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 84c:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 851:	89 45 f0             	mov    %eax,-0x10(%ebp)
 854:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 858:	75 23                	jne    87d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 85a:	c7 45 f0 d0 0b 00 00 	movl   $0xbd0,-0x10(%ebp)
 861:	8b 45 f0             	mov    -0x10(%ebp),%eax
 864:	a3 d8 0b 00 00       	mov    %eax,0xbd8
 869:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 86e:	a3 d0 0b 00 00       	mov    %eax,0xbd0
    base.s.size = 0;
 873:	c7 05 d4 0b 00 00 00 	movl   $0x0,0xbd4
 87a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 880:	8b 00                	mov    (%eax),%eax
 882:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 885:	8b 45 f4             	mov    -0xc(%ebp),%eax
 888:	8b 40 04             	mov    0x4(%eax),%eax
 88b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 88e:	72 4d                	jb     8dd <malloc+0xa6>
      if(p->s.size == nunits)
 890:	8b 45 f4             	mov    -0xc(%ebp),%eax
 893:	8b 40 04             	mov    0x4(%eax),%eax
 896:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 899:	75 0c                	jne    8a7 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	8b 10                	mov    (%eax),%edx
 8a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a3:	89 10                	mov    %edx,(%eax)
 8a5:	eb 26                	jmp    8cd <malloc+0x96>
      else {
        p->s.size -= nunits;
 8a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8aa:	8b 40 04             	mov    0x4(%eax),%eax
 8ad:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8b0:	89 c2                	mov    %eax,%edx
 8b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bb:	8b 40 04             	mov    0x4(%eax),%eax
 8be:	c1 e0 03             	shl    $0x3,%eax
 8c1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d0:	a3 d8 0b 00 00       	mov    %eax,0xbd8
      return (void*)(p + 1);
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	83 c0 08             	add    $0x8,%eax
 8db:	eb 3b                	jmp    918 <malloc+0xe1>
    }
    if(p == freep)
 8dd:	a1 d8 0b 00 00       	mov    0xbd8,%eax
 8e2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e5:	75 1e                	jne    905 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 8e7:	83 ec 0c             	sub    $0xc,%esp
 8ea:	ff 75 ec             	pushl  -0x14(%ebp)
 8ed:	e8 e5 fe ff ff       	call   7d7 <morecore>
 8f2:	83 c4 10             	add    $0x10,%esp
 8f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8fc:	75 07                	jne    905 <malloc+0xce>
        return 0;
 8fe:	b8 00 00 00 00       	mov    $0x0,%eax
 903:	eb 13                	jmp    918 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 905:	8b 45 f4             	mov    -0xc(%ebp),%eax
 908:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	8b 00                	mov    (%eax),%eax
 910:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 913:	e9 6d ff ff ff       	jmp    885 <malloc+0x4e>
}
 918:	c9                   	leave  
 919:	c3                   	ret    
