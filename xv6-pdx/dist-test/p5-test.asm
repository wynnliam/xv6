
_p5-test:     file format elf32-i386


Disassembly of section .text:

00000000 <canRun>:
#include "stat.h"
#include "p5-test.h"

static int
canRun(char *name)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  int rc, uid, gid;
  struct stat st;

  uid = getuid();
       6:	e8 50 14 00 00       	call   145b <getuid>
       b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  gid = getgid();
       e:	e8 50 14 00 00       	call   1463 <getgid>
      13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  check(stat(name, &st));
      16:	83 ec 08             	sub    $0x8,%esp
      19:	8d 45 d0             	lea    -0x30(%ebp),%eax
      1c:	50                   	push   %eax
      1d:	ff 75 08             	pushl  0x8(%ebp)
      20:	e8 62 12 00 00       	call   1287 <stat>
      25:	83 c4 10             	add    $0x10,%esp
      28:	89 45 ec             	mov    %eax,-0x14(%ebp)
      2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
      2f:	74 21                	je     52 <canRun+0x52>
      31:	83 ec 04             	sub    $0x4,%esp
      34:	68 4c 19 00 00       	push   $0x194c
      39:	68 5c 19 00 00       	push   $0x195c
      3e:	6a 02                	push   $0x2
      40:	e8 3d 15 00 00       	call   1582 <printf>
      45:	83 c4 10             	add    $0x10,%esp
      48:	b8 00 00 00 00       	mov    $0x0,%eax
      4d:	e9 97 00 00 00       	jmp    e9 <canRun+0xe9>
  if (uid == st.uid) {
      52:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
      56:	0f b7 c0             	movzwl %ax,%eax
      59:	3b 45 f4             	cmp    -0xc(%ebp),%eax
      5c:	75 2b                	jne    89 <canRun+0x89>
    if (st.mode.flags.u_x)
      5e:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      62:	83 e0 40             	and    $0x40,%eax
      65:	84 c0                	test   %al,%al
      67:	74 07                	je     70 <canRun+0x70>
      return TRUE;
      69:	b8 01 00 00 00       	mov    $0x1,%eax
      6e:	eb 79                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "UID match. Execute permission for user not set.\n");
      70:	83 ec 08             	sub    $0x8,%esp
      73:	68 70 19 00 00       	push   $0x1970
      78:	6a 02                	push   $0x2
      7a:	e8 03 15 00 00       	call   1582 <printf>
      7f:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      82:	b8 00 00 00 00       	mov    $0x0,%eax
      87:	eb 60                	jmp    e9 <canRun+0xe9>
    }
  }
  if (gid == st.gid) {
      89:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
      8d:	0f b7 c0             	movzwl %ax,%eax
      90:	3b 45 f0             	cmp    -0x10(%ebp),%eax
      93:	75 2b                	jne    c0 <canRun+0xc0>
    if (st.mode.flags.g_x)
      95:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      99:	83 e0 08             	and    $0x8,%eax
      9c:	84 c0                	test   %al,%al
      9e:	74 07                	je     a7 <canRun+0xa7>
      return TRUE;
      a0:	b8 01 00 00 00       	mov    $0x1,%eax
      a5:	eb 42                	jmp    e9 <canRun+0xe9>
    else {
      printf(2, "GID match. Execute permission for group not set.\n");
      a7:	83 ec 08             	sub    $0x8,%esp
      aa:	68 a4 19 00 00       	push   $0x19a4
      af:	6a 02                	push   $0x2
      b1:	e8 cc 14 00 00       	call   1582 <printf>
      b6:	83 c4 10             	add    $0x10,%esp
      return FALSE;
      b9:	b8 00 00 00 00       	mov    $0x0,%eax
      be:	eb 29                	jmp    e9 <canRun+0xe9>
    }
  }
  if (st.mode.flags.o_x) {
      c0:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
      c4:	83 e0 01             	and    $0x1,%eax
      c7:	84 c0                	test   %al,%al
      c9:	74 07                	je     d2 <canRun+0xd2>
    return TRUE;
      cb:	b8 01 00 00 00       	mov    $0x1,%eax
      d0:	eb 17                	jmp    e9 <canRun+0xe9>
  }

  printf(2, "Execute permission for other not set.\n");
      d2:	83 ec 08             	sub    $0x8,%esp
      d5:	68 d8 19 00 00       	push   $0x19d8
      da:	6a 02                	push   $0x2
      dc:	e8 a1 14 00 00       	call   1582 <printf>
      e1:	83 c4 10             	add    $0x10,%esp
  return FALSE;  // failure. Can't run
      e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
      e9:	c9                   	leave  
      ea:	c3                   	ret    

000000eb <doSetuidTest>:

static int
doSetuidTest (char **cmd)
{
      eb:	55                   	push   %ebp
      ec:	89 e5                	mov    %esp,%ebp
      ee:	53                   	push   %ebx
      ef:	83 ec 24             	sub    $0x24,%esp
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};
      f2:	c7 45 e0 ff 19 00 00 	movl   $0x19ff,-0x20(%ebp)
      f9:	c7 45 e4 09 1a 00 00 	movl   $0x1a09,-0x1c(%ebp)
     100:	c7 45 e8 13 1a 00 00 	movl   $0x1a13,-0x18(%ebp)
     107:	c7 45 ec 19 1a 00 00 	movl   $0x1a19,-0x14(%ebp)

  printf(1, "\nTesting the set uid bit.\n\n");
     10e:	83 ec 08             	sub    $0x8,%esp
     111:	68 25 1a 00 00       	push   $0x1a25
     116:	6a 01                	push   $0x1
     118:	e8 65 14 00 00       	call   1582 <printf>
     11d:	83 c4 10             	add    $0x10,%esp

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     127:	e9 7f 02 00 00       	jmp    3ab <doSetuidTest+0x2c0>
    printf(1, "Starting test: %s.\n", test[i]);
     12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     12f:	8b 44 85 e0          	mov    -0x20(%ebp,%eax,4),%eax
     133:	83 ec 04             	sub    $0x4,%esp
     136:	50                   	push   %eax
     137:	68 41 1a 00 00       	push   $0x1a41
     13c:	6a 01                	push   $0x1
     13e:	e8 3f 14 00 00       	call   1582 <printf>
     143:	83 c4 10             	add    $0x10,%esp
    check(setuid(testperms[i][procuid]));
     146:	8b 45 f4             	mov    -0xc(%ebp),%eax
     149:	c1 e0 04             	shl    $0x4,%eax
     14c:	05 00 26 00 00       	add    $0x2600,%eax
     151:	8b 00                	mov    (%eax),%eax
     153:	83 ec 0c             	sub    $0xc,%esp
     156:	50                   	push   %eax
     157:	e8 17 13 00 00       	call   1473 <setuid>
     15c:	83 c4 10             	add    $0x10,%esp
     15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     166:	74 21                	je     189 <doSetuidTest+0x9e>
     168:	83 ec 04             	sub    $0x4,%esp
     16b:	68 55 1a 00 00       	push   $0x1a55
     170:	68 5c 19 00 00       	push   $0x195c
     175:	6a 02                	push   $0x2
     177:	e8 06 14 00 00       	call   1582 <printf>
     17c:	83 c4 10             	add    $0x10,%esp
     17f:	b8 00 00 00 00       	mov    $0x0,%eax
     184:	e9 5d 02 00 00       	jmp    3e6 <doSetuidTest+0x2fb>
    check(setgid(testperms[i][procgid]));
     189:	8b 45 f4             	mov    -0xc(%ebp),%eax
     18c:	c1 e0 04             	shl    $0x4,%eax
     18f:	05 04 26 00 00       	add    $0x2604,%eax
     194:	8b 00                	mov    (%eax),%eax
     196:	83 ec 0c             	sub    $0xc,%esp
     199:	50                   	push   %eax
     19a:	e8 dc 12 00 00       	call   147b <setgid>
     19f:	83 c4 10             	add    $0x10,%esp
     1a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
     1a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     1a9:	74 21                	je     1cc <doSetuidTest+0xe1>
     1ab:	83 ec 04             	sub    $0x4,%esp
     1ae:	68 73 1a 00 00       	push   $0x1a73
     1b3:	68 5c 19 00 00       	push   $0x195c
     1b8:	6a 02                	push   $0x2
     1ba:	e8 c3 13 00 00       	call   1582 <printf>
     1bf:	83 c4 10             	add    $0x10,%esp
     1c2:	b8 00 00 00 00       	mov    $0x0,%eax
     1c7:	e9 1a 02 00 00       	jmp    3e6 <doSetuidTest+0x2fb>
    printf(1, "Process uid: %d, gid: %d\n", getuid(), getgid());
     1cc:	e8 92 12 00 00       	call   1463 <getgid>
     1d1:	89 c3                	mov    %eax,%ebx
     1d3:	e8 83 12 00 00       	call   145b <getuid>
     1d8:	53                   	push   %ebx
     1d9:	50                   	push   %eax
     1da:	68 91 1a 00 00       	push   $0x1a91
     1df:	6a 01                	push   $0x1
     1e1:	e8 9c 13 00 00       	call   1582 <printf>
     1e6:	83 c4 10             	add    $0x10,%esp
    check(chown(cmd[0], testperms[i][fileuid]));
     1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1ec:	c1 e0 04             	shl    $0x4,%eax
     1ef:	05 08 26 00 00       	add    $0x2608,%eax
     1f4:	8b 10                	mov    (%eax),%edx
     1f6:	8b 45 08             	mov    0x8(%ebp),%eax
     1f9:	8b 00                	mov    (%eax),%eax
     1fb:	83 ec 08             	sub    $0x8,%esp
     1fe:	52                   	push   %edx
     1ff:	50                   	push   %eax
     200:	e8 96 12 00 00       	call   149b <chown>
     205:	83 c4 10             	add    $0x10,%esp
     208:	89 45 f0             	mov    %eax,-0x10(%ebp)
     20b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     20f:	74 21                	je     232 <doSetuidTest+0x147>
     211:	83 ec 04             	sub    $0x4,%esp
     214:	68 ac 1a 00 00       	push   $0x1aac
     219:	68 5c 19 00 00       	push   $0x195c
     21e:	6a 02                	push   $0x2
     220:	e8 5d 13 00 00       	call   1582 <printf>
     225:	83 c4 10             	add    $0x10,%esp
     228:	b8 00 00 00 00       	mov    $0x0,%eax
     22d:	e9 b4 01 00 00       	jmp    3e6 <doSetuidTest+0x2fb>
    check(chgrp(cmd[0], testperms[i][filegid]));
     232:	8b 45 f4             	mov    -0xc(%ebp),%eax
     235:	c1 e0 04             	shl    $0x4,%eax
     238:	05 0c 26 00 00       	add    $0x260c,%eax
     23d:	8b 10                	mov    (%eax),%edx
     23f:	8b 45 08             	mov    0x8(%ebp),%eax
     242:	8b 00                	mov    (%eax),%eax
     244:	83 ec 08             	sub    $0x8,%esp
     247:	52                   	push   %edx
     248:	50                   	push   %eax
     249:	e8 55 12 00 00       	call   14a3 <chgrp>
     24e:	83 c4 10             	add    $0x10,%esp
     251:	89 45 f0             	mov    %eax,-0x10(%ebp)
     254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     258:	74 21                	je     27b <doSetuidTest+0x190>
     25a:	83 ec 04             	sub    $0x4,%esp
     25d:	68 d4 1a 00 00       	push   $0x1ad4
     262:	68 5c 19 00 00       	push   $0x195c
     267:	6a 02                	push   $0x2
     269:	e8 14 13 00 00       	call   1582 <printf>
     26e:	83 c4 10             	add    $0x10,%esp
     271:	b8 00 00 00 00       	mov    $0x0,%eax
     276:	e9 6b 01 00 00       	jmp    3e6 <doSetuidTest+0x2fb>
    printf(1, "File uid: %d, gid: %d\n",
     27b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     27e:	c1 e0 04             	shl    $0x4,%eax
     281:	05 0c 26 00 00       	add    $0x260c,%eax
     286:	8b 10                	mov    (%eax),%edx
     288:	8b 45 f4             	mov    -0xc(%ebp),%eax
     28b:	c1 e0 04             	shl    $0x4,%eax
     28e:	05 08 26 00 00       	add    $0x2608,%eax
     293:	8b 00                	mov    (%eax),%eax
     295:	52                   	push   %edx
     296:	50                   	push   %eax
     297:	68 f9 1a 00 00       	push   $0x1af9
     29c:	6a 01                	push   $0x1
     29e:	e8 df 12 00 00       	call   1582 <printf>
     2a3:	83 c4 10             	add    $0x10,%esp
		    testperms[i][fileuid], testperms[i][filegid]);
    check(chmod(cmd[0], atoi(perms[i])));
     2a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a9:	8b 04 85 e4 25 00 00 	mov    0x25e4(,%eax,4),%eax
     2b0:	83 ec 0c             	sub    $0xc,%esp
     2b3:	50                   	push   %eax
     2b4:	e8 1b 10 00 00       	call   12d4 <atoi>
     2b9:	83 c4 10             	add    $0x10,%esp
     2bc:	89 c2                	mov    %eax,%edx
     2be:	8b 45 08             	mov    0x8(%ebp),%eax
     2c1:	8b 00                	mov    (%eax),%eax
     2c3:	83 ec 08             	sub    $0x8,%esp
     2c6:	52                   	push   %edx
     2c7:	50                   	push   %eax
     2c8:	e8 c6 11 00 00       	call   1493 <chmod>
     2cd:	83 c4 10             	add    $0x10,%esp
     2d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
     2d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     2d7:	74 21                	je     2fa <doSetuidTest+0x20f>
     2d9:	83 ec 04             	sub    $0x4,%esp
     2dc:	68 10 1b 00 00       	push   $0x1b10
     2e1:	68 5c 19 00 00       	push   $0x195c
     2e6:	6a 02                	push   $0x2
     2e8:	e8 95 12 00 00       	call   1582 <printf>
     2ed:	83 c4 10             	add    $0x10,%esp
     2f0:	b8 00 00 00 00       	mov    $0x0,%eax
     2f5:	e9 ec 00 00 00       	jmp    3e6 <doSetuidTest+0x2fb>
    printf(1, "perms set to %d for %s\n", perms[i], cmd[0]);
     2fa:	8b 45 08             	mov    0x8(%ebp),%eax
     2fd:	8b 10                	mov    (%eax),%edx
     2ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     302:	8b 04 85 e4 25 00 00 	mov    0x25e4(,%eax,4),%eax
     309:	52                   	push   %edx
     30a:	50                   	push   %eax
     30b:	68 2e 1b 00 00       	push   $0x1b2e
     310:	6a 01                	push   $0x1
     312:	e8 6b 12 00 00       	call   1582 <printf>
     317:	83 c4 10             	add    $0x10,%esp

    rc = fork();
     31a:	e8 84 10 00 00       	call   13a3 <fork>
     31f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     322:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     326:	79 1c                	jns    344 <doSetuidTest+0x259>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     328:	83 ec 08             	sub    $0x8,%esp
     32b:	68 48 1b 00 00       	push   $0x1b48
     330:	6a 02                	push   $0x2
     332:	e8 4b 12 00 00       	call   1582 <printf>
     337:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     33a:	b8 00 00 00 00       	mov    $0x0,%eax
     33f:	e9 a2 00 00 00       	jmp    3e6 <doSetuidTest+0x2fb>
    }
    if (rc == 0) {   // child
     344:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     348:	75 58                	jne    3a2 <doSetuidTest+0x2b7>
      exec(cmd[0], cmd);
     34a:	8b 45 08             	mov    0x8(%ebp),%eax
     34d:	8b 00                	mov    (%eax),%eax
     34f:	83 ec 08             	sub    $0x8,%esp
     352:	ff 75 08             	pushl  0x8(%ebp)
     355:	50                   	push   %eax
     356:	e8 88 10 00 00       	call   13e3 <exec>
     35b:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     35e:	a1 e0 25 00 00       	mov    0x25e0,%eax
     363:	83 e8 01             	sub    $0x1,%eax
     366:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     369:	74 1a                	je     385 <doSetuidTest+0x29a>
     36b:	8b 45 08             	mov    0x8(%ebp),%eax
     36e:	8b 00                	mov    (%eax),%eax
     370:	83 ec 04             	sub    $0x4,%esp
     373:	50                   	push   %eax
     374:	68 90 1b 00 00       	push   $0x1b90
     379:	6a 02                	push   $0x2
     37b:	e8 02 12 00 00       	call   1582 <printf>
     380:	83 c4 10             	add    $0x10,%esp
     383:	eb 18                	jmp    39d <doSetuidTest+0x2b2>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     385:	8b 45 08             	mov    0x8(%ebp),%eax
     388:	8b 00                	mov    (%eax),%eax
     38a:	83 ec 04             	sub    $0x4,%esp
     38d:	50                   	push   %eax
     38e:	68 b4 1b 00 00       	push   $0x1bb4
     393:	6a 02                	push   $0x2
     395:	e8 e8 11 00 00       	call   1582 <printf>
     39a:	83 c4 10             	add    $0x10,%esp
      exit();
     39d:	e8 09 10 00 00       	call   13ab <exit>
    }
    wait();
     3a2:	e8 0c 10 00 00       	call   13b3 <wait>
  int rc, i;
  char *test[] = {"UID match", "GID match", "Other", "Should Fail"};

  printf(1, "\nTesting the set uid bit.\n\n");

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     3a7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3ab:	a1 e0 25 00 00       	mov    0x25e0,%eax
     3b0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     3b3:	0f 8c 73 fd ff ff    	jl     12c <doSetuidTest+0x41>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chmod(cmd[0], 00755);  // total hack but necessary. sigh
     3b9:	8b 45 08             	mov    0x8(%ebp),%eax
     3bc:	8b 00                	mov    (%eax),%eax
     3be:	83 ec 08             	sub    $0x8,%esp
     3c1:	68 ed 01 00 00       	push   $0x1ed
     3c6:	50                   	push   %eax
     3c7:	e8 c7 10 00 00       	call   1493 <chmod>
     3cc:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     3cf:	83 ec 08             	sub    $0x8,%esp
     3d2:	68 e1 1b 00 00       	push   $0x1be1
     3d7:	6a 01                	push   $0x1
     3d9:	e8 a4 11 00 00       	call   1582 <printf>
     3de:	83 c4 10             	add    $0x10,%esp
  return PASS;
     3e1:	b8 01 00 00 00       	mov    $0x1,%eax
}
     3e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3e9:	c9                   	leave  
     3ea:	c3                   	ret    

