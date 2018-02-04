
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 c0 10 00       	mov    $0x10c000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 90 e6 10 80       	mov    $0x8010e690,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 c4 3d 10 80       	mov    $0x80103dc4,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 bc a0 10 80       	push   $0x8010a0bc
80100042:	68 a0 e6 10 80       	push   $0x8010e6a0
80100047:	e8 16 68 00 00       	call   80106862 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 b0 25 11 80 a4 	movl   $0x801125a4,0x801125b0
80100056:	25 11 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 b4 25 11 80 a4 	movl   $0x801125a4,0x801125b4
80100060:	25 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 d4 e6 10 80 	movl   $0x8010e6d4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 b4 25 11 80       	mov    %eax,0x801125b4
  initlock(&bcache.lock, "bcache");

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 a4 25 11 80       	mov    $0x801125a4,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000b0:	90                   	nop
801000b1:	c9                   	leave  
801000b2:	c3                   	ret    

801000b3 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b3:	55                   	push   %ebp
801000b4:	89 e5                	mov    %esp,%ebp
801000b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b9:	83 ec 0c             	sub    $0xc,%esp
801000bc:	68 a0 e6 10 80       	push   $0x8010e6a0
801000c1:	e8 be 67 00 00       	call   80106884 <acquire>
801000c6:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c9:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801000ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d1:	eb 67                	jmp    8010013a <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d6:	8b 40 04             	mov    0x4(%eax),%eax
801000d9:	3b 45 08             	cmp    0x8(%ebp),%eax
801000dc:	75 53                	jne    80100131 <bget+0x7e>
801000de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e1:	8b 40 08             	mov    0x8(%eax),%eax
801000e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e7:	75 48                	jne    80100131 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ec:	8b 00                	mov    (%eax),%eax
801000ee:	83 e0 01             	and    $0x1,%eax
801000f1:	85 c0                	test   %eax,%eax
801000f3:	75 27                	jne    8010011c <bget+0x69>
        b->flags |= B_BUSY;
801000f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f8:	8b 00                	mov    (%eax),%eax
801000fa:	83 c8 01             	or     $0x1,%eax
801000fd:	89 c2                	mov    %eax,%edx
801000ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100102:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100104:	83 ec 0c             	sub    $0xc,%esp
80100107:	68 a0 e6 10 80       	push   $0x8010e6a0
8010010c:	e8 da 67 00 00       	call   801068eb <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 e6 10 80       	push   $0x8010e6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 e3 59 00 00       	call   80105b0f <sleep>
8010012c:	83 c4 10             	add    $0x10,%esp
      goto loop;
8010012f:	eb 98                	jmp    801000c9 <bget+0x16>

  acquire(&bcache.lock);

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100131:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100134:	8b 40 10             	mov    0x10(%eax),%eax
80100137:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013a:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
80100141:	75 90                	jne    801000d3 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100143:	a1 b0 25 11 80       	mov    0x801125b0,%eax
80100148:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014b:	eb 51                	jmp    8010019e <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100150:	8b 00                	mov    (%eax),%eax
80100152:	83 e0 01             	and    $0x1,%eax
80100155:	85 c0                	test   %eax,%eax
80100157:	75 3c                	jne    80100195 <bget+0xe2>
80100159:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015c:	8b 00                	mov    (%eax),%eax
8010015e:	83 e0 04             	and    $0x4,%eax
80100161:	85 c0                	test   %eax,%eax
80100163:	75 30                	jne    80100195 <bget+0xe2>
      b->dev = dev;
80100165:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100168:	8b 55 08             	mov    0x8(%ebp),%edx
8010016b:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100180:	83 ec 0c             	sub    $0xc,%esp
80100183:	68 a0 e6 10 80       	push   $0x8010e6a0
80100188:	e8 5e 67 00 00       	call   801068eb <release>
8010018d:	83 c4 10             	add    $0x10,%esp
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1f                	jmp    801001b4 <bget+0x101>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 0c             	mov    0xc(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 a4 25 11 80 	cmpl   $0x801125a4,-0xc(%ebp)
801001a5:	75 a6                	jne    8010014d <bget+0x9a>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
801001a7:	83 ec 0c             	sub    $0xc,%esp
801001aa:	68 c3 a0 10 80       	push   $0x8010a0c3
801001af:	e8 b2 03 00 00       	call   80100566 <panic>
}
801001b4:	c9                   	leave  
801001b5:	c3                   	ret    

801001b6 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b6:	55                   	push   %ebp
801001b7:	89 e5                	mov    %esp,%ebp
801001b9:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bc:	83 ec 08             	sub    $0x8,%esp
801001bf:	ff 75 0c             	pushl  0xc(%ebp)
801001c2:	ff 75 08             	pushl  0x8(%ebp)
801001c5:	e8 e9 fe ff ff       	call   801000b3 <bget>
801001ca:	83 c4 10             	add    $0x10,%esp
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0e                	jne    801001ea <bread+0x34>
    iderw(b);
801001dc:	83 ec 0c             	sub    $0xc,%esp
801001df:	ff 75 f4             	pushl  -0xc(%ebp)
801001e2:	e8 5b 2c 00 00       	call   80102e42 <iderw>
801001e7:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ed:	c9                   	leave  
801001ee:	c3                   	ret    

801001ef <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001ef:	55                   	push   %ebp
801001f0:	89 e5                	mov    %esp,%ebp
801001f2:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f5:	8b 45 08             	mov    0x8(%ebp),%eax
801001f8:	8b 00                	mov    (%eax),%eax
801001fa:	83 e0 01             	and    $0x1,%eax
801001fd:	85 c0                	test   %eax,%eax
801001ff:	75 0d                	jne    8010020e <bwrite+0x1f>
    panic("bwrite");
80100201:	83 ec 0c             	sub    $0xc,%esp
80100204:	68 d4 a0 10 80       	push   $0x8010a0d4
80100209:	e8 58 03 00 00       	call   80100566 <panic>
  b->flags |= B_DIRTY;
8010020e:	8b 45 08             	mov    0x8(%ebp),%eax
80100211:	8b 00                	mov    (%eax),%eax
80100213:	83 c8 04             	or     $0x4,%eax
80100216:	89 c2                	mov    %eax,%edx
80100218:	8b 45 08             	mov    0x8(%ebp),%eax
8010021b:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021d:	83 ec 0c             	sub    $0xc,%esp
80100220:	ff 75 08             	pushl  0x8(%ebp)
80100223:	e8 1a 2c 00 00       	call   80102e42 <iderw>
80100228:	83 c4 10             	add    $0x10,%esp
}
8010022b:	90                   	nop
8010022c:	c9                   	leave  
8010022d:	c3                   	ret    

8010022e <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022e:	55                   	push   %ebp
8010022f:	89 e5                	mov    %esp,%ebp
80100231:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100234:	8b 45 08             	mov    0x8(%ebp),%eax
80100237:	8b 00                	mov    (%eax),%eax
80100239:	83 e0 01             	and    $0x1,%eax
8010023c:	85 c0                	test   %eax,%eax
8010023e:	75 0d                	jne    8010024d <brelse+0x1f>
    panic("brelse");
80100240:	83 ec 0c             	sub    $0xc,%esp
80100243:	68 db a0 10 80       	push   $0x8010a0db
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 e6 10 80       	push   $0x8010e6a0
80100255:	e8 2a 66 00 00       	call   80106884 <acquire>
8010025a:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025d:	8b 45 08             	mov    0x8(%ebp),%eax
80100260:	8b 40 10             	mov    0x10(%eax),%eax
80100263:	8b 55 08             	mov    0x8(%ebp),%edx
80100266:	8b 52 0c             	mov    0xc(%edx),%edx
80100269:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026c:	8b 45 08             	mov    0x8(%ebp),%eax
8010026f:	8b 40 0c             	mov    0xc(%eax),%eax
80100272:	8b 55 08             	mov    0x8(%ebp),%edx
80100275:	8b 52 10             	mov    0x10(%edx),%edx
80100278:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027b:	8b 15 b4 25 11 80    	mov    0x801125b4,%edx
80100281:	8b 45 08             	mov    0x8(%ebp),%eax
80100284:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100287:	8b 45 08             	mov    0x8(%ebp),%eax
8010028a:	c7 40 0c a4 25 11 80 	movl   $0x801125a4,0xc(%eax)
  bcache.head.next->prev = b;
80100291:	a1 b4 25 11 80       	mov    0x801125b4,%eax
80100296:	8b 55 08             	mov    0x8(%ebp),%edx
80100299:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029c:	8b 45 08             	mov    0x8(%ebp),%eax
8010029f:	a3 b4 25 11 80       	mov    %eax,0x801125b4

  b->flags &= ~B_BUSY;
801002a4:	8b 45 08             	mov    0x8(%ebp),%eax
801002a7:	8b 00                	mov    (%eax),%eax
801002a9:	83 e0 fe             	and    $0xfffffffe,%eax
801002ac:	89 c2                	mov    %eax,%edx
801002ae:	8b 45 08             	mov    0x8(%ebp),%eax
801002b1:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b3:	83 ec 0c             	sub    $0xc,%esp
801002b6:	ff 75 08             	pushl  0x8(%ebp)
801002b9:	e8 18 5a 00 00       	call   80105cd6 <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 e6 10 80       	push   $0x8010e6a0
801002c9:	e8 1d 66 00 00       	call   801068eb <release>
801002ce:	83 c4 10             	add    $0x10,%esp
}
801002d1:	90                   	nop
801002d2:	c9                   	leave  
801002d3:	c3                   	ret    

801002d4 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801002d4:	55                   	push   %ebp
801002d5:	89 e5                	mov    %esp,%ebp
801002d7:	83 ec 14             	sub    $0x14,%esp
801002da:	8b 45 08             	mov    0x8(%ebp),%eax
801002dd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e5:	89 c2                	mov    %eax,%edx
801002e7:	ec                   	in     (%dx),%al
801002e8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002eb:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002ef:	c9                   	leave  
801002f0:	c3                   	ret    

801002f1 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	83 ec 08             	sub    $0x8,%esp
801002f7:	8b 55 08             	mov    0x8(%ebp),%edx
801002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801002fd:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100301:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100304:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80100308:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030c:	ee                   	out    %al,(%dx)
}
8010030d:	90                   	nop
8010030e:	c9                   	leave  
8010030f:	c3                   	ret    

80100310 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100313:	fa                   	cli    
}
80100314:	90                   	nop
80100315:	5d                   	pop    %ebp
80100316:	c3                   	ret    

80100317 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100317:	55                   	push   %ebp
80100318:	89 e5                	mov    %esp,%ebp
8010031a:	53                   	push   %ebx
8010031b:	83 ec 24             	sub    $0x24,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010031e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100322:	74 1c                	je     80100340 <printint+0x29>
80100324:	8b 45 08             	mov    0x8(%ebp),%eax
80100327:	c1 e8 1f             	shr    $0x1f,%eax
8010032a:	0f b6 c0             	movzbl %al,%eax
8010032d:	89 45 10             	mov    %eax,0x10(%ebp)
80100330:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100334:	74 0a                	je     80100340 <printint+0x29>
    x = -xx;
80100336:	8b 45 08             	mov    0x8(%ebp),%eax
80100339:	f7 d8                	neg    %eax
8010033b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010033e:	eb 06                	jmp    80100346 <printint+0x2f>
  else
    x = xx;
80100340:	8b 45 08             	mov    0x8(%ebp),%eax
80100343:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100350:	8d 41 01             	lea    0x1(%ecx),%eax
80100353:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100359:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035c:	ba 00 00 00 00       	mov    $0x0,%edx
80100361:	f7 f3                	div    %ebx
80100363:	89 d0                	mov    %edx,%eax
80100365:	0f b6 80 04 b0 10 80 	movzbl -0x7fef4ffc(%eax),%eax
8010036c:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100376:	ba 00 00 00 00       	mov    $0x0,%edx
8010037b:	f7 f3                	div    %ebx
8010037d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100380:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100384:	75 c7                	jne    8010034d <printint+0x36>

  if(sign)
80100386:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038a:	74 2a                	je     801003b6 <printint+0x9f>
    buf[i++] = '-';
8010038c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010038f:	8d 50 01             	lea    0x1(%eax),%edx
80100392:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100395:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039a:	eb 1a                	jmp    801003b6 <printint+0x9f>
    consputc(buf[i]);
8010039c:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010039f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a2:	01 d0                	add    %edx,%eax
801003a4:	0f b6 00             	movzbl (%eax),%eax
801003a7:	0f be c0             	movsbl %al,%eax
801003aa:	83 ec 0c             	sub    $0xc,%esp
801003ad:	50                   	push   %eax
801003ae:	e8 df 03 00 00       	call   80100792 <consputc>
801003b3:	83 c4 10             	add    $0x10,%esp
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801003b6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003be:	79 dc                	jns    8010039c <printint+0x85>
    consputc(buf[i]);
}
801003c0:	90                   	nop
801003c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 34 d6 10 80       	mov    0x8010d634,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 00 d6 10 80       	push   $0x8010d600
801003e2:	e8 9d 64 00 00       	call   80106884 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 e2 a0 10 80       	push   $0x8010a0e2
801003f9:	e8 68 01 00 00       	call   80100566 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 1a 01 00 00       	jmp    8010052a <cprintf+0x164>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	pushl  -0x1c(%ebp)
8010041c:	e8 71 03 00 00       	call   80100792 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 fd 00 00 00       	jmp    80100526 <cprintf+0x160>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 ff 00 00 00    	je     8010054c <cprintf+0x186>
      break;
    switch(c){
8010044d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	74 47                	je     8010049c <cprintf+0xd6>
80100455:	83 f8 70             	cmp    $0x70,%eax
80100458:	7f 13                	jg     8010046d <cprintf+0xa7>
8010045a:	83 f8 25             	cmp    $0x25,%eax
8010045d:	0f 84 98 00 00 00    	je     801004fb <cprintf+0x135>
80100463:	83 f8 64             	cmp    $0x64,%eax
80100466:	74 14                	je     8010047c <cprintf+0xb6>
80100468:	e9 9d 00 00 00       	jmp    8010050a <cprintf+0x144>
8010046d:	83 f8 73             	cmp    $0x73,%eax
80100470:	74 47                	je     801004b9 <cprintf+0xf3>
80100472:	83 f8 78             	cmp    $0x78,%eax
80100475:	74 25                	je     8010049c <cprintf+0xd6>
80100477:	e9 8e 00 00 00       	jmp    8010050a <cprintf+0x144>
    case 'd':
      printint(*argp++, 10, 1);
8010047c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047f:	8d 50 04             	lea    0x4(%eax),%edx
80100482:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100485:	8b 00                	mov    (%eax),%eax
80100487:	83 ec 04             	sub    $0x4,%esp
8010048a:	6a 01                	push   $0x1
8010048c:	6a 0a                	push   $0xa
8010048e:	50                   	push   %eax
8010048f:	e8 83 fe ff ff       	call   80100317 <printint>
80100494:	83 c4 10             	add    $0x10,%esp
      break;
80100497:	e9 8a 00 00 00       	jmp    80100526 <cprintf+0x160>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	83 ec 04             	sub    $0x4,%esp
801004aa:	6a 00                	push   $0x0
801004ac:	6a 10                	push   $0x10
801004ae:	50                   	push   %eax
801004af:	e8 63 fe ff ff       	call   80100317 <printint>
801004b4:	83 c4 10             	add    $0x10,%esp
      break;
801004b7:	eb 6d                	jmp    80100526 <cprintf+0x160>
    case 's':
      if((s = (char*)*argp++) == 0)
801004b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004bc:	8d 50 04             	lea    0x4(%eax),%edx
801004bf:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004c2:	8b 00                	mov    (%eax),%eax
801004c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004cb:	75 22                	jne    801004ef <cprintf+0x129>
        s = "(null)";
801004cd:	c7 45 ec eb a0 10 80 	movl   $0x8010a0eb,-0x14(%ebp)
      for(; *s; s++)
801004d4:	eb 19                	jmp    801004ef <cprintf+0x129>
        consputc(*s);
801004d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d9:	0f b6 00             	movzbl (%eax),%eax
801004dc:	0f be c0             	movsbl %al,%eax
801004df:	83 ec 0c             	sub    $0xc,%esp
801004e2:	50                   	push   %eax
801004e3:	e8 aa 02 00 00       	call   80100792 <consputc>
801004e8:	83 c4 10             	add    $0x10,%esp
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004eb:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004f2:	0f b6 00             	movzbl (%eax),%eax
801004f5:	84 c0                	test   %al,%al
801004f7:	75 dd                	jne    801004d6 <cprintf+0x110>
        consputc(*s);
      break;
801004f9:	eb 2b                	jmp    80100526 <cprintf+0x160>
    case '%':
      consputc('%');
801004fb:	83 ec 0c             	sub    $0xc,%esp
801004fe:	6a 25                	push   $0x25
80100500:	e8 8d 02 00 00       	call   80100792 <consputc>
80100505:	83 c4 10             	add    $0x10,%esp
      break;
80100508:	eb 1c                	jmp    80100526 <cprintf+0x160>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010050a:	83 ec 0c             	sub    $0xc,%esp
8010050d:	6a 25                	push   $0x25
8010050f:	e8 7e 02 00 00       	call   80100792 <consputc>
80100514:	83 c4 10             	add    $0x10,%esp
      consputc(c);
80100517:	83 ec 0c             	sub    $0xc,%esp
8010051a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010051d:	e8 70 02 00 00       	call   80100792 <consputc>
80100522:	83 c4 10             	add    $0x10,%esp
      break;
80100525:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100526:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052a:	8b 55 08             	mov    0x8(%ebp),%edx
8010052d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100530:	01 d0                	add    %edx,%eax
80100532:	0f b6 00             	movzbl (%eax),%eax
80100535:	0f be c0             	movsbl %al,%eax
80100538:	25 ff 00 00 00       	and    $0xff,%eax
8010053d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100540:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100544:	0f 85 c6 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010054a:	eb 01                	jmp    8010054d <cprintf+0x187>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
8010054c:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
8010054d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100551:	74 10                	je     80100563 <cprintf+0x19d>
    release(&cons.lock);
80100553:	83 ec 0c             	sub    $0xc,%esp
80100556:	68 00 d6 10 80       	push   $0x8010d600
8010055b:	e8 8b 63 00 00       	call   801068eb <release>
80100560:	83 c4 10             	add    $0x10,%esp
}
80100563:	90                   	nop
80100564:	c9                   	leave  
80100565:	c3                   	ret    

80100566 <panic>:

void
panic(char *s)
{
80100566:	55                   	push   %ebp
80100567:	89 e5                	mov    %esp,%ebp
80100569:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
8010056c:	e8 9f fd ff ff       	call   80100310 <cli>
  cons.locking = 0;
80100571:	c7 05 34 d6 10 80 00 	movl   $0x0,0x8010d634
80100578:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010057b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100581:	0f b6 00             	movzbl (%eax),%eax
80100584:	0f b6 c0             	movzbl %al,%eax
80100587:	83 ec 08             	sub    $0x8,%esp
8010058a:	50                   	push   %eax
8010058b:	68 f2 a0 10 80       	push   $0x8010a0f2
80100590:	e8 31 fe ff ff       	call   801003c6 <cprintf>
80100595:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
80100598:	8b 45 08             	mov    0x8(%ebp),%eax
8010059b:	83 ec 0c             	sub    $0xc,%esp
8010059e:	50                   	push   %eax
8010059f:	e8 22 fe ff ff       	call   801003c6 <cprintf>
801005a4:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005a7:	83 ec 0c             	sub    $0xc,%esp
801005aa:	68 01 a1 10 80       	push   $0x8010a101
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 76 63 00 00       	call   8010693d <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 03 a1 10 80       	push   $0x8010a103
801005e3:	e8 de fd ff ff       	call   801003c6 <cprintf>
801005e8:	83 c4 10             	add    $0x10,%esp
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005eb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005ef:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005f3:	7e de                	jle    801005d3 <panic+0x6d>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005f5:	c7 05 e0 d5 10 80 01 	movl   $0x1,0x8010d5e0
801005fc:	00 00 00 
  for(;;)
    ;
801005ff:	eb fe                	jmp    801005ff <panic+0x99>

80100601 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100601:	55                   	push   %ebp
80100602:	89 e5                	mov    %esp,%ebp
80100604:	83 ec 18             	sub    $0x18,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
80100607:	6a 0e                	push   $0xe
80100609:	68 d4 03 00 00       	push   $0x3d4
8010060e:	e8 de fc ff ff       	call   801002f1 <outb>
80100613:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
80100616:	68 d5 03 00 00       	push   $0x3d5
8010061b:	e8 b4 fc ff ff       	call   801002d4 <inb>
80100620:	83 c4 04             	add    $0x4,%esp
80100623:	0f b6 c0             	movzbl %al,%eax
80100626:	c1 e0 08             	shl    $0x8,%eax
80100629:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010062c:	6a 0f                	push   $0xf
8010062e:	68 d4 03 00 00       	push   $0x3d4
80100633:	e8 b9 fc ff ff       	call   801002f1 <outb>
80100638:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
8010063b:	68 d5 03 00 00       	push   $0x3d5
80100640:	e8 8f fc ff ff       	call   801002d4 <inb>
80100645:	83 c4 04             	add    $0x4,%esp
80100648:	0f b6 c0             	movzbl %al,%eax
8010064b:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010064e:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100652:	75 30                	jne    80100684 <cgaputc+0x83>
    pos += 80 - pos%80;
80100654:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100657:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010065c:	89 c8                	mov    %ecx,%eax
8010065e:	f7 ea                	imul   %edx
80100660:	c1 fa 05             	sar    $0x5,%edx
80100663:	89 c8                	mov    %ecx,%eax
80100665:	c1 f8 1f             	sar    $0x1f,%eax
80100668:	29 c2                	sub    %eax,%edx
8010066a:	89 d0                	mov    %edx,%eax
8010066c:	c1 e0 02             	shl    $0x2,%eax
8010066f:	01 d0                	add    %edx,%eax
80100671:	c1 e0 04             	shl    $0x4,%eax
80100674:	29 c1                	sub    %eax,%ecx
80100676:	89 ca                	mov    %ecx,%edx
80100678:	b8 50 00 00 00       	mov    $0x50,%eax
8010067d:	29 d0                	sub    %edx,%eax
8010067f:	01 45 f4             	add    %eax,-0xc(%ebp)
80100682:	eb 34                	jmp    801006b8 <cgaputc+0xb7>
  else if(c == BACKSPACE){
80100684:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010068b:	75 0c                	jne    80100699 <cgaputc+0x98>
    if(pos > 0) --pos;
8010068d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100691:	7e 25                	jle    801006b8 <cgaputc+0xb7>
80100693:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100697:	eb 1f                	jmp    801006b8 <cgaputc+0xb7>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100699:	8b 0d 00 b0 10 80    	mov    0x8010b000,%ecx
8010069f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006a2:	8d 50 01             	lea    0x1(%eax),%edx
801006a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006a8:	01 c0                	add    %eax,%eax
801006aa:	01 c8                	add    %ecx,%eax
801006ac:	8b 55 08             	mov    0x8(%ebp),%edx
801006af:	0f b6 d2             	movzbl %dl,%edx
801006b2:	80 ce 07             	or     $0x7,%dh
801006b5:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006bc:	78 09                	js     801006c7 <cgaputc+0xc6>
801006be:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006c5:	7e 0d                	jle    801006d4 <cgaputc+0xd3>
    panic("pos under/overflow");
801006c7:	83 ec 0c             	sub    $0xc,%esp
801006ca:	68 07 a1 10 80       	push   $0x8010a107
801006cf:	e8 92 fe ff ff       	call   80100566 <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006d4:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006db:	7e 4c                	jle    80100729 <cgaputc+0x128>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006dd:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006e8:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801006ed:	83 ec 04             	sub    $0x4,%esp
801006f0:	68 60 0e 00 00       	push   $0xe60
801006f5:	52                   	push   %edx
801006f6:	50                   	push   %eax
801006f7:	e8 aa 64 00 00       	call   80106ba6 <memmove>
801006fc:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
801006ff:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100703:	b8 80 07 00 00       	mov    $0x780,%eax
80100708:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010070b:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010070e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100713:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100716:	01 c9                	add    %ecx,%ecx
80100718:	01 c8                	add    %ecx,%eax
8010071a:	83 ec 04             	sub    $0x4,%esp
8010071d:	52                   	push   %edx
8010071e:	6a 00                	push   $0x0
80100720:	50                   	push   %eax
80100721:	e8 c1 63 00 00       	call   80106ae7 <memset>
80100726:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100729:	83 ec 08             	sub    $0x8,%esp
8010072c:	6a 0e                	push   $0xe
8010072e:	68 d4 03 00 00       	push   $0x3d4
80100733:	e8 b9 fb ff ff       	call   801002f1 <outb>
80100738:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010073b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010073e:	c1 f8 08             	sar    $0x8,%eax
80100741:	0f b6 c0             	movzbl %al,%eax
80100744:	83 ec 08             	sub    $0x8,%esp
80100747:	50                   	push   %eax
80100748:	68 d5 03 00 00       	push   $0x3d5
8010074d:	e8 9f fb ff ff       	call   801002f1 <outb>
80100752:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100755:	83 ec 08             	sub    $0x8,%esp
80100758:	6a 0f                	push   $0xf
8010075a:	68 d4 03 00 00       	push   $0x3d4
8010075f:	e8 8d fb ff ff       	call   801002f1 <outb>
80100764:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010076a:	0f b6 c0             	movzbl %al,%eax
8010076d:	83 ec 08             	sub    $0x8,%esp
80100770:	50                   	push   %eax
80100771:	68 d5 03 00 00       	push   $0x3d5
80100776:	e8 76 fb ff ff       	call   801002f1 <outb>
8010077b:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010077e:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80100783:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100786:	01 d2                	add    %edx,%edx
80100788:	01 d0                	add    %edx,%eax
8010078a:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078f:	90                   	nop
80100790:	c9                   	leave  
80100791:	c3                   	ret    

80100792 <consputc>:

void
consputc(int c)
{
80100792:	55                   	push   %ebp
80100793:	89 e5                	mov    %esp,%ebp
80100795:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
80100798:	a1 e0 d5 10 80       	mov    0x8010d5e0,%eax
8010079d:	85 c0                	test   %eax,%eax
8010079f:	74 07                	je     801007a8 <consputc+0x16>
    cli();
801007a1:	e8 6a fb ff ff       	call   80100310 <cli>
    for(;;)
      ;
801007a6:	eb fe                	jmp    801007a6 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a8:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007af:	75 29                	jne    801007da <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007b1:	83 ec 0c             	sub    $0xc,%esp
801007b4:	6a 08                	push   $0x8
801007b6:	e8 89 7f 00 00       	call   80108744 <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 7c 7f 00 00       	call   80108744 <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 6f 7f 00 00       	call   80108744 <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 5f 7f 00 00       	call   80108744 <uartputc>
801007e5:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	ff 75 08             	pushl  0x8(%ebp)
801007ee:	e8 0e fe ff ff       	call   80100601 <cgaputc>
801007f3:	83 c4 10             	add    $0x10,%esp
}
801007f6:	90                   	nop
801007f7:	c9                   	leave  
801007f8:	c3                   	ret    

801007f9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f9:	55                   	push   %ebp
801007fa:	89 e5                	mov    %esp,%ebp
801007fc:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  #ifdef CS333_P3P4
  int doprintready = 0;
80100806:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  int doprintfree = 0;
8010080d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int doprintsleep = 0;
80100814:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  int doprintzombie = 0;
8010081b:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  #endif

  acquire(&cons.lock);
80100822:	83 ec 0c             	sub    $0xc,%esp
80100825:	68 00 d6 10 80       	push   $0x8010d600
8010082a:	e8 55 60 00 00       	call   80106884 <acquire>
8010082f:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100832:	e9 a6 01 00 00       	jmp    801009dd <consoleintr+0x1e4>
    switch(c){
80100837:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010083a:	83 f8 12             	cmp    $0x12,%eax
8010083d:	0f 84 d8 00 00 00    	je     8010091b <consoleintr+0x122>
80100843:	83 f8 12             	cmp    $0x12,%eax
80100846:	7f 1c                	jg     80100864 <consoleintr+0x6b>
80100848:	83 f8 08             	cmp    $0x8,%eax
8010084b:	0f 84 95 00 00 00    	je     801008e6 <consoleintr+0xed>
80100851:	83 f8 10             	cmp    $0x10,%eax
80100854:	74 39                	je     8010088f <consoleintr+0x96>
80100856:	83 f8 06             	cmp    $0x6,%eax
80100859:	0f 84 c8 00 00 00    	je     80100927 <consoleintr+0x12e>
8010085f:	e9 e7 00 00 00       	jmp    8010094b <consoleintr+0x152>
80100864:	83 f8 15             	cmp    $0x15,%eax
80100867:	74 4f                	je     801008b8 <consoleintr+0xbf>
80100869:	83 f8 15             	cmp    $0x15,%eax
8010086c:	7f 0e                	jg     8010087c <consoleintr+0x83>
8010086e:	83 f8 13             	cmp    $0x13,%eax
80100871:	0f 84 bc 00 00 00    	je     80100933 <consoleintr+0x13a>
80100877:	e9 cf 00 00 00       	jmp    8010094b <consoleintr+0x152>
8010087c:	83 f8 1a             	cmp    $0x1a,%eax
8010087f:	0f 84 ba 00 00 00    	je     8010093f <consoleintr+0x146>
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	74 5c                	je     801008e6 <consoleintr+0xed>
8010088a:	e9 bc 00 00 00       	jmp    8010094b <consoleintr+0x152>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
8010088f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100896:	e9 42 01 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010089b:	a1 48 28 11 80       	mov    0x80112848,%eax
801008a0:	83 e8 01             	sub    $0x1,%eax
801008a3:	a3 48 28 11 80       	mov    %eax,0x80112848
        consputc(BACKSPACE);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	68 00 01 00 00       	push   $0x100
801008b0:	e8 dd fe ff ff       	call   80100792 <consputc>
801008b5:	83 c4 10             	add    $0x10,%esp
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008b8:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008be:	a1 44 28 11 80       	mov    0x80112844,%eax
801008c3:	39 c2                	cmp    %eax,%edx
801008c5:	0f 84 12 01 00 00    	je     801009dd <consoleintr+0x1e4>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008cb:	a1 48 28 11 80       	mov    0x80112848,%eax
801008d0:	83 e8 01             	sub    $0x1,%eax
801008d3:	83 e0 7f             	and    $0x7f,%eax
801008d6:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008dd:	3c 0a                	cmp    $0xa,%al
801008df:	75 ba                	jne    8010089b <consoleintr+0xa2>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008e1:	e9 f7 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008e6:	8b 15 48 28 11 80    	mov    0x80112848,%edx
801008ec:	a1 44 28 11 80       	mov    0x80112844,%eax
801008f1:	39 c2                	cmp    %eax,%edx
801008f3:	0f 84 e4 00 00 00    	je     801009dd <consoleintr+0x1e4>
        input.e--;
801008f9:	a1 48 28 11 80       	mov    0x80112848,%eax
801008fe:	83 e8 01             	sub    $0x1,%eax
80100901:	a3 48 28 11 80       	mov    %eax,0x80112848
        consputc(BACKSPACE);
80100906:	83 ec 0c             	sub    $0xc,%esp
80100909:	68 00 01 00 00       	push   $0x100
8010090e:	e8 7f fe ff ff       	call   80100792 <consputc>
80100913:	83 c4 10             	add    $0x10,%esp
      }
      break;
80100916:	e9 c2 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    #ifdef CS333_P3P4
    case C('R'):
      doprintready = 1;
8010091b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      break;
80100922:	e9 b6 00 00 00       	jmp    801009dd <consoleintr+0x1e4>

    case C('F'):
      doprintfree = 1;
80100927:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
      break;
8010092e:	e9 aa 00 00 00       	jmp    801009dd <consoleintr+0x1e4>

    case C('S'):
      doprintsleep = 1;
80100933:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
      break;
8010093a:	e9 9e 00 00 00       	jmp    801009dd <consoleintr+0x1e4>

    case C('Z'):
      doprintzombie = 1;
8010093f:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
      break;
80100946:	e9 92 00 00 00       	jmp    801009dd <consoleintr+0x1e4>
    #endif
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010094b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010094f:	0f 84 87 00 00 00    	je     801009dc <consoleintr+0x1e3>
80100955:	8b 15 48 28 11 80    	mov    0x80112848,%edx
8010095b:	a1 40 28 11 80       	mov    0x80112840,%eax
80100960:	29 c2                	sub    %eax,%edx
80100962:	89 d0                	mov    %edx,%eax
80100964:	83 f8 7f             	cmp    $0x7f,%eax
80100967:	77 73                	ja     801009dc <consoleintr+0x1e3>
        c = (c == '\r') ? '\n' : c;
80100969:	83 7d e0 0d          	cmpl   $0xd,-0x20(%ebp)
8010096d:	74 05                	je     80100974 <consoleintr+0x17b>
8010096f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100972:	eb 05                	jmp    80100979 <consoleintr+0x180>
80100974:	b8 0a 00 00 00       	mov    $0xa,%eax
80100979:	89 45 e0             	mov    %eax,-0x20(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	a1 48 28 11 80       	mov    0x80112848,%eax
80100981:	8d 50 01             	lea    0x1(%eax),%edx
80100984:	89 15 48 28 11 80    	mov    %edx,0x80112848
8010098a:	83 e0 7f             	and    $0x7f,%eax
8010098d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100990:	88 90 c0 27 11 80    	mov    %dl,-0x7feed840(%eax)
        consputc(c);
80100996:	83 ec 0c             	sub    $0xc,%esp
80100999:	ff 75 e0             	pushl  -0x20(%ebp)
8010099c:	e8 f1 fd ff ff       	call   80100792 <consputc>
801009a1:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009a4:	83 7d e0 0a          	cmpl   $0xa,-0x20(%ebp)
801009a8:	74 18                	je     801009c2 <consoleintr+0x1c9>
801009aa:	83 7d e0 04          	cmpl   $0x4,-0x20(%ebp)
801009ae:	74 12                	je     801009c2 <consoleintr+0x1c9>
801009b0:	a1 48 28 11 80       	mov    0x80112848,%eax
801009b5:	8b 15 40 28 11 80    	mov    0x80112840,%edx
801009bb:	83 ea 80             	sub    $0xffffff80,%edx
801009be:	39 d0                	cmp    %edx,%eax
801009c0:	75 1a                	jne    801009dc <consoleintr+0x1e3>
          input.w = input.e;
801009c2:	a1 48 28 11 80       	mov    0x80112848,%eax
801009c7:	a3 44 28 11 80       	mov    %eax,0x80112844
          wakeup(&input.r);
801009cc:	83 ec 0c             	sub    $0xc,%esp
801009cf:	68 40 28 11 80       	push   $0x80112840
801009d4:	e8 fd 52 00 00       	call   80105cd6 <wakeup>
801009d9:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
801009dc:	90                   	nop
  int doprintsleep = 0;
  int doprintzombie = 0;
  #endif

  acquire(&cons.lock);
  while((c = getc()) >= 0){
801009dd:	8b 45 08             	mov    0x8(%ebp),%eax
801009e0:	ff d0                	call   *%eax
801009e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801009e5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801009e9:	0f 89 48 fe ff ff    	jns    80100837 <consoleintr+0x3e>
        }
      }
      break;
    }
  }
  release(&cons.lock);
801009ef:	83 ec 0c             	sub    $0xc,%esp
801009f2:	68 00 d6 10 80       	push   $0x8010d600
801009f7:	e8 ef 5e 00 00       	call   801068eb <release>
801009fc:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a03:	74 05                	je     80100a0a <consoleintr+0x211>
    procdump();  // now call procdump() wo. cons.lock held
80100a05:	e8 b5 54 00 00       	call   80105ebf <procdump>
  }

  #ifdef CS333_P3P4
  if(doprintready)
80100a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a0e:	74 05                	je     80100a15 <consoleintr+0x21c>
    printready();
80100a10:	e8 95 5b 00 00       	call   801065aa <printready>

  if(doprintfree)
80100a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a19:	74 05                	je     80100a20 <consoleintr+0x227>
    printnumfree();
80100a1b:	e8 74 5c 00 00       	call   80106694 <printnumfree>

  if(doprintsleep)
80100a20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a24:	74 05                	je     80100a2b <consoleintr+0x232>
    printsleep();
80100a26:	e8 cc 5c 00 00       	call   801066f7 <printsleep>

  if(doprintzombie)
80100a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2f:	74 05                	je     80100a36 <consoleintr+0x23d>
    printzombie();
80100a31:	e8 4a 5d 00 00       	call   80106780 <printzombie>
  #endif
}
80100a36:	90                   	nop
80100a37:	c9                   	leave  
80100a38:	c3                   	ret    

80100a39 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100a39:	55                   	push   %ebp
80100a3a:	89 e5                	mov    %esp,%ebp
80100a3c:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
80100a3f:	83 ec 0c             	sub    $0xc,%esp
80100a42:	ff 75 08             	pushl  0x8(%ebp)
80100a45:	e8 8b 12 00 00       	call   80101cd5 <iunlock>
80100a4a:	83 c4 10             	add    $0x10,%esp
  target = n;
80100a4d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a50:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100a53:	83 ec 0c             	sub    $0xc,%esp
80100a56:	68 00 d6 10 80       	push   $0x8010d600
80100a5b:	e8 24 5e 00 00       	call   80106884 <acquire>
80100a60:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
80100a63:	e9 ac 00 00 00       	jmp    80100b14 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
80100a68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100a6e:	8b 40 24             	mov    0x24(%eax),%eax
80100a71:	85 c0                	test   %eax,%eax
80100a73:	74 28                	je     80100a9d <consoleread+0x64>
        release(&cons.lock);
80100a75:	83 ec 0c             	sub    $0xc,%esp
80100a78:	68 00 d6 10 80       	push   $0x8010d600
80100a7d:	e8 69 5e 00 00       	call   801068eb <release>
80100a82:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a85:	83 ec 0c             	sub    $0xc,%esp
80100a88:	ff 75 08             	pushl  0x8(%ebp)
80100a8b:	e8 bf 10 00 00       	call   80101b4f <ilock>
80100a90:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a98:	e9 ab 00 00 00       	jmp    80100b48 <consoleread+0x10f>
      }
      sleep(&input.r, &cons.lock);
80100a9d:	83 ec 08             	sub    $0x8,%esp
80100aa0:	68 00 d6 10 80       	push   $0x8010d600
80100aa5:	68 40 28 11 80       	push   $0x80112840
80100aaa:	e8 60 50 00 00       	call   80105b0f <sleep>
80100aaf:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
80100ab2:	8b 15 40 28 11 80    	mov    0x80112840,%edx
80100ab8:	a1 44 28 11 80       	mov    0x80112844,%eax
80100abd:	39 c2                	cmp    %eax,%edx
80100abf:	74 a7                	je     80100a68 <consoleread+0x2f>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100ac1:	a1 40 28 11 80       	mov    0x80112840,%eax
80100ac6:	8d 50 01             	lea    0x1(%eax),%edx
80100ac9:	89 15 40 28 11 80    	mov    %edx,0x80112840
80100acf:	83 e0 7f             	and    $0x7f,%eax
80100ad2:	0f b6 80 c0 27 11 80 	movzbl -0x7feed840(%eax),%eax
80100ad9:	0f be c0             	movsbl %al,%eax
80100adc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100adf:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100ae3:	75 17                	jne    80100afc <consoleread+0xc3>
      if(n < target){
80100ae5:	8b 45 10             	mov    0x10(%ebp),%eax
80100ae8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100aeb:	73 2f                	jae    80100b1c <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100aed:	a1 40 28 11 80       	mov    0x80112840,%eax
80100af2:	83 e8 01             	sub    $0x1,%eax
80100af5:	a3 40 28 11 80       	mov    %eax,0x80112840
      }
      break;
80100afa:	eb 20                	jmp    80100b1c <consoleread+0xe3>
    }
    *dst++ = c;
80100afc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aff:	8d 50 01             	lea    0x1(%eax),%edx
80100b02:	89 55 0c             	mov    %edx,0xc(%ebp)
80100b05:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100b08:	88 10                	mov    %dl,(%eax)
    --n;
80100b0a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100b0e:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100b12:	74 0b                	je     80100b1f <consoleread+0xe6>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100b14:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100b18:	7f 98                	jg     80100ab2 <consoleread+0x79>
80100b1a:	eb 04                	jmp    80100b20 <consoleread+0xe7>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
80100b1c:	90                   	nop
80100b1d:	eb 01                	jmp    80100b20 <consoleread+0xe7>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100b1f:	90                   	nop
  }
  release(&cons.lock);
80100b20:	83 ec 0c             	sub    $0xc,%esp
80100b23:	68 00 d6 10 80       	push   $0x8010d600
80100b28:	e8 be 5d 00 00       	call   801068eb <release>
80100b2d:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b30:	83 ec 0c             	sub    $0xc,%esp
80100b33:	ff 75 08             	pushl  0x8(%ebp)
80100b36:	e8 14 10 00 00       	call   80101b4f <ilock>
80100b3b:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100b3e:	8b 45 10             	mov    0x10(%ebp),%eax
80100b41:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b44:	29 c2                	sub    %eax,%edx
80100b46:	89 d0                	mov    %edx,%eax
}
80100b48:	c9                   	leave  
80100b49:	c3                   	ret    

80100b4a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100b4a:	55                   	push   %ebp
80100b4b:	89 e5                	mov    %esp,%ebp
80100b4d:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff 75 08             	pushl  0x8(%ebp)
80100b56:	e8 7a 11 00 00       	call   80101cd5 <iunlock>
80100b5b:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100b5e:	83 ec 0c             	sub    $0xc,%esp
80100b61:	68 00 d6 10 80       	push   $0x8010d600
80100b66:	e8 19 5d 00 00       	call   80106884 <acquire>
80100b6b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100b75:	eb 21                	jmp    80100b98 <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b7d:	01 d0                	add    %edx,%eax
80100b7f:	0f b6 00             	movzbl (%eax),%eax
80100b82:	0f be c0             	movsbl %al,%eax
80100b85:	0f b6 c0             	movzbl %al,%eax
80100b88:	83 ec 0c             	sub    $0xc,%esp
80100b8b:	50                   	push   %eax
80100b8c:	e8 01 fc ff ff       	call   80100792 <consputc>
80100b91:	83 c4 10             	add    $0x10,%esp
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100b94:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b9b:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b9e:	7c d7                	jl     80100b77 <consolewrite+0x2d>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100ba0:	83 ec 0c             	sub    $0xc,%esp
80100ba3:	68 00 d6 10 80       	push   $0x8010d600
80100ba8:	e8 3e 5d 00 00       	call   801068eb <release>
80100bad:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100bb0:	83 ec 0c             	sub    $0xc,%esp
80100bb3:	ff 75 08             	pushl  0x8(%ebp)
80100bb6:	e8 94 0f 00 00       	call   80101b4f <ilock>
80100bbb:	83 c4 10             	add    $0x10,%esp

  return n;
80100bbe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100bc1:	c9                   	leave  
80100bc2:	c3                   	ret    

80100bc3 <consoleinit>:

void
consoleinit(void)
{
80100bc3:	55                   	push   %ebp
80100bc4:	89 e5                	mov    %esp,%ebp
80100bc6:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100bc9:	83 ec 08             	sub    $0x8,%esp
80100bcc:	68 1a a1 10 80       	push   $0x8010a11a
80100bd1:	68 00 d6 10 80       	push   $0x8010d600
80100bd6:	e8 87 5c 00 00       	call   80106862 <initlock>
80100bdb:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100bde:	c7 05 0c 32 11 80 4a 	movl   $0x80100b4a,0x8011320c
80100be5:	0b 10 80 
  devsw[CONSOLE].read = consoleread;
80100be8:	c7 05 08 32 11 80 39 	movl   $0x80100a39,0x80113208
80100bef:	0a 10 80 
  cons.locking = 1;
80100bf2:	c7 05 34 d6 10 80 01 	movl   $0x1,0x8010d634
80100bf9:	00 00 00 

  picenable(IRQ_KBD);
80100bfc:	83 ec 0c             	sub    $0xc,%esp
80100bff:	6a 01                	push   $0x1
80100c01:	e8 5a 38 00 00       	call   80104460 <picenable>
80100c06:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c09:	83 ec 08             	sub    $0x8,%esp
80100c0c:	6a 00                	push   $0x0
80100c0e:	6a 01                	push   $0x1
80100c10:	e8 fa 23 00 00       	call   8010300f <ioapicenable>
80100c15:	83 c4 10             	add    $0x10,%esp
}
80100c18:	90                   	nop
80100c19:	c9                   	leave  
80100c1a:	c3                   	ret    

80100c1b <exec>:
#include "stat.h"
#endif

int
exec(char *path, char **argv)
{
80100c1b:	55                   	push   %ebp
80100c1c:	89 e5                	mov    %esp,%ebp
80100c1e:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint iuid, isetuid;
  // use this to check the mode
  struct stat stat;
  #endif

  begin_op();
80100c24:	e8 59 2e 00 00       	call   80103a82 <begin_op>
  if((ip = namei(path)) == 0){
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	ff 75 08             	pushl  0x8(%ebp)
80100c2f:	e8 29 1b 00 00       	call   8010275d <namei>
80100c34:	83 c4 10             	add    $0x10,%esp
80100c37:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c3e:	75 0f                	jne    80100c4f <exec+0x34>
    end_op();
80100c40:	e8 c9 2e 00 00       	call   80103b0e <end_op>
    return -1;
80100c45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c4a:	e9 c5 04 00 00       	jmp    80101114 <exec+0x4f9>
  }
  ilock(ip);
80100c4f:	83 ec 0c             	sub    $0xc,%esp
80100c52:	ff 75 d8             	pushl  -0x28(%ebp)
80100c55:	e8 f5 0e 00 00       	call   80101b4f <ilock>
80100c5a:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100c5d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  #ifdef CS333_P5
  // Copy the inode data into the stat.
  stati(ip, &stat);
80100c64:	83 ec 08             	sub    $0x8,%esp
80100c67:	8d 85 c8 fe ff ff    	lea    -0x138(%ebp),%eax
80100c6d:	50                   	push   %eax
80100c6e:	ff 75 d8             	pushl  -0x28(%ebp)
80100c71:	e8 29 14 00 00       	call   8010209f <stati>
80100c76:	83 c4 10             	add    $0x10,%esp

  iuid = stat.uid;
80100c79:	0f b7 85 d6 fe ff ff 	movzwl -0x12a(%ebp),%eax
80100c80:	0f b7 c0             	movzwl %ax,%eax
80100c83:	89 45 d0             	mov    %eax,-0x30(%ebp)
  isetuid = stat.mode.flags.setuid;
80100c86:	0f b6 85 dd fe ff ff 	movzbl -0x123(%ebp),%eax
80100c8d:	d0 e8                	shr    %al
80100c8f:	83 e0 01             	and    $0x1,%eax
80100c92:	0f b6 c0             	movzbl %al,%eax
80100c95:	89 45 cc             	mov    %eax,-0x34(%ebp)

  // Check the permissions
  #ifdef CS333_P5

  // If the same user, check if we can run.
  if(proc->uid == iuid)
80100c98:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100c9e:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80100ca4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
80100ca7:	75 4d                	jne    80100cf6 <exec+0xdb>
  {
    if(stat.mode.flags.u_x == 0)
80100ca9:	0f b6 85 dc fe ff ff 	movzbl -0x124(%ebp),%eax
80100cb0:	83 e0 40             	and    $0x40,%eax
80100cb3:	84 c0                	test   %al,%al
80100cb5:	0f 85 88 00 00 00    	jne    80100d43 <exec+0x128>
    {
      if(proc->gid == stat.gid && stat.mode.flags.g_x == 0)
80100cbb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cc1:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80100cc7:	0f b7 85 d8 fe ff ff 	movzwl -0x128(%ebp),%eax
80100cce:	0f b7 c0             	movzwl %ax,%eax
80100cd1:	39 c2                	cmp    %eax,%edx
80100cd3:	75 6e                	jne    80100d43 <exec+0x128>
80100cd5:	0f b6 85 dc fe ff ff 	movzbl -0x124(%ebp),%eax
80100cdc:	83 e0 08             	and    $0x8,%eax
80100cdf:	84 c0                	test   %al,%al
80100ce1:	75 60                	jne    80100d43 <exec+0x128>
      {
        if(stat.mode.flags.o_x == 0)
80100ce3:	0f b6 85 dc fe ff ff 	movzbl -0x124(%ebp),%eax
80100cea:	83 e0 01             	and    $0x1,%eax
80100ced:	84 c0                	test   %al,%al
80100cef:	75 52                	jne    80100d43 <exec+0x128>
          goto bad;
80100cf1:	e9 ec 03 00 00       	jmp    801010e2 <exec+0x4c7>
      }
    }
  }

  // If the same group, check if we can run.
  else if(proc->gid == stat.gid)
80100cf6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100cfc:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80100d02:	0f b7 85 d8 fe ff ff 	movzwl -0x128(%ebp),%eax
80100d09:	0f b7 c0             	movzwl %ax,%eax
80100d0c:	39 c2                	cmp    %eax,%edx
80100d0e:	75 21                	jne    80100d31 <exec+0x116>
  {
    if(stat.mode.flags.g_x == 0)
80100d10:	0f b6 85 dc fe ff ff 	movzbl -0x124(%ebp),%eax
80100d17:	83 e0 08             	and    $0x8,%eax
80100d1a:	84 c0                	test   %al,%al
80100d1c:	75 25                	jne    80100d43 <exec+0x128>
    {
      if(stat.mode.flags.o_x == 0)
80100d1e:	0f b6 85 dc fe ff ff 	movzbl -0x124(%ebp),%eax
80100d25:	83 e0 01             	and    $0x1,%eax
80100d28:	84 c0                	test   %al,%al
80100d2a:	75 17                	jne    80100d43 <exec+0x128>
        goto bad;
80100d2c:	e9 b1 03 00 00       	jmp    801010e2 <exec+0x4c7>
    }
  }

  else
  {
    if(stat.mode.flags.o_x == 0)
80100d31:	0f b6 85 dc fe ff ff 	movzbl -0x124(%ebp),%eax
80100d38:	83 e0 01             	and    $0x1,%eax
80100d3b:	84 c0                	test   %al,%al
80100d3d:	0f 84 7d 03 00 00    	je     801010c0 <exec+0x4a5>
  }

  #endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100d43:	6a 34                	push   $0x34
80100d45:	6a 00                	push   $0x0
80100d47:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d4d:	50                   	push   %eax
80100d4e:	ff 75 d8             	pushl  -0x28(%ebp)
80100d51:	e8 b7 13 00 00       	call   8010210d <readi>
80100d56:	83 c4 10             	add    $0x10,%esp
80100d59:	83 f8 33             	cmp    $0x33,%eax
80100d5c:	0f 86 61 03 00 00    	jbe    801010c3 <exec+0x4a8>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100d62:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
80100d68:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100d6d:	0f 85 53 03 00 00    	jne    801010c6 <exec+0x4ab>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100d73:	e8 21 8b 00 00       	call   80109899 <setupkvm>
80100d78:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100d7b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100d7f:	0f 84 44 03 00 00    	je     801010c9 <exec+0x4ae>
    goto bad;

  // Load program into memory.
  sz = 0;
80100d85:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d8c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100d93:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
80100d99:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d9c:	e9 ab 00 00 00       	jmp    80100e4c <exec+0x231>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100da1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100da4:	6a 20                	push   $0x20
80100da6:	50                   	push   %eax
80100da7:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
80100dad:	50                   	push   %eax
80100dae:	ff 75 d8             	pushl  -0x28(%ebp)
80100db1:	e8 57 13 00 00       	call   8010210d <readi>
80100db6:	83 c4 10             	add    $0x10,%esp
80100db9:	83 f8 20             	cmp    $0x20,%eax
80100dbc:	0f 85 0a 03 00 00    	jne    801010cc <exec+0x4b1>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100dc2:	8b 85 e4 fe ff ff    	mov    -0x11c(%ebp),%eax
80100dc8:	83 f8 01             	cmp    $0x1,%eax
80100dcb:	75 71                	jne    80100e3e <exec+0x223>
      continue;
    if(ph.memsz < ph.filesz)
80100dcd:	8b 95 f8 fe ff ff    	mov    -0x108(%ebp),%edx
80100dd3:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100dd9:	39 c2                	cmp    %eax,%edx
80100ddb:	0f 82 ee 02 00 00    	jb     801010cf <exec+0x4b4>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100de1:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100de7:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100ded:	01 d0                	add    %edx,%eax
80100def:	83 ec 04             	sub    $0x4,%esp
80100df2:	50                   	push   %eax
80100df3:	ff 75 e0             	pushl  -0x20(%ebp)
80100df6:	ff 75 d4             	pushl  -0x2c(%ebp)
80100df9:	e8 42 8e 00 00       	call   80109c40 <allocuvm>
80100dfe:	83 c4 10             	add    $0x10,%esp
80100e01:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100e04:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100e08:	0f 84 c4 02 00 00    	je     801010d2 <exec+0x4b7>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100e0e:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100e14:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100e1a:	8b 8d ec fe ff ff    	mov    -0x114(%ebp),%ecx
80100e20:	83 ec 0c             	sub    $0xc,%esp
80100e23:	52                   	push   %edx
80100e24:	50                   	push   %eax
80100e25:	ff 75 d8             	pushl  -0x28(%ebp)
80100e28:	51                   	push   %ecx
80100e29:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e2c:	e8 38 8d 00 00       	call   80109b69 <loaduvm>
80100e31:	83 c4 20             	add    $0x20,%esp
80100e34:	85 c0                	test   %eax,%eax
80100e36:	0f 88 99 02 00 00    	js     801010d5 <exec+0x4ba>
80100e3c:	eb 01                	jmp    80100e3f <exec+0x224>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100e3e:	90                   	nop
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e3f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100e43:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100e46:	83 c0 20             	add    $0x20,%eax
80100e49:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100e4c:	0f b7 85 30 ff ff ff 	movzwl -0xd0(%ebp),%eax
80100e53:	0f b7 c0             	movzwl %ax,%eax
80100e56:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100e59:	0f 8f 42 ff ff ff    	jg     80100da1 <exec+0x186>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }

  iunlockput(ip);
80100e5f:	83 ec 0c             	sub    $0xc,%esp
80100e62:	ff 75 d8             	pushl  -0x28(%ebp)
80100e65:	e8 cd 0f 00 00       	call   80101e37 <iunlockput>
80100e6a:	83 c4 10             	add    $0x10,%esp
  end_op();
80100e6d:	e8 9c 2c 00 00       	call   80103b0e <end_op>
  ip = 0;
80100e72:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100e79:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e7c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100e81:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100e86:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100e89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100e8c:	05 00 20 00 00       	add    $0x2000,%eax
80100e91:	83 ec 04             	sub    $0x4,%esp
80100e94:	50                   	push   %eax
80100e95:	ff 75 e0             	pushl  -0x20(%ebp)
80100e98:	ff 75 d4             	pushl  -0x2c(%ebp)
80100e9b:	e8 a0 8d 00 00       	call   80109c40 <allocuvm>
80100ea0:	83 c4 10             	add    $0x10,%esp
80100ea3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ea6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100eaa:	0f 84 28 02 00 00    	je     801010d8 <exec+0x4bd>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100eb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100eb3:	2d 00 20 00 00       	sub    $0x2000,%eax
80100eb8:	83 ec 08             	sub    $0x8,%esp
80100ebb:	50                   	push   %eax
80100ebc:	ff 75 d4             	pushl  -0x2c(%ebp)
80100ebf:	e8 a2 8f 00 00       	call   80109e66 <clearpteu>
80100ec4:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100ec7:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100eca:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ecd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100ed4:	e9 96 00 00 00       	jmp    80100f6f <exec+0x354>
    if(argc >= MAXARG)
80100ed9:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100edd:	0f 87 f8 01 00 00    	ja     801010db <exec+0x4c0>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100ee3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ee6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100eed:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ef0:	01 d0                	add    %edx,%eax
80100ef2:	8b 00                	mov    (%eax),%eax
80100ef4:	83 ec 0c             	sub    $0xc,%esp
80100ef7:	50                   	push   %eax
80100ef8:	e8 37 5e 00 00       	call   80106d34 <strlen>
80100efd:	83 c4 10             	add    $0x10,%esp
80100f00:	89 c2                	mov    %eax,%edx
80100f02:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f05:	29 d0                	sub    %edx,%eax
80100f07:	83 e8 01             	sub    $0x1,%eax
80100f0a:	83 e0 fc             	and    $0xfffffffc,%eax
80100f0d:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100f10:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f1d:	01 d0                	add    %edx,%eax
80100f1f:	8b 00                	mov    (%eax),%eax
80100f21:	83 ec 0c             	sub    $0xc,%esp
80100f24:	50                   	push   %eax
80100f25:	e8 0a 5e 00 00       	call   80106d34 <strlen>
80100f2a:	83 c4 10             	add    $0x10,%esp
80100f2d:	83 c0 01             	add    $0x1,%eax
80100f30:	89 c1                	mov    %eax,%ecx
80100f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f35:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f3f:	01 d0                	add    %edx,%eax
80100f41:	8b 00                	mov    (%eax),%eax
80100f43:	51                   	push   %ecx
80100f44:	50                   	push   %eax
80100f45:	ff 75 dc             	pushl  -0x24(%ebp)
80100f48:	ff 75 d4             	pushl  -0x2c(%ebp)
80100f4b:	e8 cd 90 00 00       	call   8010a01d <copyout>
80100f50:	83 c4 10             	add    $0x10,%esp
80100f53:	85 c0                	test   %eax,%eax
80100f55:	0f 88 83 01 00 00    	js     801010de <exec+0x4c3>
      goto bad;
    ustack[3+argc] = sp;
80100f5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f5e:	8d 50 03             	lea    0x3(%eax),%edx
80100f61:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f64:	89 84 95 38 ff ff ff 	mov    %eax,-0xc8(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100f6b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f72:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100f79:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f7c:	01 d0                	add    %edx,%eax
80100f7e:	8b 00                	mov    (%eax),%eax
80100f80:	85 c0                	test   %eax,%eax
80100f82:	0f 85 51 ff ff ff    	jne    80100ed9 <exec+0x2be>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100f8b:	83 c0 03             	add    $0x3,%eax
80100f8e:	c7 84 85 38 ff ff ff 	movl   $0x0,-0xc8(%ebp,%eax,4)
80100f95:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100f99:	c7 85 38 ff ff ff ff 	movl   $0xffffffff,-0xc8(%ebp)
80100fa0:	ff ff ff 
  ustack[1] = argc;
80100fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fa6:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100faf:	83 c0 01             	add    $0x1,%eax
80100fb2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100fb9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100fbc:	29 d0                	sub    %edx,%eax
80100fbe:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)

  sp -= (3+argc+1) * 4;
80100fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fc7:	83 c0 04             	add    $0x4,%eax
80100fca:	c1 e0 02             	shl    $0x2,%eax
80100fcd:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fd3:	83 c0 04             	add    $0x4,%eax
80100fd6:	c1 e0 02             	shl    $0x2,%eax
80100fd9:	50                   	push   %eax
80100fda:	8d 85 38 ff ff ff    	lea    -0xc8(%ebp),%eax
80100fe0:	50                   	push   %eax
80100fe1:	ff 75 dc             	pushl  -0x24(%ebp)
80100fe4:	ff 75 d4             	pushl  -0x2c(%ebp)
80100fe7:	e8 31 90 00 00       	call   8010a01d <copyout>
80100fec:	83 c4 10             	add    $0x10,%esp
80100fef:	85 c0                	test   %eax,%eax
80100ff1:	0f 88 ea 00 00 00    	js     801010e1 <exec+0x4c6>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffa:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ffd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101000:	89 45 f0             	mov    %eax,-0x10(%ebp)
80101003:	eb 17                	jmp    8010101c <exec+0x401>
    if(*s == '/')
80101005:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101008:	0f b6 00             	movzbl (%eax),%eax
8010100b:	3c 2f                	cmp    $0x2f,%al
8010100d:	75 09                	jne    80101018 <exec+0x3fd>
      last = s+1;
8010100f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101012:	83 c0 01             	add    $0x1,%eax
80101015:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80101018:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010101f:	0f b6 00             	movzbl (%eax),%eax
80101022:	84 c0                	test   %al,%al
80101024:	75 df                	jne    80101005 <exec+0x3ea>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80101026:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010102c:	83 c0 6c             	add    $0x6c,%eax
8010102f:	83 ec 04             	sub    $0x4,%esp
80101032:	6a 10                	push   $0x10
80101034:	ff 75 f0             	pushl  -0x10(%ebp)
80101037:	50                   	push   %eax
80101038:	e8 ad 5c 00 00       	call   80106cea <safestrcpy>
8010103d:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.

  #ifdef CS333_P5
  // If the ip has setuid, then set the uid.
  if(isetuid)
80101040:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
80101044:	74 0f                	je     80101055 <exec+0x43a>
    proc->uid = iuid;
80101046:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010104c:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010104f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  #endif

  oldpgdir = proc->pgdir;
80101055:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010105b:	8b 40 04             	mov    0x4(%eax),%eax
8010105e:	89 45 c8             	mov    %eax,-0x38(%ebp)
  proc->pgdir = pgdir;
80101061:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101067:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010106a:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
8010106d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101073:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101076:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80101078:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010107e:	8b 40 18             	mov    0x18(%eax),%eax
80101081:	8b 95 1c ff ff ff    	mov    -0xe4(%ebp),%edx
80101087:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
8010108a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80101090:	8b 40 18             	mov    0x18(%eax),%eax
80101093:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101096:	89 50 44             	mov    %edx,0x44(%eax)

  switchuvm(proc);
80101099:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	50                   	push   %eax
801010a3:	e8 d8 88 00 00       	call   80109980 <switchuvm>
801010a8:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
801010ab:	83 ec 0c             	sub    $0xc,%esp
801010ae:	ff 75 c8             	pushl  -0x38(%ebp)
801010b1:	e8 10 8d 00 00       	call   80109dc6 <freevm>
801010b6:	83 c4 10             	add    $0x10,%esp
  return 0;
801010b9:	b8 00 00 00 00       	mov    $0x0,%eax
801010be:	eb 54                	jmp    80101114 <exec+0x4f9>
  }

  else
  {
    if(stat.mode.flags.o_x == 0)
      goto bad;
801010c0:	90                   	nop
801010c1:	eb 1f                	jmp    801010e2 <exec+0x4c7>

  #endif

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
801010c3:	90                   	nop
801010c4:	eb 1c                	jmp    801010e2 <exec+0x4c7>
  if(elf.magic != ELF_MAGIC)
    goto bad;
801010c6:	90                   	nop
801010c7:	eb 19                	jmp    801010e2 <exec+0x4c7>

  if((pgdir = setupkvm()) == 0)
    goto bad;
801010c9:	90                   	nop
801010ca:	eb 16                	jmp    801010e2 <exec+0x4c7>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
801010cc:	90                   	nop
801010cd:	eb 13                	jmp    801010e2 <exec+0x4c7>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
801010cf:	90                   	nop
801010d0:	eb 10                	jmp    801010e2 <exec+0x4c7>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
801010d2:	90                   	nop
801010d3:	eb 0d                	jmp    801010e2 <exec+0x4c7>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
801010d5:	90                   	nop
801010d6:	eb 0a                	jmp    801010e2 <exec+0x4c7>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
801010d8:	90                   	nop
801010d9:	eb 07                	jmp    801010e2 <exec+0x4c7>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
801010db:	90                   	nop
801010dc:	eb 04                	jmp    801010e2 <exec+0x4c7>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
801010de:	90                   	nop
801010df:	eb 01                	jmp    801010e2 <exec+0x4c7>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
801010e1:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
801010e2:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
801010e6:	74 0e                	je     801010f6 <exec+0x4db>
    freevm(pgdir);
801010e8:	83 ec 0c             	sub    $0xc,%esp
801010eb:	ff 75 d4             	pushl  -0x2c(%ebp)
801010ee:	e8 d3 8c 00 00       	call   80109dc6 <freevm>
801010f3:	83 c4 10             	add    $0x10,%esp
  if(ip){
801010f6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
801010fa:	74 13                	je     8010110f <exec+0x4f4>
    iunlockput(ip);
801010fc:	83 ec 0c             	sub    $0xc,%esp
801010ff:	ff 75 d8             	pushl  -0x28(%ebp)
80101102:	e8 30 0d 00 00       	call   80101e37 <iunlockput>
80101107:	83 c4 10             	add    $0x10,%esp
    end_op();
8010110a:	e8 ff 29 00 00       	call   80103b0e <end_op>
  }
  return -1;
8010110f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101114:	c9                   	leave  
80101115:	c3                   	ret    

80101116 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80101116:	55                   	push   %ebp
80101117:	89 e5                	mov    %esp,%ebp
80101119:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
8010111c:	83 ec 08             	sub    $0x8,%esp
8010111f:	68 22 a1 10 80       	push   $0x8010a122
80101124:	68 60 28 11 80       	push   $0x80112860
80101129:	e8 34 57 00 00       	call   80106862 <initlock>
8010112e:	83 c4 10             	add    $0x10,%esp
}
80101131:	90                   	nop
80101132:	c9                   	leave  
80101133:	c3                   	ret    

80101134 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80101134:	55                   	push   %ebp
80101135:	89 e5                	mov    %esp,%ebp
80101137:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
8010113a:	83 ec 0c             	sub    $0xc,%esp
8010113d:	68 60 28 11 80       	push   $0x80112860
80101142:	e8 3d 57 00 00       	call   80106884 <acquire>
80101147:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010114a:	c7 45 f4 94 28 11 80 	movl   $0x80112894,-0xc(%ebp)
80101151:	eb 2d                	jmp    80101180 <filealloc+0x4c>
    if(f->ref == 0){
80101153:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101156:	8b 40 04             	mov    0x4(%eax),%eax
80101159:	85 c0                	test   %eax,%eax
8010115b:	75 1f                	jne    8010117c <filealloc+0x48>
      f->ref = 1;
8010115d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101160:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80101167:	83 ec 0c             	sub    $0xc,%esp
8010116a:	68 60 28 11 80       	push   $0x80112860
8010116f:	e8 77 57 00 00       	call   801068eb <release>
80101174:	83 c4 10             	add    $0x10,%esp
      return f;
80101177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010117a:	eb 23                	jmp    8010119f <filealloc+0x6b>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
8010117c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80101180:	b8 f4 31 11 80       	mov    $0x801131f4,%eax
80101185:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101188:	72 c9                	jb     80101153 <filealloc+0x1f>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
8010118a:	83 ec 0c             	sub    $0xc,%esp
8010118d:	68 60 28 11 80       	push   $0x80112860
80101192:	e8 54 57 00 00       	call   801068eb <release>
80101197:	83 c4 10             	add    $0x10,%esp
  return 0;
8010119a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010119f:	c9                   	leave  
801011a0:	c3                   	ret    

801011a1 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
801011a1:	55                   	push   %ebp
801011a2:	89 e5                	mov    %esp,%ebp
801011a4:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
801011a7:	83 ec 0c             	sub    $0xc,%esp
801011aa:	68 60 28 11 80       	push   $0x80112860
801011af:	e8 d0 56 00 00       	call   80106884 <acquire>
801011b4:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011b7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ba:	8b 40 04             	mov    0x4(%eax),%eax
801011bd:	85 c0                	test   %eax,%eax
801011bf:	7f 0d                	jg     801011ce <filedup+0x2d>
    panic("filedup");
801011c1:	83 ec 0c             	sub    $0xc,%esp
801011c4:	68 29 a1 10 80       	push   $0x8010a129
801011c9:	e8 98 f3 ff ff       	call   80100566 <panic>
  f->ref++;
801011ce:	8b 45 08             	mov    0x8(%ebp),%eax
801011d1:	8b 40 04             	mov    0x4(%eax),%eax
801011d4:	8d 50 01             	lea    0x1(%eax),%edx
801011d7:	8b 45 08             	mov    0x8(%ebp),%eax
801011da:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
801011dd:	83 ec 0c             	sub    $0xc,%esp
801011e0:	68 60 28 11 80       	push   $0x80112860
801011e5:	e8 01 57 00 00       	call   801068eb <release>
801011ea:	83 c4 10             	add    $0x10,%esp
  return f;
801011ed:	8b 45 08             	mov    0x8(%ebp),%eax
}
801011f0:	c9                   	leave  
801011f1:	c3                   	ret    

801011f2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
801011f2:	55                   	push   %ebp
801011f3:	89 e5                	mov    %esp,%ebp
801011f5:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
801011f8:	83 ec 0c             	sub    $0xc,%esp
801011fb:	68 60 28 11 80       	push   $0x80112860
80101200:	e8 7f 56 00 00       	call   80106884 <acquire>
80101205:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101208:	8b 45 08             	mov    0x8(%ebp),%eax
8010120b:	8b 40 04             	mov    0x4(%eax),%eax
8010120e:	85 c0                	test   %eax,%eax
80101210:	7f 0d                	jg     8010121f <fileclose+0x2d>
    panic("fileclose");
80101212:	83 ec 0c             	sub    $0xc,%esp
80101215:	68 31 a1 10 80       	push   $0x8010a131
8010121a:	e8 47 f3 ff ff       	call   80100566 <panic>
  if(--f->ref > 0){
8010121f:	8b 45 08             	mov    0x8(%ebp),%eax
80101222:	8b 40 04             	mov    0x4(%eax),%eax
80101225:	8d 50 ff             	lea    -0x1(%eax),%edx
80101228:	8b 45 08             	mov    0x8(%ebp),%eax
8010122b:	89 50 04             	mov    %edx,0x4(%eax)
8010122e:	8b 45 08             	mov    0x8(%ebp),%eax
80101231:	8b 40 04             	mov    0x4(%eax),%eax
80101234:	85 c0                	test   %eax,%eax
80101236:	7e 15                	jle    8010124d <fileclose+0x5b>
    release(&ftable.lock);
80101238:	83 ec 0c             	sub    $0xc,%esp
8010123b:	68 60 28 11 80       	push   $0x80112860
80101240:	e8 a6 56 00 00       	call   801068eb <release>
80101245:	83 c4 10             	add    $0x10,%esp
80101248:	e9 8b 00 00 00       	jmp    801012d8 <fileclose+0xe6>
    return;
  }
  ff = *f;
8010124d:	8b 45 08             	mov    0x8(%ebp),%eax
80101250:	8b 10                	mov    (%eax),%edx
80101252:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101255:	8b 50 04             	mov    0x4(%eax),%edx
80101258:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010125b:	8b 50 08             	mov    0x8(%eax),%edx
8010125e:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101261:	8b 50 0c             	mov    0xc(%eax),%edx
80101264:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101267:	8b 50 10             	mov    0x10(%eax),%edx
8010126a:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010126d:	8b 40 14             	mov    0x14(%eax),%eax
80101270:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101273:	8b 45 08             	mov    0x8(%ebp),%eax
80101276:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010127d:	8b 45 08             	mov    0x8(%ebp),%eax
80101280:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101286:	83 ec 0c             	sub    $0xc,%esp
80101289:	68 60 28 11 80       	push   $0x80112860
8010128e:	e8 58 56 00 00       	call   801068eb <release>
80101293:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101296:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101299:	83 f8 01             	cmp    $0x1,%eax
8010129c:	75 19                	jne    801012b7 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010129e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801012a2:	0f be d0             	movsbl %al,%edx
801012a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012a8:	83 ec 08             	sub    $0x8,%esp
801012ab:	52                   	push   %edx
801012ac:	50                   	push   %eax
801012ad:	e8 17 34 00 00       	call   801046c9 <pipeclose>
801012b2:	83 c4 10             	add    $0x10,%esp
801012b5:	eb 21                	jmp    801012d8 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
801012b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801012ba:	83 f8 02             	cmp    $0x2,%eax
801012bd:	75 19                	jne    801012d8 <fileclose+0xe6>
    begin_op();
801012bf:	e8 be 27 00 00       	call   80103a82 <begin_op>
    iput(ff.ip);
801012c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012c7:	83 ec 0c             	sub    $0xc,%esp
801012ca:	50                   	push   %eax
801012cb:	e8 77 0a 00 00       	call   80101d47 <iput>
801012d0:	83 c4 10             	add    $0x10,%esp
    end_op();
801012d3:	e8 36 28 00 00       	call   80103b0e <end_op>
  }
}
801012d8:	c9                   	leave  
801012d9:	c3                   	ret    

801012da <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801012da:	55                   	push   %ebp
801012db:	89 e5                	mov    %esp,%ebp
801012dd:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
801012e0:	8b 45 08             	mov    0x8(%ebp),%eax
801012e3:	8b 00                	mov    (%eax),%eax
801012e5:	83 f8 02             	cmp    $0x2,%eax
801012e8:	75 40                	jne    8010132a <filestat+0x50>
    ilock(f->ip);
801012ea:	8b 45 08             	mov    0x8(%ebp),%eax
801012ed:	8b 40 10             	mov    0x10(%eax),%eax
801012f0:	83 ec 0c             	sub    $0xc,%esp
801012f3:	50                   	push   %eax
801012f4:	e8 56 08 00 00       	call   80101b4f <ilock>
801012f9:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
801012fc:	8b 45 08             	mov    0x8(%ebp),%eax
801012ff:	8b 40 10             	mov    0x10(%eax),%eax
80101302:	83 ec 08             	sub    $0x8,%esp
80101305:	ff 75 0c             	pushl  0xc(%ebp)
80101308:	50                   	push   %eax
80101309:	e8 91 0d 00 00       	call   8010209f <stati>
8010130e:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
80101311:	8b 45 08             	mov    0x8(%ebp),%eax
80101314:	8b 40 10             	mov    0x10(%eax),%eax
80101317:	83 ec 0c             	sub    $0xc,%esp
8010131a:	50                   	push   %eax
8010131b:	e8 b5 09 00 00       	call   80101cd5 <iunlock>
80101320:	83 c4 10             	add    $0x10,%esp
    return 0;
80101323:	b8 00 00 00 00       	mov    $0x0,%eax
80101328:	eb 05                	jmp    8010132f <filestat+0x55>
  }
  return -1;
8010132a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010132f:	c9                   	leave  
80101330:	c3                   	ret    

80101331 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101331:	55                   	push   %ebp
80101332:	89 e5                	mov    %esp,%ebp
80101334:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
80101337:	8b 45 08             	mov    0x8(%ebp),%eax
8010133a:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010133e:	84 c0                	test   %al,%al
80101340:	75 0a                	jne    8010134c <fileread+0x1b>
    return -1;
80101342:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101347:	e9 9b 00 00 00       	jmp    801013e7 <fileread+0xb6>
  if(f->type == FD_PIPE)
8010134c:	8b 45 08             	mov    0x8(%ebp),%eax
8010134f:	8b 00                	mov    (%eax),%eax
80101351:	83 f8 01             	cmp    $0x1,%eax
80101354:	75 1a                	jne    80101370 <fileread+0x3f>
    return piperead(f->pipe, addr, n);
80101356:	8b 45 08             	mov    0x8(%ebp),%eax
80101359:	8b 40 0c             	mov    0xc(%eax),%eax
8010135c:	83 ec 04             	sub    $0x4,%esp
8010135f:	ff 75 10             	pushl  0x10(%ebp)
80101362:	ff 75 0c             	pushl  0xc(%ebp)
80101365:	50                   	push   %eax
80101366:	e8 06 35 00 00       	call   80104871 <piperead>
8010136b:	83 c4 10             	add    $0x10,%esp
8010136e:	eb 77                	jmp    801013e7 <fileread+0xb6>
  if(f->type == FD_INODE){
80101370:	8b 45 08             	mov    0x8(%ebp),%eax
80101373:	8b 00                	mov    (%eax),%eax
80101375:	83 f8 02             	cmp    $0x2,%eax
80101378:	75 60                	jne    801013da <fileread+0xa9>
    ilock(f->ip);
8010137a:	8b 45 08             	mov    0x8(%ebp),%eax
8010137d:	8b 40 10             	mov    0x10(%eax),%eax
80101380:	83 ec 0c             	sub    $0xc,%esp
80101383:	50                   	push   %eax
80101384:	e8 c6 07 00 00       	call   80101b4f <ilock>
80101389:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010138c:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010138f:	8b 45 08             	mov    0x8(%ebp),%eax
80101392:	8b 50 14             	mov    0x14(%eax),%edx
80101395:	8b 45 08             	mov    0x8(%ebp),%eax
80101398:	8b 40 10             	mov    0x10(%eax),%eax
8010139b:	51                   	push   %ecx
8010139c:	52                   	push   %edx
8010139d:	ff 75 0c             	pushl  0xc(%ebp)
801013a0:	50                   	push   %eax
801013a1:	e8 67 0d 00 00       	call   8010210d <readi>
801013a6:	83 c4 10             	add    $0x10,%esp
801013a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801013ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801013b0:	7e 11                	jle    801013c3 <fileread+0x92>
      f->off += r;
801013b2:	8b 45 08             	mov    0x8(%ebp),%eax
801013b5:	8b 50 14             	mov    0x14(%eax),%edx
801013b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013bb:	01 c2                	add    %eax,%edx
801013bd:	8b 45 08             	mov    0x8(%ebp),%eax
801013c0:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801013c3:	8b 45 08             	mov    0x8(%ebp),%eax
801013c6:	8b 40 10             	mov    0x10(%eax),%eax
801013c9:	83 ec 0c             	sub    $0xc,%esp
801013cc:	50                   	push   %eax
801013cd:	e8 03 09 00 00       	call   80101cd5 <iunlock>
801013d2:	83 c4 10             	add    $0x10,%esp
    return r;
801013d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d8:	eb 0d                	jmp    801013e7 <fileread+0xb6>
  }
  panic("fileread");
801013da:	83 ec 0c             	sub    $0xc,%esp
801013dd:	68 3b a1 10 80       	push   $0x8010a13b
801013e2:	e8 7f f1 ff ff       	call   80100566 <panic>
}
801013e7:	c9                   	leave  
801013e8:	c3                   	ret    

801013e9 <filewrite>:

// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801013e9:	55                   	push   %ebp
801013ea:	89 e5                	mov    %esp,%ebp
801013ec:	53                   	push   %ebx
801013ed:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
801013f0:	8b 45 08             	mov    0x8(%ebp),%eax
801013f3:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801013f7:	84 c0                	test   %al,%al
801013f9:	75 0a                	jne    80101405 <filewrite+0x1c>
    return -1;
801013fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101400:	e9 1b 01 00 00       	jmp    80101520 <filewrite+0x137>
  if(f->type == FD_PIPE)
80101405:	8b 45 08             	mov    0x8(%ebp),%eax
80101408:	8b 00                	mov    (%eax),%eax
8010140a:	83 f8 01             	cmp    $0x1,%eax
8010140d:	75 1d                	jne    8010142c <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010140f:	8b 45 08             	mov    0x8(%ebp),%eax
80101412:	8b 40 0c             	mov    0xc(%eax),%eax
80101415:	83 ec 04             	sub    $0x4,%esp
80101418:	ff 75 10             	pushl  0x10(%ebp)
8010141b:	ff 75 0c             	pushl  0xc(%ebp)
8010141e:	50                   	push   %eax
8010141f:	e8 4f 33 00 00       	call   80104773 <pipewrite>
80101424:	83 c4 10             	add    $0x10,%esp
80101427:	e9 f4 00 00 00       	jmp    80101520 <filewrite+0x137>
  if(f->type == FD_INODE){
8010142c:	8b 45 08             	mov    0x8(%ebp),%eax
8010142f:	8b 00                	mov    (%eax),%eax
80101431:	83 f8 02             	cmp    $0x2,%eax
80101434:	0f 85 d9 00 00 00    	jne    80101513 <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010143a:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101448:	e9 a3 00 00 00       	jmp    801014f0 <filewrite+0x107>
      int n1 = n - i;
8010144d:	8b 45 10             	mov    0x10(%ebp),%eax
80101450:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101453:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101456:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101459:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010145c:	7e 06                	jle    80101464 <filewrite+0x7b>
        n1 = max;
8010145e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101461:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101464:	e8 19 26 00 00       	call   80103a82 <begin_op>
      ilock(f->ip);
80101469:	8b 45 08             	mov    0x8(%ebp),%eax
8010146c:	8b 40 10             	mov    0x10(%eax),%eax
8010146f:	83 ec 0c             	sub    $0xc,%esp
80101472:	50                   	push   %eax
80101473:	e8 d7 06 00 00       	call   80101b4f <ilock>
80101478:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010147b:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010147e:	8b 45 08             	mov    0x8(%ebp),%eax
80101481:	8b 50 14             	mov    0x14(%eax),%edx
80101484:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101487:	8b 45 0c             	mov    0xc(%ebp),%eax
8010148a:	01 c3                	add    %eax,%ebx
8010148c:	8b 45 08             	mov    0x8(%ebp),%eax
8010148f:	8b 40 10             	mov    0x10(%eax),%eax
80101492:	51                   	push   %ecx
80101493:	52                   	push   %edx
80101494:	53                   	push   %ebx
80101495:	50                   	push   %eax
80101496:	e8 c9 0d 00 00       	call   80102264 <writei>
8010149b:	83 c4 10             	add    $0x10,%esp
8010149e:	89 45 e8             	mov    %eax,-0x18(%ebp)
801014a1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801014a5:	7e 11                	jle    801014b8 <filewrite+0xcf>
        f->off += r;
801014a7:	8b 45 08             	mov    0x8(%ebp),%eax
801014aa:	8b 50 14             	mov    0x14(%eax),%edx
801014ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014b0:	01 c2                	add    %eax,%edx
801014b2:	8b 45 08             	mov    0x8(%ebp),%eax
801014b5:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801014b8:	8b 45 08             	mov    0x8(%ebp),%eax
801014bb:	8b 40 10             	mov    0x10(%eax),%eax
801014be:	83 ec 0c             	sub    $0xc,%esp
801014c1:	50                   	push   %eax
801014c2:	e8 0e 08 00 00       	call   80101cd5 <iunlock>
801014c7:	83 c4 10             	add    $0x10,%esp
      end_op();
801014ca:	e8 3f 26 00 00       	call   80103b0e <end_op>

      if(r < 0)
801014cf:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801014d3:	78 29                	js     801014fe <filewrite+0x115>
        break;
      if(r != n1)
801014d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014d8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801014db:	74 0d                	je     801014ea <filewrite+0x101>
        panic("short filewrite");
801014dd:	83 ec 0c             	sub    $0xc,%esp
801014e0:	68 44 a1 10 80       	push   $0x8010a144
801014e5:	e8 7c f0 ff ff       	call   80100566 <panic>
      i += r;
801014ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
801014ed:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801014f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801014f3:	3b 45 10             	cmp    0x10(%ebp),%eax
801014f6:	0f 8c 51 ff ff ff    	jl     8010144d <filewrite+0x64>
801014fc:	eb 01                	jmp    801014ff <filewrite+0x116>
        f->off += r;
      iunlock(f->ip);
      end_op();

      if(r < 0)
        break;
801014fe:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801014ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101502:	3b 45 10             	cmp    0x10(%ebp),%eax
80101505:	75 05                	jne    8010150c <filewrite+0x123>
80101507:	8b 45 10             	mov    0x10(%ebp),%eax
8010150a:	eb 14                	jmp    80101520 <filewrite+0x137>
8010150c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101511:	eb 0d                	jmp    80101520 <filewrite+0x137>
  }
  panic("filewrite");
80101513:	83 ec 0c             	sub    $0xc,%esp
80101516:	68 54 a1 10 80       	push   $0x8010a154
8010151b:	e8 46 f0 ff ff       	call   80100566 <panic>
}
80101520:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101523:	c9                   	leave  
80101524:	c3                   	ret    

80101525 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101525:	55                   	push   %ebp
80101526:	89 e5                	mov    %esp,%ebp
80101528:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
8010152b:	8b 45 08             	mov    0x8(%ebp),%eax
8010152e:	83 ec 08             	sub    $0x8,%esp
80101531:	6a 01                	push   $0x1
80101533:	50                   	push   %eax
80101534:	e8 7d ec ff ff       	call   801001b6 <bread>
80101539:	83 c4 10             	add    $0x10,%esp
8010153c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010153f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101542:	83 c0 18             	add    $0x18,%eax
80101545:	83 ec 04             	sub    $0x4,%esp
80101548:	6a 1c                	push   $0x1c
8010154a:	50                   	push   %eax
8010154b:	ff 75 0c             	pushl  0xc(%ebp)
8010154e:	e8 53 56 00 00       	call   80106ba6 <memmove>
80101553:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	ff 75 f4             	pushl  -0xc(%ebp)
8010155c:	e8 cd ec ff ff       	call   8010022e <brelse>
80101561:	83 c4 10             	add    $0x10,%esp
}
80101564:	90                   	nop
80101565:	c9                   	leave  
80101566:	c3                   	ret    

80101567 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101567:	55                   	push   %ebp
80101568:	89 e5                	mov    %esp,%ebp
8010156a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
8010156d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101570:	8b 45 08             	mov    0x8(%ebp),%eax
80101573:	83 ec 08             	sub    $0x8,%esp
80101576:	52                   	push   %edx
80101577:	50                   	push   %eax
80101578:	e8 39 ec ff ff       	call   801001b6 <bread>
8010157d:	83 c4 10             	add    $0x10,%esp
80101580:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
80101583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101586:	83 c0 18             	add    $0x18,%eax
80101589:	83 ec 04             	sub    $0x4,%esp
8010158c:	68 00 02 00 00       	push   $0x200
80101591:	6a 00                	push   $0x0
80101593:	50                   	push   %eax
80101594:	e8 4e 55 00 00       	call   80106ae7 <memset>
80101599:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010159c:	83 ec 0c             	sub    $0xc,%esp
8010159f:	ff 75 f4             	pushl  -0xc(%ebp)
801015a2:	e8 13 27 00 00       	call   80103cba <log_write>
801015a7:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801015aa:	83 ec 0c             	sub    $0xc,%esp
801015ad:	ff 75 f4             	pushl  -0xc(%ebp)
801015b0:	e8 79 ec ff ff       	call   8010022e <brelse>
801015b5:	83 c4 10             	add    $0x10,%esp
}
801015b8:	90                   	nop
801015b9:	c9                   	leave  
801015ba:	c3                   	ret    

801015bb <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801015bb:	55                   	push   %ebp
801015bc:	89 e5                	mov    %esp,%ebp
801015be:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801015c1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801015c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801015cf:	e9 13 01 00 00       	jmp    801016e7 <balloc+0x12c>
    bp = bread(dev, BBLOCK(b, sb));
801015d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d7:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801015dd:	85 c0                	test   %eax,%eax
801015df:	0f 48 c2             	cmovs  %edx,%eax
801015e2:	c1 f8 0c             	sar    $0xc,%eax
801015e5:	89 c2                	mov    %eax,%edx
801015e7:	a1 78 32 11 80       	mov    0x80113278,%eax
801015ec:	01 d0                	add    %edx,%eax
801015ee:	83 ec 08             	sub    $0x8,%esp
801015f1:	50                   	push   %eax
801015f2:	ff 75 08             	pushl  0x8(%ebp)
801015f5:	e8 bc eb ff ff       	call   801001b6 <bread>
801015fa:	83 c4 10             	add    $0x10,%esp
801015fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101600:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101607:	e9 a6 00 00 00       	jmp    801016b2 <balloc+0xf7>
      m = 1 << (bi % 8);
8010160c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010160f:	99                   	cltd   
80101610:	c1 ea 1d             	shr    $0x1d,%edx
80101613:	01 d0                	add    %edx,%eax
80101615:	83 e0 07             	and    $0x7,%eax
80101618:	29 d0                	sub    %edx,%eax
8010161a:	ba 01 00 00 00       	mov    $0x1,%edx
8010161f:	89 c1                	mov    %eax,%ecx
80101621:	d3 e2                	shl    %cl,%edx
80101623:	89 d0                	mov    %edx,%eax
80101625:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101628:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010162b:	8d 50 07             	lea    0x7(%eax),%edx
8010162e:	85 c0                	test   %eax,%eax
80101630:	0f 48 c2             	cmovs  %edx,%eax
80101633:	c1 f8 03             	sar    $0x3,%eax
80101636:	89 c2                	mov    %eax,%edx
80101638:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010163b:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101640:	0f b6 c0             	movzbl %al,%eax
80101643:	23 45 e8             	and    -0x18(%ebp),%eax
80101646:	85 c0                	test   %eax,%eax
80101648:	75 64                	jne    801016ae <balloc+0xf3>
        bp->data[bi/8] |= m;  // Mark block in use.
8010164a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010164d:	8d 50 07             	lea    0x7(%eax),%edx
80101650:	85 c0                	test   %eax,%eax
80101652:	0f 48 c2             	cmovs  %edx,%eax
80101655:	c1 f8 03             	sar    $0x3,%eax
80101658:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010165b:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101660:	89 d1                	mov    %edx,%ecx
80101662:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101665:	09 ca                	or     %ecx,%edx
80101667:	89 d1                	mov    %edx,%ecx
80101669:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010166c:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101670:	83 ec 0c             	sub    $0xc,%esp
80101673:	ff 75 ec             	pushl  -0x14(%ebp)
80101676:	e8 3f 26 00 00       	call   80103cba <log_write>
8010167b:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
8010167e:	83 ec 0c             	sub    $0xc,%esp
80101681:	ff 75 ec             	pushl  -0x14(%ebp)
80101684:	e8 a5 eb ff ff       	call   8010022e <brelse>
80101689:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
8010168c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101692:	01 c2                	add    %eax,%edx
80101694:	8b 45 08             	mov    0x8(%ebp),%eax
80101697:	83 ec 08             	sub    $0x8,%esp
8010169a:	52                   	push   %edx
8010169b:	50                   	push   %eax
8010169c:	e8 c6 fe ff ff       	call   80101567 <bzero>
801016a1:	83 c4 10             	add    $0x10,%esp
        return b + bi;
801016a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016aa:	01 d0                	add    %edx,%eax
801016ac:	eb 57                	jmp    80101705 <balloc+0x14a>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801016ae:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801016b2:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801016b9:	7f 17                	jg     801016d2 <balloc+0x117>
801016bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016c1:	01 d0                	add    %edx,%eax
801016c3:	89 c2                	mov    %eax,%edx
801016c5:	a1 60 32 11 80       	mov    0x80113260,%eax
801016ca:	39 c2                	cmp    %eax,%edx
801016cc:	0f 82 3a ff ff ff    	jb     8010160c <balloc+0x51>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801016d2:	83 ec 0c             	sub    $0xc,%esp
801016d5:	ff 75 ec             	pushl  -0x14(%ebp)
801016d8:	e8 51 eb ff ff       	call   8010022e <brelse>
801016dd:	83 c4 10             	add    $0x10,%esp
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801016e0:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801016e7:	8b 15 60 32 11 80    	mov    0x80113260,%edx
801016ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f0:	39 c2                	cmp    %eax,%edx
801016f2:	0f 87 dc fe ff ff    	ja     801015d4 <balloc+0x19>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801016f8:	83 ec 0c             	sub    $0xc,%esp
801016fb:	68 60 a1 10 80       	push   $0x8010a160
80101700:	e8 61 ee ff ff       	call   80100566 <panic>
}
80101705:	c9                   	leave  
80101706:	c3                   	ret    

80101707 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101707:	55                   	push   %ebp
80101708:	89 e5                	mov    %esp,%ebp
8010170a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010170d:	83 ec 08             	sub    $0x8,%esp
80101710:	68 60 32 11 80       	push   $0x80113260
80101715:	ff 75 08             	pushl  0x8(%ebp)
80101718:	e8 08 fe ff ff       	call   80101525 <readsb>
8010171d:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101720:	8b 45 0c             	mov    0xc(%ebp),%eax
80101723:	c1 e8 0c             	shr    $0xc,%eax
80101726:	89 c2                	mov    %eax,%edx
80101728:	a1 78 32 11 80       	mov    0x80113278,%eax
8010172d:	01 c2                	add    %eax,%edx
8010172f:	8b 45 08             	mov    0x8(%ebp),%eax
80101732:	83 ec 08             	sub    $0x8,%esp
80101735:	52                   	push   %edx
80101736:	50                   	push   %eax
80101737:	e8 7a ea ff ff       	call   801001b6 <bread>
8010173c:	83 c4 10             	add    $0x10,%esp
8010173f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101742:	8b 45 0c             	mov    0xc(%ebp),%eax
80101745:	25 ff 0f 00 00       	and    $0xfff,%eax
8010174a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010174d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101750:	99                   	cltd   
80101751:	c1 ea 1d             	shr    $0x1d,%edx
80101754:	01 d0                	add    %edx,%eax
80101756:	83 e0 07             	and    $0x7,%eax
80101759:	29 d0                	sub    %edx,%eax
8010175b:	ba 01 00 00 00       	mov    $0x1,%edx
80101760:	89 c1                	mov    %eax,%ecx
80101762:	d3 e2                	shl    %cl,%edx
80101764:	89 d0                	mov    %edx,%eax
80101766:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101769:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176c:	8d 50 07             	lea    0x7(%eax),%edx
8010176f:	85 c0                	test   %eax,%eax
80101771:	0f 48 c2             	cmovs  %edx,%eax
80101774:	c1 f8 03             	sar    $0x3,%eax
80101777:	89 c2                	mov    %eax,%edx
80101779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177c:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
80101781:	0f b6 c0             	movzbl %al,%eax
80101784:	23 45 ec             	and    -0x14(%ebp),%eax
80101787:	85 c0                	test   %eax,%eax
80101789:	75 0d                	jne    80101798 <bfree+0x91>
    panic("freeing free block");
8010178b:	83 ec 0c             	sub    $0xc,%esp
8010178e:	68 76 a1 10 80       	push   $0x8010a176
80101793:	e8 ce ed ff ff       	call   80100566 <panic>
  bp->data[bi/8] &= ~m;
80101798:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010179b:	8d 50 07             	lea    0x7(%eax),%edx
8010179e:	85 c0                	test   %eax,%eax
801017a0:	0f 48 c2             	cmovs  %edx,%eax
801017a3:	c1 f8 03             	sar    $0x3,%eax
801017a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017a9:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801017ae:	89 d1                	mov    %edx,%ecx
801017b0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801017b3:	f7 d2                	not    %edx
801017b5:	21 ca                	and    %ecx,%edx
801017b7:	89 d1                	mov    %edx,%ecx
801017b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801017bc:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801017c0:	83 ec 0c             	sub    $0xc,%esp
801017c3:	ff 75 f4             	pushl  -0xc(%ebp)
801017c6:	e8 ef 24 00 00       	call   80103cba <log_write>
801017cb:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801017ce:	83 ec 0c             	sub    $0xc,%esp
801017d1:	ff 75 f4             	pushl  -0xc(%ebp)
801017d4:	e8 55 ea ff ff       	call   8010022e <brelse>
801017d9:	83 c4 10             	add    $0x10,%esp
}
801017dc:	90                   	nop
801017dd:	c9                   	leave  
801017de:	c3                   	ret    

801017df <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801017df:	55                   	push   %ebp
801017e0:	89 e5                	mov    %esp,%ebp
801017e2:	57                   	push   %edi
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
801017e8:	83 ec 08             	sub    $0x8,%esp
801017eb:	68 89 a1 10 80       	push   $0x8010a189
801017f0:	68 80 32 11 80       	push   $0x80113280
801017f5:	e8 68 50 00 00       	call   80106862 <initlock>
801017fa:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
801017fd:	83 ec 08             	sub    $0x8,%esp
80101800:	68 60 32 11 80       	push   $0x80113260
80101805:	ff 75 08             	pushl  0x8(%ebp)
80101808:	e8 18 fd ff ff       	call   80101525 <readsb>
8010180d:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
80101810:	a1 78 32 11 80       	mov    0x80113278,%eax
80101815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101818:	8b 3d 74 32 11 80    	mov    0x80113274,%edi
8010181e:	8b 35 70 32 11 80    	mov    0x80113270,%esi
80101824:	8b 1d 6c 32 11 80    	mov    0x8011326c,%ebx
8010182a:	8b 0d 68 32 11 80    	mov    0x80113268,%ecx
80101830:	8b 15 64 32 11 80    	mov    0x80113264,%edx
80101836:	a1 60 32 11 80       	mov    0x80113260,%eax
8010183b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010183e:	57                   	push   %edi
8010183f:	56                   	push   %esi
80101840:	53                   	push   %ebx
80101841:	51                   	push   %ecx
80101842:	52                   	push   %edx
80101843:	50                   	push   %eax
80101844:	68 90 a1 10 80       	push   $0x8010a190
80101849:	e8 78 eb ff ff       	call   801003c6 <cprintf>
8010184e:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
80101851:	90                   	nop
80101852:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101855:	5b                   	pop    %ebx
80101856:	5e                   	pop    %esi
80101857:	5f                   	pop    %edi
80101858:	5d                   	pop    %ebp
80101859:	c3                   	ret    

8010185a <ialloc>:

// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
8010185a:	55                   	push   %ebp
8010185b:	89 e5                	mov    %esp,%ebp
8010185d:	83 ec 28             	sub    $0x28,%esp
80101860:	8b 45 0c             	mov    0xc(%ebp),%eax
80101863:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101867:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
8010186e:	e9 ba 00 00 00       	jmp    8010192d <ialloc+0xd3>
    bp = bread(dev, IBLOCK(inum, sb));
80101873:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101876:	c1 e8 03             	shr    $0x3,%eax
80101879:	89 c2                	mov    %eax,%edx
8010187b:	a1 74 32 11 80       	mov    0x80113274,%eax
80101880:	01 d0                	add    %edx,%eax
80101882:	83 ec 08             	sub    $0x8,%esp
80101885:	50                   	push   %eax
80101886:	ff 75 08             	pushl  0x8(%ebp)
80101889:	e8 28 e9 ff ff       	call   801001b6 <bread>
8010188e:	83 c4 10             	add    $0x10,%esp
80101891:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101894:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101897:	8d 50 18             	lea    0x18(%eax),%edx
8010189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189d:	83 e0 07             	and    $0x7,%eax
801018a0:	c1 e0 06             	shl    $0x6,%eax
801018a3:	01 d0                	add    %edx,%eax
801018a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
801018a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018ab:	0f b7 00             	movzwl (%eax),%eax
801018ae:	66 85 c0             	test   %ax,%ax
801018b1:	75 68                	jne    8010191b <ialloc+0xc1>
      memset(dip, 0, sizeof(*dip));
801018b3:	83 ec 04             	sub    $0x4,%esp
801018b6:	6a 40                	push   $0x40
801018b8:	6a 00                	push   $0x0
801018ba:	ff 75 ec             	pushl  -0x14(%ebp)
801018bd:	e8 25 52 00 00       	call   80106ae7 <memset>
801018c2:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
801018c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018c8:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
801018cc:	66 89 10             	mov    %dx,(%eax)
      #ifdef CS333_P5
      dip->uid = DEFAULT_UID;
801018cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018d2:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
      dip->gid = DEFAULT_GID;
801018d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018db:	66 c7 40 0a 01 00    	movw   $0x1,0xa(%eax)
      dip->mode.asInt = DEFAULT_MODE;
801018e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801018e4:	c7 40 0c ed 01 00 00 	movl   $0x1ed,0xc(%eax)
      #endif
      log_write(bp);   // mark it allocated on the disk
801018eb:	83 ec 0c             	sub    $0xc,%esp
801018ee:	ff 75 f0             	pushl  -0x10(%ebp)
801018f1:	e8 c4 23 00 00       	call   80103cba <log_write>
801018f6:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
801018f9:	83 ec 0c             	sub    $0xc,%esp
801018fc:	ff 75 f0             	pushl  -0x10(%ebp)
801018ff:	e8 2a e9 ff ff       	call   8010022e <brelse>
80101904:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010190a:	83 ec 08             	sub    $0x8,%esp
8010190d:	50                   	push   %eax
8010190e:	ff 75 08             	pushl  0x8(%ebp)
80101911:	e8 20 01 00 00       	call   80101a36 <iget>
80101916:	83 c4 10             	add    $0x10,%esp
80101919:	eb 30                	jmp    8010194b <ialloc+0xf1>
    }
    brelse(bp);
8010191b:	83 ec 0c             	sub    $0xc,%esp
8010191e:	ff 75 f0             	pushl  -0x10(%ebp)
80101921:	e8 08 e9 ff ff       	call   8010022e <brelse>
80101926:	83 c4 10             	add    $0x10,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101929:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010192d:	8b 15 68 32 11 80    	mov    0x80113268,%edx
80101933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101936:	39 c2                	cmp    %eax,%edx
80101938:	0f 87 35 ff ff ff    	ja     80101873 <ialloc+0x19>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
8010193e:	83 ec 0c             	sub    $0xc,%esp
80101941:	68 e3 a1 10 80       	push   $0x8010a1e3
80101946:	e8 1b ec ff ff       	call   80100566 <panic>
}
8010194b:	c9                   	leave  
8010194c:	c3                   	ret    

8010194d <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
8010194d:	55                   	push   %ebp
8010194e:	89 e5                	mov    %esp,%ebp
80101950:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101953:	8b 45 08             	mov    0x8(%ebp),%eax
80101956:	8b 40 04             	mov    0x4(%eax),%eax
80101959:	c1 e8 03             	shr    $0x3,%eax
8010195c:	89 c2                	mov    %eax,%edx
8010195e:	a1 74 32 11 80       	mov    0x80113274,%eax
80101963:	01 c2                	add    %eax,%edx
80101965:	8b 45 08             	mov    0x8(%ebp),%eax
80101968:	8b 00                	mov    (%eax),%eax
8010196a:	83 ec 08             	sub    $0x8,%esp
8010196d:	52                   	push   %edx
8010196e:	50                   	push   %eax
8010196f:	e8 42 e8 ff ff       	call   801001b6 <bread>
80101974:	83 c4 10             	add    $0x10,%esp
80101977:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010197a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010197d:	8d 50 18             	lea    0x18(%eax),%edx
80101980:	8b 45 08             	mov    0x8(%ebp),%eax
80101983:	8b 40 04             	mov    0x4(%eax),%eax
80101986:	83 e0 07             	and    $0x7,%eax
80101989:	c1 e0 06             	shl    $0x6,%eax
8010198c:	01 d0                	add    %edx,%eax
8010198e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101991:	8b 45 08             	mov    0x8(%ebp),%eax
80101994:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101998:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010199b:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010199e:	8b 45 08             	mov    0x8(%ebp),%eax
801019a1:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019a8:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801019ac:	8b 45 08             	mov    0x8(%ebp),%eax
801019af:	0f b7 50 14          	movzwl 0x14(%eax),%edx
801019b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019b6:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801019ba:	8b 45 08             	mov    0x8(%ebp),%eax
801019bd:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019c4:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801019c8:	8b 45 08             	mov    0x8(%ebp),%eax
801019cb:	8b 50 20             	mov    0x20(%eax),%edx
801019ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019d1:	89 50 10             	mov    %edx,0x10(%eax)
  #ifdef CS333_P5
  dip->uid = ip->uid;
801019d4:	8b 45 08             	mov    0x8(%ebp),%eax
801019d7:	0f b7 50 18          	movzwl 0x18(%eax),%edx
801019db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019de:	66 89 50 08          	mov    %dx,0x8(%eax)
  dip->gid = ip->gid;
801019e2:	8b 45 08             	mov    0x8(%ebp),%eax
801019e5:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
801019e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019ec:	66 89 50 0a          	mov    %dx,0xa(%eax)
  dip->mode.asInt = ip->mode.asInt;
801019f0:	8b 45 08             	mov    0x8(%ebp),%eax
801019f3:	8b 50 1c             	mov    0x1c(%eax),%edx
801019f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f9:	89 50 0c             	mov    %edx,0xc(%eax)
  #endif
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	8d 50 24             	lea    0x24(%eax),%edx
80101a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a05:	83 c0 14             	add    $0x14,%eax
80101a08:	83 ec 04             	sub    $0x4,%esp
80101a0b:	6a 2c                	push   $0x2c
80101a0d:	52                   	push   %edx
80101a0e:	50                   	push   %eax
80101a0f:	e8 92 51 00 00       	call   80106ba6 <memmove>
80101a14:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101a17:	83 ec 0c             	sub    $0xc,%esp
80101a1a:	ff 75 f4             	pushl  -0xc(%ebp)
80101a1d:	e8 98 22 00 00       	call   80103cba <log_write>
80101a22:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101a25:	83 ec 0c             	sub    $0xc,%esp
80101a28:	ff 75 f4             	pushl  -0xc(%ebp)
80101a2b:	e8 fe e7 ff ff       	call   8010022e <brelse>
80101a30:	83 c4 10             	add    $0x10,%esp
}
80101a33:	90                   	nop
80101a34:	c9                   	leave  
80101a35:	c3                   	ret    

80101a36 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101a36:	55                   	push   %ebp
80101a37:	89 e5                	mov    %esp,%ebp
80101a39:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101a3c:	83 ec 0c             	sub    $0xc,%esp
80101a3f:	68 80 32 11 80       	push   $0x80113280
80101a44:	e8 3b 4e 00 00       	call   80106884 <acquire>
80101a49:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101a4c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101a53:	c7 45 f4 b4 32 11 80 	movl   $0x801132b4,-0xc(%ebp)
80101a5a:	eb 5d                	jmp    80101ab9 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a5f:	8b 40 08             	mov    0x8(%eax),%eax
80101a62:	85 c0                	test   %eax,%eax
80101a64:	7e 39                	jle    80101a9f <iget+0x69>
80101a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a69:	8b 00                	mov    (%eax),%eax
80101a6b:	3b 45 08             	cmp    0x8(%ebp),%eax
80101a6e:	75 2f                	jne    80101a9f <iget+0x69>
80101a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a73:	8b 40 04             	mov    0x4(%eax),%eax
80101a76:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101a79:	75 24                	jne    80101a9f <iget+0x69>
      ip->ref++;
80101a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a7e:	8b 40 08             	mov    0x8(%eax),%eax
80101a81:	8d 50 01             	lea    0x1(%eax),%edx
80101a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a87:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
80101a8a:	83 ec 0c             	sub    $0xc,%esp
80101a8d:	68 80 32 11 80       	push   $0x80113280
80101a92:	e8 54 4e 00 00       	call   801068eb <release>
80101a97:	83 c4 10             	add    $0x10,%esp
      return ip;
80101a9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a9d:	eb 74                	jmp    80101b13 <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101a9f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101aa3:	75 10                	jne    80101ab5 <iget+0x7f>
80101aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aa8:	8b 40 08             	mov    0x8(%eax),%eax
80101aab:	85 c0                	test   %eax,%eax
80101aad:	75 06                	jne    80101ab5 <iget+0x7f>
      empty = ip;
80101aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101ab5:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
80101ab9:	81 7d f4 54 42 11 80 	cmpl   $0x80114254,-0xc(%ebp)
80101ac0:	72 9a                	jb     80101a5c <iget+0x26>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101ac2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101ac6:	75 0d                	jne    80101ad5 <iget+0x9f>
    panic("iget: no inodes");
80101ac8:	83 ec 0c             	sub    $0xc,%esp
80101acb:	68 f5 a1 10 80       	push   $0x8010a1f5
80101ad0:	e8 91 ea ff ff       	call   80100566 <panic>

  ip = empty;
80101ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ad8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ade:	8b 55 08             	mov    0x8(%ebp),%edx
80101ae1:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ae6:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ae9:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101aef:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101af9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101b00:	83 ec 0c             	sub    $0xc,%esp
80101b03:	68 80 32 11 80       	push   $0x80113280
80101b08:	e8 de 4d 00 00       	call   801068eb <release>
80101b0d:	83 c4 10             	add    $0x10,%esp

  return ip;
80101b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101b13:	c9                   	leave  
80101b14:	c3                   	ret    

80101b15 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101b15:	55                   	push   %ebp
80101b16:	89 e5                	mov    %esp,%ebp
80101b18:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b1b:	83 ec 0c             	sub    $0xc,%esp
80101b1e:	68 80 32 11 80       	push   $0x80113280
80101b23:	e8 5c 4d 00 00       	call   80106884 <acquire>
80101b28:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2e:	8b 40 08             	mov    0x8(%eax),%eax
80101b31:	8d 50 01             	lea    0x1(%eax),%edx
80101b34:	8b 45 08             	mov    0x8(%ebp),%eax
80101b37:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b3a:	83 ec 0c             	sub    $0xc,%esp
80101b3d:	68 80 32 11 80       	push   $0x80113280
80101b42:	e8 a4 4d 00 00       	call   801068eb <release>
80101b47:	83 c4 10             	add    $0x10,%esp
  return ip;
80101b4a:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101b4d:	c9                   	leave  
80101b4e:	c3                   	ret    

80101b4f <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101b4f:	55                   	push   %ebp
80101b50:	89 e5                	mov    %esp,%ebp
80101b52:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101b59:	74 0a                	je     80101b65 <ilock+0x16>
80101b5b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5e:	8b 40 08             	mov    0x8(%eax),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	7f 0d                	jg     80101b72 <ilock+0x23>
    panic("ilock");
80101b65:	83 ec 0c             	sub    $0xc,%esp
80101b68:	68 05 a2 10 80       	push   $0x8010a205
80101b6d:	e8 f4 e9 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b72:	83 ec 0c             	sub    $0xc,%esp
80101b75:	68 80 32 11 80       	push   $0x80113280
80101b7a:	e8 05 4d 00 00       	call   80106884 <acquire>
80101b7f:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101b82:	eb 13                	jmp    80101b97 <ilock+0x48>
    sleep(ip, &icache.lock);
80101b84:	83 ec 08             	sub    $0x8,%esp
80101b87:	68 80 32 11 80       	push   $0x80113280
80101b8c:	ff 75 08             	pushl  0x8(%ebp)
80101b8f:	e8 7b 3f 00 00       	call   80105b0f <sleep>
80101b94:	83 c4 10             	add    $0x10,%esp

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
80101b97:	8b 45 08             	mov    0x8(%ebp),%eax
80101b9a:	8b 40 0c             	mov    0xc(%eax),%eax
80101b9d:	83 e0 01             	and    $0x1,%eax
80101ba0:	85 c0                	test   %eax,%eax
80101ba2:	75 e0                	jne    80101b84 <ilock+0x35>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
80101ba4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba7:	8b 40 0c             	mov    0xc(%eax),%eax
80101baa:	83 c8 01             	or     $0x1,%eax
80101bad:	89 c2                	mov    %eax,%edx
80101baf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb2:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
80101bb5:	83 ec 0c             	sub    $0xc,%esp
80101bb8:	68 80 32 11 80       	push   $0x80113280
80101bbd:	e8 29 4d 00 00       	call   801068eb <release>
80101bc2:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
80101bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc8:	8b 40 0c             	mov    0xc(%eax),%eax
80101bcb:	83 e0 02             	and    $0x2,%eax
80101bce:	85 c0                	test   %eax,%eax
80101bd0:	0f 85 fc 00 00 00    	jne    80101cd2 <ilock+0x183>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	8b 40 04             	mov    0x4(%eax),%eax
80101bdc:	c1 e8 03             	shr    $0x3,%eax
80101bdf:	89 c2                	mov    %eax,%edx
80101be1:	a1 74 32 11 80       	mov    0x80113274,%eax
80101be6:	01 c2                	add    %eax,%edx
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	8b 00                	mov    (%eax),%eax
80101bed:	83 ec 08             	sub    $0x8,%esp
80101bf0:	52                   	push   %edx
80101bf1:	50                   	push   %eax
80101bf2:	e8 bf e5 ff ff       	call   801001b6 <bread>
80101bf7:	83 c4 10             	add    $0x10,%esp
80101bfa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101bfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c00:	8d 50 18             	lea    0x18(%eax),%edx
80101c03:	8b 45 08             	mov    0x8(%ebp),%eax
80101c06:	8b 40 04             	mov    0x4(%eax),%eax
80101c09:	83 e0 07             	and    $0x7,%eax
80101c0c:	c1 e0 06             	shl    $0x6,%eax
80101c0f:	01 d0                	add    %edx,%eax
80101c11:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c17:	0f b7 10             	movzwl (%eax),%edx
80101c1a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1d:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101c21:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c24:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101c28:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2b:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c32:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101c36:	8b 45 08             	mov    0x8(%ebp),%eax
80101c39:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101c3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c40:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101c44:	8b 45 08             	mov    0x8(%ebp),%eax
80101c47:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101c4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c4e:	8b 50 10             	mov    0x10(%eax),%edx
80101c51:	8b 45 08             	mov    0x8(%ebp),%eax
80101c54:	89 50 20             	mov    %edx,0x20(%eax)
    #ifdef CS333_P5
    ip->uid = dip->uid;
80101c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c5a:	0f b7 50 08          	movzwl 0x8(%eax),%edx
80101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c61:	66 89 50 18          	mov    %dx,0x18(%eax)
    ip->gid = dip->gid;
80101c65:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c68:	0f b7 50 0a          	movzwl 0xa(%eax),%edx
80101c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c6f:	66 89 50 1a          	mov    %dx,0x1a(%eax)
    ip->mode.asInt = dip->mode.asInt;
80101c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c76:	8b 50 0c             	mov    0xc(%eax),%edx
80101c79:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7c:	89 50 1c             	mov    %edx,0x1c(%eax)
    #endif
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c82:	8d 50 14             	lea    0x14(%eax),%edx
80101c85:	8b 45 08             	mov    0x8(%ebp),%eax
80101c88:	83 c0 24             	add    $0x24,%eax
80101c8b:	83 ec 04             	sub    $0x4,%esp
80101c8e:	6a 2c                	push   $0x2c
80101c90:	52                   	push   %edx
80101c91:	50                   	push   %eax
80101c92:	e8 0f 4f 00 00       	call   80106ba6 <memmove>
80101c97:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101c9a:	83 ec 0c             	sub    $0xc,%esp
80101c9d:	ff 75 f4             	pushl  -0xc(%ebp)
80101ca0:	e8 89 e5 ff ff       	call   8010022e <brelse>
80101ca5:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101ca8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cab:	8b 40 0c             	mov    0xc(%eax),%eax
80101cae:	83 c8 02             	or     $0x2,%eax
80101cb1:	89 c2                	mov    %eax,%edx
80101cb3:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb6:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101cc0:	66 85 c0             	test   %ax,%ax
80101cc3:	75 0d                	jne    80101cd2 <ilock+0x183>
      panic("ilock: no type");
80101cc5:	83 ec 0c             	sub    $0xc,%esp
80101cc8:	68 0b a2 10 80       	push   $0x8010a20b
80101ccd:	e8 94 e8 ff ff       	call   80100566 <panic>
  }
}
80101cd2:	90                   	nop
80101cd3:	c9                   	leave  
80101cd4:	c3                   	ret    

80101cd5 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101cd5:	55                   	push   %ebp
80101cd6:	89 e5                	mov    %esp,%ebp
80101cd8:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101cdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101cdf:	74 17                	je     80101cf8 <iunlock+0x23>
80101ce1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce4:	8b 40 0c             	mov    0xc(%eax),%eax
80101ce7:	83 e0 01             	and    $0x1,%eax
80101cea:	85 c0                	test   %eax,%eax
80101cec:	74 0a                	je     80101cf8 <iunlock+0x23>
80101cee:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf1:	8b 40 08             	mov    0x8(%eax),%eax
80101cf4:	85 c0                	test   %eax,%eax
80101cf6:	7f 0d                	jg     80101d05 <iunlock+0x30>
    panic("iunlock");
80101cf8:	83 ec 0c             	sub    $0xc,%esp
80101cfb:	68 1a a2 10 80       	push   $0x8010a21a
80101d00:	e8 61 e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101d05:	83 ec 0c             	sub    $0xc,%esp
80101d08:	68 80 32 11 80       	push   $0x80113280
80101d0d:	e8 72 4b 00 00       	call   80106884 <acquire>
80101d12:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101d15:	8b 45 08             	mov    0x8(%ebp),%eax
80101d18:	8b 40 0c             	mov    0xc(%eax),%eax
80101d1b:	83 e0 fe             	and    $0xfffffffe,%eax
80101d1e:	89 c2                	mov    %eax,%edx
80101d20:	8b 45 08             	mov    0x8(%ebp),%eax
80101d23:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101d26:	83 ec 0c             	sub    $0xc,%esp
80101d29:	ff 75 08             	pushl  0x8(%ebp)
80101d2c:	e8 a5 3f 00 00       	call   80105cd6 <wakeup>
80101d31:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101d34:	83 ec 0c             	sub    $0xc,%esp
80101d37:	68 80 32 11 80       	push   $0x80113280
80101d3c:	e8 aa 4b 00 00       	call   801068eb <release>
80101d41:	83 c4 10             	add    $0x10,%esp
}
80101d44:	90                   	nop
80101d45:	c9                   	leave  
80101d46:	c3                   	ret    

80101d47 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101d47:	55                   	push   %ebp
80101d48:	89 e5                	mov    %esp,%ebp
80101d4a:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101d4d:	83 ec 0c             	sub    $0xc,%esp
80101d50:	68 80 32 11 80       	push   $0x80113280
80101d55:	e8 2a 4b 00 00       	call   80106884 <acquire>
80101d5a:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101d5d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d60:	8b 40 08             	mov    0x8(%eax),%eax
80101d63:	83 f8 01             	cmp    $0x1,%eax
80101d66:	0f 85 a9 00 00 00    	jne    80101e15 <iput+0xce>
80101d6c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d6f:	8b 40 0c             	mov    0xc(%eax),%eax
80101d72:	83 e0 02             	and    $0x2,%eax
80101d75:	85 c0                	test   %eax,%eax
80101d77:	0f 84 98 00 00 00    	je     80101e15 <iput+0xce>
80101d7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d80:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101d84:	66 85 c0             	test   %ax,%ax
80101d87:	0f 85 88 00 00 00    	jne    80101e15 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d90:	8b 40 0c             	mov    0xc(%eax),%eax
80101d93:	83 e0 01             	and    $0x1,%eax
80101d96:	85 c0                	test   %eax,%eax
80101d98:	74 0d                	je     80101da7 <iput+0x60>
      panic("iput busy");
80101d9a:	83 ec 0c             	sub    $0xc,%esp
80101d9d:	68 22 a2 10 80       	push   $0x8010a222
80101da2:	e8 bf e7 ff ff       	call   80100566 <panic>
    ip->flags |= I_BUSY;
80101da7:	8b 45 08             	mov    0x8(%ebp),%eax
80101daa:	8b 40 0c             	mov    0xc(%eax),%eax
80101dad:	83 c8 01             	or     $0x1,%eax
80101db0:	89 c2                	mov    %eax,%edx
80101db2:	8b 45 08             	mov    0x8(%ebp),%eax
80101db5:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101db8:	83 ec 0c             	sub    $0xc,%esp
80101dbb:	68 80 32 11 80       	push   $0x80113280
80101dc0:	e8 26 4b 00 00       	call   801068eb <release>
80101dc5:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101dc8:	83 ec 0c             	sub    $0xc,%esp
80101dcb:	ff 75 08             	pushl  0x8(%ebp)
80101dce:	e8 a8 01 00 00       	call   80101f7b <itrunc>
80101dd3:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101dd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd9:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	ff 75 08             	pushl  0x8(%ebp)
80101de5:	e8 63 fb ff ff       	call   8010194d <iupdate>
80101dea:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101ded:	83 ec 0c             	sub    $0xc,%esp
80101df0:	68 80 32 11 80       	push   $0x80113280
80101df5:	e8 8a 4a 00 00       	call   80106884 <acquire>
80101dfa:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101dfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101e00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101e07:	83 ec 0c             	sub    $0xc,%esp
80101e0a:	ff 75 08             	pushl  0x8(%ebp)
80101e0d:	e8 c4 3e 00 00       	call   80105cd6 <wakeup>
80101e12:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101e15:	8b 45 08             	mov    0x8(%ebp),%eax
80101e18:	8b 40 08             	mov    0x8(%eax),%eax
80101e1b:	8d 50 ff             	lea    -0x1(%eax),%edx
80101e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101e21:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101e24:	83 ec 0c             	sub    $0xc,%esp
80101e27:	68 80 32 11 80       	push   $0x80113280
80101e2c:	e8 ba 4a 00 00       	call   801068eb <release>
80101e31:	83 c4 10             	add    $0x10,%esp
}
80101e34:	90                   	nop
80101e35:	c9                   	leave  
80101e36:	c3                   	ret    

80101e37 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101e37:	55                   	push   %ebp
80101e38:	89 e5                	mov    %esp,%ebp
80101e3a:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101e3d:	83 ec 0c             	sub    $0xc,%esp
80101e40:	ff 75 08             	pushl  0x8(%ebp)
80101e43:	e8 8d fe ff ff       	call   80101cd5 <iunlock>
80101e48:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101e4b:	83 ec 0c             	sub    $0xc,%esp
80101e4e:	ff 75 08             	pushl  0x8(%ebp)
80101e51:	e8 f1 fe ff ff       	call   80101d47 <iput>
80101e56:	83 c4 10             	add    $0x10,%esp
}
80101e59:	90                   	nop
80101e5a:	c9                   	leave  
80101e5b:	c3                   	ret    

80101e5c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101e5c:	55                   	push   %ebp
80101e5d:	89 e5                	mov    %esp,%ebp
80101e5f:	53                   	push   %ebx
80101e60:	83 ec 14             	sub    $0x14,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101e63:	83 7d 0c 09          	cmpl   $0x9,0xc(%ebp)
80101e67:	77 42                	ja     80101eab <bmap+0x4f>
    if((addr = ip->addrs[bn]) == 0)
80101e69:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e6f:	83 c2 08             	add    $0x8,%edx
80101e72:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101e7d:	75 24                	jne    80101ea3 <bmap+0x47>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101e7f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e82:	8b 00                	mov    (%eax),%eax
80101e84:	83 ec 0c             	sub    $0xc,%esp
80101e87:	50                   	push   %eax
80101e88:	e8 2e f7 ff ff       	call   801015bb <balloc>
80101e8d:	83 c4 10             	add    $0x10,%esp
80101e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101e93:	8b 45 08             	mov    0x8(%ebp),%eax
80101e96:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e99:	8d 4a 08             	lea    0x8(%edx),%ecx
80101e9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101e9f:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    return addr;
80101ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ea6:	e9 cb 00 00 00       	jmp    80101f76 <bmap+0x11a>
  }
  bn -= NDIRECT;
80101eab:	83 6d 0c 0a          	subl   $0xa,0xc(%ebp)

  if(bn < NINDIRECT){
80101eaf:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101eb3:	0f 87 b0 00 00 00    	ja     80101f69 <bmap+0x10d>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101eb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebc:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ebf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ec2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101ec6:	75 1d                	jne    80101ee5 <bmap+0x89>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8b 00                	mov    (%eax),%eax
80101ecd:	83 ec 0c             	sub    $0xc,%esp
80101ed0:	50                   	push   %eax
80101ed1:	e8 e5 f6 ff ff       	call   801015bb <balloc>
80101ed6:	83 c4 10             	add    $0x10,%esp
80101ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101edc:	8b 45 08             	mov    0x8(%ebp),%eax
80101edf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ee2:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee8:	8b 00                	mov    (%eax),%eax
80101eea:	83 ec 08             	sub    $0x8,%esp
80101eed:	ff 75 f4             	pushl  -0xc(%ebp)
80101ef0:	50                   	push   %eax
80101ef1:	e8 c0 e2 ff ff       	call   801001b6 <bread>
80101ef6:	83 c4 10             	add    $0x10,%esp
80101ef9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101eff:	83 c0 18             	add    $0x18,%eax
80101f02:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101f05:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f08:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f12:	01 d0                	add    %edx,%eax
80101f14:	8b 00                	mov    (%eax),%eax
80101f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101f1d:	75 37                	jne    80101f56 <bmap+0xfa>
      a[bn] = addr = balloc(ip->dev);
80101f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f2c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f32:	8b 00                	mov    (%eax),%eax
80101f34:	83 ec 0c             	sub    $0xc,%esp
80101f37:	50                   	push   %eax
80101f38:	e8 7e f6 ff ff       	call   801015bb <balloc>
80101f3d:	83 c4 10             	add    $0x10,%esp
80101f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f46:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101f48:	83 ec 0c             	sub    $0xc,%esp
80101f4b:	ff 75 f0             	pushl  -0x10(%ebp)
80101f4e:	e8 67 1d 00 00       	call   80103cba <log_write>
80101f53:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101f56:	83 ec 0c             	sub    $0xc,%esp
80101f59:	ff 75 f0             	pushl  -0x10(%ebp)
80101f5c:	e8 cd e2 ff ff       	call   8010022e <brelse>
80101f61:	83 c4 10             	add    $0x10,%esp
    return addr;
80101f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f67:	eb 0d                	jmp    80101f76 <bmap+0x11a>
  }

  panic("bmap: out of range");
80101f69:	83 ec 0c             	sub    $0xc,%esp
80101f6c:	68 2c a2 10 80       	push   $0x8010a22c
80101f71:	e8 f0 e5 ff ff       	call   80100566 <panic>
}
80101f76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f79:	c9                   	leave  
80101f7a:	c3                   	ret    

80101f7b <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101f7b:	55                   	push   %ebp
80101f7c:	89 e5                	mov    %esp,%ebp
80101f7e:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101f81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f88:	eb 45                	jmp    80101fcf <itrunc+0x54>
    if(ip->addrs[i]){
80101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101f90:	83 c2 08             	add    $0x8,%edx
80101f93:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101f97:	85 c0                	test   %eax,%eax
80101f99:	74 30                	je     80101fcb <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101f9b:	8b 45 08             	mov    0x8(%ebp),%eax
80101f9e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101fa1:	83 c2 08             	add    $0x8,%edx
80101fa4:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80101fa8:	8b 55 08             	mov    0x8(%ebp),%edx
80101fab:	8b 12                	mov    (%edx),%edx
80101fad:	83 ec 08             	sub    $0x8,%esp
80101fb0:	50                   	push   %eax
80101fb1:	52                   	push   %edx
80101fb2:	e8 50 f7 ff ff       	call   80101707 <bfree>
80101fb7:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101fba:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101fc0:	83 c2 08             	add    $0x8,%edx
80101fc3:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
80101fca:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101fcb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101fcf:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80101fd3:	7e b5                	jle    80101f8a <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd8:	8b 40 4c             	mov    0x4c(%eax),%eax
80101fdb:	85 c0                	test   %eax,%eax
80101fdd:	0f 84 a1 00 00 00    	je     80102084 <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe6:	8b 50 4c             	mov    0x4c(%eax),%edx
80101fe9:	8b 45 08             	mov    0x8(%ebp),%eax
80101fec:	8b 00                	mov    (%eax),%eax
80101fee:	83 ec 08             	sub    $0x8,%esp
80101ff1:	52                   	push   %edx
80101ff2:	50                   	push   %eax
80101ff3:	e8 be e1 ff ff       	call   801001b6 <bread>
80101ff8:	83 c4 10             	add    $0x10,%esp
80101ffb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101ffe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102001:	83 c0 18             	add    $0x18,%eax
80102004:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80102007:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010200e:	eb 3c                	jmp    8010204c <itrunc+0xd1>
      if(a[j])
80102010:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102013:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010201a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010201d:	01 d0                	add    %edx,%eax
8010201f:	8b 00                	mov    (%eax),%eax
80102021:	85 c0                	test   %eax,%eax
80102023:	74 23                	je     80102048 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80102025:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102028:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010202f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102032:	01 d0                	add    %edx,%eax
80102034:	8b 00                	mov    (%eax),%eax
80102036:	8b 55 08             	mov    0x8(%ebp),%edx
80102039:	8b 12                	mov    (%edx),%edx
8010203b:	83 ec 08             	sub    $0x8,%esp
8010203e:	50                   	push   %eax
8010203f:	52                   	push   %edx
80102040:	e8 c2 f6 ff ff       	call   80101707 <bfree>
80102045:	83 c4 10             	add    $0x10,%esp
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80102048:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010204c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010204f:	83 f8 7f             	cmp    $0x7f,%eax
80102052:	76 bc                	jbe    80102010 <itrunc+0x95>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80102054:	83 ec 0c             	sub    $0xc,%esp
80102057:	ff 75 ec             	pushl  -0x14(%ebp)
8010205a:	e8 cf e1 ff ff       	call   8010022e <brelse>
8010205f:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80102062:	8b 45 08             	mov    0x8(%ebp),%eax
80102065:	8b 40 4c             	mov    0x4c(%eax),%eax
80102068:	8b 55 08             	mov    0x8(%ebp),%edx
8010206b:	8b 12                	mov    (%edx),%edx
8010206d:	83 ec 08             	sub    $0x8,%esp
80102070:	50                   	push   %eax
80102071:	52                   	push   %edx
80102072:	e8 90 f6 ff ff       	call   80101707 <bfree>
80102077:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
8010207a:	8b 45 08             	mov    0x8(%ebp),%eax
8010207d:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80102084:	8b 45 08             	mov    0x8(%ebp),%eax
80102087:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)
  iupdate(ip);
8010208e:	83 ec 0c             	sub    $0xc,%esp
80102091:	ff 75 08             	pushl  0x8(%ebp)
80102094:	e8 b4 f8 ff ff       	call   8010194d <iupdate>
80102099:	83 c4 10             	add    $0x10,%esp
}
8010209c:	90                   	nop
8010209d:	c9                   	leave  
8010209e:	c3                   	ret    

8010209f <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
8010209f:	55                   	push   %ebp
801020a0:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
801020a2:	8b 45 08             	mov    0x8(%ebp),%eax
801020a5:	8b 00                	mov    (%eax),%eax
801020a7:	89 c2                	mov    %eax,%edx
801020a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801020ac:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
801020af:	8b 45 08             	mov    0x8(%ebp),%eax
801020b2:	8b 50 04             	mov    0x4(%eax),%edx
801020b5:	8b 45 0c             	mov    0xc(%ebp),%eax
801020b8:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
801020bb:	8b 45 08             	mov    0x8(%ebp),%eax
801020be:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801020c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801020c5:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
801020c8:	8b 45 08             	mov    0x8(%ebp),%eax
801020cb:	0f b7 50 16          	movzwl 0x16(%eax),%edx
801020cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801020d2:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
801020d6:	8b 45 08             	mov    0x8(%ebp),%eax
801020d9:	8b 50 20             	mov    0x20(%eax),%edx
801020dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801020df:	89 50 18             	mov    %edx,0x18(%eax)

  #ifdef CS333_P5
  st->mode.asInt = ip->mode.asInt;
801020e2:	8b 45 08             	mov    0x8(%ebp),%eax
801020e5:	8b 50 1c             	mov    0x1c(%eax),%edx
801020e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801020eb:	89 50 14             	mov    %edx,0x14(%eax)
  st->uid = ip->uid;
801020ee:	8b 45 08             	mov    0x8(%ebp),%eax
801020f1:	0f b7 50 18          	movzwl 0x18(%eax),%edx
801020f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f8:	66 89 50 0e          	mov    %dx,0xe(%eax)
  st->gid = ip->gid;
801020fc:	8b 45 08             	mov    0x8(%ebp),%eax
801020ff:	0f b7 50 1a          	movzwl 0x1a(%eax),%edx
80102103:	8b 45 0c             	mov    0xc(%ebp),%eax
80102106:	66 89 50 10          	mov    %dx,0x10(%eax)
  #endif
}
8010210a:	90                   	nop
8010210b:	5d                   	pop    %ebp
8010210c:	c3                   	ret    

8010210d <readi>:

// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010210d:	55                   	push   %ebp
8010210e:	89 e5                	mov    %esp,%ebp
80102110:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80102113:	8b 45 08             	mov    0x8(%ebp),%eax
80102116:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010211a:	66 83 f8 03          	cmp    $0x3,%ax
8010211e:	75 5c                	jne    8010217c <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80102120:	8b 45 08             	mov    0x8(%ebp),%eax
80102123:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102127:	66 85 c0             	test   %ax,%ax
8010212a:	78 20                	js     8010214c <readi+0x3f>
8010212c:	8b 45 08             	mov    0x8(%ebp),%eax
8010212f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102133:	66 83 f8 09          	cmp    $0x9,%ax
80102137:	7f 13                	jg     8010214c <readi+0x3f>
80102139:	8b 45 08             	mov    0x8(%ebp),%eax
8010213c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102140:	98                   	cwtl   
80102141:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
80102148:	85 c0                	test   %eax,%eax
8010214a:	75 0a                	jne    80102156 <readi+0x49>
      return -1;
8010214c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102151:	e9 0c 01 00 00       	jmp    80102262 <readi+0x155>
    return devsw[ip->major].read(ip, dst, n);
80102156:	8b 45 08             	mov    0x8(%ebp),%eax
80102159:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010215d:	98                   	cwtl   
8010215e:	8b 04 c5 00 32 11 80 	mov    -0x7feece00(,%eax,8),%eax
80102165:	8b 55 14             	mov    0x14(%ebp),%edx
80102168:	83 ec 04             	sub    $0x4,%esp
8010216b:	52                   	push   %edx
8010216c:	ff 75 0c             	pushl  0xc(%ebp)
8010216f:	ff 75 08             	pushl  0x8(%ebp)
80102172:	ff d0                	call   *%eax
80102174:	83 c4 10             	add    $0x10,%esp
80102177:	e9 e6 00 00 00       	jmp    80102262 <readi+0x155>
  }

  if(off > ip->size || off + n < off)
8010217c:	8b 45 08             	mov    0x8(%ebp),%eax
8010217f:	8b 40 20             	mov    0x20(%eax),%eax
80102182:	3b 45 10             	cmp    0x10(%ebp),%eax
80102185:	72 0d                	jb     80102194 <readi+0x87>
80102187:	8b 55 10             	mov    0x10(%ebp),%edx
8010218a:	8b 45 14             	mov    0x14(%ebp),%eax
8010218d:	01 d0                	add    %edx,%eax
8010218f:	3b 45 10             	cmp    0x10(%ebp),%eax
80102192:	73 0a                	jae    8010219e <readi+0x91>
    return -1;
80102194:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102199:	e9 c4 00 00 00       	jmp    80102262 <readi+0x155>
  if(off + n > ip->size)
8010219e:	8b 55 10             	mov    0x10(%ebp),%edx
801021a1:	8b 45 14             	mov    0x14(%ebp),%eax
801021a4:	01 c2                	add    %eax,%edx
801021a6:	8b 45 08             	mov    0x8(%ebp),%eax
801021a9:	8b 40 20             	mov    0x20(%eax),%eax
801021ac:	39 c2                	cmp    %eax,%edx
801021ae:	76 0c                	jbe    801021bc <readi+0xaf>
    n = ip->size - off;
801021b0:	8b 45 08             	mov    0x8(%ebp),%eax
801021b3:	8b 40 20             	mov    0x20(%eax),%eax
801021b6:	2b 45 10             	sub    0x10(%ebp),%eax
801021b9:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801021bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021c3:	e9 8b 00 00 00       	jmp    80102253 <readi+0x146>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801021c8:	8b 45 10             	mov    0x10(%ebp),%eax
801021cb:	c1 e8 09             	shr    $0x9,%eax
801021ce:	83 ec 08             	sub    $0x8,%esp
801021d1:	50                   	push   %eax
801021d2:	ff 75 08             	pushl  0x8(%ebp)
801021d5:	e8 82 fc ff ff       	call   80101e5c <bmap>
801021da:	83 c4 10             	add    $0x10,%esp
801021dd:	89 c2                	mov    %eax,%edx
801021df:	8b 45 08             	mov    0x8(%ebp),%eax
801021e2:	8b 00                	mov    (%eax),%eax
801021e4:	83 ec 08             	sub    $0x8,%esp
801021e7:	52                   	push   %edx
801021e8:	50                   	push   %eax
801021e9:	e8 c8 df ff ff       	call   801001b6 <bread>
801021ee:	83 c4 10             	add    $0x10,%esp
801021f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
801021f4:	8b 45 10             	mov    0x10(%ebp),%eax
801021f7:	25 ff 01 00 00       	and    $0x1ff,%eax
801021fc:	ba 00 02 00 00       	mov    $0x200,%edx
80102201:	29 c2                	sub    %eax,%edx
80102203:	8b 45 14             	mov    0x14(%ebp),%eax
80102206:	2b 45 f4             	sub    -0xc(%ebp),%eax
80102209:	39 c2                	cmp    %eax,%edx
8010220b:	0f 46 c2             	cmovbe %edx,%eax
8010220e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80102211:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102214:	8d 50 18             	lea    0x18(%eax),%edx
80102217:	8b 45 10             	mov    0x10(%ebp),%eax
8010221a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010221f:	01 d0                	add    %edx,%eax
80102221:	83 ec 04             	sub    $0x4,%esp
80102224:	ff 75 ec             	pushl  -0x14(%ebp)
80102227:	50                   	push   %eax
80102228:	ff 75 0c             	pushl  0xc(%ebp)
8010222b:	e8 76 49 00 00       	call   80106ba6 <memmove>
80102230:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102233:	83 ec 0c             	sub    $0xc,%esp
80102236:	ff 75 f0             	pushl  -0x10(%ebp)
80102239:	e8 f0 df ff ff       	call   8010022e <brelse>
8010223e:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102241:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102244:	01 45 f4             	add    %eax,-0xc(%ebp)
80102247:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010224a:	01 45 10             	add    %eax,0x10(%ebp)
8010224d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102250:	01 45 0c             	add    %eax,0xc(%ebp)
80102253:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102256:	3b 45 14             	cmp    0x14(%ebp),%eax
80102259:	0f 82 69 ff ff ff    	jb     801021c8 <readi+0xbb>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
8010225f:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102262:	c9                   	leave  
80102263:	c3                   	ret    

80102264 <writei>:

// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102264:	55                   	push   %ebp
80102265:	89 e5                	mov    %esp,%ebp
80102267:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010226a:	8b 45 08             	mov    0x8(%ebp),%eax
8010226d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102271:	66 83 f8 03          	cmp    $0x3,%ax
80102275:	75 5c                	jne    801022d3 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102277:	8b 45 08             	mov    0x8(%ebp),%eax
8010227a:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010227e:	66 85 c0             	test   %ax,%ax
80102281:	78 20                	js     801022a3 <writei+0x3f>
80102283:	8b 45 08             	mov    0x8(%ebp),%eax
80102286:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010228a:	66 83 f8 09          	cmp    $0x9,%ax
8010228e:	7f 13                	jg     801022a3 <writei+0x3f>
80102290:	8b 45 08             	mov    0x8(%ebp),%eax
80102293:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102297:	98                   	cwtl   
80102298:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
8010229f:	85 c0                	test   %eax,%eax
801022a1:	75 0a                	jne    801022ad <writei+0x49>
      return -1;
801022a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022a8:	e9 3d 01 00 00       	jmp    801023ea <writei+0x186>
    return devsw[ip->major].write(ip, src, n);
801022ad:	8b 45 08             	mov    0x8(%ebp),%eax
801022b0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
801022b4:	98                   	cwtl   
801022b5:	8b 04 c5 04 32 11 80 	mov    -0x7feecdfc(,%eax,8),%eax
801022bc:	8b 55 14             	mov    0x14(%ebp),%edx
801022bf:	83 ec 04             	sub    $0x4,%esp
801022c2:	52                   	push   %edx
801022c3:	ff 75 0c             	pushl  0xc(%ebp)
801022c6:	ff 75 08             	pushl  0x8(%ebp)
801022c9:	ff d0                	call   *%eax
801022cb:	83 c4 10             	add    $0x10,%esp
801022ce:	e9 17 01 00 00       	jmp    801023ea <writei+0x186>
  }

  if(off > ip->size || off + n < off)
801022d3:	8b 45 08             	mov    0x8(%ebp),%eax
801022d6:	8b 40 20             	mov    0x20(%eax),%eax
801022d9:	3b 45 10             	cmp    0x10(%ebp),%eax
801022dc:	72 0d                	jb     801022eb <writei+0x87>
801022de:	8b 55 10             	mov    0x10(%ebp),%edx
801022e1:	8b 45 14             	mov    0x14(%ebp),%eax
801022e4:	01 d0                	add    %edx,%eax
801022e6:	3b 45 10             	cmp    0x10(%ebp),%eax
801022e9:	73 0a                	jae    801022f5 <writei+0x91>
    return -1;
801022eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022f0:	e9 f5 00 00 00       	jmp    801023ea <writei+0x186>
  if(off + n > MAXFILE*BSIZE)
801022f5:	8b 55 10             	mov    0x10(%ebp),%edx
801022f8:	8b 45 14             	mov    0x14(%ebp),%eax
801022fb:	01 d0                	add    %edx,%eax
801022fd:	3d 00 14 01 00       	cmp    $0x11400,%eax
80102302:	76 0a                	jbe    8010230e <writei+0xaa>
    return -1;
80102304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102309:	e9 dc 00 00 00       	jmp    801023ea <writei+0x186>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010230e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102315:	e9 99 00 00 00       	jmp    801023b3 <writei+0x14f>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010231a:	8b 45 10             	mov    0x10(%ebp),%eax
8010231d:	c1 e8 09             	shr    $0x9,%eax
80102320:	83 ec 08             	sub    $0x8,%esp
80102323:	50                   	push   %eax
80102324:	ff 75 08             	pushl  0x8(%ebp)
80102327:	e8 30 fb ff ff       	call   80101e5c <bmap>
8010232c:	83 c4 10             	add    $0x10,%esp
8010232f:	89 c2                	mov    %eax,%edx
80102331:	8b 45 08             	mov    0x8(%ebp),%eax
80102334:	8b 00                	mov    (%eax),%eax
80102336:	83 ec 08             	sub    $0x8,%esp
80102339:	52                   	push   %edx
8010233a:	50                   	push   %eax
8010233b:	e8 76 de ff ff       	call   801001b6 <bread>
80102340:	83 c4 10             	add    $0x10,%esp
80102343:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102346:	8b 45 10             	mov    0x10(%ebp),%eax
80102349:	25 ff 01 00 00       	and    $0x1ff,%eax
8010234e:	ba 00 02 00 00       	mov    $0x200,%edx
80102353:	29 c2                	sub    %eax,%edx
80102355:	8b 45 14             	mov    0x14(%ebp),%eax
80102358:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010235b:	39 c2                	cmp    %eax,%edx
8010235d:	0f 46 c2             	cmovbe %edx,%eax
80102360:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102363:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102366:	8d 50 18             	lea    0x18(%eax),%edx
80102369:	8b 45 10             	mov    0x10(%ebp),%eax
8010236c:	25 ff 01 00 00       	and    $0x1ff,%eax
80102371:	01 d0                	add    %edx,%eax
80102373:	83 ec 04             	sub    $0x4,%esp
80102376:	ff 75 ec             	pushl  -0x14(%ebp)
80102379:	ff 75 0c             	pushl  0xc(%ebp)
8010237c:	50                   	push   %eax
8010237d:	e8 24 48 00 00       	call   80106ba6 <memmove>
80102382:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102385:	83 ec 0c             	sub    $0xc,%esp
80102388:	ff 75 f0             	pushl  -0x10(%ebp)
8010238b:	e8 2a 19 00 00       	call   80103cba <log_write>
80102390:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102393:	83 ec 0c             	sub    $0xc,%esp
80102396:	ff 75 f0             	pushl  -0x10(%ebp)
80102399:	e8 90 de ff ff       	call   8010022e <brelse>
8010239e:	83 c4 10             	add    $0x10,%esp
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801023a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023a4:	01 45 f4             	add    %eax,-0xc(%ebp)
801023a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023aa:	01 45 10             	add    %eax,0x10(%ebp)
801023ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
801023b0:	01 45 0c             	add    %eax,0xc(%ebp)
801023b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b6:	3b 45 14             	cmp    0x14(%ebp),%eax
801023b9:	0f 82 5b ff ff ff    	jb     8010231a <writei+0xb6>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
801023bf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801023c3:	74 22                	je     801023e7 <writei+0x183>
801023c5:	8b 45 08             	mov    0x8(%ebp),%eax
801023c8:	8b 40 20             	mov    0x20(%eax),%eax
801023cb:	3b 45 10             	cmp    0x10(%ebp),%eax
801023ce:	73 17                	jae    801023e7 <writei+0x183>
    ip->size = off;
801023d0:	8b 45 08             	mov    0x8(%ebp),%eax
801023d3:	8b 55 10             	mov    0x10(%ebp),%edx
801023d6:	89 50 20             	mov    %edx,0x20(%eax)
    iupdate(ip);
801023d9:	83 ec 0c             	sub    $0xc,%esp
801023dc:	ff 75 08             	pushl  0x8(%ebp)
801023df:	e8 69 f5 ff ff       	call   8010194d <iupdate>
801023e4:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801023e7:	8b 45 14             	mov    0x14(%ebp),%eax
}
801023ea:	c9                   	leave  
801023eb:	c3                   	ret    

801023ec <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
801023ec:	55                   	push   %ebp
801023ed:	89 e5                	mov    %esp,%ebp
801023ef:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801023f2:	83 ec 04             	sub    $0x4,%esp
801023f5:	6a 0e                	push   $0xe
801023f7:	ff 75 0c             	pushl  0xc(%ebp)
801023fa:	ff 75 08             	pushl  0x8(%ebp)
801023fd:	e8 3a 48 00 00       	call   80106c3c <strncmp>
80102402:	83 c4 10             	add    $0x10,%esp
}
80102405:	c9                   	leave  
80102406:	c3                   	ret    

80102407 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102407:	55                   	push   %ebp
80102408:	89 e5                	mov    %esp,%ebp
8010240a:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
8010240d:	8b 45 08             	mov    0x8(%ebp),%eax
80102410:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102414:	66 83 f8 01          	cmp    $0x1,%ax
80102418:	74 0d                	je     80102427 <dirlookup+0x20>
    panic("dirlookup not DIR");
8010241a:	83 ec 0c             	sub    $0xc,%esp
8010241d:	68 3f a2 10 80       	push   $0x8010a23f
80102422:	e8 3f e1 ff ff       	call   80100566 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102427:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010242e:	eb 7b                	jmp    801024ab <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102430:	6a 10                	push   $0x10
80102432:	ff 75 f4             	pushl  -0xc(%ebp)
80102435:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102438:	50                   	push   %eax
80102439:	ff 75 08             	pushl  0x8(%ebp)
8010243c:	e8 cc fc ff ff       	call   8010210d <readi>
80102441:	83 c4 10             	add    $0x10,%esp
80102444:	83 f8 10             	cmp    $0x10,%eax
80102447:	74 0d                	je     80102456 <dirlookup+0x4f>
      panic("dirlink read");
80102449:	83 ec 0c             	sub    $0xc,%esp
8010244c:	68 51 a2 10 80       	push   $0x8010a251
80102451:	e8 10 e1 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
80102456:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010245a:	66 85 c0             	test   %ax,%ax
8010245d:	74 47                	je     801024a6 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010245f:	83 ec 08             	sub    $0x8,%esp
80102462:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102465:	83 c0 02             	add    $0x2,%eax
80102468:	50                   	push   %eax
80102469:	ff 75 0c             	pushl  0xc(%ebp)
8010246c:	e8 7b ff ff ff       	call   801023ec <namecmp>
80102471:	83 c4 10             	add    $0x10,%esp
80102474:	85 c0                	test   %eax,%eax
80102476:	75 2f                	jne    801024a7 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102478:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010247c:	74 08                	je     80102486 <dirlookup+0x7f>
        *poff = off;
8010247e:	8b 45 10             	mov    0x10(%ebp),%eax
80102481:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102484:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102486:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010248a:	0f b7 c0             	movzwl %ax,%eax
8010248d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102490:	8b 45 08             	mov    0x8(%ebp),%eax
80102493:	8b 00                	mov    (%eax),%eax
80102495:	83 ec 08             	sub    $0x8,%esp
80102498:	ff 75 f0             	pushl  -0x10(%ebp)
8010249b:	50                   	push   %eax
8010249c:	e8 95 f5 ff ff       	call   80101a36 <iget>
801024a1:	83 c4 10             	add    $0x10,%esp
801024a4:	eb 19                	jmp    801024bf <dirlookup+0xb8>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
801024a6:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
801024a7:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801024ab:	8b 45 08             	mov    0x8(%ebp),%eax
801024ae:	8b 40 20             	mov    0x20(%eax),%eax
801024b1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801024b4:	0f 87 76 ff ff ff    	ja     80102430 <dirlookup+0x29>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
801024ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
801024bf:	c9                   	leave  
801024c0:	c3                   	ret    

801024c1 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801024c1:	55                   	push   %ebp
801024c2:	89 e5                	mov    %esp,%ebp
801024c4:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801024c7:	83 ec 04             	sub    $0x4,%esp
801024ca:	6a 00                	push   $0x0
801024cc:	ff 75 0c             	pushl  0xc(%ebp)
801024cf:	ff 75 08             	pushl  0x8(%ebp)
801024d2:	e8 30 ff ff ff       	call   80102407 <dirlookup>
801024d7:	83 c4 10             	add    $0x10,%esp
801024da:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024e1:	74 18                	je     801024fb <dirlink+0x3a>
    iput(ip);
801024e3:	83 ec 0c             	sub    $0xc,%esp
801024e6:	ff 75 f0             	pushl  -0x10(%ebp)
801024e9:	e8 59 f8 ff ff       	call   80101d47 <iput>
801024ee:	83 c4 10             	add    $0x10,%esp
    return -1;
801024f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801024f6:	e9 9c 00 00 00       	jmp    80102597 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801024fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102502:	eb 39                	jmp    8010253d <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102507:	6a 10                	push   $0x10
80102509:	50                   	push   %eax
8010250a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010250d:	50                   	push   %eax
8010250e:	ff 75 08             	pushl  0x8(%ebp)
80102511:	e8 f7 fb ff ff       	call   8010210d <readi>
80102516:	83 c4 10             	add    $0x10,%esp
80102519:	83 f8 10             	cmp    $0x10,%eax
8010251c:	74 0d                	je     8010252b <dirlink+0x6a>
      panic("dirlink read");
8010251e:	83 ec 0c             	sub    $0xc,%esp
80102521:	68 51 a2 10 80       	push   $0x8010a251
80102526:	e8 3b e0 ff ff       	call   80100566 <panic>
    if(de.inum == 0)
8010252b:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010252f:	66 85 c0             	test   %ax,%ax
80102532:	74 18                	je     8010254c <dirlink+0x8b>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102537:	83 c0 10             	add    $0x10,%eax
8010253a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010253d:	8b 45 08             	mov    0x8(%ebp),%eax
80102540:	8b 50 20             	mov    0x20(%eax),%edx
80102543:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102546:	39 c2                	cmp    %eax,%edx
80102548:	77 ba                	ja     80102504 <dirlink+0x43>
8010254a:	eb 01                	jmp    8010254d <dirlink+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
8010254c:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010254d:	83 ec 04             	sub    $0x4,%esp
80102550:	6a 0e                	push   $0xe
80102552:	ff 75 0c             	pushl  0xc(%ebp)
80102555:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102558:	83 c0 02             	add    $0x2,%eax
8010255b:	50                   	push   %eax
8010255c:	e8 31 47 00 00       	call   80106c92 <strncpy>
80102561:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102564:	8b 45 10             	mov    0x10(%ebp),%eax
80102567:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010256e:	6a 10                	push   $0x10
80102570:	50                   	push   %eax
80102571:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102574:	50                   	push   %eax
80102575:	ff 75 08             	pushl  0x8(%ebp)
80102578:	e8 e7 fc ff ff       	call   80102264 <writei>
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	83 f8 10             	cmp    $0x10,%eax
80102583:	74 0d                	je     80102592 <dirlink+0xd1>
    panic("dirlink");
80102585:	83 ec 0c             	sub    $0xc,%esp
80102588:	68 5e a2 10 80       	push   $0x8010a25e
8010258d:	e8 d4 df ff ff       	call   80100566 <panic>
  
  return 0;
80102592:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102597:	c9                   	leave  
80102598:	c3                   	ret    

80102599 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102599:	55                   	push   %ebp
8010259a:	89 e5                	mov    %esp,%ebp
8010259c:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010259f:	eb 04                	jmp    801025a5 <skipelem+0xc>
    path++;
801025a1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
801025a5:	8b 45 08             	mov    0x8(%ebp),%eax
801025a8:	0f b6 00             	movzbl (%eax),%eax
801025ab:	3c 2f                	cmp    $0x2f,%al
801025ad:	74 f2                	je     801025a1 <skipelem+0x8>
    path++;
  if(*path == 0)
801025af:	8b 45 08             	mov    0x8(%ebp),%eax
801025b2:	0f b6 00             	movzbl (%eax),%eax
801025b5:	84 c0                	test   %al,%al
801025b7:	75 07                	jne    801025c0 <skipelem+0x27>
    return 0;
801025b9:	b8 00 00 00 00       	mov    $0x0,%eax
801025be:	eb 7b                	jmp    8010263b <skipelem+0xa2>
  s = path;
801025c0:	8b 45 08             	mov    0x8(%ebp),%eax
801025c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801025c6:	eb 04                	jmp    801025cc <skipelem+0x33>
    path++;
801025c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801025cc:	8b 45 08             	mov    0x8(%ebp),%eax
801025cf:	0f b6 00             	movzbl (%eax),%eax
801025d2:	3c 2f                	cmp    $0x2f,%al
801025d4:	74 0a                	je     801025e0 <skipelem+0x47>
801025d6:	8b 45 08             	mov    0x8(%ebp),%eax
801025d9:	0f b6 00             	movzbl (%eax),%eax
801025dc:	84 c0                	test   %al,%al
801025de:	75 e8                	jne    801025c8 <skipelem+0x2f>
    path++;
  len = path - s;
801025e0:	8b 55 08             	mov    0x8(%ebp),%edx
801025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801025e6:	29 c2                	sub    %eax,%edx
801025e8:	89 d0                	mov    %edx,%eax
801025ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801025ed:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801025f1:	7e 15                	jle    80102608 <skipelem+0x6f>
    memmove(name, s, DIRSIZ);
801025f3:	83 ec 04             	sub    $0x4,%esp
801025f6:	6a 0e                	push   $0xe
801025f8:	ff 75 f4             	pushl  -0xc(%ebp)
801025fb:	ff 75 0c             	pushl  0xc(%ebp)
801025fe:	e8 a3 45 00 00       	call   80106ba6 <memmove>
80102603:	83 c4 10             	add    $0x10,%esp
80102606:	eb 26                	jmp    8010262e <skipelem+0x95>
  else {
    memmove(name, s, len);
80102608:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010260b:	83 ec 04             	sub    $0x4,%esp
8010260e:	50                   	push   %eax
8010260f:	ff 75 f4             	pushl  -0xc(%ebp)
80102612:	ff 75 0c             	pushl  0xc(%ebp)
80102615:	e8 8c 45 00 00       	call   80106ba6 <memmove>
8010261a:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
8010261d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102620:	8b 45 0c             	mov    0xc(%ebp),%eax
80102623:	01 d0                	add    %edx,%eax
80102625:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102628:	eb 04                	jmp    8010262e <skipelem+0x95>
    path++;
8010262a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010262e:	8b 45 08             	mov    0x8(%ebp),%eax
80102631:	0f b6 00             	movzbl (%eax),%eax
80102634:	3c 2f                	cmp    $0x2f,%al
80102636:	74 f2                	je     8010262a <skipelem+0x91>
    path++;
  return path;
80102638:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010263b:	c9                   	leave  
8010263c:	c3                   	ret    

8010263d <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
8010263d:	55                   	push   %ebp
8010263e:	89 e5                	mov    %esp,%ebp
80102640:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102643:	8b 45 08             	mov    0x8(%ebp),%eax
80102646:	0f b6 00             	movzbl (%eax),%eax
80102649:	3c 2f                	cmp    $0x2f,%al
8010264b:	75 17                	jne    80102664 <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
8010264d:	83 ec 08             	sub    $0x8,%esp
80102650:	6a 01                	push   $0x1
80102652:	6a 01                	push   $0x1
80102654:	e8 dd f3 ff ff       	call   80101a36 <iget>
80102659:	83 c4 10             	add    $0x10,%esp
8010265c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010265f:	e9 bb 00 00 00       	jmp    8010271f <namex+0xe2>
  else
    ip = idup(proc->cwd);
80102664:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010266a:	8b 40 68             	mov    0x68(%eax),%eax
8010266d:	83 ec 0c             	sub    $0xc,%esp
80102670:	50                   	push   %eax
80102671:	e8 9f f4 ff ff       	call   80101b15 <idup>
80102676:	83 c4 10             	add    $0x10,%esp
80102679:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
8010267c:	e9 9e 00 00 00       	jmp    8010271f <namex+0xe2>
    ilock(ip);
80102681:	83 ec 0c             	sub    $0xc,%esp
80102684:	ff 75 f4             	pushl  -0xc(%ebp)
80102687:	e8 c3 f4 ff ff       	call   80101b4f <ilock>
8010268c:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102692:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102696:	66 83 f8 01          	cmp    $0x1,%ax
8010269a:	74 18                	je     801026b4 <namex+0x77>
      iunlockput(ip);
8010269c:	83 ec 0c             	sub    $0xc,%esp
8010269f:	ff 75 f4             	pushl  -0xc(%ebp)
801026a2:	e8 90 f7 ff ff       	call   80101e37 <iunlockput>
801026a7:	83 c4 10             	add    $0x10,%esp
      return 0;
801026aa:	b8 00 00 00 00       	mov    $0x0,%eax
801026af:	e9 a7 00 00 00       	jmp    8010275b <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
801026b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801026b8:	74 20                	je     801026da <namex+0x9d>
801026ba:	8b 45 08             	mov    0x8(%ebp),%eax
801026bd:	0f b6 00             	movzbl (%eax),%eax
801026c0:	84 c0                	test   %al,%al
801026c2:	75 16                	jne    801026da <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
801026c4:	83 ec 0c             	sub    $0xc,%esp
801026c7:	ff 75 f4             	pushl  -0xc(%ebp)
801026ca:	e8 06 f6 ff ff       	call   80101cd5 <iunlock>
801026cf:	83 c4 10             	add    $0x10,%esp
      return ip;
801026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026d5:	e9 81 00 00 00       	jmp    8010275b <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801026da:	83 ec 04             	sub    $0x4,%esp
801026dd:	6a 00                	push   $0x0
801026df:	ff 75 10             	pushl  0x10(%ebp)
801026e2:	ff 75 f4             	pushl  -0xc(%ebp)
801026e5:	e8 1d fd ff ff       	call   80102407 <dirlookup>
801026ea:	83 c4 10             	add    $0x10,%esp
801026ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
801026f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801026f4:	75 15                	jne    8010270b <namex+0xce>
      iunlockput(ip);
801026f6:	83 ec 0c             	sub    $0xc,%esp
801026f9:	ff 75 f4             	pushl  -0xc(%ebp)
801026fc:	e8 36 f7 ff ff       	call   80101e37 <iunlockput>
80102701:	83 c4 10             	add    $0x10,%esp
      return 0;
80102704:	b8 00 00 00 00       	mov    $0x0,%eax
80102709:	eb 50                	jmp    8010275b <namex+0x11e>
    }
    iunlockput(ip);
8010270b:	83 ec 0c             	sub    $0xc,%esp
8010270e:	ff 75 f4             	pushl  -0xc(%ebp)
80102711:	e8 21 f7 ff ff       	call   80101e37 <iunlockput>
80102716:	83 c4 10             	add    $0x10,%esp
    ip = next;
80102719:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010271c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010271f:	83 ec 08             	sub    $0x8,%esp
80102722:	ff 75 10             	pushl  0x10(%ebp)
80102725:	ff 75 08             	pushl  0x8(%ebp)
80102728:	e8 6c fe ff ff       	call   80102599 <skipelem>
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	89 45 08             	mov    %eax,0x8(%ebp)
80102733:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102737:	0f 85 44 ff ff ff    	jne    80102681 <namex+0x44>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
8010273d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102741:	74 15                	je     80102758 <namex+0x11b>
    iput(ip);
80102743:	83 ec 0c             	sub    $0xc,%esp
80102746:	ff 75 f4             	pushl  -0xc(%ebp)
80102749:	e8 f9 f5 ff ff       	call   80101d47 <iput>
8010274e:	83 c4 10             	add    $0x10,%esp
    return 0;
80102751:	b8 00 00 00 00       	mov    $0x0,%eax
80102756:	eb 03                	jmp    8010275b <namex+0x11e>
  }
  return ip;
80102758:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010275b:	c9                   	leave  
8010275c:	c3                   	ret    

8010275d <namei>:

struct inode*
namei(char *path)
{
8010275d:	55                   	push   %ebp
8010275e:	89 e5                	mov    %esp,%ebp
80102760:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102763:	83 ec 04             	sub    $0x4,%esp
80102766:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102769:	50                   	push   %eax
8010276a:	6a 00                	push   $0x0
8010276c:	ff 75 08             	pushl  0x8(%ebp)
8010276f:	e8 c9 fe ff ff       	call   8010263d <namex>
80102774:	83 c4 10             	add    $0x10,%esp
}
80102777:	c9                   	leave  
80102778:	c3                   	ret    

80102779 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102779:	55                   	push   %ebp
8010277a:	89 e5                	mov    %esp,%ebp
8010277c:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010277f:	83 ec 04             	sub    $0x4,%esp
80102782:	ff 75 0c             	pushl  0xc(%ebp)
80102785:	6a 01                	push   $0x1
80102787:	ff 75 08             	pushl  0x8(%ebp)
8010278a:	e8 ae fe ff ff       	call   8010263d <namex>
8010278f:	83 c4 10             	add    $0x10,%esp
}
80102792:	c9                   	leave  
80102793:	c3                   	ret    

80102794 <convert_to_mode>:

#ifdef CS333_P5
int
convert_to_mode(int val)
{
80102794:	55                   	push   %ebp
80102795:	89 e5                	mov    %esp,%ebp
80102797:	83 ec 10             	sub    $0x10,%esp
  if(val < 0 || val > 1777)
8010279a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010279e:	78 09                	js     801027a9 <convert_to_mode+0x15>
801027a0:	81 7d 08 f1 06 00 00 	cmpl   $0x6f1,0x8(%ebp)
801027a7:	7e 0a                	jle    801027b3 <convert_to_mode+0x1f>
    return -1;
801027a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801027ae:	e9 5a 01 00 00       	jmp    8010290d <convert_to_mode+0x179>

  int result = 0;
801027b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  // Use this for error checking
  int digit;

  // If the first digit is a 1, set the setuid digit
  // to 1. Otherwise, set it to 0.
  digit = (val / 1000) % 10;
801027ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027bd:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
801027c2:	89 c8                	mov    %ecx,%eax
801027c4:	f7 ea                	imul   %edx
801027c6:	c1 fa 06             	sar    $0x6,%edx
801027c9:	89 c8                	mov    %ecx,%eax
801027cb:	c1 f8 1f             	sar    $0x1f,%eax
801027ce:	89 d1                	mov    %edx,%ecx
801027d0:	29 c1                	sub    %eax,%ecx
801027d2:	ba 67 66 66 66       	mov    $0x66666667,%edx
801027d7:	89 c8                	mov    %ecx,%eax
801027d9:	f7 ea                	imul   %edx
801027db:	c1 fa 02             	sar    $0x2,%edx
801027de:	89 c8                	mov    %ecx,%eax
801027e0:	c1 f8 1f             	sar    $0x1f,%eax
801027e3:	29 c2                	sub    %eax,%edx
801027e5:	89 d0                	mov    %edx,%eax
801027e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
801027ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
801027ed:	89 d0                	mov    %edx,%eax
801027ef:	c1 e0 02             	shl    $0x2,%eax
801027f2:	01 d0                	add    %edx,%eax
801027f4:	01 c0                	add    %eax,%eax
801027f6:	29 c1                	sub    %eax,%ecx
801027f8:	89 c8                	mov    %ecx,%eax
801027fa:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(digit == 1)
801027fd:	83 7d f8 01          	cmpl   $0x1,-0x8(%ebp)
80102801:	75 09                	jne    8010280c <convert_to_mode+0x78>
    result ^= 0x200;
80102803:	81 75 fc 00 02 00 00 	xorl   $0x200,-0x4(%ebp)
8010280a:	eb 10                	jmp    8010281c <convert_to_mode+0x88>
  else if(digit != 0)
8010280c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
80102810:	74 0a                	je     8010281c <convert_to_mode+0x88>
    return -1;
80102812:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102817:	e9 f1 00 00 00       	jmp    8010290d <convert_to_mode+0x179>
  // Dividing by 100 nixes the first two digits in val,
  // leaving a number from 0 and 19 (the first digit in val is either
  // 0 or 1), We mod this by 10 to get the desired digit. Shifting by
  // 6 spots moves it to the correct place so that it lines up with
  // the flags in our mode.
  digit = (val / 100) % 10;
8010281c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010281f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80102824:	89 c8                	mov    %ecx,%eax
80102826:	f7 ea                	imul   %edx
80102828:	c1 fa 05             	sar    $0x5,%edx
8010282b:	89 c8                	mov    %ecx,%eax
8010282d:	c1 f8 1f             	sar    $0x1f,%eax
80102830:	89 d1                	mov    %edx,%ecx
80102832:	29 c1                	sub    %eax,%ecx
80102834:	ba 67 66 66 66       	mov    $0x66666667,%edx
80102839:	89 c8                	mov    %ecx,%eax
8010283b:	f7 ea                	imul   %edx
8010283d:	c1 fa 02             	sar    $0x2,%edx
80102840:	89 c8                	mov    %ecx,%eax
80102842:	c1 f8 1f             	sar    $0x1f,%eax
80102845:	29 c2                	sub    %eax,%edx
80102847:	89 d0                	mov    %edx,%eax
80102849:	89 45 f8             	mov    %eax,-0x8(%ebp)
8010284c:	8b 55 f8             	mov    -0x8(%ebp),%edx
8010284f:	89 d0                	mov    %edx,%eax
80102851:	c1 e0 02             	shl    $0x2,%eax
80102854:	01 d0                	add    %edx,%eax
80102856:	01 c0                	add    %eax,%eax
80102858:	29 c1                	sub    %eax,%ecx
8010285a:	89 c8                	mov    %ecx,%eax
8010285c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(digit > 7) return -1;
8010285f:	83 7d f8 07          	cmpl   $0x7,-0x8(%ebp)
80102863:	7e 0a                	jle    8010286f <convert_to_mode+0xdb>
80102865:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010286a:	e9 9e 00 00 00       	jmp    8010290d <convert_to_mode+0x179>
  result ^= digit << 6;
8010286f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102872:	c1 e0 06             	shl    $0x6,%eax
80102875:	31 45 fc             	xor    %eax,-0x4(%ebp)

  // Calculate the third digit
  digit = (val / 10) % 10;
80102878:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010287b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80102880:	89 c8                	mov    %ecx,%eax
80102882:	f7 ea                	imul   %edx
80102884:	c1 fa 02             	sar    $0x2,%edx
80102887:	89 c8                	mov    %ecx,%eax
80102889:	c1 f8 1f             	sar    $0x1f,%eax
8010288c:	89 d1                	mov    %edx,%ecx
8010288e:	29 c1                	sub    %eax,%ecx
80102890:	ba 67 66 66 66       	mov    $0x66666667,%edx
80102895:	89 c8                	mov    %ecx,%eax
80102897:	f7 ea                	imul   %edx
80102899:	c1 fa 02             	sar    $0x2,%edx
8010289c:	89 c8                	mov    %ecx,%eax
8010289e:	c1 f8 1f             	sar    $0x1f,%eax
801028a1:	29 c2                	sub    %eax,%edx
801028a3:	89 d0                	mov    %edx,%eax
801028a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
801028a8:	8b 55 f8             	mov    -0x8(%ebp),%edx
801028ab:	89 d0                	mov    %edx,%eax
801028ad:	c1 e0 02             	shl    $0x2,%eax
801028b0:	01 d0                	add    %edx,%eax
801028b2:	01 c0                	add    %eax,%eax
801028b4:	29 c1                	sub    %eax,%ecx
801028b6:	89 c8                	mov    %ecx,%eax
801028b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(digit > 7) return -1;
801028bb:	83 7d f8 07          	cmpl   $0x7,-0x8(%ebp)
801028bf:	7e 07                	jle    801028c8 <convert_to_mode+0x134>
801028c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801028c6:	eb 45                	jmp    8010290d <convert_to_mode+0x179>
  result ^= digit << 3;
801028c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801028cb:	c1 e0 03             	shl    $0x3,%eax
801028ce:	31 45 fc             	xor    %eax,-0x4(%ebp)

  // Calculate the last digit
  digit = val % 10;
801028d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
801028d4:	ba 67 66 66 66       	mov    $0x66666667,%edx
801028d9:	89 c8                	mov    %ecx,%eax
801028db:	f7 ea                	imul   %edx
801028dd:	c1 fa 02             	sar    $0x2,%edx
801028e0:	89 c8                	mov    %ecx,%eax
801028e2:	c1 f8 1f             	sar    $0x1f,%eax
801028e5:	29 c2                	sub    %eax,%edx
801028e7:	89 d0                	mov    %edx,%eax
801028e9:	c1 e0 02             	shl    $0x2,%eax
801028ec:	01 d0                	add    %edx,%eax
801028ee:	01 c0                	add    %eax,%eax
801028f0:	29 c1                	sub    %eax,%ecx
801028f2:	89 c8                	mov    %ecx,%eax
801028f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(digit > 7) return -1;
801028f7:	83 7d f8 07          	cmpl   $0x7,-0x8(%ebp)
801028fb:	7e 07                	jle    80102904 <convert_to_mode+0x170>
801028fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102902:	eb 09                	jmp    8010290d <convert_to_mode+0x179>
  result ^= digit;
80102904:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102907:	31 45 fc             	xor    %eax,-0x4(%ebp)

  return result;
8010290a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010290d:	c9                   	leave  
8010290e:	c3                   	ret    

8010290f <do_chmod>:

int
do_chmod(char* path, int mode)
{
8010290f:	55                   	push   %ebp
80102910:	89 e5                	mov    %esp,%ebp
80102912:	83 ec 18             	sub    $0x18,%esp
  struct inode* ip;

  mode = convert_to_mode(mode);
80102915:	ff 75 0c             	pushl  0xc(%ebp)
80102918:	e8 77 fe ff ff       	call   80102794 <convert_to_mode>
8010291d:	83 c4 04             	add    $0x4,%esp
80102920:	89 45 0c             	mov    %eax,0xc(%ebp)

  // The given mode was invalid.
  if(mode == -1)
80102923:	83 7d 0c ff          	cmpl   $0xffffffff,0xc(%ebp)
80102927:	75 07                	jne    80102930 <do_chmod+0x21>
    return -1;
80102929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010292e:	eb 60                	jmp    80102990 <do_chmod+0x81>

  begin_op();
80102930:	e8 4d 11 00 00       	call   80103a82 <begin_op>
  ip = namei(path);
80102935:	83 ec 0c             	sub    $0xc,%esp
80102938:	ff 75 08             	pushl  0x8(%ebp)
8010293b:	e8 1d fe ff ff       	call   8010275d <namei>
80102940:	83 c4 10             	add    $0x10,%esp
80102943:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(ip == 0)
80102946:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010294a:	75 07                	jne    80102953 <do_chmod+0x44>
	return -2;
8010294c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80102951:	eb 3d                	jmp    80102990 <do_chmod+0x81>

  ilock(ip);
80102953:	83 ec 0c             	sub    $0xc,%esp
80102956:	ff 75 f4             	pushl  -0xc(%ebp)
80102959:	e8 f1 f1 ff ff       	call   80101b4f <ilock>
8010295e:	83 c4 10             	add    $0x10,%esp

  ip->mode.asInt = mode;
80102961:	8b 55 0c             	mov    0xc(%ebp),%edx
80102964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102967:	89 50 1c             	mov    %edx,0x1c(%eax)
  iupdate(ip);
8010296a:	83 ec 0c             	sub    $0xc,%esp
8010296d:	ff 75 f4             	pushl  -0xc(%ebp)
80102970:	e8 d8 ef ff ff       	call   8010194d <iupdate>
80102975:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
80102978:	83 ec 0c             	sub    $0xc,%esp
8010297b:	ff 75 f4             	pushl  -0xc(%ebp)
8010297e:	e8 52 f3 ff ff       	call   80101cd5 <iunlock>
80102983:	83 c4 10             	add    $0x10,%esp

  end_op();
80102986:	e8 83 11 00 00       	call   80103b0e <end_op>

  return 0;
8010298b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102990:	c9                   	leave  
80102991:	c3                   	ret    

80102992 <do_chown>:

int
do_chown(char* path, int owner)
{
80102992:	55                   	push   %ebp
80102993:	89 e5                	mov    %esp,%ebp
80102995:	83 ec 18             	sub    $0x18,%esp
  struct inode* ip;

  if(MIN_UID_SIZE > owner || owner > MAX_UID_SIZE)
80102998:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010299c:	78 09                	js     801029a7 <do_chown+0x15>
8010299e:	81 7d 0c ff 7f 00 00 	cmpl   $0x7fff,0xc(%ebp)
801029a5:	7e 07                	jle    801029ae <do_chown+0x1c>
	  return -1;
801029a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801029ac:	eb 63                	jmp    80102a11 <do_chown+0x7f>

  begin_op();
801029ae:	e8 cf 10 00 00       	call   80103a82 <begin_op>
  ip = namei(path);
801029b3:	83 ec 0c             	sub    $0xc,%esp
801029b6:	ff 75 08             	pushl  0x8(%ebp)
801029b9:	e8 9f fd ff ff       	call   8010275d <namei>
801029be:	83 c4 10             	add    $0x10,%esp
801029c1:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(ip == 0)
801029c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801029c8:	75 07                	jne    801029d1 <do_chown+0x3f>
	return -1;
801029ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801029cf:	eb 40                	jmp    80102a11 <do_chown+0x7f>

  ilock(ip);
801029d1:	83 ec 0c             	sub    $0xc,%esp
801029d4:	ff 75 f4             	pushl  -0xc(%ebp)
801029d7:	e8 73 f1 ff ff       	call   80101b4f <ilock>
801029dc:	83 c4 10             	add    $0x10,%esp

  ip->uid = owner;
801029df:	8b 45 0c             	mov    0xc(%ebp),%eax
801029e2:	89 c2                	mov    %eax,%edx
801029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029e7:	66 89 50 18          	mov    %dx,0x18(%eax)
  iupdate(ip);
801029eb:	83 ec 0c             	sub    $0xc,%esp
801029ee:	ff 75 f4             	pushl  -0xc(%ebp)
801029f1:	e8 57 ef ff ff       	call   8010194d <iupdate>
801029f6:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
801029f9:	83 ec 0c             	sub    $0xc,%esp
801029fc:	ff 75 f4             	pushl  -0xc(%ebp)
801029ff:	e8 d1 f2 ff ff       	call   80101cd5 <iunlock>
80102a04:	83 c4 10             	add    $0x10,%esp

  end_op();
80102a07:	e8 02 11 00 00       	call   80103b0e <end_op>

  return 0;
80102a0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102a11:	c9                   	leave  
80102a12:	c3                   	ret    

80102a13 <do_chgrp>:

int
do_chgrp(char* path, int group)
{
80102a13:	55                   	push   %ebp
80102a14:	89 e5                	mov    %esp,%ebp
80102a16:	83 ec 18             	sub    $0x18,%esp
  struct inode* ip;

  if(MIN_GID_SIZE > group || group > MAX_GID_SIZE)
80102a19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102a1d:	78 09                	js     80102a28 <do_chgrp+0x15>
80102a1f:	81 7d 0c ff 7f 00 00 	cmpl   $0x7fff,0xc(%ebp)
80102a26:	7e 07                	jle    80102a2f <do_chgrp+0x1c>
	  return -1;
80102a28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102a2d:	eb 63                	jmp    80102a92 <do_chgrp+0x7f>

  begin_op();
80102a2f:	e8 4e 10 00 00       	call   80103a82 <begin_op>
  ip = namei(path);
80102a34:	83 ec 0c             	sub    $0xc,%esp
80102a37:	ff 75 08             	pushl  0x8(%ebp)
80102a3a:	e8 1e fd ff ff       	call   8010275d <namei>
80102a3f:	83 c4 10             	add    $0x10,%esp
80102a42:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(ip == 0)
80102a45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102a49:	75 07                	jne    80102a52 <do_chgrp+0x3f>
	return -1;
80102a4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102a50:	eb 40                	jmp    80102a92 <do_chgrp+0x7f>

  ilock(ip);
80102a52:	83 ec 0c             	sub    $0xc,%esp
80102a55:	ff 75 f4             	pushl  -0xc(%ebp)
80102a58:	e8 f2 f0 ff ff       	call   80101b4f <ilock>
80102a5d:	83 c4 10             	add    $0x10,%esp

  ip->gid = group;
80102a60:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a63:	89 c2                	mov    %eax,%edx
80102a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a68:	66 89 50 1a          	mov    %dx,0x1a(%eax)
  iupdate(ip);
80102a6c:	83 ec 0c             	sub    $0xc,%esp
80102a6f:	ff 75 f4             	pushl  -0xc(%ebp)
80102a72:	e8 d6 ee ff ff       	call   8010194d <iupdate>
80102a77:	83 c4 10             	add    $0x10,%esp

  iunlock(ip);
80102a7a:	83 ec 0c             	sub    $0xc,%esp
80102a7d:	ff 75 f4             	pushl  -0xc(%ebp)
80102a80:	e8 50 f2 ff ff       	call   80101cd5 <iunlock>
80102a85:	83 c4 10             	add    $0x10,%esp

  end_op();
80102a88:	e8 81 10 00 00       	call   80103b0e <end_op>

  return 0;
80102a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102a92:	c9                   	leave  
80102a93:	c3                   	ret    

80102a94 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102a94:	55                   	push   %ebp
80102a95:	89 e5                	mov    %esp,%ebp
80102a97:	83 ec 14             	sub    $0x14,%esp
80102a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80102a9d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102aa5:	89 c2                	mov    %eax,%edx
80102aa7:	ec                   	in     (%dx),%al
80102aa8:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102aab:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102aaf:	c9                   	leave  
80102ab0:	c3                   	ret    

80102ab1 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
80102ab1:	55                   	push   %ebp
80102ab2:	89 e5                	mov    %esp,%ebp
80102ab4:	57                   	push   %edi
80102ab5:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102ab6:	8b 55 08             	mov    0x8(%ebp),%edx
80102ab9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102abc:	8b 45 10             	mov    0x10(%ebp),%eax
80102abf:	89 cb                	mov    %ecx,%ebx
80102ac1:	89 df                	mov    %ebx,%edi
80102ac3:	89 c1                	mov    %eax,%ecx
80102ac5:	fc                   	cld    
80102ac6:	f3 6d                	rep insl (%dx),%es:(%edi)
80102ac8:	89 c8                	mov    %ecx,%eax
80102aca:	89 fb                	mov    %edi,%ebx
80102acc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102acf:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
80102ad2:	90                   	nop
80102ad3:	5b                   	pop    %ebx
80102ad4:	5f                   	pop    %edi
80102ad5:	5d                   	pop    %ebp
80102ad6:	c3                   	ret    

80102ad7 <outb>:

static inline void
outb(ushort port, uchar data)
{
80102ad7:	55                   	push   %ebp
80102ad8:	89 e5                	mov    %esp,%ebp
80102ada:	83 ec 08             	sub    $0x8,%esp
80102add:	8b 55 08             	mov    0x8(%ebp),%edx
80102ae0:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ae3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102ae7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aea:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102aee:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102af2:	ee                   	out    %al,(%dx)
}
80102af3:	90                   	nop
80102af4:	c9                   	leave  
80102af5:	c3                   	ret    

80102af6 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102af6:	55                   	push   %ebp
80102af7:	89 e5                	mov    %esp,%ebp
80102af9:	56                   	push   %esi
80102afa:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102afb:	8b 55 08             	mov    0x8(%ebp),%edx
80102afe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b01:	8b 45 10             	mov    0x10(%ebp),%eax
80102b04:	89 cb                	mov    %ecx,%ebx
80102b06:	89 de                	mov    %ebx,%esi
80102b08:	89 c1                	mov    %eax,%ecx
80102b0a:	fc                   	cld    
80102b0b:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102b0d:	89 c8                	mov    %ecx,%eax
80102b0f:	89 f3                	mov    %esi,%ebx
80102b11:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102b14:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102b17:	90                   	nop
80102b18:	5b                   	pop    %ebx
80102b19:	5e                   	pop    %esi
80102b1a:	5d                   	pop    %ebp
80102b1b:	c3                   	ret    

80102b1c <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102b1c:	55                   	push   %ebp
80102b1d:	89 e5                	mov    %esp,%ebp
80102b1f:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
80102b22:	90                   	nop
80102b23:	68 f7 01 00 00       	push   $0x1f7
80102b28:	e8 67 ff ff ff       	call   80102a94 <inb>
80102b2d:	83 c4 04             	add    $0x4,%esp
80102b30:	0f b6 c0             	movzbl %al,%eax
80102b33:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102b36:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102b39:	25 c0 00 00 00       	and    $0xc0,%eax
80102b3e:	83 f8 40             	cmp    $0x40,%eax
80102b41:	75 e0                	jne    80102b23 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102b43:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102b47:	74 11                	je     80102b5a <idewait+0x3e>
80102b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102b4c:	83 e0 21             	and    $0x21,%eax
80102b4f:	85 c0                	test   %eax,%eax
80102b51:	74 07                	je     80102b5a <idewait+0x3e>
    return -1;
80102b53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b58:	eb 05                	jmp    80102b5f <idewait+0x43>
  return 0;
80102b5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102b5f:	c9                   	leave  
80102b60:	c3                   	ret    

80102b61 <ideinit>:

void
ideinit(void)
{
80102b61:	55                   	push   %ebp
80102b62:	89 e5                	mov    %esp,%ebp
80102b64:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102b67:	83 ec 08             	sub    $0x8,%esp
80102b6a:	68 66 a2 10 80       	push   $0x8010a266
80102b6f:	68 40 d6 10 80       	push   $0x8010d640
80102b74:	e8 e9 3c 00 00       	call   80106862 <initlock>
80102b79:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102b7c:	83 ec 0c             	sub    $0xc,%esp
80102b7f:	6a 0e                	push   $0xe
80102b81:	e8 da 18 00 00       	call   80104460 <picenable>
80102b86:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102b89:	a1 18 45 11 80       	mov    0x80114518,%eax
80102b8e:	83 e8 01             	sub    $0x1,%eax
80102b91:	83 ec 08             	sub    $0x8,%esp
80102b94:	50                   	push   %eax
80102b95:	6a 0e                	push   $0xe
80102b97:	e8 73 04 00 00       	call   8010300f <ioapicenable>
80102b9c:	83 c4 10             	add    $0x10,%esp
  idewait(0);
80102b9f:	83 ec 0c             	sub    $0xc,%esp
80102ba2:	6a 00                	push   $0x0
80102ba4:	e8 73 ff ff ff       	call   80102b1c <idewait>
80102ba9:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102bac:	83 ec 08             	sub    $0x8,%esp
80102baf:	68 f0 00 00 00       	push   $0xf0
80102bb4:	68 f6 01 00 00       	push   $0x1f6
80102bb9:	e8 19 ff ff ff       	call   80102ad7 <outb>
80102bbe:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
80102bc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102bc8:	eb 24                	jmp    80102bee <ideinit+0x8d>
    if(inb(0x1f7) != 0){
80102bca:	83 ec 0c             	sub    $0xc,%esp
80102bcd:	68 f7 01 00 00       	push   $0x1f7
80102bd2:	e8 bd fe ff ff       	call   80102a94 <inb>
80102bd7:	83 c4 10             	add    $0x10,%esp
80102bda:	84 c0                	test   %al,%al
80102bdc:	74 0c                	je     80102bea <ideinit+0x89>
      havedisk1 = 1;
80102bde:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
80102be5:	00 00 00 
      break;
80102be8:	eb 0d                	jmp    80102bf7 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102bea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102bee:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102bf5:	7e d3                	jle    80102bca <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102bf7:	83 ec 08             	sub    $0x8,%esp
80102bfa:	68 e0 00 00 00       	push   $0xe0
80102bff:	68 f6 01 00 00       	push   $0x1f6
80102c04:	e8 ce fe ff ff       	call   80102ad7 <outb>
80102c09:	83 c4 10             	add    $0x10,%esp
}
80102c0c:	90                   	nop
80102c0d:	c9                   	leave  
80102c0e:	c3                   	ret    

80102c0f <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102c0f:	55                   	push   %ebp
80102c10:	89 e5                	mov    %esp,%ebp
80102c12:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102c15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102c19:	75 0d                	jne    80102c28 <idestart+0x19>
    panic("idestart");
80102c1b:	83 ec 0c             	sub    $0xc,%esp
80102c1e:	68 6a a2 10 80       	push   $0x8010a26a
80102c23:	e8 3e d9 ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102c28:	8b 45 08             	mov    0x8(%ebp),%eax
80102c2b:	8b 40 08             	mov    0x8(%eax),%eax
80102c2e:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102c33:	76 0d                	jbe    80102c42 <idestart+0x33>
    panic("incorrect blockno");
80102c35:	83 ec 0c             	sub    $0xc,%esp
80102c38:	68 73 a2 10 80       	push   $0x8010a273
80102c3d:	e8 24 d9 ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102c42:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102c49:	8b 45 08             	mov    0x8(%ebp),%eax
80102c4c:	8b 50 08             	mov    0x8(%eax),%edx
80102c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c52:	0f af c2             	imul   %edx,%eax
80102c55:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102c58:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102c5c:	7e 0d                	jle    80102c6b <idestart+0x5c>
80102c5e:	83 ec 0c             	sub    $0xc,%esp
80102c61:	68 6a a2 10 80       	push   $0x8010a26a
80102c66:	e8 fb d8 ff ff       	call   80100566 <panic>
  
  idewait(0);
80102c6b:	83 ec 0c             	sub    $0xc,%esp
80102c6e:	6a 00                	push   $0x0
80102c70:	e8 a7 fe ff ff       	call   80102b1c <idewait>
80102c75:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102c78:	83 ec 08             	sub    $0x8,%esp
80102c7b:	6a 00                	push   $0x0
80102c7d:	68 f6 03 00 00       	push   $0x3f6
80102c82:	e8 50 fe ff ff       	call   80102ad7 <outb>
80102c87:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c8d:	0f b6 c0             	movzbl %al,%eax
80102c90:	83 ec 08             	sub    $0x8,%esp
80102c93:	50                   	push   %eax
80102c94:	68 f2 01 00 00       	push   $0x1f2
80102c99:	e8 39 fe ff ff       	call   80102ad7 <outb>
80102c9e:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ca4:	0f b6 c0             	movzbl %al,%eax
80102ca7:	83 ec 08             	sub    $0x8,%esp
80102caa:	50                   	push   %eax
80102cab:	68 f3 01 00 00       	push   $0x1f3
80102cb0:	e8 22 fe ff ff       	call   80102ad7 <outb>
80102cb5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102cbb:	c1 f8 08             	sar    $0x8,%eax
80102cbe:	0f b6 c0             	movzbl %al,%eax
80102cc1:	83 ec 08             	sub    $0x8,%esp
80102cc4:	50                   	push   %eax
80102cc5:	68 f4 01 00 00       	push   $0x1f4
80102cca:	e8 08 fe ff ff       	call   80102ad7 <outb>
80102ccf:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102cd5:	c1 f8 10             	sar    $0x10,%eax
80102cd8:	0f b6 c0             	movzbl %al,%eax
80102cdb:	83 ec 08             	sub    $0x8,%esp
80102cde:	50                   	push   %eax
80102cdf:	68 f5 01 00 00       	push   $0x1f5
80102ce4:	e8 ee fd ff ff       	call   80102ad7 <outb>
80102ce9:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102cec:	8b 45 08             	mov    0x8(%ebp),%eax
80102cef:	8b 40 04             	mov    0x4(%eax),%eax
80102cf2:	83 e0 01             	and    $0x1,%eax
80102cf5:	c1 e0 04             	shl    $0x4,%eax
80102cf8:	89 c2                	mov    %eax,%edx
80102cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102cfd:	c1 f8 18             	sar    $0x18,%eax
80102d00:	83 e0 0f             	and    $0xf,%eax
80102d03:	09 d0                	or     %edx,%eax
80102d05:	83 c8 e0             	or     $0xffffffe0,%eax
80102d08:	0f b6 c0             	movzbl %al,%eax
80102d0b:	83 ec 08             	sub    $0x8,%esp
80102d0e:	50                   	push   %eax
80102d0f:	68 f6 01 00 00       	push   $0x1f6
80102d14:	e8 be fd ff ff       	call   80102ad7 <outb>
80102d19:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80102d1f:	8b 00                	mov    (%eax),%eax
80102d21:	83 e0 04             	and    $0x4,%eax
80102d24:	85 c0                	test   %eax,%eax
80102d26:	74 30                	je     80102d58 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102d28:	83 ec 08             	sub    $0x8,%esp
80102d2b:	6a 30                	push   $0x30
80102d2d:	68 f7 01 00 00       	push   $0x1f7
80102d32:	e8 a0 fd ff ff       	call   80102ad7 <outb>
80102d37:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102d3a:	8b 45 08             	mov    0x8(%ebp),%eax
80102d3d:	83 c0 18             	add    $0x18,%eax
80102d40:	83 ec 04             	sub    $0x4,%esp
80102d43:	68 80 00 00 00       	push   $0x80
80102d48:	50                   	push   %eax
80102d49:	68 f0 01 00 00       	push   $0x1f0
80102d4e:	e8 a3 fd ff ff       	call   80102af6 <outsl>
80102d53:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102d56:	eb 12                	jmp    80102d6a <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102d58:	83 ec 08             	sub    $0x8,%esp
80102d5b:	6a 20                	push   $0x20
80102d5d:	68 f7 01 00 00       	push   $0x1f7
80102d62:	e8 70 fd ff ff       	call   80102ad7 <outb>
80102d67:	83 c4 10             	add    $0x10,%esp
  }
}
80102d6a:	90                   	nop
80102d6b:	c9                   	leave  
80102d6c:	c3                   	ret    

80102d6d <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102d6d:	55                   	push   %ebp
80102d6e:	89 e5                	mov    %esp,%ebp
80102d70:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102d73:	83 ec 0c             	sub    $0xc,%esp
80102d76:	68 40 d6 10 80       	push   $0x8010d640
80102d7b:	e8 04 3b 00 00       	call   80106884 <acquire>
80102d80:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102d83:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102d88:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102d8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102d8f:	75 15                	jne    80102da6 <ideintr+0x39>
    release(&idelock);
80102d91:	83 ec 0c             	sub    $0xc,%esp
80102d94:	68 40 d6 10 80       	push   $0x8010d640
80102d99:	e8 4d 3b 00 00       	call   801068eb <release>
80102d9e:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102da1:	e9 9a 00 00 00       	jmp    80102e40 <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102da9:	8b 40 14             	mov    0x14(%eax),%eax
80102dac:	a3 74 d6 10 80       	mov    %eax,0x8010d674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102db4:	8b 00                	mov    (%eax),%eax
80102db6:	83 e0 04             	and    $0x4,%eax
80102db9:	85 c0                	test   %eax,%eax
80102dbb:	75 2d                	jne    80102dea <ideintr+0x7d>
80102dbd:	83 ec 0c             	sub    $0xc,%esp
80102dc0:	6a 01                	push   $0x1
80102dc2:	e8 55 fd ff ff       	call   80102b1c <idewait>
80102dc7:	83 c4 10             	add    $0x10,%esp
80102dca:	85 c0                	test   %eax,%eax
80102dcc:	78 1c                	js     80102dea <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dd1:	83 c0 18             	add    $0x18,%eax
80102dd4:	83 ec 04             	sub    $0x4,%esp
80102dd7:	68 80 00 00 00       	push   $0x80
80102ddc:	50                   	push   %eax
80102ddd:	68 f0 01 00 00       	push   $0x1f0
80102de2:	e8 ca fc ff ff       	call   80102ab1 <insl>
80102de7:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ded:	8b 00                	mov    (%eax),%eax
80102def:	83 c8 02             	or     $0x2,%eax
80102df2:	89 c2                	mov    %eax,%edx
80102df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df7:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dfc:	8b 00                	mov    (%eax),%eax
80102dfe:	83 e0 fb             	and    $0xfffffffb,%eax
80102e01:	89 c2                	mov    %eax,%edx
80102e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e06:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102e08:	83 ec 0c             	sub    $0xc,%esp
80102e0b:	ff 75 f4             	pushl  -0xc(%ebp)
80102e0e:	e8 c3 2e 00 00       	call   80105cd6 <wakeup>
80102e13:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102e16:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102e1b:	85 c0                	test   %eax,%eax
80102e1d:	74 11                	je     80102e30 <ideintr+0xc3>
    idestart(idequeue);
80102e1f:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102e24:	83 ec 0c             	sub    $0xc,%esp
80102e27:	50                   	push   %eax
80102e28:	e8 e2 fd ff ff       	call   80102c0f <idestart>
80102e2d:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102e30:	83 ec 0c             	sub    $0xc,%esp
80102e33:	68 40 d6 10 80       	push   $0x8010d640
80102e38:	e8 ae 3a 00 00       	call   801068eb <release>
80102e3d:	83 c4 10             	add    $0x10,%esp
}
80102e40:	c9                   	leave  
80102e41:	c3                   	ret    

80102e42 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102e42:	55                   	push   %ebp
80102e43:	89 e5                	mov    %esp,%ebp
80102e45:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102e48:	8b 45 08             	mov    0x8(%ebp),%eax
80102e4b:	8b 00                	mov    (%eax),%eax
80102e4d:	83 e0 01             	and    $0x1,%eax
80102e50:	85 c0                	test   %eax,%eax
80102e52:	75 0d                	jne    80102e61 <iderw+0x1f>
    panic("iderw: buf not busy");
80102e54:	83 ec 0c             	sub    $0xc,%esp
80102e57:	68 85 a2 10 80       	push   $0x8010a285
80102e5c:	e8 05 d7 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102e61:	8b 45 08             	mov    0x8(%ebp),%eax
80102e64:	8b 00                	mov    (%eax),%eax
80102e66:	83 e0 06             	and    $0x6,%eax
80102e69:	83 f8 02             	cmp    $0x2,%eax
80102e6c:	75 0d                	jne    80102e7b <iderw+0x39>
    panic("iderw: nothing to do");
80102e6e:	83 ec 0c             	sub    $0xc,%esp
80102e71:	68 99 a2 10 80       	push   $0x8010a299
80102e76:	e8 eb d6 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80102e7e:	8b 40 04             	mov    0x4(%eax),%eax
80102e81:	85 c0                	test   %eax,%eax
80102e83:	74 16                	je     80102e9b <iderw+0x59>
80102e85:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80102e8a:	85 c0                	test   %eax,%eax
80102e8c:	75 0d                	jne    80102e9b <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102e8e:	83 ec 0c             	sub    $0xc,%esp
80102e91:	68 ae a2 10 80       	push   $0x8010a2ae
80102e96:	e8 cb d6 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102e9b:	83 ec 0c             	sub    $0xc,%esp
80102e9e:	68 40 d6 10 80       	push   $0x8010d640
80102ea3:	e8 dc 39 00 00       	call   80106884 <acquire>
80102ea8:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102eab:	8b 45 08             	mov    0x8(%ebp),%eax
80102eae:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102eb5:	c7 45 f4 74 d6 10 80 	movl   $0x8010d674,-0xc(%ebp)
80102ebc:	eb 0b                	jmp    80102ec9 <iderw+0x87>
80102ebe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ec1:	8b 00                	mov    (%eax),%eax
80102ec3:	83 c0 14             	add    $0x14,%eax
80102ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ecc:	8b 00                	mov    (%eax),%eax
80102ece:	85 c0                	test   %eax,%eax
80102ed0:	75 ec                	jne    80102ebe <iderw+0x7c>
    ;
  *pp = b;
80102ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ed5:	8b 55 08             	mov    0x8(%ebp),%edx
80102ed8:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102eda:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102edf:	3b 45 08             	cmp    0x8(%ebp),%eax
80102ee2:	75 23                	jne    80102f07 <iderw+0xc5>
    idestart(b);
80102ee4:	83 ec 0c             	sub    $0xc,%esp
80102ee7:	ff 75 08             	pushl  0x8(%ebp)
80102eea:	e8 20 fd ff ff       	call   80102c0f <idestart>
80102eef:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102ef2:	eb 13                	jmp    80102f07 <iderw+0xc5>
    sleep(b, &idelock);
80102ef4:	83 ec 08             	sub    $0x8,%esp
80102ef7:	68 40 d6 10 80       	push   $0x8010d640
80102efc:	ff 75 08             	pushl  0x8(%ebp)
80102eff:	e8 0b 2c 00 00       	call   80105b0f <sleep>
80102f04:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102f07:	8b 45 08             	mov    0x8(%ebp),%eax
80102f0a:	8b 00                	mov    (%eax),%eax
80102f0c:	83 e0 06             	and    $0x6,%eax
80102f0f:	83 f8 02             	cmp    $0x2,%eax
80102f12:	75 e0                	jne    80102ef4 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102f14:	83 ec 0c             	sub    $0xc,%esp
80102f17:	68 40 d6 10 80       	push   $0x8010d640
80102f1c:	e8 ca 39 00 00       	call   801068eb <release>
80102f21:	83 c4 10             	add    $0x10,%esp
}
80102f24:	90                   	nop
80102f25:	c9                   	leave  
80102f26:	c3                   	ret    

80102f27 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102f27:	55                   	push   %ebp
80102f28:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102f2a:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f2f:	8b 55 08             	mov    0x8(%ebp),%edx
80102f32:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102f34:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f39:	8b 40 10             	mov    0x10(%eax),%eax
}
80102f3c:	5d                   	pop    %ebp
80102f3d:	c3                   	ret    

80102f3e <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102f3e:	55                   	push   %ebp
80102f3f:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102f41:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f46:	8b 55 08             	mov    0x8(%ebp),%edx
80102f49:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102f4b:	a1 54 42 11 80       	mov    0x80114254,%eax
80102f50:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f53:	89 50 10             	mov    %edx,0x10(%eax)
}
80102f56:	90                   	nop
80102f57:	5d                   	pop    %ebp
80102f58:	c3                   	ret    

80102f59 <ioapicinit>:

void
ioapicinit(void)
{
80102f59:	55                   	push   %ebp
80102f5a:	89 e5                	mov    %esp,%ebp
80102f5c:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102f5f:	a1 84 43 11 80       	mov    0x80114384,%eax
80102f64:	85 c0                	test   %eax,%eax
80102f66:	0f 84 a0 00 00 00    	je     8010300c <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102f6c:	c7 05 54 42 11 80 00 	movl   $0xfec00000,0x80114254
80102f73:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102f76:	6a 01                	push   $0x1
80102f78:	e8 aa ff ff ff       	call   80102f27 <ioapicread>
80102f7d:	83 c4 04             	add    $0x4,%esp
80102f80:	c1 e8 10             	shr    $0x10,%eax
80102f83:	25 ff 00 00 00       	and    $0xff,%eax
80102f88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102f8b:	6a 00                	push   $0x0
80102f8d:	e8 95 ff ff ff       	call   80102f27 <ioapicread>
80102f92:	83 c4 04             	add    $0x4,%esp
80102f95:	c1 e8 18             	shr    $0x18,%eax
80102f98:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102f9b:	0f b6 05 80 43 11 80 	movzbl 0x80114380,%eax
80102fa2:	0f b6 c0             	movzbl %al,%eax
80102fa5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102fa8:	74 10                	je     80102fba <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102faa:	83 ec 0c             	sub    $0xc,%esp
80102fad:	68 cc a2 10 80       	push   $0x8010a2cc
80102fb2:	e8 0f d4 ff ff       	call   801003c6 <cprintf>
80102fb7:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102fba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102fc1:	eb 3f                	jmp    80103002 <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fc6:	83 c0 20             	add    $0x20,%eax
80102fc9:	0d 00 00 01 00       	or     $0x10000,%eax
80102fce:	89 c2                	mov    %eax,%edx
80102fd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fd3:	83 c0 08             	add    $0x8,%eax
80102fd6:	01 c0                	add    %eax,%eax
80102fd8:	83 ec 08             	sub    $0x8,%esp
80102fdb:	52                   	push   %edx
80102fdc:	50                   	push   %eax
80102fdd:	e8 5c ff ff ff       	call   80102f3e <ioapicwrite>
80102fe2:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102fe5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fe8:	83 c0 08             	add    $0x8,%eax
80102feb:	01 c0                	add    %eax,%eax
80102fed:	83 c0 01             	add    $0x1,%eax
80102ff0:	83 ec 08             	sub    $0x8,%esp
80102ff3:	6a 00                	push   $0x0
80102ff5:	50                   	push   %eax
80102ff6:	e8 43 ff ff ff       	call   80102f3e <ioapicwrite>
80102ffb:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102ffe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103002:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103005:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80103008:	7e b9                	jle    80102fc3 <ioapicinit+0x6a>
8010300a:	eb 01                	jmp    8010300d <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
8010300c:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010300d:	c9                   	leave  
8010300e:	c3                   	ret    

8010300f <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010300f:	55                   	push   %ebp
80103010:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80103012:	a1 84 43 11 80       	mov    0x80114384,%eax
80103017:	85 c0                	test   %eax,%eax
80103019:	74 39                	je     80103054 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010301b:	8b 45 08             	mov    0x8(%ebp),%eax
8010301e:	83 c0 20             	add    $0x20,%eax
80103021:	89 c2                	mov    %eax,%edx
80103023:	8b 45 08             	mov    0x8(%ebp),%eax
80103026:	83 c0 08             	add    $0x8,%eax
80103029:	01 c0                	add    %eax,%eax
8010302b:	52                   	push   %edx
8010302c:	50                   	push   %eax
8010302d:	e8 0c ff ff ff       	call   80102f3e <ioapicwrite>
80103032:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80103035:	8b 45 0c             	mov    0xc(%ebp),%eax
80103038:	c1 e0 18             	shl    $0x18,%eax
8010303b:	89 c2                	mov    %eax,%edx
8010303d:	8b 45 08             	mov    0x8(%ebp),%eax
80103040:	83 c0 08             	add    $0x8,%eax
80103043:	01 c0                	add    %eax,%eax
80103045:	83 c0 01             	add    $0x1,%eax
80103048:	52                   	push   %edx
80103049:	50                   	push   %eax
8010304a:	e8 ef fe ff ff       	call   80102f3e <ioapicwrite>
8010304f:	83 c4 08             	add    $0x8,%esp
80103052:	eb 01                	jmp    80103055 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80103054:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80103055:	c9                   	leave  
80103056:	c3                   	ret    

80103057 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80103057:	55                   	push   %ebp
80103058:	89 e5                	mov    %esp,%ebp
8010305a:	8b 45 08             	mov    0x8(%ebp),%eax
8010305d:	05 00 00 00 80       	add    $0x80000000,%eax
80103062:	5d                   	pop    %ebp
80103063:	c3                   	ret    

80103064 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80103064:	55                   	push   %ebp
80103065:	89 e5                	mov    %esp,%ebp
80103067:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
8010306a:	83 ec 08             	sub    $0x8,%esp
8010306d:	68 fe a2 10 80       	push   $0x8010a2fe
80103072:	68 60 42 11 80       	push   $0x80114260
80103077:	e8 e6 37 00 00       	call   80106862 <initlock>
8010307c:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
8010307f:	c7 05 94 42 11 80 00 	movl   $0x0,0x80114294
80103086:	00 00 00 
  freerange(vstart, vend);
80103089:	83 ec 08             	sub    $0x8,%esp
8010308c:	ff 75 0c             	pushl  0xc(%ebp)
8010308f:	ff 75 08             	pushl  0x8(%ebp)
80103092:	e8 2a 00 00 00       	call   801030c1 <freerange>
80103097:	83 c4 10             	add    $0x10,%esp
}
8010309a:	90                   	nop
8010309b:	c9                   	leave  
8010309c:	c3                   	ret    

8010309d <kinit2>:

void
kinit2(void *vstart, void *vend)
{
8010309d:	55                   	push   %ebp
8010309e:	89 e5                	mov    %esp,%ebp
801030a0:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
801030a3:	83 ec 08             	sub    $0x8,%esp
801030a6:	ff 75 0c             	pushl  0xc(%ebp)
801030a9:	ff 75 08             	pushl  0x8(%ebp)
801030ac:	e8 10 00 00 00       	call   801030c1 <freerange>
801030b1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
801030b4:	c7 05 94 42 11 80 01 	movl   $0x1,0x80114294
801030bb:	00 00 00 
}
801030be:	90                   	nop
801030bf:	c9                   	leave  
801030c0:	c3                   	ret    

801030c1 <freerange>:

void
freerange(void *vstart, void *vend)
{
801030c1:	55                   	push   %ebp
801030c2:	89 e5                	mov    %esp,%ebp
801030c4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801030c7:	8b 45 08             	mov    0x8(%ebp),%eax
801030ca:	05 ff 0f 00 00       	add    $0xfff,%eax
801030cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801030d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030d7:	eb 15                	jmp    801030ee <freerange+0x2d>
    kfree(p);
801030d9:	83 ec 0c             	sub    $0xc,%esp
801030dc:	ff 75 f4             	pushl  -0xc(%ebp)
801030df:	e8 1a 00 00 00       	call   801030fe <kfree>
801030e4:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030e7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801030ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030f1:	05 00 10 00 00       	add    $0x1000,%eax
801030f6:	3b 45 0c             	cmp    0xc(%ebp),%eax
801030f9:	76 de                	jbe    801030d9 <freerange+0x18>
    kfree(p);
}
801030fb:	90                   	nop
801030fc:	c9                   	leave  
801030fd:	c3                   	ret    

801030fe <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801030fe:	55                   	push   %ebp
801030ff:	89 e5                	mov    %esp,%ebp
80103101:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80103104:	8b 45 08             	mov    0x8(%ebp),%eax
80103107:	25 ff 0f 00 00       	and    $0xfff,%eax
8010310c:	85 c0                	test   %eax,%eax
8010310e:	75 1b                	jne    8010312b <kfree+0x2d>
80103110:	81 7d 08 dc 74 11 80 	cmpl   $0x801174dc,0x8(%ebp)
80103117:	72 12                	jb     8010312b <kfree+0x2d>
80103119:	ff 75 08             	pushl  0x8(%ebp)
8010311c:	e8 36 ff ff ff       	call   80103057 <v2p>
80103121:	83 c4 04             	add    $0x4,%esp
80103124:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80103129:	76 0d                	jbe    80103138 <kfree+0x3a>
    panic("kfree");
8010312b:	83 ec 0c             	sub    $0xc,%esp
8010312e:	68 03 a3 10 80       	push   $0x8010a303
80103133:	e8 2e d4 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80103138:	83 ec 04             	sub    $0x4,%esp
8010313b:	68 00 10 00 00       	push   $0x1000
80103140:	6a 01                	push   $0x1
80103142:	ff 75 08             	pushl  0x8(%ebp)
80103145:	e8 9d 39 00 00       	call   80106ae7 <memset>
8010314a:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
8010314d:	a1 94 42 11 80       	mov    0x80114294,%eax
80103152:	85 c0                	test   %eax,%eax
80103154:	74 10                	je     80103166 <kfree+0x68>
    acquire(&kmem.lock);
80103156:	83 ec 0c             	sub    $0xc,%esp
80103159:	68 60 42 11 80       	push   $0x80114260
8010315e:	e8 21 37 00 00       	call   80106884 <acquire>
80103163:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80103166:	8b 45 08             	mov    0x8(%ebp),%eax
80103169:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
8010316c:	8b 15 98 42 11 80    	mov    0x80114298,%edx
80103172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103175:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80103177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010317a:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
8010317f:	a1 94 42 11 80       	mov    0x80114294,%eax
80103184:	85 c0                	test   %eax,%eax
80103186:	74 10                	je     80103198 <kfree+0x9a>
    release(&kmem.lock);
80103188:	83 ec 0c             	sub    $0xc,%esp
8010318b:	68 60 42 11 80       	push   $0x80114260
80103190:	e8 56 37 00 00       	call   801068eb <release>
80103195:	83 c4 10             	add    $0x10,%esp
}
80103198:	90                   	nop
80103199:	c9                   	leave  
8010319a:	c3                   	ret    

8010319b <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
8010319b:	55                   	push   %ebp
8010319c:	89 e5                	mov    %esp,%ebp
8010319e:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
801031a1:	a1 94 42 11 80       	mov    0x80114294,%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 10                	je     801031ba <kalloc+0x1f>
    acquire(&kmem.lock);
801031aa:	83 ec 0c             	sub    $0xc,%esp
801031ad:	68 60 42 11 80       	push   $0x80114260
801031b2:	e8 cd 36 00 00       	call   80106884 <acquire>
801031b7:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
801031ba:	a1 98 42 11 80       	mov    0x80114298,%eax
801031bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
801031c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801031c6:	74 0a                	je     801031d2 <kalloc+0x37>
    kmem.freelist = r->next;
801031c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031cb:	8b 00                	mov    (%eax),%eax
801031cd:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
801031d2:	a1 94 42 11 80       	mov    0x80114294,%eax
801031d7:	85 c0                	test   %eax,%eax
801031d9:	74 10                	je     801031eb <kalloc+0x50>
    release(&kmem.lock);
801031db:	83 ec 0c             	sub    $0xc,%esp
801031de:	68 60 42 11 80       	push   $0x80114260
801031e3:	e8 03 37 00 00       	call   801068eb <release>
801031e8:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801031eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801031ee:	c9                   	leave  
801031ef:	c3                   	ret    

801031f0 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 14             	sub    $0x14,%esp
801031f6:	8b 45 08             	mov    0x8(%ebp),%eax
801031f9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801031fd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103201:	89 c2                	mov    %eax,%edx
80103203:	ec                   	in     (%dx),%al
80103204:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103207:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010320b:	c9                   	leave  
8010320c:	c3                   	ret    

8010320d <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
8010320d:	55                   	push   %ebp
8010320e:	89 e5                	mov    %esp,%ebp
80103210:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80103213:	6a 64                	push   $0x64
80103215:	e8 d6 ff ff ff       	call   801031f0 <inb>
8010321a:	83 c4 04             	add    $0x4,%esp
8010321d:	0f b6 c0             	movzbl %al,%eax
80103220:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80103223:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103226:	83 e0 01             	and    $0x1,%eax
80103229:	85 c0                	test   %eax,%eax
8010322b:	75 0a                	jne    80103237 <kbdgetc+0x2a>
    return -1;
8010322d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103232:	e9 23 01 00 00       	jmp    8010335a <kbdgetc+0x14d>
  data = inb(KBDATAP);
80103237:	6a 60                	push   $0x60
80103239:	e8 b2 ff ff ff       	call   801031f0 <inb>
8010323e:	83 c4 04             	add    $0x4,%esp
80103241:	0f b6 c0             	movzbl %al,%eax
80103244:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80103247:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
8010324e:	75 17                	jne    80103267 <kbdgetc+0x5a>
    shift |= E0ESC;
80103250:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103255:	83 c8 40             	or     $0x40,%eax
80103258:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
8010325d:	b8 00 00 00 00       	mov    $0x0,%eax
80103262:	e9 f3 00 00 00       	jmp    8010335a <kbdgetc+0x14d>
  } else if(data & 0x80){
80103267:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010326a:	25 80 00 00 00       	and    $0x80,%eax
8010326f:	85 c0                	test   %eax,%eax
80103271:	74 45                	je     801032b8 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80103273:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103278:	83 e0 40             	and    $0x40,%eax
8010327b:	85 c0                	test   %eax,%eax
8010327d:	75 08                	jne    80103287 <kbdgetc+0x7a>
8010327f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103282:	83 e0 7f             	and    $0x7f,%eax
80103285:	eb 03                	jmp    8010328a <kbdgetc+0x7d>
80103287:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010328a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
8010328d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103290:	05 20 b0 10 80       	add    $0x8010b020,%eax
80103295:	0f b6 00             	movzbl (%eax),%eax
80103298:	83 c8 40             	or     $0x40,%eax
8010329b:	0f b6 c0             	movzbl %al,%eax
8010329e:	f7 d0                	not    %eax
801032a0:	89 c2                	mov    %eax,%edx
801032a2:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032a7:	21 d0                	and    %edx,%eax
801032a9:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
801032ae:	b8 00 00 00 00       	mov    $0x0,%eax
801032b3:	e9 a2 00 00 00       	jmp    8010335a <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801032b8:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032bd:	83 e0 40             	and    $0x40,%eax
801032c0:	85 c0                	test   %eax,%eax
801032c2:	74 14                	je     801032d8 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801032c4:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801032cb:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032d0:	83 e0 bf             	and    $0xffffffbf,%eax
801032d3:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  }

  shift |= shiftcode[data];
801032d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801032db:	05 20 b0 10 80       	add    $0x8010b020,%eax
801032e0:	0f b6 00             	movzbl (%eax),%eax
801032e3:	0f b6 d0             	movzbl %al,%edx
801032e6:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801032eb:	09 d0                	or     %edx,%eax
801032ed:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  shift ^= togglecode[data];
801032f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801032f5:	05 20 b1 10 80       	add    $0x8010b120,%eax
801032fa:	0f b6 00             	movzbl (%eax),%eax
801032fd:	0f b6 d0             	movzbl %al,%edx
80103300:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103305:	31 d0                	xor    %edx,%eax
80103307:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  c = charcode[shift & (CTL | SHIFT)][data];
8010330c:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103311:	83 e0 03             	and    $0x3,%eax
80103314:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
8010331b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010331e:	01 d0                	add    %edx,%eax
80103320:	0f b6 00             	movzbl (%eax),%eax
80103323:	0f b6 c0             	movzbl %al,%eax
80103326:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80103329:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010332e:	83 e0 08             	and    $0x8,%eax
80103331:	85 c0                	test   %eax,%eax
80103333:	74 22                	je     80103357 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80103335:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80103339:	76 0c                	jbe    80103347 <kbdgetc+0x13a>
8010333b:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
8010333f:	77 06                	ja     80103347 <kbdgetc+0x13a>
      c += 'A' - 'a';
80103341:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80103345:	eb 10                	jmp    80103357 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80103347:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
8010334b:	76 0a                	jbe    80103357 <kbdgetc+0x14a>
8010334d:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80103351:	77 04                	ja     80103357 <kbdgetc+0x14a>
      c += 'a' - 'A';
80103353:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80103357:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010335a:	c9                   	leave  
8010335b:	c3                   	ret    

8010335c <kbdintr>:

void
kbdintr(void)
{
8010335c:	55                   	push   %ebp
8010335d:	89 e5                	mov    %esp,%ebp
8010335f:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80103362:	83 ec 0c             	sub    $0xc,%esp
80103365:	68 0d 32 10 80       	push   $0x8010320d
8010336a:	e8 8a d4 ff ff       	call   801007f9 <consoleintr>
8010336f:	83 c4 10             	add    $0x10,%esp
}
80103372:	90                   	nop
80103373:	c9                   	leave  
80103374:	c3                   	ret    

80103375 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103375:	55                   	push   %ebp
80103376:	89 e5                	mov    %esp,%ebp
80103378:	83 ec 14             	sub    $0x14,%esp
8010337b:	8b 45 08             	mov    0x8(%ebp),%eax
8010337e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103382:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103386:	89 c2                	mov    %eax,%edx
80103388:	ec                   	in     (%dx),%al
80103389:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010338c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103390:	c9                   	leave  
80103391:	c3                   	ret    

80103392 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103392:	55                   	push   %ebp
80103393:	89 e5                	mov    %esp,%ebp
80103395:	83 ec 08             	sub    $0x8,%esp
80103398:	8b 55 08             	mov    0x8(%ebp),%edx
8010339b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010339e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801033a2:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033a5:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801033a9:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801033ad:	ee                   	out    %al,(%dx)
}
801033ae:	90                   	nop
801033af:	c9                   	leave  
801033b0:	c3                   	ret    

801033b1 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801033b1:	55                   	push   %ebp
801033b2:	89 e5                	mov    %esp,%ebp
801033b4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801033b7:	9c                   	pushf  
801033b8:	58                   	pop    %eax
801033b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801033bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801033bf:	c9                   	leave  
801033c0:	c3                   	ret    

801033c1 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801033c1:	55                   	push   %ebp
801033c2:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801033c4:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801033c9:	8b 55 08             	mov    0x8(%ebp),%edx
801033cc:	c1 e2 02             	shl    $0x2,%edx
801033cf:	01 c2                	add    %eax,%edx
801033d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801033d4:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801033d6:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801033db:	83 c0 20             	add    $0x20,%eax
801033de:	8b 00                	mov    (%eax),%eax
}
801033e0:	90                   	nop
801033e1:	5d                   	pop    %ebp
801033e2:	c3                   	ret    

801033e3 <lapicinit>:

void
lapicinit(void)
{
801033e3:	55                   	push   %ebp
801033e4:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
801033e6:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801033eb:	85 c0                	test   %eax,%eax
801033ed:	0f 84 0b 01 00 00    	je     801034fe <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801033f3:	68 3f 01 00 00       	push   $0x13f
801033f8:	6a 3c                	push   $0x3c
801033fa:	e8 c2 ff ff ff       	call   801033c1 <lapicw>
801033ff:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80103402:	6a 0b                	push   $0xb
80103404:	68 f8 00 00 00       	push   $0xf8
80103409:	e8 b3 ff ff ff       	call   801033c1 <lapicw>
8010340e:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80103411:	68 20 00 02 00       	push   $0x20020
80103416:	68 c8 00 00 00       	push   $0xc8
8010341b:	e8 a1 ff ff ff       	call   801033c1 <lapicw>
80103420:	83 c4 08             	add    $0x8,%esp
  // lapicw(TICR, 10000000); 
  lapicw(TICR, 1000000000/TPS); // PSU CS333. Makes ticks per second programmable
80103423:	68 40 42 0f 00       	push   $0xf4240
80103428:	68 e0 00 00 00       	push   $0xe0
8010342d:	e8 8f ff ff ff       	call   801033c1 <lapicw>
80103432:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103435:	68 00 00 01 00       	push   $0x10000
8010343a:	68 d4 00 00 00       	push   $0xd4
8010343f:	e8 7d ff ff ff       	call   801033c1 <lapicw>
80103444:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80103447:	68 00 00 01 00       	push   $0x10000
8010344c:	68 d8 00 00 00       	push   $0xd8
80103451:	e8 6b ff ff ff       	call   801033c1 <lapicw>
80103456:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103459:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010345e:	83 c0 30             	add    $0x30,%eax
80103461:	8b 00                	mov    (%eax),%eax
80103463:	c1 e8 10             	shr    $0x10,%eax
80103466:	0f b6 c0             	movzbl %al,%eax
80103469:	83 f8 03             	cmp    $0x3,%eax
8010346c:	76 12                	jbe    80103480 <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
8010346e:	68 00 00 01 00       	push   $0x10000
80103473:	68 d0 00 00 00       	push   $0xd0
80103478:	e8 44 ff ff ff       	call   801033c1 <lapicw>
8010347d:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80103480:	6a 33                	push   $0x33
80103482:	68 dc 00 00 00       	push   $0xdc
80103487:	e8 35 ff ff ff       	call   801033c1 <lapicw>
8010348c:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010348f:	6a 00                	push   $0x0
80103491:	68 a0 00 00 00       	push   $0xa0
80103496:	e8 26 ff ff ff       	call   801033c1 <lapicw>
8010349b:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
8010349e:	6a 00                	push   $0x0
801034a0:	68 a0 00 00 00       	push   $0xa0
801034a5:	e8 17 ff ff ff       	call   801033c1 <lapicw>
801034aa:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801034ad:	6a 00                	push   $0x0
801034af:	6a 2c                	push   $0x2c
801034b1:	e8 0b ff ff ff       	call   801033c1 <lapicw>
801034b6:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801034b9:	6a 00                	push   $0x0
801034bb:	68 c4 00 00 00       	push   $0xc4
801034c0:	e8 fc fe ff ff       	call   801033c1 <lapicw>
801034c5:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801034c8:	68 00 85 08 00       	push   $0x88500
801034cd:	68 c0 00 00 00       	push   $0xc0
801034d2:	e8 ea fe ff ff       	call   801033c1 <lapicw>
801034d7:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801034da:	90                   	nop
801034db:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801034e0:	05 00 03 00 00       	add    $0x300,%eax
801034e5:	8b 00                	mov    (%eax),%eax
801034e7:	25 00 10 00 00       	and    $0x1000,%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	75 eb                	jne    801034db <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801034f0:	6a 00                	push   $0x0
801034f2:	6a 20                	push   $0x20
801034f4:	e8 c8 fe ff ff       	call   801033c1 <lapicw>
801034f9:	83 c4 08             	add    $0x8,%esp
801034fc:	eb 01                	jmp    801034ff <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
801034fe:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801034ff:	c9                   	leave  
80103500:	c3                   	ret    

80103501 <cpunum>:

int
cpunum(void)
{
80103501:	55                   	push   %ebp
80103502:	89 e5                	mov    %esp,%ebp
80103504:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103507:	e8 a5 fe ff ff       	call   801033b1 <readeflags>
8010350c:	25 00 02 00 00       	and    $0x200,%eax
80103511:	85 c0                	test   %eax,%eax
80103513:	74 26                	je     8010353b <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103515:	a1 80 d6 10 80       	mov    0x8010d680,%eax
8010351a:	8d 50 01             	lea    0x1(%eax),%edx
8010351d:	89 15 80 d6 10 80    	mov    %edx,0x8010d680
80103523:	85 c0                	test   %eax,%eax
80103525:	75 14                	jne    8010353b <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103527:	8b 45 04             	mov    0x4(%ebp),%eax
8010352a:	83 ec 08             	sub    $0x8,%esp
8010352d:	50                   	push   %eax
8010352e:	68 0c a3 10 80       	push   $0x8010a30c
80103533:	e8 8e ce ff ff       	call   801003c6 <cprintf>
80103538:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
8010353b:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103540:	85 c0                	test   %eax,%eax
80103542:	74 0f                	je     80103553 <cpunum+0x52>
    return lapic[ID]>>24;
80103544:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103549:	83 c0 20             	add    $0x20,%eax
8010354c:	8b 00                	mov    (%eax),%eax
8010354e:	c1 e8 18             	shr    $0x18,%eax
80103551:	eb 05                	jmp    80103558 <cpunum+0x57>
  return 0;
80103553:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103558:	c9                   	leave  
80103559:	c3                   	ret    

8010355a <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
8010355a:	55                   	push   %ebp
8010355b:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010355d:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103562:	85 c0                	test   %eax,%eax
80103564:	74 0c                	je     80103572 <lapiceoi+0x18>
    lapicw(EOI, 0);
80103566:	6a 00                	push   $0x0
80103568:	6a 2c                	push   $0x2c
8010356a:	e8 52 fe ff ff       	call   801033c1 <lapicw>
8010356f:	83 c4 08             	add    $0x8,%esp
}
80103572:	90                   	nop
80103573:	c9                   	leave  
80103574:	c3                   	ret    

80103575 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103575:	55                   	push   %ebp
80103576:	89 e5                	mov    %esp,%ebp
}
80103578:	90                   	nop
80103579:	5d                   	pop    %ebp
8010357a:	c3                   	ret    

8010357b <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
8010357b:	55                   	push   %ebp
8010357c:	89 e5                	mov    %esp,%ebp
8010357e:	83 ec 14             	sub    $0x14,%esp
80103581:	8b 45 08             	mov    0x8(%ebp),%eax
80103584:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103587:	6a 0f                	push   $0xf
80103589:	6a 70                	push   $0x70
8010358b:	e8 02 fe ff ff       	call   80103392 <outb>
80103590:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
80103593:	6a 0a                	push   $0xa
80103595:	6a 71                	push   $0x71
80103597:	e8 f6 fd ff ff       	call   80103392 <outb>
8010359c:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010359f:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801035a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801035a9:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801035ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801035b1:	83 c0 02             	add    $0x2,%eax
801035b4:	8b 55 0c             	mov    0xc(%ebp),%edx
801035b7:	c1 ea 04             	shr    $0x4,%edx
801035ba:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801035bd:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801035c1:	c1 e0 18             	shl    $0x18,%eax
801035c4:	50                   	push   %eax
801035c5:	68 c4 00 00 00       	push   $0xc4
801035ca:	e8 f2 fd ff ff       	call   801033c1 <lapicw>
801035cf:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801035d2:	68 00 c5 00 00       	push   $0xc500
801035d7:	68 c0 00 00 00       	push   $0xc0
801035dc:	e8 e0 fd ff ff       	call   801033c1 <lapicw>
801035e1:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801035e4:	68 c8 00 00 00       	push   $0xc8
801035e9:	e8 87 ff ff ff       	call   80103575 <microdelay>
801035ee:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801035f1:	68 00 85 00 00       	push   $0x8500
801035f6:	68 c0 00 00 00       	push   $0xc0
801035fb:	e8 c1 fd ff ff       	call   801033c1 <lapicw>
80103600:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103603:	6a 64                	push   $0x64
80103605:	e8 6b ff ff ff       	call   80103575 <microdelay>
8010360a:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010360d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103614:	eb 3d                	jmp    80103653 <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103616:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
8010361a:	c1 e0 18             	shl    $0x18,%eax
8010361d:	50                   	push   %eax
8010361e:	68 c4 00 00 00       	push   $0xc4
80103623:	e8 99 fd ff ff       	call   801033c1 <lapicw>
80103628:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
8010362b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010362e:	c1 e8 0c             	shr    $0xc,%eax
80103631:	80 cc 06             	or     $0x6,%ah
80103634:	50                   	push   %eax
80103635:	68 c0 00 00 00       	push   $0xc0
8010363a:	e8 82 fd ff ff       	call   801033c1 <lapicw>
8010363f:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103642:	68 c8 00 00 00       	push   $0xc8
80103647:	e8 29 ff ff ff       	call   80103575 <microdelay>
8010364c:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010364f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103653:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103657:	7e bd                	jle    80103616 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103659:	90                   	nop
8010365a:	c9                   	leave  
8010365b:	c3                   	ret    

8010365c <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010365c:	55                   	push   %ebp
8010365d:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010365f:	8b 45 08             	mov    0x8(%ebp),%eax
80103662:	0f b6 c0             	movzbl %al,%eax
80103665:	50                   	push   %eax
80103666:	6a 70                	push   $0x70
80103668:	e8 25 fd ff ff       	call   80103392 <outb>
8010366d:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
80103670:	68 c8 00 00 00       	push   $0xc8
80103675:	e8 fb fe ff ff       	call   80103575 <microdelay>
8010367a:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010367d:	6a 71                	push   $0x71
8010367f:	e8 f1 fc ff ff       	call   80103375 <inb>
80103684:	83 c4 04             	add    $0x4,%esp
80103687:	0f b6 c0             	movzbl %al,%eax
}
8010368a:	c9                   	leave  
8010368b:	c3                   	ret    

8010368c <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010368c:	55                   	push   %ebp
8010368d:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010368f:	6a 00                	push   $0x0
80103691:	e8 c6 ff ff ff       	call   8010365c <cmos_read>
80103696:	83 c4 04             	add    $0x4,%esp
80103699:	89 c2                	mov    %eax,%edx
8010369b:	8b 45 08             	mov    0x8(%ebp),%eax
8010369e:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801036a0:	6a 02                	push   $0x2
801036a2:	e8 b5 ff ff ff       	call   8010365c <cmos_read>
801036a7:	83 c4 04             	add    $0x4,%esp
801036aa:	89 c2                	mov    %eax,%edx
801036ac:	8b 45 08             	mov    0x8(%ebp),%eax
801036af:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801036b2:	6a 04                	push   $0x4
801036b4:	e8 a3 ff ff ff       	call   8010365c <cmos_read>
801036b9:	83 c4 04             	add    $0x4,%esp
801036bc:	89 c2                	mov    %eax,%edx
801036be:	8b 45 08             	mov    0x8(%ebp),%eax
801036c1:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801036c4:	6a 07                	push   $0x7
801036c6:	e8 91 ff ff ff       	call   8010365c <cmos_read>
801036cb:	83 c4 04             	add    $0x4,%esp
801036ce:	89 c2                	mov    %eax,%edx
801036d0:	8b 45 08             	mov    0x8(%ebp),%eax
801036d3:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801036d6:	6a 08                	push   $0x8
801036d8:	e8 7f ff ff ff       	call   8010365c <cmos_read>
801036dd:	83 c4 04             	add    $0x4,%esp
801036e0:	89 c2                	mov    %eax,%edx
801036e2:	8b 45 08             	mov    0x8(%ebp),%eax
801036e5:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801036e8:	6a 09                	push   $0x9
801036ea:	e8 6d ff ff ff       	call   8010365c <cmos_read>
801036ef:	83 c4 04             	add    $0x4,%esp
801036f2:	89 c2                	mov    %eax,%edx
801036f4:	8b 45 08             	mov    0x8(%ebp),%eax
801036f7:	89 50 14             	mov    %edx,0x14(%eax)
}
801036fa:	90                   	nop
801036fb:	c9                   	leave  
801036fc:	c3                   	ret    

801036fd <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801036fd:	55                   	push   %ebp
801036fe:	89 e5                	mov    %esp,%ebp
80103700:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103703:	6a 0b                	push   $0xb
80103705:	e8 52 ff ff ff       	call   8010365c <cmos_read>
8010370a:	83 c4 04             	add    $0x4,%esp
8010370d:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103710:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103713:	83 e0 04             	and    $0x4,%eax
80103716:	85 c0                	test   %eax,%eax
80103718:	0f 94 c0             	sete   %al
8010371b:	0f b6 c0             	movzbl %al,%eax
8010371e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103721:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103724:	50                   	push   %eax
80103725:	e8 62 ff ff ff       	call   8010368c <fill_rtcdate>
8010372a:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010372d:	6a 0a                	push   $0xa
8010372f:	e8 28 ff ff ff       	call   8010365c <cmos_read>
80103734:	83 c4 04             	add    $0x4,%esp
80103737:	25 80 00 00 00       	and    $0x80,%eax
8010373c:	85 c0                	test   %eax,%eax
8010373e:	75 27                	jne    80103767 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103740:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103743:	50                   	push   %eax
80103744:	e8 43 ff ff ff       	call   8010368c <fill_rtcdate>
80103749:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010374c:	83 ec 04             	sub    $0x4,%esp
8010374f:	6a 18                	push   $0x18
80103751:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103754:	50                   	push   %eax
80103755:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103758:	50                   	push   %eax
80103759:	e8 f0 33 00 00       	call   80106b4e <memcmp>
8010375e:	83 c4 10             	add    $0x10,%esp
80103761:	85 c0                	test   %eax,%eax
80103763:	74 05                	je     8010376a <cmostime+0x6d>
80103765:	eb ba                	jmp    80103721 <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103767:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103768:	eb b7                	jmp    80103721 <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
8010376a:	90                   	nop
  }

  // convert
  if (bcd) {
8010376b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010376f:	0f 84 b4 00 00 00    	je     80103829 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103775:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103778:	c1 e8 04             	shr    $0x4,%eax
8010377b:	89 c2                	mov    %eax,%edx
8010377d:	89 d0                	mov    %edx,%eax
8010377f:	c1 e0 02             	shl    $0x2,%eax
80103782:	01 d0                	add    %edx,%eax
80103784:	01 c0                	add    %eax,%eax
80103786:	89 c2                	mov    %eax,%edx
80103788:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010378b:	83 e0 0f             	and    $0xf,%eax
8010378e:	01 d0                	add    %edx,%eax
80103790:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103793:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103796:	c1 e8 04             	shr    $0x4,%eax
80103799:	89 c2                	mov    %eax,%edx
8010379b:	89 d0                	mov    %edx,%eax
8010379d:	c1 e0 02             	shl    $0x2,%eax
801037a0:	01 d0                	add    %edx,%eax
801037a2:	01 c0                	add    %eax,%eax
801037a4:	89 c2                	mov    %eax,%edx
801037a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801037a9:	83 e0 0f             	and    $0xf,%eax
801037ac:	01 d0                	add    %edx,%eax
801037ae:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801037b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801037b4:	c1 e8 04             	shr    $0x4,%eax
801037b7:	89 c2                	mov    %eax,%edx
801037b9:	89 d0                	mov    %edx,%eax
801037bb:	c1 e0 02             	shl    $0x2,%eax
801037be:	01 d0                	add    %edx,%eax
801037c0:	01 c0                	add    %eax,%eax
801037c2:	89 c2                	mov    %eax,%edx
801037c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801037c7:	83 e0 0f             	and    $0xf,%eax
801037ca:	01 d0                	add    %edx,%eax
801037cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801037cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801037d2:	c1 e8 04             	shr    $0x4,%eax
801037d5:	89 c2                	mov    %eax,%edx
801037d7:	89 d0                	mov    %edx,%eax
801037d9:	c1 e0 02             	shl    $0x2,%eax
801037dc:	01 d0                	add    %edx,%eax
801037de:	01 c0                	add    %eax,%eax
801037e0:	89 c2                	mov    %eax,%edx
801037e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801037e5:	83 e0 0f             	and    $0xf,%eax
801037e8:	01 d0                	add    %edx,%eax
801037ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801037ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
801037f0:	c1 e8 04             	shr    $0x4,%eax
801037f3:	89 c2                	mov    %eax,%edx
801037f5:	89 d0                	mov    %edx,%eax
801037f7:	c1 e0 02             	shl    $0x2,%eax
801037fa:	01 d0                	add    %edx,%eax
801037fc:	01 c0                	add    %eax,%eax
801037fe:	89 c2                	mov    %eax,%edx
80103800:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103803:	83 e0 0f             	and    $0xf,%eax
80103806:	01 d0                	add    %edx,%eax
80103808:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010380b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010380e:	c1 e8 04             	shr    $0x4,%eax
80103811:	89 c2                	mov    %eax,%edx
80103813:	89 d0                	mov    %edx,%eax
80103815:	c1 e0 02             	shl    $0x2,%eax
80103818:	01 d0                	add    %edx,%eax
8010381a:	01 c0                	add    %eax,%eax
8010381c:	89 c2                	mov    %eax,%edx
8010381e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103821:	83 e0 0f             	and    $0xf,%eax
80103824:	01 d0                	add    %edx,%eax
80103826:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103829:	8b 45 08             	mov    0x8(%ebp),%eax
8010382c:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010382f:	89 10                	mov    %edx,(%eax)
80103831:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103834:	89 50 04             	mov    %edx,0x4(%eax)
80103837:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010383a:	89 50 08             	mov    %edx,0x8(%eax)
8010383d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103840:	89 50 0c             	mov    %edx,0xc(%eax)
80103843:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103846:	89 50 10             	mov    %edx,0x10(%eax)
80103849:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010384c:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010384f:	8b 45 08             	mov    0x8(%ebp),%eax
80103852:	8b 40 14             	mov    0x14(%eax),%eax
80103855:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010385b:	8b 45 08             	mov    0x8(%ebp),%eax
8010385e:	89 50 14             	mov    %edx,0x14(%eax)
}
80103861:	90                   	nop
80103862:	c9                   	leave  
80103863:	c3                   	ret    

80103864 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103864:	55                   	push   %ebp
80103865:	89 e5                	mov    %esp,%ebp
80103867:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010386a:	83 ec 08             	sub    $0x8,%esp
8010386d:	68 38 a3 10 80       	push   $0x8010a338
80103872:	68 a0 42 11 80       	push   $0x801142a0
80103877:	e8 e6 2f 00 00       	call   80106862 <initlock>
8010387c:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010387f:	83 ec 08             	sub    $0x8,%esp
80103882:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103885:	50                   	push   %eax
80103886:	ff 75 08             	pushl  0x8(%ebp)
80103889:	e8 97 dc ff ff       	call   80101525 <readsb>
8010388e:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103891:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103894:	a3 d4 42 11 80       	mov    %eax,0x801142d4
  log.size = sb.nlog;
80103899:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010389c:	a3 d8 42 11 80       	mov    %eax,0x801142d8
  log.dev = dev;
801038a1:	8b 45 08             	mov    0x8(%ebp),%eax
801038a4:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  recover_from_log();
801038a9:	e8 b2 01 00 00       	call   80103a60 <recover_from_log>
}
801038ae:	90                   	nop
801038af:	c9                   	leave  
801038b0:	c3                   	ret    

801038b1 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801038b1:	55                   	push   %ebp
801038b2:	89 e5                	mov    %esp,%ebp
801038b4:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801038b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801038be:	e9 95 00 00 00       	jmp    80103958 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801038c3:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
801038c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038cc:	01 d0                	add    %edx,%eax
801038ce:	83 c0 01             	add    $0x1,%eax
801038d1:	89 c2                	mov    %eax,%edx
801038d3:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801038d8:	83 ec 08             	sub    $0x8,%esp
801038db:	52                   	push   %edx
801038dc:	50                   	push   %eax
801038dd:	e8 d4 c8 ff ff       	call   801001b6 <bread>
801038e2:	83 c4 10             	add    $0x10,%esp
801038e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801038e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038eb:	83 c0 10             	add    $0x10,%eax
801038ee:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
801038f5:	89 c2                	mov    %eax,%edx
801038f7:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801038fc:	83 ec 08             	sub    $0x8,%esp
801038ff:	52                   	push   %edx
80103900:	50                   	push   %eax
80103901:	e8 b0 c8 ff ff       	call   801001b6 <bread>
80103906:	83 c4 10             	add    $0x10,%esp
80103909:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
8010390c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010390f:	8d 50 18             	lea    0x18(%eax),%edx
80103912:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103915:	83 c0 18             	add    $0x18,%eax
80103918:	83 ec 04             	sub    $0x4,%esp
8010391b:	68 00 02 00 00       	push   $0x200
80103920:	52                   	push   %edx
80103921:	50                   	push   %eax
80103922:	e8 7f 32 00 00       	call   80106ba6 <memmove>
80103927:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010392a:	83 ec 0c             	sub    $0xc,%esp
8010392d:	ff 75 ec             	pushl  -0x14(%ebp)
80103930:	e8 ba c8 ff ff       	call   801001ef <bwrite>
80103935:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103938:	83 ec 0c             	sub    $0xc,%esp
8010393b:	ff 75 f0             	pushl  -0x10(%ebp)
8010393e:	e8 eb c8 ff ff       	call   8010022e <brelse>
80103943:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103946:	83 ec 0c             	sub    $0xc,%esp
80103949:	ff 75 ec             	pushl  -0x14(%ebp)
8010394c:	e8 dd c8 ff ff       	call   8010022e <brelse>
80103951:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103954:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103958:	a1 e8 42 11 80       	mov    0x801142e8,%eax
8010395d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103960:	0f 8f 5d ff ff ff    	jg     801038c3 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103966:	90                   	nop
80103967:	c9                   	leave  
80103968:	c3                   	ret    

80103969 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103969:	55                   	push   %ebp
8010396a:	89 e5                	mov    %esp,%ebp
8010396c:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010396f:	a1 d4 42 11 80       	mov    0x801142d4,%eax
80103974:	89 c2                	mov    %eax,%edx
80103976:	a1 e4 42 11 80       	mov    0x801142e4,%eax
8010397b:	83 ec 08             	sub    $0x8,%esp
8010397e:	52                   	push   %edx
8010397f:	50                   	push   %eax
80103980:	e8 31 c8 ff ff       	call   801001b6 <bread>
80103985:	83 c4 10             	add    $0x10,%esp
80103988:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010398b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010398e:	83 c0 18             	add    $0x18,%eax
80103991:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103994:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103997:	8b 00                	mov    (%eax),%eax
80103999:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  for (i = 0; i < log.lh.n; i++) {
8010399e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039a5:	eb 1b                	jmp    801039c2 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801039a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801039aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
801039ad:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801039b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801039b4:	83 c2 10             	add    $0x10,%edx
801039b7:	89 04 95 ac 42 11 80 	mov    %eax,-0x7feebd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801039be:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801039c2:	a1 e8 42 11 80       	mov    0x801142e8,%eax
801039c7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801039ca:	7f db                	jg     801039a7 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801039cc:	83 ec 0c             	sub    $0xc,%esp
801039cf:	ff 75 f0             	pushl  -0x10(%ebp)
801039d2:	e8 57 c8 ff ff       	call   8010022e <brelse>
801039d7:	83 c4 10             	add    $0x10,%esp
}
801039da:	90                   	nop
801039db:	c9                   	leave  
801039dc:	c3                   	ret    

801039dd <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801039dd:	55                   	push   %ebp
801039de:	89 e5                	mov    %esp,%ebp
801039e0:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801039e3:	a1 d4 42 11 80       	mov    0x801142d4,%eax
801039e8:	89 c2                	mov    %eax,%edx
801039ea:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801039ef:	83 ec 08             	sub    $0x8,%esp
801039f2:	52                   	push   %edx
801039f3:	50                   	push   %eax
801039f4:	e8 bd c7 ff ff       	call   801001b6 <bread>
801039f9:	83 c4 10             	add    $0x10,%esp
801039fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801039ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a02:	83 c0 18             	add    $0x18,%eax
80103a05:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103a08:	8b 15 e8 42 11 80    	mov    0x801142e8,%edx
80103a0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a11:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103a13:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103a1a:	eb 1b                	jmp    80103a37 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1f:	83 c0 10             	add    $0x10,%eax
80103a22:	8b 0c 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%ecx
80103a29:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a2f:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103a33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a37:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a3c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a3f:	7f db                	jg     80103a1c <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80103a41:	83 ec 0c             	sub    $0xc,%esp
80103a44:	ff 75 f0             	pushl  -0x10(%ebp)
80103a47:	e8 a3 c7 ff ff       	call   801001ef <bwrite>
80103a4c:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103a4f:	83 ec 0c             	sub    $0xc,%esp
80103a52:	ff 75 f0             	pushl  -0x10(%ebp)
80103a55:	e8 d4 c7 ff ff       	call   8010022e <brelse>
80103a5a:	83 c4 10             	add    $0x10,%esp
}
80103a5d:	90                   	nop
80103a5e:	c9                   	leave  
80103a5f:	c3                   	ret    

80103a60 <recover_from_log>:

static void
recover_from_log(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103a66:	e8 fe fe ff ff       	call   80103969 <read_head>
  install_trans(); // if committed, copy from log to disk
80103a6b:	e8 41 fe ff ff       	call   801038b1 <install_trans>
  log.lh.n = 0;
80103a70:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103a77:	00 00 00 
  write_head(); // clear the log
80103a7a:	e8 5e ff ff ff       	call   801039dd <write_head>
}
80103a7f:	90                   	nop
80103a80:	c9                   	leave  
80103a81:	c3                   	ret    

80103a82 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103a82:	55                   	push   %ebp
80103a83:	89 e5                	mov    %esp,%ebp
80103a85:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103a88:	83 ec 0c             	sub    $0xc,%esp
80103a8b:	68 a0 42 11 80       	push   $0x801142a0
80103a90:	e8 ef 2d 00 00       	call   80106884 <acquire>
80103a95:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
80103a98:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103a9d:	85 c0                	test   %eax,%eax
80103a9f:	74 17                	je     80103ab8 <begin_op+0x36>
      sleep(&log, &log.lock);
80103aa1:	83 ec 08             	sub    $0x8,%esp
80103aa4:	68 a0 42 11 80       	push   $0x801142a0
80103aa9:	68 a0 42 11 80       	push   $0x801142a0
80103aae:	e8 5c 20 00 00       	call   80105b0f <sleep>
80103ab3:	83 c4 10             	add    $0x10,%esp
80103ab6:	eb e0                	jmp    80103a98 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103ab8:	8b 0d e8 42 11 80    	mov    0x801142e8,%ecx
80103abe:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103ac3:	8d 50 01             	lea    0x1(%eax),%edx
80103ac6:	89 d0                	mov    %edx,%eax
80103ac8:	c1 e0 02             	shl    $0x2,%eax
80103acb:	01 d0                	add    %edx,%eax
80103acd:	01 c0                	add    %eax,%eax
80103acf:	01 c8                	add    %ecx,%eax
80103ad1:	83 f8 1e             	cmp    $0x1e,%eax
80103ad4:	7e 17                	jle    80103aed <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103ad6:	83 ec 08             	sub    $0x8,%esp
80103ad9:	68 a0 42 11 80       	push   $0x801142a0
80103ade:	68 a0 42 11 80       	push   $0x801142a0
80103ae3:	e8 27 20 00 00       	call   80105b0f <sleep>
80103ae8:	83 c4 10             	add    $0x10,%esp
80103aeb:	eb ab                	jmp    80103a98 <begin_op+0x16>
    } else {
      log.outstanding += 1;
80103aed:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103af2:	83 c0 01             	add    $0x1,%eax
80103af5:	a3 dc 42 11 80       	mov    %eax,0x801142dc
      release(&log.lock);
80103afa:	83 ec 0c             	sub    $0xc,%esp
80103afd:	68 a0 42 11 80       	push   $0x801142a0
80103b02:	e8 e4 2d 00 00       	call   801068eb <release>
80103b07:	83 c4 10             	add    $0x10,%esp
      break;
80103b0a:	90                   	nop
    }
  }
}
80103b0b:	90                   	nop
80103b0c:	c9                   	leave  
80103b0d:	c3                   	ret    

80103b0e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103b0e:	55                   	push   %ebp
80103b0f:	89 e5                	mov    %esp,%ebp
80103b11:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103b14:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103b1b:	83 ec 0c             	sub    $0xc,%esp
80103b1e:	68 a0 42 11 80       	push   $0x801142a0
80103b23:	e8 5c 2d 00 00       	call   80106884 <acquire>
80103b28:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103b2b:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103b30:	83 e8 01             	sub    $0x1,%eax
80103b33:	a3 dc 42 11 80       	mov    %eax,0x801142dc
  if(log.committing)
80103b38:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103b3d:	85 c0                	test   %eax,%eax
80103b3f:	74 0d                	je     80103b4e <end_op+0x40>
    panic("log.committing");
80103b41:	83 ec 0c             	sub    $0xc,%esp
80103b44:	68 3c a3 10 80       	push   $0x8010a33c
80103b49:	e8 18 ca ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
80103b4e:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103b53:	85 c0                	test   %eax,%eax
80103b55:	75 13                	jne    80103b6a <end_op+0x5c>
    do_commit = 1;
80103b57:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103b5e:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
80103b65:	00 00 00 
80103b68:	eb 10                	jmp    80103b7a <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	68 a0 42 11 80       	push   $0x801142a0
80103b72:	e8 5f 21 00 00       	call   80105cd6 <wakeup>
80103b77:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103b7a:	83 ec 0c             	sub    $0xc,%esp
80103b7d:	68 a0 42 11 80       	push   $0x801142a0
80103b82:	e8 64 2d 00 00       	call   801068eb <release>
80103b87:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103b8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b8e:	74 3f                	je     80103bcf <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103b90:	e8 f5 00 00 00       	call   80103c8a <commit>
    acquire(&log.lock);
80103b95:	83 ec 0c             	sub    $0xc,%esp
80103b98:	68 a0 42 11 80       	push   $0x801142a0
80103b9d:	e8 e2 2c 00 00       	call   80106884 <acquire>
80103ba2:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103ba5:	c7 05 e0 42 11 80 00 	movl   $0x0,0x801142e0
80103bac:	00 00 00 
    wakeup(&log);
80103baf:	83 ec 0c             	sub    $0xc,%esp
80103bb2:	68 a0 42 11 80       	push   $0x801142a0
80103bb7:	e8 1a 21 00 00       	call   80105cd6 <wakeup>
80103bbc:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
80103bbf:	83 ec 0c             	sub    $0xc,%esp
80103bc2:	68 a0 42 11 80       	push   $0x801142a0
80103bc7:	e8 1f 2d 00 00       	call   801068eb <release>
80103bcc:	83 c4 10             	add    $0x10,%esp
  }
}
80103bcf:	90                   	nop
80103bd0:	c9                   	leave  
80103bd1:	c3                   	ret    

80103bd2 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103bd2:	55                   	push   %ebp
80103bd3:	89 e5                	mov    %esp,%ebp
80103bd5:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103bd8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103bdf:	e9 95 00 00 00       	jmp    80103c79 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103be4:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
80103bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bed:	01 d0                	add    %edx,%eax
80103bef:	83 c0 01             	add    $0x1,%eax
80103bf2:	89 c2                	mov    %eax,%edx
80103bf4:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103bf9:	83 ec 08             	sub    $0x8,%esp
80103bfc:	52                   	push   %edx
80103bfd:	50                   	push   %eax
80103bfe:	e8 b3 c5 ff ff       	call   801001b6 <bread>
80103c03:	83 c4 10             	add    $0x10,%esp
80103c06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c0c:	83 c0 10             	add    $0x10,%eax
80103c0f:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103c16:	89 c2                	mov    %eax,%edx
80103c18:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103c1d:	83 ec 08             	sub    $0x8,%esp
80103c20:	52                   	push   %edx
80103c21:	50                   	push   %eax
80103c22:	e8 8f c5 ff ff       	call   801001b6 <bread>
80103c27:	83 c4 10             	add    $0x10,%esp
80103c2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103c2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c30:	8d 50 18             	lea    0x18(%eax),%edx
80103c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c36:	83 c0 18             	add    $0x18,%eax
80103c39:	83 ec 04             	sub    $0x4,%esp
80103c3c:	68 00 02 00 00       	push   $0x200
80103c41:	52                   	push   %edx
80103c42:	50                   	push   %eax
80103c43:	e8 5e 2f 00 00       	call   80106ba6 <memmove>
80103c48:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103c4b:	83 ec 0c             	sub    $0xc,%esp
80103c4e:	ff 75 f0             	pushl  -0x10(%ebp)
80103c51:	e8 99 c5 ff ff       	call   801001ef <bwrite>
80103c56:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103c59:	83 ec 0c             	sub    $0xc,%esp
80103c5c:	ff 75 ec             	pushl  -0x14(%ebp)
80103c5f:	e8 ca c5 ff ff       	call   8010022e <brelse>
80103c64:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103c67:	83 ec 0c             	sub    $0xc,%esp
80103c6a:	ff 75 f0             	pushl  -0x10(%ebp)
80103c6d:	e8 bc c5 ff ff       	call   8010022e <brelse>
80103c72:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103c75:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103c79:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103c7e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103c81:	0f 8f 5d ff ff ff    	jg     80103be4 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103c87:	90                   	nop
80103c88:	c9                   	leave  
80103c89:	c3                   	ret    

80103c8a <commit>:

static void
commit()
{
80103c8a:	55                   	push   %ebp
80103c8b:	89 e5                	mov    %esp,%ebp
80103c8d:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103c90:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103c95:	85 c0                	test   %eax,%eax
80103c97:	7e 1e                	jle    80103cb7 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103c99:	e8 34 ff ff ff       	call   80103bd2 <write_log>
    write_head();    // Write header to disk -- the real commit
80103c9e:	e8 3a fd ff ff       	call   801039dd <write_head>
    install_trans(); // Now install writes to home locations
80103ca3:	e8 09 fc ff ff       	call   801038b1 <install_trans>
    log.lh.n = 0; 
80103ca8:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103caf:	00 00 00 
    write_head();    // Erase the transaction from the log
80103cb2:	e8 26 fd ff ff       	call   801039dd <write_head>
  }
}
80103cb7:	90                   	nop
80103cb8:	c9                   	leave  
80103cb9:	c3                   	ret    

80103cba <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103cba:	55                   	push   %ebp
80103cbb:	89 e5                	mov    %esp,%ebp
80103cbd:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103cc0:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103cc5:	83 f8 1d             	cmp    $0x1d,%eax
80103cc8:	7f 12                	jg     80103cdc <log_write+0x22>
80103cca:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103ccf:	8b 15 d8 42 11 80    	mov    0x801142d8,%edx
80103cd5:	83 ea 01             	sub    $0x1,%edx
80103cd8:	39 d0                	cmp    %edx,%eax
80103cda:	7c 0d                	jl     80103ce9 <log_write+0x2f>
    panic("too big a transaction");
80103cdc:	83 ec 0c             	sub    $0xc,%esp
80103cdf:	68 4b a3 10 80       	push   $0x8010a34b
80103ce4:	e8 7d c8 ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103ce9:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103cee:	85 c0                	test   %eax,%eax
80103cf0:	7f 0d                	jg     80103cff <log_write+0x45>
    panic("log_write outside of trans");
80103cf2:	83 ec 0c             	sub    $0xc,%esp
80103cf5:	68 61 a3 10 80       	push   $0x8010a361
80103cfa:	e8 67 c8 ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103cff:	83 ec 0c             	sub    $0xc,%esp
80103d02:	68 a0 42 11 80       	push   $0x801142a0
80103d07:	e8 78 2b 00 00       	call   80106884 <acquire>
80103d0c:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103d0f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103d16:	eb 1d                	jmp    80103d35 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d1b:	83 c0 10             	add    $0x10,%eax
80103d1e:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103d25:	89 c2                	mov    %eax,%edx
80103d27:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2a:	8b 40 08             	mov    0x8(%eax),%eax
80103d2d:	39 c2                	cmp    %eax,%edx
80103d2f:	74 10                	je     80103d41 <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103d31:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103d35:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103d3a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d3d:	7f d9                	jg     80103d18 <log_write+0x5e>
80103d3f:	eb 01                	jmp    80103d42 <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103d41:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103d42:	8b 45 08             	mov    0x8(%ebp),%eax
80103d45:	8b 40 08             	mov    0x8(%eax),%eax
80103d48:	89 c2                	mov    %eax,%edx
80103d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d4d:	83 c0 10             	add    $0x10,%eax
80103d50:	89 14 85 ac 42 11 80 	mov    %edx,-0x7feebd54(,%eax,4)
  if (i == log.lh.n)
80103d57:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103d5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d5f:	75 0d                	jne    80103d6e <log_write+0xb4>
    log.lh.n++;
80103d61:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103d66:	83 c0 01             	add    $0x1,%eax
80103d69:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  b->flags |= B_DIRTY; // prevent eviction
80103d6e:	8b 45 08             	mov    0x8(%ebp),%eax
80103d71:	8b 00                	mov    (%eax),%eax
80103d73:	83 c8 04             	or     $0x4,%eax
80103d76:	89 c2                	mov    %eax,%edx
80103d78:	8b 45 08             	mov    0x8(%ebp),%eax
80103d7b:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103d7d:	83 ec 0c             	sub    $0xc,%esp
80103d80:	68 a0 42 11 80       	push   $0x801142a0
80103d85:	e8 61 2b 00 00       	call   801068eb <release>
80103d8a:	83 c4 10             	add    $0x10,%esp
}
80103d8d:	90                   	nop
80103d8e:	c9                   	leave  
80103d8f:	c3                   	ret    

80103d90 <v2p>:
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	8b 45 08             	mov    0x8(%ebp),%eax
80103d96:	05 00 00 00 80       	add    $0x80000000,%eax
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret    

80103d9d <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103d9d:	55                   	push   %ebp
80103d9e:	89 e5                	mov    %esp,%ebp
80103da0:	8b 45 08             	mov    0x8(%ebp),%eax
80103da3:	05 00 00 00 80       	add    $0x80000000,%eax
80103da8:	5d                   	pop    %ebp
80103da9:	c3                   	ret    

80103daa <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103daa:	55                   	push   %ebp
80103dab:	89 e5                	mov    %esp,%ebp
80103dad:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103db0:	8b 55 08             	mov    0x8(%ebp),%edx
80103db3:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103db9:	f0 87 02             	lock xchg %eax,(%edx)
80103dbc:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103dc2:	c9                   	leave  
80103dc3:	c3                   	ret    

80103dc4 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103dc4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103dc8:	83 e4 f0             	and    $0xfffffff0,%esp
80103dcb:	ff 71 fc             	pushl  -0x4(%ecx)
80103dce:	55                   	push   %ebp
80103dcf:	89 e5                	mov    %esp,%ebp
80103dd1:	51                   	push   %ecx
80103dd2:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103dd5:	83 ec 08             	sub    $0x8,%esp
80103dd8:	68 00 00 40 80       	push   $0x80400000
80103ddd:	68 dc 74 11 80       	push   $0x801174dc
80103de2:	e8 7d f2 ff ff       	call   80103064 <kinit1>
80103de7:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103dea:	e8 5c 5b 00 00       	call   8010994b <kvmalloc>
  mpinit();        // collect info about this machine
80103def:	e8 43 04 00 00       	call   80104237 <mpinit>
  lapicinit();
80103df4:	e8 ea f5 ff ff       	call   801033e3 <lapicinit>
  seginit();       // set up segments
80103df9:	e8 f6 54 00 00       	call   801092f4 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103dfe:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103e04:	0f b6 00             	movzbl (%eax),%eax
80103e07:	0f b6 c0             	movzbl %al,%eax
80103e0a:	83 ec 08             	sub    $0x8,%esp
80103e0d:	50                   	push   %eax
80103e0e:	68 7c a3 10 80       	push   $0x8010a37c
80103e13:	e8 ae c5 ff ff       	call   801003c6 <cprintf>
80103e18:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103e1b:	e8 6d 06 00 00       	call   8010448d <picinit>
  ioapicinit();    // another interrupt controller
80103e20:	e8 34 f1 ff ff       	call   80102f59 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103e25:	e8 99 cd ff ff       	call   80100bc3 <consoleinit>
  uartinit();      // serial port
80103e2a:	e8 21 48 00 00       	call   80108650 <uartinit>
  pinit();         // process table
80103e2f:	e8 a1 0c 00 00       	call   80104ad5 <pinit>
  tvinit();        // trap vectors
80103e34:	e8 f0 43 00 00       	call   80108229 <tvinit>
  binit();         // buffer cache
80103e39:	e8 f6 c1 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103e3e:	e8 d3 d2 ff ff       	call   80101116 <fileinit>
  ideinit();       // disk
80103e43:	e8 19 ed ff ff       	call   80102b61 <ideinit>
  if(!ismp)
80103e48:	a1 84 43 11 80       	mov    0x80114384,%eax
80103e4d:	85 c0                	test   %eax,%eax
80103e4f:	75 05                	jne    80103e56 <main+0x92>
    timerinit();   // uniprocessor timer
80103e51:	e8 24 43 00 00       	call   8010817a <timerinit>
  startothers();   // start other processors
80103e56:	e8 7f 00 00 00       	call   80103eda <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103e5b:	83 ec 08             	sub    $0x8,%esp
80103e5e:	68 00 00 00 8e       	push   $0x8e000000
80103e63:	68 00 00 40 80       	push   $0x80400000
80103e68:	e8 30 f2 ff ff       	call   8010309d <kinit2>
80103e6d:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103e70:	e8 28 0e 00 00       	call   80104c9d <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103e75:	e8 1a 00 00 00       	call   80103e94 <mpmain>

80103e7a <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103e7a:	55                   	push   %ebp
80103e7b:	89 e5                	mov    %esp,%ebp
80103e7d:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103e80:	e8 de 5a 00 00       	call   80109963 <switchkvm>
  seginit();
80103e85:	e8 6a 54 00 00       	call   801092f4 <seginit>
  lapicinit();
80103e8a:	e8 54 f5 ff ff       	call   801033e3 <lapicinit>
  mpmain();
80103e8f:	e8 00 00 00 00       	call   80103e94 <mpmain>

80103e94 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103e9a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ea0:	0f b6 00             	movzbl (%eax),%eax
80103ea3:	0f b6 c0             	movzbl %al,%eax
80103ea6:	83 ec 08             	sub    $0x8,%esp
80103ea9:	50                   	push   %eax
80103eaa:	68 93 a3 10 80       	push   $0x8010a393
80103eaf:	e8 12 c5 ff ff       	call   801003c6 <cprintf>
80103eb4:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103eb7:	e8 ce 44 00 00       	call   8010838a <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103ebc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103ec2:	05 a8 00 00 00       	add    $0xa8,%eax
80103ec7:	83 ec 08             	sub    $0x8,%esp
80103eca:	6a 01                	push   $0x1
80103ecc:	50                   	push   %eax
80103ecd:	e8 d8 fe ff ff       	call   80103daa <xchg>
80103ed2:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103ed5:	e8 5d 17 00 00       	call   80105637 <scheduler>

80103eda <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103eda:	55                   	push   %ebp
80103edb:	89 e5                	mov    %esp,%ebp
80103edd:	53                   	push   %ebx
80103ede:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103ee1:	68 00 70 00 00       	push   $0x7000
80103ee6:	e8 b2 fe ff ff       	call   80103d9d <p2v>
80103eeb:	83 c4 04             	add    $0x4,%esp
80103eee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103ef1:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103ef6:	83 ec 04             	sub    $0x4,%esp
80103ef9:	50                   	push   %eax
80103efa:	68 4c d5 10 80       	push   $0x8010d54c
80103eff:	ff 75 f0             	pushl  -0x10(%ebp)
80103f02:	e8 9f 2c 00 00       	call   80106ba6 <memmove>
80103f07:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103f0a:	c7 45 f4 a0 43 11 80 	movl   $0x801143a0,-0xc(%ebp)
80103f11:	e9 90 00 00 00       	jmp    80103fa6 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103f16:	e8 e6 f5 ff ff       	call   80103501 <cpunum>
80103f1b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103f21:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103f26:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103f29:	74 73                	je     80103f9e <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103f2b:	e8 6b f2 ff ff       	call   8010319b <kalloc>
80103f30:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103f33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f36:	83 e8 04             	sub    $0x4,%eax
80103f39:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103f3c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103f42:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f47:	83 e8 08             	sub    $0x8,%eax
80103f4a:	c7 00 7a 3e 10 80    	movl   $0x80103e7a,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103f50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f53:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103f56:	83 ec 0c             	sub    $0xc,%esp
80103f59:	68 00 c0 10 80       	push   $0x8010c000
80103f5e:	e8 2d fe ff ff       	call   80103d90 <v2p>
80103f63:	83 c4 10             	add    $0x10,%esp
80103f66:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103f68:	83 ec 0c             	sub    $0xc,%esp
80103f6b:	ff 75 f0             	pushl  -0x10(%ebp)
80103f6e:	e8 1d fe ff ff       	call   80103d90 <v2p>
80103f73:	83 c4 10             	add    $0x10,%esp
80103f76:	89 c2                	mov    %eax,%edx
80103f78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f7b:	0f b6 00             	movzbl (%eax),%eax
80103f7e:	0f b6 c0             	movzbl %al,%eax
80103f81:	83 ec 08             	sub    $0x8,%esp
80103f84:	52                   	push   %edx
80103f85:	50                   	push   %eax
80103f86:	e8 f0 f5 ff ff       	call   8010357b <lapicstartap>
80103f8b:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103f8e:	90                   	nop
80103f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f92:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103f98:	85 c0                	test   %eax,%eax
80103f9a:	74 f3                	je     80103f8f <startothers+0xb5>
80103f9c:	eb 01                	jmp    80103f9f <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103f9e:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103f9f:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103fa6:	a1 18 45 11 80       	mov    0x80114518,%eax
80103fab:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103fb1:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103fb6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103fb9:	0f 87 57 ff ff ff    	ja     80103f16 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103fbf:	90                   	nop
80103fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc3:	c9                   	leave  
80103fc4:	c3                   	ret    

80103fc5 <p2v>:
80103fc5:	55                   	push   %ebp
80103fc6:	89 e5                	mov    %esp,%ebp
80103fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcb:	05 00 00 00 80       	add    $0x80000000,%eax
80103fd0:	5d                   	pop    %ebp
80103fd1:	c3                   	ret    

80103fd2 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103fd2:	55                   	push   %ebp
80103fd3:	89 e5                	mov    %esp,%ebp
80103fd5:	83 ec 14             	sub    $0x14,%esp
80103fd8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103fdf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103fe3:	89 c2                	mov    %eax,%edx
80103fe5:	ec                   	in     (%dx),%al
80103fe6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103fe9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103fed:	c9                   	leave  
80103fee:	c3                   	ret    

80103fef <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103fef:	55                   	push   %ebp
80103ff0:	89 e5                	mov    %esp,%ebp
80103ff2:	83 ec 08             	sub    $0x8,%esp
80103ff5:	8b 55 08             	mov    0x8(%ebp),%edx
80103ff8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ffb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103fff:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80104002:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104006:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010400a:	ee                   	out    %al,(%dx)
}
8010400b:	90                   	nop
8010400c:	c9                   	leave  
8010400d:	c3                   	ret    

8010400e <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010400e:	55                   	push   %ebp
8010400f:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80104011:	a1 84 d6 10 80       	mov    0x8010d684,%eax
80104016:	89 c2                	mov    %eax,%edx
80104018:	b8 a0 43 11 80       	mov    $0x801143a0,%eax
8010401d:	29 c2                	sub    %eax,%edx
8010401f:	89 d0                	mov    %edx,%eax
80104021:	c1 f8 02             	sar    $0x2,%eax
80104024:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010402a:	5d                   	pop    %ebp
8010402b:	c3                   	ret    

8010402c <sum>:

static uchar
sum(uchar *addr, int len)
{
8010402c:	55                   	push   %ebp
8010402d:	89 e5                	mov    %esp,%ebp
8010402f:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80104032:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80104039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80104040:	eb 15                	jmp    80104057 <sum+0x2b>
    sum += addr[i];
80104042:	8b 55 fc             	mov    -0x4(%ebp),%edx
80104045:	8b 45 08             	mov    0x8(%ebp),%eax
80104048:	01 d0                	add    %edx,%eax
8010404a:	0f b6 00             	movzbl (%eax),%eax
8010404d:	0f b6 c0             	movzbl %al,%eax
80104050:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80104053:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80104057:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010405a:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010405d:	7c e3                	jl     80104042 <sum+0x16>
    sum += addr[i];
  return sum;
8010405f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104062:	c9                   	leave  
80104063:	c3                   	ret    

80104064 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80104064:	55                   	push   %ebp
80104065:	89 e5                	mov    %esp,%ebp
80104067:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
8010406a:	ff 75 08             	pushl  0x8(%ebp)
8010406d:	e8 53 ff ff ff       	call   80103fc5 <p2v>
80104072:	83 c4 04             	add    $0x4,%esp
80104075:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80104078:	8b 55 0c             	mov    0xc(%ebp),%edx
8010407b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010407e:	01 d0                	add    %edx,%eax
80104080:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80104083:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104086:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104089:	eb 36                	jmp    801040c1 <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010408b:	83 ec 04             	sub    $0x4,%esp
8010408e:	6a 04                	push   $0x4
80104090:	68 a4 a3 10 80       	push   $0x8010a3a4
80104095:	ff 75 f4             	pushl  -0xc(%ebp)
80104098:	e8 b1 2a 00 00       	call   80106b4e <memcmp>
8010409d:	83 c4 10             	add    $0x10,%esp
801040a0:	85 c0                	test   %eax,%eax
801040a2:	75 19                	jne    801040bd <mpsearch1+0x59>
801040a4:	83 ec 08             	sub    $0x8,%esp
801040a7:	6a 10                	push   $0x10
801040a9:	ff 75 f4             	pushl  -0xc(%ebp)
801040ac:	e8 7b ff ff ff       	call   8010402c <sum>
801040b1:	83 c4 10             	add    $0x10,%esp
801040b4:	84 c0                	test   %al,%al
801040b6:	75 05                	jne    801040bd <mpsearch1+0x59>
      return (struct mp*)p;
801040b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040bb:	eb 11                	jmp    801040ce <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
801040bd:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801040c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801040c7:	72 c2                	jb     8010408b <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
801040c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801040ce:	c9                   	leave  
801040cf:	c3                   	ret    

801040d0 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
801040d6:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801040dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040e0:	83 c0 0f             	add    $0xf,%eax
801040e3:	0f b6 00             	movzbl (%eax),%eax
801040e6:	0f b6 c0             	movzbl %al,%eax
801040e9:	c1 e0 08             	shl    $0x8,%eax
801040ec:	89 c2                	mov    %eax,%edx
801040ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f1:	83 c0 0e             	add    $0xe,%eax
801040f4:	0f b6 00             	movzbl (%eax),%eax
801040f7:	0f b6 c0             	movzbl %al,%eax
801040fa:	09 d0                	or     %edx,%eax
801040fc:	c1 e0 04             	shl    $0x4,%eax
801040ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104102:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104106:	74 21                	je     80104129 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80104108:	83 ec 08             	sub    $0x8,%esp
8010410b:	68 00 04 00 00       	push   $0x400
80104110:	ff 75 f0             	pushl  -0x10(%ebp)
80104113:	e8 4c ff ff ff       	call   80104064 <mpsearch1>
80104118:	83 c4 10             	add    $0x10,%esp
8010411b:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010411e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80104122:	74 51                	je     80104175 <mpsearch+0xa5>
      return mp;
80104124:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104127:	eb 61                	jmp    8010418a <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80104129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010412c:	83 c0 14             	add    $0x14,%eax
8010412f:	0f b6 00             	movzbl (%eax),%eax
80104132:	0f b6 c0             	movzbl %al,%eax
80104135:	c1 e0 08             	shl    $0x8,%eax
80104138:	89 c2                	mov    %eax,%edx
8010413a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413d:	83 c0 13             	add    $0x13,%eax
80104140:	0f b6 00             	movzbl (%eax),%eax
80104143:	0f b6 c0             	movzbl %al,%eax
80104146:	09 d0                	or     %edx,%eax
80104148:	c1 e0 0a             	shl    $0xa,%eax
8010414b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
8010414e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104151:	2d 00 04 00 00       	sub    $0x400,%eax
80104156:	83 ec 08             	sub    $0x8,%esp
80104159:	68 00 04 00 00       	push   $0x400
8010415e:	50                   	push   %eax
8010415f:	e8 00 ff ff ff       	call   80104064 <mpsearch1>
80104164:	83 c4 10             	add    $0x10,%esp
80104167:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010416a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010416e:	74 05                	je     80104175 <mpsearch+0xa5>
      return mp;
80104170:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104173:	eb 15                	jmp    8010418a <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80104175:	83 ec 08             	sub    $0x8,%esp
80104178:	68 00 00 01 00       	push   $0x10000
8010417d:	68 00 00 0f 00       	push   $0xf0000
80104182:	e8 dd fe ff ff       	call   80104064 <mpsearch1>
80104187:	83 c4 10             	add    $0x10,%esp
}
8010418a:	c9                   	leave  
8010418b:	c3                   	ret    

8010418c <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
8010418c:	55                   	push   %ebp
8010418d:	89 e5                	mov    %esp,%ebp
8010418f:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80104192:	e8 39 ff ff ff       	call   801040d0 <mpsearch>
80104197:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010419a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010419e:	74 0a                	je     801041aa <mpconfig+0x1e>
801041a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a3:	8b 40 04             	mov    0x4(%eax),%eax
801041a6:	85 c0                	test   %eax,%eax
801041a8:	75 0a                	jne    801041b4 <mpconfig+0x28>
    return 0;
801041aa:	b8 00 00 00 00       	mov    $0x0,%eax
801041af:	e9 81 00 00 00       	jmp    80104235 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
801041b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b7:	8b 40 04             	mov    0x4(%eax),%eax
801041ba:	83 ec 0c             	sub    $0xc,%esp
801041bd:	50                   	push   %eax
801041be:	e8 02 fe ff ff       	call   80103fc5 <p2v>
801041c3:	83 c4 10             	add    $0x10,%esp
801041c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801041c9:	83 ec 04             	sub    $0x4,%esp
801041cc:	6a 04                	push   $0x4
801041ce:	68 a9 a3 10 80       	push   $0x8010a3a9
801041d3:	ff 75 f0             	pushl  -0x10(%ebp)
801041d6:	e8 73 29 00 00       	call   80106b4e <memcmp>
801041db:	83 c4 10             	add    $0x10,%esp
801041de:	85 c0                	test   %eax,%eax
801041e0:	74 07                	je     801041e9 <mpconfig+0x5d>
    return 0;
801041e2:	b8 00 00 00 00       	mov    $0x0,%eax
801041e7:	eb 4c                	jmp    80104235 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
801041e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041ec:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801041f0:	3c 01                	cmp    $0x1,%al
801041f2:	74 12                	je     80104206 <mpconfig+0x7a>
801041f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801041f7:	0f b6 40 06          	movzbl 0x6(%eax),%eax
801041fb:	3c 04                	cmp    $0x4,%al
801041fd:	74 07                	je     80104206 <mpconfig+0x7a>
    return 0;
801041ff:	b8 00 00 00 00       	mov    $0x0,%eax
80104204:	eb 2f                	jmp    80104235 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80104206:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104209:	0f b7 40 04          	movzwl 0x4(%eax),%eax
8010420d:	0f b7 c0             	movzwl %ax,%eax
80104210:	83 ec 08             	sub    $0x8,%esp
80104213:	50                   	push   %eax
80104214:	ff 75 f0             	pushl  -0x10(%ebp)
80104217:	e8 10 fe ff ff       	call   8010402c <sum>
8010421c:	83 c4 10             	add    $0x10,%esp
8010421f:	84 c0                	test   %al,%al
80104221:	74 07                	je     8010422a <mpconfig+0x9e>
    return 0;
80104223:	b8 00 00 00 00       	mov    $0x0,%eax
80104228:	eb 0b                	jmp    80104235 <mpconfig+0xa9>
  *pmp = mp;
8010422a:	8b 45 08             	mov    0x8(%ebp),%eax
8010422d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104230:	89 10                	mov    %edx,(%eax)
  return conf;
80104232:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104235:	c9                   	leave  
80104236:	c3                   	ret    

80104237 <mpinit>:

void
mpinit(void)
{
80104237:	55                   	push   %ebp
80104238:	89 e5                	mov    %esp,%ebp
8010423a:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
8010423d:	c7 05 84 d6 10 80 a0 	movl   $0x801143a0,0x8010d684
80104244:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80104247:	83 ec 0c             	sub    $0xc,%esp
8010424a:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010424d:	50                   	push   %eax
8010424e:	e8 39 ff ff ff       	call   8010418c <mpconfig>
80104253:	83 c4 10             	add    $0x10,%esp
80104256:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104259:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010425d:	0f 84 96 01 00 00    	je     801043f9 <mpinit+0x1c2>
    return;
  ismp = 1;
80104263:	c7 05 84 43 11 80 01 	movl   $0x1,0x80114384
8010426a:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
8010426d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104270:	8b 40 24             	mov    0x24(%eax),%eax
80104273:	a3 9c 42 11 80       	mov    %eax,0x8011429c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104278:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010427b:	83 c0 2c             	add    $0x2c,%eax
8010427e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104281:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104284:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104288:	0f b7 d0             	movzwl %ax,%edx
8010428b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010428e:	01 d0                	add    %edx,%eax
80104290:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104293:	e9 f2 00 00 00       	jmp    8010438a <mpinit+0x153>
    switch(*p){
80104298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429b:	0f b6 00             	movzbl (%eax),%eax
8010429e:	0f b6 c0             	movzbl %al,%eax
801042a1:	83 f8 04             	cmp    $0x4,%eax
801042a4:	0f 87 bc 00 00 00    	ja     80104366 <mpinit+0x12f>
801042aa:	8b 04 85 ec a3 10 80 	mov    -0x7fef5c14(,%eax,4),%eax
801042b1:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801042b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b6:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801042b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042bc:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801042c0:	0f b6 d0             	movzbl %al,%edx
801042c3:	a1 18 45 11 80       	mov    0x80114518,%eax
801042c8:	39 c2                	cmp    %eax,%edx
801042ca:	74 2b                	je     801042f7 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801042cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042cf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801042d3:	0f b6 d0             	movzbl %al,%edx
801042d6:	a1 18 45 11 80       	mov    0x80114518,%eax
801042db:	83 ec 04             	sub    $0x4,%esp
801042de:	52                   	push   %edx
801042df:	50                   	push   %eax
801042e0:	68 ae a3 10 80       	push   $0x8010a3ae
801042e5:	e8 dc c0 ff ff       	call   801003c6 <cprintf>
801042ea:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
801042ed:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
801042f4:	00 00 00 
      }
      if(proc->flags & MPBOOT)
801042f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801042fa:	0f b6 40 03          	movzbl 0x3(%eax),%eax
801042fe:	0f b6 c0             	movzbl %al,%eax
80104301:	83 e0 02             	and    $0x2,%eax
80104304:	85 c0                	test   %eax,%eax
80104306:	74 15                	je     8010431d <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80104308:	a1 18 45 11 80       	mov    0x80114518,%eax
8010430d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80104313:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104318:	a3 84 d6 10 80       	mov    %eax,0x8010d684
      cpus[ncpu].id = ncpu;
8010431d:	a1 18 45 11 80       	mov    0x80114518,%eax
80104322:	8b 15 18 45 11 80    	mov    0x80114518,%edx
80104328:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010432e:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104333:	88 10                	mov    %dl,(%eax)
      ncpu++;
80104335:	a1 18 45 11 80       	mov    0x80114518,%eax
8010433a:	83 c0 01             	add    $0x1,%eax
8010433d:	a3 18 45 11 80       	mov    %eax,0x80114518
      p += sizeof(struct mpproc);
80104342:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80104346:	eb 42                	jmp    8010438a <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80104348:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
8010434e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104351:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104355:	a2 80 43 11 80       	mov    %al,0x80114380
      p += sizeof(struct mpioapic);
8010435a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010435e:	eb 2a                	jmp    8010438a <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80104360:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104364:	eb 24                	jmp    8010438a <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80104366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104369:	0f b6 00             	movzbl (%eax),%eax
8010436c:	0f b6 c0             	movzbl %al,%eax
8010436f:	83 ec 08             	sub    $0x8,%esp
80104372:	50                   	push   %eax
80104373:	68 cc a3 10 80       	push   $0x8010a3cc
80104378:	e8 49 c0 ff ff       	call   801003c6 <cprintf>
8010437d:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80104380:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
80104387:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010438a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104390:	0f 82 02 ff ff ff    	jb     80104298 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80104396:	a1 84 43 11 80       	mov    0x80114384,%eax
8010439b:	85 c0                	test   %eax,%eax
8010439d:	75 1d                	jne    801043bc <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
8010439f:	c7 05 18 45 11 80 01 	movl   $0x1,0x80114518
801043a6:	00 00 00 
    lapic = 0;
801043a9:	c7 05 9c 42 11 80 00 	movl   $0x0,0x8011429c
801043b0:	00 00 00 
    ioapicid = 0;
801043b3:	c6 05 80 43 11 80 00 	movb   $0x0,0x80114380
    return;
801043ba:	eb 3e                	jmp    801043fa <mpinit+0x1c3>
  }

  if(mp->imcrp){
801043bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043bf:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801043c3:	84 c0                	test   %al,%al
801043c5:	74 33                	je     801043fa <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801043c7:	83 ec 08             	sub    $0x8,%esp
801043ca:	6a 70                	push   $0x70
801043cc:	6a 22                	push   $0x22
801043ce:	e8 1c fc ff ff       	call   80103fef <outb>
801043d3:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801043d6:	83 ec 0c             	sub    $0xc,%esp
801043d9:	6a 23                	push   $0x23
801043db:	e8 f2 fb ff ff       	call   80103fd2 <inb>
801043e0:	83 c4 10             	add    $0x10,%esp
801043e3:	83 c8 01             	or     $0x1,%eax
801043e6:	0f b6 c0             	movzbl %al,%eax
801043e9:	83 ec 08             	sub    $0x8,%esp
801043ec:	50                   	push   %eax
801043ed:	6a 23                	push   $0x23
801043ef:	e8 fb fb ff ff       	call   80103fef <outb>
801043f4:	83 c4 10             	add    $0x10,%esp
801043f7:	eb 01                	jmp    801043fa <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
801043f9:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
801043fa:	c9                   	leave  
801043fb:	c3                   	ret    

801043fc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801043fc:	55                   	push   %ebp
801043fd:	89 e5                	mov    %esp,%ebp
801043ff:	83 ec 08             	sub    $0x8,%esp
80104402:	8b 55 08             	mov    0x8(%ebp),%edx
80104405:	8b 45 0c             	mov    0xc(%ebp),%eax
80104408:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010440c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010440f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80104413:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80104417:	ee                   	out    %al,(%dx)
}
80104418:	90                   	nop
80104419:	c9                   	leave  
8010441a:	c3                   	ret    

8010441b <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
8010441b:	55                   	push   %ebp
8010441c:	89 e5                	mov    %esp,%ebp
8010441e:	83 ec 04             	sub    $0x4,%esp
80104421:	8b 45 08             	mov    0x8(%ebp),%eax
80104424:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80104428:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010442c:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
80104432:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104436:	0f b6 c0             	movzbl %al,%eax
80104439:	50                   	push   %eax
8010443a:	6a 21                	push   $0x21
8010443c:	e8 bb ff ff ff       	call   801043fc <outb>
80104441:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104444:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104448:	66 c1 e8 08          	shr    $0x8,%ax
8010444c:	0f b6 c0             	movzbl %al,%eax
8010444f:	50                   	push   %eax
80104450:	68 a1 00 00 00       	push   $0xa1
80104455:	e8 a2 ff ff ff       	call   801043fc <outb>
8010445a:	83 c4 08             	add    $0x8,%esp
}
8010445d:	90                   	nop
8010445e:	c9                   	leave  
8010445f:	c3                   	ret    

80104460 <picenable>:

void
picenable(int irq)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80104463:	8b 45 08             	mov    0x8(%ebp),%eax
80104466:	ba 01 00 00 00       	mov    $0x1,%edx
8010446b:	89 c1                	mov    %eax,%ecx
8010446d:	d3 e2                	shl    %cl,%edx
8010446f:	89 d0                	mov    %edx,%eax
80104471:	f7 d0                	not    %eax
80104473:	89 c2                	mov    %eax,%edx
80104475:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010447c:	21 d0                	and    %edx,%eax
8010447e:	0f b7 c0             	movzwl %ax,%eax
80104481:	50                   	push   %eax
80104482:	e8 94 ff ff ff       	call   8010441b <picsetmask>
80104487:	83 c4 04             	add    $0x4,%esp
}
8010448a:	90                   	nop
8010448b:	c9                   	leave  
8010448c:	c3                   	ret    

8010448d <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
8010448d:	55                   	push   %ebp
8010448e:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80104490:	68 ff 00 00 00       	push   $0xff
80104495:	6a 21                	push   $0x21
80104497:	e8 60 ff ff ff       	call   801043fc <outb>
8010449c:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
8010449f:	68 ff 00 00 00       	push   $0xff
801044a4:	68 a1 00 00 00       	push   $0xa1
801044a9:	e8 4e ff ff ff       	call   801043fc <outb>
801044ae:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801044b1:	6a 11                	push   $0x11
801044b3:	6a 20                	push   $0x20
801044b5:	e8 42 ff ff ff       	call   801043fc <outb>
801044ba:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801044bd:	6a 20                	push   $0x20
801044bf:	6a 21                	push   $0x21
801044c1:	e8 36 ff ff ff       	call   801043fc <outb>
801044c6:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801044c9:	6a 04                	push   $0x4
801044cb:	6a 21                	push   $0x21
801044cd:	e8 2a ff ff ff       	call   801043fc <outb>
801044d2:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801044d5:	6a 03                	push   $0x3
801044d7:	6a 21                	push   $0x21
801044d9:	e8 1e ff ff ff       	call   801043fc <outb>
801044de:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801044e1:	6a 11                	push   $0x11
801044e3:	68 a0 00 00 00       	push   $0xa0
801044e8:	e8 0f ff ff ff       	call   801043fc <outb>
801044ed:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801044f0:	6a 28                	push   $0x28
801044f2:	68 a1 00 00 00       	push   $0xa1
801044f7:	e8 00 ff ff ff       	call   801043fc <outb>
801044fc:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
801044ff:	6a 02                	push   $0x2
80104501:	68 a1 00 00 00       	push   $0xa1
80104506:	e8 f1 fe ff ff       	call   801043fc <outb>
8010450b:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010450e:	6a 03                	push   $0x3
80104510:	68 a1 00 00 00       	push   $0xa1
80104515:	e8 e2 fe ff ff       	call   801043fc <outb>
8010451a:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010451d:	6a 68                	push   $0x68
8010451f:	6a 20                	push   $0x20
80104521:	e8 d6 fe ff ff       	call   801043fc <outb>
80104526:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104529:	6a 0a                	push   $0xa
8010452b:	6a 20                	push   $0x20
8010452d:	e8 ca fe ff ff       	call   801043fc <outb>
80104532:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104535:	6a 68                	push   $0x68
80104537:	68 a0 00 00 00       	push   $0xa0
8010453c:	e8 bb fe ff ff       	call   801043fc <outb>
80104541:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104544:	6a 0a                	push   $0xa
80104546:	68 a0 00 00 00       	push   $0xa0
8010454b:	e8 ac fe ff ff       	call   801043fc <outb>
80104550:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104553:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
8010455a:	66 83 f8 ff          	cmp    $0xffff,%ax
8010455e:	74 13                	je     80104573 <picinit+0xe6>
    picsetmask(irqmask);
80104560:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104567:	0f b7 c0             	movzwl %ax,%eax
8010456a:	50                   	push   %eax
8010456b:	e8 ab fe ff ff       	call   8010441b <picsetmask>
80104570:	83 c4 04             	add    $0x4,%esp
}
80104573:	90                   	nop
80104574:	c9                   	leave  
80104575:	c3                   	ret    

80104576 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104576:	55                   	push   %ebp
80104577:	89 e5                	mov    %esp,%ebp
80104579:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010457c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104583:	8b 45 0c             	mov    0xc(%ebp),%eax
80104586:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010458c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010458f:	8b 10                	mov    (%eax),%edx
80104591:	8b 45 08             	mov    0x8(%ebp),%eax
80104594:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80104596:	e8 99 cb ff ff       	call   80101134 <filealloc>
8010459b:	89 c2                	mov    %eax,%edx
8010459d:	8b 45 08             	mov    0x8(%ebp),%eax
801045a0:	89 10                	mov    %edx,(%eax)
801045a2:	8b 45 08             	mov    0x8(%ebp),%eax
801045a5:	8b 00                	mov    (%eax),%eax
801045a7:	85 c0                	test   %eax,%eax
801045a9:	0f 84 cb 00 00 00    	je     8010467a <pipealloc+0x104>
801045af:	e8 80 cb ff ff       	call   80101134 <filealloc>
801045b4:	89 c2                	mov    %eax,%edx
801045b6:	8b 45 0c             	mov    0xc(%ebp),%eax
801045b9:	89 10                	mov    %edx,(%eax)
801045bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801045be:	8b 00                	mov    (%eax),%eax
801045c0:	85 c0                	test   %eax,%eax
801045c2:	0f 84 b2 00 00 00    	je     8010467a <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801045c8:	e8 ce eb ff ff       	call   8010319b <kalloc>
801045cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801045d4:	0f 84 9f 00 00 00    	je     80104679 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801045da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045dd:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801045e4:	00 00 00 
  p->writeopen = 1;
801045e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045ea:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801045f1:	00 00 00 
  p->nwrite = 0;
801045f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f7:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801045fe:	00 00 00 
  p->nread = 0;
80104601:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104604:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
8010460b:	00 00 00 
  initlock(&p->lock, "pipe");
8010460e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104611:	83 ec 08             	sub    $0x8,%esp
80104614:	68 00 a4 10 80       	push   $0x8010a400
80104619:	50                   	push   %eax
8010461a:	e8 43 22 00 00       	call   80106862 <initlock>
8010461f:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104622:	8b 45 08             	mov    0x8(%ebp),%eax
80104625:	8b 00                	mov    (%eax),%eax
80104627:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010462d:	8b 45 08             	mov    0x8(%ebp),%eax
80104630:	8b 00                	mov    (%eax),%eax
80104632:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104636:	8b 45 08             	mov    0x8(%ebp),%eax
80104639:	8b 00                	mov    (%eax),%eax
8010463b:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010463f:	8b 45 08             	mov    0x8(%ebp),%eax
80104642:	8b 00                	mov    (%eax),%eax
80104644:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104647:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010464a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010464d:	8b 00                	mov    (%eax),%eax
8010464f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104655:	8b 45 0c             	mov    0xc(%ebp),%eax
80104658:	8b 00                	mov    (%eax),%eax
8010465a:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010465e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104661:	8b 00                	mov    (%eax),%eax
80104663:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104667:	8b 45 0c             	mov    0xc(%ebp),%eax
8010466a:	8b 00                	mov    (%eax),%eax
8010466c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010466f:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104672:	b8 00 00 00 00       	mov    $0x0,%eax
80104677:	eb 4e                	jmp    801046c7 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104679:	90                   	nop
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;

 bad:
  if(p)
8010467a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010467e:	74 0e                	je     8010468e <pipealloc+0x118>
    kfree((char*)p);
80104680:	83 ec 0c             	sub    $0xc,%esp
80104683:	ff 75 f4             	pushl  -0xc(%ebp)
80104686:	e8 73 ea ff ff       	call   801030fe <kfree>
8010468b:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010468e:	8b 45 08             	mov    0x8(%ebp),%eax
80104691:	8b 00                	mov    (%eax),%eax
80104693:	85 c0                	test   %eax,%eax
80104695:	74 11                	je     801046a8 <pipealloc+0x132>
    fileclose(*f0);
80104697:	8b 45 08             	mov    0x8(%ebp),%eax
8010469a:	8b 00                	mov    (%eax),%eax
8010469c:	83 ec 0c             	sub    $0xc,%esp
8010469f:	50                   	push   %eax
801046a0:	e8 4d cb ff ff       	call   801011f2 <fileclose>
801046a5:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801046a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801046ab:	8b 00                	mov    (%eax),%eax
801046ad:	85 c0                	test   %eax,%eax
801046af:	74 11                	je     801046c2 <pipealloc+0x14c>
    fileclose(*f1);
801046b1:	8b 45 0c             	mov    0xc(%ebp),%eax
801046b4:	8b 00                	mov    (%eax),%eax
801046b6:	83 ec 0c             	sub    $0xc,%esp
801046b9:	50                   	push   %eax
801046ba:	e8 33 cb ff ff       	call   801011f2 <fileclose>
801046bf:	83 c4 10             	add    $0x10,%esp
  return -1;
801046c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801046c7:	c9                   	leave  
801046c8:	c3                   	ret    

801046c9 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801046c9:	55                   	push   %ebp
801046ca:	89 e5                	mov    %esp,%ebp
801046cc:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801046cf:	8b 45 08             	mov    0x8(%ebp),%eax
801046d2:	83 ec 0c             	sub    $0xc,%esp
801046d5:	50                   	push   %eax
801046d6:	e8 a9 21 00 00       	call   80106884 <acquire>
801046db:	83 c4 10             	add    $0x10,%esp
  if(writable){
801046de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801046e2:	74 23                	je     80104707 <pipeclose+0x3e>
    p->writeopen = 0;
801046e4:	8b 45 08             	mov    0x8(%ebp),%eax
801046e7:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801046ee:	00 00 00 
    wakeup(&p->nread);
801046f1:	8b 45 08             	mov    0x8(%ebp),%eax
801046f4:	05 34 02 00 00       	add    $0x234,%eax
801046f9:	83 ec 0c             	sub    $0xc,%esp
801046fc:	50                   	push   %eax
801046fd:	e8 d4 15 00 00       	call   80105cd6 <wakeup>
80104702:	83 c4 10             	add    $0x10,%esp
80104705:	eb 21                	jmp    80104728 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104707:	8b 45 08             	mov    0x8(%ebp),%eax
8010470a:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104711:	00 00 00 
    wakeup(&p->nwrite);
80104714:	8b 45 08             	mov    0x8(%ebp),%eax
80104717:	05 38 02 00 00       	add    $0x238,%eax
8010471c:	83 ec 0c             	sub    $0xc,%esp
8010471f:	50                   	push   %eax
80104720:	e8 b1 15 00 00       	call   80105cd6 <wakeup>
80104725:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104728:	8b 45 08             	mov    0x8(%ebp),%eax
8010472b:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104731:	85 c0                	test   %eax,%eax
80104733:	75 2c                	jne    80104761 <pipeclose+0x98>
80104735:	8b 45 08             	mov    0x8(%ebp),%eax
80104738:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010473e:	85 c0                	test   %eax,%eax
80104740:	75 1f                	jne    80104761 <pipeclose+0x98>
    release(&p->lock);
80104742:	8b 45 08             	mov    0x8(%ebp),%eax
80104745:	83 ec 0c             	sub    $0xc,%esp
80104748:	50                   	push   %eax
80104749:	e8 9d 21 00 00       	call   801068eb <release>
8010474e:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104751:	83 ec 0c             	sub    $0xc,%esp
80104754:	ff 75 08             	pushl  0x8(%ebp)
80104757:	e8 a2 e9 ff ff       	call   801030fe <kfree>
8010475c:	83 c4 10             	add    $0x10,%esp
8010475f:	eb 0f                	jmp    80104770 <pipeclose+0xa7>
  } else
    release(&p->lock);
80104761:	8b 45 08             	mov    0x8(%ebp),%eax
80104764:	83 ec 0c             	sub    $0xc,%esp
80104767:	50                   	push   %eax
80104768:	e8 7e 21 00 00       	call   801068eb <release>
8010476d:	83 c4 10             	add    $0x10,%esp
}
80104770:	90                   	nop
80104771:	c9                   	leave  
80104772:	c3                   	ret    

80104773 <pipewrite>:

int
pipewrite(struct pipe *p, char *addr, int n)
{
80104773:	55                   	push   %ebp
80104774:	89 e5                	mov    %esp,%ebp
80104776:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104779:	8b 45 08             	mov    0x8(%ebp),%eax
8010477c:	83 ec 0c             	sub    $0xc,%esp
8010477f:	50                   	push   %eax
80104780:	e8 ff 20 00 00       	call   80106884 <acquire>
80104785:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104788:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010478f:	e9 ad 00 00 00       	jmp    80104841 <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80104794:	8b 45 08             	mov    0x8(%ebp),%eax
80104797:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010479d:	85 c0                	test   %eax,%eax
8010479f:	74 0d                	je     801047ae <pipewrite+0x3b>
801047a1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047a7:	8b 40 24             	mov    0x24(%eax),%eax
801047aa:	85 c0                	test   %eax,%eax
801047ac:	74 19                	je     801047c7 <pipewrite+0x54>
        release(&p->lock);
801047ae:	8b 45 08             	mov    0x8(%ebp),%eax
801047b1:	83 ec 0c             	sub    $0xc,%esp
801047b4:	50                   	push   %eax
801047b5:	e8 31 21 00 00       	call   801068eb <release>
801047ba:	83 c4 10             	add    $0x10,%esp
        return -1;
801047bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047c2:	e9 a8 00 00 00       	jmp    8010486f <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801047c7:	8b 45 08             	mov    0x8(%ebp),%eax
801047ca:	05 34 02 00 00       	add    $0x234,%eax
801047cf:	83 ec 0c             	sub    $0xc,%esp
801047d2:	50                   	push   %eax
801047d3:	e8 fe 14 00 00       	call   80105cd6 <wakeup>
801047d8:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801047db:	8b 45 08             	mov    0x8(%ebp),%eax
801047de:	8b 55 08             	mov    0x8(%ebp),%edx
801047e1:	81 c2 38 02 00 00    	add    $0x238,%edx
801047e7:	83 ec 08             	sub    $0x8,%esp
801047ea:	50                   	push   %eax
801047eb:	52                   	push   %edx
801047ec:	e8 1e 13 00 00       	call   80105b0f <sleep>
801047f1:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801047f4:	8b 45 08             	mov    0x8(%ebp),%eax
801047f7:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801047fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104800:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104806:	05 00 02 00 00       	add    $0x200,%eax
8010480b:	39 c2                	cmp    %eax,%edx
8010480d:	74 85                	je     80104794 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010480f:	8b 45 08             	mov    0x8(%ebp),%eax
80104812:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104818:	8d 48 01             	lea    0x1(%eax),%ecx
8010481b:	8b 55 08             	mov    0x8(%ebp),%edx
8010481e:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104824:	25 ff 01 00 00       	and    $0x1ff,%eax
80104829:	89 c1                	mov    %eax,%ecx
8010482b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010482e:	8b 45 0c             	mov    0xc(%ebp),%eax
80104831:	01 d0                	add    %edx,%eax
80104833:	0f b6 10             	movzbl (%eax),%edx
80104836:	8b 45 08             	mov    0x8(%ebp),%eax
80104839:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
8010483d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104841:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104844:	3b 45 10             	cmp    0x10(%ebp),%eax
80104847:	7c ab                	jl     801047f4 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104849:	8b 45 08             	mov    0x8(%ebp),%eax
8010484c:	05 34 02 00 00       	add    $0x234,%eax
80104851:	83 ec 0c             	sub    $0xc,%esp
80104854:	50                   	push   %eax
80104855:	e8 7c 14 00 00       	call   80105cd6 <wakeup>
8010485a:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010485d:	8b 45 08             	mov    0x8(%ebp),%eax
80104860:	83 ec 0c             	sub    $0xc,%esp
80104863:	50                   	push   %eax
80104864:	e8 82 20 00 00       	call   801068eb <release>
80104869:	83 c4 10             	add    $0x10,%esp
  return n;
8010486c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010486f:	c9                   	leave  
80104870:	c3                   	ret    

80104871 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104871:	55                   	push   %ebp
80104872:	89 e5                	mov    %esp,%ebp
80104874:	53                   	push   %ebx
80104875:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104878:	8b 45 08             	mov    0x8(%ebp),%eax
8010487b:	83 ec 0c             	sub    $0xc,%esp
8010487e:	50                   	push   %eax
8010487f:	e8 00 20 00 00       	call   80106884 <acquire>
80104884:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104887:	eb 3f                	jmp    801048c8 <piperead+0x57>
    if(proc->killed){
80104889:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488f:	8b 40 24             	mov    0x24(%eax),%eax
80104892:	85 c0                	test   %eax,%eax
80104894:	74 19                	je     801048af <piperead+0x3e>
      release(&p->lock);
80104896:	8b 45 08             	mov    0x8(%ebp),%eax
80104899:	83 ec 0c             	sub    $0xc,%esp
8010489c:	50                   	push   %eax
8010489d:	e8 49 20 00 00       	call   801068eb <release>
801048a2:	83 c4 10             	add    $0x10,%esp
      return -1;
801048a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801048aa:	e9 bf 00 00 00       	jmp    8010496e <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801048af:	8b 45 08             	mov    0x8(%ebp),%eax
801048b2:	8b 55 08             	mov    0x8(%ebp),%edx
801048b5:	81 c2 34 02 00 00    	add    $0x234,%edx
801048bb:	83 ec 08             	sub    $0x8,%esp
801048be:	50                   	push   %eax
801048bf:	52                   	push   %edx
801048c0:	e8 4a 12 00 00       	call   80105b0f <sleep>
801048c5:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801048c8:	8b 45 08             	mov    0x8(%ebp),%eax
801048cb:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801048d1:	8b 45 08             	mov    0x8(%ebp),%eax
801048d4:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801048da:	39 c2                	cmp    %eax,%edx
801048dc:	75 0d                	jne    801048eb <piperead+0x7a>
801048de:	8b 45 08             	mov    0x8(%ebp),%eax
801048e1:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801048e7:	85 c0                	test   %eax,%eax
801048e9:	75 9e                	jne    80104889 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801048eb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801048f2:	eb 49                	jmp    8010493d <piperead+0xcc>
    if(p->nread == p->nwrite)
801048f4:	8b 45 08             	mov    0x8(%ebp),%eax
801048f7:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801048fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104900:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104906:	39 c2                	cmp    %eax,%edx
80104908:	74 3d                	je     80104947 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010490a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010490d:	8b 45 0c             	mov    0xc(%ebp),%eax
80104910:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104913:	8b 45 08             	mov    0x8(%ebp),%eax
80104916:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010491c:	8d 48 01             	lea    0x1(%eax),%ecx
8010491f:	8b 55 08             	mov    0x8(%ebp),%edx
80104922:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104928:	25 ff 01 00 00       	and    $0x1ff,%eax
8010492d:	89 c2                	mov    %eax,%edx
8010492f:	8b 45 08             	mov    0x8(%ebp),%eax
80104932:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104937:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104939:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010493d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104940:	3b 45 10             	cmp    0x10(%ebp),%eax
80104943:	7c af                	jl     801048f4 <piperead+0x83>
80104945:	eb 01                	jmp    80104948 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104947:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104948:	8b 45 08             	mov    0x8(%ebp),%eax
8010494b:	05 38 02 00 00       	add    $0x238,%eax
80104950:	83 ec 0c             	sub    $0xc,%esp
80104953:	50                   	push   %eax
80104954:	e8 7d 13 00 00       	call   80105cd6 <wakeup>
80104959:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
8010495c:	8b 45 08             	mov    0x8(%ebp),%eax
8010495f:	83 ec 0c             	sub    $0xc,%esp
80104962:	50                   	push   %eax
80104963:	e8 83 1f 00 00       	call   801068eb <release>
80104968:	83 c4 10             	add    $0x10,%esp
  return i;
8010496b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010496e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104971:	c9                   	leave  
80104972:	c3                   	ret    

80104973 <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
80104973:	55                   	push   %ebp
80104974:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
80104976:	f4                   	hlt    
}
80104977:	90                   	nop
80104978:	5d                   	pop    %ebp
80104979:	c3                   	ret    

8010497a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010497a:	55                   	push   %ebp
8010497b:	89 e5                	mov    %esp,%ebp
8010497d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104980:	9c                   	pushf  
80104981:	58                   	pop    %eax
80104982:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104985:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104988:	c9                   	leave  
80104989:	c3                   	ret    

8010498a <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
8010498a:	55                   	push   %ebp
8010498b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010498d:	fb                   	sti    
}
8010498e:	90                   	nop
8010498f:	5d                   	pop    %ebp
80104990:	c3                   	ret    

80104991 <plistinsert>:
static void wakeup1(void *chan);

#ifdef CS333_P3P4
void
plistinsert(struct proc* p, struct proc** list)
{
80104991:	55                   	push   %ebp
80104992:	89 e5                	mov    %esp,%ebp
80104994:	83 ec 18             	sub    $0x18,%esp
  if(!p || !list)
80104997:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010499b:	74 06                	je     801049a3 <plistinsert+0x12>
8010499d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801049a1:	75 0d                	jne    801049b0 <plistinsert+0x1f>
    panic("Bad insert");
801049a3:	83 ec 0c             	sub    $0xc,%esp
801049a6:	68 08 a4 10 80       	push   $0x8010a408
801049ab:	e8 b6 bb ff ff       	call   80100566 <panic>

  struct proc* curr = *list;
801049b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801049b3:	8b 00                	mov    (%eax),%eax
801049b5:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // Special case: the list is empty)
  if(!curr)
801049b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801049bc:	75 24                	jne    801049e2 <plistinsert+0x51>
  {
    p->next = *list;
801049be:	8b 45 0c             	mov    0xc(%ebp),%eax
801049c1:	8b 10                	mov    (%eax),%edx
801049c3:	8b 45 08             	mov    0x8(%ebp),%eax
801049c6:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    *list = p;
801049cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049cf:	8b 55 08             	mov    0x8(%ebp),%edx
801049d2:	89 10                	mov    %edx,(%eax)
    return;
801049d4:	eb 32                	jmp    80104a08 <plistinsert+0x77>
  }

  while(curr->next)
    curr = curr->next;
801049d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801049df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p->next = *list;
    *list = p;
    return;
  }

  while(curr->next)
801049e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e5:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801049eb:	85 c0                	test   %eax,%eax
801049ed:	75 e7                	jne    801049d6 <plistinsert+0x45>
    curr = curr->next;

  curr->next = p;
801049ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f2:	8b 55 08             	mov    0x8(%ebp),%edx
801049f5:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
  p->next = 0x0;
801049fb:	8b 45 08             	mov    0x8(%ebp),%eax
801049fe:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104a05:	00 00 00 
}
80104a08:	c9                   	leave  
80104a09:	c3                   	ret    

80104a0a <plistremove>:

void
plistremove(struct proc* p, struct proc** list)
{
80104a0a:	55                   	push   %ebp
80104a0b:	89 e5                	mov    %esp,%ebp
80104a0d:	83 ec 18             	sub    $0x18,%esp
  // If p is not in the list, we will panic
  if(!p || !list)
80104a10:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a14:	74 06                	je     80104a1c <plistremove+0x12>
80104a16:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104a1a:	75 0d                	jne    80104a29 <plistremove+0x1f>
    panic("Bad remove!");
80104a1c:	83 ec 0c             	sub    $0xc,%esp
80104a1f:	68 13 a4 10 80       	push   $0x8010a413
80104a24:	e8 3d bb ff ff       	call   80100566 <panic>

  assertinlist(p, *list);
80104a29:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a2c:	8b 00                	mov    (%eax),%eax
80104a2e:	83 ec 08             	sub    $0x8,%esp
80104a31:	50                   	push   %eax
80104a32:	ff 75 08             	pushl  0x8(%ebp)
80104a35:	e8 63 00 00 00       	call   80104a9d <assertinlist>
80104a3a:	83 c4 10             	add    $0x10,%esp

  struct proc* prev;
  struct proc* curr;

  prev = 0x0;
80104a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  curr = *list;
80104a44:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a47:	8b 00                	mov    (%eax),%eax
80104a49:	89 45 f0             	mov    %eax,-0x10(%ebp)

  while(curr)
80104a4c:	eb 46                	jmp    80104a94 <plistremove+0x8a>
  {
    if(curr == p)
80104a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a51:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a54:	75 2c                	jne    80104a82 <plistremove+0x78>
    {
      if(prev == 0x0)
80104a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104a5a:	75 12                	jne    80104a6e <plistremove+0x64>
        *list = (*list)->next;
80104a5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a5f:	8b 00                	mov    (%eax),%eax
80104a61:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80104a67:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a6a:	89 10                	mov    %edx,(%eax)
      else
        prev->next = curr->next;

      break;
80104a6c:	eb 2c                	jmp    80104a9a <plistremove+0x90>
    if(curr == p)
    {
      if(prev == 0x0)
        *list = (*list)->next;
      else
        prev->next = curr->next;
80104a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a71:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80104a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a7a:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)

      break;
80104a80:	eb 18                	jmp    80104a9a <plistremove+0x90>
    }

    else
    {
      prev = curr;
80104a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a85:	89 45 f4             	mov    %eax,-0xc(%ebp)
      curr = curr->next;
80104a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a8b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct proc* curr;

  prev = 0x0;
  curr = *list;

  while(curr)
80104a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a98:	75 b4                	jne    80104a4e <plistremove+0x44>
    {
      prev = curr;
      curr = curr->next;
    }
  }
}
80104a9a:	90                   	nop
80104a9b:	c9                   	leave  
80104a9c:	c3                   	ret    

80104a9d <assertinlist>:

void
assertinlist(struct proc* proc, struct proc* list)
{
80104a9d:	55                   	push   %ebp
80104a9e:	89 e5                	mov    %esp,%ebp
80104aa0:	83 ec 18             	sub    $0x18,%esp
  struct proc* curr = list;
80104aa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aa6:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while(curr)
80104aa9:	eb 14                	jmp    80104abf <assertinlist+0x22>
  {
    if(curr == proc)
80104aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aae:	3b 45 08             	cmp    0x8(%ebp),%eax
80104ab1:	74 1f                	je     80104ad2 <assertinlist+0x35>
      return;
    else
      curr = curr->next;
80104ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80104abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
void
assertinlist(struct proc* proc, struct proc* list)
{
  struct proc* curr = list;

  while(curr)
80104abf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104ac3:	75 e6                	jne    80104aab <assertinlist+0xe>
      return;
    else
      curr = curr->next;
  }

  panic("Proc not in list!");
80104ac5:	83 ec 0c             	sub    $0xc,%esp
80104ac8:	68 1f a4 10 80       	push   $0x8010a41f
80104acd:	e8 94 ba ff ff       	call   80100566 <panic>
  struct proc* curr = list;

  while(curr)
  {
    if(curr == proc)
      return;
80104ad2:	90                   	nop
    else
      curr = curr->next;
  }

  panic("Proc not in list!");
}
80104ad3:	c9                   	leave  
80104ad4:	c3                   	ret    

80104ad5 <pinit>:

#endif

void
pinit(void)
{
80104ad5:	55                   	push   %ebp
80104ad6:	89 e5                	mov    %esp,%ebp
80104ad8:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
80104adb:	83 ec 08             	sub    $0x8,%esp
80104ade:	68 31 a4 10 80       	push   $0x8010a431
80104ae3:	68 20 45 11 80       	push   $0x80114520
80104ae8:	e8 75 1d 00 00       	call   80106862 <initlock>
80104aed:	83 c4 10             	add    $0x10,%esp
}
80104af0:	90                   	nop
80104af1:	c9                   	leave  
80104af2:	c3                   	ret    

80104af3 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104af3:	55                   	push   %ebp
80104af4:	89 e5                	mov    %esp,%ebp
80104af6:	83 ec 18             	sub    $0x18,%esp
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;
  #else
  acquire(&ptable.lock);
80104af9:	83 ec 0c             	sub    $0xc,%esp
80104afc:	68 20 45 11 80       	push   $0x80114520
80104b01:	e8 7e 1d 00 00       	call   80106884 <acquire>
80104b06:	83 c4 10             	add    $0x10,%esp
  //If there is an available process
  if(ptable.pLists.free)
80104b09:	a1 68 6c 11 80       	mov    0x80116c68,%eax
80104b0e:	85 c0                	test   %eax,%eax
80104b10:	74 78                	je     80104b8a <allocproc+0x97>
  {
    p = ptable.pLists.free;
80104b12:	a1 68 6c 11 80       	mov    0x80116c68,%eax
80104b17:	89 45 f4             	mov    %eax,-0xc(%ebp)
    plistremove(p, &ptable.pLists.free);
80104b1a:	83 ec 08             	sub    $0x8,%esp
80104b1d:	68 68 6c 11 80       	push   $0x80116c68
80104b22:	ff 75 f4             	pushl  -0xc(%ebp)
80104b25:	e8 e0 fe ff ff       	call   80104a0a <plistremove>
80104b2a:	83 c4 10             	add    $0x10,%esp

    goto found;
80104b2d:	90                   	nop
    return 0;
  }
  #endif

found:
  p->state = EMBRYO;
80104b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b31:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104b38:	a1 04 d0 10 80       	mov    0x8010d004,%eax
80104b3d:	8d 50 01             	lea    0x1(%eax),%edx
80104b40:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104b46:	89 c2                	mov    %eax,%edx
80104b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4b:	89 50 10             	mov    %edx,0x10(%eax)

  // Add the proc to the embryo list
  #ifdef CS333_P3P4
  plistinsert(p, &ptable.pLists.embryo);
80104b4e:	83 ec 08             	sub    $0x8,%esp
80104b51:	68 78 6c 11 80       	push   $0x80116c78
80104b56:	ff 75 f4             	pushl  -0xc(%ebp)
80104b59:	e8 33 fe ff ff       	call   80104991 <plistinsert>
80104b5e:	83 c4 10             	add    $0x10,%esp
  #endif

  release(&ptable.lock);
80104b61:	83 ec 0c             	sub    $0xc,%esp
80104b64:	68 20 45 11 80       	push   $0x80114520
80104b69:	e8 7d 1d 00 00       	call   801068eb <release>
80104b6e:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104b71:	e8 25 e6 ff ff       	call   8010319b <kalloc>
80104b76:	89 c2                	mov    %eax,%edx
80104b78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b7b:	89 50 08             	mov    %edx,0x8(%eax)
80104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b81:	8b 40 08             	mov    0x8(%eax),%eax
80104b84:	85 c0                	test   %eax,%eax
80104b86:	75 76                	jne    80104bfe <allocproc+0x10b>
80104b88:	eb 1a                	jmp    80104ba4 <allocproc+0xb1>
  }

  else
  {
    // No procs can be allocated, so release.
    release(&ptable.lock);
80104b8a:	83 ec 0c             	sub    $0xc,%esp
80104b8d:	68 20 45 11 80       	push   $0x80114520
80104b92:	e8 54 1d 00 00       	call   801068eb <release>
80104b97:	83 c4 10             	add    $0x10,%esp
    return 0;
80104b9a:	b8 00 00 00 00       	mov    $0x0,%eax
80104b9f:	e9 f7 00 00 00       	jmp    80104c9b <allocproc+0x1a8>
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104ba4:	83 ec 0c             	sub    $0xc,%esp
80104ba7:	68 20 45 11 80       	push   $0x80114520
80104bac:	e8 d3 1c 00 00       	call   80106884 <acquire>
80104bb1:	83 c4 10             	add    $0x10,%esp

    // Remove p from embryo list and add to free list again
    plistremove(p, &ptable.pLists.embryo);
80104bb4:	83 ec 08             	sub    $0x8,%esp
80104bb7:	68 78 6c 11 80       	push   $0x80116c78
80104bbc:	ff 75 f4             	pushl  -0xc(%ebp)
80104bbf:	e8 46 fe ff ff       	call   80104a0a <plistremove>
80104bc4:	83 c4 10             	add    $0x10,%esp
    plistinsert(p, &ptable.pLists.free);
80104bc7:	83 ec 08             	sub    $0x8,%esp
80104bca:	68 68 6c 11 80       	push   $0x80116c68
80104bcf:	ff 75 f4             	pushl  -0xc(%ebp)
80104bd2:	e8 ba fd ff ff       	call   80104991 <plistinsert>
80104bd7:	83 c4 10             	add    $0x10,%esp

    release(&ptable.lock);
80104bda:	83 ec 0c             	sub    $0xc,%esp
80104bdd:	68 20 45 11 80       	push   $0x80114520
80104be2:	e8 04 1d 00 00       	call   801068eb <release>
80104be7:	83 c4 10             	add    $0x10,%esp
    #endif

    p->state = UNUSED;
80104bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
80104bf4:	b8 00 00 00 00       	mov    $0x0,%eax
80104bf9:	e9 9d 00 00 00       	jmp    80104c9b <allocproc+0x1a8>
  }
  sp = p->kstack + KSTACKSIZE;
80104bfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c01:	8b 40 08             	mov    0x8(%eax),%eax
80104c04:	05 00 10 00 00       	add    $0x1000,%eax
80104c09:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104c0c:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c13:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c16:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104c19:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104c1d:	ba d7 81 10 80       	mov    $0x801081d7,%edx
80104c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c25:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104c27:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c31:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c37:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c3a:	83 ec 04             	sub    $0x4,%esp
80104c3d:	6a 14                	push   $0x14
80104c3f:	6a 00                	push   $0x0
80104c41:	50                   	push   %eax
80104c42:	e8 a0 1e 00 00       	call   80106ae7 <memset>
80104c47:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80104c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c4d:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c50:	ba c9 5a 10 80       	mov    $0x80105ac9,%edx
80104c55:	89 50 10             	mov    %edx,0x10(%eax)

  #ifdef CS333_P1
  // Initialize the process's start_ticks to be the global tick count.
  // This gives us a timestamp of WHEN the process starts. In addition,
  // when the process ends, we can calculate how long the process ran.
  p->start_ticks = ticks;
80104c58:	8b 15 80 74 11 80    	mov    0x80117480,%edx
80104c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c61:	89 50 7c             	mov    %edx,0x7c(%eax)
  #endif

  #ifdef CS333_P2
  p->cpu_ticks_total = 0;
80104c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c67:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104c6e:	00 00 00 
  p->cpu_ticks_in = 0;
80104c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c74:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80104c7b:	00 00 00 
  #endif

  #ifdef CS333_P3P4
  p->priority = 0;
80104c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c81:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
80104c88:	00 00 00 
  p->budget = MAX_BUDGET;
80104c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c8e:	c7 80 98 00 00 00 b8 	movl   $0xbb8,0x98(%eax)
80104c95:	0b 00 00 
  #endif

  return p;
80104c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104c9b:	c9                   	leave  
80104c9c:	c3                   	ret    

80104c9d <userinit>:

// Set up first user process.
void
userinit(void)
{
80104c9d:	55                   	push   %ebp
80104c9e:	89 e5                	mov    %esp,%ebp
80104ca0:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
 
  #ifdef CS333_P3P4
  initproclists();
80104ca3:	e8 94 01 00 00       	call   80104e3c <initproclists>
  #endif
 
  p = allocproc();
80104ca8:	e8 46 fe ff ff       	call   80104af3 <allocproc>
80104cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb3:	a3 88 d6 10 80       	mov    %eax,0x8010d688
  if((p->pgdir = setupkvm()) == 0)
80104cb8:	e8 dc 4b 00 00       	call   80109899 <setupkvm>
80104cbd:	89 c2                	mov    %eax,%edx
80104cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc2:	89 50 04             	mov    %edx,0x4(%eax)
80104cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc8:	8b 40 04             	mov    0x4(%eax),%eax
80104ccb:	85 c0                	test   %eax,%eax
80104ccd:	75 0d                	jne    80104cdc <userinit+0x3f>
    panic("userinit: out of memory?");
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	68 38 a4 10 80       	push   $0x8010a438
80104cd7:	e8 8a b8 ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104cdc:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce4:	8b 40 04             	mov    0x4(%eax),%eax
80104ce7:	83 ec 04             	sub    $0x4,%esp
80104cea:	52                   	push   %edx
80104ceb:	68 20 d5 10 80       	push   $0x8010d520
80104cf0:	50                   	push   %eax
80104cf1:	e8 fd 4d 00 00       	call   80109af3 <inituvm>
80104cf6:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cfc:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d05:	8b 40 18             	mov    0x18(%eax),%eax
80104d08:	83 ec 04             	sub    $0x4,%esp
80104d0b:	6a 4c                	push   $0x4c
80104d0d:	6a 00                	push   $0x0
80104d0f:	50                   	push   %eax
80104d10:	e8 d2 1d 00 00       	call   80106ae7 <memset>
80104d15:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104d18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d1b:	8b 40 18             	mov    0x18(%eax),%eax
80104d1e:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d27:	8b 40 18             	mov    0x18(%eax),%eax
80104d2a:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d33:	8b 40 18             	mov    0x18(%eax),%eax
80104d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d39:	8b 52 18             	mov    0x18(%edx),%edx
80104d3c:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104d40:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d47:	8b 40 18             	mov    0x18(%eax),%eax
80104d4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d4d:	8b 52 18             	mov    0x18(%edx),%edx
80104d50:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104d54:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104d58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d5b:	8b 40 18             	mov    0x18(%eax),%eax
80104d5e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104d65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d68:	8b 40 18             	mov    0x18(%eax),%eax
80104d6b:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d75:	8b 40 18             	mov    0x18(%eax),%eax
80104d78:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d82:	83 c0 6c             	add    $0x6c,%eax
80104d85:	83 ec 04             	sub    $0x4,%esp
80104d88:	6a 10                	push   $0x10
80104d8a:	68 51 a4 10 80       	push   $0x8010a451
80104d8f:	50                   	push   %eax
80104d90:	e8 55 1f 00 00       	call   80106cea <safestrcpy>
80104d95:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	68 5a a4 10 80       	push   $0x8010a45a
80104da0:	e8 b8 d9 ff ff       	call   8010275d <namei>
80104da5:	83 c4 10             	add    $0x10,%esp
80104da8:	89 c2                	mov    %eax,%edx
80104daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dad:	89 50 68             	mov    %edx,0x68(%eax)

  // Note that p is the first user process, so we will
  // give them the default uid and gid
  #ifdef CS333_P2
  p->uid = DEFAULT_UID;
80104db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db3:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104dba:	00 00 00 
  p->gid = DEFAULT_GID;
80104dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc0:	c7 80 84 00 00 00 01 	movl   $0x1,0x84(%eax)
80104dc7:	00 00 00 

  #ifdef CS333_P3P4
  // Remove p from the embryo list and add to
  // the ready list

  acquire(&ptable.lock);
80104dca:	83 ec 0c             	sub    $0xc,%esp
80104dcd:	68 20 45 11 80       	push   $0x80114520
80104dd2:	e8 ad 1a 00 00       	call   80106884 <acquire>
80104dd7:	83 c4 10             	add    $0x10,%esp

  // Remove p from the embryo list and add to ready list.
  plistremove(p, &ptable.pLists.embryo);
80104dda:	83 ec 08             	sub    $0x8,%esp
80104ddd:	68 78 6c 11 80       	push   $0x80116c78
80104de2:	ff 75 f4             	pushl  -0xc(%ebp)
80104de5:	e8 20 fc ff ff       	call   80104a0a <plistremove>
80104dea:	83 c4 10             	add    $0x10,%esp
  p->state = RUNNABLE;
80104ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  plistinsert(p, &(ptable.pLists.ready[p->priority]));
80104df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dfa:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80104e00:	05 cc 09 00 00       	add    $0x9cc,%eax
80104e05:	c1 e0 02             	shl    $0x2,%eax
80104e08:	05 20 45 11 80       	add    $0x80114520,%eax
80104e0d:	83 c0 04             	add    $0x4,%eax
80104e10:	83 ec 08             	sub    $0x8,%esp
80104e13:	50                   	push   %eax
80104e14:	ff 75 f4             	pushl  -0xc(%ebp)
80104e17:	e8 75 fb ff ff       	call   80104991 <plistinsert>
80104e1c:	83 c4 10             	add    $0x10,%esp

  // Initialize the ticks to promote at.
  ptable.PromoteAtTicks = TICKS_TO_PROMOTE;
80104e1f:	c7 05 7c 6c 11 80 10 	movl   $0x2710,0x80116c7c
80104e26:	27 00 00 

  release(&ptable.lock);
80104e29:	83 ec 0c             	sub    $0xc,%esp
80104e2c:	68 20 45 11 80       	push   $0x80114520
80104e31:	e8 b5 1a 00 00       	call   801068eb <release>
80104e36:	83 c4 10             	add    $0x10,%esp
  #else
  acquire(&ptable.lock);
  p->state = RUNNABLE;
  release(&ptable.lock);
  #endif
}
80104e39:	90                   	nop
80104e3a:	c9                   	leave  
80104e3b:	c3                   	ret    

80104e3c <initproclists>:

#ifdef CS333_P3P4
void
initproclists(void)
{
80104e3c:	55                   	push   %ebp
80104e3d:	89 e5                	mov    %esp,%ebp
80104e3f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104e42:	83 ec 0c             	sub    $0xc,%esp
80104e45:	68 20 45 11 80       	push   $0x80114520
80104e4a:	e8 35 1a 00 00       	call   80106884 <acquire>
80104e4f:	83 c4 10             	add    $0x10,%esp
  // We will set all the lists to empty.

  //ptable.pLists.ready = 0x0;

  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
80104e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104e59:	eb 17                	jmp    80104e72 <initproclists+0x36>
    ptable.pLists.ready[i] = 0x0;
80104e5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5e:	05 cc 09 00 00       	add    $0x9cc,%eax
80104e63:	c7 04 85 24 45 11 80 	movl   $0x0,-0x7feebadc(,%eax,4)
80104e6a:	00 00 00 00 
  // We will set all the lists to empty.

  //ptable.pLists.ready = 0x0;

  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
80104e6e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104e72:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80104e76:	7e e3                	jle    80104e5b <initproclists+0x1f>
    ptable.pLists.ready[i] = 0x0;

  ptable.pLists.free = 0x0;
80104e78:	c7 05 68 6c 11 80 00 	movl   $0x0,0x80116c68
80104e7f:	00 00 00 
  ptable.pLists.sleep = 0x0;
80104e82:	c7 05 6c 6c 11 80 00 	movl   $0x0,0x80116c6c
80104e89:	00 00 00 
  ptable.pLists.zombie = 0x0;
80104e8c:	c7 05 70 6c 11 80 00 	movl   $0x0,0x80116c70
80104e93:	00 00 00 
  ptable.pLists.running = 0x0;
80104e96:	c7 05 74 6c 11 80 00 	movl   $0x0,0x80116c74
80104e9d:	00 00 00 
  ptable.pLists.embryo = 0x0;
80104ea0:	c7 05 78 6c 11 80 00 	movl   $0x0,0x80116c78
80104ea7:	00 00 00 
  /*
    At this point, we don't have any processes anywhere.
    They should all be in the free stage at first. This way,
    when we run allocproc() it will work just fine
  */
  for(i = 0; i < NPROC; ++i)
80104eaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104eb1:	eb 3d                	jmp    80104ef0 <initproclists+0xb4>
  {
    ptable.proc[i].state = UNUSED;
80104eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eb6:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80104ebc:	05 60 45 11 80       	add    $0x80114560,%eax
80104ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    plistinsert(&ptable.proc[i], &ptable.pLists.free);
80104ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104eca:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80104ed0:	83 c0 30             	add    $0x30,%eax
80104ed3:	05 20 45 11 80       	add    $0x80114520,%eax
80104ed8:	83 c0 04             	add    $0x4,%eax
80104edb:	83 ec 08             	sub    $0x8,%esp
80104ede:	68 68 6c 11 80       	push   $0x80116c68
80104ee3:	50                   	push   %eax
80104ee4:	e8 a8 fa ff ff       	call   80104991 <plistinsert>
80104ee9:	83 c4 10             	add    $0x10,%esp
  /*
    At this point, we don't have any processes anywhere.
    They should all be in the free stage at first. This way,
    when we run allocproc() it will work just fine
  */
  for(i = 0; i < NPROC; ++i)
80104eec:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ef0:	83 7d f4 3f          	cmpl   $0x3f,-0xc(%ebp)
80104ef4:	7e bd                	jle    80104eb3 <initproclists+0x77>
    ptable.proc[i].state = UNUSED;
    plistinsert(&ptable.proc[i], &ptable.pLists.free);
  }


  release(&ptable.lock);
80104ef6:	83 ec 0c             	sub    $0xc,%esp
80104ef9:	68 20 45 11 80       	push   $0x80114520
80104efe:	e8 e8 19 00 00       	call   801068eb <release>
80104f03:	83 c4 10             	add    $0x10,%esp
}
80104f06:	90                   	nop
80104f07:	c9                   	leave  
80104f08:	c3                   	ret    

80104f09 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104f09:	55                   	push   %ebp
80104f0a:	89 e5                	mov    %esp,%ebp
80104f0c:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104f0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f15:	8b 00                	mov    (%eax),%eax
80104f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104f1a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104f1e:	7e 31                	jle    80104f51 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104f20:	8b 55 08             	mov    0x8(%ebp),%edx
80104f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f26:	01 c2                	add    %eax,%edx
80104f28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f2e:	8b 40 04             	mov    0x4(%eax),%eax
80104f31:	83 ec 04             	sub    $0x4,%esp
80104f34:	52                   	push   %edx
80104f35:	ff 75 f4             	pushl  -0xc(%ebp)
80104f38:	50                   	push   %eax
80104f39:	e8 02 4d 00 00       	call   80109c40 <allocuvm>
80104f3e:	83 c4 10             	add    $0x10,%esp
80104f41:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f48:	75 3e                	jne    80104f88 <growproc+0x7f>
      return -1;
80104f4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f4f:	eb 59                	jmp    80104faa <growproc+0xa1>
  } else if(n < 0){
80104f51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104f55:	79 31                	jns    80104f88 <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104f57:	8b 55 08             	mov    0x8(%ebp),%edx
80104f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f5d:	01 c2                	add    %eax,%edx
80104f5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f65:	8b 40 04             	mov    0x4(%eax),%eax
80104f68:	83 ec 04             	sub    $0x4,%esp
80104f6b:	52                   	push   %edx
80104f6c:	ff 75 f4             	pushl  -0xc(%ebp)
80104f6f:	50                   	push   %eax
80104f70:	e8 94 4d 00 00       	call   80109d09 <deallocuvm>
80104f75:	83 c4 10             	add    $0x10,%esp
80104f78:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104f7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104f7f:	75 07                	jne    80104f88 <growproc+0x7f>
      return -1;
80104f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f86:	eb 22                	jmp    80104faa <growproc+0xa1>
  }
  proc->sz = sz;
80104f88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f91:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104f93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f99:	83 ec 0c             	sub    $0xc,%esp
80104f9c:	50                   	push   %eax
80104f9d:	e8 de 49 00 00       	call   80109980 <switchuvm>
80104fa2:	83 c4 10             	add    $0x10,%esp
  return 0;
80104fa5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104faa:	c9                   	leave  
80104fab:	c3                   	ret    

80104fac <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104fac:	55                   	push   %ebp
80104fad:	89 e5                	mov    %esp,%ebp
80104faf:	57                   	push   %edi
80104fb0:	56                   	push   %esi
80104fb1:	53                   	push   %ebx
80104fb2:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104fb5:	e8 39 fb ff ff       	call   80104af3 <allocproc>
80104fba:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104fbd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104fc1:	75 0a                	jne    80104fcd <fork+0x21>
    return -1;
80104fc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc8:	e9 13 02 00 00       	jmp    801051e0 <fork+0x234>

  // Copy process state from p. If this fails, remove np from
  // the embryo list if this operation fails.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104fcd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fd3:	8b 10                	mov    (%eax),%edx
80104fd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fdb:	8b 40 04             	mov    0x4(%eax),%eax
80104fde:	83 ec 08             	sub    $0x8,%esp
80104fe1:	52                   	push   %edx
80104fe2:	50                   	push   %eax
80104fe3:	e8 bf 4e 00 00       	call   80109ea7 <copyuvm>
80104fe8:	83 c4 10             	add    $0x10,%esp
80104feb:	89 c2                	mov    %eax,%edx
80104fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ff0:	89 50 04             	mov    %edx,0x4(%eax)
80104ff3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ff6:	8b 40 04             	mov    0x4(%eax),%eax
80104ff9:	85 c0                	test   %eax,%eax
80104ffb:	75 76                	jne    80105073 <fork+0xc7>
    kfree(np->kstack);
80104ffd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105000:	8b 40 08             	mov    0x8(%eax),%eax
80105003:	83 ec 0c             	sub    $0xc,%esp
80105006:	50                   	push   %eax
80105007:	e8 f2 e0 ff ff       	call   801030fe <kfree>
8010500c:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
8010500f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105012:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80105019:	83 ec 0c             	sub    $0xc,%esp
8010501c:	68 20 45 11 80       	push   $0x80114520
80105021:	e8 5e 18 00 00       	call   80106884 <acquire>
80105026:	83 c4 10             	add    $0x10,%esp
    plistremove(np, &ptable.pLists.embryo);
80105029:	83 ec 08             	sub    $0x8,%esp
8010502c:	68 78 6c 11 80       	push   $0x80116c78
80105031:	ff 75 e0             	pushl  -0x20(%ebp)
80105034:	e8 d1 f9 ff ff       	call   80104a0a <plistremove>
80105039:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
8010503c:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010503f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    plistinsert(np, &ptable.pLists.free);
80105046:	83 ec 08             	sub    $0x8,%esp
80105049:	68 68 6c 11 80       	push   $0x80116c68
8010504e:	ff 75 e0             	pushl  -0x20(%ebp)
80105051:	e8 3b f9 ff ff       	call   80104991 <plistinsert>
80105056:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105059:	83 ec 0c             	sub    $0xc,%esp
8010505c:	68 20 45 11 80       	push   $0x80114520
80105061:	e8 85 18 00 00       	call   801068eb <release>
80105066:	83 c4 10             	add    $0x10,%esp
    acquire(&ptable.lock);
    np->state = UNUSED;
    release(&ptable.lock);
    #endif

    return -1;
80105069:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010506e:	e9 6d 01 00 00       	jmp    801051e0 <fork+0x234>
  }
  np->sz = proc->sz;
80105073:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105079:	8b 10                	mov    (%eax),%edx
8010507b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010507e:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80105080:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105087:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010508a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
8010508d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105090:	8b 50 18             	mov    0x18(%eax),%edx
80105093:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105099:	8b 40 18             	mov    0x18(%eax),%eax
8010509c:	89 c3                	mov    %eax,%ebx
8010509e:	b8 13 00 00 00       	mov    $0x13,%eax
801050a3:	89 d7                	mov    %edx,%edi
801050a5:	89 de                	mov    %ebx,%esi
801050a7:	89 c1                	mov    %eax,%ecx
801050a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  #ifdef CS333_P2
  np->uid = proc->uid;
801050ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050b1:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801050b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050ba:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np->gid = proc->gid;
801050c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050c6:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
801050cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050cf:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801050d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050d8:	8b 40 18             	mov    0x18(%eax),%eax
801050db:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801050e2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801050e9:	eb 43                	jmp    8010512e <fork+0x182>
    if(proc->ofile[i])
801050eb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801050f4:	83 c2 08             	add    $0x8,%edx
801050f7:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801050fb:	85 c0                	test   %eax,%eax
801050fd:	74 2b                	je     8010512a <fork+0x17e>
      np->ofile[i] = filedup(proc->ofile[i]);
801050ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105105:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105108:	83 c2 08             	add    $0x8,%edx
8010510b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010510f:	83 ec 0c             	sub    $0xc,%esp
80105112:	50                   	push   %eax
80105113:	e8 89 c0 ff ff       	call   801011a1 <filedup>
80105118:	83 c4 10             	add    $0x10,%esp
8010511b:	89 c1                	mov    %eax,%ecx
8010511d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105120:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80105123:	83 c2 08             	add    $0x8,%edx
80105126:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  #endif

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
8010512a:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010512e:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80105132:	7e b7                	jle    801050eb <fork+0x13f>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80105134:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010513a:	8b 40 68             	mov    0x68(%eax),%eax
8010513d:	83 ec 0c             	sub    $0xc,%esp
80105140:	50                   	push   %eax
80105141:	e8 cf c9 ff ff       	call   80101b15 <idup>
80105146:	83 c4 10             	add    $0x10,%esp
80105149:	89 c2                	mov    %eax,%edx
8010514b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010514e:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80105151:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105157:	8d 50 6c             	lea    0x6c(%eax),%edx
8010515a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010515d:	83 c0 6c             	add    $0x6c,%eax
80105160:	83 ec 04             	sub    $0x4,%esp
80105163:	6a 10                	push   $0x10
80105165:	52                   	push   %edx
80105166:	50                   	push   %eax
80105167:	e8 7e 1b 00 00       	call   80106cea <safestrcpy>
8010516c:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
8010516f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105172:	8b 40 10             	mov    0x10(%eax),%eax
80105175:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  #ifdef CS333_P3P4
  acquire(&ptable.lock);
80105178:	83 ec 0c             	sub    $0xc,%esp
8010517b:	68 20 45 11 80       	push   $0x80114520
80105180:	e8 ff 16 00 00       	call   80106884 <acquire>
80105185:	83 c4 10             	add    $0x10,%esp
  plistremove(np, &ptable.pLists.embryo);
80105188:	83 ec 08             	sub    $0x8,%esp
8010518b:	68 78 6c 11 80       	push   $0x80116c78
80105190:	ff 75 e0             	pushl  -0x20(%ebp)
80105193:	e8 72 f8 ff ff       	call   80104a0a <plistremove>
80105198:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
8010519b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010519e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  plistinsert(np, &(ptable.pLists.ready[np->priority]));
801051a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051a8:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801051ae:	05 cc 09 00 00       	add    $0x9cc,%eax
801051b3:	c1 e0 02             	shl    $0x2,%eax
801051b6:	05 20 45 11 80       	add    $0x80114520,%eax
801051bb:	83 c0 04             	add    $0x4,%eax
801051be:	83 ec 08             	sub    $0x8,%esp
801051c1:	50                   	push   %eax
801051c2:	ff 75 e0             	pushl  -0x20(%ebp)
801051c5:	e8 c7 f7 ff ff       	call   80104991 <plistinsert>
801051ca:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
801051cd:	83 ec 0c             	sub    $0xc,%esp
801051d0:	68 20 45 11 80       	push   $0x80114520
801051d5:	e8 11 17 00 00       	call   801068eb <release>
801051da:	83 c4 10             	add    $0x10,%esp
  acquire(&ptable.lock);
  np->state = RUNNABLE;
  release(&ptable.lock);
  #endif
  
  return pid;
801051dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801051e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801051e3:	5b                   	pop    %ebx
801051e4:	5e                   	pop    %esi
801051e5:	5f                   	pop    %edi
801051e6:	5d                   	pop    %ebp
801051e7:	c3                   	ret    

801051e8 <exit>:
  panic("zombie exit");
}
#else
void
exit(void)
{
801051e8:	55                   	push   %ebp
801051e9:	89 e5                	mov    %esp,%ebp
801051eb:	83 ec 18             	sub    $0x18,%esp
  int fd;

  if(proc == initproc)
801051ee:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801051f5:	a1 88 d6 10 80       	mov    0x8010d688,%eax
801051fa:	39 c2                	cmp    %eax,%edx
801051fc:	75 0d                	jne    8010520b <exit+0x23>
    panic("init exiting");
801051fe:	83 ec 0c             	sub    $0xc,%esp
80105201:	68 5c a4 10 80       	push   $0x8010a45c
80105206:	e8 5b b3 ff ff       	call   80100566 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010520b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105212:	eb 48                	jmp    8010525c <exit+0x74>
    if(proc->ofile[fd]){
80105214:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010521a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010521d:	83 c2 08             	add    $0x8,%edx
80105220:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105224:	85 c0                	test   %eax,%eax
80105226:	74 30                	je     80105258 <exit+0x70>
      fileclose(proc->ofile[fd]);
80105228:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010522e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105231:	83 c2 08             	add    $0x8,%edx
80105234:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	50                   	push   %eax
8010523c:	e8 b1 bf ff ff       	call   801011f2 <fileclose>
80105241:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80105244:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010524a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010524d:	83 c2 08             	add    $0x8,%edx
80105250:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105257:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80105258:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010525c:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105260:	7e b2                	jle    80105214 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80105262:	e8 1b e8 ff ff       	call   80103a82 <begin_op>
  iput(proc->cwd);
80105267:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010526d:	8b 40 68             	mov    0x68(%eax),%eax
80105270:	83 ec 0c             	sub    $0xc,%esp
80105273:	50                   	push   %eax
80105274:	e8 ce ca ff ff       	call   80101d47 <iput>
80105279:	83 c4 10             	add    $0x10,%esp
  end_op();
8010527c:	e8 8d e8 ff ff       	call   80103b0e <end_op>
  proc->cwd = 0;
80105281:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105287:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
8010528e:	83 ec 0c             	sub    $0xc,%esp
80105291:	68 20 45 11 80       	push   $0x80114520
80105296:	e8 e9 15 00 00       	call   80106884 <acquire>
8010529b:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
8010529e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052a4:	8b 40 14             	mov    0x14(%eax),%eax
801052a7:	83 ec 0c             	sub    $0xc,%esp
801052aa:	50                   	push   %eax
801052ab:	e8 44 09 00 00       	call   80105bf4 <wakeup1>
801052b0:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  // This will require traversing every list looking for
  // processes whose parent is proc.
  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
801052b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801052ba:	eb 26                	jmp    801052e2 <exit+0xfa>
    adoptallchildren(proc, ptable.pLists.ready[i]);
801052bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052bf:	05 cc 09 00 00       	add    $0x9cc,%eax
801052c4:	8b 14 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%edx
801052cb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052d1:	83 ec 08             	sub    $0x8,%esp
801052d4:	52                   	push   %edx
801052d5:	50                   	push   %eax
801052d6:	e8 be 00 00 00       	call   80105399 <adoptallchildren>
801052db:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  // This will require traversing every list looking for
  // processes whose parent is proc.
  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
801052de:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801052e2:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801052e6:	7e d4                	jle    801052bc <exit+0xd4>
    adoptallchildren(proc, ptable.pLists.ready[i]);
  adoptallchildren(proc, ptable.pLists.running);
801052e8:	8b 15 74 6c 11 80    	mov    0x80116c74,%edx
801052ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801052f4:	83 ec 08             	sub    $0x8,%esp
801052f7:	52                   	push   %edx
801052f8:	50                   	push   %eax
801052f9:	e8 9b 00 00 00       	call   80105399 <adoptallchildren>
801052fe:	83 c4 10             	add    $0x10,%esp
  adoptallchildren(proc, ptable.pLists.sleep);
80105301:	8b 15 6c 6c 11 80    	mov    0x80116c6c,%edx
80105307:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010530d:	83 ec 08             	sub    $0x8,%esp
80105310:	52                   	push   %edx
80105311:	50                   	push   %eax
80105312:	e8 82 00 00 00       	call   80105399 <adoptallchildren>
80105317:	83 c4 10             	add    $0x10,%esp
  adoptallchildren(proc, ptable.pLists.zombie);
8010531a:	8b 15 70 6c 11 80    	mov    0x80116c70,%edx
80105320:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105326:	83 ec 08             	sub    $0x8,%esp
80105329:	52                   	push   %edx
8010532a:	50                   	push   %eax
8010532b:	e8 69 00 00 00       	call   80105399 <adoptallchildren>
80105330:	83 c4 10             	add    $0x10,%esp
  adoptallchildren(proc, ptable.pLists.embryo);
80105333:	8b 15 78 6c 11 80    	mov    0x80116c78,%edx
80105339:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010533f:	83 ec 08             	sub    $0x8,%esp
80105342:	52                   	push   %edx
80105343:	50                   	push   %eax
80105344:	e8 50 00 00 00       	call   80105399 <adoptallchildren>
80105349:	83 c4 10             	add    $0x10,%esp

  // Jump into the scheduler, never to return.
  plistremove(proc, &ptable.pLists.running);
8010534c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105352:	83 ec 08             	sub    $0x8,%esp
80105355:	68 74 6c 11 80       	push   $0x80116c74
8010535a:	50                   	push   %eax
8010535b:	e8 aa f6 ff ff       	call   80104a0a <plistremove>
80105360:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80105363:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105369:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  plistinsert(proc, &ptable.pLists.zombie);
80105370:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105376:	83 ec 08             	sub    $0x8,%esp
80105379:	68 70 6c 11 80       	push   $0x80116c70
8010537e:	50                   	push   %eax
8010537f:	e8 0d f6 ff ff       	call   80104991 <plistinsert>
80105384:	83 c4 10             	add    $0x10,%esp
  sched();
80105387:	e8 35 05 00 00       	call   801058c1 <sched>
  panic("zombie exit");
8010538c:	83 ec 0c             	sub    $0xc,%esp
8010538f:	68 69 a4 10 80       	push   $0x8010a469
80105394:	e8 cd b1 ff ff       	call   80100566 <panic>

80105399 <adoptallchildren>:
#endif

#ifdef CS333_P3P4
void
adoptallchildren(struct proc* parent, struct proc* list)
{
80105399:	55                   	push   %ebp
8010539a:	89 e5                	mov    %esp,%ebp
8010539c:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  p = list;
8010539f:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
801053a5:	eb 44                	jmp    801053eb <adoptallchildren+0x52>
  {
    if(p->parent == proc)
801053a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053aa:	8b 50 14             	mov    0x14(%eax),%edx
801053ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053b3:	39 c2                	cmp    %eax,%edx
801053b5:	75 28                	jne    801053df <adoptallchildren+0x46>
    {
      p->parent = initproc;
801053b7:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
801053bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c0:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801053c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053c6:	8b 40 0c             	mov    0xc(%eax),%eax
801053c9:	83 f8 05             	cmp    $0x5,%eax
801053cc:	75 11                	jne    801053df <adoptallchildren+0x46>
        wakeup1(initproc);
801053ce:	a1 88 d6 10 80       	mov    0x8010d688,%eax
801053d3:	83 ec 0c             	sub    $0xc,%esp
801053d6:	50                   	push   %eax
801053d7:	e8 18 08 00 00       	call   80105bf4 <wakeup1>
801053dc:	83 c4 10             	add    $0x10,%esp
    }

    p = p->next;
801053df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053e2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801053e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
adoptallchildren(struct proc* parent, struct proc* list)
{
  struct proc* p;

  p = list;
  while(p)
801053eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801053ef:	75 b6                	jne    801053a7 <adoptallchildren+0xe>
        wakeup1(initproc);
    }

    p = p->next;
  }
}
801053f1:	90                   	nop
801053f2:	c9                   	leave  
801053f3:	c3                   	ret    

801053f4 <wait>:
  }
}
#else
int
wait(void)
{
801053f4:	55                   	push   %ebp
801053f5:	89 e5                	mov    %esp,%ebp
801053f7:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801053fa:	83 ec 0c             	sub    $0xc,%esp
801053fd:	68 20 45 11 80       	push   $0x80114520
80105402:	e8 7d 14 00 00       	call   80106884 <acquire>
80105407:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = havechildren(proc, ptable.pLists.running) ||
8010540a:	8b 15 74 6c 11 80    	mov    0x80116c74,%edx
80105410:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105416:	83 ec 08             	sub    $0x8,%esp
80105419:	52                   	push   %edx
8010541a:	50                   	push   %eax
8010541b:	e8 de 01 00 00       	call   801055fe <havechildren>
80105420:	83 c4 10             	add    $0x10,%esp
               havechildren(proc, ptable.pLists.zombie) ||
               havechildren(proc, ptable.pLists.embryo) ||
80105423:	85 c0                	test   %eax,%eax
80105425:	75 57                	jne    8010547e <wait+0x8a>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = havechildren(proc, ptable.pLists.running) ||
               havechildren(proc, ptable.pLists.zombie) ||
80105427:	8b 15 70 6c 11 80    	mov    0x80116c70,%edx
8010542d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105433:	83 ec 08             	sub    $0x8,%esp
80105436:	52                   	push   %edx
80105437:	50                   	push   %eax
80105438:	e8 c1 01 00 00       	call   801055fe <havechildren>
8010543d:	83 c4 10             	add    $0x10,%esp
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = havechildren(proc, ptable.pLists.running) ||
80105440:	85 c0                	test   %eax,%eax
80105442:	75 3a                	jne    8010547e <wait+0x8a>
               havechildren(proc, ptable.pLists.zombie) ||
               havechildren(proc, ptable.pLists.embryo) ||
80105444:	8b 15 78 6c 11 80    	mov    0x80116c78,%edx
8010544a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105450:	83 ec 08             	sub    $0x8,%esp
80105453:	52                   	push   %edx
80105454:	50                   	push   %eax
80105455:	e8 a4 01 00 00       	call   801055fe <havechildren>
8010545a:	83 c4 10             	add    $0x10,%esp

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = havechildren(proc, ptable.pLists.running) ||
               havechildren(proc, ptable.pLists.zombie) ||
8010545d:	85 c0                	test   %eax,%eax
8010545f:	75 1d                	jne    8010547e <wait+0x8a>
               havechildren(proc, ptable.pLists.embryo) ||
               havechildren(proc, ptable.pLists.sleep);
80105461:	8b 15 6c 6c 11 80    	mov    0x80116c6c,%edx
80105467:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010546d:	83 ec 08             	sub    $0x8,%esp
80105470:	52                   	push   %edx
80105471:	50                   	push   %eax
80105472:	e8 87 01 00 00       	call   801055fe <havechildren>
80105477:	83 c4 10             	add    $0x10,%esp
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = havechildren(proc, ptable.pLists.running) ||
               havechildren(proc, ptable.pLists.zombie) ||
               havechildren(proc, ptable.pLists.embryo) ||
8010547a:	85 c0                	test   %eax,%eax
8010547c:	74 07                	je     80105485 <wait+0x91>
8010547e:	b8 01 00 00 00       	mov    $0x1,%eax
80105483:	eb 05                	jmp    8010548a <wait+0x96>
80105485:	b8 00 00 00 00       	mov    $0x0,%eax
  int havekids, pid;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = havechildren(proc, ptable.pLists.running) ||
8010548a:	89 45 f0             	mov    %eax,-0x10(%ebp)
               havechildren(proc, ptable.pLists.embryo) ||
               havechildren(proc, ptable.pLists.sleep);

    // If we do not find any children, scan the ready lists
    // to find a kid.
    if(havekids == 0)
8010548d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105491:	75 41                	jne    801054d4 <wait+0xe0>
    {
      int i;
      for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
80105493:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
8010549a:	eb 2f                	jmp    801054cb <wait+0xd7>
      {
        havekids = havechildren(proc, ptable.pLists.ready[i]);
8010549c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010549f:	05 cc 09 00 00       	add    $0x9cc,%eax
801054a4:	8b 14 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%edx
801054ab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054b1:	83 ec 08             	sub    $0x8,%esp
801054b4:	52                   	push   %edx
801054b5:	50                   	push   %eax
801054b6:	e8 43 01 00 00       	call   801055fe <havechildren>
801054bb:	83 c4 10             	add    $0x10,%esp
801054be:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if(havekids == 1)
801054c1:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
801054c5:	74 0c                	je     801054d3 <wait+0xdf>
    // If we do not find any children, scan the ready lists
    // to find a kid.
    if(havekids == 0)
    {
      int i;
      for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
801054c7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801054cb:	83 7d ec 04          	cmpl   $0x4,-0x14(%ebp)
801054cf:	7e cb                	jle    8010549c <wait+0xa8>
801054d1:	eb 01                	jmp    801054d4 <wait+0xe0>
      {
        havekids = havechildren(proc, ptable.pLists.ready[i]);
        if(havekids == 1)
          break;
801054d3:	90                   	nop
      }
    }

    if(havekids)
801054d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801054d8:	0f 84 d8 00 00 00    	je     801055b6 <wait+0x1c2>
    {
      p = ptable.pLists.zombie;
801054de:	a1 70 6c 11 80       	mov    0x80116c70,%eax
801054e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
      while(p)
801054e6:	e9 c1 00 00 00       	jmp    801055ac <wait+0x1b8>
      {
        if(p->parent == proc)
801054eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801054ee:	8b 50 14             	mov    0x14(%eax),%edx
801054f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054f7:	39 c2                	cmp    %eax,%edx
801054f9:	0f 85 a1 00 00 00    	jne    801055a0 <wait+0x1ac>
        {
          pid = p->pid;
801054ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105502:	8b 40 10             	mov    0x10(%eax),%eax
80105505:	89 45 e8             	mov    %eax,-0x18(%ebp)
          kfree(p->kstack);
80105508:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010550b:	8b 40 08             	mov    0x8(%eax),%eax
8010550e:	83 ec 0c             	sub    $0xc,%esp
80105511:	50                   	push   %eax
80105512:	e8 e7 db ff ff       	call   801030fe <kfree>
80105517:	83 c4 10             	add    $0x10,%esp
          p->kstack = 0;
8010551a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010551d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          freevm(p->pgdir);
80105524:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105527:	8b 40 04             	mov    0x4(%eax),%eax
8010552a:	83 ec 0c             	sub    $0xc,%esp
8010552d:	50                   	push   %eax
8010552e:	e8 93 48 00 00       	call   80109dc6 <freevm>
80105533:	83 c4 10             	add    $0x10,%esp
          p->pid = 0;
80105536:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105539:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
          p->parent = 0;
80105540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105543:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
          p->name[0] = 0;
8010554a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010554d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
          p->killed = 0;
80105551:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105554:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
          plistremove(p, &ptable.pLists.zombie);
8010555b:	83 ec 08             	sub    $0x8,%esp
8010555e:	68 70 6c 11 80       	push   $0x80116c70
80105563:	ff 75 f4             	pushl  -0xc(%ebp)
80105566:	e8 9f f4 ff ff       	call   80104a0a <plistremove>
8010556b:	83 c4 10             	add    $0x10,%esp
          p->state = UNUSED;
8010556e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105571:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
          plistinsert(p, &ptable.pLists.free);
80105578:	83 ec 08             	sub    $0x8,%esp
8010557b:	68 68 6c 11 80       	push   $0x80116c68
80105580:	ff 75 f4             	pushl  -0xc(%ebp)
80105583:	e8 09 f4 ff ff       	call   80104991 <plistinsert>
80105588:	83 c4 10             	add    $0x10,%esp
          release(&ptable.lock);
8010558b:	83 ec 0c             	sub    $0xc,%esp
8010558e:	68 20 45 11 80       	push   $0x80114520
80105593:	e8 53 13 00 00       	call   801068eb <release>
80105598:	83 c4 10             	add    $0x10,%esp
          return pid;
8010559b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010559e:	eb 5c                	jmp    801055fc <wait+0x208>
        }

        else
          p = p->next;
801055a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a3:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801055a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }

    if(havekids)
    {
      p = ptable.pLists.zombie;
      while(p)
801055ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801055b0:	0f 85 35 ff ff ff    	jne    801054eb <wait+0xf7>
          p = p->next;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
801055b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801055ba:	74 0d                	je     801055c9 <wait+0x1d5>
801055bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c2:	8b 40 24             	mov    0x24(%eax),%eax
801055c5:	85 c0                	test   %eax,%eax
801055c7:	74 17                	je     801055e0 <wait+0x1ec>
      release(&ptable.lock);
801055c9:	83 ec 0c             	sub    $0xc,%esp
801055cc:	68 20 45 11 80       	push   $0x80114520
801055d1:	e8 15 13 00 00       	call   801068eb <release>
801055d6:	83 c4 10             	add    $0x10,%esp
      return -1;
801055d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055de:	eb 1c                	jmp    801055fc <wait+0x208>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
801055e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e6:	83 ec 08             	sub    $0x8,%esp
801055e9:	68 20 45 11 80       	push   $0x80114520
801055ee:	50                   	push   %eax
801055ef:	e8 1b 05 00 00       	call   80105b0f <sleep>
801055f4:	83 c4 10             	add    $0x10,%esp
  }
801055f7:	e9 0e fe ff ff       	jmp    8010540a <wait+0x16>
}
801055fc:	c9                   	leave  
801055fd:	c3                   	ret    

801055fe <havechildren>:

int
havechildren(struct proc* parent, struct proc* list)
{
801055fe:	55                   	push   %ebp
801055ff:	89 e5                	mov    %esp,%ebp
80105601:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = list;
80105604:	8b 45 0c             	mov    0xc(%ebp),%eax
80105607:	89 45 fc             	mov    %eax,-0x4(%ebp)

  while(p)
8010560a:	eb 1e                	jmp    8010562a <havechildren+0x2c>
  {
    if(p->parent == parent)
8010560c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010560f:	8b 40 14             	mov    0x14(%eax),%eax
80105612:	3b 45 08             	cmp    0x8(%ebp),%eax
80105615:	75 07                	jne    8010561e <havechildren+0x20>
      return 1;
80105617:	b8 01 00 00 00       	mov    $0x1,%eax
8010561c:	eb 17                	jmp    80105635 <havechildren+0x37>
    else
      p = p->next;
8010561e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105621:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105627:	89 45 fc             	mov    %eax,-0x4(%ebp)
int
havechildren(struct proc* parent, struct proc* list)
{
  struct proc* p = list;

  while(p)
8010562a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010562e:	75 dc                	jne    8010560c <havechildren+0xe>
      return 1;
    else
      p = p->next;
  }

  return 0;
80105630:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105635:	c9                   	leave  
80105636:	c3                   	ret    

80105637 <scheduler>:
}

#else
void
scheduler(void)
{
80105637:	55                   	push   %ebp
80105638:	89 e5                	mov    %esp,%ebp
8010563a:	83 ec 18             	sub    $0x18,%esp
  int idle;  // for checking if processor is idle
  int prio;  // For finding the highest priority level with processes in it.

  for(;;){
    // Enable interrupts on this processor.
    sti();
8010563d:	e8 48 f3 ff ff       	call   8010498a <sti>

    idle = 1;  // assume idle unless we schedule a process
80105642:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80105649:	83 ec 0c             	sub    $0xc,%esp
8010564c:	68 20 45 11 80       	push   $0x80114520
80105651:	e8 2e 12 00 00       	call   80106884 <acquire>
80105656:	83 c4 10             	add    $0x10,%esp
    // If we have a process we can run
    prio = 0;
80105659:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    while(prio < MAX_READY_QUEUES + 1)
80105660:	e9 cb 00 00 00       	jmp    80105730 <scheduler+0xf9>
    {
	  if(ptable.pLists.ready[prio])
80105665:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105668:	05 cc 09 00 00       	add    $0x9cc,%eax
8010566d:	8b 04 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%eax
80105674:	85 c0                	test   %eax,%eax
80105676:	0f 84 b0 00 00 00    	je     8010572c <scheduler+0xf5>
	  {
		p = ptable.pLists.ready[prio];
8010567c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010567f:	05 cc 09 00 00       	add    $0x9cc,%eax
80105684:	8b 04 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%eax
8010568b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		// Switch to chosen process.  It is the process's job
		// to release ptable.lock and then reacquire it
		// before jumping back to us.
		idle = 0;  // not idle this timeslice
8010568e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		proc = p;
80105695:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105698:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
		switchuvm(p);
8010569e:	83 ec 0c             	sub    $0xc,%esp
801056a1:	ff 75 ec             	pushl  -0x14(%ebp)
801056a4:	e8 d7 42 00 00       	call   80109980 <switchuvm>
801056a9:	83 c4 10             	add    $0x10,%esp
		plistremove(p, &(ptable.pLists.ready[prio]));
801056ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056af:	05 cc 09 00 00       	add    $0x9cc,%eax
801056b4:	c1 e0 02             	shl    $0x2,%eax
801056b7:	05 20 45 11 80       	add    $0x80114520,%eax
801056bc:	83 c0 04             	add    $0x4,%eax
801056bf:	83 ec 08             	sub    $0x8,%esp
801056c2:	50                   	push   %eax
801056c3:	ff 75 ec             	pushl  -0x14(%ebp)
801056c6:	e8 3f f3 ff ff       	call   80104a0a <plistremove>
801056cb:	83 c4 10             	add    $0x10,%esp
		p->state = RUNNING;
801056ce:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056d1:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
		plistinsert(p, &ptable.pLists.running);
801056d8:	83 ec 08             	sub    $0x8,%esp
801056db:	68 74 6c 11 80       	push   $0x80116c74
801056e0:	ff 75 ec             	pushl  -0x14(%ebp)
801056e3:	e8 a9 f2 ff ff       	call   80104991 <plistinsert>
801056e8:	83 c4 10             	add    $0x10,%esp
		#ifdef CS333_P2
		p->cpu_ticks_in = ticks;
801056eb:	8b 15 80 74 11 80    	mov    0x80117480,%edx
801056f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801056f4:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
		#endif
		swtch(&cpu->scheduler, proc->context);
801056fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105700:	8b 40 1c             	mov    0x1c(%eax),%eax
80105703:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010570a:	83 c2 04             	add    $0x4,%edx
8010570d:	83 ec 08             	sub    $0x8,%esp
80105710:	50                   	push   %eax
80105711:	52                   	push   %edx
80105712:	e8 44 16 00 00       	call   80106d5b <swtch>
80105717:	83 c4 10             	add    $0x10,%esp
		switchkvm();
8010571a:	e8 44 42 00 00       	call   80109963 <switchkvm>

		// Process is done running for now.
		// It should have changed its p->state before coming back.
		proc = 0;
8010571f:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80105726:	00 00 00 00 
        break;
8010572a:	eb 0e                	jmp    8010573a <scheduler+0x103>
	  }

      else
        ++prio;
8010572c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    idle = 1;  // assume idle unless we schedule a process
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    // If we have a process we can run
    prio = 0;
    while(prio < MAX_READY_QUEUES + 1)
80105730:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80105734:	0f 8e 2b ff ff ff    	jle    80105665 <scheduler+0x2e>

      else
        ++prio;
    }

    if(ticks > ptable.PromoteAtTicks)
8010573a:	8b 15 7c 6c 11 80    	mov    0x80116c7c,%edx
80105740:	a1 80 74 11 80       	mov    0x80117480,%eax
80105745:	39 c2                	cmp    %eax,%edx
80105747:	73 14                	jae    8010575d <scheduler+0x126>
    {
      dopromotion();
80105749:	e8 38 00 00 00       	call   80105786 <dopromotion>
      ptable.PromoteAtTicks += TICKS_TO_PROMOTE;
8010574e:	a1 7c 6c 11 80       	mov    0x80116c7c,%eax
80105753:	05 10 27 00 00       	add    $0x2710,%eax
80105758:	a3 7c 6c 11 80       	mov    %eax,0x80116c7c
    }

    release(&ptable.lock);
8010575d:	83 ec 0c             	sub    $0xc,%esp
80105760:	68 20 45 11 80       	push   $0x80114520
80105765:	e8 81 11 00 00       	call   801068eb <release>
8010576a:	83 c4 10             	add    $0x10,%esp
    // if idle, wait for next interrupt
    if (idle) {
8010576d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105771:	0f 84 c6 fe ff ff    	je     8010563d <scheduler+0x6>
      sti();
80105777:	e8 0e f2 ff ff       	call   8010498a <sti>
      hlt();
8010577c:	e8 f2 f1 ff ff       	call   80104973 <hlt>
    }
  }
80105781:	e9 b7 fe ff ff       	jmp    8010563d <scheduler+0x6>

80105786 <dopromotion>:
}

void
dopromotion(void)
{
80105786:	55                   	push   %ebp
80105787:	89 e5                	mov    %esp,%ebp
80105789:	83 ec 18             	sub    $0x18,%esp
  // TODO: P4 - Clean all this up!
  struct proc* p;

  p = ptable.pLists.running;
8010578c:	a1 74 6c 11 80       	mov    0x80116c74,%eax
80105791:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80105794:	eb 2e                	jmp    801057c4 <dopromotion+0x3e>
  {
    if(p->priority > 0)
80105796:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105799:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010579f:	85 c0                	test   %eax,%eax
801057a1:	74 15                	je     801057b8 <dopromotion+0x32>
      p->priority -= 1;
801057a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057a6:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801057ac:	8d 50 ff             	lea    -0x1(%eax),%edx
801057af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057b2:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

    p = p->next;
801057b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057bb:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801057c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  // TODO: P4 - Clean all this up!
  struct proc* p;

  p = ptable.pLists.running;
  while(p)
801057c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057c8:	75 cc                	jne    80105796 <dopromotion+0x10>
      p->priority -= 1;

    p = p->next;
  }

  p = ptable.pLists.sleep;
801057ca:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
801057cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
801057d2:	eb 2e                	jmp    80105802 <dopromotion+0x7c>
  {
    if(p->priority > 0)
801057d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801057dd:	85 c0                	test   %eax,%eax
801057df:	74 15                	je     801057f6 <dopromotion+0x70>
      p->priority -= 1;
801057e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057e4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801057ea:	8d 50 ff             	lea    -0x1(%eax),%edx
801057ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f0:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

    p = p->next;
801057f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057f9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801057ff:	89 45 f4             	mov    %eax,-0xc(%ebp)

    p = p->next;
  }

  p = ptable.pLists.sleep;
  while(p)
80105802:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105806:	75 cc                	jne    801057d4 <dopromotion+0x4e>

    p = p->next;
  }

  int i;
  for(i = 1; i < MAX_READY_QUEUES + 1; ++i)
80105808:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
8010580f:	e9 a0 00 00 00       	jmp    801058b4 <dopromotion+0x12e>
  {
    p = ptable.pLists.ready[i];
80105814:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105817:	05 cc 09 00 00       	add    $0x9cc,%eax
8010581c:	8b 04 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%eax
80105823:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while(p)
80105826:	eb 7e                	jmp    801058a6 <dopromotion+0x120>
    {
      plistremove(p, &ptable.pLists.ready[i]);
80105828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010582b:	05 cc 09 00 00       	add    $0x9cc,%eax
80105830:	c1 e0 02             	shl    $0x2,%eax
80105833:	05 20 45 11 80       	add    $0x80114520,%eax
80105838:	83 c0 04             	add    $0x4,%eax
8010583b:	83 ec 08             	sub    $0x8,%esp
8010583e:	50                   	push   %eax
8010583f:	ff 75 f4             	pushl  -0xc(%ebp)
80105842:	e8 c3 f1 ff ff       	call   80104a0a <plistremove>
80105847:	83 c4 10             	add    $0x10,%esp
      p->priority -= 1;
8010584a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584d:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105853:	8d 50 ff             	lea    -0x1(%eax),%edx
80105856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105859:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      plistinsert(p, &ptable.pLists.ready[p->priority]);
8010585f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105862:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105868:	05 cc 09 00 00       	add    $0x9cc,%eax
8010586d:	c1 e0 02             	shl    $0x2,%eax
80105870:	05 20 45 11 80       	add    $0x80114520,%eax
80105875:	83 c0 04             	add    $0x4,%eax
80105878:	83 ec 08             	sub    $0x8,%esp
8010587b:	50                   	push   %eax
8010587c:	ff 75 f4             	pushl  -0xc(%ebp)
8010587f:	e8 0d f1 ff ff       	call   80104991 <plistinsert>
80105884:	83 c4 10             	add    $0x10,%esp

      // In our policy, we will reset the budget
      p->budget = MAX_BUDGET;
80105887:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010588a:	c7 80 98 00 00 00 b8 	movl   $0xbb8,0x98(%eax)
80105891:	0b 00 00 

      p = ptable.pLists.ready[i];
80105894:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105897:	05 cc 09 00 00       	add    $0x9cc,%eax
8010589c:	8b 04 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%eax
801058a3:	89 45 f4             	mov    %eax,-0xc(%ebp)

  int i;
  for(i = 1; i < MAX_READY_QUEUES + 1; ++i)
  {
    p = ptable.pLists.ready[i];
    while(p)
801058a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058aa:	0f 85 78 ff ff ff    	jne    80105828 <dopromotion+0xa2>

    p = p->next;
  }

  int i;
  for(i = 1; i < MAX_READY_QUEUES + 1; ++i)
801058b0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801058b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801058b8:	0f 8e 56 ff ff ff    	jle    80105814 <dopromotion+0x8e>
      p->budget = MAX_BUDGET;

      p = ptable.pLists.ready[i];
    }
  }
}
801058be:	90                   	nop
801058bf:	c9                   	leave  
801058c0:	c3                   	ret    

801058c1 <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
801058c1:	55                   	push   %ebp
801058c2:	89 e5                	mov    %esp,%ebp
801058c4:	83 ec 18             	sub    $0x18,%esp
  int intena;
  int delta_cpu_ticks;

  if(!holding(&ptable.lock))
801058c7:	83 ec 0c             	sub    $0xc,%esp
801058ca:	68 20 45 11 80       	push   $0x80114520
801058cf:	e8 e3 10 00 00       	call   801069b7 <holding>
801058d4:	83 c4 10             	add    $0x10,%esp
801058d7:	85 c0                	test   %eax,%eax
801058d9:	75 0d                	jne    801058e8 <sched+0x27>
    panic("sched ptable.lock");
801058db:	83 ec 0c             	sub    $0xc,%esp
801058de:	68 75 a4 10 80       	push   $0x8010a475
801058e3:	e8 7e ac ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
801058e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801058ee:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801058f4:	83 f8 01             	cmp    $0x1,%eax
801058f7:	74 0d                	je     80105906 <sched+0x45>
    panic("sched locks");
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	68 87 a4 10 80       	push   $0x8010a487
80105901:	e8 60 ac ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105906:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010590c:	8b 40 0c             	mov    0xc(%eax),%eax
8010590f:	83 f8 04             	cmp    $0x4,%eax
80105912:	75 0d                	jne    80105921 <sched+0x60>
    panic("sched running");
80105914:	83 ec 0c             	sub    $0xc,%esp
80105917:	68 93 a4 10 80       	push   $0x8010a493
8010591c:	e8 45 ac ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
80105921:	e8 54 f0 ff ff       	call   8010497a <readeflags>
80105926:	25 00 02 00 00       	and    $0x200,%eax
8010592b:	85 c0                	test   %eax,%eax
8010592d:	74 0d                	je     8010593c <sched+0x7b>
    panic("sched interruptible");
8010592f:	83 ec 0c             	sub    $0xc,%esp
80105932:	68 a1 a4 10 80       	push   $0x8010a4a1
80105937:	e8 2a ac ff ff       	call   80100566 <panic>
  intena = cpu->intena;
8010593c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105942:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80105948:	89 45 f4             	mov    %eax,-0xc(%ebp)
  delta_cpu_ticks = ticks - proc->cpu_ticks_in;
8010594b:	8b 15 80 74 11 80    	mov    0x80117480,%edx
80105951:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105957:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010595d:	29 c2                	sub    %eax,%edx
8010595f:	89 d0                	mov    %edx,%eax
80105961:	89 45 f0             	mov    %eax,-0x10(%ebp)
  #ifdef CS333_P2
  proc->cpu_ticks_total += delta_cpu_ticks;
80105964:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010596a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105971:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
80105977:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010597a:	01 ca                	add    %ecx,%edx
8010597c:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  #endif
  swtch(&proc->context, cpu->scheduler);
80105982:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105988:	8b 40 04             	mov    0x4(%eax),%eax
8010598b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105992:	83 c2 1c             	add    $0x1c,%edx
80105995:	83 ec 08             	sub    $0x8,%esp
80105998:	50                   	push   %eax
80105999:	52                   	push   %edx
8010599a:	e8 bc 13 00 00       	call   80106d5b <swtch>
8010599f:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
801059a2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801059a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059ab:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
801059b1:	90                   	nop
801059b2:	c9                   	leave  
801059b3:	c3                   	ret    

801059b4 <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
801059b4:	55                   	push   %ebp
801059b5:	89 e5                	mov    %esp,%ebp
801059b7:	83 ec 08             	sub    $0x8,%esp
  #ifdef CS333_P3P4
  acquire(&ptable.lock);  //DOC: yieldlock
801059ba:	83 ec 0c             	sub    $0xc,%esp
801059bd:	68 20 45 11 80       	push   $0x80114520
801059c2:	e8 bd 0e 00 00       	call   80106884 <acquire>
801059c7:	83 c4 10             	add    $0x10,%esp

  plistremove(proc, &ptable.pLists.running);
801059ca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059d0:	83 ec 08             	sub    $0x8,%esp
801059d3:	68 74 6c 11 80       	push   $0x80116c74
801059d8:	50                   	push   %eax
801059d9:	e8 2c f0 ff ff       	call   80104a0a <plistremove>
801059de:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
801059e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  updatebudget(proc);
801059ee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f4:	83 ec 0c             	sub    $0xc,%esp
801059f7:	50                   	push   %eax
801059f8:	e8 4a 00 00 00       	call   80105a47 <updatebudget>
801059fd:	83 c4 10             	add    $0x10,%esp
  plistinsert(proc, &(ptable.pLists.ready[proc->priority]));
80105a00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a06:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105a0c:	05 cc 09 00 00       	add    $0x9cc,%eax
80105a11:	c1 e0 02             	shl    $0x2,%eax
80105a14:	05 20 45 11 80       	add    $0x80114520,%eax
80105a19:	8d 50 04             	lea    0x4(%eax),%edx
80105a1c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a22:	83 ec 08             	sub    $0x8,%esp
80105a25:	52                   	push   %edx
80105a26:	50                   	push   %eax
80105a27:	e8 65 ef ff ff       	call   80104991 <plistinsert>
80105a2c:	83 c4 10             	add    $0x10,%esp

  sched();
80105a2f:	e8 8d fe ff ff       	call   801058c1 <sched>
  release(&ptable.lock);
80105a34:	83 ec 0c             	sub    $0xc,%esp
80105a37:	68 20 45 11 80       	push   $0x80114520
80105a3c:	e8 aa 0e 00 00       	call   801068eb <release>
80105a41:	83 c4 10             	add    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
  #endif
}
80105a44:	90                   	nop
80105a45:	c9                   	leave  
80105a46:	c3                   	ret    

80105a47 <updatebudget>:

#ifdef CS333_P3P4
void
updatebudget(struct proc* proc)
{
80105a47:	55                   	push   %ebp
80105a48:	89 e5                	mov    %esp,%ebp
  proc->budget -= (ticks - proc->cpu_ticks_in);
80105a4a:	8b 45 08             	mov    0x8(%ebp),%eax
80105a4d:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105a53:	89 c1                	mov    %eax,%ecx
80105a55:	8b 45 08             	mov    0x8(%ebp),%eax
80105a58:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80105a5e:	a1 80 74 11 80       	mov    0x80117480,%eax
80105a63:	29 c2                	sub    %eax,%edx
80105a65:	89 d0                	mov    %edx,%eax
80105a67:	01 c8                	add    %ecx,%eax
80105a69:	89 c2                	mov    %eax,%edx
80105a6b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a6e:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  if(proc->budget <= 0)
80105a74:	8b 45 08             	mov    0x8(%ebp),%eax
80105a77:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105a7d:	85 c0                	test   %eax,%eax
80105a7f:	7f 45                	jg     80105ac6 <updatebudget+0x7f>
  {
    proc->priority += 1;
80105a81:	8b 45 08             	mov    0x8(%ebp),%eax
80105a84:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105a8a:	8d 50 01             	lea    0x1(%eax),%edx
80105a8d:	8b 45 08             	mov    0x8(%ebp),%eax
80105a90:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    if(proc->priority > MAX_READY_QUEUES)
80105a96:	8b 45 08             	mov    0x8(%ebp),%eax
80105a99:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105a9f:	83 f8 04             	cmp    $0x4,%eax
80105aa2:	76 15                	jbe    80105ab9 <updatebudget+0x72>
      proc->priority -= 1;
80105aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80105aa7:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105aad:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ab0:	8b 45 08             	mov    0x8(%ebp),%eax
80105ab3:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)

    proc->budget = MAX_BUDGET;
80105ab9:	8b 45 08             	mov    0x8(%ebp),%eax
80105abc:	c7 80 98 00 00 00 b8 	movl   $0xbb8,0x98(%eax)
80105ac3:	0b 00 00 
  }
}
80105ac6:	90                   	nop
80105ac7:	5d                   	pop    %ebp
80105ac8:	c3                   	ret    

80105ac9 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80105ac9:	55                   	push   %ebp
80105aca:	89 e5                	mov    %esp,%ebp
80105acc:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105acf:	83 ec 0c             	sub    $0xc,%esp
80105ad2:	68 20 45 11 80       	push   $0x80114520
80105ad7:	e8 0f 0e 00 00       	call   801068eb <release>
80105adc:	83 c4 10             	add    $0x10,%esp

  if (first) {
80105adf:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	74 24                	je     80105b0c <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80105ae8:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105aef:	00 00 00 
    iinit(ROOTDEV);
80105af2:	83 ec 0c             	sub    $0xc,%esp
80105af5:	6a 01                	push   $0x1
80105af7:	e8 e3 bc ff ff       	call   801017df <iinit>
80105afc:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105aff:	83 ec 0c             	sub    $0xc,%esp
80105b02:	6a 01                	push   $0x1
80105b04:	e8 5b dd ff ff       	call   80103864 <initlog>
80105b09:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80105b0c:	90                   	nop
80105b0d:	c9                   	leave  
80105b0e:	c3                   	ret    

80105b0f <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105b0f:	55                   	push   %ebp
80105b10:	89 e5                	mov    %esp,%ebp
80105b12:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80105b15:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b1b:	85 c0                	test   %eax,%eax
80105b1d:	75 0d                	jne    80105b2c <sleep+0x1d>
    panic("sleep");
80105b1f:	83 ec 0c             	sub    $0xc,%esp
80105b22:	68 b5 a4 10 80       	push   $0x8010a4b5
80105b27:	e8 3a aa ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105b2c:	81 7d 0c 20 45 11 80 	cmpl   $0x80114520,0xc(%ebp)
80105b33:	74 24                	je     80105b59 <sleep+0x4a>
    acquire(&ptable.lock);
80105b35:	83 ec 0c             	sub    $0xc,%esp
80105b38:	68 20 45 11 80       	push   $0x80114520
80105b3d:	e8 42 0d 00 00       	call   80106884 <acquire>
80105b42:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105b45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105b49:	74 0e                	je     80105b59 <sleep+0x4a>
80105b4b:	83 ec 0c             	sub    $0xc,%esp
80105b4e:	ff 75 0c             	pushl  0xc(%ebp)
80105b51:	e8 95 0d 00 00       	call   801068eb <release>
80105b56:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80105b59:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b5f:	8b 55 08             	mov    0x8(%ebp),%edx
80105b62:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  plistremove(proc, &ptable.pLists.running);
80105b65:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b6b:	83 ec 08             	sub    $0x8,%esp
80105b6e:	68 74 6c 11 80       	push   $0x80116c74
80105b73:	50                   	push   %eax
80105b74:	e8 91 ee ff ff       	call   80104a0a <plistremove>
80105b79:	83 c4 10             	add    $0x10,%esp
  updatebudget(proc);
80105b7c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b82:	83 ec 0c             	sub    $0xc,%esp
80105b85:	50                   	push   %eax
80105b86:	e8 bc fe ff ff       	call   80105a47 <updatebudget>
80105b8b:	83 c4 10             	add    $0x10,%esp
  proc->state = SLEEPING;
80105b8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b94:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  plistinsert(proc, &ptable.pLists.sleep);
80105b9b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ba1:	83 ec 08             	sub    $0x8,%esp
80105ba4:	68 6c 6c 11 80       	push   $0x80116c6c
80105ba9:	50                   	push   %eax
80105baa:	e8 e2 ed ff ff       	call   80104991 <plistinsert>
80105baf:	83 c4 10             	add    $0x10,%esp
  #else
  proc->state = SLEEPING;
  #endif
  sched();
80105bb2:	e8 0a fd ff ff       	call   801058c1 <sched>

  // Tidy up.
  proc->chan = 0;
80105bb7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bbd:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
80105bc4:	81 7d 0c 20 45 11 80 	cmpl   $0x80114520,0xc(%ebp)
80105bcb:	74 24                	je     80105bf1 <sleep+0xe2>
    release(&ptable.lock);
80105bcd:	83 ec 0c             	sub    $0xc,%esp
80105bd0:	68 20 45 11 80       	push   $0x80114520
80105bd5:	e8 11 0d 00 00       	call   801068eb <release>
80105bda:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
80105bdd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105be1:	74 0e                	je     80105bf1 <sleep+0xe2>
80105be3:	83 ec 0c             	sub    $0xc,%esp
80105be6:	ff 75 0c             	pushl  0xc(%ebp)
80105be9:	e8 96 0c 00 00       	call   80106884 <acquire>
80105bee:	83 c4 10             	add    $0x10,%esp
  }
}
80105bf1:	90                   	nop
80105bf2:	c9                   	leave  
80105bf3:	c3                   	ret    

80105bf4 <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	83 ec 18             	sub    $0x18,%esp
  struct proc* curr = ptable.pLists.sleep;
80105bfa:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
80105bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc* prev = 0x0;
80105c02:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  while(curr)
80105c09:	e9 bb 00 00 00       	jmp    80105cc9 <wakeup1+0xd5>
  {
    if(curr->chan == chan)
80105c0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c11:	8b 40 20             	mov    0x20(%eax),%eax
80105c14:	3b 45 08             	cmp    0x8(%ebp),%eax
80105c17:	0f 85 9a 00 00 00    	jne    80105cb7 <wakeup1+0xc3>
    {
      curr->state = RUNNABLE;
80105c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c20:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

      if(prev == 0x0)
80105c27:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c2b:	75 42                	jne    80105c6f <wakeup1+0x7b>
      {
        ptable.pLists.sleep = ptable.pLists.sleep->next;
80105c2d:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
80105c32:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105c38:	a3 6c 6c 11 80       	mov    %eax,0x80116c6c
        plistinsert(curr, &(ptable.pLists.ready[curr->priority]));
80105c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c40:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c46:	05 cc 09 00 00       	add    $0x9cc,%eax
80105c4b:	c1 e0 02             	shl    $0x2,%eax
80105c4e:	05 20 45 11 80       	add    $0x80114520,%eax
80105c53:	83 c0 04             	add    $0x4,%eax
80105c56:	83 ec 08             	sub    $0x8,%esp
80105c59:	50                   	push   %eax
80105c5a:	ff 75 f4             	pushl  -0xc(%ebp)
80105c5d:	e8 2f ed ff ff       	call   80104991 <plistinsert>
80105c62:	83 c4 10             	add    $0x10,%esp
        curr = ptable.pLists.sleep;
80105c65:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
80105c6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c6d:	eb 5a                	jmp    80105cc9 <wakeup1+0xd5>
      }

      else
      {
        prev->next = curr->next;
80105c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c72:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80105c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c7b:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        plistinsert(curr, &(ptable.pLists.ready[curr->priority]));
80105c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c84:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105c8a:	05 cc 09 00 00       	add    $0x9cc,%eax
80105c8f:	c1 e0 02             	shl    $0x2,%eax
80105c92:	05 20 45 11 80       	add    $0x80114520,%eax
80105c97:	83 c0 04             	add    $0x4,%eax
80105c9a:	83 ec 08             	sub    $0x8,%esp
80105c9d:	50                   	push   %eax
80105c9e:	ff 75 f4             	pushl  -0xc(%ebp)
80105ca1:	e8 eb ec ff ff       	call   80104991 <plistinsert>
80105ca6:	83 c4 10             	add    $0x10,%esp
        curr = prev->next;
80105ca9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cac:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105cb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cb5:	eb 12                	jmp    80105cc9 <wakeup1+0xd5>
      }
    }

    else
    {
      prev = curr;
80105cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cba:	89 45 f0             	mov    %eax,-0x10(%ebp)
      curr = curr->next;
80105cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cc0:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105cc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
wakeup1(void *chan)
{
  struct proc* curr = ptable.pLists.sleep;
  struct proc* prev = 0x0;

  while(curr)
80105cc9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ccd:	0f 85 3b ff ff ff    	jne    80105c0e <wakeup1+0x1a>
    {
      prev = curr;
      curr = curr->next;
    }
  }
}
80105cd3:	90                   	nop
80105cd4:	c9                   	leave  
80105cd5:	c3                   	ret    

80105cd6 <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105cd6:	55                   	push   %ebp
80105cd7:	89 e5                	mov    %esp,%ebp
80105cd9:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105cdc:	83 ec 0c             	sub    $0xc,%esp
80105cdf:	68 20 45 11 80       	push   $0x80114520
80105ce4:	e8 9b 0b 00 00       	call   80106884 <acquire>
80105ce9:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105cec:	83 ec 0c             	sub    $0xc,%esp
80105cef:	ff 75 08             	pushl  0x8(%ebp)
80105cf2:	e8 fd fe ff ff       	call   80105bf4 <wakeup1>
80105cf7:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105cfa:	83 ec 0c             	sub    $0xc,%esp
80105cfd:	68 20 45 11 80       	push   $0x80114520
80105d02:	e8 e4 0b 00 00       	call   801068eb <release>
80105d07:	83 c4 10             	add    $0x10,%esp
}
80105d0a:	90                   	nop
80105d0b:	c9                   	leave  
80105d0c:	c3                   	ret    

80105d0d <kill>:
  return -1;
}
#else
int
kill(int pid)
{
80105d0d:	55                   	push   %ebp
80105d0e:	89 e5                	mov    %esp,%ebp
80105d10:	83 ec 18             	sub    $0x18,%esp
  int result = -1;
80105d13:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)

  acquire(&ptable.lock);
80105d1a:	83 ec 0c             	sub    $0xc,%esp
80105d1d:	68 20 45 11 80       	push   $0x80114520
80105d22:	e8 5d 0b 00 00       	call   80106884 <acquire>
80105d27:	83 c4 10             	add    $0x10,%esp

  if(findandkill(pid, ptable.pLists.running))
80105d2a:	a1 74 6c 11 80       	mov    0x80116c74,%eax
80105d2f:	83 ec 08             	sub    $0x8,%esp
80105d32:	50                   	push   %eax
80105d33:	ff 75 08             	pushl  0x8(%ebp)
80105d36:	e8 f0 00 00 00       	call   80105e2b <findandkill>
80105d3b:	83 c4 10             	add    $0x10,%esp
80105d3e:	85 c0                	test   %eax,%eax
80105d40:	74 0c                	je     80105d4e <kill+0x41>
    result = 0;
80105d42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105d49:	e9 c8 00 00 00       	jmp    80105e16 <kill+0x109>
  else if(findandkill(pid, ptable.pLists.sleep))
80105d4e:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
80105d53:	83 ec 08             	sub    $0x8,%esp
80105d56:	50                   	push   %eax
80105d57:	ff 75 08             	pushl  0x8(%ebp)
80105d5a:	e8 cc 00 00 00       	call   80105e2b <findandkill>
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	85 c0                	test   %eax,%eax
80105d64:	74 0c                	je     80105d72 <kill+0x65>
    result = 0;
80105d66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105d6d:	e9 a4 00 00 00       	jmp    80105e16 <kill+0x109>
  else if(findandkill(pid, ptable.pLists.free))
80105d72:	a1 68 6c 11 80       	mov    0x80116c68,%eax
80105d77:	83 ec 08             	sub    $0x8,%esp
80105d7a:	50                   	push   %eax
80105d7b:	ff 75 08             	pushl  0x8(%ebp)
80105d7e:	e8 a8 00 00 00       	call   80105e2b <findandkill>
80105d83:	83 c4 10             	add    $0x10,%esp
80105d86:	85 c0                	test   %eax,%eax
80105d88:	74 0c                	je     80105d96 <kill+0x89>
    result = 0;
80105d8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105d91:	e9 80 00 00 00       	jmp    80105e16 <kill+0x109>
  else if(findandkill(pid, ptable.pLists.embryo))
80105d96:	a1 78 6c 11 80       	mov    0x80116c78,%eax
80105d9b:	83 ec 08             	sub    $0x8,%esp
80105d9e:	50                   	push   %eax
80105d9f:	ff 75 08             	pushl  0x8(%ebp)
80105da2:	e8 84 00 00 00       	call   80105e2b <findandkill>
80105da7:	83 c4 10             	add    $0x10,%esp
80105daa:	85 c0                	test   %eax,%eax
80105dac:	74 09                	je     80105db7 <kill+0xaa>
    result = 0;
80105dae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105db5:	eb 5f                	jmp    80105e16 <kill+0x109>
  else if(findandkill(pid, ptable.pLists.zombie))
80105db7:	a1 70 6c 11 80       	mov    0x80116c70,%eax
80105dbc:	83 ec 08             	sub    $0x8,%esp
80105dbf:	50                   	push   %eax
80105dc0:	ff 75 08             	pushl  0x8(%ebp)
80105dc3:	e8 63 00 00 00       	call   80105e2b <findandkill>
80105dc8:	83 c4 10             	add    $0x10,%esp
80105dcb:	85 c0                	test   %eax,%eax
80105dcd:	74 09                	je     80105dd8 <kill+0xcb>
    result = 0;
80105dcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105dd6:	eb 3e                	jmp    80105e16 <kill+0x109>
  else
  {
    int i;
    for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
80105dd8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105ddf:	eb 2f                	jmp    80105e10 <kill+0x103>
    {
      if(findandkill(pid, ptable.pLists.ready[i]))
80105de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de4:	05 cc 09 00 00       	add    $0x9cc,%eax
80105de9:	8b 04 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%eax
80105df0:	83 ec 08             	sub    $0x8,%esp
80105df3:	50                   	push   %eax
80105df4:	ff 75 08             	pushl  0x8(%ebp)
80105df7:	e8 2f 00 00 00       	call   80105e2b <findandkill>
80105dfc:	83 c4 10             	add    $0x10,%esp
80105dff:	85 c0                	test   %eax,%eax
80105e01:	74 09                	je     80105e0c <kill+0xff>
      {
        result = 0;
80105e03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        break;
80105e0a:	eb 0a                	jmp    80105e16 <kill+0x109>
  else if(findandkill(pid, ptable.pLists.zombie))
    result = 0;
  else
  {
    int i;
    for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
80105e0c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105e10:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80105e14:	7e cb                	jle    80105de1 <kill+0xd4>
        break;
      }
    }
  }

  release(&ptable.lock);
80105e16:	83 ec 0c             	sub    $0xc,%esp
80105e19:	68 20 45 11 80       	push   $0x80114520
80105e1e:	e8 c8 0a 00 00       	call   801068eb <release>
80105e23:	83 c4 10             	add    $0x10,%esp

  return result;
80105e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105e29:	c9                   	leave  
80105e2a:	c3                   	ret    

80105e2b <findandkill>:

int
findandkill(int pid, struct proc* list)
{
80105e2b:	55                   	push   %ebp
80105e2c:	89 e5                	mov    %esp,%ebp
80105e2e:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  p = list;
80105e31:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e34:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while(p)
80105e37:	eb 79                	jmp    80105eb2 <findandkill+0x87>
  {
    if(p->pid == pid)
80105e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e3c:	8b 50 10             	mov    0x10(%eax),%edx
80105e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80105e42:	39 c2                	cmp    %eax,%edx
80105e44:	75 60                	jne    80105ea6 <findandkill+0x7b>
    {
      p->killed = 1;
80105e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e49:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)

      if(list == ptable.pLists.sleep)
80105e50:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
80105e55:	3b 45 0c             	cmp    0xc(%ebp),%eax
80105e58:	75 45                	jne    80105e9f <findandkill+0x74>
      {
        plistremove(p, &ptable.pLists.sleep);
80105e5a:	83 ec 08             	sub    $0x8,%esp
80105e5d:	68 6c 6c 11 80       	push   $0x80116c6c
80105e62:	ff 75 f4             	pushl  -0xc(%ebp)
80105e65:	e8 a0 eb ff ff       	call   80104a0a <plistremove>
80105e6a:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNABLE;
80105e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e70:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        plistinsert(p, &(ptable.pLists.ready[p->priority]));
80105e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e7a:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
80105e80:	05 cc 09 00 00       	add    $0x9cc,%eax
80105e85:	c1 e0 02             	shl    $0x2,%eax
80105e88:	05 20 45 11 80       	add    $0x80114520,%eax
80105e8d:	83 c0 04             	add    $0x4,%eax
80105e90:	83 ec 08             	sub    $0x8,%esp
80105e93:	50                   	push   %eax
80105e94:	ff 75 f4             	pushl  -0xc(%ebp)
80105e97:	e8 f5 ea ff ff       	call   80104991 <plistinsert>
80105e9c:	83 c4 10             	add    $0x10,%esp
      }

      return 1;
80105e9f:	b8 01 00 00 00       	mov    $0x1,%eax
80105ea4:	eb 17                	jmp    80105ebd <findandkill+0x92>
    }

    else
      p = p->next;
80105ea6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea9:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105eaf:	89 45 f4             	mov    %eax,-0xc(%ebp)
{
  struct proc* p;

  p = list;

  while(p)
80105eb2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105eb6:	75 81                	jne    80105e39 <findandkill+0xe>

    else
      p = p->next;
  }

  return 0;
80105eb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105ebd:	c9                   	leave  
80105ebe:	c3                   	ret    

80105ebf <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105ebf:	55                   	push   %ebp
80105ec0:	89 e5                	mov    %esp,%ebp
80105ec2:	83 ec 48             	sub    $0x48,%esp
  struct proc *p;
  char *state;
  uint pc[10];

  #ifdef CS333_P3P4
  cprintf("\n%s	%s	%s	%s	%s	%s	%s	%s	%s	%s	 %s\n", "PID", "Name", "UID", "GID", "PPID", "Priority", "Elapsed", "CPU", "State", "Size", "PCs");
80105ec5:	68 e5 a4 10 80       	push   $0x8010a4e5
80105eca:	68 e9 a4 10 80       	push   $0x8010a4e9
80105ecf:	68 ee a4 10 80       	push   $0x8010a4ee
80105ed4:	68 f4 a4 10 80       	push   $0x8010a4f4
80105ed9:	68 f8 a4 10 80       	push   $0x8010a4f8
80105ede:	68 00 a5 10 80       	push   $0x8010a500
80105ee3:	68 09 a5 10 80       	push   $0x8010a509
80105ee8:	68 0e a5 10 80       	push   $0x8010a50e
80105eed:	68 12 a5 10 80       	push   $0x8010a512
80105ef2:	68 16 a5 10 80       	push   $0x8010a516
80105ef7:	68 1b a5 10 80       	push   $0x8010a51b
80105efc:	68 20 a5 10 80       	push   $0x8010a520
80105f01:	e8 c0 a4 ff ff       	call   801003c6 <cprintf>
80105f06:	83 c4 30             	add    $0x30,%esp
  cprintf("\n%s	%s	%s	%s	%s	%s	%s	%s	%s	 %s\n", "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size", "PCs");
  #elif CS333_P1
  cprintf("\n%s	%s	%s	%s		 %s\n", "PID", "State", "Name", "Elapsed", "PCs");
  #endif
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105f09:	c7 45 f0 54 45 11 80 	movl   $0x80114554,-0x10(%ebp)
80105f10:	e9 cd 00 00 00       	jmp    80105fe2 <procdump+0x123>
    if(p->state == UNUSED)
80105f15:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f18:	8b 40 0c             	mov    0xc(%eax),%eax
80105f1b:	85 c0                	test   %eax,%eax
80105f1d:	0f 84 b7 00 00 00    	je     80105fda <procdump+0x11b>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105f23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f26:	8b 40 0c             	mov    0xc(%eax),%eax
80105f29:	83 f8 05             	cmp    $0x5,%eax
80105f2c:	77 23                	ja     80105f51 <procdump+0x92>
80105f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f31:	8b 40 0c             	mov    0xc(%eax),%eax
80105f34:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105f3b:	85 c0                	test   %eax,%eax
80105f3d:	74 12                	je     80105f51 <procdump+0x92>
      state = states[p->state];
80105f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f42:	8b 40 0c             	mov    0xc(%eax),%eax
80105f45:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105f4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105f4f:	eb 07                	jmp    80105f58 <procdump+0x99>
    else
      state = "???";
80105f51:	c7 45 ec 44 a5 10 80 	movl   $0x8010a544,-0x14(%ebp)
    #ifdef CS333_P1
    fancy_dump(p, state);
80105f58:	83 ec 08             	sub    $0x8,%esp
80105f5b:	ff 75 ec             	pushl  -0x14(%ebp)
80105f5e:	ff 75 f0             	pushl  -0x10(%ebp)
80105f61:	e8 8c 00 00 00       	call   80105ff2 <fancy_dump>
80105f66:	83 c4 10             	add    $0x10,%esp
	#else
    cprintf("%d %s %s", p->pid, state, p->name);
	#endif
    if(p->state == SLEEPING){
80105f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6c:	8b 40 0c             	mov    0xc(%eax),%eax
80105f6f:	83 f8 02             	cmp    $0x2,%eax
80105f72:	75 54                	jne    80105fc8 <procdump+0x109>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105f74:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f77:	8b 40 1c             	mov    0x1c(%eax),%eax
80105f7a:	8b 40 0c             	mov    0xc(%eax),%eax
80105f7d:	83 c0 08             	add    $0x8,%eax
80105f80:	89 c2                	mov    %eax,%edx
80105f82:	83 ec 08             	sub    $0x8,%esp
80105f85:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105f88:	50                   	push   %eax
80105f89:	52                   	push   %edx
80105f8a:	e8 ae 09 00 00       	call   8010693d <getcallerpcs>
80105f8f:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105f92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105f99:	eb 1c                	jmp    80105fb7 <procdump+0xf8>
        cprintf(" %p", pc[i]);
80105f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f9e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105fa2:	83 ec 08             	sub    $0x8,%esp
80105fa5:	50                   	push   %eax
80105fa6:	68 48 a5 10 80       	push   $0x8010a548
80105fab:	e8 16 a4 ff ff       	call   801003c6 <cprintf>
80105fb0:	83 c4 10             	add    $0x10,%esp
	#else
    cprintf("%d %s %s", p->pid, state, p->name);
	#endif
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105fb3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105fb7:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105fbb:	7f 0b                	jg     80105fc8 <procdump+0x109>
80105fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc0:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105fc4:	85 c0                	test   %eax,%eax
80105fc6:	75 d3                	jne    80105f9b <procdump+0xdc>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105fc8:	83 ec 0c             	sub    $0xc,%esp
80105fcb:	68 4c a5 10 80       	push   $0x8010a54c
80105fd0:	e8 f1 a3 ff ff       	call   801003c6 <cprintf>
80105fd5:	83 c4 10             	add    $0x10,%esp
80105fd8:	eb 01                	jmp    80105fdb <procdump+0x11c>
  cprintf("\n%s	%s	%s	%s		 %s\n", "PID", "State", "Name", "Elapsed", "PCs");
  #endif
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105fda:	90                   	nop
  cprintf("\n%s	%s	%s	%s	%s	%s	%s	%s	%s	 %s\n", "PID", "Name", "UID", "GID", "PPID", "Elapsed", "CPU", "State", "Size", "PCs");
  #elif CS333_P1
  cprintf("\n%s	%s	%s	%s		 %s\n", "PID", "State", "Name", "Elapsed", "PCs");
  #endif
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105fdb:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105fe2:	81 7d f0 54 6c 11 80 	cmpl   $0x80116c54,-0x10(%ebp)
80105fe9:	0f 82 26 ff ff ff    	jb     80105f15 <procdump+0x56>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105fef:	90                   	nop
80105ff0:	c9                   	leave  
80105ff1:	c3                   	ret    

80105ff2 <fancy_dump>:

#ifdef CS333_P1
void
fancy_dump(struct proc* p, char* state)
{
80105ff2:	55                   	push   %ebp
80105ff3:	89 e5                	mov    %esp,%ebp
80105ff5:	57                   	push   %edi
80105ff6:	56                   	push   %esi
80105ff7:	53                   	push   %ebx
80105ff8:	83 ec 2c             	sub    $0x2c,%esp
  // Like the elapsed running time, we compute our floating
  // value with both a seconds and milliseconds component.
  uint csec, cmil;

  // Calculated the elapsed time in seconds.
  edticks = ticks - p->start_ticks;
80105ffb:	8b 15 80 74 11 80    	mov    0x80117480,%edx
80106001:	8b 45 08             	mov    0x8(%ebp),%eax
80106004:	8b 40 7c             	mov    0x7c(%eax),%eax
80106007:	29 c2                	sub    %eax,%edx
80106009:	89 d0                	mov    %edx,%eax
8010600b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  esec = edticks / 1000;
8010600e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106011:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80106016:	f7 e2                	mul    %edx
80106018:	89 d0                	mov    %edx,%eax
8010601a:	c1 e8 06             	shr    $0x6,%eax
8010601d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  emil = edticks % 1000;
80106020:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106023:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80106028:	89 c8                	mov    %ecx,%eax
8010602a:	f7 e2                	mul    %edx
8010602c:	89 d0                	mov    %edx,%eax
8010602e:	c1 e8 06             	shr    $0x6,%eax
80106031:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80106037:	29 c1                	sub    %eax,%ecx
80106039:	89 c8                	mov    %ecx,%eax
8010603b:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Calculate total CPU time in seconds
  csec = p->cpu_ticks_total / 1000;
8010603e:	8b 45 08             	mov    0x8(%ebp),%eax
80106041:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80106047:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
8010604c:	f7 e2                	mul    %edx
8010604e:	89 d0                	mov    %edx,%eax
80106050:	c1 e8 06             	shr    $0x6,%eax
80106053:	89 45 d8             	mov    %eax,-0x28(%ebp)
  cmil = p->cpu_ticks_total % 1000;
80106056:	8b 45 08             	mov    0x8(%ebp),%eax
80106059:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
8010605f:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
80106064:	89 c8                	mov    %ecx,%eax
80106066:	f7 e2                	mul    %edx
80106068:	89 d0                	mov    %edx,%eax
8010606a:	c1 e8 06             	shr    $0x6,%eax
8010606d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106070:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80106073:	69 c0 e8 03 00 00    	imul   $0x3e8,%eax,%eax
80106079:	29 c1                	sub    %eax,%ecx
8010607b:	89 c8                	mov    %ecx,%eax
8010607d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  ppid = p->parent ? p->parent->pid : 1;
80106080:	8b 45 08             	mov    0x8(%ebp),%eax
80106083:	8b 40 14             	mov    0x14(%eax),%eax
80106086:	85 c0                	test   %eax,%eax
80106088:	74 0b                	je     80106095 <fancy_dump+0xa3>
8010608a:	8b 45 08             	mov    0x8(%ebp),%eax
8010608d:	8b 40 14             	mov    0x14(%eax),%eax
80106090:	8b 40 10             	mov    0x10(%eax),%eax
80106093:	eb 05                	jmp    8010609a <fancy_dump+0xa8>
80106095:	b8 01 00 00 00       	mov    $0x1,%eax
8010609a:	89 45 d0             	mov    %eax,-0x30(%ebp)

  cprintf("%d	%s	%d	%d	%d	%d		%d.%d	%d.%d	%s	%d	", p->pid, p->name, p->uid, p->gid, ppid, p->priority, esec, emil, csec, cmil, state, p->sz);
8010609d:	8b 45 08             	mov    0x8(%ebp),%eax
801060a0:	8b 30                	mov    (%eax),%esi
801060a2:	8b 45 08             	mov    0x8(%ebp),%eax
801060a5:	8b 98 94 00 00 00    	mov    0x94(%eax),%ebx
801060ab:	8b 45 08             	mov    0x8(%ebp),%eax
801060ae:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
801060b4:	8b 45 08             	mov    0x8(%ebp),%eax
801060b7:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
801060bd:	8b 45 08             	mov    0x8(%ebp),%eax
801060c0:	8d 78 6c             	lea    0x6c(%eax),%edi
801060c3:	8b 45 08             	mov    0x8(%ebp),%eax
801060c6:	8b 40 10             	mov    0x10(%eax),%eax
801060c9:	83 ec 0c             	sub    $0xc,%esp
801060cc:	56                   	push   %esi
801060cd:	ff 75 0c             	pushl  0xc(%ebp)
801060d0:	ff 75 d4             	pushl  -0x2c(%ebp)
801060d3:	ff 75 d8             	pushl  -0x28(%ebp)
801060d6:	ff 75 dc             	pushl  -0x24(%ebp)
801060d9:	ff 75 e0             	pushl  -0x20(%ebp)
801060dc:	53                   	push   %ebx
801060dd:	ff 75 d0             	pushl  -0x30(%ebp)
801060e0:	51                   	push   %ecx
801060e1:	52                   	push   %edx
801060e2:	57                   	push   %edi
801060e3:	50                   	push   %eax
801060e4:	68 50 a5 10 80       	push   $0x8010a550
801060e9:	e8 d8 a2 ff ff       	call   801003c6 <cprintf>
801060ee:	83 c4 40             	add    $0x40,%esp
  delta_tick = ticks - p->start_ticks;
  sec = delta_tick / 1000;
  millisec = delta_tick % 1000;
  cprintf("%d	%s	%s	%d.%d		", p->pid, state, p->name, sec, millisec);
  #endif
}
801060f1:	90                   	nop
801060f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060f5:	5b                   	pop    %ebx
801060f6:	5e                   	pop    %esi
801060f7:	5f                   	pop    %edi
801060f8:	5d                   	pop    %ebp
801060f9:	c3                   	ret    

801060fa <get_active_procs>:
#endif

#ifdef CS333_P2
int
get_active_procs(uint max, struct uproc* table)
{
801060fa:	55                   	push   %ebp
801060fb:	89 e5                	mov    %esp,%ebp
801060fd:	83 ec 18             	sub    $0x18,%esp
	// Use this to conveniently access the current proc.
	struct proc* proc;

	// Special case: number of processes we want is less than
	// the number of procceses in the table
	if(max > NPROC)
80106100:	83 7d 08 40          	cmpl   $0x40,0x8(%ebp)
80106104:	76 0a                	jbe    80106110 <get_active_procs+0x16>
		return -1;
80106106:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010610b:	e9 65 02 00 00       	jmp    80106375 <get_active_procs+0x27b>

	// We do not want to read the array of processes if
	// other people are modifying it.
	acquire(&ptable.lock);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	68 20 45 11 80       	push   $0x80114520
80106118:	e8 67 07 00 00       	call   80106884 <acquire>
8010611d:	83 c4 10             	add    $0x10,%esp

	curr_proc = 0;
80106120:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	curr_table_index = 0;
80106127:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	num_read_processes = 0;
8010612e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

	for(; curr_proc < max; ++curr_proc)
80106135:	e9 1c 02 00 00       	jmp    80106356 <get_active_procs+0x25c>
	{
		proc = &ptable.proc[curr_proc];
8010613a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010613d:	69 c0 9c 00 00 00    	imul   $0x9c,%eax,%eax
80106143:	83 c0 30             	add    $0x30,%eax
80106146:	05 20 45 11 80       	add    $0x80114520,%eax
8010614b:	83 c0 04             	add    $0x4,%eax
8010614e:	89 45 e8             	mov    %eax,-0x18(%ebp)

		if(proc->state == RUNNABLE || proc->state == RUNNING || proc->state == SLEEPING)
80106151:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106154:	8b 40 0c             	mov    0xc(%eax),%eax
80106157:	83 f8 03             	cmp    $0x3,%eax
8010615a:	74 1a                	je     80106176 <get_active_procs+0x7c>
8010615c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010615f:	8b 40 0c             	mov    0xc(%eax),%eax
80106162:	83 f8 04             	cmp    $0x4,%eax
80106165:	74 0f                	je     80106176 <get_active_procs+0x7c>
80106167:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010616a:	8b 40 0c             	mov    0xc(%eax),%eax
8010616d:	83 f8 02             	cmp    $0x2,%eax
80106170:	0f 85 dc 01 00 00    	jne    80106352 <get_active_procs+0x258>
		{
			safestrcpy(table[curr_table_index].name, proc->name, STRMAX);
80106176:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106179:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010617c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010617f:	89 d0                	mov    %edx,%eax
80106181:	01 c0                	add    %eax,%eax
80106183:	01 d0                	add    %edx,%eax
80106185:	c1 e0 05             	shl    $0x5,%eax
80106188:	89 c2                	mov    %eax,%edx
8010618a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010618d:	01 d0                	add    %edx,%eax
8010618f:	83 c0 3c             	add    $0x3c,%eax
80106192:	83 ec 04             	sub    $0x4,%esp
80106195:	6a 20                	push   $0x20
80106197:	51                   	push   %ecx
80106198:	50                   	push   %eax
80106199:	e8 4c 0b 00 00       	call   80106cea <safestrcpy>
8010619e:	83 c4 10             	add    $0x10,%esp
			table[curr_table_index].pid = proc->pid;
801061a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801061a4:	89 d0                	mov    %edx,%eax
801061a6:	01 c0                	add    %eax,%eax
801061a8:	01 d0                	add    %edx,%eax
801061aa:	c1 e0 05             	shl    $0x5,%eax
801061ad:	89 c2                	mov    %eax,%edx
801061af:	8b 45 0c             	mov    0xc(%ebp),%eax
801061b2:	01 c2                	add    %eax,%edx
801061b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061b7:	8b 40 10             	mov    0x10(%eax),%eax
801061ba:	89 02                	mov    %eax,(%edx)
			table[curr_table_index].uid = proc->uid;
801061bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801061bf:	89 d0                	mov    %edx,%eax
801061c1:	01 c0                	add    %eax,%eax
801061c3:	01 d0                	add    %edx,%eax
801061c5:	c1 e0 05             	shl    $0x5,%eax
801061c8:	89 c2                	mov    %eax,%edx
801061ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801061cd:	01 c2                	add    %eax,%edx
801061cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061d2:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
801061d8:	89 42 04             	mov    %eax,0x4(%edx)
			table[curr_table_index].gid = proc->gid;
801061db:	8b 55 f0             	mov    -0x10(%ebp),%edx
801061de:	89 d0                	mov    %edx,%eax
801061e0:	01 c0                	add    %eax,%eax
801061e2:	01 d0                	add    %edx,%eax
801061e4:	c1 e0 05             	shl    $0x5,%eax
801061e7:	89 c2                	mov    %eax,%edx
801061e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801061ec:	01 c2                	add    %eax,%edx
801061ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
801061f1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
801061f7:	89 42 08             	mov    %eax,0x8(%edx)
			table[curr_table_index].ppid = proc->parent ? proc->parent->pid : proc->pid;
801061fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
801061fd:	89 d0                	mov    %edx,%eax
801061ff:	01 c0                	add    %eax,%eax
80106201:	01 d0                	add    %edx,%eax
80106203:	c1 e0 05             	shl    $0x5,%eax
80106206:	89 c2                	mov    %eax,%edx
80106208:	8b 45 0c             	mov    0xc(%ebp),%eax
8010620b:	01 c2                	add    %eax,%edx
8010620d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106210:	8b 40 14             	mov    0x14(%eax),%eax
80106213:	85 c0                	test   %eax,%eax
80106215:	74 0b                	je     80106222 <get_active_procs+0x128>
80106217:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010621a:	8b 40 14             	mov    0x14(%eax),%eax
8010621d:	8b 40 10             	mov    0x10(%eax),%eax
80106220:	eb 06                	jmp    80106228 <get_active_procs+0x12e>
80106222:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106225:	8b 40 10             	mov    0x10(%eax),%eax
80106228:	89 42 0c             	mov    %eax,0xc(%edx)
			table[curr_table_index].elapsed_ticks = ticks - proc->start_ticks;
8010622b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010622e:	89 d0                	mov    %edx,%eax
80106230:	01 c0                	add    %eax,%eax
80106232:	01 d0                	add    %edx,%eax
80106234:	c1 e0 05             	shl    $0x5,%eax
80106237:	89 c2                	mov    %eax,%edx
80106239:	8b 45 0c             	mov    0xc(%ebp),%eax
8010623c:	01 c2                	add    %eax,%edx
8010623e:	8b 0d 80 74 11 80    	mov    0x80117480,%ecx
80106244:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106247:	8b 40 7c             	mov    0x7c(%eax),%eax
8010624a:	29 c1                	sub    %eax,%ecx
8010624c:	89 c8                	mov    %ecx,%eax
8010624e:	89 42 10             	mov    %eax,0x10(%edx)
			table[curr_table_index].cpu_total_ticks = proc->cpu_ticks_total;
80106251:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106254:	89 d0                	mov    %edx,%eax
80106256:	01 c0                	add    %eax,%eax
80106258:	01 d0                	add    %edx,%eax
8010625a:	c1 e0 05             	shl    $0x5,%eax
8010625d:	89 c2                	mov    %eax,%edx
8010625f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106262:	01 c2                	add    %eax,%edx
80106264:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106267:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010626d:	89 42 14             	mov    %eax,0x14(%edx)
			table[curr_table_index].size = proc->sz;
80106270:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106273:	89 d0                	mov    %edx,%eax
80106275:	01 c0                	add    %eax,%eax
80106277:	01 d0                	add    %edx,%eax
80106279:	c1 e0 05             	shl    $0x5,%eax
8010627c:	89 c2                	mov    %eax,%edx
8010627e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106281:	01 c2                	add    %eax,%edx
80106283:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106286:	8b 00                	mov    (%eax),%eax
80106288:	89 42 38             	mov    %eax,0x38(%edx)
			#ifdef CS333_P3P4
			table[curr_table_index].priority = proc->priority;
8010628b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010628e:	89 d0                	mov    %edx,%eax
80106290:	01 c0                	add    %eax,%eax
80106292:	01 d0                	add    %edx,%eax
80106294:	c1 e0 05             	shl    $0x5,%eax
80106297:	89 c2                	mov    %eax,%edx
80106299:	8b 45 0c             	mov    0xc(%ebp),%eax
8010629c:	01 c2                	add    %eax,%edx
8010629e:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062a1:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801062a7:	89 42 5c             	mov    %eax,0x5c(%edx)
			#endif

			// A very crumby way, but whatever.
			if(proc->state == RUNNABLE)
801062aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062ad:	8b 40 0c             	mov    0xc(%eax),%eax
801062b0:	83 f8 03             	cmp    $0x3,%eax
801062b3:	75 2b                	jne    801062e0 <get_active_procs+0x1e6>
				safestrcpy(table[curr_table_index].state, "RUNNABLE", STRMAX);
801062b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062b8:	89 d0                	mov    %edx,%eax
801062ba:	01 c0                	add    %eax,%eax
801062bc:	01 d0                	add    %edx,%eax
801062be:	c1 e0 05             	shl    $0x5,%eax
801062c1:	89 c2                	mov    %eax,%edx
801062c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801062c6:	01 d0                	add    %edx,%eax
801062c8:	83 c0 18             	add    $0x18,%eax
801062cb:	83 ec 04             	sub    $0x4,%esp
801062ce:	6a 20                	push   $0x20
801062d0:	68 76 a5 10 80       	push   $0x8010a576
801062d5:	50                   	push   %eax
801062d6:	e8 0f 0a 00 00       	call   80106cea <safestrcpy>
801062db:	83 c4 10             	add    $0x10,%esp
801062de:	eb 6a                	jmp    8010634a <get_active_procs+0x250>
			else if(proc->state == RUNNING)
801062e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801062e3:	8b 40 0c             	mov    0xc(%eax),%eax
801062e6:	83 f8 04             	cmp    $0x4,%eax
801062e9:	75 2b                	jne    80106316 <get_active_procs+0x21c>
				safestrcpy(table[curr_table_index].state, "RUNNING ", STRMAX);
801062eb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062ee:	89 d0                	mov    %edx,%eax
801062f0:	01 c0                	add    %eax,%eax
801062f2:	01 d0                	add    %edx,%eax
801062f4:	c1 e0 05             	shl    $0x5,%eax
801062f7:	89 c2                	mov    %eax,%edx
801062f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801062fc:	01 d0                	add    %edx,%eax
801062fe:	83 c0 18             	add    $0x18,%eax
80106301:	83 ec 04             	sub    $0x4,%esp
80106304:	6a 20                	push   $0x20
80106306:	68 7f a5 10 80       	push   $0x8010a57f
8010630b:	50                   	push   %eax
8010630c:	e8 d9 09 00 00       	call   80106cea <safestrcpy>
80106311:	83 c4 10             	add    $0x10,%esp
80106314:	eb 34                	jmp    8010634a <get_active_procs+0x250>
			else if(proc->state == SLEEPING)
80106316:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106319:	8b 40 0c             	mov    0xc(%eax),%eax
8010631c:	83 f8 02             	cmp    $0x2,%eax
8010631f:	75 29                	jne    8010634a <get_active_procs+0x250>
				safestrcpy(table[curr_table_index].state, "SLEEPING", STRMAX);
80106321:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106324:	89 d0                	mov    %edx,%eax
80106326:	01 c0                	add    %eax,%eax
80106328:	01 d0                	add    %edx,%eax
8010632a:	c1 e0 05             	shl    $0x5,%eax
8010632d:	89 c2                	mov    %eax,%edx
8010632f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106332:	01 d0                	add    %edx,%eax
80106334:	83 c0 18             	add    $0x18,%eax
80106337:	83 ec 04             	sub    $0x4,%esp
8010633a:	6a 20                	push   $0x20
8010633c:	68 88 a5 10 80       	push   $0x8010a588
80106341:	50                   	push   %eax
80106342:	e8 a3 09 00 00       	call   80106cea <safestrcpy>
80106347:	83 c4 10             	add    $0x10,%esp

			++curr_table_index;
8010634a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
			++ num_read_processes;
8010634e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)

	curr_proc = 0;
	curr_table_index = 0;
	num_read_processes = 0;

	for(; curr_proc < max; ++curr_proc)
80106352:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106359:	3b 45 08             	cmp    0x8(%ebp),%eax
8010635c:	0f 82 d8 fd ff ff    	jb     8010613a <get_active_procs+0x40>
			++curr_table_index;
			++ num_read_processes;
		}
	}

	release(&ptable.lock);
80106362:	83 ec 0c             	sub    $0xc,%esp
80106365:	68 20 45 11 80       	push   $0x80114520
8010636a:	e8 7c 05 00 00       	call   801068eb <release>
8010636f:	83 c4 10             	add    $0x10,%esp

	return num_read_processes;
80106372:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106375:	c9                   	leave  
80106376:	c3                   	ret    

80106377 <dosetpriority>:
#endif

#ifdef CS333_P3P4
int
dosetpriority(int pid, int priority)
{
80106377:	55                   	push   %ebp
80106378:	89 e5                	mov    %esp,%ebp
8010637a:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  acquire(&ptable.lock);
8010637d:	83 ec 0c             	sub    $0xc,%esp
80106380:	68 20 45 11 80       	push   $0x80114520
80106385:	e8 fa 04 00 00       	call   80106884 <acquire>
8010638a:	83 c4 10             	add    $0x10,%esp

  if(priority < 0 || priority > MAX_READY_QUEUES)
8010638d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106391:	78 06                	js     80106399 <dosetpriority+0x22>
80106393:	83 7d 0c 04          	cmpl   $0x4,0xc(%ebp)
80106397:	7e 1a                	jle    801063b3 <dosetpriority+0x3c>
  {
    release(&ptable.lock);
80106399:	83 ec 0c             	sub    $0xc,%esp
8010639c:	68 20 45 11 80       	push   $0x80114520
801063a1:	e8 45 05 00 00       	call   801068eb <release>
801063a6:	83 c4 10             	add    $0x10,%esp
    return -1;
801063a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ae:	e9 90 01 00 00       	jmp    80106543 <dosetpriority+0x1cc>
  }

  p = getproc(pid, ptable.pLists.running);
801063b3:	a1 74 6c 11 80       	mov    0x80116c74,%eax
801063b8:	83 ec 08             	sub    $0x8,%esp
801063bb:	50                   	push   %eax
801063bc:	ff 75 08             	pushl  0x8(%ebp)
801063bf:	e8 b1 01 00 00       	call   80106575 <getproc>
801063c4:	83 c4 10             	add    $0x10,%esp
801063c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(setprocpriority(p, priority))
801063ca:	83 ec 08             	sub    $0x8,%esp
801063cd:	ff 75 0c             	pushl  0xc(%ebp)
801063d0:	ff 75 f0             	pushl  -0x10(%ebp)
801063d3:	e8 6d 01 00 00       	call   80106545 <setprocpriority>
801063d8:	83 c4 10             	add    $0x10,%esp
801063db:	85 c0                	test   %eax,%eax
801063dd:	74 1a                	je     801063f9 <dosetpriority+0x82>
  {
    release(&ptable.lock);
801063df:	83 ec 0c             	sub    $0xc,%esp
801063e2:	68 20 45 11 80       	push   $0x80114520
801063e7:	e8 ff 04 00 00       	call   801068eb <release>
801063ec:	83 c4 10             	add    $0x10,%esp
    return 1;
801063ef:	b8 01 00 00 00       	mov    $0x1,%eax
801063f4:	e9 4a 01 00 00       	jmp    80106543 <dosetpriority+0x1cc>
  }

  p = getproc(pid, ptable.pLists.sleep);
801063f9:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
801063fe:	83 ec 08             	sub    $0x8,%esp
80106401:	50                   	push   %eax
80106402:	ff 75 08             	pushl  0x8(%ebp)
80106405:	e8 6b 01 00 00       	call   80106575 <getproc>
8010640a:	83 c4 10             	add    $0x10,%esp
8010640d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(setprocpriority(p, priority))
80106410:	83 ec 08             	sub    $0x8,%esp
80106413:	ff 75 0c             	pushl  0xc(%ebp)
80106416:	ff 75 f0             	pushl  -0x10(%ebp)
80106419:	e8 27 01 00 00       	call   80106545 <setprocpriority>
8010641e:	83 c4 10             	add    $0x10,%esp
80106421:	85 c0                	test   %eax,%eax
80106423:	74 1a                	je     8010643f <dosetpriority+0xc8>
  {
    release(&ptable.lock);
80106425:	83 ec 0c             	sub    $0xc,%esp
80106428:	68 20 45 11 80       	push   $0x80114520
8010642d:	e8 b9 04 00 00       	call   801068eb <release>
80106432:	83 c4 10             	add    $0x10,%esp
    return 1;
80106435:	b8 01 00 00 00       	mov    $0x1,%eax
8010643a:	e9 04 01 00 00       	jmp    80106543 <dosetpriority+0x1cc>
  }

  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
8010643f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106446:	e9 d9 00 00 00       	jmp    80106524 <dosetpriority+0x1ad>
  {
    p = getproc(pid, ptable.pLists.ready[i]);
8010644b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010644e:	05 cc 09 00 00       	add    $0x9cc,%eax
80106453:	8b 04 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%eax
8010645a:	83 ec 08             	sub    $0x8,%esp
8010645d:	50                   	push   %eax
8010645e:	ff 75 08             	pushl  0x8(%ebp)
80106461:	e8 0f 01 00 00       	call   80106575 <getproc>
80106466:	83 c4 10             	add    $0x10,%esp
80106469:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(p)
8010646c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106470:	0f 84 aa 00 00 00    	je     80106520 <dosetpriority+0x1a9>
    {
      // Don't want to change it if it's in the correct
      // list already.
      if(p->priority == priority)
80106476:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106479:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
8010647f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106482:	39 c2                	cmp    %eax,%edx
80106484:	75 1a                	jne    801064a0 <dosetpriority+0x129>
      {
        release(&ptable.lock);
80106486:	83 ec 0c             	sub    $0xc,%esp
80106489:	68 20 45 11 80       	push   $0x80114520
8010648e:	e8 58 04 00 00       	call   801068eb <release>
80106493:	83 c4 10             	add    $0x10,%esp
        return 1;
80106496:	b8 01 00 00 00       	mov    $0x1,%eax
8010649b:	e9 a3 00 00 00       	jmp    80106543 <dosetpriority+0x1cc>
      }

      plistremove(p, &ptable.pLists.ready[p->priority]);
801064a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064a3:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064a9:	05 cc 09 00 00       	add    $0x9cc,%eax
801064ae:	c1 e0 02             	shl    $0x2,%eax
801064b1:	05 20 45 11 80       	add    $0x80114520,%eax
801064b6:	83 c0 04             	add    $0x4,%eax
801064b9:	83 ec 08             	sub    $0x8,%esp
801064bc:	50                   	push   %eax
801064bd:	ff 75 f0             	pushl  -0x10(%ebp)
801064c0:	e8 45 e5 ff ff       	call   80104a0a <plistremove>
801064c5:	83 c4 10             	add    $0x10,%esp
      p->priority = priority;
801064c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801064cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064ce:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      p->budget = MAX_BUDGET;
801064d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064d7:	c7 80 98 00 00 00 b8 	movl   $0xbb8,0x98(%eax)
801064de:	0b 00 00 
      plistinsert(p, &ptable.pLists.ready[p->priority]);
801064e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064e4:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
801064ea:	05 cc 09 00 00       	add    $0x9cc,%eax
801064ef:	c1 e0 02             	shl    $0x2,%eax
801064f2:	05 20 45 11 80       	add    $0x80114520,%eax
801064f7:	83 c0 04             	add    $0x4,%eax
801064fa:	83 ec 08             	sub    $0x8,%esp
801064fd:	50                   	push   %eax
801064fe:	ff 75 f0             	pushl  -0x10(%ebp)
80106501:	e8 8b e4 ff ff       	call   80104991 <plistinsert>
80106506:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
80106509:	83 ec 0c             	sub    $0xc,%esp
8010650c:	68 20 45 11 80       	push   $0x80114520
80106511:	e8 d5 03 00 00       	call   801068eb <release>
80106516:	83 c4 10             	add    $0x10,%esp
      return 1;
80106519:	b8 01 00 00 00       	mov    $0x1,%eax
8010651e:	eb 23                	jmp    80106543 <dosetpriority+0x1cc>
    release(&ptable.lock);
    return 1;
  }

  int i;
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
80106520:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106524:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
80106528:	0f 8e 1d ff ff ff    	jle    8010644b <dosetpriority+0xd4>
      release(&ptable.lock);
      return 1;
    }
  }

  release(&ptable.lock);
8010652e:	83 ec 0c             	sub    $0xc,%esp
80106531:	68 20 45 11 80       	push   $0x80114520
80106536:	e8 b0 03 00 00       	call   801068eb <release>
8010653b:	83 c4 10             	add    $0x10,%esp
  return 0;
8010653e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106543:	c9                   	leave  
80106544:	c3                   	ret    

80106545 <setprocpriority>:

int 
setprocpriority(struct proc* proc, int priority)
{
80106545:	55                   	push   %ebp
80106546:	89 e5                	mov    %esp,%ebp
  if(proc)
80106548:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010654c:	74 20                	je     8010656e <setprocpriority+0x29>
  {
    proc->budget = MAX_BUDGET;
8010654e:	8b 45 08             	mov    0x8(%ebp),%eax
80106551:	c7 80 98 00 00 00 b8 	movl   $0xbb8,0x98(%eax)
80106558:	0b 00 00 
    proc->priority = priority;
8010655b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010655e:	8b 45 08             	mov    0x8(%ebp),%eax
80106561:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
    return 1;
80106567:	b8 01 00 00 00       	mov    $0x1,%eax
8010656c:	eb 05                	jmp    80106573 <setprocpriority+0x2e>
  }

  return 0;
8010656e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106573:	5d                   	pop    %ebp
80106574:	c3                   	ret    

80106575 <getproc>:

struct proc*
getproc(int pid, struct proc* list)
{
80106575:	55                   	push   %ebp
80106576:	89 e5                	mov    %esp,%ebp
80106578:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = list;
8010657b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010657e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  while(p)
80106581:	eb 19                	jmp    8010659c <getproc+0x27>
  {
    if(p->pid == pid)
80106583:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106586:	8b 50 10             	mov    0x10(%eax),%edx
80106589:	8b 45 08             	mov    0x8(%ebp),%eax
8010658c:	39 c2                	cmp    %eax,%edx
8010658e:	74 14                	je     801065a4 <getproc+0x2f>
      break;
    else
      p = p->next;
80106590:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106593:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106599:	89 45 fc             	mov    %eax,-0x4(%ebp)
struct proc*
getproc(int pid, struct proc* list)
{
  struct proc* p = list;

  while(p)
8010659c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801065a0:	75 e1                	jne    80106583 <getproc+0xe>
801065a2:	eb 01                	jmp    801065a5 <getproc+0x30>
  {
    if(p->pid == pid)
      break;
801065a4:	90                   	nop
    else
      p = p->next;
  }

  return p;
801065a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801065a8:	c9                   	leave  
801065a9:	c3                   	ret    

801065aa <printready>:

void
printready(void)
{
801065aa:	55                   	push   %ebp
801065ab:	89 e5                	mov    %esp,%ebp
801065ad:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i;

  cprintf("Ready Lists:\n");
801065b0:	83 ec 0c             	sub    $0xc,%esp
801065b3:	68 91 a5 10 80       	push   $0x8010a591
801065b8:	e8 09 9e ff ff       	call   801003c6 <cprintf>
801065bd:	83 c4 10             	add    $0x10,%esp

  acquire(&ptable.lock);
801065c0:	83 ec 0c             	sub    $0xc,%esp
801065c3:	68 20 45 11 80       	push   $0x80114520
801065c8:	e8 b7 02 00 00       	call   80106884 <acquire>
801065cd:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
801065d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801065d7:	e9 8b 00 00 00       	jmp    80106667 <printready+0xbd>
  {
    cprintf("%d: ", i);
801065dc:	83 ec 08             	sub    $0x8,%esp
801065df:	ff 75 f0             	pushl  -0x10(%ebp)
801065e2:	68 9f a5 10 80       	push   $0x8010a59f
801065e7:	e8 da 9d ff ff       	call   801003c6 <cprintf>
801065ec:	83 c4 10             	add    $0x10,%esp
	p = ptable.pLists.ready[i];
801065ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065f2:	05 cc 09 00 00       	add    $0x9cc,%eax
801065f7:	8b 04 85 24 45 11 80 	mov    -0x7feebadc(,%eax,4),%eax
801065fe:	89 45 f4             	mov    %eax,-0xc(%ebp)

	while(p)
80106601:	eb 4a                	jmp    8010664d <printready+0xa3>
	{
	  cprintf("(%d, %d)", p->pid, p->budget);
80106603:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106606:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
8010660c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010660f:	8b 40 10             	mov    0x10(%eax),%eax
80106612:	83 ec 04             	sub    $0x4,%esp
80106615:	52                   	push   %edx
80106616:	50                   	push   %eax
80106617:	68 a4 a5 10 80       	push   $0x8010a5a4
8010661c:	e8 a5 9d ff ff       	call   801003c6 <cprintf>
80106621:	83 c4 10             	add    $0x10,%esp

	  if(p->next)
80106624:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106627:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010662d:	85 c0                	test   %eax,%eax
8010662f:	74 10                	je     80106641 <printready+0x97>
		cprintf("->");
80106631:	83 ec 0c             	sub    $0xc,%esp
80106634:	68 ad a5 10 80       	push   $0x8010a5ad
80106639:	e8 88 9d ff ff       	call   801003c6 <cprintf>
8010663e:	83 c4 10             	add    $0x10,%esp

	  p = p->next;
80106641:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106644:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010664a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
  {
    cprintf("%d: ", i);
	p = ptable.pLists.ready[i];

	while(p)
8010664d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106651:	75 b0                	jne    80106603 <printready+0x59>
		cprintf("->");

	  p = p->next;
	}

	cprintf("\n");
80106653:	83 ec 0c             	sub    $0xc,%esp
80106656:	68 4c a5 10 80       	push   $0x8010a54c
8010665b:	e8 66 9d ff ff       	call   801003c6 <cprintf>
80106660:	83 c4 10             	add    $0x10,%esp
  int i;

  cprintf("Ready Lists:\n");

  acquire(&ptable.lock);
  for(i = 0; i < MAX_READY_QUEUES + 1; ++i)
80106663:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80106667:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010666b:	0f 8e 6b ff ff ff    	jle    801065dc <printready+0x32>
	}

	cprintf("\n");
  }

  release(&ptable.lock);
80106671:	83 ec 0c             	sub    $0xc,%esp
80106674:	68 20 45 11 80       	push   $0x80114520
80106679:	e8 6d 02 00 00       	call   801068eb <release>
8010667e:	83 c4 10             	add    $0x10,%esp
  cprintf("------------------\n");
80106681:	83 ec 0c             	sub    $0xc,%esp
80106684:	68 b0 a5 10 80       	push   $0x8010a5b0
80106689:	e8 38 9d ff ff       	call   801003c6 <cprintf>
8010668e:	83 c4 10             	add    $0x10,%esp
}
80106691:	90                   	nop
80106692:	c9                   	leave  
80106693:	c3                   	ret    

80106694 <printnumfree>:

void
printnumfree(void)
{
80106694:	55                   	push   %ebp
80106695:	89 e5                	mov    %esp,%ebp
80106697:	83 ec 18             	sub    $0x18,%esp
  int num_free = 0;
8010669a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc* p;

  acquire(&ptable.lock);
801066a1:	83 ec 0c             	sub    $0xc,%esp
801066a4:	68 20 45 11 80       	push   $0x80114520
801066a9:	e8 d6 01 00 00       	call   80106884 <acquire>
801066ae:	83 c4 10             	add    $0x10,%esp

  p = ptable.pLists.free;
801066b1:	a1 68 6c 11 80       	mov    0x80116c68,%eax
801066b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(p)
801066b9:	eb 10                	jmp    801066cb <printnumfree+0x37>
  {
    ++num_free;
801066bb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    p = p->next;
801066bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066c2:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801066c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct proc* p;

  acquire(&ptable.lock);

  p = ptable.pLists.free;
  while(p)
801066cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066cf:	75 ea                	jne    801066bb <printnumfree+0x27>
  {
    ++num_free;
    p = p->next;
  }

  release(&ptable.lock);
801066d1:	83 ec 0c             	sub    $0xc,%esp
801066d4:	68 20 45 11 80       	push   $0x80114520
801066d9:	e8 0d 02 00 00       	call   801068eb <release>
801066de:	83 c4 10             	add    $0x10,%esp

  cprintf("Free list size: %d processes\n", num_free);
801066e1:	83 ec 08             	sub    $0x8,%esp
801066e4:	ff 75 f4             	pushl  -0xc(%ebp)
801066e7:	68 c4 a5 10 80       	push   $0x8010a5c4
801066ec:	e8 d5 9c ff ff       	call   801003c6 <cprintf>
801066f1:	83 c4 10             	add    $0x10,%esp
}
801066f4:	90                   	nop
801066f5:	c9                   	leave  
801066f6:	c3                   	ret    

801066f7 <printsleep>:

void
printsleep(void)
{
801066f7:	55                   	push   %ebp
801066f8:	89 e5                	mov    %esp,%ebp
801066fa:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  acquire(&ptable.lock);
801066fd:	83 ec 0c             	sub    $0xc,%esp
80106700:	68 20 45 11 80       	push   $0x80114520
80106705:	e8 7a 01 00 00       	call   80106884 <acquire>
8010670a:	83 c4 10             	add    $0x10,%esp

  p = ptable.pLists.sleep;
8010670d:	a1 6c 6c 11 80       	mov    0x80116c6c,%eax
80106712:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(p)
80106715:	eb 40                	jmp    80106757 <printsleep+0x60>
  {
    cprintf("%d", p->pid);
80106717:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010671a:	8b 40 10             	mov    0x10(%eax),%eax
8010671d:	83 ec 08             	sub    $0x8,%esp
80106720:	50                   	push   %eax
80106721:	68 e2 a5 10 80       	push   $0x8010a5e2
80106726:	e8 9b 9c ff ff       	call   801003c6 <cprintf>
8010672b:	83 c4 10             	add    $0x10,%esp

    if(p->next)
8010672e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106731:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106737:	85 c0                	test   %eax,%eax
80106739:	74 10                	je     8010674b <printsleep+0x54>
      cprintf("->");
8010673b:	83 ec 0c             	sub    $0xc,%esp
8010673e:	68 ad a5 10 80       	push   $0x8010a5ad
80106743:	e8 7e 9c ff ff       	call   801003c6 <cprintf>
80106748:	83 c4 10             	add    $0x10,%esp

    p = p->next;
8010674b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010674e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106754:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc* p;

  acquire(&ptable.lock);

  p = ptable.pLists.sleep;
  while(p)
80106757:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010675b:	75 ba                	jne    80106717 <printsleep+0x20>
      cprintf("->");

    p = p->next;
  }

  cprintf("\n");
8010675d:	83 ec 0c             	sub    $0xc,%esp
80106760:	68 4c a5 10 80       	push   $0x8010a54c
80106765:	e8 5c 9c ff ff       	call   801003c6 <cprintf>
8010676a:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
8010676d:	83 ec 0c             	sub    $0xc,%esp
80106770:	68 20 45 11 80       	push   $0x80114520
80106775:	e8 71 01 00 00       	call   801068eb <release>
8010677a:	83 c4 10             	add    $0x10,%esp
}
8010677d:	90                   	nop
8010677e:	c9                   	leave  
8010677f:	c3                   	ret    

80106780 <printzombie>:

void
printzombie(void)
{
80106780:	55                   	push   %ebp
80106781:	89 e5                	mov    %esp,%ebp
80106783:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  uint parent;

  acquire(&ptable.lock);
80106786:	83 ec 0c             	sub    $0xc,%esp
80106789:	68 20 45 11 80       	push   $0x80114520
8010678e:	e8 f1 00 00 00       	call   80106884 <acquire>
80106793:	83 c4 10             	add    $0x10,%esp

  p = ptable.pLists.zombie;
80106796:	a1 70 6c 11 80       	mov    0x80116c70,%eax
8010679b:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while(p)
8010679e:	eb 61                	jmp    80106801 <printzombie+0x81>
  {
    parent = p->parent ? p->parent->pid : p->pid;
801067a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a3:	8b 40 14             	mov    0x14(%eax),%eax
801067a6:	85 c0                	test   %eax,%eax
801067a8:	74 0b                	je     801067b5 <printzombie+0x35>
801067aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ad:	8b 40 14             	mov    0x14(%eax),%eax
801067b0:	8b 40 10             	mov    0x10(%eax),%eax
801067b3:	eb 06                	jmp    801067bb <printzombie+0x3b>
801067b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067b8:	8b 40 10             	mov    0x10(%eax),%eax
801067bb:	89 45 f0             	mov    %eax,-0x10(%ebp)

    cprintf("(%d,%d)", p->pid, parent);
801067be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c1:	8b 40 10             	mov    0x10(%eax),%eax
801067c4:	83 ec 04             	sub    $0x4,%esp
801067c7:	ff 75 f0             	pushl  -0x10(%ebp)
801067ca:	50                   	push   %eax
801067cb:	68 e5 a5 10 80       	push   $0x8010a5e5
801067d0:	e8 f1 9b ff ff       	call   801003c6 <cprintf>
801067d5:	83 c4 10             	add    $0x10,%esp

    if(p->next)
801067d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067db:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801067e1:	85 c0                	test   %eax,%eax
801067e3:	74 10                	je     801067f5 <printzombie+0x75>
      cprintf("->");
801067e5:	83 ec 0c             	sub    $0xc,%esp
801067e8:	68 ad a5 10 80       	push   $0x8010a5ad
801067ed:	e8 d4 9b ff ff       	call   801003c6 <cprintf>
801067f2:	83 c4 10             	add    $0x10,%esp

    p = p->next;
801067f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067f8:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801067fe:	89 45 f4             	mov    %eax,-0xc(%ebp)

  acquire(&ptable.lock);

  p = ptable.pLists.zombie;

  while(p)
80106801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106805:	75 99                	jne    801067a0 <printzombie+0x20>
      cprintf("->");

    p = p->next;
  }

  cprintf("\n");
80106807:	83 ec 0c             	sub    $0xc,%esp
8010680a:	68 4c a5 10 80       	push   $0x8010a54c
8010680f:	e8 b2 9b ff ff       	call   801003c6 <cprintf>
80106814:	83 c4 10             	add    $0x10,%esp

  release(&ptable.lock);
80106817:	83 ec 0c             	sub    $0xc,%esp
8010681a:	68 20 45 11 80       	push   $0x80114520
8010681f:	e8 c7 00 00 00       	call   801068eb <release>
80106824:	83 c4 10             	add    $0x10,%esp
}
80106827:	90                   	nop
80106828:	c9                   	leave  
80106829:	c3                   	ret    

8010682a <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
8010682a:	55                   	push   %ebp
8010682b:	89 e5                	mov    %esp,%ebp
8010682d:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80106830:	9c                   	pushf  
80106831:	58                   	pop    %eax
80106832:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80106835:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106838:	c9                   	leave  
80106839:	c3                   	ret    

8010683a <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
8010683a:	55                   	push   %ebp
8010683b:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
8010683d:	fa                   	cli    
}
8010683e:	90                   	nop
8010683f:	5d                   	pop    %ebp
80106840:	c3                   	ret    

80106841 <sti>:

static inline void
sti(void)
{
80106841:	55                   	push   %ebp
80106842:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80106844:	fb                   	sti    
}
80106845:	90                   	nop
80106846:	5d                   	pop    %ebp
80106847:	c3                   	ret    

80106848 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80106848:	55                   	push   %ebp
80106849:	89 e5                	mov    %esp,%ebp
8010684b:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010684e:	8b 55 08             	mov    0x8(%ebp),%edx
80106851:	8b 45 0c             	mov    0xc(%ebp),%eax
80106854:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106857:	f0 87 02             	lock xchg %eax,(%edx)
8010685a:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010685d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106860:	c9                   	leave  
80106861:	c3                   	ret    

80106862 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80106862:	55                   	push   %ebp
80106863:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80106865:	8b 45 08             	mov    0x8(%ebp),%eax
80106868:	8b 55 0c             	mov    0xc(%ebp),%edx
8010686b:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
8010686e:	8b 45 08             	mov    0x8(%ebp),%eax
80106871:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80106877:	8b 45 08             	mov    0x8(%ebp),%eax
8010687a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80106881:	90                   	nop
80106882:	5d                   	pop    %ebp
80106883:	c3                   	ret    

80106884 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80106884:	55                   	push   %ebp
80106885:	89 e5                	mov    %esp,%ebp
80106887:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
8010688a:	e8 52 01 00 00       	call   801069e1 <pushcli>
  if(holding(lk))
8010688f:	8b 45 08             	mov    0x8(%ebp),%eax
80106892:	83 ec 0c             	sub    $0xc,%esp
80106895:	50                   	push   %eax
80106896:	e8 1c 01 00 00       	call   801069b7 <holding>
8010689b:	83 c4 10             	add    $0x10,%esp
8010689e:	85 c0                	test   %eax,%eax
801068a0:	74 0d                	je     801068af <acquire+0x2b>
    panic("acquire");
801068a2:	83 ec 0c             	sub    $0xc,%esp
801068a5:	68 ed a5 10 80       	push   $0x8010a5ed
801068aa:	e8 b7 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801068af:	90                   	nop
801068b0:	8b 45 08             	mov    0x8(%ebp),%eax
801068b3:	83 ec 08             	sub    $0x8,%esp
801068b6:	6a 01                	push   $0x1
801068b8:	50                   	push   %eax
801068b9:	e8 8a ff ff ff       	call   80106848 <xchg>
801068be:	83 c4 10             	add    $0x10,%esp
801068c1:	85 c0                	test   %eax,%eax
801068c3:	75 eb                	jne    801068b0 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
801068c5:	8b 45 08             	mov    0x8(%ebp),%eax
801068c8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801068cf:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
801068d2:	8b 45 08             	mov    0x8(%ebp),%eax
801068d5:	83 c0 0c             	add    $0xc,%eax
801068d8:	83 ec 08             	sub    $0x8,%esp
801068db:	50                   	push   %eax
801068dc:	8d 45 08             	lea    0x8(%ebp),%eax
801068df:	50                   	push   %eax
801068e0:	e8 58 00 00 00       	call   8010693d <getcallerpcs>
801068e5:	83 c4 10             	add    $0x10,%esp
}
801068e8:	90                   	nop
801068e9:	c9                   	leave  
801068ea:	c3                   	ret    

801068eb <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801068eb:	55                   	push   %ebp
801068ec:	89 e5                	mov    %esp,%ebp
801068ee:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
801068f1:	83 ec 0c             	sub    $0xc,%esp
801068f4:	ff 75 08             	pushl  0x8(%ebp)
801068f7:	e8 bb 00 00 00       	call   801069b7 <holding>
801068fc:	83 c4 10             	add    $0x10,%esp
801068ff:	85 c0                	test   %eax,%eax
80106901:	75 0d                	jne    80106910 <release+0x25>
    panic("release");
80106903:	83 ec 0c             	sub    $0xc,%esp
80106906:	68 f5 a5 10 80       	push   $0x8010a5f5
8010690b:	e8 56 9c ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
80106910:	8b 45 08             	mov    0x8(%ebp),%eax
80106913:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010691a:	8b 45 08             	mov    0x8(%ebp),%eax
8010691d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106924:	8b 45 08             	mov    0x8(%ebp),%eax
80106927:	83 ec 08             	sub    $0x8,%esp
8010692a:	6a 00                	push   $0x0
8010692c:	50                   	push   %eax
8010692d:	e8 16 ff ff ff       	call   80106848 <xchg>
80106932:	83 c4 10             	add    $0x10,%esp

  popcli();
80106935:	e8 ec 00 00 00       	call   80106a26 <popcli>
}
8010693a:	90                   	nop
8010693b:	c9                   	leave  
8010693c:	c3                   	ret    

8010693d <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010693d:	55                   	push   %ebp
8010693e:	89 e5                	mov    %esp,%ebp
80106940:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80106943:	8b 45 08             	mov    0x8(%ebp),%eax
80106946:	83 e8 08             	sub    $0x8,%eax
80106949:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010694c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80106953:	eb 38                	jmp    8010698d <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80106955:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106959:	74 53                	je     801069ae <getcallerpcs+0x71>
8010695b:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80106962:	76 4a                	jbe    801069ae <getcallerpcs+0x71>
80106964:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80106968:	74 44                	je     801069ae <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010696a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010696d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106974:	8b 45 0c             	mov    0xc(%ebp),%eax
80106977:	01 c2                	add    %eax,%edx
80106979:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010697c:	8b 40 04             	mov    0x4(%eax),%eax
8010697f:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80106981:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106984:	8b 00                	mov    (%eax),%eax
80106986:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80106989:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010698d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106991:	7e c2                	jle    80106955 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106993:	eb 19                	jmp    801069ae <getcallerpcs+0x71>
    pcs[i] = 0;
80106995:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106998:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010699f:	8b 45 0c             	mov    0xc(%ebp),%eax
801069a2:	01 d0                	add    %edx,%eax
801069a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069aa:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069ae:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069b2:	7e e1                	jle    80106995 <getcallerpcs+0x58>
    pcs[i] = 0;
}
801069b4:	90                   	nop
801069b5:	c9                   	leave  
801069b6:	c3                   	ret    

801069b7 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801069b7:	55                   	push   %ebp
801069b8:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801069ba:	8b 45 08             	mov    0x8(%ebp),%eax
801069bd:	8b 00                	mov    (%eax),%eax
801069bf:	85 c0                	test   %eax,%eax
801069c1:	74 17                	je     801069da <holding+0x23>
801069c3:	8b 45 08             	mov    0x8(%ebp),%eax
801069c6:	8b 50 08             	mov    0x8(%eax),%edx
801069c9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801069cf:	39 c2                	cmp    %eax,%edx
801069d1:	75 07                	jne    801069da <holding+0x23>
801069d3:	b8 01 00 00 00       	mov    $0x1,%eax
801069d8:	eb 05                	jmp    801069df <holding+0x28>
801069da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801069df:	5d                   	pop    %ebp
801069e0:	c3                   	ret    

801069e1 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801069e1:	55                   	push   %ebp
801069e2:	89 e5                	mov    %esp,%ebp
801069e4:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801069e7:	e8 3e fe ff ff       	call   8010682a <readeflags>
801069ec:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801069ef:	e8 46 fe ff ff       	call   8010683a <cli>
  if(cpu->ncli++ == 0)
801069f4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801069fb:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106a01:	8d 48 01             	lea    0x1(%eax),%ecx
80106a04:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106a0a:	85 c0                	test   %eax,%eax
80106a0c:	75 15                	jne    80106a23 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106a0e:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a14:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a17:	81 e2 00 02 00 00    	and    $0x200,%edx
80106a1d:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106a23:	90                   	nop
80106a24:	c9                   	leave  
80106a25:	c3                   	ret    

80106a26 <popcli>:

void
popcli(void)
{
80106a26:	55                   	push   %ebp
80106a27:	89 e5                	mov    %esp,%ebp
80106a29:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106a2c:	e8 f9 fd ff ff       	call   8010682a <readeflags>
80106a31:	25 00 02 00 00       	and    $0x200,%eax
80106a36:	85 c0                	test   %eax,%eax
80106a38:	74 0d                	je     80106a47 <popcli+0x21>
    panic("popcli - interruptible");
80106a3a:	83 ec 0c             	sub    $0xc,%esp
80106a3d:	68 fd a5 10 80       	push   $0x8010a5fd
80106a42:	e8 1f 9b ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106a47:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a4d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106a53:	83 ea 01             	sub    $0x1,%edx
80106a56:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106a5c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a62:	85 c0                	test   %eax,%eax
80106a64:	79 0d                	jns    80106a73 <popcli+0x4d>
    panic("popcli");
80106a66:	83 ec 0c             	sub    $0xc,%esp
80106a69:	68 14 a6 10 80       	push   $0x8010a614
80106a6e:	e8 f3 9a ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106a73:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a79:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106a7f:	85 c0                	test   %eax,%eax
80106a81:	75 15                	jne    80106a98 <popcli+0x72>
80106a83:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a89:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106a8f:	85 c0                	test   %eax,%eax
80106a91:	74 05                	je     80106a98 <popcli+0x72>
    sti();
80106a93:	e8 a9 fd ff ff       	call   80106841 <sti>
}
80106a98:	90                   	nop
80106a99:	c9                   	leave  
80106a9a:	c3                   	ret    

80106a9b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106a9b:	55                   	push   %ebp
80106a9c:	89 e5                	mov    %esp,%ebp
80106a9e:	57                   	push   %edi
80106a9f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106aa0:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106aa3:	8b 55 10             	mov    0x10(%ebp),%edx
80106aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aa9:	89 cb                	mov    %ecx,%ebx
80106aab:	89 df                	mov    %ebx,%edi
80106aad:	89 d1                	mov    %edx,%ecx
80106aaf:	fc                   	cld    
80106ab0:	f3 aa                	rep stos %al,%es:(%edi)
80106ab2:	89 ca                	mov    %ecx,%edx
80106ab4:	89 fb                	mov    %edi,%ebx
80106ab6:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106ab9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106abc:	90                   	nop
80106abd:	5b                   	pop    %ebx
80106abe:	5f                   	pop    %edi
80106abf:	5d                   	pop    %ebp
80106ac0:	c3                   	ret    

80106ac1 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106ac1:	55                   	push   %ebp
80106ac2:	89 e5                	mov    %esp,%ebp
80106ac4:	57                   	push   %edi
80106ac5:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106ac6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106ac9:	8b 55 10             	mov    0x10(%ebp),%edx
80106acc:	8b 45 0c             	mov    0xc(%ebp),%eax
80106acf:	89 cb                	mov    %ecx,%ebx
80106ad1:	89 df                	mov    %ebx,%edi
80106ad3:	89 d1                	mov    %edx,%ecx
80106ad5:	fc                   	cld    
80106ad6:	f3 ab                	rep stos %eax,%es:(%edi)
80106ad8:	89 ca                	mov    %ecx,%edx
80106ada:	89 fb                	mov    %edi,%ebx
80106adc:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106adf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106ae2:	90                   	nop
80106ae3:	5b                   	pop    %ebx
80106ae4:	5f                   	pop    %edi
80106ae5:	5d                   	pop    %ebp
80106ae6:	c3                   	ret    

80106ae7 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106ae7:	55                   	push   %ebp
80106ae8:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106aea:	8b 45 08             	mov    0x8(%ebp),%eax
80106aed:	83 e0 03             	and    $0x3,%eax
80106af0:	85 c0                	test   %eax,%eax
80106af2:	75 43                	jne    80106b37 <memset+0x50>
80106af4:	8b 45 10             	mov    0x10(%ebp),%eax
80106af7:	83 e0 03             	and    $0x3,%eax
80106afa:	85 c0                	test   %eax,%eax
80106afc:	75 39                	jne    80106b37 <memset+0x50>
    c &= 0xFF;
80106afe:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106b05:	8b 45 10             	mov    0x10(%ebp),%eax
80106b08:	c1 e8 02             	shr    $0x2,%eax
80106b0b:	89 c1                	mov    %eax,%ecx
80106b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b10:	c1 e0 18             	shl    $0x18,%eax
80106b13:	89 c2                	mov    %eax,%edx
80106b15:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b18:	c1 e0 10             	shl    $0x10,%eax
80106b1b:	09 c2                	or     %eax,%edx
80106b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b20:	c1 e0 08             	shl    $0x8,%eax
80106b23:	09 d0                	or     %edx,%eax
80106b25:	0b 45 0c             	or     0xc(%ebp),%eax
80106b28:	51                   	push   %ecx
80106b29:	50                   	push   %eax
80106b2a:	ff 75 08             	pushl  0x8(%ebp)
80106b2d:	e8 8f ff ff ff       	call   80106ac1 <stosl>
80106b32:	83 c4 0c             	add    $0xc,%esp
80106b35:	eb 12                	jmp    80106b49 <memset+0x62>
  } else
    stosb(dst, c, n);
80106b37:	8b 45 10             	mov    0x10(%ebp),%eax
80106b3a:	50                   	push   %eax
80106b3b:	ff 75 0c             	pushl  0xc(%ebp)
80106b3e:	ff 75 08             	pushl  0x8(%ebp)
80106b41:	e8 55 ff ff ff       	call   80106a9b <stosb>
80106b46:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106b49:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106b4c:	c9                   	leave  
80106b4d:	c3                   	ret    

80106b4e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106b4e:	55                   	push   %ebp
80106b4f:	89 e5                	mov    %esp,%ebp
80106b51:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106b54:	8b 45 08             	mov    0x8(%ebp),%eax
80106b57:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106b5a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b5d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106b60:	eb 30                	jmp    80106b92 <memcmp+0x44>
    if(*s1 != *s2)
80106b62:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b65:	0f b6 10             	movzbl (%eax),%edx
80106b68:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b6b:	0f b6 00             	movzbl (%eax),%eax
80106b6e:	38 c2                	cmp    %al,%dl
80106b70:	74 18                	je     80106b8a <memcmp+0x3c>
      return *s1 - *s2;
80106b72:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106b75:	0f b6 00             	movzbl (%eax),%eax
80106b78:	0f b6 d0             	movzbl %al,%edx
80106b7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106b7e:	0f b6 00             	movzbl (%eax),%eax
80106b81:	0f b6 c0             	movzbl %al,%eax
80106b84:	29 c2                	sub    %eax,%edx
80106b86:	89 d0                	mov    %edx,%eax
80106b88:	eb 1a                	jmp    80106ba4 <memcmp+0x56>
    s1++, s2++;
80106b8a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106b8e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106b92:	8b 45 10             	mov    0x10(%ebp),%eax
80106b95:	8d 50 ff             	lea    -0x1(%eax),%edx
80106b98:	89 55 10             	mov    %edx,0x10(%ebp)
80106b9b:	85 c0                	test   %eax,%eax
80106b9d:	75 c3                	jne    80106b62 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106b9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106ba4:	c9                   	leave  
80106ba5:	c3                   	ret    

80106ba6 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106ba6:	55                   	push   %ebp
80106ba7:	89 e5                	mov    %esp,%ebp
80106ba9:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106bac:	8b 45 0c             	mov    0xc(%ebp),%eax
80106baf:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106bb2:	8b 45 08             	mov    0x8(%ebp),%eax
80106bb5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bbb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106bbe:	73 54                	jae    80106c14 <memmove+0x6e>
80106bc0:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106bc3:	8b 45 10             	mov    0x10(%ebp),%eax
80106bc6:	01 d0                	add    %edx,%eax
80106bc8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106bcb:	76 47                	jbe    80106c14 <memmove+0x6e>
    s += n;
80106bcd:	8b 45 10             	mov    0x10(%ebp),%eax
80106bd0:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106bd3:	8b 45 10             	mov    0x10(%ebp),%eax
80106bd6:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106bd9:	eb 13                	jmp    80106bee <memmove+0x48>
      *--d = *--s;
80106bdb:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106bdf:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106be6:	0f b6 10             	movzbl (%eax),%edx
80106be9:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bec:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106bee:	8b 45 10             	mov    0x10(%ebp),%eax
80106bf1:	8d 50 ff             	lea    -0x1(%eax),%edx
80106bf4:	89 55 10             	mov    %edx,0x10(%ebp)
80106bf7:	85 c0                	test   %eax,%eax
80106bf9:	75 e0                	jne    80106bdb <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106bfb:	eb 24                	jmp    80106c21 <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106bfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c00:	8d 50 01             	lea    0x1(%eax),%edx
80106c03:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106c06:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c09:	8d 4a 01             	lea    0x1(%edx),%ecx
80106c0c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106c0f:	0f b6 12             	movzbl (%edx),%edx
80106c12:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106c14:	8b 45 10             	mov    0x10(%ebp),%eax
80106c17:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c1a:	89 55 10             	mov    %edx,0x10(%ebp)
80106c1d:	85 c0                	test   %eax,%eax
80106c1f:	75 dc                	jne    80106bfd <memmove+0x57>
      *d++ = *s++;

  return dst;
80106c21:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106c24:	c9                   	leave  
80106c25:	c3                   	ret    

80106c26 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106c26:	55                   	push   %ebp
80106c27:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106c29:	ff 75 10             	pushl  0x10(%ebp)
80106c2c:	ff 75 0c             	pushl  0xc(%ebp)
80106c2f:	ff 75 08             	pushl  0x8(%ebp)
80106c32:	e8 6f ff ff ff       	call   80106ba6 <memmove>
80106c37:	83 c4 0c             	add    $0xc,%esp
}
80106c3a:	c9                   	leave  
80106c3b:	c3                   	ret    

80106c3c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c3c:	55                   	push   %ebp
80106c3d:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c3f:	eb 0c                	jmp    80106c4d <strncmp+0x11>
    n--, p++, q++;
80106c41:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106c45:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106c49:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106c4d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c51:	74 1a                	je     80106c6d <strncmp+0x31>
80106c53:	8b 45 08             	mov    0x8(%ebp),%eax
80106c56:	0f b6 00             	movzbl (%eax),%eax
80106c59:	84 c0                	test   %al,%al
80106c5b:	74 10                	je     80106c6d <strncmp+0x31>
80106c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c60:	0f b6 10             	movzbl (%eax),%edx
80106c63:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c66:	0f b6 00             	movzbl (%eax),%eax
80106c69:	38 c2                	cmp    %al,%dl
80106c6b:	74 d4                	je     80106c41 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106c6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106c71:	75 07                	jne    80106c7a <strncmp+0x3e>
    return 0;
80106c73:	b8 00 00 00 00       	mov    $0x0,%eax
80106c78:	eb 16                	jmp    80106c90 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106c7a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c7d:	0f b6 00             	movzbl (%eax),%eax
80106c80:	0f b6 d0             	movzbl %al,%edx
80106c83:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c86:	0f b6 00             	movzbl (%eax),%eax
80106c89:	0f b6 c0             	movzbl %al,%eax
80106c8c:	29 c2                	sub    %eax,%edx
80106c8e:	89 d0                	mov    %edx,%eax
}
80106c90:	5d                   	pop    %ebp
80106c91:	c3                   	ret    

80106c92 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106c92:	55                   	push   %ebp
80106c93:	89 e5                	mov    %esp,%ebp
80106c95:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106c98:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106c9e:	90                   	nop
80106c9f:	8b 45 10             	mov    0x10(%ebp),%eax
80106ca2:	8d 50 ff             	lea    -0x1(%eax),%edx
80106ca5:	89 55 10             	mov    %edx,0x10(%ebp)
80106ca8:	85 c0                	test   %eax,%eax
80106caa:	7e 2c                	jle    80106cd8 <strncpy+0x46>
80106cac:	8b 45 08             	mov    0x8(%ebp),%eax
80106caf:	8d 50 01             	lea    0x1(%eax),%edx
80106cb2:	89 55 08             	mov    %edx,0x8(%ebp)
80106cb5:	8b 55 0c             	mov    0xc(%ebp),%edx
80106cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
80106cbb:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106cbe:	0f b6 12             	movzbl (%edx),%edx
80106cc1:	88 10                	mov    %dl,(%eax)
80106cc3:	0f b6 00             	movzbl (%eax),%eax
80106cc6:	84 c0                	test   %al,%al
80106cc8:	75 d5                	jne    80106c9f <strncpy+0xd>
    ;
  while(n-- > 0)
80106cca:	eb 0c                	jmp    80106cd8 <strncpy+0x46>
    *s++ = 0;
80106ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ccf:	8d 50 01             	lea    0x1(%eax),%edx
80106cd2:	89 55 08             	mov    %edx,0x8(%ebp)
80106cd5:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106cd8:	8b 45 10             	mov    0x10(%ebp),%eax
80106cdb:	8d 50 ff             	lea    -0x1(%eax),%edx
80106cde:	89 55 10             	mov    %edx,0x10(%ebp)
80106ce1:	85 c0                	test   %eax,%eax
80106ce3:	7f e7                	jg     80106ccc <strncpy+0x3a>
    *s++ = 0;
  return os;
80106ce5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106ce8:	c9                   	leave  
80106ce9:	c3                   	ret    

80106cea <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106cea:	55                   	push   %ebp
80106ceb:	89 e5                	mov    %esp,%ebp
80106ced:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106cf0:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106cf6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cfa:	7f 05                	jg     80106d01 <safestrcpy+0x17>
    return os;
80106cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106cff:	eb 31                	jmp    80106d32 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106d01:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106d05:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d09:	7e 1e                	jle    80106d29 <safestrcpy+0x3f>
80106d0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0e:	8d 50 01             	lea    0x1(%eax),%edx
80106d11:	89 55 08             	mov    %edx,0x8(%ebp)
80106d14:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d17:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d1a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d1d:	0f b6 12             	movzbl (%edx),%edx
80106d20:	88 10                	mov    %dl,(%eax)
80106d22:	0f b6 00             	movzbl (%eax),%eax
80106d25:	84 c0                	test   %al,%al
80106d27:	75 d8                	jne    80106d01 <safestrcpy+0x17>
    ;
  *s = 0;
80106d29:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2c:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d32:	c9                   	leave  
80106d33:	c3                   	ret    

80106d34 <strlen>:

int
strlen(const char *s)
{
80106d34:	55                   	push   %ebp
80106d35:	89 e5                	mov    %esp,%ebp
80106d37:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d3a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d41:	eb 04                	jmp    80106d47 <strlen+0x13>
80106d43:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106d47:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106d4a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4d:	01 d0                	add    %edx,%eax
80106d4f:	0f b6 00             	movzbl (%eax),%eax
80106d52:	84 c0                	test   %al,%al
80106d54:	75 ed                	jne    80106d43 <strlen+0xf>
    ;
  return n;
80106d56:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d59:	c9                   	leave  
80106d5a:	c3                   	ret    

80106d5b <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106d5b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106d5f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106d63:	55                   	push   %ebp
  pushl %ebx
80106d64:	53                   	push   %ebx
  pushl %esi
80106d65:	56                   	push   %esi
  pushl %edi
80106d66:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106d67:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106d69:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106d6b:	5f                   	pop    %edi
  popl %esi
80106d6c:	5e                   	pop    %esi
  popl %ebx
80106d6d:	5b                   	pop    %ebx
  popl %ebp
80106d6e:	5d                   	pop    %ebp
  ret
80106d6f:	c3                   	ret    

80106d70 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106d70:	55                   	push   %ebp
80106d71:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106d73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d79:	8b 00                	mov    (%eax),%eax
80106d7b:	3b 45 08             	cmp    0x8(%ebp),%eax
80106d7e:	76 12                	jbe    80106d92 <fetchint+0x22>
80106d80:	8b 45 08             	mov    0x8(%ebp),%eax
80106d83:	8d 50 04             	lea    0x4(%eax),%edx
80106d86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106d8c:	8b 00                	mov    (%eax),%eax
80106d8e:	39 c2                	cmp    %eax,%edx
80106d90:	76 07                	jbe    80106d99 <fetchint+0x29>
    return -1;
80106d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d97:	eb 0f                	jmp    80106da8 <fetchint+0x38>
  *ip = *(int*)(addr);
80106d99:	8b 45 08             	mov    0x8(%ebp),%eax
80106d9c:	8b 10                	mov    (%eax),%edx
80106d9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106da1:	89 10                	mov    %edx,(%eax)
  return 0;
80106da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106da8:	5d                   	pop    %ebp
80106da9:	c3                   	ret    

80106daa <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106daa:	55                   	push   %ebp
80106dab:	89 e5                	mov    %esp,%ebp
80106dad:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106db0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106db6:	8b 00                	mov    (%eax),%eax
80106db8:	3b 45 08             	cmp    0x8(%ebp),%eax
80106dbb:	77 07                	ja     80106dc4 <fetchstr+0x1a>
    return -1;
80106dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106dc2:	eb 46                	jmp    80106e0a <fetchstr+0x60>
  *pp = (char*)addr;
80106dc4:	8b 55 08             	mov    0x8(%ebp),%edx
80106dc7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dca:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106dcc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dd2:	8b 00                	mov    (%eax),%eax
80106dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106dd7:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dda:	8b 00                	mov    (%eax),%eax
80106ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106ddf:	eb 1c                	jmp    80106dfd <fetchstr+0x53>
    if(*s == 0)
80106de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106de4:	0f b6 00             	movzbl (%eax),%eax
80106de7:	84 c0                	test   %al,%al
80106de9:	75 0e                	jne    80106df9 <fetchstr+0x4f>
      return s - *pp;
80106deb:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106dee:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df1:	8b 00                	mov    (%eax),%eax
80106df3:	29 c2                	sub    %eax,%edx
80106df5:	89 d0                	mov    %edx,%eax
80106df7:	eb 11                	jmp    80106e0a <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106df9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106e03:	72 dc                	jb     80106de1 <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106e05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e0a:	c9                   	leave  
80106e0b:	c3                   	ret    

80106e0c <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106e0c:	55                   	push   %ebp
80106e0d:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106e0f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e15:	8b 40 18             	mov    0x18(%eax),%eax
80106e18:	8b 40 44             	mov    0x44(%eax),%eax
80106e1b:	8b 55 08             	mov    0x8(%ebp),%edx
80106e1e:	c1 e2 02             	shl    $0x2,%edx
80106e21:	01 d0                	add    %edx,%eax
80106e23:	83 c0 04             	add    $0x4,%eax
80106e26:	ff 75 0c             	pushl  0xc(%ebp)
80106e29:	50                   	push   %eax
80106e2a:	e8 41 ff ff ff       	call   80106d70 <fetchint>
80106e2f:	83 c4 08             	add    $0x8,%esp
}
80106e32:	c9                   	leave  
80106e33:	c3                   	ret    

80106e34 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106e34:	55                   	push   %ebp
80106e35:	89 e5                	mov    %esp,%ebp
80106e37:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106e3a:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e3d:	50                   	push   %eax
80106e3e:	ff 75 08             	pushl  0x8(%ebp)
80106e41:	e8 c6 ff ff ff       	call   80106e0c <argint>
80106e46:	83 c4 08             	add    $0x8,%esp
80106e49:	85 c0                	test   %eax,%eax
80106e4b:	79 07                	jns    80106e54 <argptr+0x20>
    return -1;
80106e4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e52:	eb 3b                	jmp    80106e8f <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106e54:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e5a:	8b 00                	mov    (%eax),%eax
80106e5c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e5f:	39 d0                	cmp    %edx,%eax
80106e61:	76 16                	jbe    80106e79 <argptr+0x45>
80106e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e66:	89 c2                	mov    %eax,%edx
80106e68:	8b 45 10             	mov    0x10(%ebp),%eax
80106e6b:	01 c2                	add    %eax,%edx
80106e6d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e73:	8b 00                	mov    (%eax),%eax
80106e75:	39 c2                	cmp    %eax,%edx
80106e77:	76 07                	jbe    80106e80 <argptr+0x4c>
    return -1;
80106e79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e7e:	eb 0f                	jmp    80106e8f <argptr+0x5b>
  *pp = (char*)i;
80106e80:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e83:	89 c2                	mov    %eax,%edx
80106e85:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e88:	89 10                	mov    %edx,(%eax)
  return 0;
80106e8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e8f:	c9                   	leave  
80106e90:	c3                   	ret    

80106e91 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106e91:	55                   	push   %ebp
80106e92:	89 e5                	mov    %esp,%ebp
80106e94:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106e97:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e9a:	50                   	push   %eax
80106e9b:	ff 75 08             	pushl  0x8(%ebp)
80106e9e:	e8 69 ff ff ff       	call   80106e0c <argint>
80106ea3:	83 c4 08             	add    $0x8,%esp
80106ea6:	85 c0                	test   %eax,%eax
80106ea8:	79 07                	jns    80106eb1 <argstr+0x20>
    return -1;
80106eaa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eaf:	eb 0f                	jmp    80106ec0 <argstr+0x2f>
  return fetchstr(addr, pp);
80106eb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106eb4:	ff 75 0c             	pushl  0xc(%ebp)
80106eb7:	50                   	push   %eax
80106eb8:	e8 ed fe ff ff       	call   80106daa <fetchstr>
80106ebd:	83 c4 08             	add    $0x8,%esp
}
80106ec0:	c9                   	leave  
80106ec1:	c3                   	ret    

80106ec2 <syscall>:
};
#endif

void
syscall(void)
{
80106ec2:	55                   	push   %ebp
80106ec3:	89 e5                	mov    %esp,%ebp
80106ec5:	53                   	push   %ebx
80106ec6:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106ec9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ecf:	8b 40 18             	mov    0x18(%eax),%eax
80106ed2:	8b 40 1c             	mov    0x1c(%eax),%eax
80106ed5:	89 45 f4             	mov    %eax,-0xc(%ebp)


  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106ed8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106edc:	7e 30                	jle    80106f0e <syscall+0x4c>
80106ede:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee1:	83 f8 21             	cmp    $0x21,%eax
80106ee4:	77 28                	ja     80106f0e <syscall+0x4c>
80106ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee9:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106ef0:	85 c0                	test   %eax,%eax
80106ef2:	74 1a                	je     80106f0e <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106ef4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106efa:	8b 58 18             	mov    0x18(%eax),%ebx
80106efd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f00:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f07:	ff d0                	call   *%eax
80106f09:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106f0c:	eb 34                	jmp    80106f42 <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106f0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f14:	8d 50 6c             	lea    0x6c(%eax),%edx
80106f17:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106f1d:	8b 40 10             	mov    0x10(%eax),%eax
80106f20:	ff 75 f4             	pushl  -0xc(%ebp)
80106f23:	52                   	push   %edx
80106f24:	50                   	push   %eax
80106f25:	68 1b a6 10 80       	push   $0x8010a61b
80106f2a:	e8 97 94 ff ff       	call   801003c6 <cprintf>
80106f2f:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106f32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f38:	8b 40 18             	mov    0x18(%eax),%eax
80106f3b:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106f42:	90                   	nop
80106f43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106f46:	c9                   	leave  
80106f47:	c3                   	ret    

80106f48 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106f48:	55                   	push   %ebp
80106f49:	89 e5                	mov    %esp,%ebp
80106f4b:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106f4e:	83 ec 08             	sub    $0x8,%esp
80106f51:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106f54:	50                   	push   %eax
80106f55:	ff 75 08             	pushl  0x8(%ebp)
80106f58:	e8 af fe ff ff       	call   80106e0c <argint>
80106f5d:	83 c4 10             	add    $0x10,%esp
80106f60:	85 c0                	test   %eax,%eax
80106f62:	79 07                	jns    80106f6b <argfd+0x23>
    return -1;
80106f64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f69:	eb 50                	jmp    80106fbb <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f6e:	85 c0                	test   %eax,%eax
80106f70:	78 21                	js     80106f93 <argfd+0x4b>
80106f72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106f75:	83 f8 0f             	cmp    $0xf,%eax
80106f78:	7f 19                	jg     80106f93 <argfd+0x4b>
80106f7a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f80:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106f83:	83 c2 08             	add    $0x8,%edx
80106f86:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106f8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106f8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f91:	75 07                	jne    80106f9a <argfd+0x52>
    return -1;
80106f93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f98:	eb 21                	jmp    80106fbb <argfd+0x73>
  if(pfd)
80106f9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106f9e:	74 08                	je     80106fa8 <argfd+0x60>
    *pfd = fd;
80106fa0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fa6:	89 10                	mov    %edx,(%eax)
  if(pf)
80106fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106fac:	74 08                	je     80106fb6 <argfd+0x6e>
    *pf = f;
80106fae:	8b 45 10             	mov    0x10(%ebp),%eax
80106fb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106fb4:	89 10                	mov    %edx,(%eax)
  return 0;
80106fb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106fbb:	c9                   	leave  
80106fbc:	c3                   	ret    

80106fbd <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80106fbd:	55                   	push   %ebp
80106fbe:	89 e5                	mov    %esp,%ebp
80106fc0:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106fc3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106fca:	eb 30                	jmp    80106ffc <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80106fcc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd2:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106fd5:	83 c2 08             	add    $0x8,%edx
80106fd8:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106fdc:	85 c0                	test   %eax,%eax
80106fde:	75 18                	jne    80106ff8 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80106fe0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fe6:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106fe9:	8d 4a 08             	lea    0x8(%edx),%ecx
80106fec:	8b 55 08             	mov    0x8(%ebp),%edx
80106fef:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80106ff3:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ff6:	eb 0f                	jmp    80107007 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80106ff8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106ffc:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80107000:	7e ca                	jle    80106fcc <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80107002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107007:	c9                   	leave  
80107008:	c3                   	ret    

80107009 <sys_dup>:

int
sys_dup(void)
{
80107009:	55                   	push   %ebp
8010700a:	89 e5                	mov    %esp,%ebp
8010700c:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010700f:	83 ec 04             	sub    $0x4,%esp
80107012:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107015:	50                   	push   %eax
80107016:	6a 00                	push   $0x0
80107018:	6a 00                	push   $0x0
8010701a:	e8 29 ff ff ff       	call   80106f48 <argfd>
8010701f:	83 c4 10             	add    $0x10,%esp
80107022:	85 c0                	test   %eax,%eax
80107024:	79 07                	jns    8010702d <sys_dup+0x24>
    return -1;
80107026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010702b:	eb 31                	jmp    8010705e <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010702d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	50                   	push   %eax
80107034:	e8 84 ff ff ff       	call   80106fbd <fdalloc>
80107039:	83 c4 10             	add    $0x10,%esp
8010703c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010703f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107043:	79 07                	jns    8010704c <sys_dup+0x43>
    return -1;
80107045:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010704a:	eb 12                	jmp    8010705e <sys_dup+0x55>
  filedup(f);
8010704c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010704f:	83 ec 0c             	sub    $0xc,%esp
80107052:	50                   	push   %eax
80107053:	e8 49 a1 ff ff       	call   801011a1 <filedup>
80107058:	83 c4 10             	add    $0x10,%esp
  return fd;
8010705b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010705e:	c9                   	leave  
8010705f:	c3                   	ret    

80107060 <sys_read>:

int
sys_read(void)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80107066:	83 ec 04             	sub    $0x4,%esp
80107069:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010706c:	50                   	push   %eax
8010706d:	6a 00                	push   $0x0
8010706f:	6a 00                	push   $0x0
80107071:	e8 d2 fe ff ff       	call   80106f48 <argfd>
80107076:	83 c4 10             	add    $0x10,%esp
80107079:	85 c0                	test   %eax,%eax
8010707b:	78 2e                	js     801070ab <sys_read+0x4b>
8010707d:	83 ec 08             	sub    $0x8,%esp
80107080:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107083:	50                   	push   %eax
80107084:	6a 02                	push   $0x2
80107086:	e8 81 fd ff ff       	call   80106e0c <argint>
8010708b:	83 c4 10             	add    $0x10,%esp
8010708e:	85 c0                	test   %eax,%eax
80107090:	78 19                	js     801070ab <sys_read+0x4b>
80107092:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107095:	83 ec 04             	sub    $0x4,%esp
80107098:	50                   	push   %eax
80107099:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010709c:	50                   	push   %eax
8010709d:	6a 01                	push   $0x1
8010709f:	e8 90 fd ff ff       	call   80106e34 <argptr>
801070a4:	83 c4 10             	add    $0x10,%esp
801070a7:	85 c0                	test   %eax,%eax
801070a9:	79 07                	jns    801070b2 <sys_read+0x52>
    return -1;
801070ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070b0:	eb 17                	jmp    801070c9 <sys_read+0x69>
  return fileread(f, p, n);
801070b2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801070b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801070b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801070bb:	83 ec 04             	sub    $0x4,%esp
801070be:	51                   	push   %ecx
801070bf:	52                   	push   %edx
801070c0:	50                   	push   %eax
801070c1:	e8 6b a2 ff ff       	call   80101331 <fileread>
801070c6:	83 c4 10             	add    $0x10,%esp
}
801070c9:	c9                   	leave  
801070ca:	c3                   	ret    

801070cb <sys_write>:

int
sys_write(void)
{
801070cb:	55                   	push   %ebp
801070cc:	89 e5                	mov    %esp,%ebp
801070ce:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801070d1:	83 ec 04             	sub    $0x4,%esp
801070d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070d7:	50                   	push   %eax
801070d8:	6a 00                	push   $0x0
801070da:	6a 00                	push   $0x0
801070dc:	e8 67 fe ff ff       	call   80106f48 <argfd>
801070e1:	83 c4 10             	add    $0x10,%esp
801070e4:	85 c0                	test   %eax,%eax
801070e6:	78 2e                	js     80107116 <sys_write+0x4b>
801070e8:	83 ec 08             	sub    $0x8,%esp
801070eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070ee:	50                   	push   %eax
801070ef:	6a 02                	push   $0x2
801070f1:	e8 16 fd ff ff       	call   80106e0c <argint>
801070f6:	83 c4 10             	add    $0x10,%esp
801070f9:	85 c0                	test   %eax,%eax
801070fb:	78 19                	js     80107116 <sys_write+0x4b>
801070fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107100:	83 ec 04             	sub    $0x4,%esp
80107103:	50                   	push   %eax
80107104:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107107:	50                   	push   %eax
80107108:	6a 01                	push   $0x1
8010710a:	e8 25 fd ff ff       	call   80106e34 <argptr>
8010710f:	83 c4 10             	add    $0x10,%esp
80107112:	85 c0                	test   %eax,%eax
80107114:	79 07                	jns    8010711d <sys_write+0x52>
    return -1;
80107116:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010711b:	eb 17                	jmp    80107134 <sys_write+0x69>
  return filewrite(f, p, n);
8010711d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107120:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107123:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107126:	83 ec 04             	sub    $0x4,%esp
80107129:	51                   	push   %ecx
8010712a:	52                   	push   %edx
8010712b:	50                   	push   %eax
8010712c:	e8 b8 a2 ff ff       	call   801013e9 <filewrite>
80107131:	83 c4 10             	add    $0x10,%esp
}
80107134:	c9                   	leave  
80107135:	c3                   	ret    

80107136 <sys_close>:

int
sys_close(void)
{
80107136:	55                   	push   %ebp
80107137:	89 e5                	mov    %esp,%ebp
80107139:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
8010713c:	83 ec 04             	sub    $0x4,%esp
8010713f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107142:	50                   	push   %eax
80107143:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107146:	50                   	push   %eax
80107147:	6a 00                	push   $0x0
80107149:	e8 fa fd ff ff       	call   80106f48 <argfd>
8010714e:	83 c4 10             	add    $0x10,%esp
80107151:	85 c0                	test   %eax,%eax
80107153:	79 07                	jns    8010715c <sys_close+0x26>
    return -1;
80107155:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010715a:	eb 28                	jmp    80107184 <sys_close+0x4e>
  proc->ofile[fd] = 0;
8010715c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107162:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107165:	83 c2 08             	add    $0x8,%edx
80107168:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010716f:	00 
  fileclose(f);
80107170:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107173:	83 ec 0c             	sub    $0xc,%esp
80107176:	50                   	push   %eax
80107177:	e8 76 a0 ff ff       	call   801011f2 <fileclose>
8010717c:	83 c4 10             	add    $0x10,%esp
  return 0;
8010717f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107184:	c9                   	leave  
80107185:	c3                   	ret    

80107186 <sys_fstat>:

int
sys_fstat(void)
{
80107186:	55                   	push   %ebp
80107187:	89 e5                	mov    %esp,%ebp
80107189:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010718c:	83 ec 04             	sub    $0x4,%esp
8010718f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107192:	50                   	push   %eax
80107193:	6a 00                	push   $0x0
80107195:	6a 00                	push   $0x0
80107197:	e8 ac fd ff ff       	call   80106f48 <argfd>
8010719c:	83 c4 10             	add    $0x10,%esp
8010719f:	85 c0                	test   %eax,%eax
801071a1:	78 17                	js     801071ba <sys_fstat+0x34>
801071a3:	83 ec 04             	sub    $0x4,%esp
801071a6:	6a 1c                	push   $0x1c
801071a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801071ab:	50                   	push   %eax
801071ac:	6a 01                	push   $0x1
801071ae:	e8 81 fc ff ff       	call   80106e34 <argptr>
801071b3:	83 c4 10             	add    $0x10,%esp
801071b6:	85 c0                	test   %eax,%eax
801071b8:	79 07                	jns    801071c1 <sys_fstat+0x3b>
    return -1;
801071ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071bf:	eb 13                	jmp    801071d4 <sys_fstat+0x4e>
  return filestat(f, st);
801071c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
801071c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801071c7:	83 ec 08             	sub    $0x8,%esp
801071ca:	52                   	push   %edx
801071cb:	50                   	push   %eax
801071cc:	e8 09 a1 ff ff       	call   801012da <filestat>
801071d1:	83 c4 10             	add    $0x10,%esp
}
801071d4:	c9                   	leave  
801071d5:	c3                   	ret    

801071d6 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
801071d6:	55                   	push   %ebp
801071d7:	89 e5                	mov    %esp,%ebp
801071d9:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801071dc:	83 ec 08             	sub    $0x8,%esp
801071df:	8d 45 d8             	lea    -0x28(%ebp),%eax
801071e2:	50                   	push   %eax
801071e3:	6a 00                	push   $0x0
801071e5:	e8 a7 fc ff ff       	call   80106e91 <argstr>
801071ea:	83 c4 10             	add    $0x10,%esp
801071ed:	85 c0                	test   %eax,%eax
801071ef:	78 15                	js     80107206 <sys_link+0x30>
801071f1:	83 ec 08             	sub    $0x8,%esp
801071f4:	8d 45 dc             	lea    -0x24(%ebp),%eax
801071f7:	50                   	push   %eax
801071f8:	6a 01                	push   $0x1
801071fa:	e8 92 fc ff ff       	call   80106e91 <argstr>
801071ff:	83 c4 10             	add    $0x10,%esp
80107202:	85 c0                	test   %eax,%eax
80107204:	79 0a                	jns    80107210 <sys_link+0x3a>
    return -1;
80107206:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010720b:	e9 68 01 00 00       	jmp    80107378 <sys_link+0x1a2>

  begin_op();
80107210:	e8 6d c8 ff ff       	call   80103a82 <begin_op>
  if((ip = namei(old)) == 0){
80107215:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107218:	83 ec 0c             	sub    $0xc,%esp
8010721b:	50                   	push   %eax
8010721c:	e8 3c b5 ff ff       	call   8010275d <namei>
80107221:	83 c4 10             	add    $0x10,%esp
80107224:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107227:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010722b:	75 0f                	jne    8010723c <sys_link+0x66>
    end_op();
8010722d:	e8 dc c8 ff ff       	call   80103b0e <end_op>
    return -1;
80107232:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107237:	e9 3c 01 00 00       	jmp    80107378 <sys_link+0x1a2>
  }

  ilock(ip);
8010723c:	83 ec 0c             	sub    $0xc,%esp
8010723f:	ff 75 f4             	pushl  -0xc(%ebp)
80107242:	e8 08 a9 ff ff       	call   80101b4f <ilock>
80107247:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
8010724a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010724d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107251:	66 83 f8 01          	cmp    $0x1,%ax
80107255:	75 1d                	jne    80107274 <sys_link+0x9e>
    iunlockput(ip);
80107257:	83 ec 0c             	sub    $0xc,%esp
8010725a:	ff 75 f4             	pushl  -0xc(%ebp)
8010725d:	e8 d5 ab ff ff       	call   80101e37 <iunlockput>
80107262:	83 c4 10             	add    $0x10,%esp
    end_op();
80107265:	e8 a4 c8 ff ff       	call   80103b0e <end_op>
    return -1;
8010726a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010726f:	e9 04 01 00 00       	jmp    80107378 <sys_link+0x1a2>
  }

  ip->nlink++;
80107274:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107277:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010727b:	83 c0 01             	add    $0x1,%eax
8010727e:	89 c2                	mov    %eax,%edx
80107280:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107283:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107287:	83 ec 0c             	sub    $0xc,%esp
8010728a:	ff 75 f4             	pushl  -0xc(%ebp)
8010728d:	e8 bb a6 ff ff       	call   8010194d <iupdate>
80107292:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80107295:	83 ec 0c             	sub    $0xc,%esp
80107298:	ff 75 f4             	pushl  -0xc(%ebp)
8010729b:	e8 35 aa ff ff       	call   80101cd5 <iunlock>
801072a0:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801072a3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801072a6:	83 ec 08             	sub    $0x8,%esp
801072a9:	8d 55 e2             	lea    -0x1e(%ebp),%edx
801072ac:	52                   	push   %edx
801072ad:	50                   	push   %eax
801072ae:	e8 c6 b4 ff ff       	call   80102779 <nameiparent>
801072b3:	83 c4 10             	add    $0x10,%esp
801072b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
801072b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801072bd:	74 71                	je     80107330 <sys_link+0x15a>
    goto bad;
  ilock(dp);
801072bf:	83 ec 0c             	sub    $0xc,%esp
801072c2:	ff 75 f0             	pushl  -0x10(%ebp)
801072c5:	e8 85 a8 ff ff       	call   80101b4f <ilock>
801072ca:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801072cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801072d0:	8b 10                	mov    (%eax),%edx
801072d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d5:	8b 00                	mov    (%eax),%eax
801072d7:	39 c2                	cmp    %eax,%edx
801072d9:	75 1d                	jne    801072f8 <sys_link+0x122>
801072db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072de:	8b 40 04             	mov    0x4(%eax),%eax
801072e1:	83 ec 04             	sub    $0x4,%esp
801072e4:	50                   	push   %eax
801072e5:	8d 45 e2             	lea    -0x1e(%ebp),%eax
801072e8:	50                   	push   %eax
801072e9:	ff 75 f0             	pushl  -0x10(%ebp)
801072ec:	e8 d0 b1 ff ff       	call   801024c1 <dirlink>
801072f1:	83 c4 10             	add    $0x10,%esp
801072f4:	85 c0                	test   %eax,%eax
801072f6:	79 10                	jns    80107308 <sys_link+0x132>
    iunlockput(dp);
801072f8:	83 ec 0c             	sub    $0xc,%esp
801072fb:	ff 75 f0             	pushl  -0x10(%ebp)
801072fe:	e8 34 ab ff ff       	call   80101e37 <iunlockput>
80107303:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107306:	eb 29                	jmp    80107331 <sys_link+0x15b>
  }
  iunlockput(dp);
80107308:	83 ec 0c             	sub    $0xc,%esp
8010730b:	ff 75 f0             	pushl  -0x10(%ebp)
8010730e:	e8 24 ab ff ff       	call   80101e37 <iunlockput>
80107313:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80107316:	83 ec 0c             	sub    $0xc,%esp
80107319:	ff 75 f4             	pushl  -0xc(%ebp)
8010731c:	e8 26 aa ff ff       	call   80101d47 <iput>
80107321:	83 c4 10             	add    $0x10,%esp

  end_op();
80107324:	e8 e5 c7 ff ff       	call   80103b0e <end_op>

  return 0;
80107329:	b8 00 00 00 00       	mov    $0x0,%eax
8010732e:	eb 48                	jmp    80107378 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80107330:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
80107331:	83 ec 0c             	sub    $0xc,%esp
80107334:	ff 75 f4             	pushl  -0xc(%ebp)
80107337:	e8 13 a8 ff ff       	call   80101b4f <ilock>
8010733c:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010733f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107342:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107346:	83 e8 01             	sub    $0x1,%eax
80107349:	89 c2                	mov    %eax,%edx
8010734b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010734e:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80107352:	83 ec 0c             	sub    $0xc,%esp
80107355:	ff 75 f4             	pushl  -0xc(%ebp)
80107358:	e8 f0 a5 ff ff       	call   8010194d <iupdate>
8010735d:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80107360:	83 ec 0c             	sub    $0xc,%esp
80107363:	ff 75 f4             	pushl  -0xc(%ebp)
80107366:	e8 cc aa ff ff       	call   80101e37 <iunlockput>
8010736b:	83 c4 10             	add    $0x10,%esp
  end_op();
8010736e:	e8 9b c7 ff ff       	call   80103b0e <end_op>
  return -1;
80107373:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107378:	c9                   	leave  
80107379:	c3                   	ret    

8010737a <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
8010737a:	55                   	push   %ebp
8010737b:	89 e5                	mov    %esp,%ebp
8010737d:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80107380:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80107387:	eb 40                	jmp    801073c9 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010738c:	6a 10                	push   $0x10
8010738e:	50                   	push   %eax
8010738f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107392:	50                   	push   %eax
80107393:	ff 75 08             	pushl  0x8(%ebp)
80107396:	e8 72 ad ff ff       	call   8010210d <readi>
8010739b:	83 c4 10             	add    $0x10,%esp
8010739e:	83 f8 10             	cmp    $0x10,%eax
801073a1:	74 0d                	je     801073b0 <isdirempty+0x36>
      panic("isdirempty: readi");
801073a3:	83 ec 0c             	sub    $0xc,%esp
801073a6:	68 37 a6 10 80       	push   $0x8010a637
801073ab:	e8 b6 91 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
801073b0:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801073b4:	66 85 c0             	test   %ax,%ax
801073b7:	74 07                	je     801073c0 <isdirempty+0x46>
      return 0;
801073b9:	b8 00 00 00 00       	mov    $0x0,%eax
801073be:	eb 1b                	jmp    801073db <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801073c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073c3:	83 c0 10             	add    $0x10,%eax
801073c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
801073c9:	8b 45 08             	mov    0x8(%ebp),%eax
801073cc:	8b 50 20             	mov    0x20(%eax),%edx
801073cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073d2:	39 c2                	cmp    %eax,%edx
801073d4:	77 b3                	ja     80107389 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
801073d6:	b8 01 00 00 00       	mov    $0x1,%eax
}
801073db:	c9                   	leave  
801073dc:	c3                   	ret    

801073dd <sys_unlink>:

int
sys_unlink(void)
{
801073dd:	55                   	push   %ebp
801073de:	89 e5                	mov    %esp,%ebp
801073e0:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801073e3:	83 ec 08             	sub    $0x8,%esp
801073e6:	8d 45 cc             	lea    -0x34(%ebp),%eax
801073e9:	50                   	push   %eax
801073ea:	6a 00                	push   $0x0
801073ec:	e8 a0 fa ff ff       	call   80106e91 <argstr>
801073f1:	83 c4 10             	add    $0x10,%esp
801073f4:	85 c0                	test   %eax,%eax
801073f6:	79 0a                	jns    80107402 <sys_unlink+0x25>
    return -1;
801073f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801073fd:	e9 bc 01 00 00       	jmp    801075be <sys_unlink+0x1e1>

  begin_op();
80107402:	e8 7b c6 ff ff       	call   80103a82 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80107407:	8b 45 cc             	mov    -0x34(%ebp),%eax
8010740a:	83 ec 08             	sub    $0x8,%esp
8010740d:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80107410:	52                   	push   %edx
80107411:	50                   	push   %eax
80107412:	e8 62 b3 ff ff       	call   80102779 <nameiparent>
80107417:	83 c4 10             	add    $0x10,%esp
8010741a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010741d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107421:	75 0f                	jne    80107432 <sys_unlink+0x55>
    end_op();
80107423:	e8 e6 c6 ff ff       	call   80103b0e <end_op>
    return -1;
80107428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010742d:	e9 8c 01 00 00       	jmp    801075be <sys_unlink+0x1e1>
  }

  ilock(dp);
80107432:	83 ec 0c             	sub    $0xc,%esp
80107435:	ff 75 f4             	pushl  -0xc(%ebp)
80107438:	e8 12 a7 ff ff       	call   80101b4f <ilock>
8010743d:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80107440:	83 ec 08             	sub    $0x8,%esp
80107443:	68 49 a6 10 80       	push   $0x8010a649
80107448:	8d 45 d2             	lea    -0x2e(%ebp),%eax
8010744b:	50                   	push   %eax
8010744c:	e8 9b af ff ff       	call   801023ec <namecmp>
80107451:	83 c4 10             	add    $0x10,%esp
80107454:	85 c0                	test   %eax,%eax
80107456:	0f 84 4a 01 00 00    	je     801075a6 <sys_unlink+0x1c9>
8010745c:	83 ec 08             	sub    $0x8,%esp
8010745f:	68 4b a6 10 80       	push   $0x8010a64b
80107464:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107467:	50                   	push   %eax
80107468:	e8 7f af ff ff       	call   801023ec <namecmp>
8010746d:	83 c4 10             	add    $0x10,%esp
80107470:	85 c0                	test   %eax,%eax
80107472:	0f 84 2e 01 00 00    	je     801075a6 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80107478:	83 ec 04             	sub    $0x4,%esp
8010747b:	8d 45 c8             	lea    -0x38(%ebp),%eax
8010747e:	50                   	push   %eax
8010747f:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80107482:	50                   	push   %eax
80107483:	ff 75 f4             	pushl  -0xc(%ebp)
80107486:	e8 7c af ff ff       	call   80102407 <dirlookup>
8010748b:	83 c4 10             	add    $0x10,%esp
8010748e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107491:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107495:	0f 84 0a 01 00 00    	je     801075a5 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
8010749b:	83 ec 0c             	sub    $0xc,%esp
8010749e:	ff 75 f0             	pushl  -0x10(%ebp)
801074a1:	e8 a9 a6 ff ff       	call   80101b4f <ilock>
801074a6:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
801074a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074ac:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801074b0:	66 85 c0             	test   %ax,%ax
801074b3:	7f 0d                	jg     801074c2 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
801074b5:	83 ec 0c             	sub    $0xc,%esp
801074b8:	68 4e a6 10 80       	push   $0x8010a64e
801074bd:	e8 a4 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
801074c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801074c5:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801074c9:	66 83 f8 01          	cmp    $0x1,%ax
801074cd:	75 25                	jne    801074f4 <sys_unlink+0x117>
801074cf:	83 ec 0c             	sub    $0xc,%esp
801074d2:	ff 75 f0             	pushl  -0x10(%ebp)
801074d5:	e8 a0 fe ff ff       	call   8010737a <isdirempty>
801074da:	83 c4 10             	add    $0x10,%esp
801074dd:	85 c0                	test   %eax,%eax
801074df:	75 13                	jne    801074f4 <sys_unlink+0x117>
    iunlockput(ip);
801074e1:	83 ec 0c             	sub    $0xc,%esp
801074e4:	ff 75 f0             	pushl  -0x10(%ebp)
801074e7:	e8 4b a9 ff ff       	call   80101e37 <iunlockput>
801074ec:	83 c4 10             	add    $0x10,%esp
    goto bad;
801074ef:	e9 b2 00 00 00       	jmp    801075a6 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
801074f4:	83 ec 04             	sub    $0x4,%esp
801074f7:	6a 10                	push   $0x10
801074f9:	6a 00                	push   $0x0
801074fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801074fe:	50                   	push   %eax
801074ff:	e8 e3 f5 ff ff       	call   80106ae7 <memset>
80107504:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107507:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010750a:	6a 10                	push   $0x10
8010750c:	50                   	push   %eax
8010750d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80107510:	50                   	push   %eax
80107511:	ff 75 f4             	pushl  -0xc(%ebp)
80107514:	e8 4b ad ff ff       	call   80102264 <writei>
80107519:	83 c4 10             	add    $0x10,%esp
8010751c:	83 f8 10             	cmp    $0x10,%eax
8010751f:	74 0d                	je     8010752e <sys_unlink+0x151>
    panic("unlink: writei");
80107521:	83 ec 0c             	sub    $0xc,%esp
80107524:	68 60 a6 10 80       	push   $0x8010a660
80107529:	e8 38 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
8010752e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107531:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107535:	66 83 f8 01          	cmp    $0x1,%ax
80107539:	75 21                	jne    8010755c <sys_unlink+0x17f>
    dp->nlink--;
8010753b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010753e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107542:	83 e8 01             	sub    $0x1,%eax
80107545:	89 c2                	mov    %eax,%edx
80107547:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010754a:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010754e:	83 ec 0c             	sub    $0xc,%esp
80107551:	ff 75 f4             	pushl  -0xc(%ebp)
80107554:	e8 f4 a3 ff ff       	call   8010194d <iupdate>
80107559:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
8010755c:	83 ec 0c             	sub    $0xc,%esp
8010755f:	ff 75 f4             	pushl  -0xc(%ebp)
80107562:	e8 d0 a8 ff ff       	call   80101e37 <iunlockput>
80107567:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
8010756a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010756d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80107571:	83 e8 01             	sub    $0x1,%eax
80107574:	89 c2                	mov    %eax,%edx
80107576:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107579:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010757d:	83 ec 0c             	sub    $0xc,%esp
80107580:	ff 75 f0             	pushl  -0x10(%ebp)
80107583:	e8 c5 a3 ff ff       	call   8010194d <iupdate>
80107588:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
8010758b:	83 ec 0c             	sub    $0xc,%esp
8010758e:	ff 75 f0             	pushl  -0x10(%ebp)
80107591:	e8 a1 a8 ff ff       	call   80101e37 <iunlockput>
80107596:	83 c4 10             	add    $0x10,%esp

  end_op();
80107599:	e8 70 c5 ff ff       	call   80103b0e <end_op>

  return 0;
8010759e:	b8 00 00 00 00       	mov    $0x0,%eax
801075a3:	eb 19                	jmp    801075be <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
801075a5:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
801075a6:	83 ec 0c             	sub    $0xc,%esp
801075a9:	ff 75 f4             	pushl  -0xc(%ebp)
801075ac:	e8 86 a8 ff ff       	call   80101e37 <iunlockput>
801075b1:	83 c4 10             	add    $0x10,%esp
  end_op();
801075b4:	e8 55 c5 ff ff       	call   80103b0e <end_op>
  return -1;
801075b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801075be:	c9                   	leave  
801075bf:	c3                   	ret    

801075c0 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 38             	sub    $0x38,%esp
801075c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801075c9:	8b 55 10             	mov    0x10(%ebp),%edx
801075cc:	8b 45 14             	mov    0x14(%ebp),%eax
801075cf:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
801075d3:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
801075d7:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801075db:	83 ec 08             	sub    $0x8,%esp
801075de:	8d 45 de             	lea    -0x22(%ebp),%eax
801075e1:	50                   	push   %eax
801075e2:	ff 75 08             	pushl  0x8(%ebp)
801075e5:	e8 8f b1 ff ff       	call   80102779 <nameiparent>
801075ea:	83 c4 10             	add    $0x10,%esp
801075ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801075f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801075f4:	75 0a                	jne    80107600 <create+0x40>
    return 0;
801075f6:	b8 00 00 00 00       	mov    $0x0,%eax
801075fb:	e9 90 01 00 00       	jmp    80107790 <create+0x1d0>
  ilock(dp);
80107600:	83 ec 0c             	sub    $0xc,%esp
80107603:	ff 75 f4             	pushl  -0xc(%ebp)
80107606:	e8 44 a5 ff ff       	call   80101b4f <ilock>
8010760b:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010760e:	83 ec 04             	sub    $0x4,%esp
80107611:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107614:	50                   	push   %eax
80107615:	8d 45 de             	lea    -0x22(%ebp),%eax
80107618:	50                   	push   %eax
80107619:	ff 75 f4             	pushl  -0xc(%ebp)
8010761c:	e8 e6 ad ff ff       	call   80102407 <dirlookup>
80107621:	83 c4 10             	add    $0x10,%esp
80107624:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107627:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010762b:	74 50                	je     8010767d <create+0xbd>
    iunlockput(dp);
8010762d:	83 ec 0c             	sub    $0xc,%esp
80107630:	ff 75 f4             	pushl  -0xc(%ebp)
80107633:	e8 ff a7 ff ff       	call   80101e37 <iunlockput>
80107638:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010763b:	83 ec 0c             	sub    $0xc,%esp
8010763e:	ff 75 f0             	pushl  -0x10(%ebp)
80107641:	e8 09 a5 ff ff       	call   80101b4f <ilock>
80107646:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80107649:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
8010764e:	75 15                	jne    80107665 <create+0xa5>
80107650:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107653:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107657:	66 83 f8 02          	cmp    $0x2,%ax
8010765b:	75 08                	jne    80107665 <create+0xa5>
      return ip;
8010765d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107660:	e9 2b 01 00 00       	jmp    80107790 <create+0x1d0>
    iunlockput(ip);
80107665:	83 ec 0c             	sub    $0xc,%esp
80107668:	ff 75 f0             	pushl  -0x10(%ebp)
8010766b:	e8 c7 a7 ff ff       	call   80101e37 <iunlockput>
80107670:	83 c4 10             	add    $0x10,%esp
    return 0;
80107673:	b8 00 00 00 00       	mov    $0x0,%eax
80107678:	e9 13 01 00 00       	jmp    80107790 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010767d:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80107681:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107684:	8b 00                	mov    (%eax),%eax
80107686:	83 ec 08             	sub    $0x8,%esp
80107689:	52                   	push   %edx
8010768a:	50                   	push   %eax
8010768b:	e8 ca a1 ff ff       	call   8010185a <ialloc>
80107690:	83 c4 10             	add    $0x10,%esp
80107693:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107696:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010769a:	75 0d                	jne    801076a9 <create+0xe9>
    panic("create: ialloc");
8010769c:	83 ec 0c             	sub    $0xc,%esp
8010769f:	68 6f a6 10 80       	push   $0x8010a66f
801076a4:	e8 bd 8e ff ff       	call   80100566 <panic>

  ilock(ip);
801076a9:	83 ec 0c             	sub    $0xc,%esp
801076ac:	ff 75 f0             	pushl  -0x10(%ebp)
801076af:	e8 9b a4 ff ff       	call   80101b4f <ilock>
801076b4:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
801076b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076ba:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
801076be:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
801076c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076c5:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
801076c9:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
801076cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076d0:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
801076d6:	83 ec 0c             	sub    $0xc,%esp
801076d9:	ff 75 f0             	pushl  -0x10(%ebp)
801076dc:	e8 6c a2 ff ff       	call   8010194d <iupdate>
801076e1:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
801076e4:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801076e9:	75 6a                	jne    80107755 <create+0x195>
    dp->nlink++;  // for ".."
801076eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076ee:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801076f2:	83 c0 01             	add    $0x1,%eax
801076f5:	89 c2                	mov    %eax,%edx
801076f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076fa:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801076fe:	83 ec 0c             	sub    $0xc,%esp
80107701:	ff 75 f4             	pushl  -0xc(%ebp)
80107704:	e8 44 a2 ff ff       	call   8010194d <iupdate>
80107709:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010770c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010770f:	8b 40 04             	mov    0x4(%eax),%eax
80107712:	83 ec 04             	sub    $0x4,%esp
80107715:	50                   	push   %eax
80107716:	68 49 a6 10 80       	push   $0x8010a649
8010771b:	ff 75 f0             	pushl  -0x10(%ebp)
8010771e:	e8 9e ad ff ff       	call   801024c1 <dirlink>
80107723:	83 c4 10             	add    $0x10,%esp
80107726:	85 c0                	test   %eax,%eax
80107728:	78 1e                	js     80107748 <create+0x188>
8010772a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010772d:	8b 40 04             	mov    0x4(%eax),%eax
80107730:	83 ec 04             	sub    $0x4,%esp
80107733:	50                   	push   %eax
80107734:	68 4b a6 10 80       	push   $0x8010a64b
80107739:	ff 75 f0             	pushl  -0x10(%ebp)
8010773c:	e8 80 ad ff ff       	call   801024c1 <dirlink>
80107741:	83 c4 10             	add    $0x10,%esp
80107744:	85 c0                	test   %eax,%eax
80107746:	79 0d                	jns    80107755 <create+0x195>
      panic("create dots");
80107748:	83 ec 0c             	sub    $0xc,%esp
8010774b:	68 7e a6 10 80       	push   $0x8010a67e
80107750:	e8 11 8e ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80107755:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107758:	8b 40 04             	mov    0x4(%eax),%eax
8010775b:	83 ec 04             	sub    $0x4,%esp
8010775e:	50                   	push   %eax
8010775f:	8d 45 de             	lea    -0x22(%ebp),%eax
80107762:	50                   	push   %eax
80107763:	ff 75 f4             	pushl  -0xc(%ebp)
80107766:	e8 56 ad ff ff       	call   801024c1 <dirlink>
8010776b:	83 c4 10             	add    $0x10,%esp
8010776e:	85 c0                	test   %eax,%eax
80107770:	79 0d                	jns    8010777f <create+0x1bf>
    panic("create: dirlink");
80107772:	83 ec 0c             	sub    $0xc,%esp
80107775:	68 8a a6 10 80       	push   $0x8010a68a
8010777a:	e8 e7 8d ff ff       	call   80100566 <panic>

  iunlockput(dp);
8010777f:	83 ec 0c             	sub    $0xc,%esp
80107782:	ff 75 f4             	pushl  -0xc(%ebp)
80107785:	e8 ad a6 ff ff       	call   80101e37 <iunlockput>
8010778a:	83 c4 10             	add    $0x10,%esp

  return ip;
8010778d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107790:	c9                   	leave  
80107791:	c3                   	ret    

80107792 <sys_open>:

int
sys_open(void)
{
80107792:	55                   	push   %ebp
80107793:	89 e5                	mov    %esp,%ebp
80107795:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80107798:	83 ec 08             	sub    $0x8,%esp
8010779b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010779e:	50                   	push   %eax
8010779f:	6a 00                	push   $0x0
801077a1:	e8 eb f6 ff ff       	call   80106e91 <argstr>
801077a6:	83 c4 10             	add    $0x10,%esp
801077a9:	85 c0                	test   %eax,%eax
801077ab:	78 15                	js     801077c2 <sys_open+0x30>
801077ad:	83 ec 08             	sub    $0x8,%esp
801077b0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801077b3:	50                   	push   %eax
801077b4:	6a 01                	push   $0x1
801077b6:	e8 51 f6 ff ff       	call   80106e0c <argint>
801077bb:	83 c4 10             	add    $0x10,%esp
801077be:	85 c0                	test   %eax,%eax
801077c0:	79 0a                	jns    801077cc <sys_open+0x3a>
    return -1;
801077c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801077c7:	e9 61 01 00 00       	jmp    8010792d <sys_open+0x19b>

  begin_op();
801077cc:	e8 b1 c2 ff ff       	call   80103a82 <begin_op>

  if(omode & O_CREATE){
801077d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d4:	25 00 02 00 00       	and    $0x200,%eax
801077d9:	85 c0                	test   %eax,%eax
801077db:	74 2a                	je     80107807 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
801077dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801077e0:	6a 00                	push   $0x0
801077e2:	6a 00                	push   $0x0
801077e4:	6a 02                	push   $0x2
801077e6:	50                   	push   %eax
801077e7:	e8 d4 fd ff ff       	call   801075c0 <create>
801077ec:	83 c4 10             	add    $0x10,%esp
801077ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
801077f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801077f6:	75 75                	jne    8010786d <sys_open+0xdb>
      end_op();
801077f8:	e8 11 c3 ff ff       	call   80103b0e <end_op>
      return -1;
801077fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107802:	e9 26 01 00 00       	jmp    8010792d <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107807:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010780a:	83 ec 0c             	sub    $0xc,%esp
8010780d:	50                   	push   %eax
8010780e:	e8 4a af ff ff       	call   8010275d <namei>
80107813:	83 c4 10             	add    $0x10,%esp
80107816:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107819:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010781d:	75 0f                	jne    8010782e <sys_open+0x9c>
      end_op();
8010781f:	e8 ea c2 ff ff       	call   80103b0e <end_op>
      return -1;
80107824:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107829:	e9 ff 00 00 00       	jmp    8010792d <sys_open+0x19b>
    }
    ilock(ip);
8010782e:	83 ec 0c             	sub    $0xc,%esp
80107831:	ff 75 f4             	pushl  -0xc(%ebp)
80107834:	e8 16 a3 ff ff       	call   80101b4f <ilock>
80107839:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
8010783c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107843:	66 83 f8 01          	cmp    $0x1,%ax
80107847:	75 24                	jne    8010786d <sys_open+0xdb>
80107849:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010784c:	85 c0                	test   %eax,%eax
8010784e:	74 1d                	je     8010786d <sys_open+0xdb>
      iunlockput(ip);
80107850:	83 ec 0c             	sub    $0xc,%esp
80107853:	ff 75 f4             	pushl  -0xc(%ebp)
80107856:	e8 dc a5 ff ff       	call   80101e37 <iunlockput>
8010785b:	83 c4 10             	add    $0x10,%esp
      end_op();
8010785e:	e8 ab c2 ff ff       	call   80103b0e <end_op>
      return -1;
80107863:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107868:	e9 c0 00 00 00       	jmp    8010792d <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010786d:	e8 c2 98 ff ff       	call   80101134 <filealloc>
80107872:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107875:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107879:	74 17                	je     80107892 <sys_open+0x100>
8010787b:	83 ec 0c             	sub    $0xc,%esp
8010787e:	ff 75 f0             	pushl  -0x10(%ebp)
80107881:	e8 37 f7 ff ff       	call   80106fbd <fdalloc>
80107886:	83 c4 10             	add    $0x10,%esp
80107889:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010788c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107890:	79 2e                	jns    801078c0 <sys_open+0x12e>
    if(f)
80107892:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107896:	74 0e                	je     801078a6 <sys_open+0x114>
      fileclose(f);
80107898:	83 ec 0c             	sub    $0xc,%esp
8010789b:	ff 75 f0             	pushl  -0x10(%ebp)
8010789e:	e8 4f 99 ff ff       	call   801011f2 <fileclose>
801078a3:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801078a6:	83 ec 0c             	sub    $0xc,%esp
801078a9:	ff 75 f4             	pushl  -0xc(%ebp)
801078ac:	e8 86 a5 ff ff       	call   80101e37 <iunlockput>
801078b1:	83 c4 10             	add    $0x10,%esp
    end_op();
801078b4:	e8 55 c2 ff ff       	call   80103b0e <end_op>
    return -1;
801078b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078be:	eb 6d                	jmp    8010792d <sys_open+0x19b>
  }
  iunlock(ip);
801078c0:	83 ec 0c             	sub    $0xc,%esp
801078c3:	ff 75 f4             	pushl  -0xc(%ebp)
801078c6:	e8 0a a4 ff ff       	call   80101cd5 <iunlock>
801078cb:	83 c4 10             	add    $0x10,%esp
  end_op();
801078ce:	e8 3b c2 ff ff       	call   80103b0e <end_op>

  f->type = FD_INODE;
801078d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078d6:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801078dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801078e2:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801078e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078e8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
801078ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078f2:	83 e0 01             	and    $0x1,%eax
801078f5:	85 c0                	test   %eax,%eax
801078f7:	0f 94 c0             	sete   %al
801078fa:	89 c2                	mov    %eax,%edx
801078fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801078ff:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80107902:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107905:	83 e0 01             	and    $0x1,%eax
80107908:	85 c0                	test   %eax,%eax
8010790a:	75 0a                	jne    80107916 <sys_open+0x184>
8010790c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010790f:	83 e0 02             	and    $0x2,%eax
80107912:	85 c0                	test   %eax,%eax
80107914:	74 07                	je     8010791d <sys_open+0x18b>
80107916:	b8 01 00 00 00       	mov    $0x1,%eax
8010791b:	eb 05                	jmp    80107922 <sys_open+0x190>
8010791d:	b8 00 00 00 00       	mov    $0x0,%eax
80107922:	89 c2                	mov    %eax,%edx
80107924:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107927:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010792a:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010792d:	c9                   	leave  
8010792e:	c3                   	ret    

8010792f <sys_mkdir>:

int
sys_mkdir(void)
{
8010792f:	55                   	push   %ebp
80107930:	89 e5                	mov    %esp,%ebp
80107932:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107935:	e8 48 c1 ff ff       	call   80103a82 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010793a:	83 ec 08             	sub    $0x8,%esp
8010793d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107940:	50                   	push   %eax
80107941:	6a 00                	push   $0x0
80107943:	e8 49 f5 ff ff       	call   80106e91 <argstr>
80107948:	83 c4 10             	add    $0x10,%esp
8010794b:	85 c0                	test   %eax,%eax
8010794d:	78 1b                	js     8010796a <sys_mkdir+0x3b>
8010794f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107952:	6a 00                	push   $0x0
80107954:	6a 00                	push   $0x0
80107956:	6a 01                	push   $0x1
80107958:	50                   	push   %eax
80107959:	e8 62 fc ff ff       	call   801075c0 <create>
8010795e:	83 c4 10             	add    $0x10,%esp
80107961:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107964:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107968:	75 0c                	jne    80107976 <sys_mkdir+0x47>
    end_op();
8010796a:	e8 9f c1 ff ff       	call   80103b0e <end_op>
    return -1;
8010796f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107974:	eb 18                	jmp    8010798e <sys_mkdir+0x5f>
  }
  iunlockput(ip);
80107976:	83 ec 0c             	sub    $0xc,%esp
80107979:	ff 75 f4             	pushl  -0xc(%ebp)
8010797c:	e8 b6 a4 ff ff       	call   80101e37 <iunlockput>
80107981:	83 c4 10             	add    $0x10,%esp
  end_op();
80107984:	e8 85 c1 ff ff       	call   80103b0e <end_op>
  return 0;
80107989:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010798e:	c9                   	leave  
8010798f:	c3                   	ret    

80107990 <sys_mknod>:

int
sys_mknod(void)
{
80107990:	55                   	push   %ebp
80107991:	89 e5                	mov    %esp,%ebp
80107993:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
80107996:	e8 e7 c0 ff ff       	call   80103a82 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010799b:	83 ec 08             	sub    $0x8,%esp
8010799e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801079a1:	50                   	push   %eax
801079a2:	6a 00                	push   $0x0
801079a4:	e8 e8 f4 ff ff       	call   80106e91 <argstr>
801079a9:	83 c4 10             	add    $0x10,%esp
801079ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079b3:	78 4f                	js     80107a04 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801079b5:	83 ec 08             	sub    $0x8,%esp
801079b8:	8d 45 e8             	lea    -0x18(%ebp),%eax
801079bb:	50                   	push   %eax
801079bc:	6a 01                	push   $0x1
801079be:	e8 49 f4 ff ff       	call   80106e0c <argint>
801079c3:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
801079c6:	85 c0                	test   %eax,%eax
801079c8:	78 3a                	js     80107a04 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801079ca:	83 ec 08             	sub    $0x8,%esp
801079cd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801079d0:	50                   	push   %eax
801079d1:	6a 02                	push   $0x2
801079d3:	e8 34 f4 ff ff       	call   80106e0c <argint>
801079d8:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
801079db:	85 c0                	test   %eax,%eax
801079dd:	78 25                	js     80107a04 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
801079df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801079e2:	0f bf c8             	movswl %ax,%ecx
801079e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801079e8:	0f bf d0             	movswl %ax,%edx
801079eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801079ee:	51                   	push   %ecx
801079ef:	52                   	push   %edx
801079f0:	6a 03                	push   $0x3
801079f2:	50                   	push   %eax
801079f3:	e8 c8 fb ff ff       	call   801075c0 <create>
801079f8:	83 c4 10             	add    $0x10,%esp
801079fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801079fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a02:	75 0c                	jne    80107a10 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107a04:	e8 05 c1 ff ff       	call   80103b0e <end_op>
    return -1;
80107a09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a0e:	eb 18                	jmp    80107a28 <sys_mknod+0x98>
  }
  iunlockput(ip);
80107a10:	83 ec 0c             	sub    $0xc,%esp
80107a13:	ff 75 f0             	pushl  -0x10(%ebp)
80107a16:	e8 1c a4 ff ff       	call   80101e37 <iunlockput>
80107a1b:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a1e:	e8 eb c0 ff ff       	call   80103b0e <end_op>
  return 0;
80107a23:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a28:	c9                   	leave  
80107a29:	c3                   	ret    

80107a2a <sys_chdir>:

int
sys_chdir(void)
{
80107a2a:	55                   	push   %ebp
80107a2b:	89 e5                	mov    %esp,%ebp
80107a2d:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107a30:	e8 4d c0 ff ff       	call   80103a82 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107a35:	83 ec 08             	sub    $0x8,%esp
80107a38:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a3b:	50                   	push   %eax
80107a3c:	6a 00                	push   $0x0
80107a3e:	e8 4e f4 ff ff       	call   80106e91 <argstr>
80107a43:	83 c4 10             	add    $0x10,%esp
80107a46:	85 c0                	test   %eax,%eax
80107a48:	78 18                	js     80107a62 <sys_chdir+0x38>
80107a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107a4d:	83 ec 0c             	sub    $0xc,%esp
80107a50:	50                   	push   %eax
80107a51:	e8 07 ad ff ff       	call   8010275d <namei>
80107a56:	83 c4 10             	add    $0x10,%esp
80107a59:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a60:	75 0c                	jne    80107a6e <sys_chdir+0x44>
    end_op();
80107a62:	e8 a7 c0 ff ff       	call   80103b0e <end_op>
    return -1;
80107a67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a6c:	eb 6e                	jmp    80107adc <sys_chdir+0xb2>
  }
  ilock(ip);
80107a6e:	83 ec 0c             	sub    $0xc,%esp
80107a71:	ff 75 f4             	pushl  -0xc(%ebp)
80107a74:	e8 d6 a0 ff ff       	call   80101b4f <ilock>
80107a79:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107a83:	66 83 f8 01          	cmp    $0x1,%ax
80107a87:	74 1a                	je     80107aa3 <sys_chdir+0x79>
    iunlockput(ip);
80107a89:	83 ec 0c             	sub    $0xc,%esp
80107a8c:	ff 75 f4             	pushl  -0xc(%ebp)
80107a8f:	e8 a3 a3 ff ff       	call   80101e37 <iunlockput>
80107a94:	83 c4 10             	add    $0x10,%esp
    end_op();
80107a97:	e8 72 c0 ff ff       	call   80103b0e <end_op>
    return -1;
80107a9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107aa1:	eb 39                	jmp    80107adc <sys_chdir+0xb2>
  }
  iunlock(ip);
80107aa3:	83 ec 0c             	sub    $0xc,%esp
80107aa6:	ff 75 f4             	pushl  -0xc(%ebp)
80107aa9:	e8 27 a2 ff ff       	call   80101cd5 <iunlock>
80107aae:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107ab1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ab7:	8b 40 68             	mov    0x68(%eax),%eax
80107aba:	83 ec 0c             	sub    $0xc,%esp
80107abd:	50                   	push   %eax
80107abe:	e8 84 a2 ff ff       	call   80101d47 <iput>
80107ac3:	83 c4 10             	add    $0x10,%esp
  end_op();
80107ac6:	e8 43 c0 ff ff       	call   80103b0e <end_op>
  proc->cwd = ip;
80107acb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ad1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107ad4:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107ad7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107adc:	c9                   	leave  
80107add:	c3                   	ret    

80107ade <sys_exec>:

int
sys_exec(void)
{
80107ade:	55                   	push   %ebp
80107adf:	89 e5                	mov    %esp,%ebp
80107ae1:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107ae7:	83 ec 08             	sub    $0x8,%esp
80107aea:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107aed:	50                   	push   %eax
80107aee:	6a 00                	push   $0x0
80107af0:	e8 9c f3 ff ff       	call   80106e91 <argstr>
80107af5:	83 c4 10             	add    $0x10,%esp
80107af8:	85 c0                	test   %eax,%eax
80107afa:	78 18                	js     80107b14 <sys_exec+0x36>
80107afc:	83 ec 08             	sub    $0x8,%esp
80107aff:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107b05:	50                   	push   %eax
80107b06:	6a 01                	push   $0x1
80107b08:	e8 ff f2 ff ff       	call   80106e0c <argint>
80107b0d:	83 c4 10             	add    $0x10,%esp
80107b10:	85 c0                	test   %eax,%eax
80107b12:	79 0a                	jns    80107b1e <sys_exec+0x40>
    return -1;
80107b14:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b19:	e9 c6 00 00 00       	jmp    80107be4 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107b1e:	83 ec 04             	sub    $0x4,%esp
80107b21:	68 80 00 00 00       	push   $0x80
80107b26:	6a 00                	push   $0x0
80107b28:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b2e:	50                   	push   %eax
80107b2f:	e8 b3 ef ff ff       	call   80106ae7 <memset>
80107b34:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107b37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b41:	83 f8 1f             	cmp    $0x1f,%eax
80107b44:	76 0a                	jbe    80107b50 <sys_exec+0x72>
      return -1;
80107b46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b4b:	e9 94 00 00 00       	jmp    80107be4 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b53:	c1 e0 02             	shl    $0x2,%eax
80107b56:	89 c2                	mov    %eax,%edx
80107b58:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107b5e:	01 c2                	add    %eax,%edx
80107b60:	83 ec 08             	sub    $0x8,%esp
80107b63:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107b69:	50                   	push   %eax
80107b6a:	52                   	push   %edx
80107b6b:	e8 00 f2 ff ff       	call   80106d70 <fetchint>
80107b70:	83 c4 10             	add    $0x10,%esp
80107b73:	85 c0                	test   %eax,%eax
80107b75:	79 07                	jns    80107b7e <sys_exec+0xa0>
      return -1;
80107b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b7c:	eb 66                	jmp    80107be4 <sys_exec+0x106>
    if(uarg == 0){
80107b7e:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107b84:	85 c0                	test   %eax,%eax
80107b86:	75 27                	jne    80107baf <sys_exec+0xd1>
      argv[i] = 0;
80107b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b8b:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107b92:	00 00 00 00 
      break;
80107b96:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b9a:	83 ec 08             	sub    $0x8,%esp
80107b9d:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107ba3:	52                   	push   %edx
80107ba4:	50                   	push   %eax
80107ba5:	e8 71 90 ff ff       	call   80100c1b <exec>
80107baa:	83 c4 10             	add    $0x10,%esp
80107bad:	eb 35                	jmp    80107be4 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107baf:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107bb5:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107bb8:	c1 e2 02             	shl    $0x2,%edx
80107bbb:	01 c2                	add    %eax,%edx
80107bbd:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107bc3:	83 ec 08             	sub    $0x8,%esp
80107bc6:	52                   	push   %edx
80107bc7:	50                   	push   %eax
80107bc8:	e8 dd f1 ff ff       	call   80106daa <fetchstr>
80107bcd:	83 c4 10             	add    $0x10,%esp
80107bd0:	85 c0                	test   %eax,%eax
80107bd2:	79 07                	jns    80107bdb <sys_exec+0xfd>
      return -1;
80107bd4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bd9:	eb 09                	jmp    80107be4 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107bdb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107bdf:	e9 5a ff ff ff       	jmp    80107b3e <sys_exec+0x60>
  return exec(path, argv);
}
80107be4:	c9                   	leave  
80107be5:	c3                   	ret    

80107be6 <sys_pipe>:

int
sys_pipe(void)
{
80107be6:	55                   	push   %ebp
80107be7:	89 e5                	mov    %esp,%ebp
80107be9:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107bec:	83 ec 04             	sub    $0x4,%esp
80107bef:	6a 08                	push   $0x8
80107bf1:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107bf4:	50                   	push   %eax
80107bf5:	6a 00                	push   $0x0
80107bf7:	e8 38 f2 ff ff       	call   80106e34 <argptr>
80107bfc:	83 c4 10             	add    $0x10,%esp
80107bff:	85 c0                	test   %eax,%eax
80107c01:	79 0a                	jns    80107c0d <sys_pipe+0x27>
    return -1;
80107c03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c08:	e9 af 00 00 00       	jmp    80107cbc <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107c0d:	83 ec 08             	sub    $0x8,%esp
80107c10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107c13:	50                   	push   %eax
80107c14:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107c17:	50                   	push   %eax
80107c18:	e8 59 c9 ff ff       	call   80104576 <pipealloc>
80107c1d:	83 c4 10             	add    $0x10,%esp
80107c20:	85 c0                	test   %eax,%eax
80107c22:	79 0a                	jns    80107c2e <sys_pipe+0x48>
    return -1;
80107c24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c29:	e9 8e 00 00 00       	jmp    80107cbc <sys_pipe+0xd6>
  fd0 = -1;
80107c2e:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107c35:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c38:	83 ec 0c             	sub    $0xc,%esp
80107c3b:	50                   	push   %eax
80107c3c:	e8 7c f3 ff ff       	call   80106fbd <fdalloc>
80107c41:	83 c4 10             	add    $0x10,%esp
80107c44:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c4b:	78 18                	js     80107c65 <sys_pipe+0x7f>
80107c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c50:	83 ec 0c             	sub    $0xc,%esp
80107c53:	50                   	push   %eax
80107c54:	e8 64 f3 ff ff       	call   80106fbd <fdalloc>
80107c59:	83 c4 10             	add    $0x10,%esp
80107c5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c63:	79 3f                	jns    80107ca4 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107c65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c69:	78 14                	js     80107c7f <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107c6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107c71:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c74:	83 c2 08             	add    $0x8,%edx
80107c77:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107c7e:	00 
    fileclose(rf);
80107c7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c82:	83 ec 0c             	sub    $0xc,%esp
80107c85:	50                   	push   %eax
80107c86:	e8 67 95 ff ff       	call   801011f2 <fileclose>
80107c8b:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107c8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107c91:	83 ec 0c             	sub    $0xc,%esp
80107c94:	50                   	push   %eax
80107c95:	e8 58 95 ff ff       	call   801011f2 <fileclose>
80107c9a:	83 c4 10             	add    $0x10,%esp
    return -1;
80107c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ca2:	eb 18                	jmp    80107cbc <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107ca4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ca7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107caa:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107cac:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107caf:	8d 50 04             	lea    0x4(%eax),%edx
80107cb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cb5:	89 02                	mov    %eax,(%edx)
  return 0;
80107cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107cbc:	c9                   	leave  
80107cbd:	c3                   	ret    

80107cbe <sys_chmod>:

#ifdef CS333_P5
int
sys_chmod(void)
{
80107cbe:	55                   	push   %ebp
80107cbf:	89 e5                	mov    %esp,%ebp
80107cc1:	83 ec 18             	sub    $0x18,%esp
  // The new mode for the file.
  int mode;
  // The result of do_chmod.
  int rc;

  if(argptr(0, &path, sizeof(char*)) < 0)
80107cc4:	83 ec 04             	sub    $0x4,%esp
80107cc7:	6a 04                	push   $0x4
80107cc9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ccc:	50                   	push   %eax
80107ccd:	6a 00                	push   $0x0
80107ccf:	e8 60 f1 ff ff       	call   80106e34 <argptr>
80107cd4:	83 c4 10             	add    $0x10,%esp
80107cd7:	85 c0                	test   %eax,%eax
80107cd9:	79 07                	jns    80107ce2 <sys_chmod+0x24>
	return -1;
80107cdb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ce0:	eb 35                	jmp    80107d17 <sys_chmod+0x59>
  if(argint(1, &mode) < 0)
80107ce2:	83 ec 08             	sub    $0x8,%esp
80107ce5:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107ce8:	50                   	push   %eax
80107ce9:	6a 01                	push   $0x1
80107ceb:	e8 1c f1 ff ff       	call   80106e0c <argint>
80107cf0:	83 c4 10             	add    $0x10,%esp
80107cf3:	85 c0                	test   %eax,%eax
80107cf5:	79 07                	jns    80107cfe <sys_chmod+0x40>
	return -1;
80107cf7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cfc:	eb 19                	jmp    80107d17 <sys_chmod+0x59>

  rc = do_chmod(path, mode);
80107cfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d04:	83 ec 08             	sub    $0x8,%esp
80107d07:	52                   	push   %edx
80107d08:	50                   	push   %eax
80107d09:	e8 01 ac ff ff       	call   8010290f <do_chmod>
80107d0e:	83 c4 10             	add    $0x10,%esp
80107d11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return rc;
80107d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107d17:	c9                   	leave  
80107d18:	c3                   	ret    

80107d19 <sys_chown>:

int
sys_chown(void)
{
80107d19:	55                   	push   %ebp
80107d1a:	89 e5                	mov    %esp,%ebp
80107d1c:	83 ec 18             	sub    $0x18,%esp
  char* path;
  int owner;
  int rc;

  if(argptr(0, &path, sizeof(char*)) < 0)
80107d1f:	83 ec 04             	sub    $0x4,%esp
80107d22:	6a 04                	push   $0x4
80107d24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d27:	50                   	push   %eax
80107d28:	6a 00                	push   $0x0
80107d2a:	e8 05 f1 ff ff       	call   80106e34 <argptr>
80107d2f:	83 c4 10             	add    $0x10,%esp
80107d32:	85 c0                	test   %eax,%eax
80107d34:	79 07                	jns    80107d3d <sys_chown+0x24>
	return -1;
80107d36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d3b:	eb 35                	jmp    80107d72 <sys_chown+0x59>
  if(argint(1, &owner) < 0)
80107d3d:	83 ec 08             	sub    $0x8,%esp
80107d40:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107d43:	50                   	push   %eax
80107d44:	6a 01                	push   $0x1
80107d46:	e8 c1 f0 ff ff       	call   80106e0c <argint>
80107d4b:	83 c4 10             	add    $0x10,%esp
80107d4e:	85 c0                	test   %eax,%eax
80107d50:	79 07                	jns    80107d59 <sys_chown+0x40>
	return -1;
80107d52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d57:	eb 19                	jmp    80107d72 <sys_chown+0x59>

  rc = do_chown(path, owner);
80107d59:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d5f:	83 ec 08             	sub    $0x8,%esp
80107d62:	52                   	push   %edx
80107d63:	50                   	push   %eax
80107d64:	e8 29 ac ff ff       	call   80102992 <do_chown>
80107d69:	83 c4 10             	add    $0x10,%esp
80107d6c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  return rc;
80107d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107d72:	c9                   	leave  
80107d73:	c3                   	ret    

80107d74 <sys_chgrp>:

int
sys_chgrp(void)
{
80107d74:	55                   	push   %ebp
80107d75:	89 e5                	mov    %esp,%ebp
80107d77:	83 ec 18             	sub    $0x18,%esp
  char* path;
  int group;
  int rc;

  if(argptr(0, &path, sizeof(char*)) < 0)
80107d7a:	83 ec 04             	sub    $0x4,%esp
80107d7d:	6a 04                	push   $0x4
80107d7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d82:	50                   	push   %eax
80107d83:	6a 00                	push   $0x0
80107d85:	e8 aa f0 ff ff       	call   80106e34 <argptr>
80107d8a:	83 c4 10             	add    $0x10,%esp
80107d8d:	85 c0                	test   %eax,%eax
80107d8f:	79 07                	jns    80107d98 <sys_chgrp+0x24>
	return -1;
80107d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d96:	eb 35                	jmp    80107dcd <sys_chgrp+0x59>
  if(argint(1, &group) < 0)
80107d98:	83 ec 08             	sub    $0x8,%esp
80107d9b:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107d9e:	50                   	push   %eax
80107d9f:	6a 01                	push   $0x1
80107da1:	e8 66 f0 ff ff       	call   80106e0c <argint>
80107da6:	83 c4 10             	add    $0x10,%esp
80107da9:	85 c0                	test   %eax,%eax
80107dab:	79 07                	jns    80107db4 <sys_chgrp+0x40>
	return -1;
80107dad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107db2:	eb 19                	jmp    80107dcd <sys_chgrp+0x59>

  rc = do_chgrp(path, group);
80107db4:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107db7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dba:	83 ec 08             	sub    $0x8,%esp
80107dbd:	52                   	push   %edx
80107dbe:	50                   	push   %eax
80107dbf:	e8 4f ac ff ff       	call   80102a13 <do_chgrp>
80107dc4:	83 c4 10             	add    $0x10,%esp
80107dc7:	89 45 f4             	mov    %eax,-0xc(%ebp)

  return rc;
80107dca:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
80107dcd:	c9                   	leave  
80107dce:	c3                   	ret    

80107dcf <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107dcf:	55                   	push   %ebp
80107dd0:	89 e5                	mov    %esp,%ebp
80107dd2:	83 ec 08             	sub    $0x8,%esp
80107dd5:	8b 55 08             	mov    0x8(%ebp),%edx
80107dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ddb:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107ddf:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107de3:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107de7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107deb:	66 ef                	out    %ax,(%dx)
}
80107ded:	90                   	nop
80107dee:	c9                   	leave  
80107def:	c3                   	ret    

80107df0 <sys_fork>:
extern int get_active_procs(uint, struct uproc*);
#endif

int
sys_fork(void)
{
80107df0:	55                   	push   %ebp
80107df1:	89 e5                	mov    %esp,%ebp
80107df3:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107df6:	e8 b1 d1 ff ff       	call   80104fac <fork>
}
80107dfb:	c9                   	leave  
80107dfc:	c3                   	ret    

80107dfd <sys_exit>:

int
sys_exit(void)
{
80107dfd:	55                   	push   %ebp
80107dfe:	89 e5                	mov    %esp,%ebp
80107e00:	83 ec 08             	sub    $0x8,%esp
  exit();
80107e03:	e8 e0 d3 ff ff       	call   801051e8 <exit>
  return 0;  // not reached
80107e08:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e0d:	c9                   	leave  
80107e0e:	c3                   	ret    

80107e0f <sys_wait>:

int
sys_wait(void)
{
80107e0f:	55                   	push   %ebp
80107e10:	89 e5                	mov    %esp,%ebp
80107e12:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107e15:	e8 da d5 ff ff       	call   801053f4 <wait>
}
80107e1a:	c9                   	leave  
80107e1b:	c3                   	ret    

80107e1c <sys_kill>:

int
sys_kill(void)
{
80107e1c:	55                   	push   %ebp
80107e1d:	89 e5                	mov    %esp,%ebp
80107e1f:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107e22:	83 ec 08             	sub    $0x8,%esp
80107e25:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e28:	50                   	push   %eax
80107e29:	6a 00                	push   $0x0
80107e2b:	e8 dc ef ff ff       	call   80106e0c <argint>
80107e30:	83 c4 10             	add    $0x10,%esp
80107e33:	85 c0                	test   %eax,%eax
80107e35:	79 07                	jns    80107e3e <sys_kill+0x22>
    return -1;
80107e37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e3c:	eb 0f                	jmp    80107e4d <sys_kill+0x31>
  return kill(pid);
80107e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e41:	83 ec 0c             	sub    $0xc,%esp
80107e44:	50                   	push   %eax
80107e45:	e8 c3 de ff ff       	call   80105d0d <kill>
80107e4a:	83 c4 10             	add    $0x10,%esp
}
80107e4d:	c9                   	leave  
80107e4e:	c3                   	ret    

80107e4f <sys_getpid>:

int
sys_getpid(void)
{
80107e4f:	55                   	push   %ebp
80107e50:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107e52:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e58:	8b 40 10             	mov    0x10(%eax),%eax
}
80107e5b:	5d                   	pop    %ebp
80107e5c:	c3                   	ret    

80107e5d <sys_sbrk>:

int
sys_sbrk(void)
{
80107e5d:	55                   	push   %ebp
80107e5e:	89 e5                	mov    %esp,%ebp
80107e60:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107e63:	83 ec 08             	sub    $0x8,%esp
80107e66:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107e69:	50                   	push   %eax
80107e6a:	6a 00                	push   $0x0
80107e6c:	e8 9b ef ff ff       	call   80106e0c <argint>
80107e71:	83 c4 10             	add    $0x10,%esp
80107e74:	85 c0                	test   %eax,%eax
80107e76:	79 07                	jns    80107e7f <sys_sbrk+0x22>
    return -1;
80107e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e7d:	eb 28                	jmp    80107ea7 <sys_sbrk+0x4a>
  addr = proc->sz;
80107e7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107e85:	8b 00                	mov    (%eax),%eax
80107e87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107e8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e8d:	83 ec 0c             	sub    $0xc,%esp
80107e90:	50                   	push   %eax
80107e91:	e8 73 d0 ff ff       	call   80104f09 <growproc>
80107e96:	83 c4 10             	add    $0x10,%esp
80107e99:	85 c0                	test   %eax,%eax
80107e9b:	79 07                	jns    80107ea4 <sys_sbrk+0x47>
    return -1;
80107e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ea2:	eb 03                	jmp    80107ea7 <sys_sbrk+0x4a>
  return addr;
80107ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107ea7:	c9                   	leave  
80107ea8:	c3                   	ret    

80107ea9 <sys_sleep>:

int
sys_sleep(void)
{
80107ea9:	55                   	push   %ebp
80107eaa:	89 e5                	mov    %esp,%ebp
80107eac:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107eaf:	83 ec 08             	sub    $0x8,%esp
80107eb2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107eb5:	50                   	push   %eax
80107eb6:	6a 00                	push   $0x0
80107eb8:	e8 4f ef ff ff       	call   80106e0c <argint>
80107ebd:	83 c4 10             	add    $0x10,%esp
80107ec0:	85 c0                	test   %eax,%eax
80107ec2:	79 07                	jns    80107ecb <sys_sleep+0x22>
    return -1;
80107ec4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ec9:	eb 44                	jmp    80107f0f <sys_sleep+0x66>
  ticks0 = ticks;
80107ecb:	a1 80 74 11 80       	mov    0x80117480,%eax
80107ed0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107ed3:	eb 26                	jmp    80107efb <sys_sleep+0x52>
    if(proc->killed){
80107ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107edb:	8b 40 24             	mov    0x24(%eax),%eax
80107ede:	85 c0                	test   %eax,%eax
80107ee0:	74 07                	je     80107ee9 <sys_sleep+0x40>
      return -1;
80107ee2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ee7:	eb 26                	jmp    80107f0f <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107ee9:	83 ec 08             	sub    $0x8,%esp
80107eec:	6a 00                	push   $0x0
80107eee:	68 80 74 11 80       	push   $0x80117480
80107ef3:	e8 17 dc ff ff       	call   80105b0f <sleep>
80107ef8:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107efb:	a1 80 74 11 80       	mov    0x80117480,%eax
80107f00:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f03:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f06:	39 d0                	cmp    %edx,%eax
80107f08:	72 cb                	jb     80107ed5 <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107f0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f0f:	c9                   	leave  
80107f10:	c3                   	ret    

80107f11 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107f11:	55                   	push   %ebp
80107f12:	89 e5                	mov    %esp,%ebp
80107f14:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107f17:	a1 80 74 11 80       	mov    0x80117480,%eax
80107f1c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107f1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107f22:	c9                   	leave  
80107f23:	c3                   	ret    

80107f24 <sys_halt>:

//Turn of the computer
int
sys_halt(void){
80107f24:	55                   	push   %ebp
80107f25:	89 e5                	mov    %esp,%ebp
80107f27:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107f2a:	83 ec 0c             	sub    $0xc,%esp
80107f2d:	68 9a a6 10 80       	push   $0x8010a69a
80107f32:	e8 8f 84 ff ff       	call   801003c6 <cprintf>
80107f37:	83 c4 10             	add    $0x10,%esp
  outw( 0x604, 0x0 | 0x2000);
80107f3a:	83 ec 08             	sub    $0x8,%esp
80107f3d:	68 00 20 00 00       	push   $0x2000
80107f42:	68 04 06 00 00       	push   $0x604
80107f47:	e8 83 fe ff ff       	call   80107dcf <outw>
80107f4c:	83 c4 10             	add    $0x10,%esp
  return 0;
80107f4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f54:	c9                   	leave  
80107f55:	c3                   	ret    

80107f56 <sys_date>:

#ifdef CS333_P1
int
sys_date(void)
{
80107f56:	55                   	push   %ebp
80107f57:	89 e5                	mov    %esp,%ebp
80107f59:	83 ec 18             	sub    $0x18,%esp
	// This stores the date itself.
	struct rtcdate* date;

	// Grab the date argument passed in. If this fails, return -1.
	if(argptr(0, (void*)&date, sizeof(struct rtcdate) < 0))
80107f5c:	83 ec 04             	sub    $0x4,%esp
80107f5f:	6a 00                	push   $0x0
80107f61:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107f64:	50                   	push   %eax
80107f65:	6a 00                	push   $0x0
80107f67:	e8 c8 ee ff ff       	call   80106e34 <argptr>
80107f6c:	83 c4 10             	add    $0x10,%esp
80107f6f:	85 c0                	test   %eax,%eax
80107f71:	74 07                	je     80107f7a <sys_date+0x24>
		return -1;
80107f73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f78:	eb 14                	jmp    80107f8e <sys_date+0x38>

	cmostime(date);
80107f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f7d:	83 ec 0c             	sub    $0xc,%esp
80107f80:	50                   	push   %eax
80107f81:	e8 77 b7 ff ff       	call   801036fd <cmostime>
80107f86:	83 c4 10             	add    $0x10,%esp

	return 0;
80107f89:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f8e:	c9                   	leave  
80107f8f:	c3                   	ret    

80107f90 <sys_getuid>:
#endif

#ifdef CS333_P2
int
sys_getuid(void)
{
80107f90:	55                   	push   %ebp
80107f91:	89 e5                	mov    %esp,%ebp
	// If the proc is bad, return an error.
	if(!proc)
80107f93:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f99:	85 c0                	test   %eax,%eax
80107f9b:	75 07                	jne    80107fa4 <sys_getuid+0x14>
		return -1;
80107f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fa2:	eb 0c                	jmp    80107fb0 <sys_getuid+0x20>

	// The uid is an uint, but value from 0 to 3767
	return (int)proc->uid;
80107fa4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107faa:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80107fb0:	5d                   	pop    %ebp
80107fb1:	c3                   	ret    

80107fb2 <sys_getgid>:

int
sys_getgid(void)
{
80107fb2:	55                   	push   %ebp
80107fb3:	89 e5                	mov    %esp,%ebp
	return (int)proc->gid;
80107fb5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fbb:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80107fc1:	5d                   	pop    %ebp
80107fc2:	c3                   	ret    

80107fc3 <sys_getppid>:

int
sys_getppid(void)
{
80107fc3:	55                   	push   %ebp
80107fc4:	89 e5                	mov    %esp,%ebp
80107fc6:	83 ec 10             	sub    $0x10,%esp
	int result;

	// As per the requirements, the PPID of process 1 is 1 as well.
	if(!proc->parent)
80107fc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fcf:	8b 40 14             	mov    0x14(%eax),%eax
80107fd2:	85 c0                	test   %eax,%eax
80107fd4:	75 09                	jne    80107fdf <sys_getppid+0x1c>
		result = 1;
80107fd6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
80107fdd:	eb 0f                	jmp    80107fee <sys_getppid+0x2b>
	else
		result = (int)proc->parent->pid;
80107fdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107fe5:	8b 40 14             	mov    0x14(%eax),%eax
80107fe8:	8b 40 10             	mov    0x10(%eax),%eax
80107feb:	89 45 fc             	mov    %eax,-0x4(%ebp)

	return result;
80107fee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107ff1:	c9                   	leave  
80107ff2:	c3                   	ret    

80107ff3 <sys_setuid>:

int
sys_setuid(void)
{
80107ff3:	55                   	push   %ebp
80107ff4:	89 e5                	mov    %esp,%ebp
80107ff6:	83 ec 18             	sub    $0x18,%esp
	// Stores the argument that the user gives us.
	uint val;

	if(argptr(0, (void*)&val, sizeof(uint)) == -1)
80107ff9:	83 ec 04             	sub    $0x4,%esp
80107ffc:	6a 04                	push   $0x4
80107ffe:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108001:	50                   	push   %eax
80108002:	6a 00                	push   $0x0
80108004:	e8 2b ee ff ff       	call   80106e34 <argptr>
80108009:	83 c4 10             	add    $0x10,%esp
8010800c:	83 f8 ff             	cmp    $0xffffffff,%eax
8010800f:	75 07                	jne    80108018 <sys_setuid+0x25>
		return -1;
80108011:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108016:	eb 25                	jmp    8010803d <sys_setuid+0x4a>
	// Enforces the bounds that a UID must be.
	// I recognize that the lower bound is probably
	// uneccessary since we're dealing in unsigned ints,
	// but on the other hand, it prevents undeterministic
	// related to giving a uint a negative value.
	if(MIN_UID_SIZE > val || val > MAX_UID_SIZE)
80108018:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010801b:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80108020:	76 07                	jbe    80108029 <sys_setuid+0x36>
		return -1;
80108022:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108027:	eb 14                	jmp    8010803d <sys_setuid+0x4a>

	proc->uid = val;
80108029:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010802f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108032:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)

	return 0;
80108038:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010803d:	c9                   	leave  
8010803e:	c3                   	ret    

8010803f <sys_setgid>:

int
sys_setgid(void)
{
8010803f:	55                   	push   %ebp
80108040:	89 e5                	mov    %esp,%ebp
80108042:	83 ec 18             	sub    $0x18,%esp
	uint val;

	if(argptr(0, (void*)&val, sizeof(uint)) == -1)
80108045:	83 ec 04             	sub    $0x4,%esp
80108048:	6a 04                	push   $0x4
8010804a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010804d:	50                   	push   %eax
8010804e:	6a 00                	push   $0x0
80108050:	e8 df ed ff ff       	call   80106e34 <argptr>
80108055:	83 c4 10             	add    $0x10,%esp
80108058:	83 f8 ff             	cmp    $0xffffffff,%eax
8010805b:	75 07                	jne    80108064 <sys_setgid+0x25>
		return -1;
8010805d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108062:	eb 25                	jmp    80108089 <sys_setgid+0x4a>
	if(MIN_GID_SIZE > val || val > MAX_GID_SIZE)
80108064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108067:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
8010806c:	76 07                	jbe    80108075 <sys_setgid+0x36>
		return -1;
8010806e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108073:	eb 14                	jmp    80108089 <sys_setgid+0x4a>

	proc->gid = val;
80108075:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010807b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010807e:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

	return 0;
80108084:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108089:	c9                   	leave  
8010808a:	c3                   	ret    

8010808b <sys_getprocs>:

int
sys_getprocs(void)
{
8010808b:	55                   	push   %ebp
8010808c:	89 e5                	mov    %esp,%ebp
8010808e:	83 ec 18             	sub    $0x18,%esp
	// Maximum number of processes to read in.
	uint max;
	// Where to store the process data.
	struct uproc* table;

	if(argptr(0, (void*)&max, sizeof(uint)) == -1)
80108091:	83 ec 04             	sub    $0x4,%esp
80108094:	6a 04                	push   $0x4
80108096:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108099:	50                   	push   %eax
8010809a:	6a 00                	push   $0x0
8010809c:	e8 93 ed ff ff       	call   80106e34 <argptr>
801080a1:	83 c4 10             	add    $0x10,%esp
801080a4:	83 f8 ff             	cmp    $0xffffffff,%eax
801080a7:	75 07                	jne    801080b0 <sys_getprocs+0x25>
		return -1;
801080a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080ae:	eb 32                	jmp    801080e2 <sys_getprocs+0x57>
	if(argptr(1, (void*)&table, sizeof(struct uproc*)) == -1)
801080b0:	83 ec 04             	sub    $0x4,%esp
801080b3:	6a 04                	push   $0x4
801080b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
801080b8:	50                   	push   %eax
801080b9:	6a 01                	push   $0x1
801080bb:	e8 74 ed ff ff       	call   80106e34 <argptr>
801080c0:	83 c4 10             	add    $0x10,%esp
801080c3:	83 f8 ff             	cmp    $0xffffffff,%eax
801080c6:	75 07                	jne    801080cf <sys_getprocs+0x44>
		return -1;
801080c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080cd:	eb 13                	jmp    801080e2 <sys_getprocs+0x57>

	return get_active_procs(max, table);
801080cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801080d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d5:	83 ec 08             	sub    $0x8,%esp
801080d8:	52                   	push   %edx
801080d9:	50                   	push   %eax
801080da:	e8 1b e0 ff ff       	call   801060fa <get_active_procs>
801080df:	83 c4 10             	add    $0x10,%esp
}
801080e2:	c9                   	leave  
801080e3:	c3                   	ret    

801080e4 <sys_setpriority>:
#endif

#ifdef CS333_P3P4
int
sys_setpriority(void)
{
801080e4:	55                   	push   %ebp
801080e5:	89 e5                	mov    %esp,%ebp
801080e7:	83 ec 18             	sub    $0x18,%esp
  int pid, priority;
  int rc;

  if(argint(0, &pid) == -1)
801080ea:	83 ec 08             	sub    $0x8,%esp
801080ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801080f0:	50                   	push   %eax
801080f1:	6a 00                	push   $0x0
801080f3:	e8 14 ed ff ff       	call   80106e0c <argint>
801080f8:	83 c4 10             	add    $0x10,%esp
801080fb:	83 f8 ff             	cmp    $0xffffffff,%eax
801080fe:	75 07                	jne    80108107 <sys_setpriority+0x23>
    return -1;
80108100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108105:	eb 52                	jmp    80108159 <sys_setpriority+0x75>
  else if(argint(1, &priority) == -1)
80108107:	83 ec 08             	sub    $0x8,%esp
8010810a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010810d:	50                   	push   %eax
8010810e:	6a 01                	push   $0x1
80108110:	e8 f7 ec ff ff       	call   80106e0c <argint>
80108115:	83 c4 10             	add    $0x10,%esp
80108118:	83 f8 ff             	cmp    $0xffffffff,%eax
8010811b:	75 07                	jne    80108124 <sys_setpriority+0x40>
    return -1;
8010811d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108122:	eb 35                	jmp    80108159 <sys_setpriority+0x75>

  rc = dosetpriority(pid, priority);
80108124:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108127:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010812a:	83 ec 08             	sub    $0x8,%esp
8010812d:	52                   	push   %edx
8010812e:	50                   	push   %eax
8010812f:	e8 43 e2 ff ff       	call   80106377 <dosetpriority>
80108134:	83 c4 10             	add    $0x10,%esp
80108137:	89 45 f4             	mov    %eax,-0xc(%ebp)

  // Priority out of range
  if(rc == -1)
8010813a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
8010813e:	75 07                	jne    80108147 <sys_setpriority+0x63>
    return -2;
80108140:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80108145:	eb 12                	jmp    80108159 <sys_setpriority+0x75>
  // Failed to find active process with
  // pid.
  else if(rc == 0)
80108147:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010814b:	75 07                	jne    80108154 <sys_setpriority+0x70>
    return -3;
8010814d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
80108152:	eb 05                	jmp    80108159 <sys_setpriority+0x75>

  return 0;
80108154:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108159:	c9                   	leave  
8010815a:	c3                   	ret    

8010815b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010815b:	55                   	push   %ebp
8010815c:	89 e5                	mov    %esp,%ebp
8010815e:	83 ec 08             	sub    $0x8,%esp
80108161:	8b 55 08             	mov    0x8(%ebp),%edx
80108164:	8b 45 0c             	mov    0xc(%ebp),%eax
80108167:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010816b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010816e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108172:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108176:	ee                   	out    %al,(%dx)
}
80108177:	90                   	nop
80108178:	c9                   	leave  
80108179:	c3                   	ret    

8010817a <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
8010817a:	55                   	push   %ebp
8010817b:	89 e5                	mov    %esp,%ebp
8010817d:	83 ec 08             	sub    $0x8,%esp
  // Interrupt TPS times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80108180:	6a 34                	push   $0x34
80108182:	6a 43                	push   $0x43
80108184:	e8 d2 ff ff ff       	call   8010815b <outb>
80108189:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) % 256);
8010818c:	68 a9 00 00 00       	push   $0xa9
80108191:	6a 40                	push   $0x40
80108193:	e8 c3 ff ff ff       	call   8010815b <outb>
80108198:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(TPS) / 256);
8010819b:	6a 04                	push   $0x4
8010819d:	6a 40                	push   $0x40
8010819f:	e8 b7 ff ff ff       	call   8010815b <outb>
801081a4:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801081a7:	83 ec 0c             	sub    $0xc,%esp
801081aa:	6a 00                	push   $0x0
801081ac:	e8 af c2 ff ff       	call   80104460 <picenable>
801081b1:	83 c4 10             	add    $0x10,%esp
}
801081b4:	90                   	nop
801081b5:	c9                   	leave  
801081b6:	c3                   	ret    

801081b7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801081b7:	1e                   	push   %ds
  pushl %es
801081b8:	06                   	push   %es
  pushl %fs
801081b9:	0f a0                	push   %fs
  pushl %gs
801081bb:	0f a8                	push   %gs
  pushal
801081bd:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801081be:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801081c2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801081c4:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801081c6:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801081ca:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801081cc:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801081ce:	54                   	push   %esp
  call trap
801081cf:	e8 ce 01 00 00       	call   801083a2 <trap>
  addl $4, %esp
801081d4:	83 c4 04             	add    $0x4,%esp

801081d7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801081d7:	61                   	popa   
  popl %gs
801081d8:	0f a9                	pop    %gs
  popl %fs
801081da:	0f a1                	pop    %fs
  popl %es
801081dc:	07                   	pop    %es
  popl %ds
801081dd:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801081de:	83 c4 08             	add    $0x8,%esp
  iret
801081e1:	cf                   	iret   

801081e2 <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
801081e2:	55                   	push   %ebp
801081e3:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
801081e5:	8b 45 08             	mov    0x8(%ebp),%eax
801081e8:	f0 ff 00             	lock incl (%eax)
}
801081eb:	90                   	nop
801081ec:	5d                   	pop    %ebp
801081ed:	c3                   	ret    

801081ee <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801081ee:	55                   	push   %ebp
801081ef:	89 e5                	mov    %esp,%ebp
801081f1:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801081f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801081f7:	83 e8 01             	sub    $0x1,%eax
801081fa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801081fe:	8b 45 08             	mov    0x8(%ebp),%eax
80108201:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108205:	8b 45 08             	mov    0x8(%ebp),%eax
80108208:	c1 e8 10             	shr    $0x10,%eax
8010820b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010820f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80108212:	0f 01 18             	lidtl  (%eax)
}
80108215:	90                   	nop
80108216:	c9                   	leave  
80108217:	c3                   	ret    

80108218 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80108218:	55                   	push   %ebp
80108219:	89 e5                	mov    %esp,%ebp
8010821b:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010821e:	0f 20 d0             	mov    %cr2,%eax
80108221:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80108224:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108227:	c9                   	leave  
80108228:	c3                   	ret    

80108229 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80108229:	55                   	push   %ebp
8010822a:	89 e5                	mov    %esp,%ebp
8010822c:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
8010822f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108236:	e9 c3 00 00 00       	jmp    801082fe <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010823b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010823e:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
80108245:	89 c2                	mov    %eax,%edx
80108247:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010824a:	66 89 14 c5 80 6c 11 	mov    %dx,-0x7fee9380(,%eax,8)
80108251:	80 
80108252:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108255:	66 c7 04 c5 82 6c 11 	movw   $0x8,-0x7fee937e(,%eax,8)
8010825c:	80 08 00 
8010825f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108262:	0f b6 14 c5 84 6c 11 	movzbl -0x7fee937c(,%eax,8),%edx
80108269:	80 
8010826a:	83 e2 e0             	and    $0xffffffe0,%edx
8010826d:	88 14 c5 84 6c 11 80 	mov    %dl,-0x7fee937c(,%eax,8)
80108274:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108277:	0f b6 14 c5 84 6c 11 	movzbl -0x7fee937c(,%eax,8),%edx
8010827e:	80 
8010827f:	83 e2 1f             	and    $0x1f,%edx
80108282:	88 14 c5 84 6c 11 80 	mov    %dl,-0x7fee937c(,%eax,8)
80108289:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010828c:	0f b6 14 c5 85 6c 11 	movzbl -0x7fee937b(,%eax,8),%edx
80108293:	80 
80108294:	83 e2 f0             	and    $0xfffffff0,%edx
80108297:	83 ca 0e             	or     $0xe,%edx
8010829a:	88 14 c5 85 6c 11 80 	mov    %dl,-0x7fee937b(,%eax,8)
801082a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082a4:	0f b6 14 c5 85 6c 11 	movzbl -0x7fee937b(,%eax,8),%edx
801082ab:	80 
801082ac:	83 e2 ef             	and    $0xffffffef,%edx
801082af:	88 14 c5 85 6c 11 80 	mov    %dl,-0x7fee937b(,%eax,8)
801082b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082b9:	0f b6 14 c5 85 6c 11 	movzbl -0x7fee937b(,%eax,8),%edx
801082c0:	80 
801082c1:	83 e2 9f             	and    $0xffffff9f,%edx
801082c4:	88 14 c5 85 6c 11 80 	mov    %dl,-0x7fee937b(,%eax,8)
801082cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082ce:	0f b6 14 c5 85 6c 11 	movzbl -0x7fee937b(,%eax,8),%edx
801082d5:	80 
801082d6:	83 ca 80             	or     $0xffffff80,%edx
801082d9:	88 14 c5 85 6c 11 80 	mov    %dl,-0x7fee937b(,%eax,8)
801082e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082e3:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
801082ea:	c1 e8 10             	shr    $0x10,%eax
801082ed:	89 c2                	mov    %eax,%edx
801082ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082f2:	66 89 14 c5 86 6c 11 	mov    %dx,-0x7fee937a(,%eax,8)
801082f9:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801082fa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801082fe:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80108305:	0f 8e 30 ff ff ff    	jle    8010823b <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010830b:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
80108310:	66 a3 80 6e 11 80    	mov    %ax,0x80116e80
80108316:	66 c7 05 82 6e 11 80 	movw   $0x8,0x80116e82
8010831d:	08 00 
8010831f:	0f b6 05 84 6e 11 80 	movzbl 0x80116e84,%eax
80108326:	83 e0 e0             	and    $0xffffffe0,%eax
80108329:	a2 84 6e 11 80       	mov    %al,0x80116e84
8010832e:	0f b6 05 84 6e 11 80 	movzbl 0x80116e84,%eax
80108335:	83 e0 1f             	and    $0x1f,%eax
80108338:	a2 84 6e 11 80       	mov    %al,0x80116e84
8010833d:	0f b6 05 85 6e 11 80 	movzbl 0x80116e85,%eax
80108344:	83 c8 0f             	or     $0xf,%eax
80108347:	a2 85 6e 11 80       	mov    %al,0x80116e85
8010834c:	0f b6 05 85 6e 11 80 	movzbl 0x80116e85,%eax
80108353:	83 e0 ef             	and    $0xffffffef,%eax
80108356:	a2 85 6e 11 80       	mov    %al,0x80116e85
8010835b:	0f b6 05 85 6e 11 80 	movzbl 0x80116e85,%eax
80108362:	83 c8 60             	or     $0x60,%eax
80108365:	a2 85 6e 11 80       	mov    %al,0x80116e85
8010836a:	0f b6 05 85 6e 11 80 	movzbl 0x80116e85,%eax
80108371:	83 c8 80             	or     $0xffffff80,%eax
80108374:	a2 85 6e 11 80       	mov    %al,0x80116e85
80108379:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
8010837e:	c1 e8 10             	shr    $0x10,%eax
80108381:	66 a3 86 6e 11 80    	mov    %ax,0x80116e86
  
}
80108387:	90                   	nop
80108388:	c9                   	leave  
80108389:	c3                   	ret    

8010838a <idtinit>:

void
idtinit(void)
{
8010838a:	55                   	push   %ebp
8010838b:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010838d:	68 00 08 00 00       	push   $0x800
80108392:	68 80 6c 11 80       	push   $0x80116c80
80108397:	e8 52 fe ff ff       	call   801081ee <lidt>
8010839c:	83 c4 08             	add    $0x8,%esp
}
8010839f:	90                   	nop
801083a0:	c9                   	leave  
801083a1:	c3                   	ret    

801083a2 <trap>:

void
trap(struct trapframe *tf)
{
801083a2:	55                   	push   %ebp
801083a3:	89 e5                	mov    %esp,%ebp
801083a5:	57                   	push   %edi
801083a6:	56                   	push   %esi
801083a7:	53                   	push   %ebx
801083a8:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801083ab:	8b 45 08             	mov    0x8(%ebp),%eax
801083ae:	8b 40 30             	mov    0x30(%eax),%eax
801083b1:	83 f8 40             	cmp    $0x40,%eax
801083b4:	75 3e                	jne    801083f4 <trap+0x52>
    if(proc->killed)
801083b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083bc:	8b 40 24             	mov    0x24(%eax),%eax
801083bf:	85 c0                	test   %eax,%eax
801083c1:	74 05                	je     801083c8 <trap+0x26>
      exit();
801083c3:	e8 20 ce ff ff       	call   801051e8 <exit>
    proc->tf = tf;
801083c8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083ce:	8b 55 08             	mov    0x8(%ebp),%edx
801083d1:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801083d4:	e8 e9 ea ff ff       	call   80106ec2 <syscall>
    if(proc->killed)
801083d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083df:	8b 40 24             	mov    0x24(%eax),%eax
801083e2:	85 c0                	test   %eax,%eax
801083e4:	0f 84 21 02 00 00    	je     8010860b <trap+0x269>
      exit();
801083ea:	e8 f9 cd ff ff       	call   801051e8 <exit>
    return;
801083ef:	e9 17 02 00 00       	jmp    8010860b <trap+0x269>
  }

  switch(tf->trapno){
801083f4:	8b 45 08             	mov    0x8(%ebp),%eax
801083f7:	8b 40 30             	mov    0x30(%eax),%eax
801083fa:	83 e8 20             	sub    $0x20,%eax
801083fd:	83 f8 1f             	cmp    $0x1f,%eax
80108400:	0f 87 a3 00 00 00    	ja     801084a9 <trap+0x107>
80108406:	8b 04 85 50 a7 10 80 	mov    -0x7fef58b0(,%eax,4),%eax
8010840d:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
8010840f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108415:	0f b6 00             	movzbl (%eax),%eax
80108418:	84 c0                	test   %al,%al
8010841a:	75 20                	jne    8010843c <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
8010841c:	83 ec 0c             	sub    $0xc,%esp
8010841f:	68 80 74 11 80       	push   $0x80117480
80108424:	e8 b9 fd ff ff       	call   801081e2 <atom_inc>
80108429:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
8010842c:	83 ec 0c             	sub    $0xc,%esp
8010842f:	68 80 74 11 80       	push   $0x80117480
80108434:	e8 9d d8 ff ff       	call   80105cd6 <wakeup>
80108439:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
8010843c:	e8 19 b1 ff ff       	call   8010355a <lapiceoi>
    break;
80108441:	e9 1c 01 00 00       	jmp    80108562 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80108446:	e8 22 a9 ff ff       	call   80102d6d <ideintr>
    lapiceoi();
8010844b:	e8 0a b1 ff ff       	call   8010355a <lapiceoi>
    break;
80108450:	e9 0d 01 00 00       	jmp    80108562 <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80108455:	e8 02 af ff ff       	call   8010335c <kbdintr>
    lapiceoi();
8010845a:	e8 fb b0 ff ff       	call   8010355a <lapiceoi>
    break;
8010845f:	e9 fe 00 00 00       	jmp    80108562 <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80108464:	e8 83 03 00 00       	call   801087ec <uartintr>
    lapiceoi();
80108469:	e8 ec b0 ff ff       	call   8010355a <lapiceoi>
    break;
8010846e:	e9 ef 00 00 00       	jmp    80108562 <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108473:	8b 45 08             	mov    0x8(%ebp),%eax
80108476:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80108479:	8b 45 08             	mov    0x8(%ebp),%eax
8010847c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108480:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80108483:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108489:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010848c:	0f b6 c0             	movzbl %al,%eax
8010848f:	51                   	push   %ecx
80108490:	52                   	push   %edx
80108491:	50                   	push   %eax
80108492:	68 b0 a6 10 80       	push   $0x8010a6b0
80108497:	e8 2a 7f ff ff       	call   801003c6 <cprintf>
8010849c:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010849f:	e8 b6 b0 ff ff       	call   8010355a <lapiceoi>
    break;
801084a4:	e9 b9 00 00 00       	jmp    80108562 <trap+0x1c0>
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801084a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801084af:	85 c0                	test   %eax,%eax
801084b1:	74 11                	je     801084c4 <trap+0x122>
801084b3:	8b 45 08             	mov    0x8(%ebp),%eax
801084b6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801084ba:	0f b7 c0             	movzwl %ax,%eax
801084bd:	83 e0 03             	and    $0x3,%eax
801084c0:	85 c0                	test   %eax,%eax
801084c2:	75 40                	jne    80108504 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801084c4:	e8 4f fd ff ff       	call   80108218 <rcr2>
801084c9:	89 c3                	mov    %eax,%ebx
801084cb:	8b 45 08             	mov    0x8(%ebp),%eax
801084ce:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801084d1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084d7:	0f b6 00             	movzbl (%eax),%eax
    break;
   
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801084da:	0f b6 d0             	movzbl %al,%edx
801084dd:	8b 45 08             	mov    0x8(%ebp),%eax
801084e0:	8b 40 30             	mov    0x30(%eax),%eax
801084e3:	83 ec 0c             	sub    $0xc,%esp
801084e6:	53                   	push   %ebx
801084e7:	51                   	push   %ecx
801084e8:	52                   	push   %edx
801084e9:	50                   	push   %eax
801084ea:	68 d4 a6 10 80       	push   $0x8010a6d4
801084ef:	e8 d2 7e ff ff       	call   801003c6 <cprintf>
801084f4:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801084f7:	83 ec 0c             	sub    $0xc,%esp
801084fa:	68 06 a7 10 80       	push   $0x8010a706
801084ff:	e8 62 80 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108504:	e8 0f fd ff ff       	call   80108218 <rcr2>
80108509:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010850c:	8b 45 08             	mov    0x8(%ebp),%eax
8010850f:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108512:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108518:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010851b:	0f b6 d8             	movzbl %al,%ebx
8010851e:	8b 45 08             	mov    0x8(%ebp),%eax
80108521:	8b 48 34             	mov    0x34(%eax),%ecx
80108524:	8b 45 08             	mov    0x8(%ebp),%eax
80108527:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010852a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108530:	8d 78 6c             	lea    0x6c(%eax),%edi
80108533:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108539:	8b 40 10             	mov    0x10(%eax),%eax
8010853c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010853f:	56                   	push   %esi
80108540:	53                   	push   %ebx
80108541:	51                   	push   %ecx
80108542:	52                   	push   %edx
80108543:	57                   	push   %edi
80108544:	50                   	push   %eax
80108545:	68 0c a7 10 80       	push   $0x8010a70c
8010854a:	e8 77 7e ff ff       	call   801003c6 <cprintf>
8010854f:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
80108552:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108558:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010855f:	eb 01                	jmp    80108562 <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80108561:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80108562:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108568:	85 c0                	test   %eax,%eax
8010856a:	74 24                	je     80108590 <trap+0x1ee>
8010856c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108572:	8b 40 24             	mov    0x24(%eax),%eax
80108575:	85 c0                	test   %eax,%eax
80108577:	74 17                	je     80108590 <trap+0x1ee>
80108579:	8b 45 08             	mov    0x8(%ebp),%eax
8010857c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80108580:	0f b7 c0             	movzwl %ax,%eax
80108583:	83 e0 03             	and    $0x3,%eax
80108586:	83 f8 03             	cmp    $0x3,%eax
80108589:	75 05                	jne    80108590 <trap+0x1ee>
    exit();
8010858b:	e8 58 cc ff ff       	call   801051e8 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
80108590:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108596:	85 c0                	test   %eax,%eax
80108598:	74 41                	je     801085db <trap+0x239>
8010859a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085a0:	8b 40 0c             	mov    0xc(%eax),%eax
801085a3:	83 f8 04             	cmp    $0x4,%eax
801085a6:	75 33                	jne    801085db <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
801085a8:	8b 45 08             	mov    0x8(%ebp),%eax
801085ab:	8b 40 30             	mov    0x30(%eax),%eax
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING &&
801085ae:	83 f8 20             	cmp    $0x20,%eax
801085b1:	75 28                	jne    801085db <trap+0x239>
	  tf->trapno == T_IRQ0+IRQ_TIMER && ticks%SCHED_INTERVAL==0)
801085b3:	8b 0d 80 74 11 80    	mov    0x80117480,%ecx
801085b9:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801085be:	89 c8                	mov    %ecx,%eax
801085c0:	f7 e2                	mul    %edx
801085c2:	c1 ea 03             	shr    $0x3,%edx
801085c5:	89 d0                	mov    %edx,%eax
801085c7:	c1 e0 02             	shl    $0x2,%eax
801085ca:	01 d0                	add    %edx,%eax
801085cc:	01 c0                	add    %eax,%eax
801085ce:	29 c1                	sub    %eax,%ecx
801085d0:	89 ca                	mov    %ecx,%edx
801085d2:	85 d2                	test   %edx,%edx
801085d4:	75 05                	jne    801085db <trap+0x239>
    yield();
801085d6:	e8 d9 d3 ff ff       	call   801059b4 <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801085db:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085e1:	85 c0                	test   %eax,%eax
801085e3:	74 27                	je     8010860c <trap+0x26a>
801085e5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085eb:	8b 40 24             	mov    0x24(%eax),%eax
801085ee:	85 c0                	test   %eax,%eax
801085f0:	74 1a                	je     8010860c <trap+0x26a>
801085f2:	8b 45 08             	mov    0x8(%ebp),%eax
801085f5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801085f9:	0f b7 c0             	movzwl %ax,%eax
801085fc:	83 e0 03             	and    $0x3,%eax
801085ff:	83 f8 03             	cmp    $0x3,%eax
80108602:	75 08                	jne    8010860c <trap+0x26a>
    exit();
80108604:	e8 df cb ff ff       	call   801051e8 <exit>
80108609:	eb 01                	jmp    8010860c <trap+0x26a>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
8010860b:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
8010860c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010860f:	5b                   	pop    %ebx
80108610:	5e                   	pop    %esi
80108611:	5f                   	pop    %edi
80108612:	5d                   	pop    %ebp
80108613:	c3                   	ret    

80108614 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80108614:	55                   	push   %ebp
80108615:	89 e5                	mov    %esp,%ebp
80108617:	83 ec 14             	sub    $0x14,%esp
8010861a:	8b 45 08             	mov    0x8(%ebp),%eax
8010861d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80108621:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80108625:	89 c2                	mov    %eax,%edx
80108627:	ec                   	in     (%dx),%al
80108628:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010862b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010862f:	c9                   	leave  
80108630:	c3                   	ret    

80108631 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80108631:	55                   	push   %ebp
80108632:	89 e5                	mov    %esp,%ebp
80108634:	83 ec 08             	sub    $0x8,%esp
80108637:	8b 55 08             	mov    0x8(%ebp),%edx
8010863a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010863d:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108641:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80108644:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108648:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010864c:	ee                   	out    %al,(%dx)
}
8010864d:	90                   	nop
8010864e:	c9                   	leave  
8010864f:	c3                   	ret    

80108650 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80108650:	55                   	push   %ebp
80108651:	89 e5                	mov    %esp,%ebp
80108653:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80108656:	6a 00                	push   $0x0
80108658:	68 fa 03 00 00       	push   $0x3fa
8010865d:	e8 cf ff ff ff       	call   80108631 <outb>
80108662:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80108665:	68 80 00 00 00       	push   $0x80
8010866a:	68 fb 03 00 00       	push   $0x3fb
8010866f:	e8 bd ff ff ff       	call   80108631 <outb>
80108674:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80108677:	6a 0c                	push   $0xc
80108679:	68 f8 03 00 00       	push   $0x3f8
8010867e:	e8 ae ff ff ff       	call   80108631 <outb>
80108683:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108686:	6a 00                	push   $0x0
80108688:	68 f9 03 00 00       	push   $0x3f9
8010868d:	e8 9f ff ff ff       	call   80108631 <outb>
80108692:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80108695:	6a 03                	push   $0x3
80108697:	68 fb 03 00 00       	push   $0x3fb
8010869c:	e8 90 ff ff ff       	call   80108631 <outb>
801086a1:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
801086a4:	6a 00                	push   $0x0
801086a6:	68 fc 03 00 00       	push   $0x3fc
801086ab:	e8 81 ff ff ff       	call   80108631 <outb>
801086b0:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
801086b3:	6a 01                	push   $0x1
801086b5:	68 f9 03 00 00       	push   $0x3f9
801086ba:	e8 72 ff ff ff       	call   80108631 <outb>
801086bf:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
801086c2:	68 fd 03 00 00       	push   $0x3fd
801086c7:	e8 48 ff ff ff       	call   80108614 <inb>
801086cc:	83 c4 04             	add    $0x4,%esp
801086cf:	3c ff                	cmp    $0xff,%al
801086d1:	74 6e                	je     80108741 <uartinit+0xf1>
    return;
  uart = 1;
801086d3:	c7 05 8c d6 10 80 01 	movl   $0x1,0x8010d68c
801086da:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801086dd:	68 fa 03 00 00       	push   $0x3fa
801086e2:	e8 2d ff ff ff       	call   80108614 <inb>
801086e7:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801086ea:	68 f8 03 00 00       	push   $0x3f8
801086ef:	e8 20 ff ff ff       	call   80108614 <inb>
801086f4:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801086f7:	83 ec 0c             	sub    $0xc,%esp
801086fa:	6a 04                	push   $0x4
801086fc:	e8 5f bd ff ff       	call   80104460 <picenable>
80108701:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80108704:	83 ec 08             	sub    $0x8,%esp
80108707:	6a 00                	push   $0x0
80108709:	6a 04                	push   $0x4
8010870b:	e8 ff a8 ff ff       	call   8010300f <ioapicenable>
80108710:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108713:	c7 45 f4 d0 a7 10 80 	movl   $0x8010a7d0,-0xc(%ebp)
8010871a:	eb 19                	jmp    80108735 <uartinit+0xe5>
    uartputc(*p);
8010871c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010871f:	0f b6 00             	movzbl (%eax),%eax
80108722:	0f be c0             	movsbl %al,%eax
80108725:	83 ec 0c             	sub    $0xc,%esp
80108728:	50                   	push   %eax
80108729:	e8 16 00 00 00       	call   80108744 <uartputc>
8010872e:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80108731:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108735:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108738:	0f b6 00             	movzbl (%eax),%eax
8010873b:	84 c0                	test   %al,%al
8010873d:	75 dd                	jne    8010871c <uartinit+0xcc>
8010873f:	eb 01                	jmp    80108742 <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80108741:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80108742:	c9                   	leave  
80108743:	c3                   	ret    

80108744 <uartputc>:

void
uartputc(int c)
{
80108744:	55                   	push   %ebp
80108745:	89 e5                	mov    %esp,%ebp
80108747:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
8010874a:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
8010874f:	85 c0                	test   %eax,%eax
80108751:	74 53                	je     801087a6 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108753:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010875a:	eb 11                	jmp    8010876d <uartputc+0x29>
    microdelay(10);
8010875c:	83 ec 0c             	sub    $0xc,%esp
8010875f:	6a 0a                	push   $0xa
80108761:	e8 0f ae ff ff       	call   80103575 <microdelay>
80108766:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108769:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010876d:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80108771:	7f 1a                	jg     8010878d <uartputc+0x49>
80108773:	83 ec 0c             	sub    $0xc,%esp
80108776:	68 fd 03 00 00       	push   $0x3fd
8010877b:	e8 94 fe ff ff       	call   80108614 <inb>
80108780:	83 c4 10             	add    $0x10,%esp
80108783:	0f b6 c0             	movzbl %al,%eax
80108786:	83 e0 20             	and    $0x20,%eax
80108789:	85 c0                	test   %eax,%eax
8010878b:	74 cf                	je     8010875c <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
8010878d:	8b 45 08             	mov    0x8(%ebp),%eax
80108790:	0f b6 c0             	movzbl %al,%eax
80108793:	83 ec 08             	sub    $0x8,%esp
80108796:	50                   	push   %eax
80108797:	68 f8 03 00 00       	push   $0x3f8
8010879c:	e8 90 fe ff ff       	call   80108631 <outb>
801087a1:	83 c4 10             	add    $0x10,%esp
801087a4:	eb 01                	jmp    801087a7 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
801087a6:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
801087a7:	c9                   	leave  
801087a8:	c3                   	ret    

801087a9 <uartgetc>:

static int
uartgetc(void)
{
801087a9:	55                   	push   %ebp
801087aa:	89 e5                	mov    %esp,%ebp
  if(!uart)
801087ac:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
801087b1:	85 c0                	test   %eax,%eax
801087b3:	75 07                	jne    801087bc <uartgetc+0x13>
    return -1;
801087b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087ba:	eb 2e                	jmp    801087ea <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
801087bc:	68 fd 03 00 00       	push   $0x3fd
801087c1:	e8 4e fe ff ff       	call   80108614 <inb>
801087c6:	83 c4 04             	add    $0x4,%esp
801087c9:	0f b6 c0             	movzbl %al,%eax
801087cc:	83 e0 01             	and    $0x1,%eax
801087cf:	85 c0                	test   %eax,%eax
801087d1:	75 07                	jne    801087da <uartgetc+0x31>
    return -1;
801087d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087d8:	eb 10                	jmp    801087ea <uartgetc+0x41>
  return inb(COM1+0);
801087da:	68 f8 03 00 00       	push   $0x3f8
801087df:	e8 30 fe ff ff       	call   80108614 <inb>
801087e4:	83 c4 04             	add    $0x4,%esp
801087e7:	0f b6 c0             	movzbl %al,%eax
}
801087ea:	c9                   	leave  
801087eb:	c3                   	ret    

801087ec <uartintr>:

void
uartintr(void)
{
801087ec:	55                   	push   %ebp
801087ed:	89 e5                	mov    %esp,%ebp
801087ef:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801087f2:	83 ec 0c             	sub    $0xc,%esp
801087f5:	68 a9 87 10 80       	push   $0x801087a9
801087fa:	e8 fa 7f ff ff       	call   801007f9 <consoleintr>
801087ff:	83 c4 10             	add    $0x10,%esp
}
80108802:	90                   	nop
80108803:	c9                   	leave  
80108804:	c3                   	ret    

80108805 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80108805:	6a 00                	push   $0x0
  pushl $0
80108807:	6a 00                	push   $0x0
  jmp alltraps
80108809:	e9 a9 f9 ff ff       	jmp    801081b7 <alltraps>

8010880e <vector1>:
.globl vector1
vector1:
  pushl $0
8010880e:	6a 00                	push   $0x0
  pushl $1
80108810:	6a 01                	push   $0x1
  jmp alltraps
80108812:	e9 a0 f9 ff ff       	jmp    801081b7 <alltraps>

80108817 <vector2>:
.globl vector2
vector2:
  pushl $0
80108817:	6a 00                	push   $0x0
  pushl $2
80108819:	6a 02                	push   $0x2
  jmp alltraps
8010881b:	e9 97 f9 ff ff       	jmp    801081b7 <alltraps>

80108820 <vector3>:
.globl vector3
vector3:
  pushl $0
80108820:	6a 00                	push   $0x0
  pushl $3
80108822:	6a 03                	push   $0x3
  jmp alltraps
80108824:	e9 8e f9 ff ff       	jmp    801081b7 <alltraps>

80108829 <vector4>:
.globl vector4
vector4:
  pushl $0
80108829:	6a 00                	push   $0x0
  pushl $4
8010882b:	6a 04                	push   $0x4
  jmp alltraps
8010882d:	e9 85 f9 ff ff       	jmp    801081b7 <alltraps>

80108832 <vector5>:
.globl vector5
vector5:
  pushl $0
80108832:	6a 00                	push   $0x0
  pushl $5
80108834:	6a 05                	push   $0x5
  jmp alltraps
80108836:	e9 7c f9 ff ff       	jmp    801081b7 <alltraps>

8010883b <vector6>:
.globl vector6
vector6:
  pushl $0
8010883b:	6a 00                	push   $0x0
  pushl $6
8010883d:	6a 06                	push   $0x6
  jmp alltraps
8010883f:	e9 73 f9 ff ff       	jmp    801081b7 <alltraps>

80108844 <vector7>:
.globl vector7
vector7:
  pushl $0
80108844:	6a 00                	push   $0x0
  pushl $7
80108846:	6a 07                	push   $0x7
  jmp alltraps
80108848:	e9 6a f9 ff ff       	jmp    801081b7 <alltraps>

8010884d <vector8>:
.globl vector8
vector8:
  pushl $8
8010884d:	6a 08                	push   $0x8
  jmp alltraps
8010884f:	e9 63 f9 ff ff       	jmp    801081b7 <alltraps>

80108854 <vector9>:
.globl vector9
vector9:
  pushl $0
80108854:	6a 00                	push   $0x0
  pushl $9
80108856:	6a 09                	push   $0x9
  jmp alltraps
80108858:	e9 5a f9 ff ff       	jmp    801081b7 <alltraps>

8010885d <vector10>:
.globl vector10
vector10:
  pushl $10
8010885d:	6a 0a                	push   $0xa
  jmp alltraps
8010885f:	e9 53 f9 ff ff       	jmp    801081b7 <alltraps>

80108864 <vector11>:
.globl vector11
vector11:
  pushl $11
80108864:	6a 0b                	push   $0xb
  jmp alltraps
80108866:	e9 4c f9 ff ff       	jmp    801081b7 <alltraps>

8010886b <vector12>:
.globl vector12
vector12:
  pushl $12
8010886b:	6a 0c                	push   $0xc
  jmp alltraps
8010886d:	e9 45 f9 ff ff       	jmp    801081b7 <alltraps>

80108872 <vector13>:
.globl vector13
vector13:
  pushl $13
80108872:	6a 0d                	push   $0xd
  jmp alltraps
80108874:	e9 3e f9 ff ff       	jmp    801081b7 <alltraps>

80108879 <vector14>:
.globl vector14
vector14:
  pushl $14
80108879:	6a 0e                	push   $0xe
  jmp alltraps
8010887b:	e9 37 f9 ff ff       	jmp    801081b7 <alltraps>

80108880 <vector15>:
.globl vector15
vector15:
  pushl $0
80108880:	6a 00                	push   $0x0
  pushl $15
80108882:	6a 0f                	push   $0xf
  jmp alltraps
80108884:	e9 2e f9 ff ff       	jmp    801081b7 <alltraps>

80108889 <vector16>:
.globl vector16
vector16:
  pushl $0
80108889:	6a 00                	push   $0x0
  pushl $16
8010888b:	6a 10                	push   $0x10
  jmp alltraps
8010888d:	e9 25 f9 ff ff       	jmp    801081b7 <alltraps>

80108892 <vector17>:
.globl vector17
vector17:
  pushl $17
80108892:	6a 11                	push   $0x11
  jmp alltraps
80108894:	e9 1e f9 ff ff       	jmp    801081b7 <alltraps>

80108899 <vector18>:
.globl vector18
vector18:
  pushl $0
80108899:	6a 00                	push   $0x0
  pushl $18
8010889b:	6a 12                	push   $0x12
  jmp alltraps
8010889d:	e9 15 f9 ff ff       	jmp    801081b7 <alltraps>

801088a2 <vector19>:
.globl vector19
vector19:
  pushl $0
801088a2:	6a 00                	push   $0x0
  pushl $19
801088a4:	6a 13                	push   $0x13
  jmp alltraps
801088a6:	e9 0c f9 ff ff       	jmp    801081b7 <alltraps>

801088ab <vector20>:
.globl vector20
vector20:
  pushl $0
801088ab:	6a 00                	push   $0x0
  pushl $20
801088ad:	6a 14                	push   $0x14
  jmp alltraps
801088af:	e9 03 f9 ff ff       	jmp    801081b7 <alltraps>

801088b4 <vector21>:
.globl vector21
vector21:
  pushl $0
801088b4:	6a 00                	push   $0x0
  pushl $21
801088b6:	6a 15                	push   $0x15
  jmp alltraps
801088b8:	e9 fa f8 ff ff       	jmp    801081b7 <alltraps>

801088bd <vector22>:
.globl vector22
vector22:
  pushl $0
801088bd:	6a 00                	push   $0x0
  pushl $22
801088bf:	6a 16                	push   $0x16
  jmp alltraps
801088c1:	e9 f1 f8 ff ff       	jmp    801081b7 <alltraps>

801088c6 <vector23>:
.globl vector23
vector23:
  pushl $0
801088c6:	6a 00                	push   $0x0
  pushl $23
801088c8:	6a 17                	push   $0x17
  jmp alltraps
801088ca:	e9 e8 f8 ff ff       	jmp    801081b7 <alltraps>

801088cf <vector24>:
.globl vector24
vector24:
  pushl $0
801088cf:	6a 00                	push   $0x0
  pushl $24
801088d1:	6a 18                	push   $0x18
  jmp alltraps
801088d3:	e9 df f8 ff ff       	jmp    801081b7 <alltraps>

801088d8 <vector25>:
.globl vector25
vector25:
  pushl $0
801088d8:	6a 00                	push   $0x0
  pushl $25
801088da:	6a 19                	push   $0x19
  jmp alltraps
801088dc:	e9 d6 f8 ff ff       	jmp    801081b7 <alltraps>

801088e1 <vector26>:
.globl vector26
vector26:
  pushl $0
801088e1:	6a 00                	push   $0x0
  pushl $26
801088e3:	6a 1a                	push   $0x1a
  jmp alltraps
801088e5:	e9 cd f8 ff ff       	jmp    801081b7 <alltraps>

801088ea <vector27>:
.globl vector27
vector27:
  pushl $0
801088ea:	6a 00                	push   $0x0
  pushl $27
801088ec:	6a 1b                	push   $0x1b
  jmp alltraps
801088ee:	e9 c4 f8 ff ff       	jmp    801081b7 <alltraps>

801088f3 <vector28>:
.globl vector28
vector28:
  pushl $0
801088f3:	6a 00                	push   $0x0
  pushl $28
801088f5:	6a 1c                	push   $0x1c
  jmp alltraps
801088f7:	e9 bb f8 ff ff       	jmp    801081b7 <alltraps>

801088fc <vector29>:
.globl vector29
vector29:
  pushl $0
801088fc:	6a 00                	push   $0x0
  pushl $29
801088fe:	6a 1d                	push   $0x1d
  jmp alltraps
80108900:	e9 b2 f8 ff ff       	jmp    801081b7 <alltraps>

80108905 <vector30>:
.globl vector30
vector30:
  pushl $0
80108905:	6a 00                	push   $0x0
  pushl $30
80108907:	6a 1e                	push   $0x1e
  jmp alltraps
80108909:	e9 a9 f8 ff ff       	jmp    801081b7 <alltraps>

8010890e <vector31>:
.globl vector31
vector31:
  pushl $0
8010890e:	6a 00                	push   $0x0
  pushl $31
80108910:	6a 1f                	push   $0x1f
  jmp alltraps
80108912:	e9 a0 f8 ff ff       	jmp    801081b7 <alltraps>

80108917 <vector32>:
.globl vector32
vector32:
  pushl $0
80108917:	6a 00                	push   $0x0
  pushl $32
80108919:	6a 20                	push   $0x20
  jmp alltraps
8010891b:	e9 97 f8 ff ff       	jmp    801081b7 <alltraps>

80108920 <vector33>:
.globl vector33
vector33:
  pushl $0
80108920:	6a 00                	push   $0x0
  pushl $33
80108922:	6a 21                	push   $0x21
  jmp alltraps
80108924:	e9 8e f8 ff ff       	jmp    801081b7 <alltraps>

80108929 <vector34>:
.globl vector34
vector34:
  pushl $0
80108929:	6a 00                	push   $0x0
  pushl $34
8010892b:	6a 22                	push   $0x22
  jmp alltraps
8010892d:	e9 85 f8 ff ff       	jmp    801081b7 <alltraps>

80108932 <vector35>:
.globl vector35
vector35:
  pushl $0
80108932:	6a 00                	push   $0x0
  pushl $35
80108934:	6a 23                	push   $0x23
  jmp alltraps
80108936:	e9 7c f8 ff ff       	jmp    801081b7 <alltraps>

8010893b <vector36>:
.globl vector36
vector36:
  pushl $0
8010893b:	6a 00                	push   $0x0
  pushl $36
8010893d:	6a 24                	push   $0x24
  jmp alltraps
8010893f:	e9 73 f8 ff ff       	jmp    801081b7 <alltraps>

80108944 <vector37>:
.globl vector37
vector37:
  pushl $0
80108944:	6a 00                	push   $0x0
  pushl $37
80108946:	6a 25                	push   $0x25
  jmp alltraps
80108948:	e9 6a f8 ff ff       	jmp    801081b7 <alltraps>

8010894d <vector38>:
.globl vector38
vector38:
  pushl $0
8010894d:	6a 00                	push   $0x0
  pushl $38
8010894f:	6a 26                	push   $0x26
  jmp alltraps
80108951:	e9 61 f8 ff ff       	jmp    801081b7 <alltraps>

80108956 <vector39>:
.globl vector39
vector39:
  pushl $0
80108956:	6a 00                	push   $0x0
  pushl $39
80108958:	6a 27                	push   $0x27
  jmp alltraps
8010895a:	e9 58 f8 ff ff       	jmp    801081b7 <alltraps>

8010895f <vector40>:
.globl vector40
vector40:
  pushl $0
8010895f:	6a 00                	push   $0x0
  pushl $40
80108961:	6a 28                	push   $0x28
  jmp alltraps
80108963:	e9 4f f8 ff ff       	jmp    801081b7 <alltraps>

80108968 <vector41>:
.globl vector41
vector41:
  pushl $0
80108968:	6a 00                	push   $0x0
  pushl $41
8010896a:	6a 29                	push   $0x29
  jmp alltraps
8010896c:	e9 46 f8 ff ff       	jmp    801081b7 <alltraps>

80108971 <vector42>:
.globl vector42
vector42:
  pushl $0
80108971:	6a 00                	push   $0x0
  pushl $42
80108973:	6a 2a                	push   $0x2a
  jmp alltraps
80108975:	e9 3d f8 ff ff       	jmp    801081b7 <alltraps>

8010897a <vector43>:
.globl vector43
vector43:
  pushl $0
8010897a:	6a 00                	push   $0x0
  pushl $43
8010897c:	6a 2b                	push   $0x2b
  jmp alltraps
8010897e:	e9 34 f8 ff ff       	jmp    801081b7 <alltraps>

80108983 <vector44>:
.globl vector44
vector44:
  pushl $0
80108983:	6a 00                	push   $0x0
  pushl $44
80108985:	6a 2c                	push   $0x2c
  jmp alltraps
80108987:	e9 2b f8 ff ff       	jmp    801081b7 <alltraps>

8010898c <vector45>:
.globl vector45
vector45:
  pushl $0
8010898c:	6a 00                	push   $0x0
  pushl $45
8010898e:	6a 2d                	push   $0x2d
  jmp alltraps
80108990:	e9 22 f8 ff ff       	jmp    801081b7 <alltraps>

80108995 <vector46>:
.globl vector46
vector46:
  pushl $0
80108995:	6a 00                	push   $0x0
  pushl $46
80108997:	6a 2e                	push   $0x2e
  jmp alltraps
80108999:	e9 19 f8 ff ff       	jmp    801081b7 <alltraps>

8010899e <vector47>:
.globl vector47
vector47:
  pushl $0
8010899e:	6a 00                	push   $0x0
  pushl $47
801089a0:	6a 2f                	push   $0x2f
  jmp alltraps
801089a2:	e9 10 f8 ff ff       	jmp    801081b7 <alltraps>

801089a7 <vector48>:
.globl vector48
vector48:
  pushl $0
801089a7:	6a 00                	push   $0x0
  pushl $48
801089a9:	6a 30                	push   $0x30
  jmp alltraps
801089ab:	e9 07 f8 ff ff       	jmp    801081b7 <alltraps>

801089b0 <vector49>:
.globl vector49
vector49:
  pushl $0
801089b0:	6a 00                	push   $0x0
  pushl $49
801089b2:	6a 31                	push   $0x31
  jmp alltraps
801089b4:	e9 fe f7 ff ff       	jmp    801081b7 <alltraps>

801089b9 <vector50>:
.globl vector50
vector50:
  pushl $0
801089b9:	6a 00                	push   $0x0
  pushl $50
801089bb:	6a 32                	push   $0x32
  jmp alltraps
801089bd:	e9 f5 f7 ff ff       	jmp    801081b7 <alltraps>

801089c2 <vector51>:
.globl vector51
vector51:
  pushl $0
801089c2:	6a 00                	push   $0x0
  pushl $51
801089c4:	6a 33                	push   $0x33
  jmp alltraps
801089c6:	e9 ec f7 ff ff       	jmp    801081b7 <alltraps>

801089cb <vector52>:
.globl vector52
vector52:
  pushl $0
801089cb:	6a 00                	push   $0x0
  pushl $52
801089cd:	6a 34                	push   $0x34
  jmp alltraps
801089cf:	e9 e3 f7 ff ff       	jmp    801081b7 <alltraps>

801089d4 <vector53>:
.globl vector53
vector53:
  pushl $0
801089d4:	6a 00                	push   $0x0
  pushl $53
801089d6:	6a 35                	push   $0x35
  jmp alltraps
801089d8:	e9 da f7 ff ff       	jmp    801081b7 <alltraps>

801089dd <vector54>:
.globl vector54
vector54:
  pushl $0
801089dd:	6a 00                	push   $0x0
  pushl $54
801089df:	6a 36                	push   $0x36
  jmp alltraps
801089e1:	e9 d1 f7 ff ff       	jmp    801081b7 <alltraps>

801089e6 <vector55>:
.globl vector55
vector55:
  pushl $0
801089e6:	6a 00                	push   $0x0
  pushl $55
801089e8:	6a 37                	push   $0x37
  jmp alltraps
801089ea:	e9 c8 f7 ff ff       	jmp    801081b7 <alltraps>

801089ef <vector56>:
.globl vector56
vector56:
  pushl $0
801089ef:	6a 00                	push   $0x0
  pushl $56
801089f1:	6a 38                	push   $0x38
  jmp alltraps
801089f3:	e9 bf f7 ff ff       	jmp    801081b7 <alltraps>

801089f8 <vector57>:
.globl vector57
vector57:
  pushl $0
801089f8:	6a 00                	push   $0x0
  pushl $57
801089fa:	6a 39                	push   $0x39
  jmp alltraps
801089fc:	e9 b6 f7 ff ff       	jmp    801081b7 <alltraps>

80108a01 <vector58>:
.globl vector58
vector58:
  pushl $0
80108a01:	6a 00                	push   $0x0
  pushl $58
80108a03:	6a 3a                	push   $0x3a
  jmp alltraps
80108a05:	e9 ad f7 ff ff       	jmp    801081b7 <alltraps>

80108a0a <vector59>:
.globl vector59
vector59:
  pushl $0
80108a0a:	6a 00                	push   $0x0
  pushl $59
80108a0c:	6a 3b                	push   $0x3b
  jmp alltraps
80108a0e:	e9 a4 f7 ff ff       	jmp    801081b7 <alltraps>

80108a13 <vector60>:
.globl vector60
vector60:
  pushl $0
80108a13:	6a 00                	push   $0x0
  pushl $60
80108a15:	6a 3c                	push   $0x3c
  jmp alltraps
80108a17:	e9 9b f7 ff ff       	jmp    801081b7 <alltraps>

80108a1c <vector61>:
.globl vector61
vector61:
  pushl $0
80108a1c:	6a 00                	push   $0x0
  pushl $61
80108a1e:	6a 3d                	push   $0x3d
  jmp alltraps
80108a20:	e9 92 f7 ff ff       	jmp    801081b7 <alltraps>

80108a25 <vector62>:
.globl vector62
vector62:
  pushl $0
80108a25:	6a 00                	push   $0x0
  pushl $62
80108a27:	6a 3e                	push   $0x3e
  jmp alltraps
80108a29:	e9 89 f7 ff ff       	jmp    801081b7 <alltraps>

80108a2e <vector63>:
.globl vector63
vector63:
  pushl $0
80108a2e:	6a 00                	push   $0x0
  pushl $63
80108a30:	6a 3f                	push   $0x3f
  jmp alltraps
80108a32:	e9 80 f7 ff ff       	jmp    801081b7 <alltraps>

80108a37 <vector64>:
.globl vector64
vector64:
  pushl $0
80108a37:	6a 00                	push   $0x0
  pushl $64
80108a39:	6a 40                	push   $0x40
  jmp alltraps
80108a3b:	e9 77 f7 ff ff       	jmp    801081b7 <alltraps>

80108a40 <vector65>:
.globl vector65
vector65:
  pushl $0
80108a40:	6a 00                	push   $0x0
  pushl $65
80108a42:	6a 41                	push   $0x41
  jmp alltraps
80108a44:	e9 6e f7 ff ff       	jmp    801081b7 <alltraps>

80108a49 <vector66>:
.globl vector66
vector66:
  pushl $0
80108a49:	6a 00                	push   $0x0
  pushl $66
80108a4b:	6a 42                	push   $0x42
  jmp alltraps
80108a4d:	e9 65 f7 ff ff       	jmp    801081b7 <alltraps>

80108a52 <vector67>:
.globl vector67
vector67:
  pushl $0
80108a52:	6a 00                	push   $0x0
  pushl $67
80108a54:	6a 43                	push   $0x43
  jmp alltraps
80108a56:	e9 5c f7 ff ff       	jmp    801081b7 <alltraps>

80108a5b <vector68>:
.globl vector68
vector68:
  pushl $0
80108a5b:	6a 00                	push   $0x0
  pushl $68
80108a5d:	6a 44                	push   $0x44
  jmp alltraps
80108a5f:	e9 53 f7 ff ff       	jmp    801081b7 <alltraps>

80108a64 <vector69>:
.globl vector69
vector69:
  pushl $0
80108a64:	6a 00                	push   $0x0
  pushl $69
80108a66:	6a 45                	push   $0x45
  jmp alltraps
80108a68:	e9 4a f7 ff ff       	jmp    801081b7 <alltraps>

80108a6d <vector70>:
.globl vector70
vector70:
  pushl $0
80108a6d:	6a 00                	push   $0x0
  pushl $70
80108a6f:	6a 46                	push   $0x46
  jmp alltraps
80108a71:	e9 41 f7 ff ff       	jmp    801081b7 <alltraps>

80108a76 <vector71>:
.globl vector71
vector71:
  pushl $0
80108a76:	6a 00                	push   $0x0
  pushl $71
80108a78:	6a 47                	push   $0x47
  jmp alltraps
80108a7a:	e9 38 f7 ff ff       	jmp    801081b7 <alltraps>

80108a7f <vector72>:
.globl vector72
vector72:
  pushl $0
80108a7f:	6a 00                	push   $0x0
  pushl $72
80108a81:	6a 48                	push   $0x48
  jmp alltraps
80108a83:	e9 2f f7 ff ff       	jmp    801081b7 <alltraps>

80108a88 <vector73>:
.globl vector73
vector73:
  pushl $0
80108a88:	6a 00                	push   $0x0
  pushl $73
80108a8a:	6a 49                	push   $0x49
  jmp alltraps
80108a8c:	e9 26 f7 ff ff       	jmp    801081b7 <alltraps>

80108a91 <vector74>:
.globl vector74
vector74:
  pushl $0
80108a91:	6a 00                	push   $0x0
  pushl $74
80108a93:	6a 4a                	push   $0x4a
  jmp alltraps
80108a95:	e9 1d f7 ff ff       	jmp    801081b7 <alltraps>

80108a9a <vector75>:
.globl vector75
vector75:
  pushl $0
80108a9a:	6a 00                	push   $0x0
  pushl $75
80108a9c:	6a 4b                	push   $0x4b
  jmp alltraps
80108a9e:	e9 14 f7 ff ff       	jmp    801081b7 <alltraps>

80108aa3 <vector76>:
.globl vector76
vector76:
  pushl $0
80108aa3:	6a 00                	push   $0x0
  pushl $76
80108aa5:	6a 4c                	push   $0x4c
  jmp alltraps
80108aa7:	e9 0b f7 ff ff       	jmp    801081b7 <alltraps>

80108aac <vector77>:
.globl vector77
vector77:
  pushl $0
80108aac:	6a 00                	push   $0x0
  pushl $77
80108aae:	6a 4d                	push   $0x4d
  jmp alltraps
80108ab0:	e9 02 f7 ff ff       	jmp    801081b7 <alltraps>

80108ab5 <vector78>:
.globl vector78
vector78:
  pushl $0
80108ab5:	6a 00                	push   $0x0
  pushl $78
80108ab7:	6a 4e                	push   $0x4e
  jmp alltraps
80108ab9:	e9 f9 f6 ff ff       	jmp    801081b7 <alltraps>

80108abe <vector79>:
.globl vector79
vector79:
  pushl $0
80108abe:	6a 00                	push   $0x0
  pushl $79
80108ac0:	6a 4f                	push   $0x4f
  jmp alltraps
80108ac2:	e9 f0 f6 ff ff       	jmp    801081b7 <alltraps>

80108ac7 <vector80>:
.globl vector80
vector80:
  pushl $0
80108ac7:	6a 00                	push   $0x0
  pushl $80
80108ac9:	6a 50                	push   $0x50
  jmp alltraps
80108acb:	e9 e7 f6 ff ff       	jmp    801081b7 <alltraps>

80108ad0 <vector81>:
.globl vector81
vector81:
  pushl $0
80108ad0:	6a 00                	push   $0x0
  pushl $81
80108ad2:	6a 51                	push   $0x51
  jmp alltraps
80108ad4:	e9 de f6 ff ff       	jmp    801081b7 <alltraps>

80108ad9 <vector82>:
.globl vector82
vector82:
  pushl $0
80108ad9:	6a 00                	push   $0x0
  pushl $82
80108adb:	6a 52                	push   $0x52
  jmp alltraps
80108add:	e9 d5 f6 ff ff       	jmp    801081b7 <alltraps>

80108ae2 <vector83>:
.globl vector83
vector83:
  pushl $0
80108ae2:	6a 00                	push   $0x0
  pushl $83
80108ae4:	6a 53                	push   $0x53
  jmp alltraps
80108ae6:	e9 cc f6 ff ff       	jmp    801081b7 <alltraps>

80108aeb <vector84>:
.globl vector84
vector84:
  pushl $0
80108aeb:	6a 00                	push   $0x0
  pushl $84
80108aed:	6a 54                	push   $0x54
  jmp alltraps
80108aef:	e9 c3 f6 ff ff       	jmp    801081b7 <alltraps>

80108af4 <vector85>:
.globl vector85
vector85:
  pushl $0
80108af4:	6a 00                	push   $0x0
  pushl $85
80108af6:	6a 55                	push   $0x55
  jmp alltraps
80108af8:	e9 ba f6 ff ff       	jmp    801081b7 <alltraps>

80108afd <vector86>:
.globl vector86
vector86:
  pushl $0
80108afd:	6a 00                	push   $0x0
  pushl $86
80108aff:	6a 56                	push   $0x56
  jmp alltraps
80108b01:	e9 b1 f6 ff ff       	jmp    801081b7 <alltraps>

80108b06 <vector87>:
.globl vector87
vector87:
  pushl $0
80108b06:	6a 00                	push   $0x0
  pushl $87
80108b08:	6a 57                	push   $0x57
  jmp alltraps
80108b0a:	e9 a8 f6 ff ff       	jmp    801081b7 <alltraps>

80108b0f <vector88>:
.globl vector88
vector88:
  pushl $0
80108b0f:	6a 00                	push   $0x0
  pushl $88
80108b11:	6a 58                	push   $0x58
  jmp alltraps
80108b13:	e9 9f f6 ff ff       	jmp    801081b7 <alltraps>

80108b18 <vector89>:
.globl vector89
vector89:
  pushl $0
80108b18:	6a 00                	push   $0x0
  pushl $89
80108b1a:	6a 59                	push   $0x59
  jmp alltraps
80108b1c:	e9 96 f6 ff ff       	jmp    801081b7 <alltraps>

80108b21 <vector90>:
.globl vector90
vector90:
  pushl $0
80108b21:	6a 00                	push   $0x0
  pushl $90
80108b23:	6a 5a                	push   $0x5a
  jmp alltraps
80108b25:	e9 8d f6 ff ff       	jmp    801081b7 <alltraps>

80108b2a <vector91>:
.globl vector91
vector91:
  pushl $0
80108b2a:	6a 00                	push   $0x0
  pushl $91
80108b2c:	6a 5b                	push   $0x5b
  jmp alltraps
80108b2e:	e9 84 f6 ff ff       	jmp    801081b7 <alltraps>

80108b33 <vector92>:
.globl vector92
vector92:
  pushl $0
80108b33:	6a 00                	push   $0x0
  pushl $92
80108b35:	6a 5c                	push   $0x5c
  jmp alltraps
80108b37:	e9 7b f6 ff ff       	jmp    801081b7 <alltraps>

80108b3c <vector93>:
.globl vector93
vector93:
  pushl $0
80108b3c:	6a 00                	push   $0x0
  pushl $93
80108b3e:	6a 5d                	push   $0x5d
  jmp alltraps
80108b40:	e9 72 f6 ff ff       	jmp    801081b7 <alltraps>

80108b45 <vector94>:
.globl vector94
vector94:
  pushl $0
80108b45:	6a 00                	push   $0x0
  pushl $94
80108b47:	6a 5e                	push   $0x5e
  jmp alltraps
80108b49:	e9 69 f6 ff ff       	jmp    801081b7 <alltraps>

80108b4e <vector95>:
.globl vector95
vector95:
  pushl $0
80108b4e:	6a 00                	push   $0x0
  pushl $95
80108b50:	6a 5f                	push   $0x5f
  jmp alltraps
80108b52:	e9 60 f6 ff ff       	jmp    801081b7 <alltraps>

80108b57 <vector96>:
.globl vector96
vector96:
  pushl $0
80108b57:	6a 00                	push   $0x0
  pushl $96
80108b59:	6a 60                	push   $0x60
  jmp alltraps
80108b5b:	e9 57 f6 ff ff       	jmp    801081b7 <alltraps>

80108b60 <vector97>:
.globl vector97
vector97:
  pushl $0
80108b60:	6a 00                	push   $0x0
  pushl $97
80108b62:	6a 61                	push   $0x61
  jmp alltraps
80108b64:	e9 4e f6 ff ff       	jmp    801081b7 <alltraps>

80108b69 <vector98>:
.globl vector98
vector98:
  pushl $0
80108b69:	6a 00                	push   $0x0
  pushl $98
80108b6b:	6a 62                	push   $0x62
  jmp alltraps
80108b6d:	e9 45 f6 ff ff       	jmp    801081b7 <alltraps>

80108b72 <vector99>:
.globl vector99
vector99:
  pushl $0
80108b72:	6a 00                	push   $0x0
  pushl $99
80108b74:	6a 63                	push   $0x63
  jmp alltraps
80108b76:	e9 3c f6 ff ff       	jmp    801081b7 <alltraps>

80108b7b <vector100>:
.globl vector100
vector100:
  pushl $0
80108b7b:	6a 00                	push   $0x0
  pushl $100
80108b7d:	6a 64                	push   $0x64
  jmp alltraps
80108b7f:	e9 33 f6 ff ff       	jmp    801081b7 <alltraps>

80108b84 <vector101>:
.globl vector101
vector101:
  pushl $0
80108b84:	6a 00                	push   $0x0
  pushl $101
80108b86:	6a 65                	push   $0x65
  jmp alltraps
80108b88:	e9 2a f6 ff ff       	jmp    801081b7 <alltraps>

80108b8d <vector102>:
.globl vector102
vector102:
  pushl $0
80108b8d:	6a 00                	push   $0x0
  pushl $102
80108b8f:	6a 66                	push   $0x66
  jmp alltraps
80108b91:	e9 21 f6 ff ff       	jmp    801081b7 <alltraps>

80108b96 <vector103>:
.globl vector103
vector103:
  pushl $0
80108b96:	6a 00                	push   $0x0
  pushl $103
80108b98:	6a 67                	push   $0x67
  jmp alltraps
80108b9a:	e9 18 f6 ff ff       	jmp    801081b7 <alltraps>

80108b9f <vector104>:
.globl vector104
vector104:
  pushl $0
80108b9f:	6a 00                	push   $0x0
  pushl $104
80108ba1:	6a 68                	push   $0x68
  jmp alltraps
80108ba3:	e9 0f f6 ff ff       	jmp    801081b7 <alltraps>

80108ba8 <vector105>:
.globl vector105
vector105:
  pushl $0
80108ba8:	6a 00                	push   $0x0
  pushl $105
80108baa:	6a 69                	push   $0x69
  jmp alltraps
80108bac:	e9 06 f6 ff ff       	jmp    801081b7 <alltraps>

80108bb1 <vector106>:
.globl vector106
vector106:
  pushl $0
80108bb1:	6a 00                	push   $0x0
  pushl $106
80108bb3:	6a 6a                	push   $0x6a
  jmp alltraps
80108bb5:	e9 fd f5 ff ff       	jmp    801081b7 <alltraps>

80108bba <vector107>:
.globl vector107
vector107:
  pushl $0
80108bba:	6a 00                	push   $0x0
  pushl $107
80108bbc:	6a 6b                	push   $0x6b
  jmp alltraps
80108bbe:	e9 f4 f5 ff ff       	jmp    801081b7 <alltraps>

80108bc3 <vector108>:
.globl vector108
vector108:
  pushl $0
80108bc3:	6a 00                	push   $0x0
  pushl $108
80108bc5:	6a 6c                	push   $0x6c
  jmp alltraps
80108bc7:	e9 eb f5 ff ff       	jmp    801081b7 <alltraps>

80108bcc <vector109>:
.globl vector109
vector109:
  pushl $0
80108bcc:	6a 00                	push   $0x0
  pushl $109
80108bce:	6a 6d                	push   $0x6d
  jmp alltraps
80108bd0:	e9 e2 f5 ff ff       	jmp    801081b7 <alltraps>

80108bd5 <vector110>:
.globl vector110
vector110:
  pushl $0
80108bd5:	6a 00                	push   $0x0
  pushl $110
80108bd7:	6a 6e                	push   $0x6e
  jmp alltraps
80108bd9:	e9 d9 f5 ff ff       	jmp    801081b7 <alltraps>

80108bde <vector111>:
.globl vector111
vector111:
  pushl $0
80108bde:	6a 00                	push   $0x0
  pushl $111
80108be0:	6a 6f                	push   $0x6f
  jmp alltraps
80108be2:	e9 d0 f5 ff ff       	jmp    801081b7 <alltraps>

80108be7 <vector112>:
.globl vector112
vector112:
  pushl $0
80108be7:	6a 00                	push   $0x0
  pushl $112
80108be9:	6a 70                	push   $0x70
  jmp alltraps
80108beb:	e9 c7 f5 ff ff       	jmp    801081b7 <alltraps>

80108bf0 <vector113>:
.globl vector113
vector113:
  pushl $0
80108bf0:	6a 00                	push   $0x0
  pushl $113
80108bf2:	6a 71                	push   $0x71
  jmp alltraps
80108bf4:	e9 be f5 ff ff       	jmp    801081b7 <alltraps>

80108bf9 <vector114>:
.globl vector114
vector114:
  pushl $0
80108bf9:	6a 00                	push   $0x0
  pushl $114
80108bfb:	6a 72                	push   $0x72
  jmp alltraps
80108bfd:	e9 b5 f5 ff ff       	jmp    801081b7 <alltraps>

80108c02 <vector115>:
.globl vector115
vector115:
  pushl $0
80108c02:	6a 00                	push   $0x0
  pushl $115
80108c04:	6a 73                	push   $0x73
  jmp alltraps
80108c06:	e9 ac f5 ff ff       	jmp    801081b7 <alltraps>

80108c0b <vector116>:
.globl vector116
vector116:
  pushl $0
80108c0b:	6a 00                	push   $0x0
  pushl $116
80108c0d:	6a 74                	push   $0x74
  jmp alltraps
80108c0f:	e9 a3 f5 ff ff       	jmp    801081b7 <alltraps>

80108c14 <vector117>:
.globl vector117
vector117:
  pushl $0
80108c14:	6a 00                	push   $0x0
  pushl $117
80108c16:	6a 75                	push   $0x75
  jmp alltraps
80108c18:	e9 9a f5 ff ff       	jmp    801081b7 <alltraps>

80108c1d <vector118>:
.globl vector118
vector118:
  pushl $0
80108c1d:	6a 00                	push   $0x0
  pushl $118
80108c1f:	6a 76                	push   $0x76
  jmp alltraps
80108c21:	e9 91 f5 ff ff       	jmp    801081b7 <alltraps>

80108c26 <vector119>:
.globl vector119
vector119:
  pushl $0
80108c26:	6a 00                	push   $0x0
  pushl $119
80108c28:	6a 77                	push   $0x77
  jmp alltraps
80108c2a:	e9 88 f5 ff ff       	jmp    801081b7 <alltraps>

80108c2f <vector120>:
.globl vector120
vector120:
  pushl $0
80108c2f:	6a 00                	push   $0x0
  pushl $120
80108c31:	6a 78                	push   $0x78
  jmp alltraps
80108c33:	e9 7f f5 ff ff       	jmp    801081b7 <alltraps>

80108c38 <vector121>:
.globl vector121
vector121:
  pushl $0
80108c38:	6a 00                	push   $0x0
  pushl $121
80108c3a:	6a 79                	push   $0x79
  jmp alltraps
80108c3c:	e9 76 f5 ff ff       	jmp    801081b7 <alltraps>

80108c41 <vector122>:
.globl vector122
vector122:
  pushl $0
80108c41:	6a 00                	push   $0x0
  pushl $122
80108c43:	6a 7a                	push   $0x7a
  jmp alltraps
80108c45:	e9 6d f5 ff ff       	jmp    801081b7 <alltraps>

80108c4a <vector123>:
.globl vector123
vector123:
  pushl $0
80108c4a:	6a 00                	push   $0x0
  pushl $123
80108c4c:	6a 7b                	push   $0x7b
  jmp alltraps
80108c4e:	e9 64 f5 ff ff       	jmp    801081b7 <alltraps>

80108c53 <vector124>:
.globl vector124
vector124:
  pushl $0
80108c53:	6a 00                	push   $0x0
  pushl $124
80108c55:	6a 7c                	push   $0x7c
  jmp alltraps
80108c57:	e9 5b f5 ff ff       	jmp    801081b7 <alltraps>

80108c5c <vector125>:
.globl vector125
vector125:
  pushl $0
80108c5c:	6a 00                	push   $0x0
  pushl $125
80108c5e:	6a 7d                	push   $0x7d
  jmp alltraps
80108c60:	e9 52 f5 ff ff       	jmp    801081b7 <alltraps>

80108c65 <vector126>:
.globl vector126
vector126:
  pushl $0
80108c65:	6a 00                	push   $0x0
  pushl $126
80108c67:	6a 7e                	push   $0x7e
  jmp alltraps
80108c69:	e9 49 f5 ff ff       	jmp    801081b7 <alltraps>

80108c6e <vector127>:
.globl vector127
vector127:
  pushl $0
80108c6e:	6a 00                	push   $0x0
  pushl $127
80108c70:	6a 7f                	push   $0x7f
  jmp alltraps
80108c72:	e9 40 f5 ff ff       	jmp    801081b7 <alltraps>

80108c77 <vector128>:
.globl vector128
vector128:
  pushl $0
80108c77:	6a 00                	push   $0x0
  pushl $128
80108c79:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108c7e:	e9 34 f5 ff ff       	jmp    801081b7 <alltraps>

80108c83 <vector129>:
.globl vector129
vector129:
  pushl $0
80108c83:	6a 00                	push   $0x0
  pushl $129
80108c85:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108c8a:	e9 28 f5 ff ff       	jmp    801081b7 <alltraps>

80108c8f <vector130>:
.globl vector130
vector130:
  pushl $0
80108c8f:	6a 00                	push   $0x0
  pushl $130
80108c91:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108c96:	e9 1c f5 ff ff       	jmp    801081b7 <alltraps>

80108c9b <vector131>:
.globl vector131
vector131:
  pushl $0
80108c9b:	6a 00                	push   $0x0
  pushl $131
80108c9d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108ca2:	e9 10 f5 ff ff       	jmp    801081b7 <alltraps>

80108ca7 <vector132>:
.globl vector132
vector132:
  pushl $0
80108ca7:	6a 00                	push   $0x0
  pushl $132
80108ca9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108cae:	e9 04 f5 ff ff       	jmp    801081b7 <alltraps>

80108cb3 <vector133>:
.globl vector133
vector133:
  pushl $0
80108cb3:	6a 00                	push   $0x0
  pushl $133
80108cb5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108cba:	e9 f8 f4 ff ff       	jmp    801081b7 <alltraps>

80108cbf <vector134>:
.globl vector134
vector134:
  pushl $0
80108cbf:	6a 00                	push   $0x0
  pushl $134
80108cc1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108cc6:	e9 ec f4 ff ff       	jmp    801081b7 <alltraps>

80108ccb <vector135>:
.globl vector135
vector135:
  pushl $0
80108ccb:	6a 00                	push   $0x0
  pushl $135
80108ccd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108cd2:	e9 e0 f4 ff ff       	jmp    801081b7 <alltraps>

80108cd7 <vector136>:
.globl vector136
vector136:
  pushl $0
80108cd7:	6a 00                	push   $0x0
  pushl $136
80108cd9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108cde:	e9 d4 f4 ff ff       	jmp    801081b7 <alltraps>

80108ce3 <vector137>:
.globl vector137
vector137:
  pushl $0
80108ce3:	6a 00                	push   $0x0
  pushl $137
80108ce5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108cea:	e9 c8 f4 ff ff       	jmp    801081b7 <alltraps>

80108cef <vector138>:
.globl vector138
vector138:
  pushl $0
80108cef:	6a 00                	push   $0x0
  pushl $138
80108cf1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108cf6:	e9 bc f4 ff ff       	jmp    801081b7 <alltraps>

80108cfb <vector139>:
.globl vector139
vector139:
  pushl $0
80108cfb:	6a 00                	push   $0x0
  pushl $139
80108cfd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108d02:	e9 b0 f4 ff ff       	jmp    801081b7 <alltraps>

80108d07 <vector140>:
.globl vector140
vector140:
  pushl $0
80108d07:	6a 00                	push   $0x0
  pushl $140
80108d09:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108d0e:	e9 a4 f4 ff ff       	jmp    801081b7 <alltraps>

80108d13 <vector141>:
.globl vector141
vector141:
  pushl $0
80108d13:	6a 00                	push   $0x0
  pushl $141
80108d15:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108d1a:	e9 98 f4 ff ff       	jmp    801081b7 <alltraps>

80108d1f <vector142>:
.globl vector142
vector142:
  pushl $0
80108d1f:	6a 00                	push   $0x0
  pushl $142
80108d21:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108d26:	e9 8c f4 ff ff       	jmp    801081b7 <alltraps>

80108d2b <vector143>:
.globl vector143
vector143:
  pushl $0
80108d2b:	6a 00                	push   $0x0
  pushl $143
80108d2d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108d32:	e9 80 f4 ff ff       	jmp    801081b7 <alltraps>

80108d37 <vector144>:
.globl vector144
vector144:
  pushl $0
80108d37:	6a 00                	push   $0x0
  pushl $144
80108d39:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108d3e:	e9 74 f4 ff ff       	jmp    801081b7 <alltraps>

80108d43 <vector145>:
.globl vector145
vector145:
  pushl $0
80108d43:	6a 00                	push   $0x0
  pushl $145
80108d45:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108d4a:	e9 68 f4 ff ff       	jmp    801081b7 <alltraps>

80108d4f <vector146>:
.globl vector146
vector146:
  pushl $0
80108d4f:	6a 00                	push   $0x0
  pushl $146
80108d51:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108d56:	e9 5c f4 ff ff       	jmp    801081b7 <alltraps>

80108d5b <vector147>:
.globl vector147
vector147:
  pushl $0
80108d5b:	6a 00                	push   $0x0
  pushl $147
80108d5d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108d62:	e9 50 f4 ff ff       	jmp    801081b7 <alltraps>

80108d67 <vector148>:
.globl vector148
vector148:
  pushl $0
80108d67:	6a 00                	push   $0x0
  pushl $148
80108d69:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108d6e:	e9 44 f4 ff ff       	jmp    801081b7 <alltraps>

80108d73 <vector149>:
.globl vector149
vector149:
  pushl $0
80108d73:	6a 00                	push   $0x0
  pushl $149
80108d75:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108d7a:	e9 38 f4 ff ff       	jmp    801081b7 <alltraps>

80108d7f <vector150>:
.globl vector150
vector150:
  pushl $0
80108d7f:	6a 00                	push   $0x0
  pushl $150
80108d81:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108d86:	e9 2c f4 ff ff       	jmp    801081b7 <alltraps>

80108d8b <vector151>:
.globl vector151
vector151:
  pushl $0
80108d8b:	6a 00                	push   $0x0
  pushl $151
80108d8d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108d92:	e9 20 f4 ff ff       	jmp    801081b7 <alltraps>

80108d97 <vector152>:
.globl vector152
vector152:
  pushl $0
80108d97:	6a 00                	push   $0x0
  pushl $152
80108d99:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108d9e:	e9 14 f4 ff ff       	jmp    801081b7 <alltraps>

80108da3 <vector153>:
.globl vector153
vector153:
  pushl $0
80108da3:	6a 00                	push   $0x0
  pushl $153
80108da5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108daa:	e9 08 f4 ff ff       	jmp    801081b7 <alltraps>

80108daf <vector154>:
.globl vector154
vector154:
  pushl $0
80108daf:	6a 00                	push   $0x0
  pushl $154
80108db1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108db6:	e9 fc f3 ff ff       	jmp    801081b7 <alltraps>

80108dbb <vector155>:
.globl vector155
vector155:
  pushl $0
80108dbb:	6a 00                	push   $0x0
  pushl $155
80108dbd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108dc2:	e9 f0 f3 ff ff       	jmp    801081b7 <alltraps>

80108dc7 <vector156>:
.globl vector156
vector156:
  pushl $0
80108dc7:	6a 00                	push   $0x0
  pushl $156
80108dc9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108dce:	e9 e4 f3 ff ff       	jmp    801081b7 <alltraps>

80108dd3 <vector157>:
.globl vector157
vector157:
  pushl $0
80108dd3:	6a 00                	push   $0x0
  pushl $157
80108dd5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108dda:	e9 d8 f3 ff ff       	jmp    801081b7 <alltraps>

80108ddf <vector158>:
.globl vector158
vector158:
  pushl $0
80108ddf:	6a 00                	push   $0x0
  pushl $158
80108de1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108de6:	e9 cc f3 ff ff       	jmp    801081b7 <alltraps>

80108deb <vector159>:
.globl vector159
vector159:
  pushl $0
80108deb:	6a 00                	push   $0x0
  pushl $159
80108ded:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108df2:	e9 c0 f3 ff ff       	jmp    801081b7 <alltraps>

80108df7 <vector160>:
.globl vector160
vector160:
  pushl $0
80108df7:	6a 00                	push   $0x0
  pushl $160
80108df9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108dfe:	e9 b4 f3 ff ff       	jmp    801081b7 <alltraps>

80108e03 <vector161>:
.globl vector161
vector161:
  pushl $0
80108e03:	6a 00                	push   $0x0
  pushl $161
80108e05:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108e0a:	e9 a8 f3 ff ff       	jmp    801081b7 <alltraps>

80108e0f <vector162>:
.globl vector162
vector162:
  pushl $0
80108e0f:	6a 00                	push   $0x0
  pushl $162
80108e11:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108e16:	e9 9c f3 ff ff       	jmp    801081b7 <alltraps>

80108e1b <vector163>:
.globl vector163
vector163:
  pushl $0
80108e1b:	6a 00                	push   $0x0
  pushl $163
80108e1d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108e22:	e9 90 f3 ff ff       	jmp    801081b7 <alltraps>

80108e27 <vector164>:
.globl vector164
vector164:
  pushl $0
80108e27:	6a 00                	push   $0x0
  pushl $164
80108e29:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108e2e:	e9 84 f3 ff ff       	jmp    801081b7 <alltraps>

80108e33 <vector165>:
.globl vector165
vector165:
  pushl $0
80108e33:	6a 00                	push   $0x0
  pushl $165
80108e35:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108e3a:	e9 78 f3 ff ff       	jmp    801081b7 <alltraps>

80108e3f <vector166>:
.globl vector166
vector166:
  pushl $0
80108e3f:	6a 00                	push   $0x0
  pushl $166
80108e41:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108e46:	e9 6c f3 ff ff       	jmp    801081b7 <alltraps>

80108e4b <vector167>:
.globl vector167
vector167:
  pushl $0
80108e4b:	6a 00                	push   $0x0
  pushl $167
80108e4d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108e52:	e9 60 f3 ff ff       	jmp    801081b7 <alltraps>

80108e57 <vector168>:
.globl vector168
vector168:
  pushl $0
80108e57:	6a 00                	push   $0x0
  pushl $168
80108e59:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108e5e:	e9 54 f3 ff ff       	jmp    801081b7 <alltraps>

80108e63 <vector169>:
.globl vector169
vector169:
  pushl $0
80108e63:	6a 00                	push   $0x0
  pushl $169
80108e65:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108e6a:	e9 48 f3 ff ff       	jmp    801081b7 <alltraps>

80108e6f <vector170>:
.globl vector170
vector170:
  pushl $0
80108e6f:	6a 00                	push   $0x0
  pushl $170
80108e71:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108e76:	e9 3c f3 ff ff       	jmp    801081b7 <alltraps>

80108e7b <vector171>:
.globl vector171
vector171:
  pushl $0
80108e7b:	6a 00                	push   $0x0
  pushl $171
80108e7d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108e82:	e9 30 f3 ff ff       	jmp    801081b7 <alltraps>

80108e87 <vector172>:
.globl vector172
vector172:
  pushl $0
80108e87:	6a 00                	push   $0x0
  pushl $172
80108e89:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108e8e:	e9 24 f3 ff ff       	jmp    801081b7 <alltraps>

80108e93 <vector173>:
.globl vector173
vector173:
  pushl $0
80108e93:	6a 00                	push   $0x0
  pushl $173
80108e95:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108e9a:	e9 18 f3 ff ff       	jmp    801081b7 <alltraps>

80108e9f <vector174>:
.globl vector174
vector174:
  pushl $0
80108e9f:	6a 00                	push   $0x0
  pushl $174
80108ea1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108ea6:	e9 0c f3 ff ff       	jmp    801081b7 <alltraps>

80108eab <vector175>:
.globl vector175
vector175:
  pushl $0
80108eab:	6a 00                	push   $0x0
  pushl $175
80108ead:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108eb2:	e9 00 f3 ff ff       	jmp    801081b7 <alltraps>

80108eb7 <vector176>:
.globl vector176
vector176:
  pushl $0
80108eb7:	6a 00                	push   $0x0
  pushl $176
80108eb9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108ebe:	e9 f4 f2 ff ff       	jmp    801081b7 <alltraps>

80108ec3 <vector177>:
.globl vector177
vector177:
  pushl $0
80108ec3:	6a 00                	push   $0x0
  pushl $177
80108ec5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108eca:	e9 e8 f2 ff ff       	jmp    801081b7 <alltraps>

80108ecf <vector178>:
.globl vector178
vector178:
  pushl $0
80108ecf:	6a 00                	push   $0x0
  pushl $178
80108ed1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108ed6:	e9 dc f2 ff ff       	jmp    801081b7 <alltraps>

80108edb <vector179>:
.globl vector179
vector179:
  pushl $0
80108edb:	6a 00                	push   $0x0
  pushl $179
80108edd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108ee2:	e9 d0 f2 ff ff       	jmp    801081b7 <alltraps>

80108ee7 <vector180>:
.globl vector180
vector180:
  pushl $0
80108ee7:	6a 00                	push   $0x0
  pushl $180
80108ee9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108eee:	e9 c4 f2 ff ff       	jmp    801081b7 <alltraps>

80108ef3 <vector181>:
.globl vector181
vector181:
  pushl $0
80108ef3:	6a 00                	push   $0x0
  pushl $181
80108ef5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108efa:	e9 b8 f2 ff ff       	jmp    801081b7 <alltraps>

80108eff <vector182>:
.globl vector182
vector182:
  pushl $0
80108eff:	6a 00                	push   $0x0
  pushl $182
80108f01:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108f06:	e9 ac f2 ff ff       	jmp    801081b7 <alltraps>

80108f0b <vector183>:
.globl vector183
vector183:
  pushl $0
80108f0b:	6a 00                	push   $0x0
  pushl $183
80108f0d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108f12:	e9 a0 f2 ff ff       	jmp    801081b7 <alltraps>

80108f17 <vector184>:
.globl vector184
vector184:
  pushl $0
80108f17:	6a 00                	push   $0x0
  pushl $184
80108f19:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108f1e:	e9 94 f2 ff ff       	jmp    801081b7 <alltraps>

80108f23 <vector185>:
.globl vector185
vector185:
  pushl $0
80108f23:	6a 00                	push   $0x0
  pushl $185
80108f25:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108f2a:	e9 88 f2 ff ff       	jmp    801081b7 <alltraps>

80108f2f <vector186>:
.globl vector186
vector186:
  pushl $0
80108f2f:	6a 00                	push   $0x0
  pushl $186
80108f31:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108f36:	e9 7c f2 ff ff       	jmp    801081b7 <alltraps>

80108f3b <vector187>:
.globl vector187
vector187:
  pushl $0
80108f3b:	6a 00                	push   $0x0
  pushl $187
80108f3d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108f42:	e9 70 f2 ff ff       	jmp    801081b7 <alltraps>

80108f47 <vector188>:
.globl vector188
vector188:
  pushl $0
80108f47:	6a 00                	push   $0x0
  pushl $188
80108f49:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108f4e:	e9 64 f2 ff ff       	jmp    801081b7 <alltraps>

80108f53 <vector189>:
.globl vector189
vector189:
  pushl $0
80108f53:	6a 00                	push   $0x0
  pushl $189
80108f55:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108f5a:	e9 58 f2 ff ff       	jmp    801081b7 <alltraps>

80108f5f <vector190>:
.globl vector190
vector190:
  pushl $0
80108f5f:	6a 00                	push   $0x0
  pushl $190
80108f61:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108f66:	e9 4c f2 ff ff       	jmp    801081b7 <alltraps>

80108f6b <vector191>:
.globl vector191
vector191:
  pushl $0
80108f6b:	6a 00                	push   $0x0
  pushl $191
80108f6d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108f72:	e9 40 f2 ff ff       	jmp    801081b7 <alltraps>

80108f77 <vector192>:
.globl vector192
vector192:
  pushl $0
80108f77:	6a 00                	push   $0x0
  pushl $192
80108f79:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108f7e:	e9 34 f2 ff ff       	jmp    801081b7 <alltraps>

80108f83 <vector193>:
.globl vector193
vector193:
  pushl $0
80108f83:	6a 00                	push   $0x0
  pushl $193
80108f85:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108f8a:	e9 28 f2 ff ff       	jmp    801081b7 <alltraps>

80108f8f <vector194>:
.globl vector194
vector194:
  pushl $0
80108f8f:	6a 00                	push   $0x0
  pushl $194
80108f91:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108f96:	e9 1c f2 ff ff       	jmp    801081b7 <alltraps>

80108f9b <vector195>:
.globl vector195
vector195:
  pushl $0
80108f9b:	6a 00                	push   $0x0
  pushl $195
80108f9d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108fa2:	e9 10 f2 ff ff       	jmp    801081b7 <alltraps>

80108fa7 <vector196>:
.globl vector196
vector196:
  pushl $0
80108fa7:	6a 00                	push   $0x0
  pushl $196
80108fa9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108fae:	e9 04 f2 ff ff       	jmp    801081b7 <alltraps>

80108fb3 <vector197>:
.globl vector197
vector197:
  pushl $0
80108fb3:	6a 00                	push   $0x0
  pushl $197
80108fb5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108fba:	e9 f8 f1 ff ff       	jmp    801081b7 <alltraps>

80108fbf <vector198>:
.globl vector198
vector198:
  pushl $0
80108fbf:	6a 00                	push   $0x0
  pushl $198
80108fc1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108fc6:	e9 ec f1 ff ff       	jmp    801081b7 <alltraps>

80108fcb <vector199>:
.globl vector199
vector199:
  pushl $0
80108fcb:	6a 00                	push   $0x0
  pushl $199
80108fcd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108fd2:	e9 e0 f1 ff ff       	jmp    801081b7 <alltraps>

80108fd7 <vector200>:
.globl vector200
vector200:
  pushl $0
80108fd7:	6a 00                	push   $0x0
  pushl $200
80108fd9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108fde:	e9 d4 f1 ff ff       	jmp    801081b7 <alltraps>

80108fe3 <vector201>:
.globl vector201
vector201:
  pushl $0
80108fe3:	6a 00                	push   $0x0
  pushl $201
80108fe5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108fea:	e9 c8 f1 ff ff       	jmp    801081b7 <alltraps>

80108fef <vector202>:
.globl vector202
vector202:
  pushl $0
80108fef:	6a 00                	push   $0x0
  pushl $202
80108ff1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108ff6:	e9 bc f1 ff ff       	jmp    801081b7 <alltraps>

80108ffb <vector203>:
.globl vector203
vector203:
  pushl $0
80108ffb:	6a 00                	push   $0x0
  pushl $203
80108ffd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80109002:	e9 b0 f1 ff ff       	jmp    801081b7 <alltraps>

80109007 <vector204>:
.globl vector204
vector204:
  pushl $0
80109007:	6a 00                	push   $0x0
  pushl $204
80109009:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010900e:	e9 a4 f1 ff ff       	jmp    801081b7 <alltraps>

80109013 <vector205>:
.globl vector205
vector205:
  pushl $0
80109013:	6a 00                	push   $0x0
  pushl $205
80109015:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010901a:	e9 98 f1 ff ff       	jmp    801081b7 <alltraps>

8010901f <vector206>:
.globl vector206
vector206:
  pushl $0
8010901f:	6a 00                	push   $0x0
  pushl $206
80109021:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80109026:	e9 8c f1 ff ff       	jmp    801081b7 <alltraps>

8010902b <vector207>:
.globl vector207
vector207:
  pushl $0
8010902b:	6a 00                	push   $0x0
  pushl $207
8010902d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80109032:	e9 80 f1 ff ff       	jmp    801081b7 <alltraps>

80109037 <vector208>:
.globl vector208
vector208:
  pushl $0
80109037:	6a 00                	push   $0x0
  pushl $208
80109039:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010903e:	e9 74 f1 ff ff       	jmp    801081b7 <alltraps>

80109043 <vector209>:
.globl vector209
vector209:
  pushl $0
80109043:	6a 00                	push   $0x0
  pushl $209
80109045:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010904a:	e9 68 f1 ff ff       	jmp    801081b7 <alltraps>

8010904f <vector210>:
.globl vector210
vector210:
  pushl $0
8010904f:	6a 00                	push   $0x0
  pushl $210
80109051:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80109056:	e9 5c f1 ff ff       	jmp    801081b7 <alltraps>

8010905b <vector211>:
.globl vector211
vector211:
  pushl $0
8010905b:	6a 00                	push   $0x0
  pushl $211
8010905d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80109062:	e9 50 f1 ff ff       	jmp    801081b7 <alltraps>

80109067 <vector212>:
.globl vector212
vector212:
  pushl $0
80109067:	6a 00                	push   $0x0
  pushl $212
80109069:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010906e:	e9 44 f1 ff ff       	jmp    801081b7 <alltraps>

80109073 <vector213>:
.globl vector213
vector213:
  pushl $0
80109073:	6a 00                	push   $0x0
  pushl $213
80109075:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010907a:	e9 38 f1 ff ff       	jmp    801081b7 <alltraps>

8010907f <vector214>:
.globl vector214
vector214:
  pushl $0
8010907f:	6a 00                	push   $0x0
  pushl $214
80109081:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80109086:	e9 2c f1 ff ff       	jmp    801081b7 <alltraps>

8010908b <vector215>:
.globl vector215
vector215:
  pushl $0
8010908b:	6a 00                	push   $0x0
  pushl $215
8010908d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80109092:	e9 20 f1 ff ff       	jmp    801081b7 <alltraps>

80109097 <vector216>:
.globl vector216
vector216:
  pushl $0
80109097:	6a 00                	push   $0x0
  pushl $216
80109099:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010909e:	e9 14 f1 ff ff       	jmp    801081b7 <alltraps>

801090a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801090a3:	6a 00                	push   $0x0
  pushl $217
801090a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801090aa:	e9 08 f1 ff ff       	jmp    801081b7 <alltraps>

801090af <vector218>:
.globl vector218
vector218:
  pushl $0
801090af:	6a 00                	push   $0x0
  pushl $218
801090b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801090b6:	e9 fc f0 ff ff       	jmp    801081b7 <alltraps>

801090bb <vector219>:
.globl vector219
vector219:
  pushl $0
801090bb:	6a 00                	push   $0x0
  pushl $219
801090bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801090c2:	e9 f0 f0 ff ff       	jmp    801081b7 <alltraps>

801090c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801090c7:	6a 00                	push   $0x0
  pushl $220
801090c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801090ce:	e9 e4 f0 ff ff       	jmp    801081b7 <alltraps>

801090d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801090d3:	6a 00                	push   $0x0
  pushl $221
801090d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801090da:	e9 d8 f0 ff ff       	jmp    801081b7 <alltraps>

801090df <vector222>:
.globl vector222
vector222:
  pushl $0
801090df:	6a 00                	push   $0x0
  pushl $222
801090e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801090e6:	e9 cc f0 ff ff       	jmp    801081b7 <alltraps>

801090eb <vector223>:
.globl vector223
vector223:
  pushl $0
801090eb:	6a 00                	push   $0x0
  pushl $223
801090ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801090f2:	e9 c0 f0 ff ff       	jmp    801081b7 <alltraps>

801090f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801090f7:	6a 00                	push   $0x0
  pushl $224
801090f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801090fe:	e9 b4 f0 ff ff       	jmp    801081b7 <alltraps>

80109103 <vector225>:
.globl vector225
vector225:
  pushl $0
80109103:	6a 00                	push   $0x0
  pushl $225
80109105:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010910a:	e9 a8 f0 ff ff       	jmp    801081b7 <alltraps>

8010910f <vector226>:
.globl vector226
vector226:
  pushl $0
8010910f:	6a 00                	push   $0x0
  pushl $226
80109111:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80109116:	e9 9c f0 ff ff       	jmp    801081b7 <alltraps>

8010911b <vector227>:
.globl vector227
vector227:
  pushl $0
8010911b:	6a 00                	push   $0x0
  pushl $227
8010911d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80109122:	e9 90 f0 ff ff       	jmp    801081b7 <alltraps>

80109127 <vector228>:
.globl vector228
vector228:
  pushl $0
80109127:	6a 00                	push   $0x0
  pushl $228
80109129:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010912e:	e9 84 f0 ff ff       	jmp    801081b7 <alltraps>

80109133 <vector229>:
.globl vector229
vector229:
  pushl $0
80109133:	6a 00                	push   $0x0
  pushl $229
80109135:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010913a:	e9 78 f0 ff ff       	jmp    801081b7 <alltraps>

8010913f <vector230>:
.globl vector230
vector230:
  pushl $0
8010913f:	6a 00                	push   $0x0
  pushl $230
80109141:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80109146:	e9 6c f0 ff ff       	jmp    801081b7 <alltraps>

8010914b <vector231>:
.globl vector231
vector231:
  pushl $0
8010914b:	6a 00                	push   $0x0
  pushl $231
8010914d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80109152:	e9 60 f0 ff ff       	jmp    801081b7 <alltraps>

80109157 <vector232>:
.globl vector232
vector232:
  pushl $0
80109157:	6a 00                	push   $0x0
  pushl $232
80109159:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010915e:	e9 54 f0 ff ff       	jmp    801081b7 <alltraps>

80109163 <vector233>:
.globl vector233
vector233:
  pushl $0
80109163:	6a 00                	push   $0x0
  pushl $233
80109165:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010916a:	e9 48 f0 ff ff       	jmp    801081b7 <alltraps>

8010916f <vector234>:
.globl vector234
vector234:
  pushl $0
8010916f:	6a 00                	push   $0x0
  pushl $234
80109171:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109176:	e9 3c f0 ff ff       	jmp    801081b7 <alltraps>

8010917b <vector235>:
.globl vector235
vector235:
  pushl $0
8010917b:	6a 00                	push   $0x0
  pushl $235
8010917d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80109182:	e9 30 f0 ff ff       	jmp    801081b7 <alltraps>

80109187 <vector236>:
.globl vector236
vector236:
  pushl $0
80109187:	6a 00                	push   $0x0
  pushl $236
80109189:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010918e:	e9 24 f0 ff ff       	jmp    801081b7 <alltraps>

80109193 <vector237>:
.globl vector237
vector237:
  pushl $0
80109193:	6a 00                	push   $0x0
  pushl $237
80109195:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010919a:	e9 18 f0 ff ff       	jmp    801081b7 <alltraps>

8010919f <vector238>:
.globl vector238
vector238:
  pushl $0
8010919f:	6a 00                	push   $0x0
  pushl $238
801091a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801091a6:	e9 0c f0 ff ff       	jmp    801081b7 <alltraps>

801091ab <vector239>:
.globl vector239
vector239:
  pushl $0
801091ab:	6a 00                	push   $0x0
  pushl $239
801091ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801091b2:	e9 00 f0 ff ff       	jmp    801081b7 <alltraps>

801091b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801091b7:	6a 00                	push   $0x0
  pushl $240
801091b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801091be:	e9 f4 ef ff ff       	jmp    801081b7 <alltraps>

801091c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801091c3:	6a 00                	push   $0x0
  pushl $241
801091c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801091ca:	e9 e8 ef ff ff       	jmp    801081b7 <alltraps>

801091cf <vector242>:
.globl vector242
vector242:
  pushl $0
801091cf:	6a 00                	push   $0x0
  pushl $242
801091d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801091d6:	e9 dc ef ff ff       	jmp    801081b7 <alltraps>

801091db <vector243>:
.globl vector243
vector243:
  pushl $0
801091db:	6a 00                	push   $0x0
  pushl $243
801091dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801091e2:	e9 d0 ef ff ff       	jmp    801081b7 <alltraps>

801091e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801091e7:	6a 00                	push   $0x0
  pushl $244
801091e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801091ee:	e9 c4 ef ff ff       	jmp    801081b7 <alltraps>

801091f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801091f3:	6a 00                	push   $0x0
  pushl $245
801091f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801091fa:	e9 b8 ef ff ff       	jmp    801081b7 <alltraps>

801091ff <vector246>:
.globl vector246
vector246:
  pushl $0
801091ff:	6a 00                	push   $0x0
  pushl $246
80109201:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80109206:	e9 ac ef ff ff       	jmp    801081b7 <alltraps>

8010920b <vector247>:
.globl vector247
vector247:
  pushl $0
8010920b:	6a 00                	push   $0x0
  pushl $247
8010920d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80109212:	e9 a0 ef ff ff       	jmp    801081b7 <alltraps>

80109217 <vector248>:
.globl vector248
vector248:
  pushl $0
80109217:	6a 00                	push   $0x0
  pushl $248
80109219:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010921e:	e9 94 ef ff ff       	jmp    801081b7 <alltraps>

80109223 <vector249>:
.globl vector249
vector249:
  pushl $0
80109223:	6a 00                	push   $0x0
  pushl $249
80109225:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010922a:	e9 88 ef ff ff       	jmp    801081b7 <alltraps>

8010922f <vector250>:
.globl vector250
vector250:
  pushl $0
8010922f:	6a 00                	push   $0x0
  pushl $250
80109231:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80109236:	e9 7c ef ff ff       	jmp    801081b7 <alltraps>

8010923b <vector251>:
.globl vector251
vector251:
  pushl $0
8010923b:	6a 00                	push   $0x0
  pushl $251
8010923d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80109242:	e9 70 ef ff ff       	jmp    801081b7 <alltraps>

80109247 <vector252>:
.globl vector252
vector252:
  pushl $0
80109247:	6a 00                	push   $0x0
  pushl $252
80109249:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010924e:	e9 64 ef ff ff       	jmp    801081b7 <alltraps>

80109253 <vector253>:
.globl vector253
vector253:
  pushl $0
80109253:	6a 00                	push   $0x0
  pushl $253
80109255:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010925a:	e9 58 ef ff ff       	jmp    801081b7 <alltraps>

8010925f <vector254>:
.globl vector254
vector254:
  pushl $0
8010925f:	6a 00                	push   $0x0
  pushl $254
80109261:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109266:	e9 4c ef ff ff       	jmp    801081b7 <alltraps>

8010926b <vector255>:
.globl vector255
vector255:
  pushl $0
8010926b:	6a 00                	push   $0x0
  pushl $255
8010926d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80109272:	e9 40 ef ff ff       	jmp    801081b7 <alltraps>

80109277 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80109277:	55                   	push   %ebp
80109278:	89 e5                	mov    %esp,%ebp
8010927a:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010927d:	8b 45 0c             	mov    0xc(%ebp),%eax
80109280:	83 e8 01             	sub    $0x1,%eax
80109283:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80109287:	8b 45 08             	mov    0x8(%ebp),%eax
8010928a:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010928e:	8b 45 08             	mov    0x8(%ebp),%eax
80109291:	c1 e8 10             	shr    $0x10,%eax
80109294:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80109298:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010929b:	0f 01 10             	lgdtl  (%eax)
}
8010929e:	90                   	nop
8010929f:	c9                   	leave  
801092a0:	c3                   	ret    

801092a1 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
801092a1:	55                   	push   %ebp
801092a2:	89 e5                	mov    %esp,%ebp
801092a4:	83 ec 04             	sub    $0x4,%esp
801092a7:	8b 45 08             	mov    0x8(%ebp),%eax
801092aa:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801092ae:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801092b2:	0f 00 d8             	ltr    %ax
}
801092b5:	90                   	nop
801092b6:	c9                   	leave  
801092b7:	c3                   	ret    

801092b8 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
801092b8:	55                   	push   %ebp
801092b9:	89 e5                	mov    %esp,%ebp
801092bb:	83 ec 04             	sub    $0x4,%esp
801092be:	8b 45 08             	mov    0x8(%ebp),%eax
801092c1:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
801092c5:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801092c9:	8e e8                	mov    %eax,%gs
}
801092cb:	90                   	nop
801092cc:	c9                   	leave  
801092cd:	c3                   	ret    

801092ce <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801092ce:	55                   	push   %ebp
801092cf:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801092d1:	8b 45 08             	mov    0x8(%ebp),%eax
801092d4:	0f 22 d8             	mov    %eax,%cr3
}
801092d7:	90                   	nop
801092d8:	5d                   	pop    %ebp
801092d9:	c3                   	ret    

801092da <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801092da:	55                   	push   %ebp
801092db:	89 e5                	mov    %esp,%ebp
801092dd:	8b 45 08             	mov    0x8(%ebp),%eax
801092e0:	05 00 00 00 80       	add    $0x80000000,%eax
801092e5:	5d                   	pop    %ebp
801092e6:	c3                   	ret    

801092e7 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801092e7:	55                   	push   %ebp
801092e8:	89 e5                	mov    %esp,%ebp
801092ea:	8b 45 08             	mov    0x8(%ebp),%eax
801092ed:	05 00 00 00 80       	add    $0x80000000,%eax
801092f2:	5d                   	pop    %ebp
801092f3:	c3                   	ret    

801092f4 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801092f4:	55                   	push   %ebp
801092f5:	89 e5                	mov    %esp,%ebp
801092f7:	53                   	push   %ebx
801092f8:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801092fb:	e8 01 a2 ff ff       	call   80103501 <cpunum>
80109300:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80109306:	05 a0 43 11 80       	add    $0x801143a0,%eax
8010930b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010930e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109311:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80109317:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010931a:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80109320:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109323:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80109327:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010932a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010932e:	83 e2 f0             	and    $0xfffffff0,%edx
80109331:	83 ca 0a             	or     $0xa,%edx
80109334:	88 50 7d             	mov    %dl,0x7d(%eax)
80109337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933a:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010933e:	83 ca 10             	or     $0x10,%edx
80109341:	88 50 7d             	mov    %dl,0x7d(%eax)
80109344:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109347:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010934b:	83 e2 9f             	and    $0xffffff9f,%edx
8010934e:	88 50 7d             	mov    %dl,0x7d(%eax)
80109351:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109354:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109358:	83 ca 80             	or     $0xffffff80,%edx
8010935b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010935e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109361:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109365:	83 ca 0f             	or     $0xf,%edx
80109368:	88 50 7e             	mov    %dl,0x7e(%eax)
8010936b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010936e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109372:	83 e2 ef             	and    $0xffffffef,%edx
80109375:	88 50 7e             	mov    %dl,0x7e(%eax)
80109378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010937f:	83 e2 df             	and    $0xffffffdf,%edx
80109382:	88 50 7e             	mov    %dl,0x7e(%eax)
80109385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109388:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010938c:	83 ca 40             	or     $0x40,%edx
8010938f:	88 50 7e             	mov    %dl,0x7e(%eax)
80109392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109395:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109399:	83 ca 80             	or     $0xffffff80,%edx
8010939c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010939f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a2:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801093a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a9:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801093b0:	ff ff 
801093b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093b5:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801093bc:	00 00 
801093be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093c1:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801093c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093cb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093d2:	83 e2 f0             	and    $0xfffffff0,%edx
801093d5:	83 ca 02             	or     $0x2,%edx
801093d8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093e8:	83 ca 10             	or     $0x10,%edx
801093eb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f4:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093fb:	83 e2 9f             	and    $0xffffff9f,%edx
801093fe:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109407:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010940e:	83 ca 80             	or     $0xffffff80,%edx
80109411:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80109417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109421:	83 ca 0f             	or     $0xf,%edx
80109424:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010942a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010942d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109434:	83 e2 ef             	and    $0xffffffef,%edx
80109437:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010943d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109440:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109447:	83 e2 df             	and    $0xffffffdf,%edx
8010944a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109453:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010945a:	83 ca 40             	or     $0x40,%edx
8010945d:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109463:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109466:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010946d:	83 ca 80             	or     $0xffffff80,%edx
80109470:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109476:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109479:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80109480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109483:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
8010948a:	ff ff 
8010948c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010948f:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109496:	00 00 
80109498:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010949b:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801094a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a5:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094ac:	83 e2 f0             	and    $0xfffffff0,%edx
801094af:	83 ca 0a             	or     $0xa,%edx
801094b2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094c2:	83 ca 10             	or     $0x10,%edx
801094c5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ce:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094d5:	83 ca 60             	or     $0x60,%edx
801094d8:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e1:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094e8:	83 ca 80             	or     $0xffffff80,%edx
801094eb:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801094fb:	83 ca 0f             	or     $0xf,%edx
801094fe:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109507:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010950e:	83 e2 ef             	and    $0xffffffef,%edx
80109511:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010951a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109521:	83 e2 df             	and    $0xffffffdf,%edx
80109524:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010952a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010952d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109534:	83 ca 40             	or     $0x40,%edx
80109537:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010953d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109540:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109547:	83 ca 80             	or     $0xffffff80,%edx
8010954a:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109550:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109553:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010955a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010955d:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80109564:	ff ff 
80109566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109569:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80109570:	00 00 
80109572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109575:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
8010957c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010957f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109586:	83 e2 f0             	and    $0xfffffff0,%edx
80109589:	83 ca 02             	or     $0x2,%edx
8010958c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109595:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010959c:	83 ca 10             	or     $0x10,%edx
8010959f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801095a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095a8:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801095af:	83 ca 60             	or     $0x60,%edx
801095b2:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801095b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095bb:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801095c2:	83 ca 80             	or     $0xffffff80,%edx
801095c5:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801095cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ce:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095d5:	83 ca 0f             	or     $0xf,%edx
801095d8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095e8:	83 e2 ef             	and    $0xffffffef,%edx
801095eb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095fb:	83 e2 df             	and    $0xffffffdf,%edx
801095fe:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109607:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010960e:	83 ca 40             	or     $0x40,%edx
80109611:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109617:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010961a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80109621:	83 ca 80             	or     $0xffffff80,%edx
80109624:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010962a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010962d:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80109634:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109637:	05 b4 00 00 00       	add    $0xb4,%eax
8010963c:	89 c3                	mov    %eax,%ebx
8010963e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109641:	05 b4 00 00 00       	add    $0xb4,%eax
80109646:	c1 e8 10             	shr    $0x10,%eax
80109649:	89 c2                	mov    %eax,%edx
8010964b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010964e:	05 b4 00 00 00       	add    $0xb4,%eax
80109653:	c1 e8 18             	shr    $0x18,%eax
80109656:	89 c1                	mov    %eax,%ecx
80109658:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010965b:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80109662:	00 00 
80109664:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109667:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
8010966e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109671:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80109677:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010967a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109681:	83 e2 f0             	and    $0xfffffff0,%edx
80109684:	83 ca 02             	or     $0x2,%edx
80109687:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010968d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109690:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109697:	83 ca 10             	or     $0x10,%edx
8010969a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a3:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801096aa:	83 e2 9f             	and    $0xffffff9f,%edx
801096ad:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b6:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801096bd:	83 ca 80             	or     $0xffffff80,%edx
801096c0:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096c9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096d0:	83 e2 f0             	and    $0xfffffff0,%edx
801096d3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096dc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096e3:	83 e2 ef             	and    $0xffffffef,%edx
801096e6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ef:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096f6:	83 e2 df             	and    $0xffffffdf,%edx
801096f9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109702:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80109709:	83 ca 40             	or     $0x40,%edx
8010970c:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109715:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
8010971c:	83 ca 80             	or     $0xffffff80,%edx
8010971f:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80109725:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109728:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010972e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109731:	83 c0 70             	add    $0x70,%eax
80109734:	83 ec 08             	sub    $0x8,%esp
80109737:	6a 38                	push   $0x38
80109739:	50                   	push   %eax
8010973a:	e8 38 fb ff ff       	call   80109277 <lgdt>
8010973f:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80109742:	83 ec 0c             	sub    $0xc,%esp
80109745:	6a 18                	push   $0x18
80109747:	e8 6c fb ff ff       	call   801092b8 <loadgs>
8010974c:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
8010974f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109752:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109758:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
8010975f:	00 00 00 00 
}
80109763:	90                   	nop
80109764:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109767:	c9                   	leave  
80109768:	c3                   	ret    

80109769 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80109769:	55                   	push   %ebp
8010976a:	89 e5                	mov    %esp,%ebp
8010976c:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010976f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109772:	c1 e8 16             	shr    $0x16,%eax
80109775:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010977c:	8b 45 08             	mov    0x8(%ebp),%eax
8010977f:	01 d0                	add    %edx,%eax
80109781:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80109784:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109787:	8b 00                	mov    (%eax),%eax
80109789:	83 e0 01             	and    $0x1,%eax
8010978c:	85 c0                	test   %eax,%eax
8010978e:	74 18                	je     801097a8 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80109790:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109793:	8b 00                	mov    (%eax),%eax
80109795:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010979a:	50                   	push   %eax
8010979b:	e8 47 fb ff ff       	call   801092e7 <p2v>
801097a0:	83 c4 04             	add    $0x4,%esp
801097a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801097a6:	eb 48                	jmp    801097f0 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801097a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801097ac:	74 0e                	je     801097bc <walkpgdir+0x53>
801097ae:	e8 e8 99 ff ff       	call   8010319b <kalloc>
801097b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801097b6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801097ba:	75 07                	jne    801097c3 <walkpgdir+0x5a>
      return 0;
801097bc:	b8 00 00 00 00       	mov    $0x0,%eax
801097c1:	eb 44                	jmp    80109807 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
801097c3:	83 ec 04             	sub    $0x4,%esp
801097c6:	68 00 10 00 00       	push   $0x1000
801097cb:	6a 00                	push   $0x0
801097cd:	ff 75 f4             	pushl  -0xc(%ebp)
801097d0:	e8 12 d3 ff ff       	call   80106ae7 <memset>
801097d5:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801097d8:	83 ec 0c             	sub    $0xc,%esp
801097db:	ff 75 f4             	pushl  -0xc(%ebp)
801097de:	e8 f7 fa ff ff       	call   801092da <v2p>
801097e3:	83 c4 10             	add    $0x10,%esp
801097e6:	83 c8 07             	or     $0x7,%eax
801097e9:	89 c2                	mov    %eax,%edx
801097eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097ee:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801097f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801097f3:	c1 e8 0c             	shr    $0xc,%eax
801097f6:	25 ff 03 00 00       	and    $0x3ff,%eax
801097fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109805:	01 d0                	add    %edx,%eax
}
80109807:	c9                   	leave  
80109808:	c3                   	ret    

80109809 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80109809:	55                   	push   %ebp
8010980a:	89 e5                	mov    %esp,%ebp
8010980c:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010980f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109812:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109817:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010981a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010981d:	8b 45 10             	mov    0x10(%ebp),%eax
80109820:	01 d0                	add    %edx,%eax
80109822:	83 e8 01             	sub    $0x1,%eax
80109825:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010982a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010982d:	83 ec 04             	sub    $0x4,%esp
80109830:	6a 01                	push   $0x1
80109832:	ff 75 f4             	pushl  -0xc(%ebp)
80109835:	ff 75 08             	pushl  0x8(%ebp)
80109838:	e8 2c ff ff ff       	call   80109769 <walkpgdir>
8010983d:	83 c4 10             	add    $0x10,%esp
80109840:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109843:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109847:	75 07                	jne    80109850 <mappages+0x47>
      return -1;
80109849:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010984e:	eb 47                	jmp    80109897 <mappages+0x8e>
    if(*pte & PTE_P)
80109850:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109853:	8b 00                	mov    (%eax),%eax
80109855:	83 e0 01             	and    $0x1,%eax
80109858:	85 c0                	test   %eax,%eax
8010985a:	74 0d                	je     80109869 <mappages+0x60>
      panic("remap");
8010985c:	83 ec 0c             	sub    $0xc,%esp
8010985f:	68 d8 a7 10 80       	push   $0x8010a7d8
80109864:	e8 fd 6c ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80109869:	8b 45 18             	mov    0x18(%ebp),%eax
8010986c:	0b 45 14             	or     0x14(%ebp),%eax
8010986f:	83 c8 01             	or     $0x1,%eax
80109872:	89 c2                	mov    %eax,%edx
80109874:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109877:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109879:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010987c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010987f:	74 10                	je     80109891 <mappages+0x88>
      break;
    a += PGSIZE;
80109881:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109888:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
8010988f:	eb 9c                	jmp    8010982d <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80109891:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80109892:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109897:	c9                   	leave  
80109898:	c3                   	ret    

80109899 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80109899:	55                   	push   %ebp
8010989a:	89 e5                	mov    %esp,%ebp
8010989c:	53                   	push   %ebx
8010989d:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801098a0:	e8 f6 98 ff ff       	call   8010319b <kalloc>
801098a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
801098a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801098ac:	75 0a                	jne    801098b8 <setupkvm+0x1f>
    return 0;
801098ae:	b8 00 00 00 00       	mov    $0x0,%eax
801098b3:	e9 8e 00 00 00       	jmp    80109946 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
801098b8:	83 ec 04             	sub    $0x4,%esp
801098bb:	68 00 10 00 00       	push   $0x1000
801098c0:	6a 00                	push   $0x0
801098c2:	ff 75 f0             	pushl  -0x10(%ebp)
801098c5:	e8 1d d2 ff ff       	call   80106ae7 <memset>
801098ca:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801098cd:	83 ec 0c             	sub    $0xc,%esp
801098d0:	68 00 00 00 0e       	push   $0xe000000
801098d5:	e8 0d fa ff ff       	call   801092e7 <p2v>
801098da:	83 c4 10             	add    $0x10,%esp
801098dd:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801098e2:	76 0d                	jbe    801098f1 <setupkvm+0x58>
    panic("PHYSTOP too high");
801098e4:	83 ec 0c             	sub    $0xc,%esp
801098e7:	68 de a7 10 80       	push   $0x8010a7de
801098ec:	e8 75 6c ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801098f1:	c7 45 f4 e0 d4 10 80 	movl   $0x8010d4e0,-0xc(%ebp)
801098f8:	eb 40                	jmp    8010993a <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801098fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098fd:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80109900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109903:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80109906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109909:	8b 58 08             	mov    0x8(%eax),%ebx
8010990c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010990f:	8b 40 04             	mov    0x4(%eax),%eax
80109912:	29 c3                	sub    %eax,%ebx
80109914:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109917:	8b 00                	mov    (%eax),%eax
80109919:	83 ec 0c             	sub    $0xc,%esp
8010991c:	51                   	push   %ecx
8010991d:	52                   	push   %edx
8010991e:	53                   	push   %ebx
8010991f:	50                   	push   %eax
80109920:	ff 75 f0             	pushl  -0x10(%ebp)
80109923:	e8 e1 fe ff ff       	call   80109809 <mappages>
80109928:	83 c4 20             	add    $0x20,%esp
8010992b:	85 c0                	test   %eax,%eax
8010992d:	79 07                	jns    80109936 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
8010992f:	b8 00 00 00 00       	mov    $0x0,%eax
80109934:	eb 10                	jmp    80109946 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109936:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010993a:	81 7d f4 20 d5 10 80 	cmpl   $0x8010d520,-0xc(%ebp)
80109941:	72 b7                	jb     801098fa <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80109943:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109946:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109949:	c9                   	leave  
8010994a:	c3                   	ret    

8010994b <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010994b:	55                   	push   %ebp
8010994c:	89 e5                	mov    %esp,%ebp
8010994e:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80109951:	e8 43 ff ff ff       	call   80109899 <setupkvm>
80109956:	a3 d8 74 11 80       	mov    %eax,0x801174d8
  switchkvm();
8010995b:	e8 03 00 00 00       	call   80109963 <switchkvm>
}
80109960:	90                   	nop
80109961:	c9                   	leave  
80109962:	c3                   	ret    

80109963 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80109963:	55                   	push   %ebp
80109964:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109966:	a1 d8 74 11 80       	mov    0x801174d8,%eax
8010996b:	50                   	push   %eax
8010996c:	e8 69 f9 ff ff       	call   801092da <v2p>
80109971:	83 c4 04             	add    $0x4,%esp
80109974:	50                   	push   %eax
80109975:	e8 54 f9 ff ff       	call   801092ce <lcr3>
8010997a:	83 c4 04             	add    $0x4,%esp
}
8010997d:	90                   	nop
8010997e:	c9                   	leave  
8010997f:	c3                   	ret    

80109980 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80109980:	55                   	push   %ebp
80109981:	89 e5                	mov    %esp,%ebp
80109983:	56                   	push   %esi
80109984:	53                   	push   %ebx
  pushcli();
80109985:	e8 57 d0 ff ff       	call   801069e1 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
8010998a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109990:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109997:	83 c2 08             	add    $0x8,%edx
8010999a:	89 d6                	mov    %edx,%esi
8010999c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801099a3:	83 c2 08             	add    $0x8,%edx
801099a6:	c1 ea 10             	shr    $0x10,%edx
801099a9:	89 d3                	mov    %edx,%ebx
801099ab:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801099b2:	83 c2 08             	add    $0x8,%edx
801099b5:	c1 ea 18             	shr    $0x18,%edx
801099b8:	89 d1                	mov    %edx,%ecx
801099ba:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
801099c1:	67 00 
801099c3:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801099ca:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801099d0:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099d7:	83 e2 f0             	and    $0xfffffff0,%edx
801099da:	83 ca 09             	or     $0x9,%edx
801099dd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099e3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099ea:	83 ca 10             	or     $0x10,%edx
801099ed:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099f3:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099fa:	83 e2 9f             	and    $0xffffff9f,%edx
801099fd:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109a03:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a0a:	83 ca 80             	or     $0xffffff80,%edx
80109a0d:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80109a13:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a1a:	83 e2 f0             	and    $0xfffffff0,%edx
80109a1d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a23:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a2a:	83 e2 ef             	and    $0xffffffef,%edx
80109a2d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a33:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a3a:	83 e2 df             	and    $0xffffffdf,%edx
80109a3d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a43:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a4a:	83 ca 40             	or     $0x40,%edx
80109a4d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a53:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a5a:	83 e2 7f             	and    $0x7f,%edx
80109a5d:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a63:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109a69:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a6f:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a76:	83 e2 ef             	and    $0xffffffef,%edx
80109a79:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109a7f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a85:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109a8b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a91:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109a98:	8b 52 08             	mov    0x8(%edx),%edx
80109a9b:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109aa1:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109aa4:	83 ec 0c             	sub    $0xc,%esp
80109aa7:	6a 30                	push   $0x30
80109aa9:	e8 f3 f7 ff ff       	call   801092a1 <ltr>
80109aae:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109ab1:	8b 45 08             	mov    0x8(%ebp),%eax
80109ab4:	8b 40 04             	mov    0x4(%eax),%eax
80109ab7:	85 c0                	test   %eax,%eax
80109ab9:	75 0d                	jne    80109ac8 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80109abb:	83 ec 0c             	sub    $0xc,%esp
80109abe:	68 ef a7 10 80       	push   $0x8010a7ef
80109ac3:	e8 9e 6a ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80109acb:	8b 40 04             	mov    0x4(%eax),%eax
80109ace:	83 ec 0c             	sub    $0xc,%esp
80109ad1:	50                   	push   %eax
80109ad2:	e8 03 f8 ff ff       	call   801092da <v2p>
80109ad7:	83 c4 10             	add    $0x10,%esp
80109ada:	83 ec 0c             	sub    $0xc,%esp
80109add:	50                   	push   %eax
80109ade:	e8 eb f7 ff ff       	call   801092ce <lcr3>
80109ae3:	83 c4 10             	add    $0x10,%esp
  popcli();
80109ae6:	e8 3b cf ff ff       	call   80106a26 <popcli>
}
80109aeb:	90                   	nop
80109aec:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109aef:	5b                   	pop    %ebx
80109af0:	5e                   	pop    %esi
80109af1:	5d                   	pop    %ebp
80109af2:	c3                   	ret    

80109af3 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109af3:	55                   	push   %ebp
80109af4:	89 e5                	mov    %esp,%ebp
80109af6:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109af9:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109b00:	76 0d                	jbe    80109b0f <inituvm+0x1c>
    panic("inituvm: more than a page");
80109b02:	83 ec 0c             	sub    $0xc,%esp
80109b05:	68 03 a8 10 80       	push   $0x8010a803
80109b0a:	e8 57 6a ff ff       	call   80100566 <panic>
  mem = kalloc();
80109b0f:	e8 87 96 ff ff       	call   8010319b <kalloc>
80109b14:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109b17:	83 ec 04             	sub    $0x4,%esp
80109b1a:	68 00 10 00 00       	push   $0x1000
80109b1f:	6a 00                	push   $0x0
80109b21:	ff 75 f4             	pushl  -0xc(%ebp)
80109b24:	e8 be cf ff ff       	call   80106ae7 <memset>
80109b29:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b2c:	83 ec 0c             	sub    $0xc,%esp
80109b2f:	ff 75 f4             	pushl  -0xc(%ebp)
80109b32:	e8 a3 f7 ff ff       	call   801092da <v2p>
80109b37:	83 c4 10             	add    $0x10,%esp
80109b3a:	83 ec 0c             	sub    $0xc,%esp
80109b3d:	6a 06                	push   $0x6
80109b3f:	50                   	push   %eax
80109b40:	68 00 10 00 00       	push   $0x1000
80109b45:	6a 00                	push   $0x0
80109b47:	ff 75 08             	pushl  0x8(%ebp)
80109b4a:	e8 ba fc ff ff       	call   80109809 <mappages>
80109b4f:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109b52:	83 ec 04             	sub    $0x4,%esp
80109b55:	ff 75 10             	pushl  0x10(%ebp)
80109b58:	ff 75 0c             	pushl  0xc(%ebp)
80109b5b:	ff 75 f4             	pushl  -0xc(%ebp)
80109b5e:	e8 43 d0 ff ff       	call   80106ba6 <memmove>
80109b63:	83 c4 10             	add    $0x10,%esp
}
80109b66:	90                   	nop
80109b67:	c9                   	leave  
80109b68:	c3                   	ret    

80109b69 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109b69:	55                   	push   %ebp
80109b6a:	89 e5                	mov    %esp,%ebp
80109b6c:	53                   	push   %ebx
80109b6d:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109b70:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b73:	25 ff 0f 00 00       	and    $0xfff,%eax
80109b78:	85 c0                	test   %eax,%eax
80109b7a:	74 0d                	je     80109b89 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109b7c:	83 ec 0c             	sub    $0xc,%esp
80109b7f:	68 20 a8 10 80       	push   $0x8010a820
80109b84:	e8 dd 69 ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109b89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109b90:	e9 95 00 00 00       	jmp    80109c2a <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109b95:	8b 55 0c             	mov    0xc(%ebp),%edx
80109b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b9b:	01 d0                	add    %edx,%eax
80109b9d:	83 ec 04             	sub    $0x4,%esp
80109ba0:	6a 00                	push   $0x0
80109ba2:	50                   	push   %eax
80109ba3:	ff 75 08             	pushl  0x8(%ebp)
80109ba6:	e8 be fb ff ff       	call   80109769 <walkpgdir>
80109bab:	83 c4 10             	add    $0x10,%esp
80109bae:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109bb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109bb5:	75 0d                	jne    80109bc4 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109bb7:	83 ec 0c             	sub    $0xc,%esp
80109bba:	68 43 a8 10 80       	push   $0x8010a843
80109bbf:	e8 a2 69 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109bc7:	8b 00                	mov    (%eax),%eax
80109bc9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109bce:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109bd1:	8b 45 18             	mov    0x18(%ebp),%eax
80109bd4:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109bd7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109bdc:	77 0b                	ja     80109be9 <loaduvm+0x80>
      n = sz - i;
80109bde:	8b 45 18             	mov    0x18(%ebp),%eax
80109be1:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109be7:	eb 07                	jmp    80109bf0 <loaduvm+0x87>
    else
      n = PGSIZE;
80109be9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109bf0:	8b 55 14             	mov    0x14(%ebp),%edx
80109bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bf6:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109bf9:	83 ec 0c             	sub    $0xc,%esp
80109bfc:	ff 75 e8             	pushl  -0x18(%ebp)
80109bff:	e8 e3 f6 ff ff       	call   801092e7 <p2v>
80109c04:	83 c4 10             	add    $0x10,%esp
80109c07:	ff 75 f0             	pushl  -0x10(%ebp)
80109c0a:	53                   	push   %ebx
80109c0b:	50                   	push   %eax
80109c0c:	ff 75 10             	pushl  0x10(%ebp)
80109c0f:	e8 f9 84 ff ff       	call   8010210d <readi>
80109c14:	83 c4 10             	add    $0x10,%esp
80109c17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109c1a:	74 07                	je     80109c23 <loaduvm+0xba>
      return -1;
80109c1c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109c21:	eb 18                	jmp    80109c3b <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109c23:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c2d:	3b 45 18             	cmp    0x18(%ebp),%eax
80109c30:	0f 82 5f ff ff ff    	jb     80109b95 <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109c36:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109c3b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109c3e:	c9                   	leave  
80109c3f:	c3                   	ret    

80109c40 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109c40:	55                   	push   %ebp
80109c41:	89 e5                	mov    %esp,%ebp
80109c43:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109c46:	8b 45 10             	mov    0x10(%ebp),%eax
80109c49:	85 c0                	test   %eax,%eax
80109c4b:	79 0a                	jns    80109c57 <allocuvm+0x17>
    return 0;
80109c4d:	b8 00 00 00 00       	mov    $0x0,%eax
80109c52:	e9 b0 00 00 00       	jmp    80109d07 <allocuvm+0xc7>
  if(newsz < oldsz)
80109c57:	8b 45 10             	mov    0x10(%ebp),%eax
80109c5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c5d:	73 08                	jae    80109c67 <allocuvm+0x27>
    return oldsz;
80109c5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c62:	e9 a0 00 00 00       	jmp    80109d07 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109c67:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c6a:	05 ff 0f 00 00       	add    $0xfff,%eax
80109c6f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109c77:	eb 7f                	jmp    80109cf8 <allocuvm+0xb8>
    mem = kalloc();
80109c79:	e8 1d 95 ff ff       	call   8010319b <kalloc>
80109c7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109c81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109c85:	75 2b                	jne    80109cb2 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109c87:	83 ec 0c             	sub    $0xc,%esp
80109c8a:	68 61 a8 10 80       	push   $0x8010a861
80109c8f:	e8 32 67 ff ff       	call   801003c6 <cprintf>
80109c94:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109c97:	83 ec 04             	sub    $0x4,%esp
80109c9a:	ff 75 0c             	pushl  0xc(%ebp)
80109c9d:	ff 75 10             	pushl  0x10(%ebp)
80109ca0:	ff 75 08             	pushl  0x8(%ebp)
80109ca3:	e8 61 00 00 00       	call   80109d09 <deallocuvm>
80109ca8:	83 c4 10             	add    $0x10,%esp
      return 0;
80109cab:	b8 00 00 00 00       	mov    $0x0,%eax
80109cb0:	eb 55                	jmp    80109d07 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109cb2:	83 ec 04             	sub    $0x4,%esp
80109cb5:	68 00 10 00 00       	push   $0x1000
80109cba:	6a 00                	push   $0x0
80109cbc:	ff 75 f0             	pushl  -0x10(%ebp)
80109cbf:	e8 23 ce ff ff       	call   80106ae7 <memset>
80109cc4:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109cc7:	83 ec 0c             	sub    $0xc,%esp
80109cca:	ff 75 f0             	pushl  -0x10(%ebp)
80109ccd:	e8 08 f6 ff ff       	call   801092da <v2p>
80109cd2:	83 c4 10             	add    $0x10,%esp
80109cd5:	89 c2                	mov    %eax,%edx
80109cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cda:	83 ec 0c             	sub    $0xc,%esp
80109cdd:	6a 06                	push   $0x6
80109cdf:	52                   	push   %edx
80109ce0:	68 00 10 00 00       	push   $0x1000
80109ce5:	50                   	push   %eax
80109ce6:	ff 75 08             	pushl  0x8(%ebp)
80109ce9:	e8 1b fb ff ff       	call   80109809 <mappages>
80109cee:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109cf1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cfb:	3b 45 10             	cmp    0x10(%ebp),%eax
80109cfe:	0f 82 75 ff ff ff    	jb     80109c79 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109d04:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109d07:	c9                   	leave  
80109d08:	c3                   	ret    

80109d09 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109d09:	55                   	push   %ebp
80109d0a:	89 e5                	mov    %esp,%ebp
80109d0c:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109d0f:	8b 45 10             	mov    0x10(%ebp),%eax
80109d12:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109d15:	72 08                	jb     80109d1f <deallocuvm+0x16>
    return oldsz;
80109d17:	8b 45 0c             	mov    0xc(%ebp),%eax
80109d1a:	e9 a5 00 00 00       	jmp    80109dc4 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109d1f:	8b 45 10             	mov    0x10(%ebp),%eax
80109d22:	05 ff 0f 00 00       	add    $0xfff,%eax
80109d27:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109d2f:	e9 81 00 00 00       	jmp    80109db5 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d37:	83 ec 04             	sub    $0x4,%esp
80109d3a:	6a 00                	push   $0x0
80109d3c:	50                   	push   %eax
80109d3d:	ff 75 08             	pushl  0x8(%ebp)
80109d40:	e8 24 fa ff ff       	call   80109769 <walkpgdir>
80109d45:	83 c4 10             	add    $0x10,%esp
80109d48:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109d4b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109d4f:	75 09                	jne    80109d5a <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109d51:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109d58:	eb 54                	jmp    80109dae <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d5d:	8b 00                	mov    (%eax),%eax
80109d5f:	83 e0 01             	and    $0x1,%eax
80109d62:	85 c0                	test   %eax,%eax
80109d64:	74 48                	je     80109dae <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109d66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d69:	8b 00                	mov    (%eax),%eax
80109d6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109d73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109d77:	75 0d                	jne    80109d86 <deallocuvm+0x7d>
        panic("kfree");
80109d79:	83 ec 0c             	sub    $0xc,%esp
80109d7c:	68 79 a8 10 80       	push   $0x8010a879
80109d81:	e8 e0 67 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109d86:	83 ec 0c             	sub    $0xc,%esp
80109d89:	ff 75 ec             	pushl  -0x14(%ebp)
80109d8c:	e8 56 f5 ff ff       	call   801092e7 <p2v>
80109d91:	83 c4 10             	add    $0x10,%esp
80109d94:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109d97:	83 ec 0c             	sub    $0xc,%esp
80109d9a:	ff 75 e8             	pushl  -0x18(%ebp)
80109d9d:	e8 5c 93 ff ff       	call   801030fe <kfree>
80109da2:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109da8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109dae:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109db5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109db8:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109dbb:	0f 82 73 ff ff ff    	jb     80109d34 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109dc1:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109dc4:	c9                   	leave  
80109dc5:	c3                   	ret    

80109dc6 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109dc6:	55                   	push   %ebp
80109dc7:	89 e5                	mov    %esp,%ebp
80109dc9:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109dcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109dd0:	75 0d                	jne    80109ddf <freevm+0x19>
    panic("freevm: no pgdir");
80109dd2:	83 ec 0c             	sub    $0xc,%esp
80109dd5:	68 7f a8 10 80       	push   $0x8010a87f
80109dda:	e8 87 67 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109ddf:	83 ec 04             	sub    $0x4,%esp
80109de2:	6a 00                	push   $0x0
80109de4:	68 00 00 00 80       	push   $0x80000000
80109de9:	ff 75 08             	pushl  0x8(%ebp)
80109dec:	e8 18 ff ff ff       	call   80109d09 <deallocuvm>
80109df1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109df4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109dfb:	eb 4f                	jmp    80109e4c <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e00:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109e07:	8b 45 08             	mov    0x8(%ebp),%eax
80109e0a:	01 d0                	add    %edx,%eax
80109e0c:	8b 00                	mov    (%eax),%eax
80109e0e:	83 e0 01             	and    $0x1,%eax
80109e11:	85 c0                	test   %eax,%eax
80109e13:	74 33                	je     80109e48 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e18:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109e1f:	8b 45 08             	mov    0x8(%ebp),%eax
80109e22:	01 d0                	add    %edx,%eax
80109e24:	8b 00                	mov    (%eax),%eax
80109e26:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e2b:	83 ec 0c             	sub    $0xc,%esp
80109e2e:	50                   	push   %eax
80109e2f:	e8 b3 f4 ff ff       	call   801092e7 <p2v>
80109e34:	83 c4 10             	add    $0x10,%esp
80109e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109e3a:	83 ec 0c             	sub    $0xc,%esp
80109e3d:	ff 75 f0             	pushl  -0x10(%ebp)
80109e40:	e8 b9 92 ff ff       	call   801030fe <kfree>
80109e45:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109e48:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109e4c:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109e53:	76 a8                	jbe    80109dfd <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109e55:	83 ec 0c             	sub    $0xc,%esp
80109e58:	ff 75 08             	pushl  0x8(%ebp)
80109e5b:	e8 9e 92 ff ff       	call   801030fe <kfree>
80109e60:	83 c4 10             	add    $0x10,%esp
}
80109e63:	90                   	nop
80109e64:	c9                   	leave  
80109e65:	c3                   	ret    

80109e66 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109e66:	55                   	push   %ebp
80109e67:	89 e5                	mov    %esp,%ebp
80109e69:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109e6c:	83 ec 04             	sub    $0x4,%esp
80109e6f:	6a 00                	push   $0x0
80109e71:	ff 75 0c             	pushl  0xc(%ebp)
80109e74:	ff 75 08             	pushl  0x8(%ebp)
80109e77:	e8 ed f8 ff ff       	call   80109769 <walkpgdir>
80109e7c:	83 c4 10             	add    $0x10,%esp
80109e7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109e82:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109e86:	75 0d                	jne    80109e95 <clearpteu+0x2f>
    panic("clearpteu");
80109e88:	83 ec 0c             	sub    $0xc,%esp
80109e8b:	68 90 a8 10 80       	push   $0x8010a890
80109e90:	e8 d1 66 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e98:	8b 00                	mov    (%eax),%eax
80109e9a:	83 e0 fb             	and    $0xfffffffb,%eax
80109e9d:	89 c2                	mov    %eax,%edx
80109e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ea2:	89 10                	mov    %edx,(%eax)
}
80109ea4:	90                   	nop
80109ea5:	c9                   	leave  
80109ea6:	c3                   	ret    

80109ea7 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109ea7:	55                   	push   %ebp
80109ea8:	89 e5                	mov    %esp,%ebp
80109eaa:	53                   	push   %ebx
80109eab:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109eae:	e8 e6 f9 ff ff       	call   80109899 <setupkvm>
80109eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109eb6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109eba:	75 0a                	jne    80109ec6 <copyuvm+0x1f>
    return 0;
80109ebc:	b8 00 00 00 00       	mov    $0x0,%eax
80109ec1:	e9 f8 00 00 00       	jmp    80109fbe <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109ec6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109ecd:	e9 c4 00 00 00       	jmp    80109f96 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ed5:	83 ec 04             	sub    $0x4,%esp
80109ed8:	6a 00                	push   $0x0
80109eda:	50                   	push   %eax
80109edb:	ff 75 08             	pushl  0x8(%ebp)
80109ede:	e8 86 f8 ff ff       	call   80109769 <walkpgdir>
80109ee3:	83 c4 10             	add    $0x10,%esp
80109ee6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109ee9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109eed:	75 0d                	jne    80109efc <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109eef:	83 ec 0c             	sub    $0xc,%esp
80109ef2:	68 9a a8 10 80       	push   $0x8010a89a
80109ef7:	e8 6a 66 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eff:	8b 00                	mov    (%eax),%eax
80109f01:	83 e0 01             	and    $0x1,%eax
80109f04:	85 c0                	test   %eax,%eax
80109f06:	75 0d                	jne    80109f15 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109f08:	83 ec 0c             	sub    $0xc,%esp
80109f0b:	68 b4 a8 10 80       	push   $0x8010a8b4
80109f10:	e8 51 66 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f18:	8b 00                	mov    (%eax),%eax
80109f1a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109f1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109f25:	8b 00                	mov    (%eax),%eax
80109f27:	25 ff 0f 00 00       	and    $0xfff,%eax
80109f2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109f2f:	e8 67 92 ff ff       	call   8010319b <kalloc>
80109f34:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109f37:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109f3b:	74 6a                	je     80109fa7 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109f3d:	83 ec 0c             	sub    $0xc,%esp
80109f40:	ff 75 e8             	pushl  -0x18(%ebp)
80109f43:	e8 9f f3 ff ff       	call   801092e7 <p2v>
80109f48:	83 c4 10             	add    $0x10,%esp
80109f4b:	83 ec 04             	sub    $0x4,%esp
80109f4e:	68 00 10 00 00       	push   $0x1000
80109f53:	50                   	push   %eax
80109f54:	ff 75 e0             	pushl  -0x20(%ebp)
80109f57:	e8 4a cc ff ff       	call   80106ba6 <memmove>
80109f5c:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109f5f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109f62:	83 ec 0c             	sub    $0xc,%esp
80109f65:	ff 75 e0             	pushl  -0x20(%ebp)
80109f68:	e8 6d f3 ff ff       	call   801092da <v2p>
80109f6d:	83 c4 10             	add    $0x10,%esp
80109f70:	89 c2                	mov    %eax,%edx
80109f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f75:	83 ec 0c             	sub    $0xc,%esp
80109f78:	53                   	push   %ebx
80109f79:	52                   	push   %edx
80109f7a:	68 00 10 00 00       	push   $0x1000
80109f7f:	50                   	push   %eax
80109f80:	ff 75 f0             	pushl  -0x10(%ebp)
80109f83:	e8 81 f8 ff ff       	call   80109809 <mappages>
80109f88:	83 c4 20             	add    $0x20,%esp
80109f8b:	85 c0                	test   %eax,%eax
80109f8d:	78 1b                	js     80109faa <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109f8f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f99:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109f9c:	0f 82 30 ff ff ff    	jb     80109ed2 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109fa5:	eb 17                	jmp    80109fbe <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109fa7:	90                   	nop
80109fa8:	eb 01                	jmp    80109fab <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109faa:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109fab:	83 ec 0c             	sub    $0xc,%esp
80109fae:	ff 75 f0             	pushl  -0x10(%ebp)
80109fb1:	e8 10 fe ff ff       	call   80109dc6 <freevm>
80109fb6:	83 c4 10             	add    $0x10,%esp
  return 0;
80109fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109fc1:	c9                   	leave  
80109fc2:	c3                   	ret    

80109fc3 <uva2ka>:

// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109fc3:	55                   	push   %ebp
80109fc4:	89 e5                	mov    %esp,%ebp
80109fc6:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109fc9:	83 ec 04             	sub    $0x4,%esp
80109fcc:	6a 00                	push   $0x0
80109fce:	ff 75 0c             	pushl  0xc(%ebp)
80109fd1:	ff 75 08             	pushl  0x8(%ebp)
80109fd4:	e8 90 f7 ff ff       	call   80109769 <walkpgdir>
80109fd9:	83 c4 10             	add    $0x10,%esp
80109fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fe2:	8b 00                	mov    (%eax),%eax
80109fe4:	83 e0 01             	and    $0x1,%eax
80109fe7:	85 c0                	test   %eax,%eax
80109fe9:	75 07                	jne    80109ff2 <uva2ka+0x2f>
    return 0;
80109feb:	b8 00 00 00 00       	mov    $0x0,%eax
80109ff0:	eb 29                	jmp    8010a01b <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109ff5:	8b 00                	mov    (%eax),%eax
80109ff7:	83 e0 04             	and    $0x4,%eax
80109ffa:	85 c0                	test   %eax,%eax
80109ffc:	75 07                	jne    8010a005 <uva2ka+0x42>
    return 0;
80109ffe:	b8 00 00 00 00       	mov    $0x0,%eax
8010a003:	eb 16                	jmp    8010a01b <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
8010a005:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010a008:	8b 00                	mov    (%eax),%eax
8010a00a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a00f:	83 ec 0c             	sub    $0xc,%esp
8010a012:	50                   	push   %eax
8010a013:	e8 cf f2 ff ff       	call   801092e7 <p2v>
8010a018:	83 c4 10             	add    $0x10,%esp
}
8010a01b:	c9                   	leave  
8010a01c:	c3                   	ret    

8010a01d <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010a01d:	55                   	push   %ebp
8010a01e:	89 e5                	mov    %esp,%ebp
8010a020:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
8010a023:	8b 45 10             	mov    0x10(%ebp),%eax
8010a026:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010a029:	eb 7f                	jmp    8010a0aa <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010a02b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a02e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a033:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010a036:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a039:	83 ec 08             	sub    $0x8,%esp
8010a03c:	50                   	push   %eax
8010a03d:	ff 75 08             	pushl  0x8(%ebp)
8010a040:	e8 7e ff ff ff       	call   80109fc3 <uva2ka>
8010a045:	83 c4 10             	add    $0x10,%esp
8010a048:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010a04b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010a04f:	75 07                	jne    8010a058 <copyout+0x3b>
      return -1;
8010a051:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010a056:	eb 61                	jmp    8010a0b9 <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010a058:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a05b:	2b 45 0c             	sub    0xc(%ebp),%eax
8010a05e:	05 00 10 00 00       	add    $0x1000,%eax
8010a063:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010a066:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a069:	3b 45 14             	cmp    0x14(%ebp),%eax
8010a06c:	76 06                	jbe    8010a074 <copyout+0x57>
      n = len;
8010a06e:	8b 45 14             	mov    0x14(%ebp),%eax
8010a071:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010a074:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a077:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010a07a:	89 c2                	mov    %eax,%edx
8010a07c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a07f:	01 d0                	add    %edx,%eax
8010a081:	83 ec 04             	sub    $0x4,%esp
8010a084:	ff 75 f0             	pushl  -0x10(%ebp)
8010a087:	ff 75 f4             	pushl  -0xc(%ebp)
8010a08a:	50                   	push   %eax
8010a08b:	e8 16 cb ff ff       	call   80106ba6 <memmove>
8010a090:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010a093:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a096:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010a099:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a09c:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010a09f:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a0a2:	05 00 10 00 00       	add    $0x1000,%eax
8010a0a7:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010a0aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010a0ae:	0f 85 77 ff ff ff    	jne    8010a02b <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010a0b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a0b9:	c9                   	leave  
8010a0ba:	c3                   	ret    
