
_ps:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
*/
void convert_to_seconds(uint val, uint* sec, uint* dec);

int
main(int argc, char** argv)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 48             	sub    $0x48,%esp
  14:	89 c8                	mov    %ecx,%eax
  struct uproc* table;
  int max = 63;
  16:	c7 45 e4 3f 00 00 00 	movl   $0x3f,-0x1c(%ebp)
  int read;

  if(argc > 1)
  1d:	83 38 01             	cmpl   $0x1,(%eax)
  20:	7e 24                	jle    46 <main+0x46>
  {
    max = atoi(argv[1]);
  22:	8b 40 04             	mov    0x4(%eax),%eax
  25:	83 c0 04             	add    $0x4,%eax
  28:	8b 00                	mov    (%eax),%eax
  2a:	83 ec 0c             	sub    $0xc,%esp
  2d:	50                   	push   %eax
  2e:	e8 07 04 00 00       	call   43a <atoi>
  33:	83 c4 10             	add    $0x10,%esp
  36:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    if(max <= 0)
  39:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  3d:	7f 07                	jg     46 <main+0x46>
      max = 4;
  3f:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
  // The elapsed ticks in seconds, including the decimal component.
  uint elt_sec, elt_dec;
  // The total cpu ticks in second, with decimal component.
  uint cpu_sec, cpu_dec;

  table = (struct uproc*)malloc(sizeof(struct uproc) * max);
  46:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  49:	89 d0                	mov    %edx,%eax
  4b:	01 c0                	add    %eax,%eax
  4d:	01 d0                	add    %edx,%eax
  4f:	c1 e0 05             	shl    $0x5,%eax
  52:	83 ec 0c             	sub    $0xc,%esp
  55:	50                   	push   %eax
  56:	e8 60 09 00 00       	call   9bb <malloc>
  5b:	83 c4 10             	add    $0x10,%esp
  5e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  read = getprocs(max, table);
  61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  64:	83 ec 08             	sub    $0x8,%esp
  67:	ff 75 dc             	pushl  -0x24(%ebp)
  6a:	50                   	push   %eax
  6b:	e8 79 05 00 00       	call   5e9 <getprocs>
  70:	83 c4 10             	add    $0x10,%esp
  73:	89 45 d8             	mov    %eax,-0x28(%ebp)

  #ifndef CS333_P3P4
  printf(1, "%s	%s	%s	%s	%s	%s	%s			%s	%s\n", "id", "uid", "gid", "ppid", "elapsed time", "cpu time", "state", "size", "name");
  #else
  printf(1, "%s	%s	%s	%s	%s	%s	%s	%s		%s	%s\n", "id", "uid", "gid", "ppid", "prio", "elapsed time", "cpu time", "state", "size", "name");
  76:	68 a0 0a 00 00       	push   $0xaa0
  7b:	68 a5 0a 00 00       	push   $0xaa5
  80:	68 aa 0a 00 00       	push   $0xaaa
  85:	68 b0 0a 00 00       	push   $0xab0
  8a:	68 b9 0a 00 00       	push   $0xab9
  8f:	68 c6 0a 00 00       	push   $0xac6
  94:	68 cb 0a 00 00       	push   $0xacb
  99:	68 d0 0a 00 00       	push   $0xad0
  9e:	68 d4 0a 00 00       	push   $0xad4
  a3:	68 d8 0a 00 00       	push   $0xad8
  a8:	68 dc 0a 00 00       	push   $0xadc
  ad:	6a 01                	push   $0x1
  af:	e8 34 06 00 00       	call   6e8 <printf>
  b4:	83 c4 30             	add    $0x30,%esp
  #endif

  int i;
  for(i = 0; i < read; ++i)
  b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  be:	e9 54 01 00 00       	jmp    217 <main+0x217>
  {
    // Convert our values to seconds, but save the milliseconds.
    convert_to_seconds(table[i].elapsed_ticks, &elt_sec, &elt_dec);
  c3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  c6:	89 d0                	mov    %edx,%eax
  c8:	01 c0                	add    %eax,%eax
  ca:	01 d0                	add    %edx,%eax
  cc:	c1 e0 05             	shl    $0x5,%eax
  cf:	89 c2                	mov    %eax,%edx
  d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  d4:	01 d0                	add    %edx,%eax
  d6:	8b 40 10             	mov    0x10(%eax),%eax
  d9:	83 ec 04             	sub    $0x4,%esp
  dc:	8d 55 d0             	lea    -0x30(%ebp),%edx
  df:	52                   	push   %edx
  e0:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  e3:	52                   	push   %edx
  e4:	50                   	push   %eax
  e5:	e8 53 01 00 00       	call   23d <convert_to_seconds>
  ea:	83 c4 10             	add    $0x10,%esp
    convert_to_seconds(table[i].cpu_total_ticks, &cpu_sec, &cpu_dec);
  ed:	8b 55 e0             	mov    -0x20(%ebp),%edx
  f0:	89 d0                	mov    %edx,%eax
  f2:	01 c0                	add    %eax,%eax
  f4:	01 d0                	add    %edx,%eax
  f6:	c1 e0 05             	shl    $0x5,%eax
  f9:	89 c2                	mov    %eax,%edx
  fb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  fe:	01 d0                	add    %edx,%eax
 100:	8b 40 14             	mov    0x14(%eax),%eax
 103:	83 ec 04             	sub    $0x4,%esp
 106:	8d 55 c8             	lea    -0x38(%ebp),%edx
 109:	52                   	push   %edx
 10a:	8d 55 cc             	lea    -0x34(%ebp),%edx
 10d:	52                   	push   %edx
 10e:	50                   	push   %eax
 10f:	e8 29 01 00 00       	call   23d <convert_to_seconds>
 114:	83 c4 10             	add    $0x10,%esp
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
 117:	8b 55 e0             	mov    -0x20(%ebp),%edx
 11a:	89 d0                	mov    %edx,%eax
 11c:	01 c0                	add    %eax,%eax
 11e:	01 d0                	add    %edx,%eax
 120:	c1 e0 05             	shl    $0x5,%eax
 123:	89 c2                	mov    %eax,%edx
 125:	8b 45 dc             	mov    -0x24(%ebp),%eax
 128:	01 d0                	add    %edx,%eax
 12a:	83 c0 3c             	add    $0x3c,%eax
 12d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 130:	8b 55 e0             	mov    -0x20(%ebp),%edx
 133:	89 d0                	mov    %edx,%eax
 135:	01 c0                	add    %eax,%eax
 137:	01 d0                	add    %edx,%eax
 139:	c1 e0 05             	shl    $0x5,%eax
 13c:	89 c2                	mov    %eax,%edx
 13e:	8b 45 dc             	mov    -0x24(%ebp),%eax
 141:	01 d0                	add    %edx,%eax
    #ifndef CS333_P3P4
    printf(1, "%d	%d	%d	%d	%d.%d		%d.%d		%s		%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
 143:	8b 58 38             	mov    0x38(%eax),%ebx
 146:	89 5d c0             	mov    %ebx,-0x40(%ebp)
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
 149:	8b 55 e0             	mov    -0x20(%ebp),%edx
 14c:	89 d0                	mov    %edx,%eax
 14e:	01 c0                	add    %eax,%eax
 150:	01 d0                	add    %edx,%eax
 152:	c1 e0 05             	shl    $0x5,%eax
 155:	89 c2                	mov    %eax,%edx
 157:	8b 45 dc             	mov    -0x24(%ebp),%eax
 15a:	01 d0                	add    %edx,%eax
 15c:	8d 70 18             	lea    0x18(%eax),%esi
 15f:	89 75 bc             	mov    %esi,-0x44(%ebp)
    #ifndef CS333_P3P4
    printf(1, "%d	%d	%d	%d	%d.%d		%d.%d		%s		%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
 162:	8b 7d c8             	mov    -0x38(%ebp),%edi
 165:	89 7d b8             	mov    %edi,-0x48(%ebp)
 168:	8b 4d cc             	mov    -0x34(%ebp),%ecx
 16b:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
 16e:	8b 55 d0             	mov    -0x30(%ebp),%edx
 171:	89 55 b0             	mov    %edx,-0x50(%ebp)
 174:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 177:	89 45 ac             	mov    %eax,-0x54(%ebp)
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
 17a:	8b 55 e0             	mov    -0x20(%ebp),%edx
 17d:	89 d0                	mov    %edx,%eax
 17f:	01 c0                	add    %eax,%eax
 181:	01 d0                	add    %edx,%eax
 183:	c1 e0 05             	shl    $0x5,%eax
 186:	89 c2                	mov    %eax,%edx
 188:	8b 45 dc             	mov    -0x24(%ebp),%eax
 18b:	01 d0                	add    %edx,%eax
    #ifndef CS333_P3P4
    printf(1, "%d	%d	%d	%d	%d.%d		%d.%d		%s		%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
 18d:	8b 78 5c             	mov    0x5c(%eax),%edi
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
 190:	8b 55 e0             	mov    -0x20(%ebp),%edx
 193:	89 d0                	mov    %edx,%eax
 195:	01 c0                	add    %eax,%eax
 197:	01 d0                	add    %edx,%eax
 199:	c1 e0 05             	shl    $0x5,%eax
 19c:	89 c2                	mov    %eax,%edx
 19e:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
    #ifndef CS333_P3P4
    printf(1, "%d	%d	%d	%d	%d.%d		%d.%d		%s		%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
 1a3:	8b 70 0c             	mov    0xc(%eax),%esi
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
 1a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
 1a9:	89 d0                	mov    %edx,%eax
 1ab:	01 c0                	add    %eax,%eax
 1ad:	01 d0                	add    %edx,%eax
 1af:	c1 e0 05             	shl    $0x5,%eax
 1b2:	89 c2                	mov    %eax,%edx
 1b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1b7:	01 d0                	add    %edx,%eax
    #ifndef CS333_P3P4
    printf(1, "%d	%d	%d	%d	%d.%d		%d.%d		%s		%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
 1b9:	8b 58 08             	mov    0x8(%eax),%ebx
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
 1bc:	8b 55 e0             	mov    -0x20(%ebp),%edx
 1bf:	89 d0                	mov    %edx,%eax
 1c1:	01 c0                	add    %eax,%eax
 1c3:	01 d0                	add    %edx,%eax
 1c5:	c1 e0 05             	shl    $0x5,%eax
 1c8:	89 c2                	mov    %eax,%edx
 1ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1cd:	01 d0                	add    %edx,%eax
    #ifndef CS333_P3P4
    printf(1, "%d	%d	%d	%d	%d.%d		%d.%d		%s		%d	%s\n", table[i].pid,
		   table[i].uid, table[i].gid, table[i].ppid, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #else
    printf(1, "%d	%d	%d	%d	%d	%d.%d		%d.%d		%s	%d	%s\n", table[i].pid,
 1cf:	8b 48 04             	mov    0x4(%eax),%ecx
 1d2:	8b 55 e0             	mov    -0x20(%ebp),%edx
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	01 c0                	add    %eax,%eax
 1d9:	01 d0                	add    %edx,%eax
 1db:	c1 e0 05             	shl    $0x5,%eax
 1de:	89 c2                	mov    %eax,%edx
 1e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
 1e3:	01 d0                	add    %edx,%eax
 1e5:	8b 00                	mov    (%eax),%eax
 1e7:	83 ec 08             	sub    $0x8,%esp
 1ea:	ff 75 c4             	pushl  -0x3c(%ebp)
 1ed:	ff 75 c0             	pushl  -0x40(%ebp)
 1f0:	ff 75 bc             	pushl  -0x44(%ebp)
 1f3:	ff 75 b8             	pushl  -0x48(%ebp)
 1f6:	ff 75 b4             	pushl  -0x4c(%ebp)
 1f9:	ff 75 b0             	pushl  -0x50(%ebp)
 1fc:	ff 75 ac             	pushl  -0x54(%ebp)
 1ff:	57                   	push   %edi
 200:	56                   	push   %esi
 201:	53                   	push   %ebx
 202:	51                   	push   %ecx
 203:	50                   	push   %eax
 204:	68 fc 0a 00 00       	push   $0xafc
 209:	6a 01                	push   $0x1
 20b:	e8 d8 04 00 00       	call   6e8 <printf>
 210:	83 c4 40             	add    $0x40,%esp
  #else
  printf(1, "%s	%s	%s	%s	%s	%s	%s	%s		%s	%s\n", "id", "uid", "gid", "ppid", "prio", "elapsed time", "cpu time", "state", "size", "name");
  #endif

  int i;
  for(i = 0; i < read; ++i)
 213:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
 217:	8b 45 e0             	mov    -0x20(%ebp),%eax
 21a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
 21d:	0f 8c a0 fe ff ff    	jl     c3 <main+0xc3>
		   table[i].uid, table[i].gid, table[i].ppid, table[i].priority, elt_sec, elt_dec,
		   cpu_sec, cpu_dec, table[i].state, table[i].size, table[i].name);
    #endif
  }

  free(table);
 223:	83 ec 0c             	sub    $0xc,%esp
 226:	ff 75 dc             	pushl  -0x24(%ebp)
 229:	e8 4b 06 00 00       	call   879 <free>
 22e:	83 c4 10             	add    $0x10,%esp
  table = 0x0;
 231:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  exit();
 238:	e8 d4 02 00 00       	call   511 <exit>

0000023d <convert_to_seconds>:
}

void
convert_to_seconds(uint val, uint* sec, uint* dec)
{
 23d:	55                   	push   %ebp
 23e:	89 e5                	mov    %esp,%ebp
	*sec = val / 1000;
 240:	8b 45 08             	mov    0x8(%ebp),%eax
 243:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 248:	f7 e2                	mul    %edx
 24a:	c1 ea 06             	shr    $0x6,%edx
 24d:	8b 45 0c             	mov    0xc(%ebp),%eax
 250:	89 10                	mov    %edx,(%eax)
	*dec = val % 1000;
 252:	8b 4d 08             	mov    0x8(%ebp),%ecx
 255:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
 25a:	89 c8                	mov    %ecx,%eax
 25c:	f7 e2                	mul    %edx
 25e:	89 d0                	mov    %edx,%eax
 260:	c1 e8 06             	shr    $0x6,%eax
 263:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
 269:	29 c1                	sub    %eax,%ecx
 26b:	89 c8                	mov    %ecx,%eax
 26d:	8b 55 10             	mov    0x10(%ebp),%edx
 270:	89 02                	mov    %eax,(%edx)
	//*sec = val;
	//*dec = 0;
}
 272:	90                   	nop
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    

00000275 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	57                   	push   %edi
 279:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 27a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 27d:	8b 55 10             	mov    0x10(%ebp),%edx
 280:	8b 45 0c             	mov    0xc(%ebp),%eax
 283:	89 cb                	mov    %ecx,%ebx
 285:	89 df                	mov    %ebx,%edi
 287:	89 d1                	mov    %edx,%ecx
 289:	fc                   	cld    
 28a:	f3 aa                	rep stos %al,%es:(%edi)
 28c:	89 ca                	mov    %ecx,%edx
 28e:	89 fb                	mov    %edi,%ebx
 290:	89 5d 08             	mov    %ebx,0x8(%ebp)
 293:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 296:	90                   	nop
 297:	5b                   	pop    %ebx
 298:	5f                   	pop    %edi
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    

0000029b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
 29e:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 2a1:	8b 45 08             	mov    0x8(%ebp),%eax
 2a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 2a7:	90                   	nop
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	8d 50 01             	lea    0x1(%eax),%edx
 2ae:	89 55 08             	mov    %edx,0x8(%ebp)
 2b1:	8b 55 0c             	mov    0xc(%ebp),%edx
 2b4:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2ba:	0f b6 12             	movzbl (%edx),%edx
 2bd:	88 10                	mov    %dl,(%eax)
 2bf:	0f b6 00             	movzbl (%eax),%eax
 2c2:	84 c0                	test   %al,%al
 2c4:	75 e2                	jne    2a8 <strcpy+0xd>
    ;
  return os;
 2c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2c9:	c9                   	leave  
 2ca:	c3                   	ret    

000002cb <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2cb:	55                   	push   %ebp
 2cc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2ce:	eb 08                	jmp    2d8 <strcmp+0xd>
    p++, q++;
 2d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2d4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	0f b6 00             	movzbl (%eax),%eax
 2de:	84 c0                	test   %al,%al
 2e0:	74 10                	je     2f2 <strcmp+0x27>
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	0f b6 10             	movzbl (%eax),%edx
 2e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2eb:	0f b6 00             	movzbl (%eax),%eax
 2ee:	38 c2                	cmp    %al,%dl
 2f0:	74 de                	je     2d0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	0f b6 00             	movzbl (%eax),%eax
 2f8:	0f b6 d0             	movzbl %al,%edx
 2fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fe:	0f b6 00             	movzbl (%eax),%eax
 301:	0f b6 c0             	movzbl %al,%eax
 304:	29 c2                	sub    %eax,%edx
 306:	89 d0                	mov    %edx,%eax
}
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    

0000030a <strlen>:

uint
strlen(char *s)
{
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 310:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 317:	eb 04                	jmp    31d <strlen+0x13>
 319:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 31d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 320:	8b 45 08             	mov    0x8(%ebp),%eax
 323:	01 d0                	add    %edx,%eax
 325:	0f b6 00             	movzbl (%eax),%eax
 328:	84 c0                	test   %al,%al
 32a:	75 ed                	jne    319 <strlen+0xf>
    ;
  return n;
 32c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 32f:	c9                   	leave  
 330:	c3                   	ret    

00000331 <memset>:

void*
memset(void *dst, int c, uint n)
{
 331:	55                   	push   %ebp
 332:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 334:	8b 45 10             	mov    0x10(%ebp),%eax
 337:	50                   	push   %eax
 338:	ff 75 0c             	pushl  0xc(%ebp)
 33b:	ff 75 08             	pushl  0x8(%ebp)
 33e:	e8 32 ff ff ff       	call   275 <stosb>
 343:	83 c4 0c             	add    $0xc,%esp
  return dst;
 346:	8b 45 08             	mov    0x8(%ebp),%eax
}
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <strchr>:

char*
strchr(const char *s, char c)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	83 ec 04             	sub    $0x4,%esp
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 357:	eb 14                	jmp    36d <strchr+0x22>
    if(*s == c)
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	0f b6 00             	movzbl (%eax),%eax
 35f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 362:	75 05                	jne    369 <strchr+0x1e>
      return (char*)s;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	eb 13                	jmp    37c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 369:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	0f b6 00             	movzbl (%eax),%eax
 373:	84 c0                	test   %al,%al
 375:	75 e2                	jne    359 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 377:	b8 00 00 00 00       	mov    $0x0,%eax
}
 37c:	c9                   	leave  
 37d:	c3                   	ret    

0000037e <gets>:

char*
gets(char *buf, int max)
{
 37e:	55                   	push   %ebp
 37f:	89 e5                	mov    %esp,%ebp
 381:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 38b:	eb 42                	jmp    3cf <gets+0x51>
    cc = read(0, &c, 1);
 38d:	83 ec 04             	sub    $0x4,%esp
 390:	6a 01                	push   $0x1
 392:	8d 45 ef             	lea    -0x11(%ebp),%eax
 395:	50                   	push   %eax
 396:	6a 00                	push   $0x0
 398:	e8 8c 01 00 00       	call   529 <read>
 39d:	83 c4 10             	add    $0x10,%esp
 3a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 3a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3a7:	7e 33                	jle    3dc <gets+0x5e>
      break;
    buf[i++] = c;
 3a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ac:	8d 50 01             	lea    0x1(%eax),%edx
 3af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3b2:	89 c2                	mov    %eax,%edx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	01 c2                	add    %eax,%edx
 3b9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3bd:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 3bf:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3c3:	3c 0a                	cmp    $0xa,%al
 3c5:	74 16                	je     3dd <gets+0x5f>
 3c7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 3cb:	3c 0d                	cmp    $0xd,%al
 3cd:	74 0e                	je     3dd <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3d2:	83 c0 01             	add    $0x1,%eax
 3d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
 3d8:	7c b3                	jl     38d <gets+0xf>
 3da:	eb 01                	jmp    3dd <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 3dc:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 3dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	01 d0                	add    %edx,%eax
 3e5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3eb:	c9                   	leave  
 3ec:	c3                   	ret    

000003ed <stat>:

int
stat(char *n, struct stat *st)
{
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3f3:	83 ec 08             	sub    $0x8,%esp
 3f6:	6a 00                	push   $0x0
 3f8:	ff 75 08             	pushl  0x8(%ebp)
 3fb:	e8 51 01 00 00       	call   551 <open>
 400:	83 c4 10             	add    $0x10,%esp
 403:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 406:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 40a:	79 07                	jns    413 <stat+0x26>
    return -1;
 40c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 411:	eb 25                	jmp    438 <stat+0x4b>
  r = fstat(fd, st);
 413:	83 ec 08             	sub    $0x8,%esp
 416:	ff 75 0c             	pushl  0xc(%ebp)
 419:	ff 75 f4             	pushl  -0xc(%ebp)
 41c:	e8 48 01 00 00       	call   569 <fstat>
 421:	83 c4 10             	add    $0x10,%esp
 424:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 427:	83 ec 0c             	sub    $0xc,%esp
 42a:	ff 75 f4             	pushl  -0xc(%ebp)
 42d:	e8 07 01 00 00       	call   539 <close>
 432:	83 c4 10             	add    $0x10,%esp
  return r;
 435:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <atoi>:

int
atoi(const char *s)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
 440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
 447:	eb 04                	jmp    44d <atoi+0x13>
 449:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	3c 20                	cmp    $0x20,%al
 455:	74 f2                	je     449 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
 457:	8b 45 08             	mov    0x8(%ebp),%eax
 45a:	0f b6 00             	movzbl (%eax),%eax
 45d:	3c 2d                	cmp    $0x2d,%al
 45f:	75 07                	jne    468 <atoi+0x2e>
 461:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 466:	eb 05                	jmp    46d <atoi+0x33>
 468:	b8 01 00 00 00       	mov    $0x1,%eax
 46d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
 470:	8b 45 08             	mov    0x8(%ebp),%eax
 473:	0f b6 00             	movzbl (%eax),%eax
 476:	3c 2b                	cmp    $0x2b,%al
 478:	74 0a                	je     484 <atoi+0x4a>
 47a:	8b 45 08             	mov    0x8(%ebp),%eax
 47d:	0f b6 00             	movzbl (%eax),%eax
 480:	3c 2d                	cmp    $0x2d,%al
 482:	75 2b                	jne    4af <atoi+0x75>
    s++;
 484:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
 488:	eb 25                	jmp    4af <atoi+0x75>
    n = n*10 + *s++ - '0';
 48a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 48d:	89 d0                	mov    %edx,%eax
 48f:	c1 e0 02             	shl    $0x2,%eax
 492:	01 d0                	add    %edx,%eax
 494:	01 c0                	add    %eax,%eax
 496:	89 c1                	mov    %eax,%ecx
 498:	8b 45 08             	mov    0x8(%ebp),%eax
 49b:	8d 50 01             	lea    0x1(%eax),%edx
 49e:	89 55 08             	mov    %edx,0x8(%ebp)
 4a1:	0f b6 00             	movzbl (%eax),%eax
 4a4:	0f be c0             	movsbl %al,%eax
 4a7:	01 c8                	add    %ecx,%eax
 4a9:	83 e8 30             	sub    $0x30,%eax
 4ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	0f b6 00             	movzbl (%eax),%eax
 4b5:	3c 2f                	cmp    $0x2f,%al
 4b7:	7e 0a                	jle    4c3 <atoi+0x89>
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	0f b6 00             	movzbl (%eax),%eax
 4bf:	3c 39                	cmp    $0x39,%al
 4c1:	7e c7                	jle    48a <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
 4c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4c6:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
 4ca:	c9                   	leave  
 4cb:	c3                   	ret    

000004cc <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 4d2:	8b 45 08             	mov    0x8(%ebp),%eax
 4d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 4d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 4de:	eb 17                	jmp    4f7 <memmove+0x2b>
    *dst++ = *src++;
 4e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4e3:	8d 50 01             	lea    0x1(%eax),%edx
 4e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
 4e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4ec:	8d 4a 01             	lea    0x1(%edx),%ecx
 4ef:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 4f2:	0f b6 12             	movzbl (%edx),%edx
 4f5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4f7:	8b 45 10             	mov    0x10(%ebp),%eax
 4fa:	8d 50 ff             	lea    -0x1(%eax),%edx
 4fd:	89 55 10             	mov    %edx,0x10(%ebp)
 500:	85 c0                	test   %eax,%eax
 502:	7f dc                	jg     4e0 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 504:	8b 45 08             	mov    0x8(%ebp),%eax
}
 507:	c9                   	leave  
 508:	c3                   	ret    

00000509 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 509:	b8 01 00 00 00       	mov    $0x1,%eax
 50e:	cd 40                	int    $0x40
 510:	c3                   	ret    

00000511 <exit>:
SYSCALL(exit)
 511:	b8 02 00 00 00       	mov    $0x2,%eax
 516:	cd 40                	int    $0x40
 518:	c3                   	ret    

00000519 <wait>:
SYSCALL(wait)
 519:	b8 03 00 00 00       	mov    $0x3,%eax
 51e:	cd 40                	int    $0x40
 520:	c3                   	ret    

00000521 <pipe>:
SYSCALL(pipe)
 521:	b8 04 00 00 00       	mov    $0x4,%eax
 526:	cd 40                	int    $0x40
 528:	c3                   	ret    

00000529 <read>:
SYSCALL(read)
 529:	b8 05 00 00 00       	mov    $0x5,%eax
 52e:	cd 40                	int    $0x40
 530:	c3                   	ret    

00000531 <write>:
SYSCALL(write)
 531:	b8 10 00 00 00       	mov    $0x10,%eax
 536:	cd 40                	int    $0x40
 538:	c3                   	ret    

00000539 <close>:
SYSCALL(close)
 539:	b8 15 00 00 00       	mov    $0x15,%eax
 53e:	cd 40                	int    $0x40
 540:	c3                   	ret    

00000541 <kill>:
SYSCALL(kill)
 541:	b8 06 00 00 00       	mov    $0x6,%eax
 546:	cd 40                	int    $0x40
 548:	c3                   	ret    

00000549 <exec>:
SYSCALL(exec)
 549:	b8 07 00 00 00       	mov    $0x7,%eax
 54e:	cd 40                	int    $0x40
 550:	c3                   	ret    

00000551 <open>:
SYSCALL(open)
 551:	b8 0f 00 00 00       	mov    $0xf,%eax
 556:	cd 40                	int    $0x40
 558:	c3                   	ret    

00000559 <mknod>:
SYSCALL(mknod)
 559:	b8 11 00 00 00       	mov    $0x11,%eax
 55e:	cd 40                	int    $0x40
 560:	c3                   	ret    

00000561 <unlink>:
SYSCALL(unlink)
 561:	b8 12 00 00 00       	mov    $0x12,%eax
 566:	cd 40                	int    $0x40
 568:	c3                   	ret    

00000569 <fstat>:
SYSCALL(fstat)
 569:	b8 08 00 00 00       	mov    $0x8,%eax
 56e:	cd 40                	int    $0x40
 570:	c3                   	ret    

00000571 <link>:
SYSCALL(link)
 571:	b8 13 00 00 00       	mov    $0x13,%eax
 576:	cd 40                	int    $0x40
 578:	c3                   	ret    

00000579 <mkdir>:
SYSCALL(mkdir)
 579:	b8 14 00 00 00       	mov    $0x14,%eax
 57e:	cd 40                	int    $0x40
 580:	c3                   	ret    

00000581 <chdir>:
SYSCALL(chdir)
 581:	b8 09 00 00 00       	mov    $0x9,%eax
 586:	cd 40                	int    $0x40
 588:	c3                   	ret    

00000589 <dup>:
SYSCALL(dup)
 589:	b8 0a 00 00 00       	mov    $0xa,%eax
 58e:	cd 40                	int    $0x40
 590:	c3                   	ret    

00000591 <getpid>:
SYSCALL(getpid)
 591:	b8 0b 00 00 00       	mov    $0xb,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <sbrk>:
SYSCALL(sbrk)
 599:	b8 0c 00 00 00       	mov    $0xc,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <sleep>:
SYSCALL(sleep)
 5a1:	b8 0d 00 00 00       	mov    $0xd,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <uptime>:
SYSCALL(uptime)
 5a9:	b8 0e 00 00 00       	mov    $0xe,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <halt>:
SYSCALL(halt)
 5b1:	b8 16 00 00 00       	mov    $0x16,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <date>:
SYSCALL(date)
 5b9:	b8 17 00 00 00       	mov    $0x17,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <getuid>:
SYSCALL(getuid)
 5c1:	b8 18 00 00 00       	mov    $0x18,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <getgid>:
SYSCALL(getgid)
 5c9:	b8 19 00 00 00       	mov    $0x19,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <getppid>:
SYSCALL(getppid)
 5d1:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <setuid>:
SYSCALL(setuid)
 5d9:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <setgid>:
SYSCALL(setgid)
 5e1:	b8 1c 00 00 00       	mov    $0x1c,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <getprocs>:
SYSCALL(getprocs)
 5e9:	b8 1d 00 00 00       	mov    $0x1d,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <setpriority>:
SYSCALL(setpriority)
 5f1:	b8 1e 00 00 00       	mov    $0x1e,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <chmod>:
SYSCALL(chmod)
 5f9:	b8 1f 00 00 00       	mov    $0x1f,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <chown>:
SYSCALL(chown)
 601:	b8 20 00 00 00       	mov    $0x20,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <chgrp>:
SYSCALL(chgrp)
 609:	b8 21 00 00 00       	mov    $0x21,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 611:	55                   	push   %ebp
 612:	89 e5                	mov    %esp,%ebp
 614:	83 ec 18             	sub    $0x18,%esp
 617:	8b 45 0c             	mov    0xc(%ebp),%eax
 61a:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 61d:	83 ec 04             	sub    $0x4,%esp
 620:	6a 01                	push   $0x1
 622:	8d 45 f4             	lea    -0xc(%ebp),%eax
 625:	50                   	push   %eax
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 03 ff ff ff       	call   531 <write>
 62e:	83 c4 10             	add    $0x10,%esp
}
 631:	90                   	nop
 632:	c9                   	leave  
 633:	c3                   	ret    

00000634 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 634:	55                   	push   %ebp
 635:	89 e5                	mov    %esp,%ebp
 637:	53                   	push   %ebx
 638:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 63b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 642:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 646:	74 17                	je     65f <printint+0x2b>
 648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 64c:	79 11                	jns    65f <printint+0x2b>
    neg = 1;
 64e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 655:	8b 45 0c             	mov    0xc(%ebp),%eax
 658:	f7 d8                	neg    %eax
 65a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 65d:	eb 06                	jmp    665 <printint+0x31>
  } else {
    x = xx;
 65f:	8b 45 0c             	mov    0xc(%ebp),%eax
 662:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 66c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 66f:	8d 41 01             	lea    0x1(%ecx),%eax
 672:	89 45 f4             	mov    %eax,-0xc(%ebp)
 675:	8b 5d 10             	mov    0x10(%ebp),%ebx
 678:	8b 45 ec             	mov    -0x14(%ebp),%eax
 67b:	ba 00 00 00 00       	mov    $0x0,%edx
 680:	f7 f3                	div    %ebx
 682:	89 d0                	mov    %edx,%eax
 684:	0f b6 80 a0 0d 00 00 	movzbl 0xda0(%eax),%eax
 68b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 68f:	8b 5d 10             	mov    0x10(%ebp),%ebx
 692:	8b 45 ec             	mov    -0x14(%ebp),%eax
 695:	ba 00 00 00 00       	mov    $0x0,%edx
 69a:	f7 f3                	div    %ebx
 69c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 69f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6a3:	75 c7                	jne    66c <printint+0x38>
  if(neg)
 6a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6a9:	74 2d                	je     6d8 <printint+0xa4>
    buf[i++] = '-';
 6ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ae:	8d 50 01             	lea    0x1(%eax),%edx
 6b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6b4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6b9:	eb 1d                	jmp    6d8 <printint+0xa4>
    putc(fd, buf[i]);
 6bb:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c1:	01 d0                	add    %edx,%eax
 6c3:	0f b6 00             	movzbl (%eax),%eax
 6c6:	0f be c0             	movsbl %al,%eax
 6c9:	83 ec 08             	sub    $0x8,%esp
 6cc:	50                   	push   %eax
 6cd:	ff 75 08             	pushl  0x8(%ebp)
 6d0:	e8 3c ff ff ff       	call   611 <putc>
 6d5:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 6d8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e0:	79 d9                	jns    6bb <printint+0x87>
    putc(fd, buf[i]);
}
 6e2:	90                   	nop
 6e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    

000006e8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ee:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6f5:	8d 45 0c             	lea    0xc(%ebp),%eax
 6f8:	83 c0 04             	add    $0x4,%eax
 6fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6fe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 705:	e9 59 01 00 00       	jmp    863 <printf+0x17b>
    c = fmt[i] & 0xff;
 70a:	8b 55 0c             	mov    0xc(%ebp),%edx
 70d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 710:	01 d0                	add    %edx,%eax
 712:	0f b6 00             	movzbl (%eax),%eax
 715:	0f be c0             	movsbl %al,%eax
 718:	25 ff 00 00 00       	and    $0xff,%eax
 71d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 720:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 724:	75 2c                	jne    752 <printf+0x6a>
      if(c == '%'){
 726:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 72a:	75 0c                	jne    738 <printf+0x50>
        state = '%';
 72c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 733:	e9 27 01 00 00       	jmp    85f <printf+0x177>
      } else {
        putc(fd, c);
 738:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 73b:	0f be c0             	movsbl %al,%eax
 73e:	83 ec 08             	sub    $0x8,%esp
 741:	50                   	push   %eax
 742:	ff 75 08             	pushl  0x8(%ebp)
 745:	e8 c7 fe ff ff       	call   611 <putc>
 74a:	83 c4 10             	add    $0x10,%esp
 74d:	e9 0d 01 00 00       	jmp    85f <printf+0x177>
      }
    } else if(state == '%'){
 752:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 756:	0f 85 03 01 00 00    	jne    85f <printf+0x177>
      if(c == 'd'){
 75c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 760:	75 1e                	jne    780 <printf+0x98>
        printint(fd, *ap, 10, 1);
 762:	8b 45 e8             	mov    -0x18(%ebp),%eax
 765:	8b 00                	mov    (%eax),%eax
 767:	6a 01                	push   $0x1
 769:	6a 0a                	push   $0xa
 76b:	50                   	push   %eax
 76c:	ff 75 08             	pushl  0x8(%ebp)
 76f:	e8 c0 fe ff ff       	call   634 <printint>
 774:	83 c4 10             	add    $0x10,%esp
        ap++;
 777:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 77b:	e9 d8 00 00 00       	jmp    858 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 780:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 784:	74 06                	je     78c <printf+0xa4>
 786:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 78a:	75 1e                	jne    7aa <printf+0xc2>
        printint(fd, *ap, 16, 0);
 78c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	6a 00                	push   $0x0
 793:	6a 10                	push   $0x10
 795:	50                   	push   %eax
 796:	ff 75 08             	pushl  0x8(%ebp)
 799:	e8 96 fe ff ff       	call   634 <printint>
 79e:	83 c4 10             	add    $0x10,%esp
        ap++;
 7a1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a5:	e9 ae 00 00 00       	jmp    858 <printf+0x170>
      } else if(c == 's'){
 7aa:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7ae:	75 43                	jne    7f3 <printf+0x10b>
        s = (char*)*ap;
 7b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b3:	8b 00                	mov    (%eax),%eax
 7b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c0:	75 25                	jne    7e7 <printf+0xff>
          s = "(null)";
 7c2:	c7 45 f4 23 0b 00 00 	movl   $0xb23,-0xc(%ebp)
        while(*s != 0){
 7c9:	eb 1c                	jmp    7e7 <printf+0xff>
          putc(fd, *s);
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	0f b6 00             	movzbl (%eax),%eax
 7d1:	0f be c0             	movsbl %al,%eax
 7d4:	83 ec 08             	sub    $0x8,%esp
 7d7:	50                   	push   %eax
 7d8:	ff 75 08             	pushl  0x8(%ebp)
 7db:	e8 31 fe ff ff       	call   611 <putc>
 7e0:	83 c4 10             	add    $0x10,%esp
          s++;
 7e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	0f b6 00             	movzbl (%eax),%eax
 7ed:	84 c0                	test   %al,%al
 7ef:	75 da                	jne    7cb <printf+0xe3>
 7f1:	eb 65                	jmp    858 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7f3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7f7:	75 1d                	jne    816 <printf+0x12e>
        putc(fd, *ap);
 7f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	0f be c0             	movsbl %al,%eax
 801:	83 ec 08             	sub    $0x8,%esp
 804:	50                   	push   %eax
 805:	ff 75 08             	pushl  0x8(%ebp)
 808:	e8 04 fe ff ff       	call   611 <putc>
 80d:	83 c4 10             	add    $0x10,%esp
        ap++;
 810:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 814:	eb 42                	jmp    858 <printf+0x170>
      } else if(c == '%'){
 816:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 81a:	75 17                	jne    833 <printf+0x14b>
        putc(fd, c);
 81c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 81f:	0f be c0             	movsbl %al,%eax
 822:	83 ec 08             	sub    $0x8,%esp
 825:	50                   	push   %eax
 826:	ff 75 08             	pushl  0x8(%ebp)
 829:	e8 e3 fd ff ff       	call   611 <putc>
 82e:	83 c4 10             	add    $0x10,%esp
 831:	eb 25                	jmp    858 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 833:	83 ec 08             	sub    $0x8,%esp
 836:	6a 25                	push   $0x25
 838:	ff 75 08             	pushl  0x8(%ebp)
 83b:	e8 d1 fd ff ff       	call   611 <putc>
 840:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 843:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 846:	0f be c0             	movsbl %al,%eax
 849:	83 ec 08             	sub    $0x8,%esp
 84c:	50                   	push   %eax
 84d:	ff 75 08             	pushl  0x8(%ebp)
 850:	e8 bc fd ff ff       	call   611 <putc>
 855:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 858:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 85f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 863:	8b 55 0c             	mov    0xc(%ebp),%edx
 866:	8b 45 f0             	mov    -0x10(%ebp),%eax
 869:	01 d0                	add    %edx,%eax
 86b:	0f b6 00             	movzbl (%eax),%eax
 86e:	84 c0                	test   %al,%al
 870:	0f 85 94 fe ff ff    	jne    70a <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 876:	90                   	nop
 877:	c9                   	leave  
 878:	c3                   	ret    

00000879 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 879:	55                   	push   %ebp
 87a:	89 e5                	mov    %esp,%ebp
 87c:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	83 e8 08             	sub    $0x8,%eax
 885:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 888:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 88d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 890:	eb 24                	jmp    8b6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 892:	8b 45 fc             	mov    -0x4(%ebp),%eax
 895:	8b 00                	mov    (%eax),%eax
 897:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 89a:	77 12                	ja     8ae <free+0x35>
 89c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8a2:	77 24                	ja     8c8 <free+0x4f>
 8a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a7:	8b 00                	mov    (%eax),%eax
 8a9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ac:	77 1a                	ja     8c8 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b1:	8b 00                	mov    (%eax),%eax
 8b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8bc:	76 d4                	jbe    892 <free+0x19>
 8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c1:	8b 00                	mov    (%eax),%eax
 8c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8c6:	76 ca                	jbe    892 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 8c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cb:	8b 40 04             	mov    0x4(%eax),%eax
 8ce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8d8:	01 c2                	add    %eax,%edx
 8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dd:	8b 00                	mov    (%eax),%eax
 8df:	39 c2                	cmp    %eax,%edx
 8e1:	75 24                	jne    907 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e6:	8b 50 04             	mov    0x4(%eax),%edx
 8e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ec:	8b 00                	mov    (%eax),%eax
 8ee:	8b 40 04             	mov    0x4(%eax),%eax
 8f1:	01 c2                	add    %eax,%edx
 8f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f6:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fc:	8b 00                	mov    (%eax),%eax
 8fe:	8b 10                	mov    (%eax),%edx
 900:	8b 45 f8             	mov    -0x8(%ebp),%eax
 903:	89 10                	mov    %edx,(%eax)
 905:	eb 0a                	jmp    911 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 907:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90a:	8b 10                	mov    (%eax),%edx
 90c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	8b 40 04             	mov    0x4(%eax),%eax
 917:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 91e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 921:	01 d0                	add    %edx,%eax
 923:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 926:	75 20                	jne    948 <free+0xcf>
    p->s.size += bp->s.size;
 928:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92b:	8b 50 04             	mov    0x4(%eax),%edx
 92e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 931:	8b 40 04             	mov    0x4(%eax),%eax
 934:	01 c2                	add    %eax,%edx
 936:	8b 45 fc             	mov    -0x4(%ebp),%eax
 939:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 93c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93f:	8b 10                	mov    (%eax),%edx
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	89 10                	mov    %edx,(%eax)
 946:	eb 08                	jmp    950 <free+0xd7>
  } else
    p->s.ptr = bp;
 948:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 94e:	89 10                	mov    %edx,(%eax)
  freep = p;
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	a3 bc 0d 00 00       	mov    %eax,0xdbc
}
 958:	90                   	nop
 959:	c9                   	leave  
 95a:	c3                   	ret    

0000095b <morecore>:

static Header*
morecore(uint nu)
{
 95b:	55                   	push   %ebp
 95c:	89 e5                	mov    %esp,%ebp
 95e:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 961:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 968:	77 07                	ja     971 <morecore+0x16>
    nu = 4096;
 96a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 971:	8b 45 08             	mov    0x8(%ebp),%eax
 974:	c1 e0 03             	shl    $0x3,%eax
 977:	83 ec 0c             	sub    $0xc,%esp
 97a:	50                   	push   %eax
 97b:	e8 19 fc ff ff       	call   599 <sbrk>
 980:	83 c4 10             	add    $0x10,%esp
 983:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 986:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 98a:	75 07                	jne    993 <morecore+0x38>
    return 0;
 98c:	b8 00 00 00 00       	mov    $0x0,%eax
 991:	eb 26                	jmp    9b9 <morecore+0x5e>
  hp = (Header*)p;
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 999:	8b 45 f0             	mov    -0x10(%ebp),%eax
 99c:	8b 55 08             	mov    0x8(%ebp),%edx
 99f:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a5:	83 c0 08             	add    $0x8,%eax
 9a8:	83 ec 0c             	sub    $0xc,%esp
 9ab:	50                   	push   %eax
 9ac:	e8 c8 fe ff ff       	call   879 <free>
 9b1:	83 c4 10             	add    $0x10,%esp
  return freep;
 9b4:	a1 bc 0d 00 00       	mov    0xdbc,%eax
}
 9b9:	c9                   	leave  
 9ba:	c3                   	ret    

000009bb <malloc>:

void*
malloc(uint nbytes)
{
 9bb:	55                   	push   %ebp
 9bc:	89 e5                	mov    %esp,%ebp
 9be:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c1:	8b 45 08             	mov    0x8(%ebp),%eax
 9c4:	83 c0 07             	add    $0x7,%eax
 9c7:	c1 e8 03             	shr    $0x3,%eax
 9ca:	83 c0 01             	add    $0x1,%eax
 9cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9d0:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 9d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9d8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9dc:	75 23                	jne    a01 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9de:	c7 45 f0 b4 0d 00 00 	movl   $0xdb4,-0x10(%ebp)
 9e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e8:	a3 bc 0d 00 00       	mov    %eax,0xdbc
 9ed:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 9f2:	a3 b4 0d 00 00       	mov    %eax,0xdb4
    base.s.size = 0;
 9f7:	c7 05 b8 0d 00 00 00 	movl   $0x0,0xdb8
 9fe:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a04:	8b 00                	mov    (%eax),%eax
 a06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0c:	8b 40 04             	mov    0x4(%eax),%eax
 a0f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a12:	72 4d                	jb     a61 <malloc+0xa6>
      if(p->s.size == nunits)
 a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a17:	8b 40 04             	mov    0x4(%eax),%eax
 a1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a1d:	75 0c                	jne    a2b <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a22:	8b 10                	mov    (%eax),%edx
 a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a27:	89 10                	mov    %edx,(%eax)
 a29:	eb 26                	jmp    a51 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2e:	8b 40 04             	mov    0x4(%eax),%eax
 a31:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a34:	89 c2                	mov    %eax,%edx
 a36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a39:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3f:	8b 40 04             	mov    0x4(%eax),%eax
 a42:	c1 e0 03             	shl    $0x3,%eax
 a45:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a4e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a54:	a3 bc 0d 00 00       	mov    %eax,0xdbc
      return (void*)(p + 1);
 a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5c:	83 c0 08             	add    $0x8,%eax
 a5f:	eb 3b                	jmp    a9c <malloc+0xe1>
    }
    if(p == freep)
 a61:	a1 bc 0d 00 00       	mov    0xdbc,%eax
 a66:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a69:	75 1e                	jne    a89 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 a6b:	83 ec 0c             	sub    $0xc,%esp
 a6e:	ff 75 ec             	pushl  -0x14(%ebp)
 a71:	e8 e5 fe ff ff       	call   95b <morecore>
 a76:	83 c4 10             	add    $0x10,%esp
 a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a80:	75 07                	jne    a89 <malloc+0xce>
        return 0;
 a82:	b8 00 00 00 00       	mov    $0x0,%eax
 a87:	eb 13                	jmp    a9c <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8b 00                	mov    (%eax),%eax
 a94:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 a97:	e9 6d ff ff ff       	jmp    a09 <malloc+0x4e>
}
 a9c:	c9                   	leave  
 a9d:	c3                   	ret    