000003eb <doUidTest>:

static int
doUidTest (char **cmd)
{
     3eb:	55                   	push   %ebp
     3ec:	89 e5                	mov    %esp,%ebp
     3ee:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, startuid, testuid, baduidcount = 3;
     3f1:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int baduids[] = {32767+5, -41, ~0};  // 32767 is max value
     3f8:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     3ff:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     406:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setuid() test.\n\n");
     40d:	83 ec 08             	sub    $0x8,%esp
     410:	68 ee 1b 00 00       	push   $0x1bee
     415:	6a 01                	push   $0x1
     417:	e8 66 11 00 00       	call   1582 <printf>
     41c:	83 c4 10             	add    $0x10,%esp

  startuid = uid = getuid();
     41f:	e8 37 10 00 00       	call   145b <getuid>
     424:	89 45 ec             	mov    %eax,-0x14(%ebp)
     427:	8b 45 ec             	mov    -0x14(%ebp),%eax
     42a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testuid = ++uid;
     42d:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     431:	8b 45 ec             	mov    -0x14(%ebp),%eax
     434:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setuid(testuid);
     437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     43a:	83 ec 0c             	sub    $0xc,%esp
     43d:	50                   	push   %eax
     43e:	e8 30 10 00 00       	call   1473 <setuid>
     443:	83 c4 10             	add    $0x10,%esp
     446:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     449:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     44d:	74 1c                	je     46b <doUidTest+0x80>
    printf(2, "setuid system call reports an error.\n");
     44f:	83 ec 08             	sub    $0x8,%esp
     452:	68 0c 1c 00 00       	push   $0x1c0c
     457:	6a 02                	push   $0x2
     459:	e8 24 11 00 00       	call   1582 <printf>
     45e:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     461:	b8 00 00 00 00       	mov    $0x0,%eax
     466:	e9 07 01 00 00       	jmp    572 <doUidTest+0x187>
  }
  uid = getuid();
     46b:	e8 eb 0f 00 00       	call   145b <getuid>
     470:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (uid != testuid) {
     473:	8b 45 ec             	mov    -0x14(%ebp),%eax
     476:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     479:	74 31                	je     4ac <doUidTest+0xc1>
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
     47b:	83 ec 08             	sub    $0x8,%esp
     47e:	68 34 1c 00 00       	push   $0x1c34
     483:	6a 02                	push   $0x2
     485:	e8 f8 10 00 00       	call   1582 <printf>
     48a:	83 c4 10             	add    $0x10,%esp
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
     48d:	ff 75 ec             	pushl  -0x14(%ebp)
     490:	ff 75 e4             	pushl  -0x1c(%ebp)
     493:	68 6c 1c 00 00       	push   $0x1c6c
     498:	6a 02                	push   $0x2
     49a:	e8 e3 10 00 00       	call   1582 <printf>
     49f:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     4a2:	b8 00 00 00 00       	mov    $0x0,%eax
     4a7:	e9 c6 00 00 00       	jmp    572 <doUidTest+0x187>
  }
  for (i=0; i<baduidcount; i++) {
     4ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     4b3:	e9 88 00 00 00       	jmp    540 <doUidTest+0x155>
    rc = setuid(baduids[i]);
     4b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4bb:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4bf:	83 ec 0c             	sub    $0xc,%esp
     4c2:	50                   	push   %eax
     4c3:	e8 ab 0f 00 00       	call   1473 <setuid>
     4c8:	83 c4 10             	add    $0x10,%esp
     4cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     4ce:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     4d2:	75 21                	jne    4f5 <doUidTest+0x10a>
      printf(2, "Tried to set the uid to a bad value (%d) and setuid()failed to fail. rc == %d\n",
     4d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d7:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     4db:	ff 75 e0             	pushl  -0x20(%ebp)
     4de:	50                   	push   %eax
     4df:	68 90 1c 00 00       	push   $0x1c90
     4e4:	6a 02                	push   $0x2
     4e6:	e8 97 10 00 00       	call   1582 <printf>
     4eb:	83 c4 10             	add    $0x10,%esp
                      baduids[i], rc);
      return NOPASS;
     4ee:	b8 00 00 00 00       	mov    $0x0,%eax
     4f3:	eb 7d                	jmp    572 <doUidTest+0x187>
    }
    rc = getuid();
     4f5:	e8 61 0f 00 00       	call   145b <getuid>
     4fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (baduids[i] == rc) {
     4fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     500:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     504:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     507:	75 33                	jne    53c <doUidTest+0x151>
      printf(2, "ERROR! Gave setuid() a bad value (%d) and it failed to fail. gid: %d\n",
     509:	8b 45 f4             	mov    -0xc(%ebp),%eax
     50c:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     510:	ff 75 e0             	pushl  -0x20(%ebp)
     513:	50                   	push   %eax
     514:	68 e0 1c 00 00       	push   $0x1ce0
     519:	6a 02                	push   $0x2
     51b:	e8 62 10 00 00       	call   1582 <printf>
     520:	83 c4 10             	add    $0x10,%esp
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
     523:	83 ec 08             	sub    $0x8,%esp
     526:	68 28 1d 00 00       	push   $0x1d28
     52b:	6a 02                	push   $0x2
     52d:	e8 50 10 00 00       	call   1582 <printf>
     532:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     535:	b8 00 00 00 00       	mov    $0x0,%eax
     53a:	eb 36                	jmp    572 <doUidTest+0x187>
  if (uid != testuid) {
    printf(2, "ERROR! setuid claims to have worked but really didn't!\n");
    printf(2, "uid should be %d but is instead %d\n", testuid, uid);
    return NOPASS;
  }
  for (i=0; i<baduidcount; i++) {
     53c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     540:	8b 45 f4             	mov    -0xc(%ebp),%eax
     543:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     546:	0f 8c 6c ff ff ff    	jl     4b8 <doUidTest+0xcd>
		      baduids[i],rc);
      printf(2, "Valid UIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setuid(startuid);
     54c:	8b 45 e8             	mov    -0x18(%ebp),%eax
     54f:	83 ec 0c             	sub    $0xc,%esp
     552:	50                   	push   %eax
     553:	e8 1b 0f 00 00       	call   1473 <setuid>
     558:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     55b:	83 ec 08             	sub    $0x8,%esp
     55e:	68 e1 1b 00 00       	push   $0x1be1
     563:	6a 01                	push   $0x1
     565:	e8 18 10 00 00       	call   1582 <printf>
     56a:	83 c4 10             	add    $0x10,%esp
  return PASS;
     56d:	b8 01 00 00 00       	mov    $0x1,%eax
}
     572:	c9                   	leave  
     573:	c3                   	ret    

00000574 <doGidTest>:

static int
doGidTest (char **cmd)
{
     574:	55                   	push   %ebp
     575:	89 e5                	mov    %esp,%ebp
     577:	83 ec 38             	sub    $0x38,%esp
  int i, rc, gid, startgid, testgid, badgidcount = 3;
     57a:	c7 45 f0 03 00 00 00 	movl   $0x3,-0x10(%ebp)
  int badgids[] = {32767+5, -41, ~0};  // 32767 is max value
     581:	c7 45 d4 04 80 00 00 	movl   $0x8004,-0x2c(%ebp)
     588:	c7 45 d8 d7 ff ff ff 	movl   $0xffffffd7,-0x28(%ebp)
     58f:	c7 45 dc ff ff ff ff 	movl   $0xffffffff,-0x24(%ebp)

  printf(1, "\nExecuting setgid() test.\n\n");
     596:	83 ec 08             	sub    $0x8,%esp
     599:	68 56 1d 00 00       	push   $0x1d56
     59e:	6a 01                	push   $0x1
     5a0:	e8 dd 0f 00 00       	call   1582 <printf>
     5a5:	83 c4 10             	add    $0x10,%esp

  startgid = gid = getgid();
     5a8:	e8 b6 0e 00 00       	call   1463 <getgid>
     5ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
     5b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  testgid = ++gid;
     5b6:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
     5ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  rc = setgid(testgid);
     5c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     5c3:	83 ec 0c             	sub    $0xc,%esp
     5c6:	50                   	push   %eax
     5c7:	e8 af 0e 00 00       	call   147b <setgid>
     5cc:	83 c4 10             	add    $0x10,%esp
     5cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (rc) {
     5d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     5d6:	74 1c                	je     5f4 <doGidTest+0x80>
    printf(2, "setgid system call reports an error.\n");
     5d8:	83 ec 08             	sub    $0x8,%esp
     5db:	68 74 1d 00 00       	push   $0x1d74
     5e0:	6a 02                	push   $0x2
     5e2:	e8 9b 0f 00 00       	call   1582 <printf>
     5e7:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     5ea:	b8 00 00 00 00       	mov    $0x0,%eax
     5ef:	e9 07 01 00 00       	jmp    6fb <doGidTest+0x187>
  }
  gid = getgid();
     5f4:	e8 6a 0e 00 00       	call   1463 <getgid>
     5f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (gid != testgid) {
     5fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     5ff:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
     602:	74 31                	je     635 <doGidTest+0xc1>
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
     604:	83 ec 08             	sub    $0x8,%esp
     607:	68 9c 1d 00 00       	push   $0x1d9c
     60c:	6a 02                	push   $0x2
     60e:	e8 6f 0f 00 00       	call   1582 <printf>
     613:	83 c4 10             	add    $0x10,%esp
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
     616:	ff 75 ec             	pushl  -0x14(%ebp)
     619:	ff 75 e4             	pushl  -0x1c(%ebp)
     61c:	68 d4 1d 00 00       	push   $0x1dd4
     621:	6a 02                	push   $0x2
     623:	e8 5a 0f 00 00       	call   1582 <printf>
     628:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     62b:	b8 00 00 00 00       	mov    $0x0,%eax
     630:	e9 c6 00 00 00       	jmp    6fb <doGidTest+0x187>
  }
  for (i=0; i<badgidcount; i++) {
     635:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     63c:	e9 88 00 00 00       	jmp    6c9 <doGidTest+0x155>
    rc = setgid(badgids[i]); 
     641:	8b 45 f4             	mov    -0xc(%ebp),%eax
     644:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     648:	83 ec 0c             	sub    $0xc,%esp
     64b:	50                   	push   %eax
     64c:	e8 2a 0e 00 00       	call   147b <setgid>
     651:	83 c4 10             	add    $0x10,%esp
     654:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (rc == 0) {
     657:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
     65b:	75 21                	jne    67e <doGidTest+0x10a>
      printf(2, "Tried to set the gid to a bad value (%d) and setgid()failed to fail. rc == %d\n",
     65d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     660:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     664:	ff 75 e0             	pushl  -0x20(%ebp)
     667:	50                   	push   %eax
     668:	68 f8 1d 00 00       	push   $0x1df8
     66d:	6a 02                	push   $0x2
     66f:	e8 0e 0f 00 00       	call   1582 <printf>
     674:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      return NOPASS;
     677:	b8 00 00 00 00       	mov    $0x0,%eax
     67c:	eb 7d                	jmp    6fb <doGidTest+0x187>
    }
    rc = getgid();
     67e:	e8 e0 0d 00 00       	call   1463 <getgid>
     683:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (badgids[i] == rc) {
     686:	8b 45 f4             	mov    -0xc(%ebp),%eax
     689:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     68d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
     690:	75 33                	jne    6c5 <doGidTest+0x151>
      printf(2, "ERROR! Gave setgid() a bad value (%d) and it failed to fail. gid: %d\n",
     692:	8b 45 f4             	mov    -0xc(%ebp),%eax
     695:	8b 44 85 d4          	mov    -0x2c(%ebp,%eax,4),%eax
     699:	ff 75 e0             	pushl  -0x20(%ebp)
     69c:	50                   	push   %eax
     69d:	68 48 1e 00 00       	push   $0x1e48
     6a2:	6a 02                	push   $0x2
     6a4:	e8 d9 0e 00 00       	call   1582 <printf>
     6a9:	83 c4 10             	add    $0x10,%esp
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
     6ac:	83 ec 08             	sub    $0x8,%esp
     6af:	68 90 1e 00 00       	push   $0x1e90
     6b4:	6a 02                	push   $0x2
     6b6:	e8 c7 0e 00 00       	call   1582 <printf>
     6bb:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     6be:	b8 00 00 00 00       	mov    $0x0,%eax
     6c3:	eb 36                	jmp    6fb <doGidTest+0x187>
  if (gid != testgid) {
    printf(2, "ERROR! setgid claims to have worked but really didn't!\n");
    printf(2, "gid should be %d but is instead %d\n", testgid, gid);
    return NOPASS;
  }
  for (i=0; i<badgidcount; i++) {
     6c5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     6c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     6cf:	0f 8c 6c ff ff ff    	jl     641 <doGidTest+0xcd>
		      badgids[i], rc);
      printf(2, "Valid GIDs are in the range [0, 32767] only!\n");
      return NOPASS;
    }
  }
  setgid(startgid);
     6d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6d8:	83 ec 0c             	sub    $0xc,%esp
     6db:	50                   	push   %eax
     6dc:	e8 9a 0d 00 00       	call   147b <setgid>
     6e1:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     6e4:	83 ec 08             	sub    $0x8,%esp
     6e7:	68 e1 1b 00 00       	push   $0x1be1
     6ec:	6a 01                	push   $0x1
     6ee:	e8 8f 0e 00 00       	call   1582 <printf>
     6f3:	83 c4 10             	add    $0x10,%esp
  return PASS;
     6f6:	b8 01 00 00 00       	mov    $0x1,%eax
}
     6fb:	c9                   	leave  
     6fc:	c3                   	ret    

000006fd <doChmodTest>:

static int
doChmodTest(char **cmd) 
{
     6fd:	55                   	push   %ebp
     6fe:	89 e5                	mov    %esp,%ebp
     700:	83 ec 38             	sub    $0x38,%esp
  int i, rc, mode, testmode;
  struct stat st;

  printf(1, "\nExecuting chmod() test.\n\n");
     703:	83 ec 08             	sub    $0x8,%esp
     706:	68 be 1e 00 00       	push   $0x1ebe
     70b:	6a 01                	push   $0x1
     70d:	e8 70 0e 00 00       	call   1582 <printf>
     712:	83 c4 10             	add    $0x10,%esp

  check(stat(cmd[0], &st));
     715:	8b 45 08             	mov    0x8(%ebp),%eax
     718:	8b 00                	mov    (%eax),%eax
     71a:	83 ec 08             	sub    $0x8,%esp
     71d:	8d 55 cc             	lea    -0x34(%ebp),%edx
     720:	52                   	push   %edx
     721:	50                   	push   %eax
     722:	e8 60 0b 00 00       	call   1287 <stat>
     727:	83 c4 10             	add    $0x10,%esp
     72a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     72d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     731:	74 21                	je     754 <doChmodTest+0x57>
     733:	83 ec 04             	sub    $0x4,%esp
     736:	68 d9 1e 00 00       	push   $0x1ed9
     73b:	68 5c 19 00 00       	push   $0x195c
     740:	6a 02                	push   $0x2
     742:	e8 3b 0e 00 00       	call   1582 <printf>
     747:	83 c4 10             	add    $0x10,%esp
     74a:	b8 00 00 00 00       	mov    $0x0,%eax
     74f:	e9 2c 01 00 00       	jmp    880 <doChmodTest+0x183>
  mode = st.mode.asInt;
     754:	8b 45 e0             	mov    -0x20(%ebp),%eax
     757:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     75a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     761:	e9 df 00 00 00       	jmp    845 <doChmodTest+0x148>
    check(chmod(cmd[0], atoi(perms[i])));
     766:	8b 45 f4             	mov    -0xc(%ebp),%eax
     769:	8b 04 85 e4 25 00 00 	mov    0x25e4(,%eax,4),%eax
     770:	83 ec 0c             	sub    $0xc,%esp
     773:	50                   	push   %eax
     774:	e8 5b 0b 00 00       	call   12d4 <atoi>
     779:	83 c4 10             	add    $0x10,%esp
     77c:	89 c2                	mov    %eax,%edx
     77e:	8b 45 08             	mov    0x8(%ebp),%eax
     781:	8b 00                	mov    (%eax),%eax
     783:	83 ec 08             	sub    $0x8,%esp
     786:	52                   	push   %edx
     787:	50                   	push   %eax
     788:	e8 06 0d 00 00       	call   1493 <chmod>
     78d:	83 c4 10             	add    $0x10,%esp
     790:	89 45 f0             	mov    %eax,-0x10(%ebp)
     793:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     797:	74 21                	je     7ba <doChmodTest+0xbd>
     799:	83 ec 04             	sub    $0x4,%esp
     79c:	68 10 1b 00 00       	push   $0x1b10
     7a1:	68 5c 19 00 00       	push   $0x195c
     7a6:	6a 02                	push   $0x2
     7a8:	e8 d5 0d 00 00       	call   1582 <printf>
     7ad:	83 c4 10             	add    $0x10,%esp
     7b0:	b8 00 00 00 00       	mov    $0x0,%eax
     7b5:	e9 c6 00 00 00       	jmp    880 <doChmodTest+0x183>
    check(stat(cmd[0], &st));
     7ba:	8b 45 08             	mov    0x8(%ebp),%eax
     7bd:	8b 00                	mov    (%eax),%eax
     7bf:	83 ec 08             	sub    $0x8,%esp
     7c2:	8d 55 cc             	lea    -0x34(%ebp),%edx
     7c5:	52                   	push   %edx
     7c6:	50                   	push   %eax
     7c7:	e8 bb 0a 00 00       	call   1287 <stat>
     7cc:	83 c4 10             	add    $0x10,%esp
     7cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
     7d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     7d6:	74 21                	je     7f9 <doChmodTest+0xfc>
     7d8:	83 ec 04             	sub    $0x4,%esp
     7db:	68 d9 1e 00 00       	push   $0x1ed9
     7e0:	68 5c 19 00 00       	push   $0x195c
     7e5:	6a 02                	push   $0x2
     7e7:	e8 96 0d 00 00       	call   1582 <printf>
     7ec:	83 c4 10             	add    $0x10,%esp
     7ef:	b8 00 00 00 00       	mov    $0x0,%eax
     7f4:	e9 87 00 00 00       	jmp    880 <doChmodTest+0x183>
    testmode = st.mode.asInt;
     7f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     7fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if (mode == testmode) {
     7ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
     802:	3b 45 e8             	cmp    -0x18(%ebp),%eax
     805:	75 3a                	jne    841 <doChmodTest+0x144>
      printf(2, "Error! Unable to test.\n");
     807:	83 ec 08             	sub    $0x8,%esp
     80a:	68 eb 1e 00 00       	push   $0x1eeb
     80f:	6a 02                	push   $0x2
     811:	e8 6c 0d 00 00       	call   1582 <printf>
     816:	83 c4 10             	add    $0x10,%esp
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
     819:	8b 45 08             	mov    0x8(%ebp),%eax
     81c:	8b 00                	mov    (%eax),%eax
     81e:	83 ec 08             	sub    $0x8,%esp
     821:	ff 75 f4             	pushl  -0xc(%ebp)
     824:	50                   	push   %eax
     825:	ff 75 e8             	pushl  -0x18(%ebp)
     828:	ff 75 ec             	pushl  -0x14(%ebp)
     82b:	68 04 1f 00 00       	push   $0x1f04
     830:	6a 02                	push   $0x2
     832:	e8 4b 0d 00 00       	call   1582 <printf>
     837:	83 c4 20             	add    $0x20,%esp
		     mode, testmode, cmd[0], i);
      return NOPASS;
     83a:	b8 00 00 00 00       	mov    $0x0,%eax
     83f:	eb 3f                	jmp    880 <doChmodTest+0x183>
  printf(1, "\nExecuting chmod() test.\n\n");

  check(stat(cmd[0], &st));
  mode = st.mode.asInt;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     841:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     845:	a1 e0 25 00 00       	mov    0x25e0,%eax
     84a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     84d:	0f 8c 13 ff ff ff    	jl     766 <doChmodTest+0x69>
      printf(2, "\tfile mode (%d) == testmode (%d) for file (%s) in test %d\n",
		     mode, testmode, cmd[0], i);
      return NOPASS;
    }
  }
  chmod(cmd[0], 00755); // hack
     853:	8b 45 08             	mov    0x8(%ebp),%eax
     856:	8b 00                	mov    (%eax),%eax
     858:	83 ec 08             	sub    $0x8,%esp
     85b:	68 ed 01 00 00       	push   $0x1ed
     860:	50                   	push   %eax
     861:	e8 2d 0c 00 00       	call   1493 <chmod>
     866:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     869:	83 ec 08             	sub    $0x8,%esp
     86c:	68 e1 1b 00 00       	push   $0x1be1
     871:	6a 01                	push   $0x1
     873:	e8 0a 0d 00 00       	call   1582 <printf>
     878:	83 c4 10             	add    $0x10,%esp
  return PASS;
     87b:	b8 01 00 00 00       	mov    $0x1,%eax
}
     880:	c9                   	leave  
     881:	c3                   	ret    

00000882 <doChownTest>:

static int
doChownTest(char **cmd) 
{
     882:	55                   	push   %ebp
     883:	89 e5                	mov    %esp,%ebp
     885:	83 ec 38             	sub    $0x38,%esp
  int rc, uid1, uid2;
  struct stat st;

  printf(1, "\nExecuting chown test.\n\n");
     888:	83 ec 08             	sub    $0x8,%esp
     88b:	68 3f 1f 00 00       	push   $0x1f3f
     890:	6a 01                	push   $0x1
     892:	e8 eb 0c 00 00       	call   1582 <printf>
     897:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     89a:	8b 45 08             	mov    0x8(%ebp),%eax
     89d:	8b 00                	mov    (%eax),%eax
     89f:	83 ec 08             	sub    $0x8,%esp
     8a2:	8d 55 d0             	lea    -0x30(%ebp),%edx
     8a5:	52                   	push   %edx
     8a6:	50                   	push   %eax
     8a7:	e8 db 09 00 00       	call   1287 <stat>
     8ac:	83 c4 10             	add    $0x10,%esp
  uid1 = st.uid;
     8af:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     8b3:	0f b7 c0             	movzwl %ax,%eax
     8b6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chown(cmd[0], uid1+1);
     8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8bc:	8d 50 01             	lea    0x1(%eax),%edx
     8bf:	8b 45 08             	mov    0x8(%ebp),%eax
     8c2:	8b 00                	mov    (%eax),%eax
     8c4:	83 ec 08             	sub    $0x8,%esp
     8c7:	52                   	push   %edx
     8c8:	50                   	push   %eax
     8c9:	e8 cd 0b 00 00       	call   149b <chown>
     8ce:	83 c4 10             	add    $0x10,%esp
     8d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     8d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     8d8:	74 1c                	je     8f6 <doChownTest+0x74>
    printf(2, "Error! chown() failed on setting new owner. %d as rc.\n", rc);
     8da:	83 ec 04             	sub    $0x4,%esp
     8dd:	ff 75 f0             	pushl  -0x10(%ebp)
     8e0:	68 58 1f 00 00       	push   $0x1f58
     8e5:	6a 02                	push   $0x2
     8e7:	e8 96 0c 00 00       	call   1582 <printf>
     8ec:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     8ef:	b8 00 00 00 00       	mov    $0x0,%eax
     8f4:	eb 6e                	jmp    964 <doChownTest+0xe2>
  }

  stat(cmd[0], &st);
     8f6:	8b 45 08             	mov    0x8(%ebp),%eax
     8f9:	8b 00                	mov    (%eax),%eax
     8fb:	83 ec 08             	sub    $0x8,%esp
     8fe:	8d 55 d0             	lea    -0x30(%ebp),%edx
     901:	52                   	push   %edx
     902:	50                   	push   %eax
     903:	e8 7f 09 00 00       	call   1287 <stat>
     908:	83 c4 10             	add    $0x10,%esp
  uid2 = st.uid;
     90b:	0f b7 45 de          	movzwl -0x22(%ebp),%eax
     90f:	0f b7 c0             	movzwl %ax,%eax
     912:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (uid1 == uid2) {
     915:	8b 45 f4             	mov    -0xc(%ebp),%eax
     918:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     91b:	75 1c                	jne    939 <doChownTest+0xb7>
    printf(2, "Error! test failed. Old uid: %d, new uid: uid2, should differ\n",
     91d:	ff 75 ec             	pushl  -0x14(%ebp)
     920:	ff 75 f4             	pushl  -0xc(%ebp)
     923:	68 90 1f 00 00       	push   $0x1f90
     928:	6a 02                	push   $0x2
     92a:	e8 53 0c 00 00       	call   1582 <printf>
     92f:	83 c4 10             	add    $0x10,%esp
		    uid1, uid2);
    return NOPASS;
     932:	b8 00 00 00 00       	mov    $0x0,%eax
     937:	eb 2b                	jmp    964 <doChownTest+0xe2>
  }
  chown(cmd[0], uid1);  // put back the original
     939:	8b 45 08             	mov    0x8(%ebp),%eax
     93c:	8b 00                	mov    (%eax),%eax
     93e:	83 ec 08             	sub    $0x8,%esp
     941:	ff 75 f4             	pushl  -0xc(%ebp)
     944:	50                   	push   %eax
     945:	e8 51 0b 00 00       	call   149b <chown>
     94a:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     94d:	83 ec 08             	sub    $0x8,%esp
     950:	68 e1 1b 00 00       	push   $0x1be1
     955:	6a 01                	push   $0x1
     957:	e8 26 0c 00 00       	call   1582 <printf>
     95c:	83 c4 10             	add    $0x10,%esp
  return PASS;
     95f:	b8 01 00 00 00       	mov    $0x1,%eax
}
     964:	c9                   	leave  
     965:	c3                   	ret    

00000966 <doChgrpTest>:

static int
doChgrpTest(char **cmd) 
{
     966:	55                   	push   %ebp
     967:	89 e5                	mov    %esp,%ebp
     969:	83 ec 38             	sub    $0x38,%esp
  int rc, gid1, gid2;
  struct stat st;

  printf(1, "\nExecuting chgrp test.\n\n");
     96c:	83 ec 08             	sub    $0x8,%esp
     96f:	68 cf 1f 00 00       	push   $0x1fcf
     974:	6a 01                	push   $0x1
     976:	e8 07 0c 00 00       	call   1582 <printf>
     97b:	83 c4 10             	add    $0x10,%esp

  stat(cmd[0], &st);
     97e:	8b 45 08             	mov    0x8(%ebp),%eax
     981:	8b 00                	mov    (%eax),%eax
     983:	83 ec 08             	sub    $0x8,%esp
     986:	8d 55 d0             	lea    -0x30(%ebp),%edx
     989:	52                   	push   %edx
     98a:	50                   	push   %eax
     98b:	e8 f7 08 00 00       	call   1287 <stat>
     990:	83 c4 10             	add    $0x10,%esp
  gid1 = st.gid;
     993:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     997:	0f b7 c0             	movzwl %ax,%eax
     99a:	89 45 f4             	mov    %eax,-0xc(%ebp)

  rc = chgrp(cmd[0], gid1+1);
     99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9a0:	8d 50 01             	lea    0x1(%eax),%edx
     9a3:	8b 45 08             	mov    0x8(%ebp),%eax
     9a6:	8b 00                	mov    (%eax),%eax
     9a8:	83 ec 08             	sub    $0x8,%esp
     9ab:	52                   	push   %edx
     9ac:	50                   	push   %eax
     9ad:	e8 f1 0a 00 00       	call   14a3 <chgrp>
     9b2:	83 c4 10             	add    $0x10,%esp
     9b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if (rc != 0) {
     9b8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9bc:	74 19                	je     9d7 <doChgrpTest+0x71>
    printf(2, "Error! chgrp() failed on setting new group.\n");
     9be:	83 ec 08             	sub    $0x8,%esp
     9c1:	68 e8 1f 00 00       	push   $0x1fe8
     9c6:	6a 02                	push   $0x2
     9c8:	e8 b5 0b 00 00       	call   1582 <printf>
     9cd:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     9d0:	b8 00 00 00 00       	mov    $0x0,%eax
     9d5:	eb 6e                	jmp    a45 <doChgrpTest+0xdf>
  }

  stat(cmd[0], &st);
     9d7:	8b 45 08             	mov    0x8(%ebp),%eax
     9da:	8b 00                	mov    (%eax),%eax
     9dc:	83 ec 08             	sub    $0x8,%esp
     9df:	8d 55 d0             	lea    -0x30(%ebp),%edx
     9e2:	52                   	push   %edx
     9e3:	50                   	push   %eax
     9e4:	e8 9e 08 00 00       	call   1287 <stat>
     9e9:	83 c4 10             	add    $0x10,%esp
  gid2 = st.gid;
     9ec:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
     9f0:	0f b7 c0             	movzwl %ax,%eax
     9f3:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (gid1 == gid2) {
     9f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     9fc:	75 1c                	jne    a1a <doChgrpTest+0xb4>
    printf(2, "Error! test failed. Old gid: %d, new gid: gid2, should differ\n",
     9fe:	ff 75 ec             	pushl  -0x14(%ebp)
     a01:	ff 75 f4             	pushl  -0xc(%ebp)
     a04:	68 18 20 00 00       	push   $0x2018
     a09:	6a 02                	push   $0x2
     a0b:	e8 72 0b 00 00       	call   1582 <printf>
     a10:	83 c4 10             	add    $0x10,%esp
                    gid1, gid2);
    return NOPASS;
     a13:	b8 00 00 00 00       	mov    $0x0,%eax
     a18:	eb 2b                	jmp    a45 <doChgrpTest+0xdf>
  }
  chgrp(cmd[0], gid1);  // put back the original
     a1a:	8b 45 08             	mov    0x8(%ebp),%eax
     a1d:	8b 00                	mov    (%eax),%eax
     a1f:	83 ec 08             	sub    $0x8,%esp
     a22:	ff 75 f4             	pushl  -0xc(%ebp)
     a25:	50                   	push   %eax
     a26:	e8 78 0a 00 00       	call   14a3 <chgrp>
     a2b:	83 c4 10             	add    $0x10,%esp
  printf(1, "Test Passed\n");
     a2e:	83 ec 08             	sub    $0x8,%esp
     a31:	68 e1 1b 00 00       	push   $0x1be1
     a36:	6a 01                	push   $0x1
     a38:	e8 45 0b 00 00       	call   1582 <printf>
     a3d:	83 c4 10             	add    $0x10,%esp
  return PASS;
     a40:	b8 01 00 00 00       	mov    $0x1,%eax
}
     a45:	c9                   	leave  
     a46:	c3                   	ret    

00000a47 <doExecTest>:

static int
doExecTest(char **cmd) 
{
     a47:	55                   	push   %ebp
     a48:	89 e5                	mov    %esp,%ebp
     a4a:	83 ec 38             	sub    $0x38,%esp
  int i, rc, uid, gid;
  struct stat st;

  printf(1, "\nExecuting exec test.\n\n");
     a4d:	83 ec 08             	sub    $0x8,%esp
     a50:	68 57 20 00 00       	push   $0x2057
     a55:	6a 01                	push   $0x1
     a57:	e8 26 0b 00 00       	call   1582 <printf>
     a5c:	83 c4 10             	add    $0x10,%esp

  if (!canRun(cmd[0])) {
     a5f:	8b 45 08             	mov    0x8(%ebp),%eax
     a62:	8b 00                	mov    (%eax),%eax
     a64:	83 ec 0c             	sub    $0xc,%esp
     a67:	50                   	push   %eax
     a68:	e8 93 f5 ff ff       	call   0 <canRun>
     a6d:	83 c4 10             	add    $0x10,%esp
     a70:	85 c0                	test   %eax,%eax
     a72:	75 22                	jne    a96 <doExecTest+0x4f>
    printf(2, "Unable to run %s. test aborted.\n", cmd[0]);
     a74:	8b 45 08             	mov    0x8(%ebp),%eax
     a77:	8b 00                	mov    (%eax),%eax
     a79:	83 ec 04             	sub    $0x4,%esp
     a7c:	50                   	push   %eax
     a7d:	68 70 20 00 00       	push   $0x2070
     a82:	6a 02                	push   $0x2
     a84:	e8 f9 0a 00 00       	call   1582 <printf>
     a89:	83 c4 10             	add    $0x10,%esp
    return NOPASS;
     a8c:	b8 00 00 00 00       	mov    $0x0,%eax
     a91:	e9 f2 02 00 00       	jmp    d88 <doExecTest+0x341>
  }

  check(stat(cmd[0], &st));
     a96:	8b 45 08             	mov    0x8(%ebp),%eax
     a99:	8b 00                	mov    (%eax),%eax
     a9b:	83 ec 08             	sub    $0x8,%esp
     a9e:	8d 55 cc             	lea    -0x34(%ebp),%edx
     aa1:	52                   	push   %edx
     aa2:	50                   	push   %eax
     aa3:	e8 df 07 00 00       	call   1287 <stat>
     aa8:	83 c4 10             	add    $0x10,%esp
     aab:	89 45 f0             	mov    %eax,-0x10(%ebp)
     aae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ab2:	74 21                	je     ad5 <doExecTest+0x8e>
     ab4:	83 ec 04             	sub    $0x4,%esp
     ab7:	68 d9 1e 00 00       	push   $0x1ed9
     abc:	68 5c 19 00 00       	push   $0x195c
     ac1:	6a 02                	push   $0x2
     ac3:	e8 ba 0a 00 00       	call   1582 <printf>
     ac8:	83 c4 10             	add    $0x10,%esp
     acb:	b8 00 00 00 00       	mov    $0x0,%eax
     ad0:	e9 b3 02 00 00       	jmp    d88 <doExecTest+0x341>
  uid = st.uid;
     ad5:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
     ad9:	0f b7 c0             	movzwl %ax,%eax
     adc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  gid = st.gid;
     adf:	0f b7 45 dc          	movzwl -0x24(%ebp),%eax
     ae3:	0f b7 c0             	movzwl %ax,%eax
     ae6:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     ae9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     af0:	e9 30 02 00 00       	jmp    d25 <doExecTest+0x2de>
    check(setuid(testperms[i][procuid]));
     af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     af8:	c1 e0 04             	shl    $0x4,%eax
     afb:	05 00 26 00 00       	add    $0x2600,%eax
     b00:	8b 00                	mov    (%eax),%eax
     b02:	83 ec 0c             	sub    $0xc,%esp
     b05:	50                   	push   %eax
     b06:	e8 68 09 00 00       	call   1473 <setuid>
     b0b:	83 c4 10             	add    $0x10,%esp
     b0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b15:	74 21                	je     b38 <doExecTest+0xf1>
     b17:	83 ec 04             	sub    $0x4,%esp
     b1a:	68 55 1a 00 00       	push   $0x1a55
     b1f:	68 5c 19 00 00       	push   $0x195c
     b24:	6a 02                	push   $0x2
     b26:	e8 57 0a 00 00       	call   1582 <printf>
     b2b:	83 c4 10             	add    $0x10,%esp
     b2e:	b8 00 00 00 00       	mov    $0x0,%eax
     b33:	e9 50 02 00 00       	jmp    d88 <doExecTest+0x341>
    check(setgid(testperms[i][procgid]));
     b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b3b:	c1 e0 04             	shl    $0x4,%eax
     b3e:	05 04 26 00 00       	add    $0x2604,%eax
     b43:	8b 00                	mov    (%eax),%eax
     b45:	83 ec 0c             	sub    $0xc,%esp
     b48:	50                   	push   %eax
     b49:	e8 2d 09 00 00       	call   147b <setgid>
     b4e:	83 c4 10             	add    $0x10,%esp
     b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b58:	74 21                	je     b7b <doExecTest+0x134>
     b5a:	83 ec 04             	sub    $0x4,%esp
     b5d:	68 73 1a 00 00       	push   $0x1a73
     b62:	68 5c 19 00 00       	push   $0x195c
     b67:	6a 02                	push   $0x2
     b69:	e8 14 0a 00 00       	call   1582 <printf>
     b6e:	83 c4 10             	add    $0x10,%esp
     b71:	b8 00 00 00 00       	mov    $0x0,%eax
     b76:	e9 0d 02 00 00       	jmp    d88 <doExecTest+0x341>
    check(chown(cmd[0], testperms[i][fileuid]));
     b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b7e:	c1 e0 04             	shl    $0x4,%eax
     b81:	05 08 26 00 00       	add    $0x2608,%eax
     b86:	8b 10                	mov    (%eax),%edx
     b88:	8b 45 08             	mov    0x8(%ebp),%eax
     b8b:	8b 00                	mov    (%eax),%eax
     b8d:	83 ec 08             	sub    $0x8,%esp
     b90:	52                   	push   %edx
     b91:	50                   	push   %eax
     b92:	e8 04 09 00 00       	call   149b <chown>
     b97:	83 c4 10             	add    $0x10,%esp
     b9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
     b9d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ba1:	74 21                	je     bc4 <doExecTest+0x17d>
     ba3:	83 ec 04             	sub    $0x4,%esp
     ba6:	68 ac 1a 00 00       	push   $0x1aac
     bab:	68 5c 19 00 00       	push   $0x195c
     bb0:	6a 02                	push   $0x2
     bb2:	e8 cb 09 00 00       	call   1582 <printf>
     bb7:	83 c4 10             	add    $0x10,%esp
     bba:	b8 00 00 00 00       	mov    $0x0,%eax
     bbf:	e9 c4 01 00 00       	jmp    d88 <doExecTest+0x341>
    check(chgrp(cmd[0], testperms[i][filegid]));
     bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     bc7:	c1 e0 04             	shl    $0x4,%eax
     bca:	05 0c 26 00 00       	add    $0x260c,%eax
     bcf:	8b 10                	mov    (%eax),%edx
     bd1:	8b 45 08             	mov    0x8(%ebp),%eax
     bd4:	8b 00                	mov    (%eax),%eax
     bd6:	83 ec 08             	sub    $0x8,%esp
     bd9:	52                   	push   %edx
     bda:	50                   	push   %eax
     bdb:	e8 c3 08 00 00       	call   14a3 <chgrp>
     be0:	83 c4 10             	add    $0x10,%esp
     be3:	89 45 f0             	mov    %eax,-0x10(%ebp)
     be6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bea:	74 21                	je     c0d <doExecTest+0x1c6>
     bec:	83 ec 04             	sub    $0x4,%esp
     bef:	68 d4 1a 00 00       	push   $0x1ad4
     bf4:	68 5c 19 00 00       	push   $0x195c
     bf9:	6a 02                	push   $0x2
     bfb:	e8 82 09 00 00       	call   1582 <printf>
     c00:	83 c4 10             	add    $0x10,%esp
     c03:	b8 00 00 00 00       	mov    $0x0,%eax
     c08:	e9 7b 01 00 00       	jmp    d88 <doExecTest+0x341>
    check(chmod(cmd[0], atoi(perms[i])));
     c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c10:	8b 04 85 e4 25 00 00 	mov    0x25e4(,%eax,4),%eax
     c17:	83 ec 0c             	sub    $0xc,%esp
     c1a:	50                   	push   %eax
     c1b:	e8 b4 06 00 00       	call   12d4 <atoi>
     c20:	83 c4 10             	add    $0x10,%esp
     c23:	89 c2                	mov    %eax,%edx
     c25:	8b 45 08             	mov    0x8(%ebp),%eax
     c28:	8b 00                	mov    (%eax),%eax
     c2a:	83 ec 08             	sub    $0x8,%esp
     c2d:	52                   	push   %edx
     c2e:	50                   	push   %eax
     c2f:	e8 5f 08 00 00       	call   1493 <chmod>
     c34:	83 c4 10             	add    $0x10,%esp
     c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
     c3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c3e:	74 21                	je     c61 <doExecTest+0x21a>
     c40:	83 ec 04             	sub    $0x4,%esp
     c43:	68 10 1b 00 00       	push   $0x1b10
     c48:	68 5c 19 00 00       	push   $0x195c
     c4d:	6a 02                	push   $0x2
     c4f:	e8 2e 09 00 00       	call   1582 <printf>
     c54:	83 c4 10             	add    $0x10,%esp
     c57:	b8 00 00 00 00       	mov    $0x0,%eax
     c5c:	e9 27 01 00 00       	jmp    d88 <doExecTest+0x341>

    if (i != NUMPERMSTOCHECK-1)
     c61:	a1 e0 25 00 00       	mov    0x25e0,%eax
     c66:	83 e8 01             	sub    $0x1,%eax
     c69:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     c6c:	74 14                	je     c82 <doExecTest+0x23b>
      printf(2, "The following test should not produce an error.\n");
     c6e:	83 ec 08             	sub    $0x8,%esp
     c71:	68 94 20 00 00       	push   $0x2094
     c76:	6a 02                	push   $0x2
     c78:	e8 05 09 00 00       	call   1582 <printf>
     c7d:	83 c4 10             	add    $0x10,%esp
     c80:	eb 12                	jmp    c94 <doExecTest+0x24d>
    else
      printf(2, "The following test should fail.\n");
     c82:	83 ec 08             	sub    $0x8,%esp
     c85:	68 c8 20 00 00       	push   $0x20c8
     c8a:	6a 02                	push   $0x2
     c8c:	e8 f1 08 00 00       	call   1582 <printf>
     c91:	83 c4 10             	add    $0x10,%esp
    rc = fork();
     c94:	e8 0a 07 00 00       	call   13a3 <fork>
     c99:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (rc < 0) {    // fork failed
     c9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ca0:	79 1c                	jns    cbe <doExecTest+0x277>
      printf(2, "The fork() system call failed. That's pretty catastrophic. Ending test\n");
     ca2:	83 ec 08             	sub    $0x8,%esp
     ca5:	68 48 1b 00 00       	push   $0x1b48
     caa:	6a 02                	push   $0x2
     cac:	e8 d1 08 00 00       	call   1582 <printf>
     cb1:	83 c4 10             	add    $0x10,%esp
      return NOPASS;
     cb4:	b8 00 00 00 00       	mov    $0x0,%eax
     cb9:	e9 ca 00 00 00       	jmp    d88 <doExecTest+0x341>
    }
    if (rc == 0) {   // child
     cbe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cc2:	75 58                	jne    d1c <doExecTest+0x2d5>
      exec(cmd[0], cmd);
     cc4:	8b 45 08             	mov    0x8(%ebp),%eax
     cc7:	8b 00                	mov    (%eax),%eax
     cc9:	83 ec 08             	sub    $0x8,%esp
     ccc:	ff 75 08             	pushl  0x8(%ebp)
     ccf:	50                   	push   %eax
     cd0:	e8 0e 07 00 00       	call   13e3 <exec>
     cd5:	83 c4 10             	add    $0x10,%esp
      if (i != NUMPERMSTOCHECK-1) printf(2, "**** exec call for %s **FAILED**.\n",  cmd[0]);
     cd8:	a1 e0 25 00 00       	mov    0x25e0,%eax
     cdd:	83 e8 01             	sub    $0x1,%eax
     ce0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     ce3:	74 1a                	je     cff <doExecTest+0x2b8>
     ce5:	8b 45 08             	mov    0x8(%ebp),%eax
     ce8:	8b 00                	mov    (%eax),%eax
     cea:	83 ec 04             	sub    $0x4,%esp
     ced:	50                   	push   %eax
     cee:	68 90 1b 00 00       	push   $0x1b90
     cf3:	6a 02                	push   $0x2
     cf5:	e8 88 08 00 00       	call   1582 <printf>
     cfa:	83 c4 10             	add    $0x10,%esp
     cfd:	eb 18                	jmp    d17 <doExecTest+0x2d0>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
     cff:	8b 45 08             	mov    0x8(%ebp),%eax
     d02:	8b 00                	mov    (%eax),%eax
     d04:	83 ec 04             	sub    $0x4,%esp
     d07:	50                   	push   %eax
     d08:	68 b4 1b 00 00       	push   $0x1bb4
     d0d:	6a 02                	push   $0x2
     d0f:	e8 6e 08 00 00       	call   1582 <printf>
     d14:	83 c4 10             	add    $0x10,%esp
      exit();
     d17:	e8 8f 06 00 00       	call   13ab <exit>
    }
    wait();
     d1c:	e8 92 06 00 00       	call   13b3 <wait>

  check(stat(cmd[0], &st));
  uid = st.uid;
  gid = st.gid;

  for (i=0; i<NUMPERMSTOCHECK; i++) {
     d21:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     d25:	a1 e0 25 00 00       	mov    0x25e0,%eax
     d2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     d2d:	0f 8c c2 fd ff ff    	jl     af5 <doExecTest+0xae>
      else printf(2, "**** exec call for %s **FAILED as expected.\n", cmd[0]);
      exit();
    }
    wait();
  }
  chown(cmd[0], uid);
     d33:	8b 45 08             	mov    0x8(%ebp),%eax
     d36:	8b 00                	mov    (%eax),%eax
     d38:	83 ec 08             	sub    $0x8,%esp
     d3b:	ff 75 ec             	pushl  -0x14(%ebp)
     d3e:	50                   	push   %eax
     d3f:	e8 57 07 00 00       	call   149b <chown>
     d44:	83 c4 10             	add    $0x10,%esp
  chgrp(cmd[0], gid);
     d47:	8b 45 08             	mov    0x8(%ebp),%eax
     d4a:	8b 00                	mov    (%eax),%eax
     d4c:	83 ec 08             	sub    $0x8,%esp
     d4f:	ff 75 e8             	pushl  -0x18(%ebp)
     d52:	50                   	push   %eax
     d53:	e8 4b 07 00 00       	call   14a3 <chgrp>
     d58:	83 c4 10             	add    $0x10,%esp
  chmod(cmd[0], 00755);
     d5b:	8b 45 08             	mov    0x8(%ebp),%eax
     d5e:	8b 00                	mov    (%eax),%eax
     d60:	83 ec 08             	sub    $0x8,%esp
     d63:	68 ed 01 00 00       	push   $0x1ed
     d68:	50                   	push   %eax
     d69:	e8 25 07 00 00       	call   1493 <chmod>
     d6e:	83 c4 10             	add    $0x10,%esp
  printf(1, "Requires user visually confirms PASS/FAIL\n");
     d71:	83 ec 08             	sub    $0x8,%esp
     d74:	68 ec 20 00 00       	push   $0x20ec
     d79:	6a 01                	push   $0x1
     d7b:	e8 02 08 00 00       	call   1582 <printf>
     d80:	83 c4 10             	add    $0x10,%esp
  return PASS;
     d83:	b8 01 00 00 00       	mov    $0x1,%eax
}
     d88:	c9                   	leave  
     d89:	c3                   	ret    

00000d8a <printMenu>:

void
printMenu(void)
{
     d8a:	55                   	push   %ebp
     d8b:	89 e5                	mov    %esp,%ebp
     d8d:	83 ec 18             	sub    $0x18,%esp
  int i = 0;
     d90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  printf(1, "\n");
     d97:	83 ec 08             	sub    $0x8,%esp
     d9a:	68 17 21 00 00       	push   $0x2117
     d9f:	6a 01                	push   $0x1
     da1:	e8 dc 07 00 00       	call   1582 <printf>
     da6:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exit program\n", i++);
     da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dac:	8d 50 01             	lea    0x1(%eax),%edx
     daf:	89 55 f4             	mov    %edx,-0xc(%ebp)
     db2:	83 ec 04             	sub    $0x4,%esp
     db5:	50                   	push   %eax
     db6:	68 19 21 00 00       	push   $0x2119
     dbb:	6a 01                	push   $0x1
     dbd:	e8 c0 07 00 00       	call   1582 <printf>
     dc2:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc UID\n", i++);
     dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     dc8:	8d 50 01             	lea    0x1(%eax),%edx
     dcb:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dce:	83 ec 04             	sub    $0x4,%esp
     dd1:	50                   	push   %eax
     dd2:	68 2b 21 00 00       	push   $0x212b
     dd7:	6a 01                	push   $0x1
     dd9:	e8 a4 07 00 00       	call   1582 <printf>
     dde:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. Proc GID\n", i++);
     de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     de4:	8d 50 01             	lea    0x1(%eax),%edx
     de7:	89 55 f4             	mov    %edx,-0xc(%ebp)
     dea:	83 ec 04             	sub    $0x4,%esp
     ded:	50                   	push   %eax
     dee:	68 39 21 00 00       	push   $0x2139
     df3:	6a 01                	push   $0x1
     df5:	e8 88 07 00 00       	call   1582 <printf>
     dfa:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chmod()\n", i++);
     dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e00:	8d 50 01             	lea    0x1(%eax),%edx
     e03:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e06:	83 ec 04             	sub    $0x4,%esp
     e09:	50                   	push   %eax
     e0a:	68 47 21 00 00       	push   $0x2147
     e0f:	6a 01                	push   $0x1
     e11:	e8 6c 07 00 00       	call   1582 <printf>
     e16:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chown()\n", i++);
     e19:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e1c:	8d 50 01             	lea    0x1(%eax),%edx
     e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e22:	83 ec 04             	sub    $0x4,%esp
     e25:	50                   	push   %eax
     e26:	68 54 21 00 00       	push   $0x2154
     e2b:	6a 01                	push   $0x1
     e2d:	e8 50 07 00 00       	call   1582 <printf>
     e32:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. chgrp()\n", i++);
     e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e38:	8d 50 01             	lea    0x1(%eax),%edx
     e3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e3e:	83 ec 04             	sub    $0x4,%esp
     e41:	50                   	push   %eax
     e42:	68 61 21 00 00       	push   $0x2161
     e47:	6a 01                	push   $0x1
     e49:	e8 34 07 00 00       	call   1582 <printf>
     e4e:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. exec()\n", i++);
     e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e54:	8d 50 01             	lea    0x1(%eax),%edx
     e57:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e5a:	83 ec 04             	sub    $0x4,%esp
     e5d:	50                   	push   %eax
     e5e:	68 6e 21 00 00       	push   $0x216e
     e63:	6a 01                	push   $0x1
     e65:	e8 18 07 00 00       	call   1582 <printf>
     e6a:	83 c4 10             	add    $0x10,%esp
  printf(1, "%d. setuid\n", i++);
     e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e70:	8d 50 01             	lea    0x1(%eax),%edx
     e73:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e76:	83 ec 04             	sub    $0x4,%esp
     e79:	50                   	push   %eax
     e7a:	68 7a 21 00 00       	push   $0x217a
     e7f:	6a 01                	push   $0x1
     e81:	e8 fc 06 00 00       	call   1582 <printf>
     e86:	83 c4 10             	add    $0x10,%esp
}
     e89:	90                   	nop
     e8a:	c9                   	leave  
     e8b:	c3                   	ret    

00000e8c <main>:

int
main(int argc, char *argv[])
{
     e8c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     e90:	83 e4 f0             	and    $0xfffffff0,%esp
     e93:	ff 71 fc             	pushl  -0x4(%ecx)
     e96:	55                   	push   %ebp
     e97:	89 e5                	mov    %esp,%ebp
     e99:	51                   	push   %ecx
     e9a:	83 ec 24             	sub    $0x24,%esp
  int rc, select, done;
  char buf[5];

  // test strings
  char *t0[] = {'\0'}; // dummy
     e9d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  char *t1[] = {"testsetuid", '\0'};
     ea4:	c7 45 d8 86 21 00 00 	movl   $0x2186,-0x28(%ebp)
     eab:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)

  while (1) {
    done = FALSE;
     eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    printMenu();
     eb9:	e8 cc fe ff ff       	call   d8a <printMenu>
    printf(1, "Enter test number: ");
     ebe:	83 ec 08             	sub    $0x8,%esp
     ec1:	68 91 21 00 00       	push   $0x2191
     ec6:	6a 01                	push   $0x1
     ec8:	e8 b5 06 00 00       	call   1582 <printf>
     ecd:	83 c4 10             	add    $0x10,%esp
    gets(buf, 5);
     ed0:	83 ec 08             	sub    $0x8,%esp
     ed3:	6a 05                	push   $0x5
     ed5:	8d 45 e7             	lea    -0x19(%ebp),%eax
     ed8:	50                   	push   %eax
     ed9:	e8 3a 03 00 00       	call   1218 <gets>
     ede:	83 c4 10             	add    $0x10,%esp
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
     ee1:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ee5:	3c 0a                	cmp    $0xa,%al
     ee7:	0f 84 f5 01 00 00    	je     10e2 <main+0x256>
     eed:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ef1:	84 c0                	test   %al,%al
     ef3:	0f 84 e9 01 00 00    	je     10e2 <main+0x256>
    select = atoi(buf);
     ef9:	83 ec 0c             	sub    $0xc,%esp
     efc:	8d 45 e7             	lea    -0x19(%ebp),%eax
     eff:	50                   	push   %eax
     f00:	e8 cf 03 00 00       	call   12d4 <atoi>
     f05:	83 c4 10             	add    $0x10,%esp
     f08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    switch (select) {
     f0b:	83 7d f0 07          	cmpl   $0x7,-0x10(%ebp)
     f0f:	0f 87 9b 01 00 00    	ja     10b0 <main+0x224>
     f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f18:	c1 e0 02             	shl    $0x2,%eax
     f1b:	05 34 22 00 00       	add    $0x2234,%eax
     f20:	8b 00                	mov    (%eax),%eax
     f22:	ff e0                	jmp    *%eax
	    case 0: done = TRUE; break;
     f24:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     f2b:	e9 a7 01 00 00       	jmp    10d7 <main+0x24b>
	    case 1:
		  doTest(doUidTest,    t0); break;
     f30:	83 ec 0c             	sub    $0xc,%esp
     f33:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f36:	50                   	push   %eax
     f37:	e8 af f4 ff ff       	call   3eb <doUidTest>
     f3c:	83 c4 10             	add    $0x10,%esp
     f3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f46:	0f 85 78 01 00 00    	jne    10c4 <main+0x238>
     f4c:	83 ec 04             	sub    $0x4,%esp
     f4f:	68 a5 21 00 00       	push   $0x21a5
     f54:	68 af 21 00 00       	push   $0x21af
     f59:	6a 02                	push   $0x2
     f5b:	e8 22 06 00 00       	call   1582 <printf>
     f60:	83 c4 10             	add    $0x10,%esp
     f63:	e8 43 04 00 00       	call   13ab <exit>
	    case 2:
		  doTest(doGidTest,    t0); break;
     f68:	83 ec 0c             	sub    $0xc,%esp
     f6b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     f6e:	50                   	push   %eax
     f6f:	e8 00 f6 ff ff       	call   574 <doGidTest>
     f74:	83 c4 10             	add    $0x10,%esp
     f77:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f7e:	0f 85 43 01 00 00    	jne    10c7 <main+0x23b>
     f84:	83 ec 04             	sub    $0x4,%esp
     f87:	68 c1 21 00 00       	push   $0x21c1
     f8c:	68 af 21 00 00       	push   $0x21af
     f91:	6a 02                	push   $0x2
     f93:	e8 ea 05 00 00       	call   1582 <printf>
     f98:	83 c4 10             	add    $0x10,%esp
     f9b:	e8 0b 04 00 00       	call   13ab <exit>
	    case 3:
		  doTest(doChmodTest,  t1); break;
     fa0:	83 ec 0c             	sub    $0xc,%esp
     fa3:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fa6:	50                   	push   %eax
     fa7:	e8 51 f7 ff ff       	call   6fd <doChmodTest>
     fac:	83 c4 10             	add    $0x10,%esp
     faf:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fb2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fb6:	0f 85 0e 01 00 00    	jne    10ca <main+0x23e>
     fbc:	83 ec 04             	sub    $0x4,%esp
     fbf:	68 cb 21 00 00       	push   $0x21cb
     fc4:	68 af 21 00 00       	push   $0x21af
     fc9:	6a 02                	push   $0x2
     fcb:	e8 b2 05 00 00       	call   1582 <printf>
     fd0:	83 c4 10             	add    $0x10,%esp
     fd3:	e8 d3 03 00 00       	call   13ab <exit>
	    case 4:
		  doTest(doChownTest,  t1); break;
     fd8:	83 ec 0c             	sub    $0xc,%esp
     fdb:	8d 45 d8             	lea    -0x28(%ebp),%eax
     fde:	50                   	push   %eax
     fdf:	e8 9e f8 ff ff       	call   882 <doChownTest>
     fe4:	83 c4 10             	add    $0x10,%esp
     fe7:	89 45 ec             	mov    %eax,-0x14(%ebp)
     fea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fee:	0f 85 d9 00 00 00    	jne    10cd <main+0x241>
     ff4:	83 ec 04             	sub    $0x4,%esp
     ff7:	68 d7 21 00 00       	push   $0x21d7
     ffc:	68 af 21 00 00       	push   $0x21af
    1001:	6a 02                	push   $0x2
    1003:	e8 7a 05 00 00       	call   1582 <printf>
    1008:	83 c4 10             	add    $0x10,%esp
    100b:	e8 9b 03 00 00       	call   13ab <exit>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
    1010:	83 ec 0c             	sub    $0xc,%esp
    1013:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1016:	50                   	push   %eax
    1017:	e8 4a f9 ff ff       	call   966 <doChgrpTest>
    101c:	83 c4 10             	add    $0x10,%esp
    101f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1022:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1026:	0f 85 a4 00 00 00    	jne    10d0 <main+0x244>
    102c:	83 ec 04             	sub    $0x4,%esp
    102f:	68 e3 21 00 00       	push   $0x21e3
    1034:	68 af 21 00 00       	push   $0x21af
    1039:	6a 02                	push   $0x2
    103b:	e8 42 05 00 00       	call   1582 <printf>
    1040:	83 c4 10             	add    $0x10,%esp
    1043:	e8 63 03 00 00       	call   13ab <exit>
	    case 6:
		  doTest(doExecTest,   t1); break;
    1048:	83 ec 0c             	sub    $0xc,%esp
    104b:	8d 45 d8             	lea    -0x28(%ebp),%eax
    104e:	50                   	push   %eax
    104f:	e8 f3 f9 ff ff       	call   a47 <doExecTest>
    1054:	83 c4 10             	add    $0x10,%esp
    1057:	89 45 ec             	mov    %eax,-0x14(%ebp)
    105a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    105e:	75 73                	jne    10d3 <main+0x247>
    1060:	83 ec 04             	sub    $0x4,%esp
    1063:	68 ef 21 00 00       	push   $0x21ef
    1068:	68 af 21 00 00       	push   $0x21af
    106d:	6a 02                	push   $0x2
    106f:	e8 0e 05 00 00       	call   1582 <printf>
    1074:	83 c4 10             	add    $0x10,%esp
    1077:	e8 2f 03 00 00       	call   13ab <exit>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    107c:	83 ec 0c             	sub    $0xc,%esp
    107f:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1082:	50                   	push   %eax
    1083:	e8 63 f0 ff ff       	call   eb <doSetuidTest>
    1088:	83 c4 10             	add    $0x10,%esp
    108b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    108e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1092:	75 42                	jne    10d6 <main+0x24a>
    1094:	83 ec 04             	sub    $0x4,%esp
    1097:	68 fa 21 00 00       	push   $0x21fa
    109c:	68 af 21 00 00       	push   $0x21af
    10a1:	6a 02                	push   $0x2
    10a3:	e8 da 04 00 00       	call   1582 <printf>
    10a8:	83 c4 10             	add    $0x10,%esp
    10ab:	e8 fb 02 00 00       	call   13ab <exit>
	    default:
		   printf(1, "Error:invalid test number.\n");
    10b0:	83 ec 08             	sub    $0x8,%esp
    10b3:	68 07 22 00 00       	push   $0x2207
    10b8:	6a 01                	push   $0x1
    10ba:	e8 c3 04 00 00       	call   1582 <printf>
    10bf:	83 c4 10             	add    $0x10,%esp
    10c2:	eb 13                	jmp    10d7 <main+0x24b>
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    select = atoi(buf);
    switch (select) {
	    case 0: done = TRUE; break;
	    case 1:
		  doTest(doUidTest,    t0); break;
    10c4:	90                   	nop
    10c5:	eb 10                	jmp    10d7 <main+0x24b>
	    case 2:
		  doTest(doGidTest,    t0); break;
    10c7:	90                   	nop
    10c8:	eb 0d                	jmp    10d7 <main+0x24b>
	    case 3:
		  doTest(doChmodTest,  t1); break;
    10ca:	90                   	nop
    10cb:	eb 0a                	jmp    10d7 <main+0x24b>
	    case 4:
		  doTest(doChownTest,  t1); break;
    10cd:	90                   	nop
    10ce:	eb 07                	jmp    10d7 <main+0x24b>
	    case 5:
		  doTest(doChgrpTest,  t1); break;
    10d0:	90                   	nop
    10d1:	eb 04                	jmp    10d7 <main+0x24b>
	    case 6:
		  doTest(doExecTest,   t1); break;
    10d3:	90                   	nop
    10d4:	eb 01                	jmp    10d7 <main+0x24b>
	    case 7:
		  doTest(doSetuidTest, t1); break;
    10d6:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10db:	75 0b                	jne    10e8 <main+0x25c>
    10dd:	e9 d0 fd ff ff       	jmp    eb2 <main+0x26>
  while (1) {
    done = FALSE;
    printMenu();
    printf(1, "Enter test number: ");
    gets(buf, 5);
    if ((buf[0] == '\n') || (buf[0] == '\0')) continue;
    10e2:	90                   	nop
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
  }
    10e3:	e9 ca fd ff ff       	jmp    eb2 <main+0x26>
		  doTest(doSetuidTest, t1); break;
	    default:
		   printf(1, "Error:invalid test number.\n");
    }

    if (done) break;
    10e8:	90                   	nop
  }

  printf(1, "\nDone for now\n");
    10e9:	83 ec 08             	sub    $0x8,%esp
    10ec:	68 23 22 00 00       	push   $0x2223
    10f1:	6a 01                	push   $0x1
    10f3:	e8 8a 04 00 00       	call   1582 <printf>
    10f8:	83 c4 10             	add    $0x10,%esp
  free(buf);
    10fb:	83 ec 0c             	sub    $0xc,%esp
    10fe:	8d 45 e7             	lea    -0x19(%ebp),%eax
    1101:	50                   	push   %eax
    1102:	e8 0c 06 00 00       	call   1713 <free>
    1107:	83 c4 10             	add    $0x10,%esp
  exit();
    110a:	e8 9c 02 00 00       	call   13ab <exit>

0000110f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
    110f:	55                   	push   %ebp
    1110:	89 e5                	mov    %esp,%ebp
    1112:	57                   	push   %edi
    1113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
    1114:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1117:	8b 55 10             	mov    0x10(%ebp),%edx
    111a:	8b 45 0c             	mov    0xc(%ebp),%eax
    111d:	89 cb                	mov    %ecx,%ebx
    111f:	89 df                	mov    %ebx,%edi
    1121:	89 d1                	mov    %edx,%ecx
    1123:	fc                   	cld    
    1124:	f3 aa                	rep stos %al,%es:(%edi)
    1126:	89 ca                	mov    %ecx,%edx
    1128:	89 fb                	mov    %edi,%ebx
    112a:	89 5d 08             	mov    %ebx,0x8(%ebp)
    112d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
    1130:	90                   	nop
    1131:	5b                   	pop    %ebx
    1132:	5f                   	pop    %edi
    1133:	5d                   	pop    %ebp
    1134:	c3                   	ret    

00001135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
    1135:	55                   	push   %ebp
    1136:	89 e5                	mov    %esp,%ebp
    1138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
    1141:	90                   	nop
    1142:	8b 45 08             	mov    0x8(%ebp),%eax
    1145:	8d 50 01             	lea    0x1(%eax),%edx
    1148:	89 55 08             	mov    %edx,0x8(%ebp)
    114b:	8b 55 0c             	mov    0xc(%ebp),%edx
    114e:	8d 4a 01             	lea    0x1(%edx),%ecx
    1151:	89 4d 0c             	mov    %ecx,0xc(%ebp)
    1154:	0f b6 12             	movzbl (%edx),%edx
    1157:	88 10                	mov    %dl,(%eax)
    1159:	0f b6 00             	movzbl (%eax),%eax
    115c:	84 c0                	test   %al,%al
    115e:	75 e2                	jne    1142 <strcpy+0xd>
    ;
  return os;
    1160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1163:	c9                   	leave  
    1164:	c3                   	ret    

00001165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1165:	55                   	push   %ebp
    1166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    1168:	eb 08                	jmp    1172 <strcmp+0xd>
    p++, q++;
    116a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    116e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1172:	8b 45 08             	mov    0x8(%ebp),%eax
    1175:	0f b6 00             	movzbl (%eax),%eax
    1178:	84 c0                	test   %al,%al
    117a:	74 10                	je     118c <strcmp+0x27>
    117c:	8b 45 08             	mov    0x8(%ebp),%eax
    117f:	0f b6 10             	movzbl (%eax),%edx
    1182:	8b 45 0c             	mov    0xc(%ebp),%eax
    1185:	0f b6 00             	movzbl (%eax),%eax
    1188:	38 c2                	cmp    %al,%dl
    118a:	74 de                	je     116a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    118c:	8b 45 08             	mov    0x8(%ebp),%eax
    118f:	0f b6 00             	movzbl (%eax),%eax
    1192:	0f b6 d0             	movzbl %al,%edx
    1195:	8b 45 0c             	mov    0xc(%ebp),%eax
    1198:	0f b6 00             	movzbl (%eax),%eax
    119b:	0f b6 c0             	movzbl %al,%eax
    119e:	29 c2                	sub    %eax,%edx
    11a0:	89 d0                	mov    %edx,%eax
}
    11a2:	5d                   	pop    %ebp
    11a3:	c3                   	ret    

000011a4 <strlen>:

uint
strlen(char *s)
{
    11a4:	55                   	push   %ebp
    11a5:	89 e5                	mov    %esp,%ebp
    11a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    11aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b1:	eb 04                	jmp    11b7 <strlen+0x13>
    11b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
    11b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11ba:	8b 45 08             	mov    0x8(%ebp),%eax
    11bd:	01 d0                	add    %edx,%eax
    11bf:	0f b6 00             	movzbl (%eax),%eax
    11c2:	84 c0                	test   %al,%al
    11c4:	75 ed                	jne    11b3 <strlen+0xf>
    ;
  return n;
    11c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c9:	c9                   	leave  
    11ca:	c3                   	ret    

000011cb <memset>:

void*
memset(void *dst, int c, uint n)
{
    11cb:	55                   	push   %ebp
    11cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
    11ce:	8b 45 10             	mov    0x10(%ebp),%eax
    11d1:	50                   	push   %eax
    11d2:	ff 75 0c             	pushl  0xc(%ebp)
    11d5:	ff 75 08             	pushl  0x8(%ebp)
    11d8:	e8 32 ff ff ff       	call   110f <stosb>
    11dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
    11e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11e3:	c9                   	leave  
    11e4:	c3                   	ret    

000011e5 <strchr>:

char*
strchr(const char *s, char c)
{
    11e5:	55                   	push   %ebp
    11e6:	89 e5                	mov    %esp,%ebp
    11e8:	83 ec 04             	sub    $0x4,%esp
    11eb:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    11f1:	eb 14                	jmp    1207 <strchr+0x22>
    if(*s == c)
    11f3:	8b 45 08             	mov    0x8(%ebp),%eax
    11f6:	0f b6 00             	movzbl (%eax),%eax
    11f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
    11fc:	75 05                	jne    1203 <strchr+0x1e>
      return (char*)s;
    11fe:	8b 45 08             	mov    0x8(%ebp),%eax
    1201:	eb 13                	jmp    1216 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    1207:	8b 45 08             	mov    0x8(%ebp),%eax
    120a:	0f b6 00             	movzbl (%eax),%eax
    120d:	84 c0                	test   %al,%al
    120f:	75 e2                	jne    11f3 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1211:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1216:	c9                   	leave  
    1217:	c3                   	ret    

00001218 <gets>:

char*
gets(char *buf, int max)
{
    1218:	55                   	push   %ebp
    1219:	89 e5                	mov    %esp,%ebp
    121b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    121e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1225:	eb 42                	jmp    1269 <gets+0x51>
    cc = read(0, &c, 1);
    1227:	83 ec 04             	sub    $0x4,%esp
    122a:	6a 01                	push   $0x1
    122c:	8d 45 ef             	lea    -0x11(%ebp),%eax
    122f:	50                   	push   %eax
    1230:	6a 00                	push   $0x0
    1232:	e8 8c 01 00 00       	call   13c3 <read>
    1237:	83 c4 10             	add    $0x10,%esp
    123a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    123d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1241:	7e 33                	jle    1276 <gets+0x5e>
      break;
    buf[i++] = c;
    1243:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1246:	8d 50 01             	lea    0x1(%eax),%edx
    1249:	89 55 f4             	mov    %edx,-0xc(%ebp)
    124c:	89 c2                	mov    %eax,%edx
    124e:	8b 45 08             	mov    0x8(%ebp),%eax
    1251:	01 c2                	add    %eax,%edx
    1253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    125d:	3c 0a                	cmp    $0xa,%al
    125f:	74 16                	je     1277 <gets+0x5f>
    1261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    1265:	3c 0d                	cmp    $0xd,%al
    1267:	74 0e                	je     1277 <gets+0x5f>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1269:	8b 45 f4             	mov    -0xc(%ebp),%eax
    126c:	83 c0 01             	add    $0x1,%eax
    126f:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1272:	7c b3                	jl     1227 <gets+0xf>
    1274:	eb 01                	jmp    1277 <gets+0x5f>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    1276:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1277:	8b 55 f4             	mov    -0xc(%ebp),%edx
    127a:	8b 45 08             	mov    0x8(%ebp),%eax
    127d:	01 d0                	add    %edx,%eax
    127f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1282:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1285:	c9                   	leave  
    1286:	c3                   	ret    

00001287 <stat>:

int
stat(char *n, struct stat *st)
{
    1287:	55                   	push   %ebp
    1288:	89 e5                	mov    %esp,%ebp
    128a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    128d:	83 ec 08             	sub    $0x8,%esp
    1290:	6a 00                	push   $0x0
    1292:	ff 75 08             	pushl  0x8(%ebp)
    1295:	e8 51 01 00 00       	call   13eb <open>
    129a:	83 c4 10             	add    $0x10,%esp
    129d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a4:	79 07                	jns    12ad <stat+0x26>
    return -1;
    12a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12ab:	eb 25                	jmp    12d2 <stat+0x4b>
  r = fstat(fd, st);
    12ad:	83 ec 08             	sub    $0x8,%esp
    12b0:	ff 75 0c             	pushl  0xc(%ebp)
    12b3:	ff 75 f4             	pushl  -0xc(%ebp)
    12b6:	e8 48 01 00 00       	call   1403 <fstat>
    12bb:	83 c4 10             	add    $0x10,%esp
    12be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12c1:	83 ec 0c             	sub    $0xc,%esp
    12c4:	ff 75 f4             	pushl  -0xc(%ebp)
    12c7:	e8 07 01 00 00       	call   13d3 <close>
    12cc:	83 c4 10             	add    $0x10,%esp
  return r;
    12cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12d2:	c9                   	leave  
    12d3:	c3                   	ret    

000012d4 <atoi>:

int
atoi(const char *s)
{
    12d4:	55                   	push   %ebp
    12d5:	89 e5                	mov    %esp,%ebp
    12d7:	83 ec 10             	sub    $0x10,%esp
  int n, sign;

  n = 0;
    12da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while (*s == ' ') s++;
    12e1:	eb 04                	jmp    12e7 <atoi+0x13>
    12e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    12e7:	8b 45 08             	mov    0x8(%ebp),%eax
    12ea:	0f b6 00             	movzbl (%eax),%eax
    12ed:	3c 20                	cmp    $0x20,%al
    12ef:	74 f2                	je     12e3 <atoi+0xf>
  sign = (*s == '-') ? -1 : 1;
    12f1:	8b 45 08             	mov    0x8(%ebp),%eax
    12f4:	0f b6 00             	movzbl (%eax),%eax
    12f7:	3c 2d                	cmp    $0x2d,%al
    12f9:	75 07                	jne    1302 <atoi+0x2e>
    12fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1300:	eb 05                	jmp    1307 <atoi+0x33>
    1302:	b8 01 00 00 00       	mov    $0x1,%eax
    1307:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if (*s == '+'  || *s == '-')
    130a:	8b 45 08             	mov    0x8(%ebp),%eax
    130d:	0f b6 00             	movzbl (%eax),%eax
    1310:	3c 2b                	cmp    $0x2b,%al
    1312:	74 0a                	je     131e <atoi+0x4a>
    1314:	8b 45 08             	mov    0x8(%ebp),%eax
    1317:	0f b6 00             	movzbl (%eax),%eax
    131a:	3c 2d                	cmp    $0x2d,%al
    131c:	75 2b                	jne    1349 <atoi+0x75>
    s++;
    131e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while('0' <= *s && *s <= '9')
    1322:	eb 25                	jmp    1349 <atoi+0x75>
    n = n*10 + *s++ - '0';
    1324:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1327:	89 d0                	mov    %edx,%eax
    1329:	c1 e0 02             	shl    $0x2,%eax
    132c:	01 d0                	add    %edx,%eax
    132e:	01 c0                	add    %eax,%eax
    1330:	89 c1                	mov    %eax,%ecx
    1332:	8b 45 08             	mov    0x8(%ebp),%eax
    1335:	8d 50 01             	lea    0x1(%eax),%edx
    1338:	89 55 08             	mov    %edx,0x8(%ebp)
    133b:	0f b6 00             	movzbl (%eax),%eax
    133e:	0f be c0             	movsbl %al,%eax
    1341:	01 c8                	add    %ecx,%eax
    1343:	83 e8 30             	sub    $0x30,%eax
    1346:	89 45 fc             	mov    %eax,-0x4(%ebp)
  n = 0;
  while (*s == ' ') s++;
  sign = (*s == '-') ? -1 : 1;
  if (*s == '+'  || *s == '-')
    s++;
  while('0' <= *s && *s <= '9')
    1349:	8b 45 08             	mov    0x8(%ebp),%eax
    134c:	0f b6 00             	movzbl (%eax),%eax
    134f:	3c 2f                	cmp    $0x2f,%al
    1351:	7e 0a                	jle    135d <atoi+0x89>
    1353:	8b 45 08             	mov    0x8(%ebp),%eax
    1356:	0f b6 00             	movzbl (%eax),%eax
    1359:	3c 39                	cmp    $0x39,%al
    135b:	7e c7                	jle    1324 <atoi+0x50>
    n = n*10 + *s++ - '0';
  return sign*n;
    135d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1360:	0f af 45 fc          	imul   -0x4(%ebp),%eax
}
    1364:	c9                   	leave  
    1365:	c3                   	ret    

00001366 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1366:	55                   	push   %ebp
    1367:	89 e5                	mov    %esp,%ebp
    1369:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
    136c:	8b 45 08             	mov    0x8(%ebp),%eax
    136f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1372:	8b 45 0c             	mov    0xc(%ebp),%eax
    1375:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1378:	eb 17                	jmp    1391 <memmove+0x2b>
    *dst++ = *src++;
    137a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    137d:	8d 50 01             	lea    0x1(%eax),%edx
    1380:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1383:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1386:	8d 4a 01             	lea    0x1(%edx),%ecx
    1389:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    138c:	0f b6 12             	movzbl (%edx),%edx
    138f:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1391:	8b 45 10             	mov    0x10(%ebp),%eax
    1394:	8d 50 ff             	lea    -0x1(%eax),%edx
    1397:	89 55 10             	mov    %edx,0x10(%ebp)
    139a:	85 c0                	test   %eax,%eax
    139c:	7f dc                	jg     137a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    139e:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13a1:	c9                   	leave  
    13a2:	c3                   	ret    

000013a3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    13a3:	b8 01 00 00 00       	mov    $0x1,%eax
    13a8:	cd 40                	int    $0x40
    13aa:	c3                   	ret    

000013ab <exit>:
SYSCALL(exit)
    13ab:	b8 02 00 00 00       	mov    $0x2,%eax
    13b0:	cd 40                	int    $0x40
    13b2:	c3                   	ret    

000013b3 <wait>:
SYSCALL(wait)
    13b3:	b8 03 00 00 00       	mov    $0x3,%eax
    13b8:	cd 40                	int    $0x40
    13ba:	c3                   	ret    

000013bb <pipe>:
SYSCALL(pipe)
    13bb:	b8 04 00 00 00       	mov    $0x4,%eax
    13c0:	cd 40                	int    $0x40
    13c2:	c3                   	ret    

000013c3 <read>:
SYSCALL(read)
    13c3:	b8 05 00 00 00       	mov    $0x5,%eax
    13c8:	cd 40                	int    $0x40
    13ca:	c3                   	ret    

000013cb <write>:
SYSCALL(write)
    13cb:	b8 10 00 00 00       	mov    $0x10,%eax
    13d0:	cd 40                	int    $0x40
    13d2:	c3                   	ret    

000013d3 <close>:
SYSCALL(close)
    13d3:	b8 15 00 00 00       	mov    $0x15,%eax
    13d8:	cd 40                	int    $0x40
    13da:	c3                   	ret    

000013db <kill>:
SYSCALL(kill)
    13db:	b8 06 00 00 00       	mov    $0x6,%eax
    13e0:	cd 40                	int    $0x40
    13e2:	c3                   	ret    

000013e3 <exec>:
SYSCALL(exec)
    13e3:	b8 07 00 00 00       	mov    $0x7,%eax
    13e8:	cd 40                	int    $0x40
    13ea:	c3                   	ret    

000013eb <open>:
SYSCALL(open)
    13eb:	b8 0f 00 00 00       	mov    $0xf,%eax
    13f0:	cd 40                	int    $0x40
    13f2:	c3                   	ret    

000013f3 <mknod>:
SYSCALL(mknod)
    13f3:	b8 11 00 00 00       	mov    $0x11,%eax
    13f8:	cd 40                	int    $0x40
    13fa:	c3                   	ret    

000013fb <unlink>:
SYSCALL(unlink)
    13fb:	b8 12 00 00 00       	mov    $0x12,%eax
    1400:	cd 40                	int    $0x40
    1402:	c3                   	ret    

00001403 <fstat>:
SYSCALL(fstat)
    1403:	b8 08 00 00 00       	mov    $0x8,%eax
    1408:	cd 40                	int    $0x40
    140a:	c3                   	ret    

0000140b <link>:
SYSCALL(link)
    140b:	b8 13 00 00 00       	mov    $0x13,%eax
    1410:	cd 40                	int    $0x40
    1412:	c3                   	ret    

00001413 <mkdir>:
SYSCALL(mkdir)
    1413:	b8 14 00 00 00       	mov    $0x14,%eax
    1418:	cd 40                	int    $0x40
    141a:	c3                   	ret    

0000141b <chdir>:
SYSCALL(chdir)
    141b:	b8 09 00 00 00       	mov    $0x9,%eax
    1420:	cd 40                	int    $0x40
    1422:	c3                   	ret    

00001423 <dup>:
SYSCALL(dup)
    1423:	b8 0a 00 00 00       	mov    $0xa,%eax
    1428:	cd 40                	int    $0x40
    142a:	c3                   	ret    

0000142b <getpid>:
SYSCALL(getpid)
    142b:	b8 0b 00 00 00       	mov    $0xb,%eax
    1430:	cd 40                	int    $0x40
    1432:	c3                   	ret    

00001433 <sbrk>:
SYSCALL(sbrk)
    1433:	b8 0c 00 00 00       	mov    $0xc,%eax
    1438:	cd 40                	int    $0x40
    143a:	c3                   	ret    

0000143b <sleep>:
SYSCALL(sleep)
    143b:	b8 0d 00 00 00       	mov    $0xd,%eax
    1440:	cd 40                	int    $0x40
    1442:	c3                   	ret    

00001443 <uptime>:
SYSCALL(uptime)
    1443:	b8 0e 00 00 00       	mov    $0xe,%eax
    1448:	cd 40                	int    $0x40
    144a:	c3                   	ret    

0000144b <halt>:
SYSCALL(halt)
    144b:	b8 16 00 00 00       	mov    $0x16,%eax
    1450:	cd 40                	int    $0x40
    1452:	c3                   	ret    

00001453 <date>:
SYSCALL(date)
    1453:	b8 17 00 00 00       	mov    $0x17,%eax
    1458:	cd 40                	int    $0x40
    145a:	c3                   	ret    

0000145b <getuid>:
SYSCALL(getuid)
    145b:	b8 18 00 00 00       	mov    $0x18,%eax
    1460:	cd 40                	int    $0x40
    1462:	c3                   	ret    

00001463 <getgid>:
SYSCALL(getgid)
    1463:	b8 19 00 00 00       	mov    $0x19,%eax
    1468:	cd 40                	int    $0x40
    146a:	c3                   	ret    

0000146b <getppid>:
SYSCALL(getppid)
    146b:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1470:	cd 40                	int    $0x40
    1472:	c3                   	ret    

00001473 <setuid>:
SYSCALL(setuid)
    1473:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1478:	cd 40                	int    $0x40
    147a:	c3                   	ret    

0000147b <setgid>:
SYSCALL(setgid)
    147b:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1480:	cd 40                	int    $0x40
    1482:	c3                   	ret    

00001483 <getprocs>:
SYSCALL(getprocs)
    1483:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1488:	cd 40                	int    $0x40
    148a:	c3                   	ret    

0000148b <setpriority>:
SYSCALL(setpriority)
    148b:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1490:	cd 40                	int    $0x40
    1492:	c3                   	ret    

00001493 <chmod>:
SYSCALL(chmod)
    1493:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1498:	cd 40                	int    $0x40
    149a:	c3                   	ret    

0000149b <chown>:
SYSCALL(chown)
    149b:	b8 20 00 00 00       	mov    $0x20,%eax
    14a0:	cd 40                	int    $0x40
    14a2:	c3                   	ret    

000014a3 <chgrp>:
SYSCALL(chgrp)
    14a3:	b8 21 00 00 00       	mov    $0x21,%eax
    14a8:	cd 40                	int    $0x40
    14aa:	c3                   	ret    

000014ab <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    14ab:	55                   	push   %ebp
    14ac:	89 e5                	mov    %esp,%ebp
    14ae:	83 ec 18             	sub    $0x18,%esp
    14b1:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b4:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    14b7:	83 ec 04             	sub    $0x4,%esp
    14ba:	6a 01                	push   $0x1
    14bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
    14bf:	50                   	push   %eax
    14c0:	ff 75 08             	pushl  0x8(%ebp)
    14c3:	e8 03 ff ff ff       	call   13cb <write>
    14c8:	83 c4 10             	add    $0x10,%esp
}
    14cb:	90                   	nop
    14cc:	c9                   	leave  
    14cd:	c3                   	ret    

000014ce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14ce:	55                   	push   %ebp
    14cf:	89 e5                	mov    %esp,%ebp
    14d1:	53                   	push   %ebx
    14d2:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    14d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    14dc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    14e0:	74 17                	je     14f9 <printint+0x2b>
    14e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    14e6:	79 11                	jns    14f9 <printint+0x2b>
    neg = 1;
    14e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    14ef:	8b 45 0c             	mov    0xc(%ebp),%eax
    14f2:	f7 d8                	neg    %eax
    14f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14f7:	eb 06                	jmp    14ff <printint+0x31>
  } else {
    x = xx;
    14f9:	8b 45 0c             	mov    0xc(%ebp),%eax
    14fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    14ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1506:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1509:	8d 41 01             	lea    0x1(%ecx),%eax
    150c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    150f:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1512:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1515:	ba 00 00 00 00       	mov    $0x0,%edx
    151a:	f7 f3                	div    %ebx
    151c:	89 d0                	mov    %edx,%eax
    151e:	0f b6 80 40 26 00 00 	movzbl 0x2640(%eax),%eax
    1525:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1529:	8b 5d 10             	mov    0x10(%ebp),%ebx
    152c:	8b 45 ec             	mov    -0x14(%ebp),%eax
    152f:	ba 00 00 00 00       	mov    $0x0,%edx
    1534:	f7 f3                	div    %ebx
    1536:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1539:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    153d:	75 c7                	jne    1506 <printint+0x38>
  if(neg)
    153f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1543:	74 2d                	je     1572 <printint+0xa4>
    buf[i++] = '-';
    1545:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1548:	8d 50 01             	lea    0x1(%eax),%edx
    154b:	89 55 f4             	mov    %edx,-0xc(%ebp)
    154e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1553:	eb 1d                	jmp    1572 <printint+0xa4>
    putc(fd, buf[i]);
    1555:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1558:	8b 45 f4             	mov    -0xc(%ebp),%eax
    155b:	01 d0                	add    %edx,%eax
    155d:	0f b6 00             	movzbl (%eax),%eax
    1560:	0f be c0             	movsbl %al,%eax
    1563:	83 ec 08             	sub    $0x8,%esp
    1566:	50                   	push   %eax
    1567:	ff 75 08             	pushl  0x8(%ebp)
    156a:	e8 3c ff ff ff       	call   14ab <putc>
    156f:	83 c4 10             	add    $0x10,%esp
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1572:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
    1576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    157a:	79 d9                	jns    1555 <printint+0x87>
    putc(fd, buf[i]);
}
    157c:	90                   	nop
    157d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1580:	c9                   	leave  
    1581:	c3                   	ret    

00001582 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1582:	55                   	push   %ebp
    1583:	89 e5                	mov    %esp,%ebp
    1585:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1588:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    158f:	8d 45 0c             	lea    0xc(%ebp),%eax
    1592:	83 c0 04             	add    $0x4,%eax
    1595:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1598:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    159f:	e9 59 01 00 00       	jmp    16fd <printf+0x17b>
    c = fmt[i] & 0xff;
    15a4:	8b 55 0c             	mov    0xc(%ebp),%edx
    15a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    15aa:	01 d0                	add    %edx,%eax
    15ac:	0f b6 00             	movzbl (%eax),%eax
    15af:	0f be c0             	movsbl %al,%eax
    15b2:	25 ff 00 00 00       	and    $0xff,%eax
    15b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    15ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    15be:	75 2c                	jne    15ec <printf+0x6a>
      if(c == '%'){
    15c0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    15c4:	75 0c                	jne    15d2 <printf+0x50>
        state = '%';
    15c6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    15cd:	e9 27 01 00 00       	jmp    16f9 <printf+0x177>
      } else {
        putc(fd, c);
    15d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    15d5:	0f be c0             	movsbl %al,%eax
    15d8:	83 ec 08             	sub    $0x8,%esp
    15db:	50                   	push   %eax
    15dc:	ff 75 08             	pushl  0x8(%ebp)
    15df:	e8 c7 fe ff ff       	call   14ab <putc>
    15e4:	83 c4 10             	add    $0x10,%esp
    15e7:	e9 0d 01 00 00       	jmp    16f9 <printf+0x177>
      }
    } else if(state == '%'){
    15ec:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    15f0:	0f 85 03 01 00 00    	jne    16f9 <printf+0x177>
      if(c == 'd'){
    15f6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    15fa:	75 1e                	jne    161a <printf+0x98>
        printint(fd, *ap, 10, 1);
    15fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15ff:	8b 00                	mov    (%eax),%eax
    1601:	6a 01                	push   $0x1
    1603:	6a 0a                	push   $0xa
    1605:	50                   	push   %eax
    1606:	ff 75 08             	pushl  0x8(%ebp)
    1609:	e8 c0 fe ff ff       	call   14ce <printint>
    160e:	83 c4 10             	add    $0x10,%esp
        ap++;
    1611:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1615:	e9 d8 00 00 00       	jmp    16f2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
    161a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    161e:	74 06                	je     1626 <printf+0xa4>
    1620:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1624:	75 1e                	jne    1644 <printf+0xc2>
        printint(fd, *ap, 16, 0);
    1626:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1629:	8b 00                	mov    (%eax),%eax
    162b:	6a 00                	push   $0x0
    162d:	6a 10                	push   $0x10
    162f:	50                   	push   %eax
    1630:	ff 75 08             	pushl  0x8(%ebp)
    1633:	e8 96 fe ff ff       	call   14ce <printint>
    1638:	83 c4 10             	add    $0x10,%esp
        ap++;
    163b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    163f:	e9 ae 00 00 00       	jmp    16f2 <printf+0x170>
      } else if(c == 's'){
    1644:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1648:	75 43                	jne    168d <printf+0x10b>
        s = (char*)*ap;
    164a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    164d:	8b 00                	mov    (%eax),%eax
    164f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1652:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1656:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    165a:	75 25                	jne    1681 <printf+0xff>
          s = "(null)";
    165c:	c7 45 f4 54 22 00 00 	movl   $0x2254,-0xc(%ebp)
        while(*s != 0){
    1663:	eb 1c                	jmp    1681 <printf+0xff>
          putc(fd, *s);
    1665:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1668:	0f b6 00             	movzbl (%eax),%eax
    166b:	0f be c0             	movsbl %al,%eax
    166e:	83 ec 08             	sub    $0x8,%esp
    1671:	50                   	push   %eax
    1672:	ff 75 08             	pushl  0x8(%ebp)
    1675:	e8 31 fe ff ff       	call   14ab <putc>
    167a:	83 c4 10             	add    $0x10,%esp
          s++;
    167d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1681:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1684:	0f b6 00             	movzbl (%eax),%eax
    1687:	84 c0                	test   %al,%al
    1689:	75 da                	jne    1665 <printf+0xe3>
    168b:	eb 65                	jmp    16f2 <printf+0x170>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    168d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1691:	75 1d                	jne    16b0 <printf+0x12e>
        putc(fd, *ap);
    1693:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1696:	8b 00                	mov    (%eax),%eax
    1698:	0f be c0             	movsbl %al,%eax
    169b:	83 ec 08             	sub    $0x8,%esp
    169e:	50                   	push   %eax
    169f:	ff 75 08             	pushl  0x8(%ebp)
    16a2:	e8 04 fe ff ff       	call   14ab <putc>
    16a7:	83 c4 10             	add    $0x10,%esp
        ap++;
    16aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    16ae:	eb 42                	jmp    16f2 <printf+0x170>
      } else if(c == '%'){
    16b0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16b4:	75 17                	jne    16cd <printf+0x14b>
        putc(fd, c);
    16b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16b9:	0f be c0             	movsbl %al,%eax
    16bc:	83 ec 08             	sub    $0x8,%esp
    16bf:	50                   	push   %eax
    16c0:	ff 75 08             	pushl  0x8(%ebp)
    16c3:	e8 e3 fd ff ff       	call   14ab <putc>
    16c8:	83 c4 10             	add    $0x10,%esp
    16cb:	eb 25                	jmp    16f2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    16cd:	83 ec 08             	sub    $0x8,%esp
    16d0:	6a 25                	push   $0x25
    16d2:	ff 75 08             	pushl  0x8(%ebp)
    16d5:	e8 d1 fd ff ff       	call   14ab <putc>
    16da:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
    16dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16e0:	0f be c0             	movsbl %al,%eax
    16e3:	83 ec 08             	sub    $0x8,%esp
    16e6:	50                   	push   %eax
    16e7:	ff 75 08             	pushl  0x8(%ebp)
    16ea:	e8 bc fd ff ff       	call   14ab <putc>
    16ef:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    16f2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16f9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    16fd:	8b 55 0c             	mov    0xc(%ebp),%edx
    1700:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1703:	01 d0                	add    %edx,%eax
    1705:	0f b6 00             	movzbl (%eax),%eax
    1708:	84 c0                	test   %al,%al
    170a:	0f 85 94 fe ff ff    	jne    15a4 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1710:	90                   	nop
    1711:	c9                   	leave  
    1712:	c3                   	ret    

00001713 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1713:	55                   	push   %ebp
    1714:	89 e5                	mov    %esp,%ebp
    1716:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1719:	8b 45 08             	mov    0x8(%ebp),%eax
    171c:	83 e8 08             	sub    $0x8,%eax
    171f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1722:	a1 5c 26 00 00       	mov    0x265c,%eax
    1727:	89 45 fc             	mov    %eax,-0x4(%ebp)
    172a:	eb 24                	jmp    1750 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172f:	8b 00                	mov    (%eax),%eax
    1731:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1734:	77 12                	ja     1748 <free+0x35>
    1736:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1739:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    173c:	77 24                	ja     1762 <free+0x4f>
    173e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1741:	8b 00                	mov    (%eax),%eax
    1743:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1746:	77 1a                	ja     1762 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1748:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174b:	8b 00                	mov    (%eax),%eax
    174d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1750:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1753:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1756:	76 d4                	jbe    172c <free+0x19>
    1758:	8b 45 fc             	mov    -0x4(%ebp),%eax
    175b:	8b 00                	mov    (%eax),%eax
    175d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1760:	76 ca                	jbe    172c <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1762:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1765:	8b 40 04             	mov    0x4(%eax),%eax
    1768:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    176f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1772:	01 c2                	add    %eax,%edx
    1774:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1777:	8b 00                	mov    (%eax),%eax
    1779:	39 c2                	cmp    %eax,%edx
    177b:	75 24                	jne    17a1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1780:	8b 50 04             	mov    0x4(%eax),%edx
    1783:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1786:	8b 00                	mov    (%eax),%eax
    1788:	8b 40 04             	mov    0x4(%eax),%eax
    178b:	01 c2                	add    %eax,%edx
    178d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1790:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1793:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1796:	8b 00                	mov    (%eax),%eax
    1798:	8b 10                	mov    (%eax),%edx
    179a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    179d:	89 10                	mov    %edx,(%eax)
    179f:	eb 0a                	jmp    17ab <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    17a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17a4:	8b 10                	mov    (%eax),%edx
    17a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17a9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    17ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ae:	8b 40 04             	mov    0x4(%eax),%eax
    17b1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    17b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17bb:	01 d0                	add    %edx,%eax
    17bd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    17c0:	75 20                	jne    17e2 <free+0xcf>
    p->s.size += bp->s.size;
    17c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17c5:	8b 50 04             	mov    0x4(%eax),%edx
    17c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17cb:	8b 40 04             	mov    0x4(%eax),%eax
    17ce:	01 c2                	add    %eax,%edx
    17d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17d3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    17d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    17d9:	8b 10                	mov    (%eax),%edx
    17db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17de:	89 10                	mov    %edx,(%eax)
    17e0:	eb 08                	jmp    17ea <free+0xd7>
  } else
    p->s.ptr = bp;
    17e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17e5:	8b 55 f8             	mov    -0x8(%ebp),%edx
    17e8:	89 10                	mov    %edx,(%eax)
  freep = p;
    17ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
    17ed:	a3 5c 26 00 00       	mov    %eax,0x265c
}
    17f2:	90                   	nop
    17f3:	c9                   	leave  
    17f4:	c3                   	ret    

000017f5 <morecore>:

static Header*
morecore(uint nu)
{
    17f5:	55                   	push   %ebp
    17f6:	89 e5                	mov    %esp,%ebp
    17f8:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17fb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1802:	77 07                	ja     180b <morecore+0x16>
    nu = 4096;
    1804:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    180b:	8b 45 08             	mov    0x8(%ebp),%eax
    180e:	c1 e0 03             	shl    $0x3,%eax
    1811:	83 ec 0c             	sub    $0xc,%esp
    1814:	50                   	push   %eax
    1815:	e8 19 fc ff ff       	call   1433 <sbrk>
    181a:	83 c4 10             	add    $0x10,%esp
    181d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1820:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1824:	75 07                	jne    182d <morecore+0x38>
    return 0;
    1826:	b8 00 00 00 00       	mov    $0x0,%eax
    182b:	eb 26                	jmp    1853 <morecore+0x5e>
  hp = (Header*)p;
    182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1830:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1833:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1836:	8b 55 08             	mov    0x8(%ebp),%edx
    1839:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    183c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    183f:	83 c0 08             	add    $0x8,%eax
    1842:	83 ec 0c             	sub    $0xc,%esp
    1845:	50                   	push   %eax
    1846:	e8 c8 fe ff ff       	call   1713 <free>
    184b:	83 c4 10             	add    $0x10,%esp
  return freep;
    184e:	a1 5c 26 00 00       	mov    0x265c,%eax
}
    1853:	c9                   	leave  
    1854:	c3                   	ret    

00001855 <malloc>:

void*
malloc(uint nbytes)
{
    1855:	55                   	push   %ebp
    1856:	89 e5                	mov    %esp,%ebp
    1858:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    185b:	8b 45 08             	mov    0x8(%ebp),%eax
    185e:	83 c0 07             	add    $0x7,%eax
    1861:	c1 e8 03             	shr    $0x3,%eax
    1864:	83 c0 01             	add    $0x1,%eax
    1867:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    186a:	a1 5c 26 00 00       	mov    0x265c,%eax
    186f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1872:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1876:	75 23                	jne    189b <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1878:	c7 45 f0 54 26 00 00 	movl   $0x2654,-0x10(%ebp)
    187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1882:	a3 5c 26 00 00       	mov    %eax,0x265c
    1887:	a1 5c 26 00 00       	mov    0x265c,%eax
    188c:	a3 54 26 00 00       	mov    %eax,0x2654
    base.s.size = 0;
    1891:	c7 05 58 26 00 00 00 	movl   $0x0,0x2658
    1898:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    189e:	8b 00                	mov    (%eax),%eax
    18a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    18a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a6:	8b 40 04             	mov    0x4(%eax),%eax
    18a9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18ac:	72 4d                	jb     18fb <malloc+0xa6>
      if(p->s.size == nunits)
    18ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18b1:	8b 40 04             	mov    0x4(%eax),%eax
    18b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    18b7:	75 0c                	jne    18c5 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    18b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18bc:	8b 10                	mov    (%eax),%edx
    18be:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18c1:	89 10                	mov    %edx,(%eax)
    18c3:	eb 26                	jmp    18eb <malloc+0x96>
      else {
        p->s.size -= nunits;
    18c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c8:	8b 40 04             	mov    0x4(%eax),%eax
    18cb:	2b 45 ec             	sub    -0x14(%ebp),%eax
    18ce:	89 c2                	mov    %eax,%edx
    18d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d3:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    18d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18d9:	8b 40 04             	mov    0x4(%eax),%eax
    18dc:	c1 e0 03             	shl    $0x3,%eax
    18df:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    18e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18e5:	8b 55 ec             	mov    -0x14(%ebp),%edx
    18e8:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    18eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18ee:	a3 5c 26 00 00       	mov    %eax,0x265c
      return (void*)(p + 1);
    18f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18f6:	83 c0 08             	add    $0x8,%eax
    18f9:	eb 3b                	jmp    1936 <malloc+0xe1>
    }
    if(p == freep)
    18fb:	a1 5c 26 00 00       	mov    0x265c,%eax
    1900:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1903:	75 1e                	jne    1923 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
    1905:	83 ec 0c             	sub    $0xc,%esp
    1908:	ff 75 ec             	pushl  -0x14(%ebp)
    190b:	e8 e5 fe ff ff       	call   17f5 <morecore>
    1910:	83 c4 10             	add    $0x10,%esp
    1913:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1916:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    191a:	75 07                	jne    1923 <malloc+0xce>
        return 0;
    191c:	b8 00 00 00 00       	mov    $0x0,%eax
    1921:	eb 13                	jmp    1936 <malloc+0xe1>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1923:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1926:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1929:	8b 45 f4             	mov    -0xc(%ebp),%eax
    192c:	8b 00                	mov    (%eax),%eax
    192e:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1931:	e9 6d ff ff ff       	jmp    18a3 <malloc+0x4e>
}
    1936:	c9                   	leave  
    1937:	c3                   	ret    
