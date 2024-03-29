
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 2f 10 80       	mov    $0x80102fa0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 6f 10 80       	push   $0x80106fe0
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 e5 42 00 00       	call   80104340 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100063:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	83 ec 08             	sub    $0x8,%esp
80100085:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 6f 10 80       	push   $0x80106fe7
80100097:	50                   	push   %eax
80100098:	e8 73 41 00 00       	call   80104210 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a2:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a4:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 7d 08             	mov    0x8(%ebp),%edi
801000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 b7 43 00 00       	call   801044a0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 f9 43 00 00       	call   80104560 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 de 40 00 00       	call   80104250 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 20 00 00       	call   801021f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 ee 6f 10 80       	push   $0x80106fee
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 2d 41 00 00       	call   801042f0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 20 00 00       	jmp    801021f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 6f 10 80       	push   $0x80106fff
801001e1:	e8 aa 01 00 00       	call   80100390 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 40 00 00       	call   801042f0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 9c 40 00 00       	call   801042b0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010021b:	e8 80 42 00 00       	call   801044a0 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 ef 42 00 00       	jmp    80104560 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 70 10 80       	push   $0x80107006
80100279:	e8 12 01 00 00       	call   80100390 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100289:	ff 75 08             	pushl  0x8(%ebp)
{
8010028c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010028f:	e8 5c 15 00 00       	call   801017f0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100294:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029b:	e8 00 42 00 00       	call   801044a0 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	31 c0                	xor    %eax,%eax
    *dst++ = c;
801002a8:	01 f7                	add    %esi,%edi
  while(n > 0){
801002aa:	85 f6                	test   %esi,%esi
801002ac:	0f 8e a0 00 00 00    	jle    80100352 <consoleread+0xd2>
801002b2:	89 f3                	mov    %esi,%ebx
    while(input.r == input.w){
801002b4:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002ba:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
801002c0:	74 29                	je     801002eb <consoleread+0x6b>
801002c2:	eb 5c                	jmp    80100320 <consoleread+0xa0>
801002c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      sleep(&input.r, &cons.lock);
801002c8:	83 ec 08             	sub    $0x8,%esp
801002cb:	68 20 a5 10 80       	push   $0x8010a520
801002d0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d5:	e8 96 3b 00 00       	call   80103e70 <sleep>
    while(input.r == input.w){
801002da:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002e0:	83 c4 10             	add    $0x10,%esp
801002e3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002e9:	75 35                	jne    80100320 <consoleread+0xa0>
      if(myproc()->killed){
801002eb:	e8 e0 35 00 00       	call   801038d0 <myproc>
801002f0:	8b 48 24             	mov    0x24(%eax),%ecx
801002f3:	85 c9                	test   %ecx,%ecx
801002f5:	74 d1                	je     801002c8 <consoleread+0x48>
        release(&cons.lock);
801002f7:	83 ec 0c             	sub    $0xc,%esp
801002fa:	68 20 a5 10 80       	push   $0x8010a520
801002ff:	e8 5c 42 00 00       	call   80104560 <release>
        ilock(ip);
80100304:	5a                   	pop    %edx
80100305:	ff 75 08             	pushl  0x8(%ebp)
80100308:	e8 03 14 00 00       	call   80101710 <ilock>
        return -1;
8010030d:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100310:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100318:	5b                   	pop    %ebx
80100319:	5e                   	pop    %esi
8010031a:	5f                   	pop    %edi
8010031b:	5d                   	pop    %ebp
8010031c:	c3                   	ret    
8010031d:	8d 76 00             	lea    0x0(%esi),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100320:	8d 42 01             	lea    0x1(%edx),%eax
80100323:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100328:	89 d0                	mov    %edx,%eax
8010032a:	83 e0 7f             	and    $0x7f,%eax
8010032d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
    if(c == C('D')){  // EOF
80100334:	83 f8 04             	cmp    $0x4,%eax
80100337:	74 46                	je     8010037f <consoleread+0xff>
    *dst++ = c;
80100339:	89 da                	mov    %ebx,%edx
    --n;
8010033b:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010033e:	f7 da                	neg    %edx
80100340:	88 04 17             	mov    %al,(%edi,%edx,1)
    if(c == '\n')
80100343:	83 f8 0a             	cmp    $0xa,%eax
80100346:	74 31                	je     80100379 <consoleread+0xf9>
  while(n > 0){
80100348:	85 db                	test   %ebx,%ebx
8010034a:	0f 85 64 ff ff ff    	jne    801002b4 <consoleread+0x34>
80100350:	89 f0                	mov    %esi,%eax
  release(&cons.lock);
80100352:	83 ec 0c             	sub    $0xc,%esp
80100355:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100358:	68 20 a5 10 80       	push   $0x8010a520
8010035d:	e8 fe 41 00 00       	call   80104560 <release>
  ilock(ip);
80100362:	58                   	pop    %eax
80100363:	ff 75 08             	pushl  0x8(%ebp)
80100366:	e8 a5 13 00 00       	call   80101710 <ilock>
  return target - n;
8010036b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010036e:	83 c4 10             	add    $0x10,%esp
}
80100371:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100374:	5b                   	pop    %ebx
80100375:	5e                   	pop    %esi
80100376:	5f                   	pop    %edi
80100377:	5d                   	pop    %ebp
80100378:	c3                   	ret    
80100379:	89 f0                	mov    %esi,%eax
8010037b:	29 d8                	sub    %ebx,%eax
8010037d:	eb d3                	jmp    80100352 <consoleread+0xd2>
      if(n < target){
8010037f:	89 f0                	mov    %esi,%eax
80100381:	29 d8                	sub    %ebx,%eax
80100383:	39 f3                	cmp    %esi,%ebx
80100385:	73 cb                	jae    80100352 <consoleread+0xd2>
        input.r--;
80100387:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010038d:	eb c3                	jmp    80100352 <consoleread+0xd2>
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 72 24 00 00       	call   80102820 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 0d 70 10 80       	push   $0x8010700d
801003b7:	e8 f4 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 eb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 5f 79 10 80 	movl   $0x8010795f,(%esp)
801003cc:	e8 df 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	8d 45 08             	lea    0x8(%ebp),%eax
801003d4:	5a                   	pop    %edx
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 83 3f 00 00       	call   80104360 <getcallerpcs>
  for(i=0; i<10; i++)
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 21 70 10 80       	push   $0x80107021
801003ed:	e8 be 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
    ;
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010040c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 c1 57 00 00       	call   80105bf0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004ec:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 d6 56 00 00       	call   80105bf0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ca 56 00 00       	call   80105bf0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 be 56 00 00       	call   80105bf0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010054b:	68 60 0e 00 00       	push   $0xe60
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100550:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 ea 40 00 00       	call   80104650 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 35 40 00 00       	call   801045b0 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 25 70 10 80       	push   $0x80107025
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 68                	js     8010061c <printint+0x7c>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	31 db                	xor    %ebx,%ebx
801005ba:	eb 04                	jmp    801005c0 <printint+0x20>
  }while((x /= base) != 0);
801005bc:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
801005be:	89 fb                	mov    %edi,%ebx
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	8d 7b 01             	lea    0x1(%ebx),%edi
801005c7:	f7 75 d4             	divl   -0x2c(%ebp)
801005ca:	0f b6 92 50 70 10 80 	movzbl -0x7fef8fb0(%edx),%edx
801005d1:	88 54 3d d7          	mov    %dl,-0x29(%ebp,%edi,1)
  }while((x /= base) != 0);
801005d5:	39 4d d4             	cmp    %ecx,-0x2c(%ebp)
801005d8:	76 e2                	jbe    801005bc <printint+0x1c>
  if(sign)
801005da:	85 f6                	test   %esi,%esi
801005dc:	75 32                	jne    80100610 <printint+0x70>
801005de:	0f be c2             	movsbl %dl,%eax
801005e1:	89 df                	mov    %ebx,%edi
  if(panicked){
801005e3:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801005e9:	85 c9                	test   %ecx,%ecx
801005eb:	75 20                	jne    8010060d <printint+0x6d>
801005ed:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005f1:	e8 1a fe ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
801005f6:	8d 45 d7             	lea    -0x29(%ebp),%eax
801005f9:	39 d8                	cmp    %ebx,%eax
801005fb:	74 27                	je     80100624 <printint+0x84>
  if(panicked){
801005fd:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i]);
80100603:	0f be 03             	movsbl (%ebx),%eax
  if(panicked){
80100606:	83 eb 01             	sub    $0x1,%ebx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 e4                	je     801005f1 <printint+0x51>
  asm volatile("cli");
8010060d:	fa                   	cli    
      ;
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
    buf[i++] = '-';
80100610:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
80100615:	b8 2d 00 00 00       	mov    $0x2d,%eax
8010061a:	eb c7                	jmp    801005e3 <printint+0x43>
    x = -xx;
8010061c:	f7 d8                	neg    %eax
8010061e:	89 ce                	mov    %ecx,%esi
80100620:	89 c1                	mov    %eax,%ecx
80100622:	eb 94                	jmp    801005b8 <printint+0x18>
}
80100624:	83 c4 2c             	add    $0x2c,%esp
80100627:	5b                   	pop    %ebx
80100628:	5e                   	pop    %esi
80100629:	5f                   	pop    %edi
8010062a:	5d                   	pop    %ebp
8010062b:	c3                   	ret    
8010062c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100630 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100630:	55                   	push   %ebp
80100631:	89 e5                	mov    %esp,%ebp
80100633:	57                   	push   %edi
80100634:	56                   	push   %esi
80100635:	53                   	push   %ebx
80100636:	83 ec 18             	sub    $0x18,%esp
80100639:	8b 7d 10             	mov    0x10(%ebp),%edi
8010063c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  int i;

  iunlock(ip);
8010063f:	ff 75 08             	pushl  0x8(%ebp)
80100642:	e8 a9 11 00 00       	call   801017f0 <iunlock>
  acquire(&cons.lock);
80100647:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010064e:	e8 4d 3e 00 00       	call   801044a0 <acquire>
  for(i = 0; i < n; i++)
80100653:	83 c4 10             	add    $0x10,%esp
80100656:	85 ff                	test   %edi,%edi
80100658:	7e 36                	jle    80100690 <consolewrite+0x60>
  if(panicked){
8010065a:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
80100660:	85 c9                	test   %ecx,%ecx
80100662:	75 21                	jne    80100685 <consolewrite+0x55>
    consputc(buf[i] & 0xff);
80100664:	0f b6 03             	movzbl (%ebx),%eax
80100667:	8d 73 01             	lea    0x1(%ebx),%esi
8010066a:	01 fb                	add    %edi,%ebx
8010066c:	e8 9f fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
80100671:	39 de                	cmp    %ebx,%esi
80100673:	74 1b                	je     80100690 <consolewrite+0x60>
  if(panicked){
80100675:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
    consputc(buf[i] & 0xff);
8010067b:	0f b6 06             	movzbl (%esi),%eax
  if(panicked){
8010067e:	83 c6 01             	add    $0x1,%esi
80100681:	85 d2                	test   %edx,%edx
80100683:	74 e7                	je     8010066c <consolewrite+0x3c>
80100685:	fa                   	cli    
      ;
80100686:	eb fe                	jmp    80100686 <consolewrite+0x56>
80100688:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010068f:	90                   	nop
  release(&cons.lock);
80100690:	83 ec 0c             	sub    $0xc,%esp
80100693:	68 20 a5 10 80       	push   $0x8010a520
80100698:	e8 c3 3e 00 00       	call   80104560 <release>
  ilock(ip);
8010069d:	58                   	pop    %eax
8010069e:	ff 75 08             	pushl  0x8(%ebp)
801006a1:	e8 6a 10 00 00       	call   80101710 <ilock>

  return n;
}
801006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a9:	89 f8                	mov    %edi,%eax
801006ab:	5b                   	pop    %ebx
801006ac:	5e                   	pop    %esi
801006ad:	5f                   	pop    %edi
801006ae:	5d                   	pop    %ebp
801006af:	c3                   	ret    

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801006be:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c1:	85 c0                	test   %eax,%eax
801006c3:	0f 85 df 00 00 00    	jne    801007a8 <cprintf+0xf8>
  if (fmt == 0)
801006c9:	8b 45 08             	mov    0x8(%ebp),%eax
801006cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006cf:	85 c0                	test   %eax,%eax
801006d1:	0f 84 5e 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d7:	0f b6 00             	movzbl (%eax),%eax
801006da:	85 c0                	test   %eax,%eax
801006dc:	74 32                	je     80100710 <cprintf+0x60>
  argp = (uint*)(void*)(&fmt + 1);
801006de:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e1:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	74 40                	je     80100728 <cprintf+0x78>
  if(panicked){
801006e8:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
801006ee:	85 c9                	test   %ecx,%ecx
801006f0:	74 0b                	je     801006fd <cprintf+0x4d>
801006f2:	fa                   	cli    
      ;
801006f3:	eb fe                	jmp    801006f3 <cprintf+0x43>
801006f5:	8d 76 00             	lea    0x0(%esi),%esi
801006f8:	b8 25 00 00 00       	mov    $0x25,%eax
801006fd:	e8 0e fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100702:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100705:	83 c6 01             	add    $0x1,%esi
80100708:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
8010070c:	85 c0                	test   %eax,%eax
8010070e:	75 d3                	jne    801006e3 <cprintf+0x33>
  if(locking)
80100710:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80100713:	85 db                	test   %ebx,%ebx
80100715:	0f 85 05 01 00 00    	jne    80100820 <cprintf+0x170>
}
8010071b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010071e:	5b                   	pop    %ebx
8010071f:	5e                   	pop    %esi
80100720:	5f                   	pop    %edi
80100721:	5d                   	pop    %ebp
80100722:	c3                   	ret    
80100723:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100727:	90                   	nop
    c = fmt[++i] & 0xff;
80100728:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010072b:	83 c6 01             	add    $0x1,%esi
8010072e:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
80100732:	85 ff                	test   %edi,%edi
80100734:	74 da                	je     80100710 <cprintf+0x60>
    switch(c){
80100736:	83 ff 70             	cmp    $0x70,%edi
80100739:	0f 84 7e 00 00 00    	je     801007bd <cprintf+0x10d>
8010073f:	7f 26                	jg     80100767 <cprintf+0xb7>
80100741:	83 ff 25             	cmp    $0x25,%edi
80100744:	0f 84 be 00 00 00    	je     80100808 <cprintf+0x158>
8010074a:	83 ff 64             	cmp    $0x64,%edi
8010074d:	75 46                	jne    80100795 <cprintf+0xe5>
      printint(*argp++, 10, 1);
8010074f:	8b 03                	mov    (%ebx),%eax
80100751:	8d 7b 04             	lea    0x4(%ebx),%edi
80100754:	b9 01 00 00 00       	mov    $0x1,%ecx
80100759:	ba 0a 00 00 00       	mov    $0xa,%edx
8010075e:	89 fb                	mov    %edi,%ebx
80100760:	e8 3b fe ff ff       	call   801005a0 <printint>
      break;
80100765:	eb 9b                	jmp    80100702 <cprintf+0x52>
    switch(c){
80100767:	83 ff 73             	cmp    $0x73,%edi
8010076a:	75 24                	jne    80100790 <cprintf+0xe0>
      if((s = (char*)*argp++) == 0)
8010076c:	8d 7b 04             	lea    0x4(%ebx),%edi
8010076f:	8b 1b                	mov    (%ebx),%ebx
80100771:	85 db                	test   %ebx,%ebx
80100773:	75 68                	jne    801007dd <cprintf+0x12d>
80100775:	b8 28 00 00 00       	mov    $0x28,%eax
        s = "(null)";
8010077a:	bb 38 70 10 80       	mov    $0x80107038,%ebx
  if(panicked){
8010077f:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100785:	85 d2                	test   %edx,%edx
80100787:	74 4c                	je     801007d5 <cprintf+0x125>
80100789:	fa                   	cli    
      ;
8010078a:	eb fe                	jmp    8010078a <cprintf+0xda>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100790:	83 ff 78             	cmp    $0x78,%edi
80100793:	74 28                	je     801007bd <cprintf+0x10d>
  if(panicked){
80100795:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
8010079b:	85 d2                	test   %edx,%edx
8010079d:	74 4c                	je     801007eb <cprintf+0x13b>
8010079f:	fa                   	cli    
      ;
801007a0:	eb fe                	jmp    801007a0 <cprintf+0xf0>
801007a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&cons.lock);
801007a8:	83 ec 0c             	sub    $0xc,%esp
801007ab:	68 20 a5 10 80       	push   $0x8010a520
801007b0:	e8 eb 3c 00 00       	call   801044a0 <acquire>
801007b5:	83 c4 10             	add    $0x10,%esp
801007b8:	e9 0c ff ff ff       	jmp    801006c9 <cprintf+0x19>
      printint(*argp++, 16, 0);
801007bd:	8b 03                	mov    (%ebx),%eax
801007bf:	8d 7b 04             	lea    0x4(%ebx),%edi
801007c2:	31 c9                	xor    %ecx,%ecx
801007c4:	ba 10 00 00 00       	mov    $0x10,%edx
801007c9:	89 fb                	mov    %edi,%ebx
801007cb:	e8 d0 fd ff ff       	call   801005a0 <printint>
      break;
801007d0:	e9 2d ff ff ff       	jmp    80100702 <cprintf+0x52>
801007d5:	e8 36 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007da:	83 c3 01             	add    $0x1,%ebx
801007dd:	0f be 03             	movsbl (%ebx),%eax
801007e0:	84 c0                	test   %al,%al
801007e2:	75 9b                	jne    8010077f <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
801007e4:	89 fb                	mov    %edi,%ebx
801007e6:	e9 17 ff ff ff       	jmp    80100702 <cprintf+0x52>
801007eb:	b8 25 00 00 00       	mov    $0x25,%eax
801007f0:	e8 1b fc ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
801007f5:	a1 58 a5 10 80       	mov    0x8010a558,%eax
801007fa:	85 c0                	test   %eax,%eax
801007fc:	74 4a                	je     80100848 <cprintf+0x198>
801007fe:	fa                   	cli    
      ;
801007ff:	eb fe                	jmp    801007ff <cprintf+0x14f>
80100801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100808:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
8010080e:	85 c9                	test   %ecx,%ecx
80100810:	0f 84 e2 fe ff ff    	je     801006f8 <cprintf+0x48>
80100816:	fa                   	cli    
      ;
80100817:	eb fe                	jmp    80100817 <cprintf+0x167>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 a5 10 80       	push   $0x8010a520
80100828:	e8 33 3d 00 00       	call   80104560 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 e6 fe ff ff       	jmp    8010071b <cprintf+0x6b>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 3f 70 10 80       	push   $0x8010703f
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 ae fe ff ff       	jmp    80100702 <cprintf+0x52>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	55                   	push   %ebp
80100861:	89 e5                	mov    %esp,%ebp
80100863:	57                   	push   %edi
80100864:	56                   	push   %esi
  int c, doprocdump = 0;
80100865:	31 f6                	xor    %esi,%esi
{
80100867:	53                   	push   %ebx
80100868:	83 ec 18             	sub    $0x18,%esp
8010086b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010086e:	68 20 a5 10 80       	push   $0x8010a520
80100873:	e8 28 3c 00 00       	call   801044a0 <acquire>
  while((c = getc()) >= 0){
80100878:	83 c4 10             	add    $0x10,%esp
8010087b:	ff d7                	call   *%edi
8010087d:	89 c3                	mov    %eax,%ebx
8010087f:	85 c0                	test   %eax,%eax
80100881:	0f 88 38 01 00 00    	js     801009bf <consoleintr+0x15f>
    switch(c){
80100887:	83 fb 10             	cmp    $0x10,%ebx
8010088a:	0f 84 f0 00 00 00    	je     80100980 <consoleintr+0x120>
80100890:	0f 8e ba 00 00 00    	jle    80100950 <consoleintr+0xf0>
80100896:	83 fb 15             	cmp    $0x15,%ebx
80100899:	75 35                	jne    801008d0 <consoleintr+0x70>
      while(input.e != input.w &&
8010089b:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008a0:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
801008a6:	74 d3                	je     8010087b <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008a8:	83 e8 01             	sub    $0x1,%eax
801008ab:	89 c2                	mov    %eax,%edx
801008ad:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801008b0:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
801008b7:	74 c2                	je     8010087b <consoleintr+0x1b>
  if(panicked){
801008b9:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
        input.e--;
801008bf:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
801008c4:	85 d2                	test   %edx,%edx
801008c6:	0f 84 be 00 00 00    	je     8010098a <consoleintr+0x12a>
801008cc:	fa                   	cli    
      ;
801008cd:	eb fe                	jmp    801008cd <consoleintr+0x6d>
801008cf:	90                   	nop
    switch(c){
801008d0:	83 fb 7f             	cmp    $0x7f,%ebx
801008d3:	0f 84 7c 00 00 00    	je     80100955 <consoleintr+0xf5>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d9:	85 db                	test   %ebx,%ebx
801008db:	74 9e                	je     8010087b <consoleintr+0x1b>
801008dd:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008e2:	89 c2                	mov    %eax,%edx
801008e4:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008ea:	83 fa 7f             	cmp    $0x7f,%edx
801008ed:	77 8c                	ja     8010087b <consoleintr+0x1b>
        c = (c == '\r') ? '\n' : c;
801008ef:	8d 48 01             	lea    0x1(%eax),%ecx
801008f2:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801008f8:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008fb:	89 0d a8 ff 10 80    	mov    %ecx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
80100901:	83 fb 0d             	cmp    $0xd,%ebx
80100904:	0f 84 d1 00 00 00    	je     801009db <consoleintr+0x17b>
        input.buf[input.e++ % INPUT_BUF] = c;
8010090a:	88 98 20 ff 10 80    	mov    %bl,-0x7fef00e0(%eax)
  if(panicked){
80100910:	85 d2                	test   %edx,%edx
80100912:	0f 85 ce 00 00 00    	jne    801009e6 <consoleintr+0x186>
80100918:	89 d8                	mov    %ebx,%eax
8010091a:	e8 f1 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010091f:	83 fb 0a             	cmp    $0xa,%ebx
80100922:	0f 84 d2 00 00 00    	je     801009fa <consoleintr+0x19a>
80100928:	83 fb 04             	cmp    $0x4,%ebx
8010092b:	0f 84 c9 00 00 00    	je     801009fa <consoleintr+0x19a>
80100931:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
80100936:	83 e8 80             	sub    $0xffffff80,%eax
80100939:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
8010093f:	0f 85 36 ff ff ff    	jne    8010087b <consoleintr+0x1b>
80100945:	e9 b5 00 00 00       	jmp    801009ff <consoleintr+0x19f>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100950:	83 fb 08             	cmp    $0x8,%ebx
80100953:	75 84                	jne    801008d9 <consoleintr+0x79>
      if(input.e != input.w){
80100955:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010095a:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100960:	0f 84 15 ff ff ff    	je     8010087b <consoleintr+0x1b>
        input.e--;
80100966:	83 e8 01             	sub    $0x1,%eax
80100969:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
  if(panicked){
8010096e:	a1 58 a5 10 80       	mov    0x8010a558,%eax
80100973:	85 c0                	test   %eax,%eax
80100975:	74 39                	je     801009b0 <consoleintr+0x150>
80100977:	fa                   	cli    
      ;
80100978:	eb fe                	jmp    80100978 <consoleintr+0x118>
8010097a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      doprocdump = 1;
80100980:	be 01 00 00 00       	mov    $0x1,%esi
80100985:	e9 f1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
8010098a:	b8 00 01 00 00       	mov    $0x100,%eax
8010098f:	e8 7c fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
80100994:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100999:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010099f:	0f 85 03 ff ff ff    	jne    801008a8 <consoleintr+0x48>
801009a5:	e9 d1 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
801009aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 56 fa ff ff       	call   80100410 <consputc.part.0>
801009ba:	e9 bc fe ff ff       	jmp    8010087b <consoleintr+0x1b>
  release(&cons.lock);
801009bf:	83 ec 0c             	sub    $0xc,%esp
801009c2:	68 20 a5 10 80       	push   $0x8010a520
801009c7:	e8 94 3b 00 00       	call   80104560 <release>
  if(doprocdump) {
801009cc:	83 c4 10             	add    $0x10,%esp
801009cf:	85 f6                	test   %esi,%esi
801009d1:	75 46                	jne    80100a19 <consoleintr+0x1b9>
}
801009d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009d6:	5b                   	pop    %ebx
801009d7:	5e                   	pop    %esi
801009d8:	5f                   	pop    %edi
801009d9:	5d                   	pop    %ebp
801009da:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009db:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
  if(panicked){
801009e2:	85 d2                	test   %edx,%edx
801009e4:	74 0a                	je     801009f0 <consoleintr+0x190>
801009e6:	fa                   	cli    
      ;
801009e7:	eb fe                	jmp    801009e7 <consoleintr+0x187>
801009e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f0:	b8 0a 00 00 00       	mov    $0xa,%eax
801009f5:	e8 16 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009fa:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
          wakeup(&input.r);
801009ff:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a02:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100a07:	68 a0 ff 10 80       	push   $0x8010ffa0
80100a0c:	e8 0f 36 00 00       	call   80104020 <wakeup>
80100a11:	83 c4 10             	add    $0x10,%esp
80100a14:	e9 62 fe ff ff       	jmp    8010087b <consoleintr+0x1b>
}
80100a19:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a1c:	5b                   	pop    %ebx
80100a1d:	5e                   	pop    %esi
80100a1e:	5f                   	pop    %edi
80100a1f:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a20:	e9 db 36 00 00       	jmp    80104100 <procdump>
80100a25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	55                   	push   %ebp
80100a31:	89 e5                	mov    %esp,%ebp
80100a33:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a36:	68 48 70 10 80       	push   $0x80107048
80100a3b:	68 20 a5 10 80       	push   $0x8010a520
80100a40:	e8 fb 38 00 00       	call   80104340 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a45:	58                   	pop    %eax
80100a46:	5a                   	pop    %edx
80100a47:	6a 00                	push   $0x0
80100a49:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4b:	c7 05 6c 09 11 80 30 	movl   $0x80100630,0x8011096c
80100a52:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a55:	c7 05 68 09 11 80 80 	movl   $0x80100280,0x80110968
80100a5c:	02 10 80 
  cons.locking = 1;
80100a5f:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100a66:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a69:	e8 32 19 00 00       	call   801023a0 <ioapicenable>
}
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	c9                   	leave  
80100a72:	c3                   	ret    
80100a73:	66 90                	xchg   %ax,%ax
80100a75:	66 90                	xchg   %ax,%ax
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	55                   	push   %ebp
80100a81:	89 e5                	mov    %esp,%ebp
80100a83:	57                   	push   %edi
80100a84:	56                   	push   %esi
80100a85:	53                   	push   %ebx
80100a86:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a8c:	e8 3f 2e 00 00       	call   801038d0 <myproc>
80100a91:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a97:	e8 f4 21 00 00       	call   80102c90 <begin_op>

  if((ip = namei(path)) == 0){
80100a9c:	83 ec 0c             	sub    $0xc,%esp
80100a9f:	ff 75 08             	pushl  0x8(%ebp)
80100aa2:	e8 09 15 00 00       	call   80101fb0 <namei>
80100aa7:	83 c4 10             	add    $0x10,%esp
80100aaa:	85 c0                	test   %eax,%eax
80100aac:	0f 84 02 03 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab2:	83 ec 0c             	sub    $0xc,%esp
80100ab5:	89 c3                	mov    %eax,%ebx
80100ab7:	50                   	push   %eax
80100ab8:	e8 53 0c 00 00       	call   80101710 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100abd:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac3:	6a 34                	push   $0x34
80100ac5:	6a 00                	push   $0x0
80100ac7:	50                   	push   %eax
80100ac8:	53                   	push   %ebx
80100ac9:	e8 22 0f 00 00       	call   801019f0 <readi>
80100ace:	83 c4 20             	add    $0x20,%esp
80100ad1:	83 f8 34             	cmp    $0x34,%eax
80100ad4:	74 22                	je     80100af8 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ad6:	83 ec 0c             	sub    $0xc,%esp
80100ad9:	53                   	push   %ebx
80100ada:	e8 c1 0e 00 00       	call   801019a0 <iunlockput>
    end_op();
80100adf:	e8 1c 22 00 00       	call   80102d00 <end_op>
80100ae4:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100ae7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100aec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aef:	5b                   	pop    %ebx
80100af0:	5e                   	pop    %esi
80100af1:	5f                   	pop    %edi
80100af2:	5d                   	pop    %ebp
80100af3:	c3                   	ret    
80100af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100af8:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100aff:	45 4c 46 
80100b02:	75 d2                	jne    80100ad6 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b04:	e8 37 62 00 00       	call   80106d40 <setupkvm>
80100b09:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b0f:	85 c0                	test   %eax,%eax
80100b11:	74 c3                	je     80100ad6 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b13:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b1a:	00 
80100b1b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b21:	0f 84 ac 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b27:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b2e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b31:	31 ff                	xor    %edi,%edi
80100b33:	e9 8e 00 00 00       	jmp    80100bc6 <exec+0x146>
80100b38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b3f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 e8 5f 00 00       	call   80106b60 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 f2 5e 00 00       	call   80106aa0 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 1a 0e 00 00       	call   801019f0 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 d0 60 00 00       	call   80106cc0 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 de fe ff ff       	jmp    80100ad6 <exec+0x56>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 7f 0d 00 00       	call   801019a0 <iunlockput>
  end_op();
80100c21:	e8 da 20 00 00       	call   80102d00 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 29 5f 00 00       	call   80106b60 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 88 61 00 00       	call   80106de0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 18 3b 00 00       	call   801047c0 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 05 3b 00 00       	call   801047c0 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 74 62 00 00       	call   80106f40 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 da 5f 00 00       	call   80106cc0 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 f9 fd ff ff       	jmp    80100aec <exec+0x6c>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 08 62 00 00       	call   80106f40 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 0a 3a 00 00       	call   80104780 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 6e 5b 00 00       	call   80106910 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 16 5f 00 00       	call   80106cc0 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 38 fd ff ff       	jmp    80100aec <exec+0x6c>
    end_op();
80100db4:	e8 47 1f 00 00       	call   80102d00 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 61 70 10 80       	push   $0x80107061
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 19 fd ff ff       	jmp    80100aec <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100de6:	68 6d 70 10 80       	push   $0x8010706d
80100deb:	68 c0 ff 10 80       	push   $0x8010ffc0
80100df0:	e8 4b 35 00 00       	call   80104340 <initlock>
}
80100df5:	83 c4 10             	add    $0x10,%esp
80100df8:	c9                   	leave  
80100df9:	c3                   	ret    
80100dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	55                   	push   %ebp
80100e01:	89 e5                	mov    %esp,%ebp
80100e03:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e04:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100e09:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e0c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e11:	e8 8a 36 00 00       	call   801044a0 <acquire>
80100e16:	83 c4 10             	add    $0x10,%esp
80100e19:	eb 10                	jmp    80100e2b <filealloc+0x2b>
80100e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e41:	e8 1a 37 00 00       	call   80104560 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e5a:	e8 01 37 00 00       	call   80104560 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	55                   	push   %ebp
80100e71:	89 e5                	mov    %esp,%ebp
80100e73:	53                   	push   %ebx
80100e74:	83 ec 10             	sub    $0x10,%esp
80100e77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7a:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e7f:	e8 1c 36 00 00       	call   801044a0 <acquire>
  if(f->ref < 1)
80100e84:	8b 43 04             	mov    0x4(%ebx),%eax
80100e87:	83 c4 10             	add    $0x10,%esp
80100e8a:	85 c0                	test   %eax,%eax
80100e8c:	7e 1a                	jle    80100ea8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e8e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e91:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e94:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e97:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e9c:	e8 bf 36 00 00       	call   80104560 <release>
  return f;
}
80100ea1:	89 d8                	mov    %ebx,%eax
80100ea3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ea6:	c9                   	leave  
80100ea7:	c3                   	ret    
    panic("filedup");
80100ea8:	83 ec 0c             	sub    $0xc,%esp
80100eab:	68 74 70 10 80       	push   $0x80107074
80100eb0:	e8 db f4 ff ff       	call   80100390 <panic>
80100eb5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ebc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	57                   	push   %edi
80100ec4:	56                   	push   %esi
80100ec5:	53                   	push   %ebx
80100ec6:	83 ec 28             	sub    $0x28,%esp
80100ec9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ecc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ed1:	e8 ca 35 00 00       	call   801044a0 <acquire>
  if(f->ref < 1)
80100ed6:	8b 43 04             	mov    0x4(%ebx),%eax
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	85 c0                	test   %eax,%eax
80100ede:	0f 8e a3 00 00 00    	jle    80100f87 <fileclose+0xc7>
    panic("fileclose");
  if(--f->ref > 0){
80100ee4:	83 e8 01             	sub    $0x1,%eax
80100ee7:	89 43 04             	mov    %eax,0x4(%ebx)
80100eea:	75 44                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100eec:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100efb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100efe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f01:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f04:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100f09:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f0c:	e8 4f 36 00 00       	call   80104560 <release>

  if(ff.type == FD_PIPE)
80100f11:	83 c4 10             	add    $0x10,%esp
80100f14:	83 ff 01             	cmp    $0x1,%edi
80100f17:	74 2f                	je     80100f48 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f19:	83 ff 02             	cmp    $0x2,%edi
80100f1c:	74 4a                	je     80100f68 <fileclose+0xa8>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f21:	5b                   	pop    %ebx
80100f22:	5e                   	pop    %esi
80100f23:	5f                   	pop    %edi
80100f24:	5d                   	pop    %ebp
80100f25:	c3                   	ret    
80100f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f2d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 1d 36 00 00       	jmp    80104560 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80100f48:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f4c:	83 ec 08             	sub    $0x8,%esp
80100f4f:	53                   	push   %ebx
80100f50:	56                   	push   %esi
80100f51:	e8 ea 24 00 00       	call   80103440 <pipeclose>
80100f56:	83 c4 10             	add    $0x10,%esp
}
80100f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5c:	5b                   	pop    %ebx
80100f5d:	5e                   	pop    %esi
80100f5e:	5f                   	pop    %edi
80100f5f:	5d                   	pop    %ebp
80100f60:	c3                   	ret    
80100f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f68:	e8 23 1d 00 00       	call   80102c90 <begin_op>
    iput(ff.ip);
80100f6d:	83 ec 0c             	sub    $0xc,%esp
80100f70:	ff 75 e0             	pushl  -0x20(%ebp)
80100f73:	e8 c8 08 00 00       	call   80101840 <iput>
    end_op();
80100f78:	83 c4 10             	add    $0x10,%esp
}
80100f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f7e:	5b                   	pop    %ebx
80100f7f:	5e                   	pop    %esi
80100f80:	5f                   	pop    %edi
80100f81:	5d                   	pop    %ebp
    end_op();
80100f82:	e9 79 1d 00 00       	jmp    80102d00 <end_op>
    panic("fileclose");
80100f87:	83 ec 0c             	sub    $0xc,%esp
80100f8a:	68 7c 70 10 80       	push   $0x8010707c
80100f8f:	e8 fc f3 ff ff       	call   80100390 <panic>
80100f94:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f9f:	90                   	nop

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	55                   	push   %ebp
80100fa1:	89 e5                	mov    %esp,%ebp
80100fa3:	53                   	push   %ebx
80100fa4:	83 ec 04             	sub    $0x4,%esp
80100fa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100faa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fad:	75 31                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	ff 73 10             	pushl  0x10(%ebx)
80100fb5:	e8 56 07 00 00       	call   80101710 <ilock>
    stati(f->ip, st);
80100fba:	58                   	pop    %eax
80100fbb:	5a                   	pop    %edx
80100fbc:	ff 75 0c             	pushl  0xc(%ebp)
80100fbf:	ff 73 10             	pushl  0x10(%ebx)
80100fc2:	e8 f9 09 00 00       	call   801019c0 <stati>
    iunlock(f->ip);
80100fc7:	59                   	pop    %ecx
80100fc8:	ff 73 10             	pushl  0x10(%ebx)
80100fcb:	e8 20 08 00 00       	call   801017f0 <iunlock>
    return 0;
80100fd0:	83 c4 10             	add    $0x10,%esp
80100fd3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100fd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd8:	c9                   	leave  
80100fd9:	c3                   	ret    
80100fda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 0c             	sub    $0xc,%esp
80100ff9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100ffc:	8b 75 0c             	mov    0xc(%ebp),%esi
80100fff:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101002:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101006:	74 60                	je     80101068 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101008:	8b 03                	mov    (%ebx),%eax
8010100a:	83 f8 01             	cmp    $0x1,%eax
8010100d:	74 41                	je     80101050 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100f:	83 f8 02             	cmp    $0x2,%eax
80101012:	75 5b                	jne    8010106f <fileread+0x7f>
    ilock(f->ip);
80101014:	83 ec 0c             	sub    $0xc,%esp
80101017:	ff 73 10             	pushl  0x10(%ebx)
8010101a:	e8 f1 06 00 00       	call   80101710 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010101f:	57                   	push   %edi
80101020:	ff 73 14             	pushl  0x14(%ebx)
80101023:	56                   	push   %esi
80101024:	ff 73 10             	pushl  0x10(%ebx)
80101027:	e8 c4 09 00 00       	call   801019f0 <readi>
8010102c:	83 c4 20             	add    $0x20,%esp
8010102f:	89 c6                	mov    %eax,%esi
80101031:	85 c0                	test   %eax,%eax
80101033:	7e 03                	jle    80101038 <fileread+0x48>
      f->off += r;
80101035:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101038:	83 ec 0c             	sub    $0xc,%esp
8010103b:	ff 73 10             	pushl  0x10(%ebx)
8010103e:	e8 ad 07 00 00       	call   801017f0 <iunlock>
    return r;
80101043:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101046:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101049:	89 f0                	mov    %esi,%eax
8010104b:	5b                   	pop    %ebx
8010104c:	5e                   	pop    %esi
8010104d:	5f                   	pop    %edi
8010104e:	5d                   	pop    %ebp
8010104f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101050:	8b 43 0c             	mov    0xc(%ebx),%eax
80101053:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101056:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101059:	5b                   	pop    %ebx
8010105a:	5e                   	pop    %esi
8010105b:	5f                   	pop    %edi
8010105c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010105d:	e9 8e 25 00 00       	jmp    801035f0 <piperead>
80101062:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101068:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010106d:	eb d7                	jmp    80101046 <fileread+0x56>
  panic("fileread");
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	68 86 70 10 80       	push   $0x80107086
80101077:	e8 14 f3 ff ff       	call   80100390 <panic>
8010107c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101080 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101080:	55                   	push   %ebp
80101081:	89 e5                	mov    %esp,%ebp
80101083:	57                   	push   %edi
80101084:	56                   	push   %esi
80101085:	53                   	push   %ebx
80101086:	83 ec 1c             	sub    $0x1c,%esp
80101089:	8b 45 0c             	mov    0xc(%ebp),%eax
8010108c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010108f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101092:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101095:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101099:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010109c:	0f 84 bb 00 00 00    	je     8010115d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
801010a2:	8b 03                	mov    (%ebx),%eax
801010a4:	83 f8 01             	cmp    $0x1,%eax
801010a7:	0f 84 bf 00 00 00    	je     8010116c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010ad:	83 f8 02             	cmp    $0x2,%eax
801010b0:	0f 85 c8 00 00 00    	jne    8010117e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010b9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010bb:	85 c0                	test   %eax,%eax
801010bd:	7f 30                	jg     801010ef <filewrite+0x6f>
801010bf:	e9 94 00 00 00       	jmp    80101158 <filewrite+0xd8>
801010c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010c8:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
801010cb:	83 ec 0c             	sub    $0xc,%esp
801010ce:	ff 73 10             	pushl  0x10(%ebx)
        f->off += r;
801010d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010d4:	e8 17 07 00 00       	call   801017f0 <iunlock>
      end_op();
801010d9:	e8 22 1c 00 00       	call   80102d00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010de:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e1:	83 c4 10             	add    $0x10,%esp
801010e4:	39 f0                	cmp    %esi,%eax
801010e6:	75 60                	jne    80101148 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
801010e8:	01 c7                	add    %eax,%edi
    while(i < n){
801010ea:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010ed:	7e 69                	jle    80101158 <filewrite+0xd8>
      int n1 = n - i;
801010ef:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801010f2:	b8 00 06 00 00       	mov    $0x600,%eax
801010f7:	29 fe                	sub    %edi,%esi
      if(n1 > max)
801010f9:	81 fe 00 06 00 00    	cmp    $0x600,%esi
801010ff:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101102:	e8 89 1b 00 00       	call   80102c90 <begin_op>
      ilock(f->ip);
80101107:	83 ec 0c             	sub    $0xc,%esp
8010110a:	ff 73 10             	pushl  0x10(%ebx)
8010110d:	e8 fe 05 00 00       	call   80101710 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101112:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101115:	56                   	push   %esi
80101116:	ff 73 14             	pushl  0x14(%ebx)
80101119:	01 f8                	add    %edi,%eax
8010111b:	50                   	push   %eax
8010111c:	ff 73 10             	pushl  0x10(%ebx)
8010111f:	e8 cc 09 00 00       	call   80101af0 <writei>
80101124:	83 c4 20             	add    $0x20,%esp
80101127:	85 c0                	test   %eax,%eax
80101129:	7f 9d                	jg     801010c8 <filewrite+0x48>
      iunlock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 73 10             	pushl  0x10(%ebx)
80101131:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101134:	e8 b7 06 00 00       	call   801017f0 <iunlock>
      end_op();
80101139:	e8 c2 1b 00 00       	call   80102d00 <end_op>
      if(r < 0)
8010113e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101141:	83 c4 10             	add    $0x10,%esp
80101144:	85 c0                	test   %eax,%eax
80101146:	75 15                	jne    8010115d <filewrite+0xdd>
        panic("short filewrite");
80101148:	83 ec 0c             	sub    $0xc,%esp
8010114b:	68 8f 70 10 80       	push   $0x8010708f
80101150:	e8 3b f2 ff ff       	call   80100390 <panic>
80101155:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101158:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010115b:	74 05                	je     80101162 <filewrite+0xe2>
8010115d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  }
  panic("filewrite");
}
80101162:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101165:	89 f8                	mov    %edi,%eax
80101167:	5b                   	pop    %ebx
80101168:	5e                   	pop    %esi
80101169:	5f                   	pop    %edi
8010116a:	5d                   	pop    %ebp
8010116b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010116c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010116f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101172:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101175:	5b                   	pop    %ebx
80101176:	5e                   	pop    %esi
80101177:	5f                   	pop    %edi
80101178:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101179:	e9 62 23 00 00       	jmp    801034e0 <pipewrite>
  panic("filewrite");
8010117e:	83 ec 0c             	sub    $0xc,%esp
80101181:	68 95 70 10 80       	push   $0x80107095
80101186:	e8 05 f2 ff ff       	call   80100390 <panic>
8010118b:	66 90                	xchg   %ax,%ax
8010118d:	66 90                	xchg   %ax,%ax
8010118f:	90                   	nop

80101190 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101190:	55                   	push   %ebp
80101191:	89 e5                	mov    %esp,%ebp
80101193:	56                   	push   %esi
80101194:	53                   	push   %ebx
80101195:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101197:	c1 ea 0c             	shr    $0xc,%edx
8010119a:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801011a0:	83 ec 08             	sub    $0x8,%esp
801011a3:	52                   	push   %edx
801011a4:	50                   	push   %eax
801011a5:	e8 26 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011aa:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011ac:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011af:	ba 01 00 00 00       	mov    $0x1,%edx
801011b4:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011b7:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011bd:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011c0:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011c2:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011c7:	85 d1                	test   %edx,%ecx
801011c9:	74 25                	je     801011f0 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011cb:	f7 d2                	not    %edx
801011cd:	89 c6                	mov    %eax,%esi
  log_write(bp);
801011cf:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801011d2:	21 ca                	and    %ecx,%edx
801011d4:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
801011d8:	56                   	push   %esi
801011d9:	e8 92 1c 00 00       	call   80102e70 <log_write>
  brelse(bp);
801011de:	89 34 24             	mov    %esi,(%esp)
801011e1:	e8 0a f0 ff ff       	call   801001f0 <brelse>
}
801011e6:	83 c4 10             	add    $0x10,%esp
801011e9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801011ec:	5b                   	pop    %ebx
801011ed:	5e                   	pop    %esi
801011ee:	5d                   	pop    %ebp
801011ef:	c3                   	ret    
    panic("freeing free block");
801011f0:	83 ec 0c             	sub    $0xc,%esp
801011f3:	68 9f 70 10 80       	push   $0x8010709f
801011f8:	e8 93 f1 ff ff       	call   80100390 <panic>
801011fd:	8d 76 00             	lea    0x0(%esi),%esi

80101200 <balloc>:
{
80101200:	55                   	push   %ebp
80101201:	89 e5                	mov    %esp,%ebp
80101203:	57                   	push   %edi
80101204:	56                   	push   %esi
80101205:	53                   	push   %ebx
80101206:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101209:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010120f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101212:	85 c9                	test   %ecx,%ecx
80101214:	0f 84 87 00 00 00    	je     801012a1 <balloc+0xa1>
8010121a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101221:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101224:	83 ec 08             	sub    $0x8,%esp
80101227:	89 f0                	mov    %esi,%eax
80101229:	c1 f8 0c             	sar    $0xc,%eax
8010122c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101232:	50                   	push   %eax
80101233:	ff 75 d8             	pushl  -0x28(%ebp)
80101236:	e8 95 ee ff ff       	call   801000d0 <bread>
8010123b:	83 c4 10             	add    $0x10,%esp
8010123e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101241:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101246:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101249:	31 c0                	xor    %eax,%eax
8010124b:	eb 2f                	jmp    8010127c <balloc+0x7c>
8010124d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101250:	89 c1                	mov    %eax,%ecx
80101252:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101257:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010125a:	83 e1 07             	and    $0x7,%ecx
8010125d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010125f:	89 c1                	mov    %eax,%ecx
80101261:	c1 f9 03             	sar    $0x3,%ecx
80101264:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101269:	89 fa                	mov    %edi,%edx
8010126b:	85 df                	test   %ebx,%edi
8010126d:	74 41                	je     801012b0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010126f:	83 c0 01             	add    $0x1,%eax
80101272:	83 c6 01             	add    $0x1,%esi
80101275:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010127a:	74 05                	je     80101281 <balloc+0x81>
8010127c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010127f:	77 cf                	ja     80101250 <balloc+0x50>
    brelse(bp);
80101281:	83 ec 0c             	sub    $0xc,%esp
80101284:	ff 75 e4             	pushl  -0x1c(%ebp)
80101287:	e8 64 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010128c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101293:	83 c4 10             	add    $0x10,%esp
80101296:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101299:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
8010129f:	77 80                	ja     80101221 <balloc+0x21>
  panic("balloc: out of blocks");
801012a1:	83 ec 0c             	sub    $0xc,%esp
801012a4:	68 b2 70 10 80       	push   $0x801070b2
801012a9:	e8 e2 f0 ff ff       	call   80100390 <panic>
801012ae:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012b3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012b6:	09 da                	or     %ebx,%edx
801012b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012bc:	57                   	push   %edi
801012bd:	e8 ae 1b 00 00       	call   80102e70 <log_write>
        brelse(bp);
801012c2:	89 3c 24             	mov    %edi,(%esp)
801012c5:	e8 26 ef ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012ca:	58                   	pop    %eax
801012cb:	5a                   	pop    %edx
801012cc:	56                   	push   %esi
801012cd:	ff 75 d8             	pushl  -0x28(%ebp)
801012d0:	e8 fb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801012d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801012d8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012da:	8d 40 5c             	lea    0x5c(%eax),%eax
801012dd:	68 00 02 00 00       	push   $0x200
801012e2:	6a 00                	push   $0x0
801012e4:	50                   	push   %eax
801012e5:	e8 c6 32 00 00       	call   801045b0 <memset>
  log_write(bp);
801012ea:	89 1c 24             	mov    %ebx,(%esp)
801012ed:	e8 7e 1b 00 00       	call   80102e70 <log_write>
  brelse(bp);
801012f2:	89 1c 24             	mov    %ebx,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	89 f0                	mov    %esi,%eax
801012ff:	5b                   	pop    %ebx
80101300:	5e                   	pop    %esi
80101301:	5f                   	pop    %edi
80101302:	5d                   	pop    %ebp
80101303:	c3                   	ret    
80101304:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010130b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010130f:	90                   	nop

80101310 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101310:	55                   	push   %ebp
80101311:	89 e5                	mov    %esp,%ebp
80101313:	57                   	push   %edi
80101314:	89 c7                	mov    %eax,%edi
80101316:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101317:	31 f6                	xor    %esi,%esi
{
80101319:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010131a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010131f:	83 ec 28             	sub    $0x28,%esp
80101322:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101325:	68 e0 09 11 80       	push   $0x801109e0
8010132a:	e8 71 31 00 00       	call   801044a0 <acquire>
8010132f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101332:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101335:	eb 1b                	jmp    80101352 <iget+0x42>
80101337:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101340:	39 3b                	cmp    %edi,(%ebx)
80101342:	74 6c                	je     801013b0 <iget+0xa0>
80101344:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101350:	73 26                	jae    80101378 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101352:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101355:	85 c9                	test   %ecx,%ecx
80101357:	7f e7                	jg     80101340 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101359:	85 f6                	test   %esi,%esi
8010135b:	75 e7                	jne    80101344 <iget+0x34>
8010135d:	8d 83 90 00 00 00    	lea    0x90(%ebx),%eax
80101363:	85 c9                	test   %ecx,%ecx
80101365:	75 70                	jne    801013d7 <iget+0xc7>
80101367:	89 de                	mov    %ebx,%esi
80101369:	89 c3                	mov    %eax,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136b:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101371:	72 df                	jb     80101352 <iget+0x42>
80101373:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101377:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101378:	85 f6                	test   %esi,%esi
8010137a:	74 74                	je     801013f0 <iget+0xe0>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010137c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010137f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101381:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101384:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010138b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101392:	68 e0 09 11 80       	push   $0x801109e0
80101397:	e8 c4 31 00 00       	call   80104560 <release>

  return ip;
8010139c:	83 c4 10             	add    $0x10,%esp
}
8010139f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013a2:	89 f0                	mov    %esi,%eax
801013a4:	5b                   	pop    %ebx
801013a5:	5e                   	pop    %esi
801013a6:	5f                   	pop    %edi
801013a7:	5d                   	pop    %ebp
801013a8:	c3                   	ret    
801013a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013b3:	75 8f                	jne    80101344 <iget+0x34>
      release(&icache.lock);
801013b5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013b8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013bb:	89 de                	mov    %ebx,%esi
      ip->ref++;
801013bd:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013c0:	68 e0 09 11 80       	push   $0x801109e0
801013c5:	e8 96 31 00 00       	call   80104560 <release>
      return ip;
801013ca:	83 c4 10             	add    $0x10,%esp
}
801013cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d0:	89 f0                	mov    %esi,%eax
801013d2:	5b                   	pop    %ebx
801013d3:	5e                   	pop    %esi
801013d4:	5f                   	pop    %edi
801013d5:	5d                   	pop    %ebp
801013d6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013d7:	3d 34 26 11 80       	cmp    $0x80112634,%eax
801013dc:	73 12                	jae    801013f0 <iget+0xe0>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013de:	8b 48 08             	mov    0x8(%eax),%ecx
801013e1:	89 c3                	mov    %eax,%ebx
801013e3:	85 c9                	test   %ecx,%ecx
801013e5:	0f 8f 55 ff ff ff    	jg     80101340 <iget+0x30>
801013eb:	e9 6d ff ff ff       	jmp    8010135d <iget+0x4d>
    panic("iget: no inodes");
801013f0:	83 ec 0c             	sub    $0xc,%esp
801013f3:	68 c8 70 10 80       	push   $0x801070c8
801013f8:	e8 93 ef ff ff       	call   80100390 <panic>
801013fd:	8d 76 00             	lea    0x0(%esi),%esi

80101400 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101400:	55                   	push   %ebp
80101401:	89 e5                	mov    %esp,%ebp
80101403:	57                   	push   %edi
80101404:	56                   	push   %esi
80101405:	89 c6                	mov    %eax,%esi
80101407:	53                   	push   %ebx
80101408:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010140b:	83 fa 0b             	cmp    $0xb,%edx
8010140e:	0f 86 84 00 00 00    	jbe    80101498 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101414:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101417:	83 fb 7f             	cmp    $0x7f,%ebx
8010141a:	0f 87 98 00 00 00    	ja     801014b8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101420:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101426:	8b 00                	mov    (%eax),%eax
80101428:	85 d2                	test   %edx,%edx
8010142a:	74 54                	je     80101480 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010142c:	83 ec 08             	sub    $0x8,%esp
8010142f:	52                   	push   %edx
80101430:	50                   	push   %eax
80101431:	e8 9a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101436:	83 c4 10             	add    $0x10,%esp
80101439:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010143d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010143f:	8b 1a                	mov    (%edx),%ebx
80101441:	85 db                	test   %ebx,%ebx
80101443:	74 1b                	je     80101460 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	57                   	push   %edi
80101449:	e8 a2 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010144e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101451:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101454:	89 d8                	mov    %ebx,%eax
80101456:	5b                   	pop    %ebx
80101457:	5e                   	pop    %esi
80101458:	5f                   	pop    %edi
80101459:	5d                   	pop    %ebp
8010145a:	c3                   	ret    
8010145b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010145f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101460:	8b 06                	mov    (%esi),%eax
80101462:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101465:	e8 96 fd ff ff       	call   80101200 <balloc>
8010146a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010146d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101470:	89 c3                	mov    %eax,%ebx
80101472:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101474:	57                   	push   %edi
80101475:	e8 f6 19 00 00       	call   80102e70 <log_write>
8010147a:	83 c4 10             	add    $0x10,%esp
8010147d:	eb c6                	jmp    80101445 <bmap+0x45>
8010147f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101480:	e8 7b fd ff ff       	call   80101200 <balloc>
80101485:	89 c2                	mov    %eax,%edx
80101487:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010148d:	8b 06                	mov    (%esi),%eax
8010148f:	eb 9b                	jmp    8010142c <bmap+0x2c>
80101491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101498:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010149b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010149e:	85 db                	test   %ebx,%ebx
801014a0:	75 af                	jne    80101451 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014a2:	8b 00                	mov    (%eax),%eax
801014a4:	e8 57 fd ff ff       	call   80101200 <balloc>
801014a9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014ac:	89 c3                	mov    %eax,%ebx
}
801014ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014b1:	89 d8                	mov    %ebx,%eax
801014b3:	5b                   	pop    %ebx
801014b4:	5e                   	pop    %esi
801014b5:	5f                   	pop    %edi
801014b6:	5d                   	pop    %ebp
801014b7:	c3                   	ret    
  panic("bmap: out of range");
801014b8:	83 ec 0c             	sub    $0xc,%esp
801014bb:	68 d8 70 10 80       	push   $0x801070d8
801014c0:	e8 cb ee ff ff       	call   80100390 <panic>
801014c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801014d0 <readsb>:
{
801014d0:	55                   	push   %ebp
801014d1:	89 e5                	mov    %esp,%ebp
801014d3:	56                   	push   %esi
801014d4:	53                   	push   %ebx
801014d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801014d8:	83 ec 08             	sub    $0x8,%esp
801014db:	6a 01                	push   $0x1
801014dd:	ff 75 08             	pushl  0x8(%ebp)
801014e0:	e8 eb eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801014e5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801014e8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801014ea:	8d 40 5c             	lea    0x5c(%eax),%eax
801014ed:	6a 1c                	push   $0x1c
801014ef:	50                   	push   %eax
801014f0:	56                   	push   %esi
801014f1:	e8 5a 31 00 00       	call   80104650 <memmove>
  brelse(bp);
801014f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014f9:	83 c4 10             	add    $0x10,%esp
}
801014fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014ff:	5b                   	pop    %ebx
80101500:	5e                   	pop    %esi
80101501:	5d                   	pop    %ebp
  brelse(bp);
80101502:	e9 e9 ec ff ff       	jmp    801001f0 <brelse>
80101507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010150e:	66 90                	xchg   %ax,%ax

80101510 <iinit>:
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	53                   	push   %ebx
80101514:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101519:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010151c:	68 eb 70 10 80       	push   $0x801070eb
80101521:	68 e0 09 11 80       	push   $0x801109e0
80101526:	e8 15 2e 00 00       	call   80104340 <initlock>
  for(i = 0; i < NINODE; i++) {
8010152b:	83 c4 10             	add    $0x10,%esp
8010152e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101530:	83 ec 08             	sub    $0x8,%esp
80101533:	68 f2 70 10 80       	push   $0x801070f2
80101538:	53                   	push   %ebx
80101539:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010153f:	e8 cc 2c 00 00       	call   80104210 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101544:	83 c4 10             	add    $0x10,%esp
80101547:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
8010154d:	75 e1                	jne    80101530 <iinit+0x20>
  readsb(dev, &sb);
8010154f:	83 ec 08             	sub    $0x8,%esp
80101552:	68 c0 09 11 80       	push   $0x801109c0
80101557:	ff 75 08             	pushl  0x8(%ebp)
8010155a:	e8 71 ff ff ff       	call   801014d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010155f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101565:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010156b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101571:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101577:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010157d:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101583:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101589:	68 58 71 10 80       	push   $0x80107158
8010158e:	e8 1d f1 ff ff       	call   801006b0 <cprintf>
}
80101593:	83 c4 30             	add    $0x30,%esp
80101596:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101599:	c9                   	leave  
8010159a:	c3                   	ret    
8010159b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010159f:	90                   	nop

801015a0 <ialloc>:
{
801015a0:	55                   	push   %ebp
801015a1:	89 e5                	mov    %esp,%ebp
801015a3:	57                   	push   %edi
801015a4:	56                   	push   %esi
801015a5:	53                   	push   %ebx
801015a6:	83 ec 1c             	sub    $0x1c,%esp
801015a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015ac:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
801015b3:	8b 75 08             	mov    0x8(%ebp),%esi
801015b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015b9:	0f 86 91 00 00 00    	jbe    80101650 <ialloc+0xb0>
801015bf:	bb 01 00 00 00       	mov    $0x1,%ebx
801015c4:	eb 21                	jmp    801015e7 <ialloc+0x47>
801015c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801015d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015d3:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
801015d6:	57                   	push   %edi
801015d7:	e8 14 ec ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801015dc:	83 c4 10             	add    $0x10,%esp
801015df:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
801015e5:	73 69                	jae    80101650 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801015e7:	89 d8                	mov    %ebx,%eax
801015e9:	83 ec 08             	sub    $0x8,%esp
801015ec:	c1 e8 03             	shr    $0x3,%eax
801015ef:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015f5:	50                   	push   %eax
801015f6:	56                   	push   %esi
801015f7:	e8 d4 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801015fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801015ff:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
80101601:	89 d8                	mov    %ebx,%eax
80101603:	83 e0 07             	and    $0x7,%eax
80101606:	c1 e0 06             	shl    $0x6,%eax
80101609:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010160d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101611:	75 bd                	jne    801015d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101613:	83 ec 04             	sub    $0x4,%esp
80101616:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101619:	6a 40                	push   $0x40
8010161b:	6a 00                	push   $0x0
8010161d:	51                   	push   %ecx
8010161e:	e8 8d 2f 00 00       	call   801045b0 <memset>
      dip->type = type;
80101623:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101627:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010162a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010162d:	89 3c 24             	mov    %edi,(%esp)
80101630:	e8 3b 18 00 00       	call   80102e70 <log_write>
      brelse(bp);
80101635:	89 3c 24             	mov    %edi,(%esp)
80101638:	e8 b3 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010163d:	83 c4 10             	add    $0x10,%esp
}
80101640:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101643:	89 da                	mov    %ebx,%edx
80101645:	89 f0                	mov    %esi,%eax
}
80101647:	5b                   	pop    %ebx
80101648:	5e                   	pop    %esi
80101649:	5f                   	pop    %edi
8010164a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010164b:	e9 c0 fc ff ff       	jmp    80101310 <iget>
  panic("ialloc: no inodes");
80101650:	83 ec 0c             	sub    $0xc,%esp
80101653:	68 f8 70 10 80       	push   $0x801070f8
80101658:	e8 33 ed ff ff       	call   80100390 <panic>
8010165d:	8d 76 00             	lea    0x0(%esi),%esi

80101660 <iupdate>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	56                   	push   %esi
80101664:	53                   	push   %ebx
80101665:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101668:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010166b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010166e:	83 ec 08             	sub    $0x8,%esp
80101671:	c1 e8 03             	shr    $0x3,%eax
80101674:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010167a:	50                   	push   %eax
8010167b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010167e:	e8 4d ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101683:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101687:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010168a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010168c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010168f:	83 e0 07             	and    $0x7,%eax
80101692:	c1 e0 06             	shl    $0x6,%eax
80101695:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101699:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010169c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bd:	6a 34                	push   $0x34
801016bf:	53                   	push   %ebx
801016c0:	50                   	push   %eax
801016c1:	e8 8a 2f 00 00       	call   80104650 <memmove>
  log_write(bp);
801016c6:	89 34 24             	mov    %esi,(%esp)
801016c9:	e8 a2 17 00 00       	call   80102e70 <log_write>
  brelse(bp);
801016ce:	89 75 08             	mov    %esi,0x8(%ebp)
801016d1:	83 c4 10             	add    $0x10,%esp
}
801016d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016d7:	5b                   	pop    %ebx
801016d8:	5e                   	pop    %esi
801016d9:	5d                   	pop    %ebp
  brelse(bp);
801016da:	e9 11 eb ff ff       	jmp    801001f0 <brelse>
801016df:	90                   	nop

801016e0 <idup>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	53                   	push   %ebx
801016e4:	83 ec 10             	sub    $0x10,%esp
801016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ea:	68 e0 09 11 80       	push   $0x801109e0
801016ef:	e8 ac 2d 00 00       	call   801044a0 <acquire>
  ip->ref++;
801016f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016f8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016ff:	e8 5c 2e 00 00       	call   80104560 <release>
}
80101704:	89 d8                	mov    %ebx,%eax
80101706:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101709:	c9                   	leave  
8010170a:	c3                   	ret    
8010170b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010170f:	90                   	nop

80101710 <ilock>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	56                   	push   %esi
80101714:	53                   	push   %ebx
80101715:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101718:	85 db                	test   %ebx,%ebx
8010171a:	0f 84 b7 00 00 00    	je     801017d7 <ilock+0xc7>
80101720:	8b 53 08             	mov    0x8(%ebx),%edx
80101723:	85 d2                	test   %edx,%edx
80101725:	0f 8e ac 00 00 00    	jle    801017d7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010172b:	83 ec 0c             	sub    $0xc,%esp
8010172e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101731:	50                   	push   %eax
80101732:	e8 19 2b 00 00       	call   80104250 <acquiresleep>
  if(ip->valid == 0){
80101737:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010173a:	83 c4 10             	add    $0x10,%esp
8010173d:	85 c0                	test   %eax,%eax
8010173f:	74 0f                	je     80101750 <ilock+0x40>
}
80101741:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101744:	5b                   	pop    %ebx
80101745:	5e                   	pop    %esi
80101746:	5d                   	pop    %ebp
80101747:	c3                   	ret    
80101748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101750:	8b 43 04             	mov    0x4(%ebx),%eax
80101753:	83 ec 08             	sub    $0x8,%esp
80101756:	c1 e8 03             	shr    $0x3,%eax
80101759:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010175f:	50                   	push   %eax
80101760:	ff 33                	pushl  (%ebx)
80101762:	e8 69 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101767:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010176c:	8b 43 04             	mov    0x4(%ebx),%eax
8010176f:	83 e0 07             	and    $0x7,%eax
80101772:	c1 e0 06             	shl    $0x6,%eax
80101775:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101779:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010177c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010177f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101783:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101787:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010178b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010178f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101793:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101797:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010179b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010179e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017a1:	6a 34                	push   $0x34
801017a3:	50                   	push   %eax
801017a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017a7:	50                   	push   %eax
801017a8:	e8 a3 2e 00 00       	call   80104650 <memmove>
    brelse(bp);
801017ad:	89 34 24             	mov    %esi,(%esp)
801017b0:	e8 3b ea ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801017b5:	83 c4 10             	add    $0x10,%esp
801017b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017c4:	0f 85 77 ff ff ff    	jne    80101741 <ilock+0x31>
      panic("ilock: no type");
801017ca:	83 ec 0c             	sub    $0xc,%esp
801017cd:	68 10 71 10 80       	push   $0x80107110
801017d2:	e8 b9 eb ff ff       	call   80100390 <panic>
    panic("ilock");
801017d7:	83 ec 0c             	sub    $0xc,%esp
801017da:	68 0a 71 10 80       	push   $0x8010710a
801017df:	e8 ac eb ff ff       	call   80100390 <panic>
801017e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801017ef:	90                   	nop

801017f0 <iunlock>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	56                   	push   %esi
801017f4:	53                   	push   %ebx
801017f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017f8:	85 db                	test   %ebx,%ebx
801017fa:	74 28                	je     80101824 <iunlock+0x34>
801017fc:	83 ec 0c             	sub    $0xc,%esp
801017ff:	8d 73 0c             	lea    0xc(%ebx),%esi
80101802:	56                   	push   %esi
80101803:	e8 e8 2a 00 00       	call   801042f0 <holdingsleep>
80101808:	83 c4 10             	add    $0x10,%esp
8010180b:	85 c0                	test   %eax,%eax
8010180d:	74 15                	je     80101824 <iunlock+0x34>
8010180f:	8b 43 08             	mov    0x8(%ebx),%eax
80101812:	85 c0                	test   %eax,%eax
80101814:	7e 0e                	jle    80101824 <iunlock+0x34>
  releasesleep(&ip->lock);
80101816:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101819:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010181c:	5b                   	pop    %ebx
8010181d:	5e                   	pop    %esi
8010181e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010181f:	e9 8c 2a 00 00       	jmp    801042b0 <releasesleep>
    panic("iunlock");
80101824:	83 ec 0c             	sub    $0xc,%esp
80101827:	68 1f 71 10 80       	push   $0x8010711f
8010182c:	e8 5f eb ff ff       	call   80100390 <panic>
80101831:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101838:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iput>:
{
80101840:	55                   	push   %ebp
80101841:	89 e5                	mov    %esp,%ebp
80101843:	57                   	push   %edi
80101844:	56                   	push   %esi
80101845:	53                   	push   %ebx
80101846:	83 ec 28             	sub    $0x28,%esp
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010184c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010184f:	57                   	push   %edi
80101850:	e8 fb 29 00 00       	call   80104250 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101855:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101858:	83 c4 10             	add    $0x10,%esp
8010185b:	85 d2                	test   %edx,%edx
8010185d:	74 07                	je     80101866 <iput+0x26>
8010185f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101864:	74 32                	je     80101898 <iput+0x58>
  releasesleep(&ip->lock);
80101866:	83 ec 0c             	sub    $0xc,%esp
80101869:	57                   	push   %edi
8010186a:	e8 41 2a 00 00       	call   801042b0 <releasesleep>
  acquire(&icache.lock);
8010186f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101876:	e8 25 2c 00 00       	call   801044a0 <acquire>
  ip->ref--;
8010187b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010187f:	83 c4 10             	add    $0x10,%esp
80101882:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101889:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5f                   	pop    %edi
8010188f:	5d                   	pop    %ebp
  release(&icache.lock);
80101890:	e9 cb 2c 00 00       	jmp    80104560 <release>
80101895:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101898:	83 ec 0c             	sub    $0xc,%esp
8010189b:	68 e0 09 11 80       	push   $0x801109e0
801018a0:	e8 fb 2b 00 00       	call   801044a0 <acquire>
    int r = ip->ref;
801018a5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018a8:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801018af:	e8 ac 2c 00 00       	call   80104560 <release>
    if(r == 1){
801018b4:	83 c4 10             	add    $0x10,%esp
801018b7:	83 fe 01             	cmp    $0x1,%esi
801018ba:	75 aa                	jne    80101866 <iput+0x26>
801018bc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018c8:	89 cf                	mov    %ecx,%edi
801018ca:	eb 0b                	jmp    801018d7 <iput+0x97>
801018cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801018d0:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801018d3:	39 fe                	cmp    %edi,%esi
801018d5:	74 19                	je     801018f0 <iput+0xb0>
    if(ip->addrs[i]){
801018d7:	8b 16                	mov    (%esi),%edx
801018d9:	85 d2                	test   %edx,%edx
801018db:	74 f3                	je     801018d0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801018dd:	8b 03                	mov    (%ebx),%eax
801018df:	e8 ac f8 ff ff       	call   80101190 <bfree>
      ip->addrs[i] = 0;
801018e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801018ea:	eb e4                	jmp    801018d0 <iput+0x90>
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801018f0:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801018f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018f9:	85 c0                	test   %eax,%eax
801018fb:	75 33                	jne    80101930 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801018fd:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101900:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101907:	53                   	push   %ebx
80101908:	e8 53 fd ff ff       	call   80101660 <iupdate>
      ip->type = 0;
8010190d:	31 c0                	xor    %eax,%eax
8010190f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101913:	89 1c 24             	mov    %ebx,(%esp)
80101916:	e8 45 fd ff ff       	call   80101660 <iupdate>
      ip->valid = 0;
8010191b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101922:	83 c4 10             	add    $0x10,%esp
80101925:	e9 3c ff ff ff       	jmp    80101866 <iput+0x26>
8010192a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101930:	83 ec 08             	sub    $0x8,%esp
80101933:	50                   	push   %eax
80101934:	ff 33                	pushl  (%ebx)
80101936:	e8 95 e7 ff ff       	call   801000d0 <bread>
8010193b:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010193e:	83 c4 10             	add    $0x10,%esp
80101941:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101947:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
8010194a:	8d 70 5c             	lea    0x5c(%eax),%esi
8010194d:	89 cf                	mov    %ecx,%edi
8010194f:	eb 0e                	jmp    8010195f <iput+0x11f>
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101958:	83 c6 04             	add    $0x4,%esi
8010195b:	39 f7                	cmp    %esi,%edi
8010195d:	74 11                	je     80101970 <iput+0x130>
      if(a[j])
8010195f:	8b 16                	mov    (%esi),%edx
80101961:	85 d2                	test   %edx,%edx
80101963:	74 f3                	je     80101958 <iput+0x118>
        bfree(ip->dev, a[j]);
80101965:	8b 03                	mov    (%ebx),%eax
80101967:	e8 24 f8 ff ff       	call   80101190 <bfree>
8010196c:	eb ea                	jmp    80101958 <iput+0x118>
8010196e:	66 90                	xchg   %ax,%ax
    brelse(bp);
80101970:	83 ec 0c             	sub    $0xc,%esp
80101973:	ff 75 e4             	pushl  -0x1c(%ebp)
80101976:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101979:	e8 72 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010197e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101984:	8b 03                	mov    (%ebx),%eax
80101986:	e8 05 f8 ff ff       	call   80101190 <bfree>
    ip->addrs[NDIRECT] = 0;
8010198b:	83 c4 10             	add    $0x10,%esp
8010198e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101995:	00 00 00 
80101998:	e9 60 ff ff ff       	jmp    801018fd <iput+0xbd>
8010199d:	8d 76 00             	lea    0x0(%esi),%esi

801019a0 <iunlockput>:
{
801019a0:	55                   	push   %ebp
801019a1:	89 e5                	mov    %esp,%ebp
801019a3:	53                   	push   %ebx
801019a4:	83 ec 10             	sub    $0x10,%esp
801019a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019aa:	53                   	push   %ebx
801019ab:	e8 40 fe ff ff       	call   801017f0 <iunlock>
  iput(ip);
801019b0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019b3:	83 c4 10             	add    $0x10,%esp
}
801019b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019b9:	c9                   	leave  
  iput(ip);
801019ba:	e9 81 fe ff ff       	jmp    80101840 <iput>
801019bf:	90                   	nop

801019c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	8b 55 08             	mov    0x8(%ebp),%edx
801019c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019c9:	8b 0a                	mov    (%edx),%ecx
801019cb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801019d1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801019d4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801019d8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801019db:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801019df:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801019e3:	8b 52 58             	mov    0x58(%edx),%edx
801019e6:	89 50 10             	mov    %edx,0x10(%eax)
}
801019e9:	5d                   	pop    %ebp
801019ea:	c3                   	ret    
801019eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801019ef:	90                   	nop

801019f0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	57                   	push   %edi
801019f4:	56                   	push   %esi
801019f5:	53                   	push   %ebx
801019f6:	83 ec 1c             	sub    $0x1c,%esp
801019f9:	8b 7d 0c             	mov    0xc(%ebp),%edi
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	8b 75 10             	mov    0x10(%ebp),%esi
80101a02:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a05:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a08:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a0d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a10:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a13:	0f 84 a7 00 00 00    	je     80101ac0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a1c:	8b 40 58             	mov    0x58(%eax),%eax
80101a1f:	39 c6                	cmp    %eax,%esi
80101a21:	0f 87 ba 00 00 00    	ja     80101ae1 <readi+0xf1>
80101a27:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a2a:	31 c9                	xor    %ecx,%ecx
80101a2c:	89 da                	mov    %ebx,%edx
80101a2e:	01 f2                	add    %esi,%edx
80101a30:	0f 92 c1             	setb   %cl
80101a33:	89 cf                	mov    %ecx,%edi
80101a35:	0f 82 a6 00 00 00    	jb     80101ae1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a3b:	89 c1                	mov    %eax,%ecx
80101a3d:	29 f1                	sub    %esi,%ecx
80101a3f:	39 d0                	cmp    %edx,%eax
80101a41:	0f 43 cb             	cmovae %ebx,%ecx
80101a44:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a47:	85 c9                	test   %ecx,%ecx
80101a49:	74 67                	je     80101ab2 <readi+0xc2>
80101a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a50:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a53:	89 f2                	mov    %esi,%edx
80101a55:	c1 ea 09             	shr    $0x9,%edx
80101a58:	89 d8                	mov    %ebx,%eax
80101a5a:	e8 a1 f9 ff ff       	call   80101400 <bmap>
80101a5f:	83 ec 08             	sub    $0x8,%esp
80101a62:	50                   	push   %eax
80101a63:	ff 33                	pushl  (%ebx)
80101a65:	e8 66 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a6a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a6d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101a72:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a75:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a77:	89 f0                	mov    %esi,%eax
80101a79:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a7e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a80:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a83:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a85:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a89:	39 d9                	cmp    %ebx,%ecx
80101a8b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a8e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a8f:	01 df                	add    %ebx,%edi
80101a91:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a93:	50                   	push   %eax
80101a94:	ff 75 e0             	pushl  -0x20(%ebp)
80101a97:	e8 b4 2b 00 00       	call   80104650 <memmove>
    brelse(bp);
80101a9c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a9f:	89 14 24             	mov    %edx,(%esp)
80101aa2:	e8 49 e7 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aa7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101aaa:	83 c4 10             	add    $0x10,%esp
80101aad:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ab0:	77 9e                	ja     80101a50 <readi+0x60>
  }
  return n;
80101ab2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ab5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ab8:	5b                   	pop    %ebx
80101ab9:	5e                   	pop    %esi
80101aba:	5f                   	pop    %edi
80101abb:	5d                   	pop    %ebp
80101abc:	c3                   	ret    
80101abd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101ac0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ac4:	66 83 f8 09          	cmp    $0x9,%ax
80101ac8:	77 17                	ja     80101ae1 <readi+0xf1>
80101aca:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101ad1:	85 c0                	test   %eax,%eax
80101ad3:	74 0c                	je     80101ae1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ad5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ad8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101adb:	5b                   	pop    %ebx
80101adc:	5e                   	pop    %esi
80101add:	5f                   	pop    %edi
80101ade:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101adf:	ff e0                	jmp    *%eax
      return -1;
80101ae1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ae6:	eb cd                	jmp    80101ab5 <readi+0xc5>
80101ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aef:	90                   	nop

80101af0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	57                   	push   %edi
80101af4:	56                   	push   %esi
80101af5:	53                   	push   %ebx
80101af6:	83 ec 1c             	sub    $0x1c,%esp
80101af9:	8b 45 08             	mov    0x8(%ebp),%eax
80101afc:	8b 75 0c             	mov    0xc(%ebp),%esi
80101aff:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b02:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b07:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b0a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b0d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b10:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b13:	0f 84 b7 00 00 00    	je     80101bd0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b19:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b1f:	0f 82 e7 00 00 00    	jb     80101c0c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b25:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b28:	89 f8                	mov    %edi,%eax
80101b2a:	01 f0                	add    %esi,%eax
80101b2c:	0f 82 da 00 00 00    	jb     80101c0c <writei+0x11c>
80101b32:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b37:	0f 87 cf 00 00 00    	ja     80101c0c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b3d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b44:	85 ff                	test   %edi,%edi
80101b46:	74 79                	je     80101bc1 <writei+0xd1>
80101b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b4f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b50:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b53:	89 f2                	mov    %esi,%edx
80101b55:	c1 ea 09             	shr    $0x9,%edx
80101b58:	89 f8                	mov    %edi,%eax
80101b5a:	e8 a1 f8 ff ff       	call   80101400 <bmap>
80101b5f:	83 ec 08             	sub    $0x8,%esp
80101b62:	50                   	push   %eax
80101b63:	ff 37                	pushl  (%edi)
80101b65:	e8 66 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b6a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b6f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b72:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b75:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b77:	89 f0                	mov    %esi,%eax
80101b79:	83 c4 0c             	add    $0xc,%esp
80101b7c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b81:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b83:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b87:	39 d9                	cmp    %ebx,%ecx
80101b89:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b8c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b8d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b8f:	ff 75 dc             	pushl  -0x24(%ebp)
80101b92:	50                   	push   %eax
80101b93:	e8 b8 2a 00 00       	call   80104650 <memmove>
    log_write(bp);
80101b98:	89 3c 24             	mov    %edi,(%esp)
80101b9b:	e8 d0 12 00 00       	call   80102e70 <log_write>
    brelse(bp);
80101ba0:	89 3c 24             	mov    %edi,(%esp)
80101ba3:	e8 48 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ba8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bab:	83 c4 10             	add    $0x10,%esp
80101bae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101bb1:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bb4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101bb7:	77 97                	ja     80101b50 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101bb9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bbc:	3b 70 58             	cmp    0x58(%eax),%esi
80101bbf:	77 37                	ja     80101bf8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bc7:	5b                   	pop    %ebx
80101bc8:	5e                   	pop    %esi
80101bc9:	5f                   	pop    %edi
80101bca:	5d                   	pop    %ebp
80101bcb:	c3                   	ret    
80101bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101bd0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101bd4:	66 83 f8 09          	cmp    $0x9,%ax
80101bd8:	77 32                	ja     80101c0c <writei+0x11c>
80101bda:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101be1:	85 c0                	test   %eax,%eax
80101be3:	74 27                	je     80101c0c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101be5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101be8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101beb:	5b                   	pop    %ebx
80101bec:	5e                   	pop    %esi
80101bed:	5f                   	pop    %edi
80101bee:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101bef:	ff e0                	jmp    *%eax
80101bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101bf8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101bfb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101bfe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c01:	50                   	push   %eax
80101c02:	e8 59 fa ff ff       	call   80101660 <iupdate>
80101c07:	83 c4 10             	add    $0x10,%esp
80101c0a:	eb b5                	jmp    80101bc1 <writei+0xd1>
      return -1;
80101c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c11:	eb b1                	jmp    80101bc4 <writei+0xd4>
80101c13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c20 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c26:	6a 0e                	push   $0xe
80101c28:	ff 75 0c             	pushl  0xc(%ebp)
80101c2b:	ff 75 08             	pushl  0x8(%ebp)
80101c2e:	e8 8d 2a 00 00       	call   801046c0 <strncmp>
}
80101c33:	c9                   	leave  
80101c34:	c3                   	ret    
80101c35:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101c40 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 1c             	sub    $0x1c,%esp
80101c49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c4c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c51:	0f 85 85 00 00 00    	jne    80101cdc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c57:	8b 53 58             	mov    0x58(%ebx),%edx
80101c5a:	31 ff                	xor    %edi,%edi
80101c5c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c5f:	85 d2                	test   %edx,%edx
80101c61:	74 3e                	je     80101ca1 <dirlookup+0x61>
80101c63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c67:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c68:	6a 10                	push   $0x10
80101c6a:	57                   	push   %edi
80101c6b:	56                   	push   %esi
80101c6c:	53                   	push   %ebx
80101c6d:	e8 7e fd ff ff       	call   801019f0 <readi>
80101c72:	83 c4 10             	add    $0x10,%esp
80101c75:	83 f8 10             	cmp    $0x10,%eax
80101c78:	75 55                	jne    80101ccf <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101c7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c7f:	74 18                	je     80101c99 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c81:	83 ec 04             	sub    $0x4,%esp
80101c84:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c87:	6a 0e                	push   $0xe
80101c89:	50                   	push   %eax
80101c8a:	ff 75 0c             	pushl  0xc(%ebp)
80101c8d:	e8 2e 2a 00 00       	call   801046c0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c92:	83 c4 10             	add    $0x10,%esp
80101c95:	85 c0                	test   %eax,%eax
80101c97:	74 17                	je     80101cb0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c99:	83 c7 10             	add    $0x10,%edi
80101c9c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c9f:	72 c7                	jb     80101c68 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101ca4:	31 c0                	xor    %eax,%eax
}
80101ca6:	5b                   	pop    %ebx
80101ca7:	5e                   	pop    %esi
80101ca8:	5f                   	pop    %edi
80101ca9:	5d                   	pop    %ebp
80101caa:	c3                   	ret    
80101cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101caf:	90                   	nop
      if(poff)
80101cb0:	8b 45 10             	mov    0x10(%ebp),%eax
80101cb3:	85 c0                	test   %eax,%eax
80101cb5:	74 05                	je     80101cbc <dirlookup+0x7c>
        *poff = off;
80101cb7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cba:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cbc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cc0:	8b 03                	mov    (%ebx),%eax
80101cc2:	e8 49 f6 ff ff       	call   80101310 <iget>
}
80101cc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cca:	5b                   	pop    %ebx
80101ccb:	5e                   	pop    %esi
80101ccc:	5f                   	pop    %edi
80101ccd:	5d                   	pop    %ebp
80101cce:	c3                   	ret    
      panic("dirlookup read");
80101ccf:	83 ec 0c             	sub    $0xc,%esp
80101cd2:	68 39 71 10 80       	push   $0x80107139
80101cd7:	e8 b4 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	68 27 71 10 80       	push   $0x80107127
80101ce4:	e8 a7 e6 ff ff       	call   80100390 <panic>
80101ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cf0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cf0:	55                   	push   %ebp
80101cf1:	89 e5                	mov    %esp,%ebp
80101cf3:	57                   	push   %edi
80101cf4:	56                   	push   %esi
80101cf5:	53                   	push   %ebx
80101cf6:	89 c3                	mov    %eax,%ebx
80101cf8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cfb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cfe:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d01:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d04:	0f 84 86 01 00 00    	je     80101e90 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d0a:	e8 c1 1b 00 00       	call   801038d0 <myproc>
  acquire(&icache.lock);
80101d0f:	83 ec 0c             	sub    $0xc,%esp
80101d12:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d14:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d17:	68 e0 09 11 80       	push   $0x801109e0
80101d1c:	e8 7f 27 00 00       	call   801044a0 <acquire>
  ip->ref++;
80101d21:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d25:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101d2c:	e8 2f 28 00 00       	call   80104560 <release>
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	eb 0d                	jmp    80101d43 <namex+0x53>
80101d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101d43:	0f b6 07             	movzbl (%edi),%eax
80101d46:	3c 2f                	cmp    $0x2f,%al
80101d48:	74 f6                	je     80101d40 <namex+0x50>
  if(*path == 0)
80101d4a:	84 c0                	test   %al,%al
80101d4c:	0f 84 ee 00 00 00    	je     80101e40 <namex+0x150>
  while(*path != '/' && *path != 0)
80101d52:	0f b6 07             	movzbl (%edi),%eax
80101d55:	84 c0                	test   %al,%al
80101d57:	0f 84 fb 00 00 00    	je     80101e58 <namex+0x168>
80101d5d:	89 fb                	mov    %edi,%ebx
80101d5f:	3c 2f                	cmp    $0x2f,%al
80101d61:	0f 84 f1 00 00 00    	je     80101e58 <namex+0x168>
80101d67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6e:	66 90                	xchg   %ax,%ax
    path++;
80101d70:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101d73:	0f b6 03             	movzbl (%ebx),%eax
80101d76:	3c 2f                	cmp    $0x2f,%al
80101d78:	74 04                	je     80101d7e <namex+0x8e>
80101d7a:	84 c0                	test   %al,%al
80101d7c:	75 f2                	jne    80101d70 <namex+0x80>
  len = path - s;
80101d7e:	89 d8                	mov    %ebx,%eax
80101d80:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101d82:	83 f8 0d             	cmp    $0xd,%eax
80101d85:	0f 8e 85 00 00 00    	jle    80101e10 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101d8b:	83 ec 04             	sub    $0x4,%esp
80101d8e:	6a 0e                	push   $0xe
80101d90:	57                   	push   %edi
    path++;
80101d91:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101d93:	ff 75 e4             	pushl  -0x1c(%ebp)
80101d96:	e8 b5 28 00 00       	call   80104650 <memmove>
80101d9b:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101d9e:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101da1:	75 0d                	jne    80101db0 <namex+0xc0>
80101da3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101da7:	90                   	nop
    path++;
80101da8:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dab:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101dae:	74 f8                	je     80101da8 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101db0:	83 ec 0c             	sub    $0xc,%esp
80101db3:	56                   	push   %esi
80101db4:	e8 57 f9 ff ff       	call   80101710 <ilock>
    if(ip->type != T_DIR){
80101db9:	83 c4 10             	add    $0x10,%esp
80101dbc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101dc1:	0f 85 a1 00 00 00    	jne    80101e68 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101dc7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101dca:	85 d2                	test   %edx,%edx
80101dcc:	74 09                	je     80101dd7 <namex+0xe7>
80101dce:	80 3f 00             	cmpb   $0x0,(%edi)
80101dd1:	0f 84 d9 00 00 00    	je     80101eb0 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dd7:	83 ec 04             	sub    $0x4,%esp
80101dda:	6a 00                	push   $0x0
80101ddc:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ddf:	56                   	push   %esi
80101de0:	e8 5b fe ff ff       	call   80101c40 <dirlookup>
80101de5:	83 c4 10             	add    $0x10,%esp
80101de8:	89 c3                	mov    %eax,%ebx
80101dea:	85 c0                	test   %eax,%eax
80101dec:	74 7a                	je     80101e68 <namex+0x178>
  iunlock(ip);
80101dee:	83 ec 0c             	sub    $0xc,%esp
80101df1:	56                   	push   %esi
80101df2:	e8 f9 f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101df7:	89 34 24             	mov    %esi,(%esp)
80101dfa:	89 de                	mov    %ebx,%esi
80101dfc:	e8 3f fa ff ff       	call   80101840 <iput>
  while(*path == '/')
80101e01:	83 c4 10             	add    $0x10,%esp
80101e04:	e9 3a ff ff ff       	jmp    80101d43 <namex+0x53>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e13:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e16:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e19:	83 ec 04             	sub    $0x4,%esp
80101e1c:	50                   	push   %eax
80101e1d:	57                   	push   %edi
    name[len] = 0;
80101e1e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101e20:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e23:	e8 28 28 00 00       	call   80104650 <memmove>
    name[len] = 0;
80101e28:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101e2b:	83 c4 10             	add    $0x10,%esp
80101e2e:	c6 00 00             	movb   $0x0,(%eax)
80101e31:	e9 68 ff ff ff       	jmp    80101d9e <namex+0xae>
80101e36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e43:	85 c0                	test   %eax,%eax
80101e45:	0f 85 85 00 00 00    	jne    80101ed0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e4e:	89 f0                	mov    %esi,%eax
80101e50:	5b                   	pop    %ebx
80101e51:	5e                   	pop    %esi
80101e52:	5f                   	pop    %edi
80101e53:	5d                   	pop    %ebp
80101e54:	c3                   	ret    
80101e55:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101e58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e5b:	89 fb                	mov    %edi,%ebx
80101e5d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101e60:	31 c0                	xor    %eax,%eax
80101e62:	eb b5                	jmp    80101e19 <namex+0x129>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e68:	83 ec 0c             	sub    $0xc,%esp
80101e6b:	56                   	push   %esi
80101e6c:	e8 7f f9 ff ff       	call   801017f0 <iunlock>
  iput(ip);
80101e71:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e74:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e76:	e8 c5 f9 ff ff       	call   80101840 <iput>
      return 0;
80101e7b:	83 c4 10             	add    $0x10,%esp
}
80101e7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e81:	89 f0                	mov    %esi,%eax
80101e83:	5b                   	pop    %ebx
80101e84:	5e                   	pop    %esi
80101e85:	5f                   	pop    %edi
80101e86:	5d                   	pop    %ebp
80101e87:	c3                   	ret    
80101e88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e8f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101e90:	ba 01 00 00 00       	mov    $0x1,%edx
80101e95:	b8 01 00 00 00       	mov    $0x1,%eax
80101e9a:	89 df                	mov    %ebx,%edi
80101e9c:	e8 6f f4 ff ff       	call   80101310 <iget>
80101ea1:	89 c6                	mov    %eax,%esi
80101ea3:	e9 9b fe ff ff       	jmp    80101d43 <namex+0x53>
80101ea8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eaf:	90                   	nop
      iunlock(ip);
80101eb0:	83 ec 0c             	sub    $0xc,%esp
80101eb3:	56                   	push   %esi
80101eb4:	e8 37 f9 ff ff       	call   801017f0 <iunlock>
      return ip;
80101eb9:	83 c4 10             	add    $0x10,%esp
}
80101ebc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ebf:	89 f0                	mov    %esi,%eax
80101ec1:	5b                   	pop    %ebx
80101ec2:	5e                   	pop    %esi
80101ec3:	5f                   	pop    %edi
80101ec4:	5d                   	pop    %ebp
80101ec5:	c3                   	ret    
80101ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ecd:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
80101ed3:	56                   	push   %esi
    return 0;
80101ed4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ed6:	e8 65 f9 ff ff       	call   80101840 <iput>
    return 0;
80101edb:	83 c4 10             	add    $0x10,%esp
80101ede:	e9 68 ff ff ff       	jmp    80101e4b <namex+0x15b>
80101ee3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ef0 <dirlink>:
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	57                   	push   %edi
80101ef4:	56                   	push   %esi
80101ef5:	53                   	push   %ebx
80101ef6:	83 ec 20             	sub    $0x20,%esp
80101ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101efc:	6a 00                	push   $0x0
80101efe:	ff 75 0c             	pushl  0xc(%ebp)
80101f01:	53                   	push   %ebx
80101f02:	e8 39 fd ff ff       	call   80101c40 <dirlookup>
80101f07:	83 c4 10             	add    $0x10,%esp
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 67                	jne    80101f75 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f0e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f11:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f14:	85 ff                	test   %edi,%edi
80101f16:	74 29                	je     80101f41 <dirlink+0x51>
80101f18:	31 ff                	xor    %edi,%edi
80101f1a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f1d:	eb 09                	jmp    80101f28 <dirlink+0x38>
80101f1f:	90                   	nop
80101f20:	83 c7 10             	add    $0x10,%edi
80101f23:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f26:	73 19                	jae    80101f41 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f28:	6a 10                	push   $0x10
80101f2a:	57                   	push   %edi
80101f2b:	56                   	push   %esi
80101f2c:	53                   	push   %ebx
80101f2d:	e8 be fa ff ff       	call   801019f0 <readi>
80101f32:	83 c4 10             	add    $0x10,%esp
80101f35:	83 f8 10             	cmp    $0x10,%eax
80101f38:	75 4e                	jne    80101f88 <dirlink+0x98>
    if(de.inum == 0)
80101f3a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f3f:	75 df                	jne    80101f20 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f41:	83 ec 04             	sub    $0x4,%esp
80101f44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f47:	6a 0e                	push   $0xe
80101f49:	ff 75 0c             	pushl  0xc(%ebp)
80101f4c:	50                   	push   %eax
80101f4d:	e8 ce 27 00 00       	call   80104720 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f52:	6a 10                	push   $0x10
  de.inum = inum;
80101f54:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f57:	57                   	push   %edi
80101f58:	56                   	push   %esi
80101f59:	53                   	push   %ebx
  de.inum = inum;
80101f5a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f5e:	e8 8d fb ff ff       	call   80101af0 <writei>
80101f63:	83 c4 20             	add    $0x20,%esp
80101f66:	83 f8 10             	cmp    $0x10,%eax
80101f69:	75 2a                	jne    80101f95 <dirlink+0xa5>
  return 0;
80101f6b:	31 c0                	xor    %eax,%eax
}
80101f6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f70:	5b                   	pop    %ebx
80101f71:	5e                   	pop    %esi
80101f72:	5f                   	pop    %edi
80101f73:	5d                   	pop    %ebp
80101f74:	c3                   	ret    
    iput(ip);
80101f75:	83 ec 0c             	sub    $0xc,%esp
80101f78:	50                   	push   %eax
80101f79:	e8 c2 f8 ff ff       	call   80101840 <iput>
    return -1;
80101f7e:	83 c4 10             	add    $0x10,%esp
80101f81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f86:	eb e5                	jmp    80101f6d <dirlink+0x7d>
      panic("dirlink read");
80101f88:	83 ec 0c             	sub    $0xc,%esp
80101f8b:	68 48 71 10 80       	push   $0x80107148
80101f90:	e8 fb e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	68 46 77 10 80       	push   $0x80107746
80101f9d:	e8 ee e3 ff ff       	call   80100390 <panic>
80101fa2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101fb0 <namei>:

struct inode*
namei(char *path)
{
80101fb0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fb1:	31 d2                	xor    %edx,%edx
{
80101fb3:	89 e5                	mov    %esp,%ebp
80101fb5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fbb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fbe:	e8 2d fd ff ff       	call   80101cf0 <namex>
}
80101fc3:	c9                   	leave  
80101fc4:	c3                   	ret    
80101fc5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fd0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fd1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fd6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fdb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fde:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fdf:	e9 0c fd ff ff       	jmp    80101cf0 <namex>
80101fe4:	66 90                	xchg   %ax,%ax
80101fe6:	66 90                	xchg   %ax,%ax
80101fe8:	66 90                	xchg   %ax,%ax
80101fea:	66 90                	xchg   %ax,%ax
80101fec:	66 90                	xchg   %ax,%ax
80101fee:	66 90                	xchg   %ax,%ax

80101ff0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101ff0:	55                   	push   %ebp
80101ff1:	89 e5                	mov    %esp,%ebp
80101ff3:	57                   	push   %edi
80101ff4:	56                   	push   %esi
80101ff5:	53                   	push   %ebx
80101ff6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80101ff9:	85 c0                	test   %eax,%eax
80101ffb:	0f 84 b4 00 00 00    	je     801020b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102001:	8b 70 08             	mov    0x8(%eax),%esi
80102004:	89 c3                	mov    %eax,%ebx
80102006:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010200c:	0f 87 96 00 00 00    	ja     801020a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102012:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102017:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010201e:	66 90                	xchg   %ax,%ax
80102020:	89 ca                	mov    %ecx,%edx
80102022:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102023:	83 e0 c0             	and    $0xffffffc0,%eax
80102026:	3c 40                	cmp    $0x40,%al
80102028:	75 f6                	jne    80102020 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010202a:	31 ff                	xor    %edi,%edi
8010202c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102031:	89 f8                	mov    %edi,%eax
80102033:	ee                   	out    %al,(%dx)
80102034:	b8 01 00 00 00       	mov    $0x1,%eax
80102039:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010203e:	ee                   	out    %al,(%dx)
8010203f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102044:	89 f0                	mov    %esi,%eax
80102046:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102047:	89 f0                	mov    %esi,%eax
80102049:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010204e:	c1 f8 08             	sar    $0x8,%eax
80102051:	ee                   	out    %al,(%dx)
80102052:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102057:	89 f8                	mov    %edi,%eax
80102059:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010205a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010205e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102063:	c1 e0 04             	shl    $0x4,%eax
80102066:	83 e0 10             	and    $0x10,%eax
80102069:	83 c8 e0             	or     $0xffffffe0,%eax
8010206c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010206d:	f6 03 04             	testb  $0x4,(%ebx)
80102070:	75 16                	jne    80102088 <idestart+0x98>
80102072:	b8 20 00 00 00       	mov    $0x20,%eax
80102077:	89 ca                	mov    %ecx,%edx
80102079:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010207a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010207d:	5b                   	pop    %ebx
8010207e:	5e                   	pop    %esi
8010207f:	5f                   	pop    %edi
80102080:	5d                   	pop    %ebp
80102081:	c3                   	ret    
80102082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102088:	b8 30 00 00 00       	mov    $0x30,%eax
8010208d:	89 ca                	mov    %ecx,%edx
8010208f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102090:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102095:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102098:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010209d:	fc                   	cld    
8010209e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801020a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020a3:	5b                   	pop    %ebx
801020a4:	5e                   	pop    %esi
801020a5:	5f                   	pop    %edi
801020a6:	5d                   	pop    %ebp
801020a7:	c3                   	ret    
    panic("incorrect blockno");
801020a8:	83 ec 0c             	sub    $0xc,%esp
801020ab:	68 b4 71 10 80       	push   $0x801071b4
801020b0:	e8 db e2 ff ff       	call   80100390 <panic>
    panic("idestart");
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	68 ab 71 10 80       	push   $0x801071ab
801020bd:	e8 ce e2 ff ff       	call   80100390 <panic>
801020c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020d0 <ideinit>:
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801020d6:	68 c6 71 10 80       	push   $0x801071c6
801020db:	68 80 a5 10 80       	push   $0x8010a580
801020e0:	e8 5b 22 00 00       	call   80104340 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801020e5:	58                   	pop    %eax
801020e6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801020eb:	5a                   	pop    %edx
801020ec:	83 e8 01             	sub    $0x1,%eax
801020ef:	50                   	push   %eax
801020f0:	6a 0e                	push   $0xe
801020f2:	e8 a9 02 00 00       	call   801023a0 <ioapicenable>
801020f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020ff:	90                   	nop
80102100:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	83 e0 c0             	and    $0xffffffc0,%eax
80102104:	3c 40                	cmp    $0x40,%al
80102106:	75 f8                	jne    80102100 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102108:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010210d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102112:	ee                   	out    %al,(%dx)
80102113:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	eb 06                	jmp    80102125 <ideinit+0x55>
8010211f:	90                   	nop
  for(i=0; i<1000; i++){
80102120:	83 e9 01             	sub    $0x1,%ecx
80102123:	74 0f                	je     80102134 <ideinit+0x64>
80102125:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102126:	84 c0                	test   %al,%al
80102128:	74 f6                	je     80102120 <ideinit+0x50>
      havedisk1 = 1;
8010212a:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102131:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102134:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102139:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010213e:	ee                   	out    %al,(%dx)
}
8010213f:	c9                   	leave  
80102140:	c3                   	ret    
80102141:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102148:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010214f:	90                   	nop

80102150 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	57                   	push   %edi
80102154:	56                   	push   %esi
80102155:	53                   	push   %ebx
80102156:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102159:	68 80 a5 10 80       	push   $0x8010a580
8010215e:	e8 3d 23 00 00       	call   801044a0 <acquire>

  if((b = idequeue) == 0){
80102163:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102169:	83 c4 10             	add    $0x10,%esp
8010216c:	85 db                	test   %ebx,%ebx
8010216e:	74 63                	je     801021d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102170:	8b 43 58             	mov    0x58(%ebx),%eax
80102173:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102178:	8b 33                	mov    (%ebx),%esi
8010217a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102180:	75 2f                	jne    801021b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102182:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010218e:	66 90                	xchg   %ax,%ax
80102190:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102191:	89 c1                	mov    %eax,%ecx
80102193:	83 e1 c0             	and    $0xffffffc0,%ecx
80102196:	80 f9 40             	cmp    $0x40,%cl
80102199:	75 f5                	jne    80102190 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010219b:	a8 21                	test   $0x21,%al
8010219d:	75 12                	jne    801021b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010219f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801021a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801021a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ac:	fc                   	cld    
801021ad:	f3 6d                	rep insl (%dx),%es:(%edi)
801021af:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801021b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801021b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801021b7:	83 ce 02             	or     $0x2,%esi
801021ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801021bc:	53                   	push   %ebx
801021bd:	e8 5e 1e 00 00       	call   80104020 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801021c2:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801021c7:	83 c4 10             	add    $0x10,%esp
801021ca:	85 c0                	test   %eax,%eax
801021cc:	74 05                	je     801021d3 <ideintr+0x83>
    idestart(idequeue);
801021ce:	e8 1d fe ff ff       	call   80101ff0 <idestart>
    release(&idelock);
801021d3:	83 ec 0c             	sub    $0xc,%esp
801021d6:	68 80 a5 10 80       	push   $0x8010a580
801021db:	e8 80 23 00 00       	call   80104560 <release>

  release(&idelock);
}
801021e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e3:	5b                   	pop    %ebx
801021e4:	5e                   	pop    %esi
801021e5:	5f                   	pop    %edi
801021e6:	5d                   	pop    %ebp
801021e7:	c3                   	ret    
801021e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021ef:	90                   	nop

801021f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	53                   	push   %ebx
801021f4:	83 ec 10             	sub    $0x10,%esp
801021f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801021fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801021fd:	50                   	push   %eax
801021fe:	e8 ed 20 00 00       	call   801042f0 <holdingsleep>
80102203:	83 c4 10             	add    $0x10,%esp
80102206:	85 c0                	test   %eax,%eax
80102208:	0f 84 d3 00 00 00    	je     801022e1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010220e:	8b 03                	mov    (%ebx),%eax
80102210:	83 e0 06             	and    $0x6,%eax
80102213:	83 f8 02             	cmp    $0x2,%eax
80102216:	0f 84 b8 00 00 00    	je     801022d4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010221c:	8b 53 04             	mov    0x4(%ebx),%edx
8010221f:	85 d2                	test   %edx,%edx
80102221:	74 0d                	je     80102230 <iderw+0x40>
80102223:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102228:	85 c0                	test   %eax,%eax
8010222a:	0f 84 97 00 00 00    	je     801022c7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102230:	83 ec 0c             	sub    $0xc,%esp
80102233:	68 80 a5 10 80       	push   $0x8010a580
80102238:	e8 63 22 00 00       	call   801044a0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010223d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
  b->qnext = 0;
80102243:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	85 d2                	test   %edx,%edx
8010224f:	75 09                	jne    8010225a <iderw+0x6a>
80102251:	eb 6d                	jmp    801022c0 <iderw+0xd0>
80102253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102257:	90                   	nop
80102258:	89 c2                	mov    %eax,%edx
8010225a:	8b 42 58             	mov    0x58(%edx),%eax
8010225d:	85 c0                	test   %eax,%eax
8010225f:	75 f7                	jne    80102258 <iderw+0x68>
80102261:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102264:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102266:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010226c:	74 42                	je     801022b0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010226e:	8b 03                	mov    (%ebx),%eax
80102270:	83 e0 06             	and    $0x6,%eax
80102273:	83 f8 02             	cmp    $0x2,%eax
80102276:	74 23                	je     8010229b <iderw+0xab>
80102278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop
    sleep(b, &idelock);
80102280:	83 ec 08             	sub    $0x8,%esp
80102283:	68 80 a5 10 80       	push   $0x8010a580
80102288:	53                   	push   %ebx
80102289:	e8 e2 1b 00 00       	call   80103e70 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010228e:	8b 03                	mov    (%ebx),%eax
80102290:	83 c4 10             	add    $0x10,%esp
80102293:	83 e0 06             	and    $0x6,%eax
80102296:	83 f8 02             	cmp    $0x2,%eax
80102299:	75 e5                	jne    80102280 <iderw+0x90>
  }


  release(&idelock);
8010229b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801022a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801022a5:	c9                   	leave  
  release(&idelock);
801022a6:	e9 b5 22 00 00       	jmp    80104560 <release>
801022ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801022af:	90                   	nop
    idestart(b);
801022b0:	89 d8                	mov    %ebx,%eax
801022b2:	e8 39 fd ff ff       	call   80101ff0 <idestart>
801022b7:	eb b5                	jmp    8010226e <iderw+0x7e>
801022b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801022c0:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
801022c5:	eb 9d                	jmp    80102264 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801022c7:	83 ec 0c             	sub    $0xc,%esp
801022ca:	68 f5 71 10 80       	push   $0x801071f5
801022cf:	e8 bc e0 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801022d4:	83 ec 0c             	sub    $0xc,%esp
801022d7:	68 e0 71 10 80       	push   $0x801071e0
801022dc:	e8 af e0 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801022e1:	83 ec 0c             	sub    $0xc,%esp
801022e4:	68 ca 71 10 80       	push   $0x801071ca
801022e9:	e8 a2 e0 ff ff       	call   80100390 <panic>
801022ee:	66 90                	xchg   %ax,%ax

801022f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801022f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801022f1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801022f8:	00 c0 fe 
{
801022fb:	89 e5                	mov    %esp,%ebp
801022fd:	56                   	push   %esi
801022fe:	53                   	push   %ebx
  ioapic->reg = reg;
801022ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102306:	00 00 00 
  return ioapic->data;
80102309:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010230f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102312:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102318:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010231e:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102325:	c1 ee 10             	shr    $0x10,%esi
80102328:	89 f0                	mov    %esi,%eax
8010232a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010232d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102330:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102333:	39 c2                	cmp    %eax,%edx
80102335:	74 16                	je     8010234d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102337:	83 ec 0c             	sub    $0xc,%esp
8010233a:	68 14 72 10 80       	push   $0x80107214
8010233f:	e8 6c e3 ff ff       	call   801006b0 <cprintf>
80102344:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010234a:	83 c4 10             	add    $0x10,%esp
8010234d:	83 c6 21             	add    $0x21,%esi
{
80102350:	ba 10 00 00 00       	mov    $0x10,%edx
80102355:	b8 20 00 00 00       	mov    $0x20,%eax
8010235a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102360:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102362:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102364:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010236a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010236d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102373:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102376:	8d 5a 01             	lea    0x1(%edx),%ebx
80102379:	83 c2 02             	add    $0x2,%edx
8010237c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010237e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102384:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010238b:	39 f0                	cmp    %esi,%eax
8010238d:	75 d1                	jne    80102360 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010238f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102392:	5b                   	pop    %ebx
80102393:	5e                   	pop    %esi
80102394:	5d                   	pop    %ebp
80102395:	c3                   	ret    
80102396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010239d:	8d 76 00             	lea    0x0(%esi),%esi

801023a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801023a0:	55                   	push   %ebp
  ioapic->reg = reg;
801023a1:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
801023a7:	89 e5                	mov    %esp,%ebp
801023a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801023ac:	8d 50 20             	lea    0x20(%eax),%edx
801023af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801023b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023b5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801023be:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023c1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801023c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801023c6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801023cb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801023ce:	89 50 10             	mov    %edx,0x10(%eax)
}
801023d1:	5d                   	pop    %ebp
801023d2:	c3                   	ret    
801023d3:	66 90                	xchg   %ax,%ax
801023d5:	66 90                	xchg   %ax,%ax
801023d7:	66 90                	xchg   %ax,%ax
801023d9:	66 90                	xchg   %ax,%ax
801023db:	66 90                	xchg   %ax,%ax
801023dd:	66 90                	xchg   %ax,%ax
801023df:	90                   	nop

801023e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801023e0:	55                   	push   %ebp
801023e1:	89 e5                	mov    %esp,%ebp
801023e3:	53                   	push   %ebx
801023e4:	83 ec 04             	sub    $0x4,%esp
801023e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801023ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801023f0:	75 76                	jne    80102468 <kfree+0x88>
801023f2:	81 fb a8 54 11 80    	cmp    $0x801154a8,%ebx
801023f8:	72 6e                	jb     80102468 <kfree+0x88>
801023fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102400:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102405:	77 61                	ja     80102468 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102407:	83 ec 04             	sub    $0x4,%esp
8010240a:	68 00 10 00 00       	push   $0x1000
8010240f:	6a 01                	push   $0x1
80102411:	53                   	push   %ebx
80102412:	e8 99 21 00 00       	call   801045b0 <memset>

  if(kmem.use_lock)
80102417:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010241d:	83 c4 10             	add    $0x10,%esp
80102420:	85 d2                	test   %edx,%edx
80102422:	75 1c                	jne    80102440 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102424:	a1 78 26 11 80       	mov    0x80112678,%eax
80102429:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010242b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102430:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102436:	85 c0                	test   %eax,%eax
80102438:	75 1e                	jne    80102458 <kfree+0x78>
    release(&kmem.lock);
}
8010243a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010243d:	c9                   	leave  
8010243e:	c3                   	ret    
8010243f:	90                   	nop
    acquire(&kmem.lock);
80102440:	83 ec 0c             	sub    $0xc,%esp
80102443:	68 40 26 11 80       	push   $0x80112640
80102448:	e8 53 20 00 00       	call   801044a0 <acquire>
8010244d:	83 c4 10             	add    $0x10,%esp
80102450:	eb d2                	jmp    80102424 <kfree+0x44>
80102452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102458:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010245f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102462:	c9                   	leave  
    release(&kmem.lock);
80102463:	e9 f8 20 00 00       	jmp    80104560 <release>
    panic("kfree");
80102468:	83 ec 0c             	sub    $0xc,%esp
8010246b:	68 46 72 10 80       	push   $0x80107246
80102470:	e8 1b df ff ff       	call   80100390 <panic>
80102475:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102480 <freerange>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102484:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102487:	8b 75 0c             	mov    0xc(%ebp),%esi
8010248a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010248b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102491:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102497:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010249d:	39 de                	cmp    %ebx,%esi
8010249f:	72 23                	jb     801024c4 <freerange+0x44>
801024a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801024a8:	83 ec 0c             	sub    $0xc,%esp
801024ab:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801024b7:	50                   	push   %eax
801024b8:	e8 23 ff ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024bd:	83 c4 10             	add    $0x10,%esp
801024c0:	39 f3                	cmp    %esi,%ebx
801024c2:	76 e4                	jbe    801024a8 <freerange+0x28>
}
801024c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024c7:	5b                   	pop    %ebx
801024c8:	5e                   	pop    %esi
801024c9:	5d                   	pop    %ebp
801024ca:	c3                   	ret    
801024cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801024cf:	90                   	nop

801024d0 <kinit1>:
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	56                   	push   %esi
801024d4:	53                   	push   %ebx
801024d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801024d8:	83 ec 08             	sub    $0x8,%esp
801024db:	68 4c 72 10 80       	push   $0x8010724c
801024e0:	68 40 26 11 80       	push   $0x80112640
801024e5:	e8 56 1e 00 00       	call   80104340 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801024ea:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024ed:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801024f0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801024f7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801024fa:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102500:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102506:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010250c:	39 de                	cmp    %ebx,%esi
8010250e:	72 1c                	jb     8010252c <kinit1+0x5c>
    kfree(p);
80102510:	83 ec 0c             	sub    $0xc,%esp
80102513:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102519:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010251f:	50                   	push   %eax
80102520:	e8 bb fe ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102525:	83 c4 10             	add    $0x10,%esp
80102528:	39 de                	cmp    %ebx,%esi
8010252a:	73 e4                	jae    80102510 <kinit1+0x40>
}
8010252c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010252f:	5b                   	pop    %ebx
80102530:	5e                   	pop    %esi
80102531:	5d                   	pop    %ebp
80102532:	c3                   	ret    
80102533:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102540 <kinit2>:
{
80102540:	55                   	push   %ebp
80102541:	89 e5                	mov    %esp,%ebp
80102543:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102544:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102547:	8b 75 0c             	mov    0xc(%ebp),%esi
8010254a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010254b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102551:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102557:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010255d:	39 de                	cmp    %ebx,%esi
8010255f:	72 23                	jb     80102584 <kinit2+0x44>
80102561:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102568:	83 ec 0c             	sub    $0xc,%esp
8010256b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102571:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102577:	50                   	push   %eax
80102578:	e8 63 fe ff ff       	call   801023e0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	39 de                	cmp    %ebx,%esi
80102582:	73 e4                	jae    80102568 <kinit2+0x28>
  kmem.use_lock = 1;
80102584:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010258b:	00 00 00 
}
8010258e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102591:	5b                   	pop    %ebx
80102592:	5e                   	pop    %esi
80102593:	5d                   	pop    %ebp
80102594:	c3                   	ret    
80102595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025a0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	53                   	push   %ebx
801025a4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801025a7:	a1 74 26 11 80       	mov    0x80112674,%eax
801025ac:	85 c0                	test   %eax,%eax
801025ae:	75 20                	jne    801025d0 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801025b0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025b6:	85 db                	test   %ebx,%ebx
801025b8:	74 07                	je     801025c1 <kalloc+0x21>
    kmem.freelist = r->next;
801025ba:	8b 03                	mov    (%ebx),%eax
801025bc:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801025c1:	89 d8                	mov    %ebx,%eax
801025c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025c6:	c9                   	leave  
801025c7:	c3                   	ret    
801025c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801025cf:	90                   	nop
    acquire(&kmem.lock);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	68 40 26 11 80       	push   $0x80112640
801025d8:	e8 c3 1e 00 00       	call   801044a0 <acquire>
  r = kmem.freelist;
801025dd:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801025e3:	83 c4 10             	add    $0x10,%esp
801025e6:	a1 74 26 11 80       	mov    0x80112674,%eax
801025eb:	85 db                	test   %ebx,%ebx
801025ed:	74 08                	je     801025f7 <kalloc+0x57>
    kmem.freelist = r->next;
801025ef:	8b 13                	mov    (%ebx),%edx
801025f1:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801025f7:	85 c0                	test   %eax,%eax
801025f9:	74 c6                	je     801025c1 <kalloc+0x21>
    release(&kmem.lock);
801025fb:	83 ec 0c             	sub    $0xc,%esp
801025fe:	68 40 26 11 80       	push   $0x80112640
80102603:	e8 58 1f 00 00       	call   80104560 <release>
}
80102608:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010260a:	83 c4 10             	add    $0x10,%esp
}
8010260d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102610:	c9                   	leave  
80102611:	c3                   	ret    
80102612:	66 90                	xchg   %ax,%ax
80102614:	66 90                	xchg   %ax,%ax
80102616:	66 90                	xchg   %ax,%ax
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102620:	ba 64 00 00 00       	mov    $0x64,%edx
80102625:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102626:	a8 01                	test   $0x1,%al
80102628:	0f 84 c2 00 00 00    	je     801026f0 <kbdgetc+0xd0>
{
8010262e:	55                   	push   %ebp
8010262f:	ba 60 00 00 00       	mov    $0x60,%edx
80102634:	89 e5                	mov    %esp,%ebp
80102636:	53                   	push   %ebx
80102637:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102638:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010263b:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
80102641:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102647:	74 57                	je     801026a0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102649:	89 d9                	mov    %ebx,%ecx
8010264b:	83 e1 40             	and    $0x40,%ecx
8010264e:	84 c0                	test   %al,%al
80102650:	78 5e                	js     801026b0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102652:	85 c9                	test   %ecx,%ecx
80102654:	74 09                	je     8010265f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102656:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102659:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010265c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010265f:	0f b6 8a 80 73 10 80 	movzbl -0x7fef8c80(%edx),%ecx
  shift ^= togglecode[data];
80102666:	0f b6 82 80 72 10 80 	movzbl -0x7fef8d80(%edx),%eax
  shift |= shiftcode[data];
8010266d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010266f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102671:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102673:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102679:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010267c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010267f:	8b 04 85 60 72 10 80 	mov    -0x7fef8da0(,%eax,4),%eax
80102686:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010268a:	74 0b                	je     80102697 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010268c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010268f:	83 fa 19             	cmp    $0x19,%edx
80102692:	77 44                	ja     801026d8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102694:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102697:	5b                   	pop    %ebx
80102698:	5d                   	pop    %ebp
80102699:	c3                   	ret    
8010269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801026a0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801026a3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801026a5:	89 1d b4 a5 10 80    	mov    %ebx,0x8010a5b4
}
801026ab:	5b                   	pop    %ebx
801026ac:	5d                   	pop    %ebp
801026ad:	c3                   	ret    
801026ae:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801026b0:	83 e0 7f             	and    $0x7f,%eax
801026b3:	85 c9                	test   %ecx,%ecx
801026b5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801026b8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801026ba:	0f b6 8a 80 73 10 80 	movzbl -0x7fef8c80(%edx),%ecx
801026c1:	83 c9 40             	or     $0x40,%ecx
801026c4:	0f b6 c9             	movzbl %cl,%ecx
801026c7:	f7 d1                	not    %ecx
801026c9:	21 d9                	and    %ebx,%ecx
}
801026cb:	5b                   	pop    %ebx
801026cc:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801026cd:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
801026d3:	c3                   	ret    
801026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801026d8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801026db:	8d 50 20             	lea    0x20(%eax),%edx
}
801026de:	5b                   	pop    %ebx
801026df:	5d                   	pop    %ebp
      c += 'a' - 'A';
801026e0:	83 f9 1a             	cmp    $0x1a,%ecx
801026e3:	0f 42 c2             	cmovb  %edx,%eax
}
801026e6:	c3                   	ret    
801026e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026ee:	66 90                	xchg   %ax,%ax
    return -1;
801026f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801026f5:	c3                   	ret    
801026f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026fd:	8d 76 00             	lea    0x0(%esi),%esi

80102700 <kbdintr>:

void
kbdintr(void)
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102706:	68 20 26 10 80       	push   $0x80102620
8010270b:	e8 50 e1 ff ff       	call   80100860 <consoleintr>
}
80102710:	83 c4 10             	add    $0x10,%esp
80102713:	c9                   	leave  
80102714:	c3                   	ret    
80102715:	66 90                	xchg   %ax,%ax
80102717:	66 90                	xchg   %ax,%ax
80102719:	66 90                	xchg   %ax,%ax
8010271b:	66 90                	xchg   %ax,%ax
8010271d:	66 90                	xchg   %ax,%ax
8010271f:	90                   	nop

80102720 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102720:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102725:	85 c0                	test   %eax,%eax
80102727:	0f 84 cb 00 00 00    	je     801027f8 <lapicinit+0xd8>
  lapic[index] = value;
8010272d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102734:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102737:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102741:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102744:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102747:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010274e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102751:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102754:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010275b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010275e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102761:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102768:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010276b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010276e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102775:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102778:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010277b:	8b 50 30             	mov    0x30(%eax),%edx
8010277e:	c1 ea 10             	shr    $0x10,%edx
80102781:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102787:	75 77                	jne    80102800 <lapicinit+0xe0>
  lapic[index] = value;
80102789:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102790:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102793:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102796:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010279d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027a3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801027aa:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ad:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027b0:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027b7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027bd:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801027c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027ca:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801027d1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801027d4:	8b 50 20             	mov    0x20(%eax),%edx
801027d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027de:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801027e0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801027e6:	80 e6 10             	and    $0x10,%dh
801027e9:	75 f5                	jne    801027e0 <lapicinit+0xc0>
  lapic[index] = value;
801027eb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801027f2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027f5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801027f8:	c3                   	ret    
801027f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102800:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102807:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010280a:	8b 50 20             	mov    0x20(%eax),%edx
8010280d:	e9 77 ff ff ff       	jmp    80102789 <lapicinit+0x69>
80102812:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102820 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102820:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102825:	85 c0                	test   %eax,%eax
80102827:	74 07                	je     80102830 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102829:	8b 40 20             	mov    0x20(%eax),%eax
8010282c:	c1 e8 18             	shr    $0x18,%eax
8010282f:	c3                   	ret    
    return 0;
80102830:	31 c0                	xor    %eax,%eax
}
80102832:	c3                   	ret    
80102833:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102840 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102840:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102845:	85 c0                	test   %eax,%eax
80102847:	74 0d                	je     80102856 <lapiceoi+0x16>
  lapic[index] = value;
80102849:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102850:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102853:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102856:	c3                   	ret    
80102857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010285e:	66 90                	xchg   %ax,%ax

80102860 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102860:	c3                   	ret    
80102861:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010286f:	90                   	nop

80102870 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102870:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102871:	b8 0f 00 00 00       	mov    $0xf,%eax
80102876:	ba 70 00 00 00       	mov    $0x70,%edx
8010287b:	89 e5                	mov    %esp,%ebp
8010287d:	53                   	push   %ebx
8010287e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102881:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102884:	ee                   	out    %al,(%dx)
80102885:	b8 0a 00 00 00       	mov    $0xa,%eax
8010288a:	ba 71 00 00 00       	mov    $0x71,%edx
8010288f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102890:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102892:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102895:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010289b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010289d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801028a0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801028a2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801028a5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801028a8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801028ae:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801028b3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028bc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801028c3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028c9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801028d0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028d6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028dc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028df:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028e5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801028e8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801028ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801028f7:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801028f8:	8b 40 20             	mov    0x20(%eax),%eax
}
801028fb:	5d                   	pop    %ebp
801028fc:	c3                   	ret    
801028fd:	8d 76 00             	lea    0x0(%esi),%esi

80102900 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102900:	55                   	push   %ebp
80102901:	b8 0b 00 00 00       	mov    $0xb,%eax
80102906:	ba 70 00 00 00       	mov    $0x70,%edx
8010290b:	89 e5                	mov    %esp,%ebp
8010290d:	57                   	push   %edi
8010290e:	56                   	push   %esi
8010290f:	53                   	push   %ebx
80102910:	83 ec 4c             	sub    $0x4c,%esp
80102913:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102914:	ba 71 00 00 00       	mov    $0x71,%edx
80102919:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010291a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010291d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102922:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102925:	8d 76 00             	lea    0x0(%esi),%esi
80102928:	31 c0                	xor    %eax,%eax
8010292a:	89 da                	mov    %ebx,%edx
8010292c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010292d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102932:	89 ca                	mov    %ecx,%edx
80102934:	ec                   	in     (%dx),%al
80102935:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102938:	89 da                	mov    %ebx,%edx
8010293a:	b8 02 00 00 00       	mov    $0x2,%eax
8010293f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102940:	89 ca                	mov    %ecx,%edx
80102942:	ec                   	in     (%dx),%al
80102943:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102946:	89 da                	mov    %ebx,%edx
80102948:	b8 04 00 00 00       	mov    $0x4,%eax
8010294d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010294e:	89 ca                	mov    %ecx,%edx
80102950:	ec                   	in     (%dx),%al
80102951:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102954:	89 da                	mov    %ebx,%edx
80102956:	b8 07 00 00 00       	mov    $0x7,%eax
8010295b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010295c:	89 ca                	mov    %ecx,%edx
8010295e:	ec                   	in     (%dx),%al
8010295f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102962:	89 da                	mov    %ebx,%edx
80102964:	b8 08 00 00 00       	mov    $0x8,%eax
80102969:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010296a:	89 ca                	mov    %ecx,%edx
8010296c:	ec                   	in     (%dx),%al
8010296d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010296f:	89 da                	mov    %ebx,%edx
80102971:	b8 09 00 00 00       	mov    $0x9,%eax
80102976:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102977:	89 ca                	mov    %ecx,%edx
80102979:	ec                   	in     (%dx),%al
8010297a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010297c:	89 da                	mov    %ebx,%edx
8010297e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102983:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102984:	89 ca                	mov    %ecx,%edx
80102986:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102987:	84 c0                	test   %al,%al
80102989:	78 9d                	js     80102928 <cmostime+0x28>
  return inb(CMOS_RETURN);
8010298b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
8010298f:	89 fa                	mov    %edi,%edx
80102991:	0f b6 fa             	movzbl %dl,%edi
80102994:	89 f2                	mov    %esi,%edx
80102996:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102999:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
8010299d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029a0:	89 da                	mov    %ebx,%edx
801029a2:	89 7d c8             	mov    %edi,-0x38(%ebp)
801029a5:	89 45 bc             	mov    %eax,-0x44(%ebp)
801029a8:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801029ac:	89 75 cc             	mov    %esi,-0x34(%ebp)
801029af:	89 45 c0             	mov    %eax,-0x40(%ebp)
801029b2:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801029b6:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801029b9:	31 c0                	xor    %eax,%eax
801029bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029bc:	89 ca                	mov    %ecx,%edx
801029be:	ec                   	in     (%dx),%al
801029bf:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029c2:	89 da                	mov    %ebx,%edx
801029c4:	89 45 d0             	mov    %eax,-0x30(%ebp)
801029c7:	b8 02 00 00 00       	mov    $0x2,%eax
801029cc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029cd:	89 ca                	mov    %ecx,%edx
801029cf:	ec                   	in     (%dx),%al
801029d0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029d3:	89 da                	mov    %ebx,%edx
801029d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801029d8:	b8 04 00 00 00       	mov    $0x4,%eax
801029dd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029de:	89 ca                	mov    %ecx,%edx
801029e0:	ec                   	in     (%dx),%al
801029e1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e4:	89 da                	mov    %ebx,%edx
801029e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801029e9:	b8 07 00 00 00       	mov    $0x7,%eax
801029ee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ef:	89 ca                	mov    %ecx,%edx
801029f1:	ec                   	in     (%dx),%al
801029f2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f5:	89 da                	mov    %ebx,%edx
801029f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801029fa:	b8 08 00 00 00       	mov    $0x8,%eax
801029ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a00:	89 ca                	mov    %ecx,%edx
80102a02:	ec                   	in     (%dx),%al
80102a03:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a06:	89 da                	mov    %ebx,%edx
80102a08:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102a0b:	b8 09 00 00 00       	mov    $0x9,%eax
80102a10:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a11:	89 ca                	mov    %ecx,%edx
80102a13:	ec                   	in     (%dx),%al
80102a14:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a17:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102a1d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102a20:	6a 18                	push   $0x18
80102a22:	50                   	push   %eax
80102a23:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102a26:	50                   	push   %eax
80102a27:	e8 d4 1b 00 00       	call   80104600 <memcmp>
80102a2c:	83 c4 10             	add    $0x10,%esp
80102a2f:	85 c0                	test   %eax,%eax
80102a31:	0f 85 f1 fe ff ff    	jne    80102928 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102a37:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102a3b:	75 78                	jne    80102ab5 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102a3d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102a40:	89 c2                	mov    %eax,%edx
80102a42:	83 e0 0f             	and    $0xf,%eax
80102a45:	c1 ea 04             	shr    $0x4,%edx
80102a48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a4e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102a51:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102a54:	89 c2                	mov    %eax,%edx
80102a56:	83 e0 0f             	and    $0xf,%eax
80102a59:	c1 ea 04             	shr    $0x4,%edx
80102a5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a62:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102a65:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102a68:	89 c2                	mov    %eax,%edx
80102a6a:	83 e0 0f             	and    $0xf,%eax
80102a6d:	c1 ea 04             	shr    $0x4,%edx
80102a70:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a73:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a76:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102a79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102a7c:	89 c2                	mov    %eax,%edx
80102a7e:	83 e0 0f             	and    $0xf,%eax
80102a81:	c1 ea 04             	shr    $0x4,%edx
80102a84:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a87:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a8a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102a8d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102a90:	89 c2                	mov    %eax,%edx
80102a92:	83 e0 0f             	and    $0xf,%eax
80102a95:	c1 ea 04             	shr    $0x4,%edx
80102a98:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102a9b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102a9e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102aa1:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102aa4:	89 c2                	mov    %eax,%edx
80102aa6:	83 e0 0f             	and    $0xf,%eax
80102aa9:	c1 ea 04             	shr    $0x4,%edx
80102aac:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102aaf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ab2:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102ab5:	8b 75 08             	mov    0x8(%ebp),%esi
80102ab8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102abb:	89 06                	mov    %eax,(%esi)
80102abd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ac0:	89 46 04             	mov    %eax,0x4(%esi)
80102ac3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ac6:	89 46 08             	mov    %eax,0x8(%esi)
80102ac9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102acc:	89 46 0c             	mov    %eax,0xc(%esi)
80102acf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102ad2:	89 46 10             	mov    %eax,0x10(%esi)
80102ad5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102ad8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102adb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ae2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ae5:	5b                   	pop    %ebx
80102ae6:	5e                   	pop    %esi
80102ae7:	5f                   	pop    %edi
80102ae8:	5d                   	pop    %ebp
80102ae9:	c3                   	ret    
80102aea:	66 90                	xchg   %ax,%ax
80102aec:	66 90                	xchg   %ax,%ax
80102aee:	66 90                	xchg   %ax,%ax

80102af0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102af0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102af6:	85 c9                	test   %ecx,%ecx
80102af8:	0f 8e 8a 00 00 00    	jle    80102b88 <install_trans+0x98>
{
80102afe:	55                   	push   %ebp
80102aff:	89 e5                	mov    %esp,%ebp
80102b01:	57                   	push   %edi
80102b02:	56                   	push   %esi
80102b03:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102b04:	31 db                	xor    %ebx,%ebx
{
80102b06:	83 ec 0c             	sub    $0xc,%esp
80102b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102b10:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102b15:	83 ec 08             	sub    $0x8,%esp
80102b18:	01 d8                	add    %ebx,%eax
80102b1a:	83 c0 01             	add    $0x1,%eax
80102b1d:	50                   	push   %eax
80102b1e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102b24:	e8 a7 d5 ff ff       	call   801000d0 <bread>
80102b29:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b2b:	58                   	pop    %eax
80102b2c:	5a                   	pop    %edx
80102b2d:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102b34:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102b3a:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b3d:	e8 8e d5 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102b45:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102b47:	8d 47 5c             	lea    0x5c(%edi),%eax
80102b4a:	68 00 02 00 00       	push   $0x200
80102b4f:	50                   	push   %eax
80102b50:	8d 46 5c             	lea    0x5c(%esi),%eax
80102b53:	50                   	push   %eax
80102b54:	e8 f7 1a 00 00       	call   80104650 <memmove>
    bwrite(dbuf);  // write dst to disk
80102b59:	89 34 24             	mov    %esi,(%esp)
80102b5c:	e8 4f d6 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102b61:	89 3c 24             	mov    %edi,(%esp)
80102b64:	e8 87 d6 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102b69:	89 34 24             	mov    %esi,(%esp)
80102b6c:	e8 7f d6 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102b71:	83 c4 10             	add    $0x10,%esp
80102b74:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102b7a:	7f 94                	jg     80102b10 <install_trans+0x20>
  }
}
80102b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b7f:	5b                   	pop    %ebx
80102b80:	5e                   	pop    %esi
80102b81:	5f                   	pop    %edi
80102b82:	5d                   	pop    %ebp
80102b83:	c3                   	ret    
80102b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b88:	c3                   	ret    
80102b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102b90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	53                   	push   %ebx
80102b94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102b97:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102b9d:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102ba3:	e8 28 d5 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ba8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102bab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102bad:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102bb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102bb5:	85 c0                	test   %eax,%eax
80102bb7:	7e 19                	jle    80102bd2 <write_head+0x42>
80102bb9:	31 d2                	xor    %edx,%edx
80102bbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bbf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102bc0:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102bc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102bcb:	83 c2 01             	add    $0x1,%edx
80102bce:	39 d0                	cmp    %edx,%eax
80102bd0:	75 ee                	jne    80102bc0 <write_head+0x30>
  }
  bwrite(buf);
80102bd2:	83 ec 0c             	sub    $0xc,%esp
80102bd5:	53                   	push   %ebx
80102bd6:	e8 d5 d5 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102bdb:	89 1c 24             	mov    %ebx,(%esp)
80102bde:	e8 0d d6 ff ff       	call   801001f0 <brelse>
}
80102be3:	83 c4 10             	add    $0x10,%esp
80102be6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102be9:	c9                   	leave  
80102bea:	c3                   	ret    
80102beb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bef:	90                   	nop

80102bf0 <initlog>:
{
80102bf0:	55                   	push   %ebp
80102bf1:	89 e5                	mov    %esp,%ebp
80102bf3:	53                   	push   %ebx
80102bf4:	83 ec 2c             	sub    $0x2c,%esp
80102bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102bfa:	68 80 74 10 80       	push   $0x80107480
80102bff:	68 80 26 11 80       	push   $0x80112680
80102c04:	e8 37 17 00 00       	call   80104340 <initlock>
  readsb(dev, &sb);
80102c09:	58                   	pop    %eax
80102c0a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102c0d:	5a                   	pop    %edx
80102c0e:	50                   	push   %eax
80102c0f:	53                   	push   %ebx
80102c10:	e8 bb e8 ff ff       	call   801014d0 <readsb>
  log.start = sb.logstart;
80102c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102c18:	59                   	pop    %ecx
  log.dev = dev;
80102c19:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102c1f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102c22:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102c27:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  struct buf *buf = bread(log.dev, log.start);
80102c2d:	5a                   	pop    %edx
80102c2e:	50                   	push   %eax
80102c2f:	53                   	push   %ebx
80102c30:	e8 9b d4 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102c35:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102c38:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102c3b:	89 0d c8 26 11 80    	mov    %ecx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102c41:	85 c9                	test   %ecx,%ecx
80102c43:	7e 1d                	jle    80102c62 <initlog+0x72>
80102c45:	31 d2                	xor    %edx,%edx
80102c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102c50:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102c54:	89 1c 95 cc 26 11 80 	mov    %ebx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102c5b:	83 c2 01             	add    $0x1,%edx
80102c5e:	39 d1                	cmp    %edx,%ecx
80102c60:	75 ee                	jne    80102c50 <initlog+0x60>
  brelse(buf);
80102c62:	83 ec 0c             	sub    $0xc,%esp
80102c65:	50                   	push   %eax
80102c66:	e8 85 d5 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102c6b:	e8 80 fe ff ff       	call   80102af0 <install_trans>
  log.lh.n = 0;
80102c70:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c77:	00 00 00 
  write_head(); // clear the log
80102c7a:	e8 11 ff ff ff       	call   80102b90 <write_head>
}
80102c7f:	83 c4 10             	add    $0x10,%esp
80102c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102c85:	c9                   	leave  
80102c86:	c3                   	ret    
80102c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c8e:	66 90                	xchg   %ax,%ax

80102c90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102c96:	68 80 26 11 80       	push   $0x80112680
80102c9b:	e8 00 18 00 00       	call   801044a0 <acquire>
80102ca0:	83 c4 10             	add    $0x10,%esp
80102ca3:	eb 18                	jmp    80102cbd <begin_op+0x2d>
80102ca5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102ca8:	83 ec 08             	sub    $0x8,%esp
80102cab:	68 80 26 11 80       	push   $0x80112680
80102cb0:	68 80 26 11 80       	push   $0x80112680
80102cb5:	e8 b6 11 00 00       	call   80103e70 <sleep>
80102cba:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102cbd:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102cc2:	85 c0                	test   %eax,%eax
80102cc4:	75 e2                	jne    80102ca8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102cc6:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102ccb:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102cd1:	83 c0 01             	add    $0x1,%eax
80102cd4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102cd7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102cda:	83 fa 1e             	cmp    $0x1e,%edx
80102cdd:	7f c9                	jg     80102ca8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102cdf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ce2:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102ce7:	68 80 26 11 80       	push   $0x80112680
80102cec:	e8 6f 18 00 00       	call   80104560 <release>
      break;
    }
  }
}
80102cf1:	83 c4 10             	add    $0x10,%esp
80102cf4:	c9                   	leave  
80102cf5:	c3                   	ret    
80102cf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102cfd:	8d 76 00             	lea    0x0(%esi),%esi

80102d00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	57                   	push   %edi
80102d04:	56                   	push   %esi
80102d05:	53                   	push   %ebx
80102d06:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102d09:	68 80 26 11 80       	push   $0x80112680
80102d0e:	e8 8d 17 00 00       	call   801044a0 <acquire>
  log.outstanding -= 1;
80102d13:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102d18:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102d1e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102d21:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102d24:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102d2a:	85 f6                	test   %esi,%esi
80102d2c:	0f 85 22 01 00 00    	jne    80102e54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102d32:	85 db                	test   %ebx,%ebx
80102d34:	0f 85 f6 00 00 00    	jne    80102e30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102d3a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102d41:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102d44:	83 ec 0c             	sub    $0xc,%esp
80102d47:	68 80 26 11 80       	push   $0x80112680
80102d4c:	e8 0f 18 00 00       	call   80104560 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102d51:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102d57:	83 c4 10             	add    $0x10,%esp
80102d5a:	85 c9                	test   %ecx,%ecx
80102d5c:	7f 42                	jg     80102da0 <end_op+0xa0>
    acquire(&log.lock);
80102d5e:	83 ec 0c             	sub    $0xc,%esp
80102d61:	68 80 26 11 80       	push   $0x80112680
80102d66:	e8 35 17 00 00       	call   801044a0 <acquire>
    wakeup(&log);
80102d6b:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
80102d72:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102d79:	00 00 00 
    wakeup(&log);
80102d7c:	e8 9f 12 00 00       	call   80104020 <wakeup>
    release(&log.lock);
80102d81:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d88:	e8 d3 17 00 00       	call   80104560 <release>
80102d8d:	83 c4 10             	add    $0x10,%esp
}
80102d90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d93:	5b                   	pop    %ebx
80102d94:	5e                   	pop    %esi
80102d95:	5f                   	pop    %edi
80102d96:	5d                   	pop    %ebp
80102d97:	c3                   	ret    
80102d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d9f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102da0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102da5:	83 ec 08             	sub    $0x8,%esp
80102da8:	01 d8                	add    %ebx,%eax
80102daa:	83 c0 01             	add    $0x1,%eax
80102dad:	50                   	push   %eax
80102dae:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102db4:	e8 17 d3 ff ff       	call   801000d0 <bread>
80102db9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dbb:	58                   	pop    %eax
80102dbc:	5a                   	pop    %edx
80102dbd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102dc4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dcd:	e8 fe d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102dd2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102dd5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102dd7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102dda:	68 00 02 00 00       	push   $0x200
80102ddf:	50                   	push   %eax
80102de0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102de3:	50                   	push   %eax
80102de4:	e8 67 18 00 00       	call   80104650 <memmove>
    bwrite(to);  // write the log
80102de9:	89 34 24             	mov    %esi,(%esp)
80102dec:	e8 bf d3 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102df1:	89 3c 24             	mov    %edi,(%esp)
80102df4:	e8 f7 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102df9:	89 34 24             	mov    %esi,(%esp)
80102dfc:	e8 ef d3 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e01:	83 c4 10             	add    $0x10,%esp
80102e04:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102e0a:	7c 94                	jl     80102da0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e0c:	e8 7f fd ff ff       	call   80102b90 <write_head>
    install_trans(); // Now install writes to home locations
80102e11:	e8 da fc ff ff       	call   80102af0 <install_trans>
    log.lh.n = 0;
80102e16:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102e1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102e20:	e8 6b fd ff ff       	call   80102b90 <write_head>
80102e25:	e9 34 ff ff ff       	jmp    80102d5e <end_op+0x5e>
80102e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102e30:	83 ec 0c             	sub    $0xc,%esp
80102e33:	68 80 26 11 80       	push   $0x80112680
80102e38:	e8 e3 11 00 00       	call   80104020 <wakeup>
  release(&log.lock);
80102e3d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102e44:	e8 17 17 00 00       	call   80104560 <release>
80102e49:	83 c4 10             	add    $0x10,%esp
}
80102e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e4f:	5b                   	pop    %ebx
80102e50:	5e                   	pop    %esi
80102e51:	5f                   	pop    %edi
80102e52:	5d                   	pop    %ebp
80102e53:	c3                   	ret    
    panic("log.committing");
80102e54:	83 ec 0c             	sub    $0xc,%esp
80102e57:	68 84 74 10 80       	push   $0x80107484
80102e5c:	e8 2f d5 ff ff       	call   80100390 <panic>
80102e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6f:	90                   	nop

80102e70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	53                   	push   %ebx
80102e74:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e77:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
80102e7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102e80:	83 fa 1d             	cmp    $0x1d,%edx
80102e83:	0f 8f 94 00 00 00    	jg     80102f1d <log_write+0xad>
80102e89:	a1 b8 26 11 80       	mov    0x801126b8,%eax
80102e8e:	83 e8 01             	sub    $0x1,%eax
80102e91:	39 c2                	cmp    %eax,%edx
80102e93:	0f 8d 84 00 00 00    	jge    80102f1d <log_write+0xad>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102e99:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102e9e:	85 c0                	test   %eax,%eax
80102ea0:	0f 8e 84 00 00 00    	jle    80102f2a <log_write+0xba>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102ea6:	83 ec 0c             	sub    $0xc,%esp
80102ea9:	68 80 26 11 80       	push   $0x80112680
80102eae:	e8 ed 15 00 00       	call   801044a0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102eb3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102eb9:	83 c4 10             	add    $0x10,%esp
80102ebc:	85 d2                	test   %edx,%edx
80102ebe:	7e 51                	jle    80102f11 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ec0:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102ec3:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102ec5:	3b 0d cc 26 11 80    	cmp    0x801126cc,%ecx
80102ecb:	75 0c                	jne    80102ed9 <log_write+0x69>
80102ecd:	eb 39                	jmp    80102f08 <log_write+0x98>
80102ecf:	90                   	nop
80102ed0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102ed7:	74 2f                	je     80102f08 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102ed9:	83 c0 01             	add    $0x1,%eax
80102edc:	39 c2                	cmp    %eax,%edx
80102ede:	75 f0                	jne    80102ed0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ee0:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102ee7:	83 c2 01             	add    $0x1,%edx
80102eea:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102ef0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102ef3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102ef6:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102efd:	c9                   	leave  
  release(&log.lock);
80102efe:	e9 5d 16 00 00       	jmp    80104560 <release>
80102f03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f07:	90                   	nop
  log.lh.block[i] = b->blockno;
80102f08:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102f0f:	eb df                	jmp    80102ef0 <log_write+0x80>
  log.lh.block[i] = b->blockno;
80102f11:	8b 43 08             	mov    0x8(%ebx),%eax
80102f14:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102f19:	75 d5                	jne    80102ef0 <log_write+0x80>
80102f1b:	eb ca                	jmp    80102ee7 <log_write+0x77>
    panic("too big a transaction");
80102f1d:	83 ec 0c             	sub    $0xc,%esp
80102f20:	68 93 74 10 80       	push   $0x80107493
80102f25:	e8 66 d4 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102f2a:	83 ec 0c             	sub    $0xc,%esp
80102f2d:	68 a9 74 10 80       	push   $0x801074a9
80102f32:	e8 59 d4 ff ff       	call   80100390 <panic>
80102f37:	66 90                	xchg   %ax,%ax
80102f39:	66 90                	xchg   %ax,%ax
80102f3b:	66 90                	xchg   %ax,%ax
80102f3d:	66 90                	xchg   %ax,%ax
80102f3f:	90                   	nop

80102f40 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	53                   	push   %ebx
80102f44:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102f47:	e8 64 09 00 00       	call   801038b0 <cpuid>
80102f4c:	89 c3                	mov    %eax,%ebx
80102f4e:	e8 5d 09 00 00       	call   801038b0 <cpuid>
80102f53:	83 ec 04             	sub    $0x4,%esp
80102f56:	53                   	push   %ebx
80102f57:	50                   	push   %eax
80102f58:	68 c4 74 10 80       	push   $0x801074c4
80102f5d:	e8 4e d7 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80102f62:	e8 99 28 00 00       	call   80105800 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102f67:	e8 c4 08 00 00       	call   80103830 <mycpu>
80102f6c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102f6e:	b8 01 00 00 00       	mov    $0x1,%eax
80102f73:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102f7a:	e8 11 0c 00 00       	call   80103b90 <scheduler>
80102f7f:	90                   	nop

80102f80 <mpenter>:
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102f86:	e8 75 39 00 00       	call   80106900 <switchkvm>
  seginit();
80102f8b:	e8 e0 38 00 00       	call   80106870 <seginit>
  lapicinit();
80102f90:	e8 8b f7 ff ff       	call   80102720 <lapicinit>
  mpmain();
80102f95:	e8 a6 ff ff ff       	call   80102f40 <mpmain>
80102f9a:	66 90                	xchg   %ax,%ax
80102f9c:	66 90                	xchg   %ax,%ax
80102f9e:	66 90                	xchg   %ax,%ax

80102fa0 <main>:
{
80102fa0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102fa4:	83 e4 f0             	and    $0xfffffff0,%esp
80102fa7:	ff 71 fc             	pushl  -0x4(%ecx)
80102faa:	55                   	push   %ebp
80102fab:	89 e5                	mov    %esp,%ebp
80102fad:	53                   	push   %ebx
80102fae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102faf:	83 ec 08             	sub    $0x8,%esp
80102fb2:	68 00 00 40 80       	push   $0x80400000
80102fb7:	68 a8 54 11 80       	push   $0x801154a8
80102fbc:	e8 0f f5 ff ff       	call   801024d0 <kinit1>
  kvmalloc();      // kernel page table
80102fc1:	e8 fa 3d 00 00       	call   80106dc0 <kvmalloc>
  mpinit();        // detect other processors
80102fc6:	e8 85 01 00 00       	call   80103150 <mpinit>
  lapicinit();     // interrupt controller
80102fcb:	e8 50 f7 ff ff       	call   80102720 <lapicinit>
  seginit();       // segment descriptors
80102fd0:	e8 9b 38 00 00       	call   80106870 <seginit>
  picinit();       // disable pic
80102fd5:	e8 46 03 00 00       	call   80103320 <picinit>
  ioapicinit();    // another interrupt controller
80102fda:	e8 11 f3 ff ff       	call   801022f0 <ioapicinit>
  consoleinit();   // console hardware
80102fdf:	e8 4c da ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80102fe4:	e8 47 2b 00 00       	call   80105b30 <uartinit>
  pinit();         // process table
80102fe9:	e8 22 08 00 00       	call   80103810 <pinit>
  tvinit();        // trap vectors
80102fee:	e8 8d 27 00 00       	call   80105780 <tvinit>
  binit();         // buffer cache
80102ff3:	e8 48 d0 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ff8:	e8 e3 dd ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80102ffd:	e8 ce f0 ff ff       	call   801020d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103002:	83 c4 0c             	add    $0xc,%esp
80103005:	68 8a 00 00 00       	push   $0x8a
8010300a:	68 8c a4 10 80       	push   $0x8010a48c
8010300f:	68 00 70 00 80       	push   $0x80007000
80103014:	e8 37 16 00 00       	call   80104650 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103019:	83 c4 10             	add    $0x10,%esp
8010301c:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103023:	00 00 00 
80103026:	05 80 27 11 80       	add    $0x80112780,%eax
8010302b:	3d 80 27 11 80       	cmp    $0x80112780,%eax
80103030:	76 7e                	jbe    801030b0 <main+0x110>
80103032:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80103037:	eb 20                	jmp    80103059 <main+0xb9>
80103039:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103040:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103047:	00 00 00 
8010304a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103050:	05 80 27 11 80       	add    $0x80112780,%eax
80103055:	39 c3                	cmp    %eax,%ebx
80103057:	73 57                	jae    801030b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103059:	e8 d2 07 00 00       	call   80103830 <mycpu>
8010305e:	39 d8                	cmp    %ebx,%eax
80103060:	74 de                	je     80103040 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103062:	e8 39 f5 ff ff       	call   801025a0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103067:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010306a:	c7 05 f8 6f 00 80 80 	movl   $0x80102f80,0x80006ff8
80103071:	2f 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103074:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010307b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010307e:	05 00 10 00 00       	add    $0x1000,%eax
80103083:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103088:	0f b6 03             	movzbl (%ebx),%eax
8010308b:	68 00 70 00 00       	push   $0x7000
80103090:	50                   	push   %eax
80103091:	e8 da f7 ff ff       	call   80102870 <lapicstartap>
80103096:	83 c4 10             	add    $0x10,%esp
80103099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801030a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801030a6:	85 c0                	test   %eax,%eax
801030a8:	74 f6                	je     801030a0 <main+0x100>
801030aa:	eb 94                	jmp    80103040 <main+0xa0>
801030ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801030b0:	83 ec 08             	sub    $0x8,%esp
801030b3:	68 00 00 00 8e       	push   $0x8e000000
801030b8:	68 00 00 40 80       	push   $0x80400000
801030bd:	e8 7e f4 ff ff       	call   80102540 <kinit2>
  userinit();      // first user process
801030c2:	e8 39 08 00 00       	call   80103900 <userinit>
  mpmain();        // finish this processor's setup
801030c7:	e8 74 fe ff ff       	call   80102f40 <mpmain>
801030cc:	66 90                	xchg   %ax,%ax
801030ce:	66 90                	xchg   %ax,%ax

801030d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	57                   	push   %edi
801030d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801030d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801030db:	53                   	push   %ebx
  e = addr+len;
801030dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801030df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801030e2:	39 de                	cmp    %ebx,%esi
801030e4:	72 10                	jb     801030f6 <mpsearch1+0x26>
801030e6:	eb 50                	jmp    80103138 <mpsearch1+0x68>
801030e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030ef:	90                   	nop
801030f0:	89 fe                	mov    %edi,%esi
801030f2:	39 fb                	cmp    %edi,%ebx
801030f4:	76 42                	jbe    80103138 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801030f6:	83 ec 04             	sub    $0x4,%esp
801030f9:	8d 7e 10             	lea    0x10(%esi),%edi
801030fc:	6a 04                	push   $0x4
801030fe:	68 d8 74 10 80       	push   $0x801074d8
80103103:	56                   	push   %esi
80103104:	e8 f7 14 00 00       	call   80104600 <memcmp>
80103109:	83 c4 10             	add    $0x10,%esp
8010310c:	85 c0                	test   %eax,%eax
8010310e:	75 e0                	jne    801030f0 <mpsearch1+0x20>
80103110:	89 f1                	mov    %esi,%ecx
80103112:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103118:	0f b6 11             	movzbl (%ecx),%edx
8010311b:	83 c1 01             	add    $0x1,%ecx
8010311e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103120:	39 f9                	cmp    %edi,%ecx
80103122:	75 f4                	jne    80103118 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103124:	84 c0                	test   %al,%al
80103126:	75 c8                	jne    801030f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103128:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010312b:	89 f0                	mov    %esi,%eax
8010312d:	5b                   	pop    %ebx
8010312e:	5e                   	pop    %esi
8010312f:	5f                   	pop    %edi
80103130:	5d                   	pop    %ebp
80103131:	c3                   	ret    
80103132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103138:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010313b:	31 f6                	xor    %esi,%esi
}
8010313d:	5b                   	pop    %ebx
8010313e:	89 f0                	mov    %esi,%eax
80103140:	5e                   	pop    %esi
80103141:	5f                   	pop    %edi
80103142:	5d                   	pop    %ebp
80103143:	c3                   	ret    
80103144:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010314b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010314f:	90                   	nop

80103150 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	57                   	push   %edi
80103154:	56                   	push   %esi
80103155:	53                   	push   %ebx
80103156:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103159:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103160:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103167:	c1 e0 08             	shl    $0x8,%eax
8010316a:	09 d0                	or     %edx,%eax
8010316c:	c1 e0 04             	shl    $0x4,%eax
8010316f:	75 1b                	jne    8010318c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103171:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103178:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010317f:	c1 e0 08             	shl    $0x8,%eax
80103182:	09 d0                	or     %edx,%eax
80103184:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103187:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010318c:	ba 00 04 00 00       	mov    $0x400,%edx
80103191:	e8 3a ff ff ff       	call   801030d0 <mpsearch1>
80103196:	89 c7                	mov    %eax,%edi
80103198:	85 c0                	test   %eax,%eax
8010319a:	0f 84 c0 00 00 00    	je     80103260 <mpinit+0x110>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801031a0:	8b 5f 04             	mov    0x4(%edi),%ebx
801031a3:	85 db                	test   %ebx,%ebx
801031a5:	0f 84 d5 00 00 00    	je     80103280 <mpinit+0x130>
  if(memcmp(conf, "PCMP", 4) != 0)
801031ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031ae:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801031b4:	6a 04                	push   $0x4
801031b6:	68 f5 74 10 80       	push   $0x801074f5
801031bb:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801031bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801031bf:	e8 3c 14 00 00       	call   80104600 <memcmp>
801031c4:	83 c4 10             	add    $0x10,%esp
801031c7:	85 c0                	test   %eax,%eax
801031c9:	0f 85 b1 00 00 00    	jne    80103280 <mpinit+0x130>
  if(conf->version != 1 && conf->version != 4)
801031cf:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801031d6:	3c 01                	cmp    $0x1,%al
801031d8:	0f 95 c2             	setne  %dl
801031db:	3c 04                	cmp    $0x4,%al
801031dd:	0f 95 c0             	setne  %al
801031e0:	20 c2                	and    %al,%dl
801031e2:	0f 85 98 00 00 00    	jne    80103280 <mpinit+0x130>
  if(sum((uchar*)conf, conf->length) != 0)
801031e8:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
  for(i=0; i<len; i++)
801031ef:	66 85 c9             	test   %cx,%cx
801031f2:	74 21                	je     80103215 <mpinit+0xc5>
801031f4:	89 d8                	mov    %ebx,%eax
801031f6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
  sum = 0;
801031f9:	31 d2                	xor    %edx,%edx
801031fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801031ff:	90                   	nop
    sum += addr[i];
80103200:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103207:	83 c0 01             	add    $0x1,%eax
8010320a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010320c:	39 c6                	cmp    %eax,%esi
8010320e:	75 f0                	jne    80103200 <mpinit+0xb0>
80103210:	84 d2                	test   %dl,%dl
80103212:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103215:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103218:	85 c9                	test   %ecx,%ecx
8010321a:	74 64                	je     80103280 <mpinit+0x130>
8010321c:	84 d2                	test   %dl,%dl
8010321e:	75 60                	jne    80103280 <mpinit+0x130>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103220:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103226:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010322b:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103232:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103238:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010323d:	01 d1                	add    %edx,%ecx
8010323f:	89 ce                	mov    %ecx,%esi
80103241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103248:	39 c6                	cmp    %eax,%esi
8010324a:	76 4b                	jbe    80103297 <mpinit+0x147>
    switch(*p){
8010324c:	0f b6 10             	movzbl (%eax),%edx
8010324f:	80 fa 04             	cmp    $0x4,%dl
80103252:	0f 87 bf 00 00 00    	ja     80103317 <mpinit+0x1c7>
80103258:	ff 24 95 1c 75 10 80 	jmp    *-0x7fef8ae4(,%edx,4)
8010325f:	90                   	nop
  return mpsearch1(0xF0000, 0x10000);
80103260:	ba 00 00 01 00       	mov    $0x10000,%edx
80103265:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010326a:	e8 61 fe ff ff       	call   801030d0 <mpsearch1>
8010326f:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103271:	85 c0                	test   %eax,%eax
80103273:	0f 85 27 ff ff ff    	jne    801031a0 <mpinit+0x50>
80103279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103280:	83 ec 0c             	sub    $0xc,%esp
80103283:	68 dd 74 10 80       	push   $0x801074dd
80103288:	e8 03 d1 ff ff       	call   80100390 <panic>
8010328d:	8d 76 00             	lea    0x0(%esi),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103290:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103293:	39 c6                	cmp    %eax,%esi
80103295:	77 b5                	ja     8010324c <mpinit+0xfc>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103297:	85 db                	test   %ebx,%ebx
80103299:	74 6f                	je     8010330a <mpinit+0x1ba>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010329b:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
8010329f:	74 15                	je     801032b6 <mpinit+0x166>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032a1:	b8 70 00 00 00       	mov    $0x70,%eax
801032a6:	ba 22 00 00 00       	mov    $0x22,%edx
801032ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801032ac:	ba 23 00 00 00       	mov    $0x23,%edx
801032b1:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801032b2:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801032b5:	ee                   	out    %al,(%dx)
  }
}
801032b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032b9:	5b                   	pop    %ebx
801032ba:	5e                   	pop    %esi
801032bb:	5f                   	pop    %edi
801032bc:	5d                   	pop    %ebp
801032bd:	c3                   	ret    
801032be:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801032c0:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
801032c6:	83 fa 07             	cmp    $0x7,%edx
801032c9:	7f 1f                	jg     801032ea <mpinit+0x19a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801032cb:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801032d1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801032d4:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801032d8:	88 91 80 27 11 80    	mov    %dl,-0x7feed880(%ecx)
        ncpu++;
801032de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801032e1:	83 c2 01             	add    $0x1,%edx
801032e4:	89 15 00 2d 11 80    	mov    %edx,0x80112d00
      p += sizeof(struct mpproc);
801032ea:	83 c0 14             	add    $0x14,%eax
      continue;
801032ed:	e9 56 ff ff ff       	jmp    80103248 <mpinit+0xf8>
801032f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ioapicid = ioapic->apicno;
801032f8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
801032fc:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801032ff:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103305:	e9 3e ff ff ff       	jmp    80103248 <mpinit+0xf8>
    panic("Didn't find a suitable machine");
8010330a:	83 ec 0c             	sub    $0xc,%esp
8010330d:	68 fc 74 10 80       	push   $0x801074fc
80103312:	e8 79 d0 ff ff       	call   80100390 <panic>
      ismp = 0;
80103317:	31 db                	xor    %ebx,%ebx
80103319:	e9 31 ff ff ff       	jmp    8010324f <mpinit+0xff>
8010331e:	66 90                	xchg   %ax,%ax

80103320 <picinit>:
80103320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103325:	ba 21 00 00 00       	mov    $0x21,%edx
8010332a:	ee                   	out    %al,(%dx)
8010332b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103330:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103331:	c3                   	ret    
80103332:	66 90                	xchg   %ax,%ax
80103334:	66 90                	xchg   %ax,%ax
80103336:	66 90                	xchg   %ax,%ax
80103338:	66 90                	xchg   %ax,%ax
8010333a:	66 90                	xchg   %ax,%ax
8010333c:	66 90                	xchg   %ax,%ax
8010333e:	66 90                	xchg   %ax,%ax

80103340 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103340:	55                   	push   %ebp
80103341:	89 e5                	mov    %esp,%ebp
80103343:	57                   	push   %edi
80103344:	56                   	push   %esi
80103345:	53                   	push   %ebx
80103346:	83 ec 0c             	sub    $0xc,%esp
80103349:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010334c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010334f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103355:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010335b:	e8 a0 da ff ff       	call   80100e00 <filealloc>
80103360:	89 03                	mov    %eax,(%ebx)
80103362:	85 c0                	test   %eax,%eax
80103364:	0f 84 a8 00 00 00    	je     80103412 <pipealloc+0xd2>
8010336a:	e8 91 da ff ff       	call   80100e00 <filealloc>
8010336f:	89 06                	mov    %eax,(%esi)
80103371:	85 c0                	test   %eax,%eax
80103373:	0f 84 87 00 00 00    	je     80103400 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103379:	e8 22 f2 ff ff       	call   801025a0 <kalloc>
8010337e:	89 c7                	mov    %eax,%edi
80103380:	85 c0                	test   %eax,%eax
80103382:	0f 84 b0 00 00 00    	je     80103438 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103388:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010338f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103392:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103395:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010339c:	00 00 00 
  p->nwrite = 0;
8010339f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801033a6:	00 00 00 
  p->nread = 0;
801033a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801033b0:	00 00 00 
  initlock(&p->lock, "pipe");
801033b3:	68 30 75 10 80       	push   $0x80107530
801033b8:	50                   	push   %eax
801033b9:	e8 82 0f 00 00       	call   80104340 <initlock>
  (*f0)->type = FD_PIPE;
801033be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801033c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801033c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801033c9:	8b 03                	mov    (%ebx),%eax
801033cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801033cf:	8b 03                	mov    (%ebx),%eax
801033d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801033d5:	8b 03                	mov    (%ebx),%eax
801033d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801033da:	8b 06                	mov    (%esi),%eax
801033dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801033e2:	8b 06                	mov    (%esi),%eax
801033e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801033e8:	8b 06                	mov    (%esi),%eax
801033ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801033ee:	8b 06                	mov    (%esi),%eax
801033f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801033f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033f6:	31 c0                	xor    %eax,%eax
}
801033f8:	5b                   	pop    %ebx
801033f9:	5e                   	pop    %esi
801033fa:	5f                   	pop    %edi
801033fb:	5d                   	pop    %ebp
801033fc:	c3                   	ret    
801033fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103400:	8b 03                	mov    (%ebx),%eax
80103402:	85 c0                	test   %eax,%eax
80103404:	74 1e                	je     80103424 <pipealloc+0xe4>
    fileclose(*f0);
80103406:	83 ec 0c             	sub    $0xc,%esp
80103409:	50                   	push   %eax
8010340a:	e8 b1 da ff ff       	call   80100ec0 <fileclose>
8010340f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103412:	8b 06                	mov    (%esi),%eax
80103414:	85 c0                	test   %eax,%eax
80103416:	74 0c                	je     80103424 <pipealloc+0xe4>
    fileclose(*f1);
80103418:	83 ec 0c             	sub    $0xc,%esp
8010341b:	50                   	push   %eax
8010341c:	e8 9f da ff ff       	call   80100ec0 <fileclose>
80103421:	83 c4 10             	add    $0x10,%esp
}
80103424:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103427:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010342c:	5b                   	pop    %ebx
8010342d:	5e                   	pop    %esi
8010342e:	5f                   	pop    %edi
8010342f:	5d                   	pop    %ebp
80103430:	c3                   	ret    
80103431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103438:	8b 03                	mov    (%ebx),%eax
8010343a:	85 c0                	test   %eax,%eax
8010343c:	75 c8                	jne    80103406 <pipealloc+0xc6>
8010343e:	eb d2                	jmp    80103412 <pipealloc+0xd2>

80103440 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103440:	55                   	push   %ebp
80103441:	89 e5                	mov    %esp,%ebp
80103443:	56                   	push   %esi
80103444:	53                   	push   %ebx
80103445:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103448:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010344b:	83 ec 0c             	sub    $0xc,%esp
8010344e:	53                   	push   %ebx
8010344f:	e8 4c 10 00 00       	call   801044a0 <acquire>
  if(writable){
80103454:	83 c4 10             	add    $0x10,%esp
80103457:	85 f6                	test   %esi,%esi
80103459:	74 65                	je     801034c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010345b:	83 ec 0c             	sub    $0xc,%esp
8010345e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103464:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010346b:	00 00 00 
    wakeup(&p->nread);
8010346e:	50                   	push   %eax
8010346f:	e8 ac 0b 00 00       	call   80104020 <wakeup>
80103474:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103477:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010347d:	85 d2                	test   %edx,%edx
8010347f:	75 0a                	jne    8010348b <pipeclose+0x4b>
80103481:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103487:	85 c0                	test   %eax,%eax
80103489:	74 15                	je     801034a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010348b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010348e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103491:	5b                   	pop    %ebx
80103492:	5e                   	pop    %esi
80103493:	5d                   	pop    %ebp
    release(&p->lock);
80103494:	e9 c7 10 00 00       	jmp    80104560 <release>
80103499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	53                   	push   %ebx
801034a4:	e8 b7 10 00 00       	call   80104560 <release>
    kfree((char*)p);
801034a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801034ac:	83 c4 10             	add    $0x10,%esp
}
801034af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034b2:	5b                   	pop    %ebx
801034b3:	5e                   	pop    %esi
801034b4:	5d                   	pop    %ebp
    kfree((char*)p);
801034b5:	e9 26 ef ff ff       	jmp    801023e0 <kfree>
801034ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801034c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801034d0:	00 00 00 
    wakeup(&p->nwrite);
801034d3:	50                   	push   %eax
801034d4:	e8 47 0b 00 00       	call   80104020 <wakeup>
801034d9:	83 c4 10             	add    $0x10,%esp
801034dc:	eb 99                	jmp    80103477 <pipeclose+0x37>
801034de:	66 90                	xchg   %ax,%ax

801034e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
801034e5:	53                   	push   %ebx
801034e6:	83 ec 28             	sub    $0x28,%esp
801034e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801034ec:	53                   	push   %ebx
801034ed:	e8 ae 0f 00 00       	call   801044a0 <acquire>
  for(i = 0; i < n; i++){
801034f2:	8b 45 10             	mov    0x10(%ebp),%eax
801034f5:	83 c4 10             	add    $0x10,%esp
801034f8:	85 c0                	test   %eax,%eax
801034fa:	0f 8e c8 00 00 00    	jle    801035c8 <pipewrite+0xe8>
80103500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103503:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103509:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010350f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103512:	03 4d 10             	add    0x10(%ebp),%ecx
80103515:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103518:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010351e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103524:	39 d0                	cmp    %edx,%eax
80103526:	75 71                	jne    80103599 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103528:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010352e:	85 c0                	test   %eax,%eax
80103530:	74 4e                	je     80103580 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103532:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103538:	eb 3a                	jmp    80103574 <pipewrite+0x94>
8010353a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103540:	83 ec 0c             	sub    $0xc,%esp
80103543:	57                   	push   %edi
80103544:	e8 d7 0a 00 00       	call   80104020 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103549:	5a                   	pop    %edx
8010354a:	59                   	pop    %ecx
8010354b:	53                   	push   %ebx
8010354c:	56                   	push   %esi
8010354d:	e8 1e 09 00 00       	call   80103e70 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103552:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103558:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010355e:	83 c4 10             	add    $0x10,%esp
80103561:	05 00 02 00 00       	add    $0x200,%eax
80103566:	39 c2                	cmp    %eax,%edx
80103568:	75 36                	jne    801035a0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010356a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103570:	85 c0                	test   %eax,%eax
80103572:	74 0c                	je     80103580 <pipewrite+0xa0>
80103574:	e8 57 03 00 00       	call   801038d0 <myproc>
80103579:	8b 40 24             	mov    0x24(%eax),%eax
8010357c:	85 c0                	test   %eax,%eax
8010357e:	74 c0                	je     80103540 <pipewrite+0x60>
        release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 d7 0f 00 00       	call   80104560 <release>
        return -1;
80103589:	83 c4 10             	add    $0x10,%esp
8010358c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103591:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103594:	5b                   	pop    %ebx
80103595:	5e                   	pop    %esi
80103596:	5f                   	pop    %edi
80103597:	5d                   	pop    %ebp
80103598:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103599:	89 c2                	mov    %eax,%edx
8010359b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010359f:	90                   	nop
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801035a0:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801035a3:	8d 42 01             	lea    0x1(%edx),%eax
801035a6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801035ac:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801035b2:	0f b6 0e             	movzbl (%esi),%ecx
801035b5:	83 c6 01             	add    $0x1,%esi
801035b8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801035bb:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801035bf:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801035c2:	0f 85 50 ff ff ff    	jne    80103518 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801035c8:	83 ec 0c             	sub    $0xc,%esp
801035cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801035d1:	50                   	push   %eax
801035d2:	e8 49 0a 00 00       	call   80104020 <wakeup>
  release(&p->lock);
801035d7:	89 1c 24             	mov    %ebx,(%esp)
801035da:	e8 81 0f 00 00       	call   80104560 <release>
  return n;
801035df:	83 c4 10             	add    $0x10,%esp
801035e2:	8b 45 10             	mov    0x10(%ebp),%eax
801035e5:	eb aa                	jmp    80103591 <pipewrite+0xb1>
801035e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035ee:	66 90                	xchg   %ax,%ax

801035f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	57                   	push   %edi
801035f4:	56                   	push   %esi
801035f5:	53                   	push   %ebx
801035f6:	83 ec 18             	sub    $0x18,%esp
801035f9:	8b 75 08             	mov    0x8(%ebp),%esi
801035fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801035ff:	56                   	push   %esi
80103600:	e8 9b 0e 00 00       	call   801044a0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103605:	83 c4 10             	add    $0x10,%esp
80103608:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010360e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103614:	75 6a                	jne    80103680 <piperead+0x90>
80103616:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010361c:	85 db                	test   %ebx,%ebx
8010361e:	0f 84 c4 00 00 00    	je     801036e8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103624:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010362a:	eb 2d                	jmp    80103659 <piperead+0x69>
8010362c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103630:	83 ec 08             	sub    $0x8,%esp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	e8 36 08 00 00       	call   80103e70 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010363a:	83 c4 10             	add    $0x10,%esp
8010363d:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103643:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103649:	75 35                	jne    80103680 <piperead+0x90>
8010364b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103651:	85 d2                	test   %edx,%edx
80103653:	0f 84 8f 00 00 00    	je     801036e8 <piperead+0xf8>
    if(myproc()->killed){
80103659:	e8 72 02 00 00       	call   801038d0 <myproc>
8010365e:	8b 48 24             	mov    0x24(%eax),%ecx
80103661:	85 c9                	test   %ecx,%ecx
80103663:	74 cb                	je     80103630 <piperead+0x40>
      release(&p->lock);
80103665:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103668:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010366d:	56                   	push   %esi
8010366e:	e8 ed 0e 00 00       	call   80104560 <release>
      return -1;
80103673:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103679:	89 d8                	mov    %ebx,%eax
8010367b:	5b                   	pop    %ebx
8010367c:	5e                   	pop    %esi
8010367d:	5f                   	pop    %edi
8010367e:	5d                   	pop    %ebp
8010367f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103680:	8b 45 10             	mov    0x10(%ebp),%eax
80103683:	85 c0                	test   %eax,%eax
80103685:	7e 61                	jle    801036e8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103687:	31 db                	xor    %ebx,%ebx
80103689:	eb 13                	jmp    8010369e <piperead+0xae>
8010368b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010368f:	90                   	nop
80103690:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103696:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010369c:	74 1f                	je     801036bd <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010369e:	8d 41 01             	lea    0x1(%ecx),%eax
801036a1:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801036a7:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
801036ad:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
801036b2:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801036b5:	83 c3 01             	add    $0x1,%ebx
801036b8:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801036bb:	75 d3                	jne    80103690 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801036bd:	83 ec 0c             	sub    $0xc,%esp
801036c0:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801036c6:	50                   	push   %eax
801036c7:	e8 54 09 00 00       	call   80104020 <wakeup>
  release(&p->lock);
801036cc:	89 34 24             	mov    %esi,(%esp)
801036cf:	e8 8c 0e 00 00       	call   80104560 <release>
  return i;
801036d4:	83 c4 10             	add    $0x10,%esp
}
801036d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036da:	89 d8                	mov    %ebx,%eax
801036dc:	5b                   	pop    %ebx
801036dd:	5e                   	pop    %esi
801036de:	5f                   	pop    %edi
801036df:	5d                   	pop    %ebp
801036e0:	c3                   	ret    
801036e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
801036e8:	31 db                	xor    %ebx,%ebx
801036ea:	eb d1                	jmp    801036bd <piperead+0xcd>
801036ec:	66 90                	xchg   %ax,%ax
801036ee:	66 90                	xchg   %ax,%ax

801036f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036f4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801036f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801036fc:	68 20 2d 11 80       	push   $0x80112d20
80103701:	e8 9a 0d 00 00       	call   801044a0 <acquire>
80103706:	83 c4 10             	add    $0x10,%esp
80103709:	eb 10                	jmp    8010371b <allocproc+0x2b>
8010370b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010370f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103710:	83 c3 7c             	add    $0x7c,%ebx
80103713:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103719:	74 75                	je     80103790 <allocproc+0xa0>
    if(p->state == UNUSED)
8010371b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010371e:	85 c0                	test   %eax,%eax
80103720:	75 ee                	jne    80103710 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103722:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103727:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010372a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103731:	89 43 10             	mov    %eax,0x10(%ebx)
80103734:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103737:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010373c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103742:	e8 19 0e 00 00       	call   80104560 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103747:	e8 54 ee ff ff       	call   801025a0 <kalloc>
8010374c:	83 c4 10             	add    $0x10,%esp
8010374f:	89 43 08             	mov    %eax,0x8(%ebx)
80103752:	85 c0                	test   %eax,%eax
80103754:	74 53                	je     801037a9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103756:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010375c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010375f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103764:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103767:	c7 40 14 6d 57 10 80 	movl   $0x8010576d,0x14(%eax)
  p->context = (struct context*)sp;
8010376e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103771:	6a 14                	push   $0x14
80103773:	6a 00                	push   $0x0
80103775:	50                   	push   %eax
80103776:	e8 35 0e 00 00       	call   801045b0 <memset>
  p->context->eip = (uint)forkret;
8010377b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010377e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103781:	c7 40 10 c0 37 10 80 	movl   $0x801037c0,0x10(%eax)
}
80103788:	89 d8                	mov    %ebx,%eax
8010378a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010378d:	c9                   	leave  
8010378e:	c3                   	ret    
8010378f:	90                   	nop
  release(&ptable.lock);
80103790:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103793:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103795:	68 20 2d 11 80       	push   $0x80112d20
8010379a:	e8 c1 0d 00 00       	call   80104560 <release>
}
8010379f:	89 d8                	mov    %ebx,%eax
  return 0;
801037a1:	83 c4 10             	add    $0x10,%esp
}
801037a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037a7:	c9                   	leave  
801037a8:	c3                   	ret    
    p->state = UNUSED;
801037a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801037b0:	31 db                	xor    %ebx,%ebx
}
801037b2:	89 d8                	mov    %ebx,%eax
801037b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037b7:	c9                   	leave  
801037b8:	c3                   	ret    
801037b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801037c0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801037c0:	55                   	push   %ebp
801037c1:	89 e5                	mov    %esp,%ebp
801037c3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801037c6:	68 20 2d 11 80       	push   $0x80112d20
801037cb:	e8 90 0d 00 00       	call   80104560 <release>

  if (first) {
801037d0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801037d5:	83 c4 10             	add    $0x10,%esp
801037d8:	85 c0                	test   %eax,%eax
801037da:	75 04                	jne    801037e0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801037dc:	c9                   	leave  
801037dd:	c3                   	ret    
801037de:	66 90                	xchg   %ax,%ax
    first = 0;
801037e0:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801037e7:	00 00 00 
    iinit(ROOTDEV);
801037ea:	83 ec 0c             	sub    $0xc,%esp
801037ed:	6a 01                	push   $0x1
801037ef:	e8 1c dd ff ff       	call   80101510 <iinit>
    initlog(ROOTDEV);
801037f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801037fb:	e8 f0 f3 ff ff       	call   80102bf0 <initlog>
80103800:	83 c4 10             	add    $0x10,%esp
}
80103803:	c9                   	leave  
80103804:	c3                   	ret    
80103805:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010380c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103810 <pinit>:
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103816:	68 35 75 10 80       	push   $0x80107535
8010381b:	68 20 2d 11 80       	push   $0x80112d20
80103820:	e8 1b 0b 00 00       	call   80104340 <initlock>
}
80103825:	83 c4 10             	add    $0x10,%esp
80103828:	c9                   	leave  
80103829:	c3                   	ret    
8010382a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103830 <mycpu>:
{
80103830:	55                   	push   %ebp
80103831:	89 e5                	mov    %esp,%ebp
80103833:	56                   	push   %esi
80103834:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103835:	9c                   	pushf  
80103836:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103837:	f6 c4 02             	test   $0x2,%ah
8010383a:	75 5d                	jne    80103899 <mycpu+0x69>
  apicid = lapicid();
8010383c:	e8 df ef ff ff       	call   80102820 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103841:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103847:	85 f6                	test   %esi,%esi
80103849:	7e 41                	jle    8010388c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
8010384b:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103852:	39 d0                	cmp    %edx,%eax
80103854:	74 2f                	je     80103885 <mycpu+0x55>
  for (i = 0; i < ncpu; ++i) {
80103856:	31 d2                	xor    %edx,%edx
80103858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010385f:	90                   	nop
80103860:	83 c2 01             	add    $0x1,%edx
80103863:	39 f2                	cmp    %esi,%edx
80103865:	74 25                	je     8010388c <mycpu+0x5c>
    if (cpus[i].apicid == apicid)
80103867:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
8010386d:	0f b6 99 80 27 11 80 	movzbl -0x7feed880(%ecx),%ebx
80103874:	39 c3                	cmp    %eax,%ebx
80103876:	75 e8                	jne    80103860 <mycpu+0x30>
80103878:	8d 81 80 27 11 80    	lea    -0x7feed880(%ecx),%eax
}
8010387e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103881:	5b                   	pop    %ebx
80103882:	5e                   	pop    %esi
80103883:	5d                   	pop    %ebp
80103884:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103885:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
8010388a:	eb f2                	jmp    8010387e <mycpu+0x4e>
  panic("unknown apicid\n");
8010388c:	83 ec 0c             	sub    $0xc,%esp
8010388f:	68 3c 75 10 80       	push   $0x8010753c
80103894:	e8 f7 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103899:	83 ec 0c             	sub    $0xc,%esp
8010389c:	68 18 76 10 80       	push   $0x80107618
801038a1:	e8 ea ca ff ff       	call   80100390 <panic>
801038a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038ad:	8d 76 00             	lea    0x0(%esi),%esi

801038b0 <cpuid>:
cpuid() {
801038b0:	55                   	push   %ebp
801038b1:	89 e5                	mov    %esp,%ebp
801038b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801038b6:	e8 75 ff ff ff       	call   80103830 <mycpu>
}
801038bb:	c9                   	leave  
  return mycpu()-cpus;
801038bc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801038c1:	c1 f8 04             	sar    $0x4,%eax
801038c4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801038ca:	c3                   	ret    
801038cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038cf:	90                   	nop

801038d0 <myproc>:
myproc(void) {
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	53                   	push   %ebx
801038d4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801038d7:	e8 d4 0a 00 00       	call   801043b0 <pushcli>
  c = mycpu();
801038dc:	e8 4f ff ff ff       	call   80103830 <mycpu>
  p = c->proc;
801038e1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038e7:	e8 14 0b 00 00       	call   80104400 <popcli>
}
801038ec:	83 c4 04             	add    $0x4,%esp
801038ef:	89 d8                	mov    %ebx,%eax
801038f1:	5b                   	pop    %ebx
801038f2:	5d                   	pop    %ebp
801038f3:	c3                   	ret    
801038f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038ff:	90                   	nop

80103900 <userinit>:
{
80103900:	55                   	push   %ebp
80103901:	89 e5                	mov    %esp,%ebp
80103903:	53                   	push   %ebx
80103904:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103907:	e8 e4 fd ff ff       	call   801036f0 <allocproc>
8010390c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010390e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103913:	e8 28 34 00 00       	call   80106d40 <setupkvm>
80103918:	89 43 04             	mov    %eax,0x4(%ebx)
8010391b:	85 c0                	test   %eax,%eax
8010391d:	0f 84 bd 00 00 00    	je     801039e0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103923:	83 ec 04             	sub    $0x4,%esp
80103926:	68 2c 00 00 00       	push   $0x2c
8010392b:	68 60 a4 10 80       	push   $0x8010a460
80103930:	50                   	push   %eax
80103931:	e8 ea 30 00 00       	call   80106a20 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103936:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103939:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010393f:	6a 4c                	push   $0x4c
80103941:	6a 00                	push   $0x0
80103943:	ff 73 18             	pushl  0x18(%ebx)
80103946:	e8 65 0c 00 00       	call   801045b0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010394b:	8b 43 18             	mov    0x18(%ebx),%eax
8010394e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103953:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103956:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010395b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010395f:	8b 43 18             	mov    0x18(%ebx),%eax
80103962:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103966:	8b 43 18             	mov    0x18(%ebx),%eax
80103969:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010396d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103971:	8b 43 18             	mov    0x18(%ebx),%eax
80103974:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103978:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010397c:	8b 43 18             	mov    0x18(%ebx),%eax
8010397f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103986:	8b 43 18             	mov    0x18(%ebx),%eax
80103989:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103990:	8b 43 18             	mov    0x18(%ebx),%eax
80103993:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
8010399a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010399d:	6a 10                	push   $0x10
8010399f:	68 65 75 10 80       	push   $0x80107565
801039a4:	50                   	push   %eax
801039a5:	e8 d6 0d 00 00       	call   80104780 <safestrcpy>
  p->cwd = namei("/");
801039aa:	c7 04 24 6e 75 10 80 	movl   $0x8010756e,(%esp)
801039b1:	e8 fa e5 ff ff       	call   80101fb0 <namei>
801039b6:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801039b9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039c0:	e8 db 0a 00 00       	call   801044a0 <acquire>
  p->state = RUNNABLE;
801039c5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801039cc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039d3:	e8 88 0b 00 00       	call   80104560 <release>
}
801039d8:	83 c4 10             	add    $0x10,%esp
801039db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039de:	c9                   	leave  
801039df:	c3                   	ret    
    panic("userinit: out of memory?");
801039e0:	83 ec 0c             	sub    $0xc,%esp
801039e3:	68 4c 75 10 80       	push   $0x8010754c
801039e8:	e8 a3 c9 ff ff       	call   80100390 <panic>
801039ed:	8d 76 00             	lea    0x0(%esi),%esi

801039f0 <growproc>:
{
801039f0:	55                   	push   %ebp
801039f1:	89 e5                	mov    %esp,%ebp
801039f3:	56                   	push   %esi
801039f4:	53                   	push   %ebx
801039f5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
801039f8:	e8 b3 09 00 00       	call   801043b0 <pushcli>
  c = mycpu();
801039fd:	e8 2e fe ff ff       	call   80103830 <mycpu>
  p = c->proc;
80103a02:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a08:	e8 f3 09 00 00       	call   80104400 <popcli>
  sz = curproc->sz;
80103a0d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103a0f:	85 f6                	test   %esi,%esi
80103a11:	7f 1d                	jg     80103a30 <growproc+0x40>
  } else if(n < 0){
80103a13:	75 3b                	jne    80103a50 <growproc+0x60>
  switchuvm(curproc);
80103a15:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103a18:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103a1a:	53                   	push   %ebx
80103a1b:	e8 f0 2e 00 00       	call   80106910 <switchuvm>
  return 0;
80103a20:	83 c4 10             	add    $0x10,%esp
80103a23:	31 c0                	xor    %eax,%eax
}
80103a25:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a28:	5b                   	pop    %ebx
80103a29:	5e                   	pop    %esi
80103a2a:	5d                   	pop    %ebp
80103a2b:	c3                   	ret    
80103a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a30:	83 ec 04             	sub    $0x4,%esp
80103a33:	01 c6                	add    %eax,%esi
80103a35:	56                   	push   %esi
80103a36:	50                   	push   %eax
80103a37:	ff 73 04             	pushl  0x4(%ebx)
80103a3a:	e8 21 31 00 00       	call   80106b60 <allocuvm>
80103a3f:	83 c4 10             	add    $0x10,%esp
80103a42:	85 c0                	test   %eax,%eax
80103a44:	75 cf                	jne    80103a15 <growproc+0x25>
      return -1;
80103a46:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a4b:	eb d8                	jmp    80103a25 <growproc+0x35>
80103a4d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103a50:	83 ec 04             	sub    $0x4,%esp
80103a53:	01 c6                	add    %eax,%esi
80103a55:	56                   	push   %esi
80103a56:	50                   	push   %eax
80103a57:	ff 73 04             	pushl  0x4(%ebx)
80103a5a:	e8 31 32 00 00       	call   80106c90 <deallocuvm>
80103a5f:	83 c4 10             	add    $0x10,%esp
80103a62:	85 c0                	test   %eax,%eax
80103a64:	75 af                	jne    80103a15 <growproc+0x25>
80103a66:	eb de                	jmp    80103a46 <growproc+0x56>
80103a68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop

80103a70 <fork>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103a79:	e8 32 09 00 00       	call   801043b0 <pushcli>
  c = mycpu();
80103a7e:	e8 ad fd ff ff       	call   80103830 <mycpu>
  p = c->proc;
80103a83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a89:	e8 72 09 00 00       	call   80104400 <popcli>
  if((np = allocproc()) == 0){
80103a8e:	e8 5d fc ff ff       	call   801036f0 <allocproc>
80103a93:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103a96:	85 c0                	test   %eax,%eax
80103a98:	0f 84 b7 00 00 00    	je     80103b55 <fork+0xe5>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103a9e:	83 ec 08             	sub    $0x8,%esp
80103aa1:	ff 33                	pushl  (%ebx)
80103aa3:	89 c7                	mov    %eax,%edi
80103aa5:	ff 73 04             	pushl  0x4(%ebx)
80103aa8:	e8 63 33 00 00       	call   80106e10 <copyuvm>
80103aad:	83 c4 10             	add    $0x10,%esp
80103ab0:	89 47 04             	mov    %eax,0x4(%edi)
80103ab3:	85 c0                	test   %eax,%eax
80103ab5:	0f 84 a1 00 00 00    	je     80103b5c <fork+0xec>
  np->sz = curproc->sz;
80103abb:	8b 03                	mov    (%ebx),%eax
80103abd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ac0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ac2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ac5:	89 c8                	mov    %ecx,%eax
80103ac7:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103aca:	b9 13 00 00 00       	mov    $0x13,%ecx
80103acf:	8b 73 18             	mov    0x18(%ebx),%esi
80103ad2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103ad4:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103ad6:	8b 40 18             	mov    0x18(%eax),%eax
80103ad9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103ae0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	74 13                	je     80103afb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ae8:	83 ec 0c             	sub    $0xc,%esp
80103aeb:	50                   	push   %eax
80103aec:	e8 7f d3 ff ff       	call   80100e70 <filedup>
80103af1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103af4:	83 c4 10             	add    $0x10,%esp
80103af7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103afb:	83 c6 01             	add    $0x1,%esi
80103afe:	83 fe 10             	cmp    $0x10,%esi
80103b01:	75 dd                	jne    80103ae0 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103b03:	83 ec 0c             	sub    $0xc,%esp
80103b06:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b09:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103b0c:	e8 cf db ff ff       	call   801016e0 <idup>
80103b11:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b14:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103b17:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103b1a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103b1d:	6a 10                	push   $0x10
80103b1f:	53                   	push   %ebx
80103b20:	50                   	push   %eax
80103b21:	e8 5a 0c 00 00       	call   80104780 <safestrcpy>
  pid = np->pid;
80103b26:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103b29:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b30:	e8 6b 09 00 00       	call   801044a0 <acquire>
  np->state = RUNNABLE;
80103b35:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103b3c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b43:	e8 18 0a 00 00       	call   80104560 <release>
  return pid;
80103b48:	83 c4 10             	add    $0x10,%esp
}
80103b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b4e:	89 d8                	mov    %ebx,%eax
80103b50:	5b                   	pop    %ebx
80103b51:	5e                   	pop    %esi
80103b52:	5f                   	pop    %edi
80103b53:	5d                   	pop    %ebp
80103b54:	c3                   	ret    
    return -1;
80103b55:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b5a:	eb ef                	jmp    80103b4b <fork+0xdb>
    kfree(np->kstack);
80103b5c:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103b5f:	83 ec 0c             	sub    $0xc,%esp
80103b62:	ff 73 08             	pushl  0x8(%ebx)
80103b65:	e8 76 e8 ff ff       	call   801023e0 <kfree>
    np->kstack = 0;
80103b6a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103b71:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103b74:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103b7b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103b80:	eb c9                	jmp    80103b4b <fork+0xdb>
80103b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b90 <scheduler>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	57                   	push   %edi
80103b94:	56                   	push   %esi
80103b95:	53                   	push   %ebx
80103b96:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103b99:	e8 92 fc ff ff       	call   80103830 <mycpu>
  c->proc = 0;
80103b9e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103ba5:	00 00 00 
  struct cpu *c = mycpu();
80103ba8:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103baa:	8d 78 04             	lea    0x4(%eax),%edi
80103bad:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103bb0:	fb                   	sti    
    acquire(&ptable.lock);
80103bb1:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103bb4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103bb9:	68 20 2d 11 80       	push   $0x80112d20
80103bbe:	e8 dd 08 00 00       	call   801044a0 <acquire>
80103bc3:	83 c4 10             	add    $0x10,%esp
80103bc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103bd0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103bd4:	75 33                	jne    80103c09 <scheduler+0x79>
      switchuvm(p);
80103bd6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103bd9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103bdf:	53                   	push   %ebx
80103be0:	e8 2b 2d 00 00       	call   80106910 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103be5:	58                   	pop    %eax
80103be6:	5a                   	pop    %edx
80103be7:	ff 73 1c             	pushl  0x1c(%ebx)
80103bea:	57                   	push   %edi
      p->state = RUNNING;
80103beb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103bf2:	e8 e4 0b 00 00       	call   801047db <swtch>
      switchkvm();
80103bf7:	e8 04 2d 00 00       	call   80106900 <switchkvm>
      c->proc = 0;
80103bfc:	83 c4 10             	add    $0x10,%esp
80103bff:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103c06:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c09:	83 c3 7c             	add    $0x7c,%ebx
80103c0c:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103c12:	75 bc                	jne    80103bd0 <scheduler+0x40>
    release(&ptable.lock);
80103c14:	83 ec 0c             	sub    $0xc,%esp
80103c17:	68 20 2d 11 80       	push   $0x80112d20
80103c1c:	e8 3f 09 00 00       	call   80104560 <release>
    sti();
80103c21:	83 c4 10             	add    $0x10,%esp
80103c24:	eb 8a                	jmp    80103bb0 <scheduler+0x20>
80103c26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi

80103c30 <sched>:
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	56                   	push   %esi
80103c34:	53                   	push   %ebx
  pushcli();
80103c35:	e8 76 07 00 00       	call   801043b0 <pushcli>
  c = mycpu();
80103c3a:	e8 f1 fb ff ff       	call   80103830 <mycpu>
  p = c->proc;
80103c3f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c45:	e8 b6 07 00 00       	call   80104400 <popcli>
  if(!holding(&ptable.lock))
80103c4a:	83 ec 0c             	sub    $0xc,%esp
80103c4d:	68 20 2d 11 80       	push   $0x80112d20
80103c52:	e8 09 08 00 00       	call   80104460 <holding>
80103c57:	83 c4 10             	add    $0x10,%esp
80103c5a:	85 c0                	test   %eax,%eax
80103c5c:	74 4f                	je     80103cad <sched+0x7d>
  if(mycpu()->ncli != 1)
80103c5e:	e8 cd fb ff ff       	call   80103830 <mycpu>
80103c63:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103c6a:	75 68                	jne    80103cd4 <sched+0xa4>
  if(p->state == RUNNING)
80103c6c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103c70:	74 55                	je     80103cc7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c72:	9c                   	pushf  
80103c73:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c74:	f6 c4 02             	test   $0x2,%ah
80103c77:	75 41                	jne    80103cba <sched+0x8a>
  intena = mycpu()->intena;
80103c79:	e8 b2 fb ff ff       	call   80103830 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103c7e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103c81:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103c87:	e8 a4 fb ff ff       	call   80103830 <mycpu>
80103c8c:	83 ec 08             	sub    $0x8,%esp
80103c8f:	ff 70 04             	pushl  0x4(%eax)
80103c92:	53                   	push   %ebx
80103c93:	e8 43 0b 00 00       	call   801047db <swtch>
  mycpu()->intena = intena;
80103c98:	e8 93 fb ff ff       	call   80103830 <mycpu>
}
80103c9d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ca0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103ca6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ca9:	5b                   	pop    %ebx
80103caa:	5e                   	pop    %esi
80103cab:	5d                   	pop    %ebp
80103cac:	c3                   	ret    
    panic("sched ptable.lock");
80103cad:	83 ec 0c             	sub    $0xc,%esp
80103cb0:	68 70 75 10 80       	push   $0x80107570
80103cb5:	e8 d6 c6 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103cba:	83 ec 0c             	sub    $0xc,%esp
80103cbd:	68 9c 75 10 80       	push   $0x8010759c
80103cc2:	e8 c9 c6 ff ff       	call   80100390 <panic>
    panic("sched running");
80103cc7:	83 ec 0c             	sub    $0xc,%esp
80103cca:	68 8e 75 10 80       	push   $0x8010758e
80103ccf:	e8 bc c6 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103cd4:	83 ec 0c             	sub    $0xc,%esp
80103cd7:	68 82 75 10 80       	push   $0x80107582
80103cdc:	e8 af c6 ff ff       	call   80100390 <panic>
80103ce1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103cef:	90                   	nop

80103cf0 <exit>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103cf9:	e8 b2 06 00 00       	call   801043b0 <pushcli>
  c = mycpu();
80103cfe:	e8 2d fb ff ff       	call   80103830 <mycpu>
  p = c->proc;
80103d03:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103d09:	e8 f2 06 00 00       	call   80104400 <popcli>
  if(curproc == initproc)
80103d0e:	8d 5e 28             	lea    0x28(%esi),%ebx
80103d11:	8d 7e 68             	lea    0x68(%esi),%edi
80103d14:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80103d1a:	0f 84 e7 00 00 00    	je     80103e07 <exit+0x117>
    if(curproc->ofile[fd]){
80103d20:	8b 03                	mov    (%ebx),%eax
80103d22:	85 c0                	test   %eax,%eax
80103d24:	74 12                	je     80103d38 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103d26:	83 ec 0c             	sub    $0xc,%esp
80103d29:	50                   	push   %eax
80103d2a:	e8 91 d1 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80103d2f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103d35:	83 c4 10             	add    $0x10,%esp
80103d38:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103d3b:	39 df                	cmp    %ebx,%edi
80103d3d:	75 e1                	jne    80103d20 <exit+0x30>
  begin_op();
80103d3f:	e8 4c ef ff ff       	call   80102c90 <begin_op>
  iput(curproc->cwd);
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	ff 76 68             	pushl  0x68(%esi)
80103d4a:	e8 f1 da ff ff       	call   80101840 <iput>
  end_op();
80103d4f:	e8 ac ef ff ff       	call   80102d00 <end_op>
  curproc->cwd = 0;
80103d54:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103d5b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d62:	e8 39 07 00 00       	call   801044a0 <acquire>
  wakeup1(curproc->parent);
80103d67:	8b 56 14             	mov    0x14(%esi),%edx
80103d6a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d6d:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103d72:	eb 0e                	jmp    80103d82 <exit+0x92>
80103d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d78:	83 c0 7c             	add    $0x7c,%eax
80103d7b:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d80:	74 1c                	je     80103d9e <exit+0xae>
    if(p->state == SLEEPING && p->chan == chan)
80103d82:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103d86:	75 f0                	jne    80103d78 <exit+0x88>
80103d88:	3b 50 20             	cmp    0x20(%eax),%edx
80103d8b:	75 eb                	jne    80103d78 <exit+0x88>
      p->state = RUNNABLE;
80103d8d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103d94:	83 c0 7c             	add    $0x7c,%eax
80103d97:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103d9c:	75 e4                	jne    80103d82 <exit+0x92>
      p->parent = initproc;
80103d9e:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103da4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103da9:	eb 10                	jmp    80103dbb <exit+0xcb>
80103dab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103daf:	90                   	nop
80103db0:	83 c2 7c             	add    $0x7c,%edx
80103db3:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
80103db9:	74 33                	je     80103dee <exit+0xfe>
    if(p->parent == curproc){
80103dbb:	39 72 14             	cmp    %esi,0x14(%edx)
80103dbe:	75 f0                	jne    80103db0 <exit+0xc0>
      if(p->state == ZOMBIE)
80103dc0:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103dc4:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103dc7:	75 e7                	jne    80103db0 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103dc9:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103dce:	eb 0a                	jmp    80103dda <exit+0xea>
80103dd0:	83 c0 7c             	add    $0x7c,%eax
80103dd3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80103dd8:	74 d6                	je     80103db0 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103dda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103dde:	75 f0                	jne    80103dd0 <exit+0xe0>
80103de0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103de3:	75 eb                	jne    80103dd0 <exit+0xe0>
      p->state = RUNNABLE;
80103de5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103dec:	eb e2                	jmp    80103dd0 <exit+0xe0>
  curproc->state = ZOMBIE;
80103dee:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80103df5:	e8 36 fe ff ff       	call   80103c30 <sched>
  panic("zombie exit");
80103dfa:	83 ec 0c             	sub    $0xc,%esp
80103dfd:	68 bd 75 10 80       	push   $0x801075bd
80103e02:	e8 89 c5 ff ff       	call   80100390 <panic>
    panic("init exiting");
80103e07:	83 ec 0c             	sub    $0xc,%esp
80103e0a:	68 b0 75 10 80       	push   $0x801075b0
80103e0f:	e8 7c c5 ff ff       	call   80100390 <panic>
80103e14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e1f:	90                   	nop

80103e20 <yield>:
{
80103e20:	55                   	push   %ebp
80103e21:	89 e5                	mov    %esp,%ebp
80103e23:	53                   	push   %ebx
80103e24:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103e27:	68 20 2d 11 80       	push   $0x80112d20
80103e2c:	e8 6f 06 00 00       	call   801044a0 <acquire>
  pushcli();
80103e31:	e8 7a 05 00 00       	call   801043b0 <pushcli>
  c = mycpu();
80103e36:	e8 f5 f9 ff ff       	call   80103830 <mycpu>
  p = c->proc;
80103e3b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e41:	e8 ba 05 00 00       	call   80104400 <popcli>
  myproc()->state = RUNNABLE;
80103e46:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80103e4d:	e8 de fd ff ff       	call   80103c30 <sched>
  release(&ptable.lock);
80103e52:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e59:	e8 02 07 00 00       	call   80104560 <release>
}
80103e5e:	83 c4 10             	add    $0x10,%esp
80103e61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103e64:	c9                   	leave  
80103e65:	c3                   	ret    
80103e66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi

80103e70 <sleep>:
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	57                   	push   %edi
80103e74:	56                   	push   %esi
80103e75:	53                   	push   %ebx
80103e76:	83 ec 0c             	sub    $0xc,%esp
80103e79:	8b 7d 08             	mov    0x8(%ebp),%edi
80103e7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80103e7f:	e8 2c 05 00 00       	call   801043b0 <pushcli>
  c = mycpu();
80103e84:	e8 a7 f9 ff ff       	call   80103830 <mycpu>
  p = c->proc;
80103e89:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e8f:	e8 6c 05 00 00       	call   80104400 <popcli>
  if(p == 0)
80103e94:	85 db                	test   %ebx,%ebx
80103e96:	0f 84 87 00 00 00    	je     80103f23 <sleep+0xb3>
  if(lk == 0)
80103e9c:	85 f6                	test   %esi,%esi
80103e9e:	74 76                	je     80103f16 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103ea0:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103ea6:	74 50                	je     80103ef8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103ea8:	83 ec 0c             	sub    $0xc,%esp
80103eab:	68 20 2d 11 80       	push   $0x80112d20
80103eb0:	e8 eb 05 00 00       	call   801044a0 <acquire>
    release(lk);
80103eb5:	89 34 24             	mov    %esi,(%esp)
80103eb8:	e8 a3 06 00 00       	call   80104560 <release>
  p->chan = chan;
80103ebd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103ec0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103ec7:	e8 64 fd ff ff       	call   80103c30 <sched>
  p->chan = 0;
80103ecc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103ed3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eda:	e8 81 06 00 00       	call   80104560 <release>
    acquire(lk);
80103edf:	89 75 08             	mov    %esi,0x8(%ebp)
80103ee2:	83 c4 10             	add    $0x10,%esp
}
80103ee5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ee8:	5b                   	pop    %ebx
80103ee9:	5e                   	pop    %esi
80103eea:	5f                   	pop    %edi
80103eeb:	5d                   	pop    %ebp
    acquire(lk);
80103eec:	e9 af 05 00 00       	jmp    801044a0 <acquire>
80103ef1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80103ef8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103efb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103f02:	e8 29 fd ff ff       	call   80103c30 <sched>
  p->chan = 0;
80103f07:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103f0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f11:	5b                   	pop    %ebx
80103f12:	5e                   	pop    %esi
80103f13:	5f                   	pop    %edi
80103f14:	5d                   	pop    %ebp
80103f15:	c3                   	ret    
    panic("sleep without lk");
80103f16:	83 ec 0c             	sub    $0xc,%esp
80103f19:	68 cf 75 10 80       	push   $0x801075cf
80103f1e:	e8 6d c4 ff ff       	call   80100390 <panic>
    panic("sleep");
80103f23:	83 ec 0c             	sub    $0xc,%esp
80103f26:	68 c9 75 10 80       	push   $0x801075c9
80103f2b:	e8 60 c4 ff ff       	call   80100390 <panic>

80103f30 <wait>:
{
80103f30:	55                   	push   %ebp
80103f31:	89 e5                	mov    %esp,%ebp
80103f33:	56                   	push   %esi
80103f34:	53                   	push   %ebx
  pushcli();
80103f35:	e8 76 04 00 00       	call   801043b0 <pushcli>
  c = mycpu();
80103f3a:	e8 f1 f8 ff ff       	call   80103830 <mycpu>
  p = c->proc;
80103f3f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f45:	e8 b6 04 00 00       	call   80104400 <popcli>
  acquire(&ptable.lock);
80103f4a:	83 ec 0c             	sub    $0xc,%esp
80103f4d:	68 20 2d 11 80       	push   $0x80112d20
80103f52:	e8 49 05 00 00       	call   801044a0 <acquire>
80103f57:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103f5a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f5c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103f61:	eb 10                	jmp    80103f73 <wait+0x43>
80103f63:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f67:	90                   	nop
80103f68:	83 c3 7c             	add    $0x7c,%ebx
80103f6b:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f71:	74 1b                	je     80103f8e <wait+0x5e>
      if(p->parent != curproc)
80103f73:	39 73 14             	cmp    %esi,0x14(%ebx)
80103f76:	75 f0                	jne    80103f68 <wait+0x38>
      if(p->state == ZOMBIE){
80103f78:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103f7c:	74 32                	je     80103fb0 <wait+0x80>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7e:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103f81:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f86:	81 fb 54 4c 11 80    	cmp    $0x80114c54,%ebx
80103f8c:	75 e5                	jne    80103f73 <wait+0x43>
    if(!havekids || curproc->killed){
80103f8e:	85 c0                	test   %eax,%eax
80103f90:	74 74                	je     80104006 <wait+0xd6>
80103f92:	8b 46 24             	mov    0x24(%esi),%eax
80103f95:	85 c0                	test   %eax,%eax
80103f97:	75 6d                	jne    80104006 <wait+0xd6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103f99:	83 ec 08             	sub    $0x8,%esp
80103f9c:	68 20 2d 11 80       	push   $0x80112d20
80103fa1:	56                   	push   %esi
80103fa2:	e8 c9 fe ff ff       	call   80103e70 <sleep>
    havekids = 0;
80103fa7:	83 c4 10             	add    $0x10,%esp
80103faa:	eb ae                	jmp    80103f5a <wait+0x2a>
80103fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80103fb0:	83 ec 0c             	sub    $0xc,%esp
80103fb3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80103fb6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103fb9:	e8 22 e4 ff ff       	call   801023e0 <kfree>
        freevm(p->pgdir);
80103fbe:	5a                   	pop    %edx
80103fbf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80103fc2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103fc9:	e8 f2 2c 00 00       	call   80106cc0 <freevm>
        release(&ptable.lock);
80103fce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103fd5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103fdc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103fe3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103fe7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103fee:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103ff5:	e8 66 05 00 00       	call   80104560 <release>
        return pid;
80103ffa:	83 c4 10             	add    $0x10,%esp
}
80103ffd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104000:	89 f0                	mov    %esi,%eax
80104002:	5b                   	pop    %ebx
80104003:	5e                   	pop    %esi
80104004:	5d                   	pop    %ebp
80104005:	c3                   	ret    
      release(&ptable.lock);
80104006:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104009:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010400e:	68 20 2d 11 80       	push   $0x80112d20
80104013:	e8 48 05 00 00       	call   80104560 <release>
      return -1;
80104018:	83 c4 10             	add    $0x10,%esp
8010401b:	eb e0                	jmp    80103ffd <wait+0xcd>
8010401d:	8d 76 00             	lea    0x0(%esi),%esi

80104020 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104020:	55                   	push   %ebp
80104021:	89 e5                	mov    %esp,%ebp
80104023:	53                   	push   %ebx
80104024:	83 ec 10             	sub    $0x10,%esp
80104027:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010402a:	68 20 2d 11 80       	push   $0x80112d20
8010402f:	e8 6c 04 00 00       	call   801044a0 <acquire>
80104034:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104037:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010403c:	eb 0c                	jmp    8010404a <wakeup+0x2a>
8010403e:	66 90                	xchg   %ax,%ax
80104040:	83 c0 7c             	add    $0x7c,%eax
80104043:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104048:	74 1c                	je     80104066 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010404a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010404e:	75 f0                	jne    80104040 <wakeup+0x20>
80104050:	3b 58 20             	cmp    0x20(%eax),%ebx
80104053:	75 eb                	jne    80104040 <wakeup+0x20>
      p->state = RUNNABLE;
80104055:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010405c:	83 c0 7c             	add    $0x7c,%eax
8010405f:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
80104064:	75 e4                	jne    8010404a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104066:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010406d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104070:	c9                   	leave  
  release(&ptable.lock);
80104071:	e9 ea 04 00 00       	jmp    80104560 <release>
80104076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010407d:	8d 76 00             	lea    0x0(%esi),%esi

80104080 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	53                   	push   %ebx
80104084:	83 ec 10             	sub    $0x10,%esp
80104087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010408a:	68 20 2d 11 80       	push   $0x80112d20
8010408f:	e8 0c 04 00 00       	call   801044a0 <acquire>
80104094:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104097:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010409c:	eb 0c                	jmp    801040aa <kill+0x2a>
8010409e:	66 90                	xchg   %ax,%ax
801040a0:	83 c0 7c             	add    $0x7c,%eax
801040a3:	3d 54 4c 11 80       	cmp    $0x80114c54,%eax
801040a8:	74 36                	je     801040e0 <kill+0x60>
    if(p->pid == pid){
801040aa:	39 58 10             	cmp    %ebx,0x10(%eax)
801040ad:	75 f1                	jne    801040a0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801040af:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801040b3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801040ba:	75 07                	jne    801040c3 <kill+0x43>
        p->state = RUNNABLE;
801040bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801040c3:	83 ec 0c             	sub    $0xc,%esp
801040c6:	68 20 2d 11 80       	push   $0x80112d20
801040cb:	e8 90 04 00 00       	call   80104560 <release>
      return 0;
801040d0:	83 c4 10             	add    $0x10,%esp
801040d3:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801040d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040d8:	c9                   	leave  
801040d9:	c3                   	ret    
801040da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801040e0:	83 ec 0c             	sub    $0xc,%esp
801040e3:	68 20 2d 11 80       	push   $0x80112d20
801040e8:	e8 73 04 00 00       	call   80104560 <release>
  return -1;
801040ed:	83 c4 10             	add    $0x10,%esp
801040f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f8:	c9                   	leave  
801040f9:	c3                   	ret    
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104100 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104108:	53                   	push   %ebx
80104109:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010410e:	83 ec 3c             	sub    $0x3c,%esp
80104111:	eb 24                	jmp    80104137 <procdump+0x37>
80104113:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104117:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104118:	83 ec 0c             	sub    $0xc,%esp
8010411b:	68 5f 79 10 80       	push   $0x8010795f
80104120:	e8 8b c5 ff ff       	call   801006b0 <cprintf>
80104125:	83 c4 10             	add    $0x10,%esp
80104128:	83 c3 7c             	add    $0x7c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010412b:	81 fb c0 4c 11 80    	cmp    $0x80114cc0,%ebx
80104131:	0f 84 81 00 00 00    	je     801041b8 <procdump+0xb8>
    if(p->state == UNUSED)
80104137:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010413a:	85 c0                	test   %eax,%eax
8010413c:	74 ea                	je     80104128 <procdump+0x28>
      state = "???";
8010413e:	ba e0 75 10 80       	mov    $0x801075e0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104143:	83 f8 05             	cmp    $0x5,%eax
80104146:	77 11                	ja     80104159 <procdump+0x59>
80104148:	8b 14 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%edx
      state = "???";
8010414f:	b8 e0 75 10 80       	mov    $0x801075e0,%eax
80104154:	85 d2                	test   %edx,%edx
80104156:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104159:	53                   	push   %ebx
8010415a:	52                   	push   %edx
8010415b:	ff 73 a4             	pushl  -0x5c(%ebx)
8010415e:	68 e4 75 10 80       	push   $0x801075e4
80104163:	e8 48 c5 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104168:	83 c4 10             	add    $0x10,%esp
8010416b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010416f:	75 a7                	jne    80104118 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104171:	83 ec 08             	sub    $0x8,%esp
80104174:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104177:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010417a:	50                   	push   %eax
8010417b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010417e:	8b 40 0c             	mov    0xc(%eax),%eax
80104181:	83 c0 08             	add    $0x8,%eax
80104184:	50                   	push   %eax
80104185:	e8 d6 01 00 00       	call   80104360 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010418a:	83 c4 10             	add    $0x10,%esp
8010418d:	8d 76 00             	lea    0x0(%esi),%esi
80104190:	8b 17                	mov    (%edi),%edx
80104192:	85 d2                	test   %edx,%edx
80104194:	74 82                	je     80104118 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104196:	83 ec 08             	sub    $0x8,%esp
80104199:	83 c7 04             	add    $0x4,%edi
8010419c:	52                   	push   %edx
8010419d:	68 21 70 10 80       	push   $0x80107021
801041a2:	e8 09 c5 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801041a7:	83 c4 10             	add    $0x10,%esp
801041aa:	39 fe                	cmp    %edi,%esi
801041ac:	75 e2                	jne    80104190 <procdump+0x90>
801041ae:	e9 65 ff ff ff       	jmp    80104118 <procdump+0x18>
801041b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b7:	90                   	nop
  }
}
801041b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041bb:	5b                   	pop    %ebx
801041bc:	5e                   	pop    %esi
801041bd:	5f                   	pop    %edi
801041be:	5d                   	pop    %ebp
801041bf:	c3                   	ret    

801041c0 <getChild>:


//int processID
//getting children's id of a process
int
getChild(int processID){
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int a = 0,childID;

  struct proc *p;
  acquire(&ptable.lock);
801041ca:	68 20 2d 11 80       	push   $0x80112d20
801041cf:	e8 cc 02 00 00       	call   801044a0 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC];p++){
801041d7:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
  int a = 0,childID;
801041dc:	31 c0                	xor    %eax,%eax
801041de:	66 90                	xchg   %ax,%ax
    if(p-> parent -> pid == processID){
801041e0:	8b 4a 14             	mov    0x14(%edx),%ecx
801041e3:	39 59 10             	cmp    %ebx,0x10(%ecx)
801041e6:	75 06                	jne    801041ee <getChild+0x2e>
    childID = p->pid;
    a = a*100 + childID ;
801041e8:	6b c0 64             	imul   $0x64,%eax,%eax
801041eb:	03 42 10             	add    0x10(%edx),%eax
  for(p = ptable.proc; p < &ptable.proc[NPROC];p++){
801041ee:	83 c2 7c             	add    $0x7c,%edx
801041f1:	81 fa 54 4c 11 80    	cmp    $0x80114c54,%edx
801041f7:	75 e7                	jne    801041e0 <getChild+0x20>
  }	
  }
  return a;
}
801041f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041fc:	c9                   	leave  
801041fd:	c3                   	ret    
801041fe:	66 90                	xchg   %ax,%ax

80104200 <getCount>:
int
getCount(int a)
{
/////////////////////////codes lots of codes:)
return 23;
}
80104200:	b8 17 00 00 00       	mov    $0x17,%eax
80104205:	c3                   	ret    
80104206:	66 90                	xchg   %ax,%ax
80104208:	66 90                	xchg   %ax,%ax
8010420a:	66 90                	xchg   %ax,%ax
8010420c:	66 90                	xchg   %ax,%ax
8010420e:	66 90                	xchg   %ax,%ax

80104210 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
80104214:	83 ec 0c             	sub    $0xc,%esp
80104217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010421a:	68 58 76 10 80       	push   $0x80107658
8010421f:	8d 43 04             	lea    0x4(%ebx),%eax
80104222:	50                   	push   %eax
80104223:	e8 18 01 00 00       	call   80104340 <initlock>
  lk->name = name;
80104228:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010422b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104231:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104234:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010423b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010423e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104241:	c9                   	leave  
80104242:	c3                   	ret    
80104243:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104250 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	56                   	push   %esi
80104254:	53                   	push   %ebx
80104255:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104258:	8d 73 04             	lea    0x4(%ebx),%esi
8010425b:	83 ec 0c             	sub    $0xc,%esp
8010425e:	56                   	push   %esi
8010425f:	e8 3c 02 00 00       	call   801044a0 <acquire>
  while (lk->locked) {
80104264:	8b 13                	mov    (%ebx),%edx
80104266:	83 c4 10             	add    $0x10,%esp
80104269:	85 d2                	test   %edx,%edx
8010426b:	74 16                	je     80104283 <acquiresleep+0x33>
8010426d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104270:	83 ec 08             	sub    $0x8,%esp
80104273:	56                   	push   %esi
80104274:	53                   	push   %ebx
80104275:	e8 f6 fb ff ff       	call   80103e70 <sleep>
  while (lk->locked) {
8010427a:	8b 03                	mov    (%ebx),%eax
8010427c:	83 c4 10             	add    $0x10,%esp
8010427f:	85 c0                	test   %eax,%eax
80104281:	75 ed                	jne    80104270 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104283:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104289:	e8 42 f6 ff ff       	call   801038d0 <myproc>
8010428e:	8b 40 10             	mov    0x10(%eax),%eax
80104291:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104294:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104297:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010429a:	5b                   	pop    %ebx
8010429b:	5e                   	pop    %esi
8010429c:	5d                   	pop    %ebp
  release(&lk->lk);
8010429d:	e9 be 02 00 00       	jmp    80104560 <release>
801042a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801042a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	56                   	push   %esi
801042b4:	53                   	push   %ebx
801042b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801042b8:	8d 73 04             	lea    0x4(%ebx),%esi
801042bb:	83 ec 0c             	sub    $0xc,%esp
801042be:	56                   	push   %esi
801042bf:	e8 dc 01 00 00       	call   801044a0 <acquire>
  lk->locked = 0;
801042c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801042ca:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801042d1:	89 1c 24             	mov    %ebx,(%esp)
801042d4:	e8 47 fd ff ff       	call   80104020 <wakeup>
  release(&lk->lk);
801042d9:	89 75 08             	mov    %esi,0x8(%ebp)
801042dc:	83 c4 10             	add    $0x10,%esp
}
801042df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042e2:	5b                   	pop    %ebx
801042e3:	5e                   	pop    %esi
801042e4:	5d                   	pop    %ebp
  release(&lk->lk);
801042e5:	e9 76 02 00 00       	jmp    80104560 <release>
801042ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	57                   	push   %edi
801042f4:	31 ff                	xor    %edi,%edi
801042f6:	56                   	push   %esi
801042f7:	53                   	push   %ebx
801042f8:	83 ec 18             	sub    $0x18,%esp
801042fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801042fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104301:	56                   	push   %esi
80104302:	e8 99 01 00 00       	call   801044a0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104307:	8b 03                	mov    (%ebx),%eax
80104309:	83 c4 10             	add    $0x10,%esp
8010430c:	85 c0                	test   %eax,%eax
8010430e:	75 18                	jne    80104328 <holdingsleep+0x38>
  release(&lk->lk);
80104310:	83 ec 0c             	sub    $0xc,%esp
80104313:	56                   	push   %esi
80104314:	e8 47 02 00 00       	call   80104560 <release>
  return r;
}
80104319:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010431c:	89 f8                	mov    %edi,%eax
8010431e:	5b                   	pop    %ebx
8010431f:	5e                   	pop    %esi
80104320:	5f                   	pop    %edi
80104321:	5d                   	pop    %ebp
80104322:	c3                   	ret    
80104323:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104327:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104328:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010432b:	e8 a0 f5 ff ff       	call   801038d0 <myproc>
80104330:	39 58 10             	cmp    %ebx,0x10(%eax)
80104333:	0f 94 c0             	sete   %al
80104336:	0f b6 c0             	movzbl %al,%eax
80104339:	89 c7                	mov    %eax,%edi
8010433b:	eb d3                	jmp    80104310 <holdingsleep+0x20>
8010433d:	66 90                	xchg   %ax,%ax
8010433f:	90                   	nop

80104340 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104346:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104349:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010434f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104352:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104359:	5d                   	pop    %ebp
8010435a:	c3                   	ret    
8010435b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010435f:	90                   	nop

80104360 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104360:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104361:	31 d2                	xor    %edx,%edx
{
80104363:	89 e5                	mov    %esp,%ebp
80104365:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104366:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104369:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010436c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010436f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104370:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104376:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010437c:	77 1a                	ja     80104398 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010437e:	8b 58 04             	mov    0x4(%eax),%ebx
80104381:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104384:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104387:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104389:	83 fa 0a             	cmp    $0xa,%edx
8010438c:	75 e2                	jne    80104370 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010438e:	5b                   	pop    %ebx
8010438f:	5d                   	pop    %ebp
80104390:	c3                   	ret    
80104391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104398:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010439b:	8d 51 28             	lea    0x28(%ecx),%edx
8010439e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801043a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801043a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801043a9:	39 d0                	cmp    %edx,%eax
801043ab:	75 f3                	jne    801043a0 <getcallerpcs+0x40>
}
801043ad:	5b                   	pop    %ebx
801043ae:	5d                   	pop    %ebp
801043af:	c3                   	ret    

801043b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 04             	sub    $0x4,%esp
801043b7:	9c                   	pushf  
801043b8:	5b                   	pop    %ebx
  asm volatile("cli");
801043b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801043ba:	e8 71 f4 ff ff       	call   80103830 <mycpu>
801043bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801043c5:	85 c0                	test   %eax,%eax
801043c7:	74 17                	je     801043e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801043c9:	e8 62 f4 ff ff       	call   80103830 <mycpu>
801043ce:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801043d5:	83 c4 04             	add    $0x4,%esp
801043d8:	5b                   	pop    %ebx
801043d9:	5d                   	pop    %ebp
801043da:	c3                   	ret    
801043db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043df:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
801043e0:	e8 4b f4 ff ff       	call   80103830 <mycpu>
801043e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801043eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801043f1:	eb d6                	jmp    801043c9 <pushcli+0x19>
801043f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <popcli>:

void
popcli(void)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104406:	9c                   	pushf  
80104407:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104408:	f6 c4 02             	test   $0x2,%ah
8010440b:	75 35                	jne    80104442 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010440d:	e8 1e f4 ff ff       	call   80103830 <mycpu>
80104412:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104419:	78 34                	js     8010444f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010441b:	e8 10 f4 ff ff       	call   80103830 <mycpu>
80104420:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104426:	85 d2                	test   %edx,%edx
80104428:	74 06                	je     80104430 <popcli+0x30>
    sti();
}
8010442a:	c9                   	leave  
8010442b:	c3                   	ret    
8010442c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104430:	e8 fb f3 ff ff       	call   80103830 <mycpu>
80104435:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010443b:	85 c0                	test   %eax,%eax
8010443d:	74 eb                	je     8010442a <popcli+0x2a>
  asm volatile("sti");
8010443f:	fb                   	sti    
}
80104440:	c9                   	leave  
80104441:	c3                   	ret    
    panic("popcli - interruptible");
80104442:	83 ec 0c             	sub    $0xc,%esp
80104445:	68 63 76 10 80       	push   $0x80107663
8010444a:	e8 41 bf ff ff       	call   80100390 <panic>
    panic("popcli");
8010444f:	83 ec 0c             	sub    $0xc,%esp
80104452:	68 7a 76 10 80       	push   $0x8010767a
80104457:	e8 34 bf ff ff       	call   80100390 <panic>
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104460 <holding>:
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	56                   	push   %esi
80104464:	53                   	push   %ebx
80104465:	8b 75 08             	mov    0x8(%ebp),%esi
80104468:	31 db                	xor    %ebx,%ebx
  pushcli();
8010446a:	e8 41 ff ff ff       	call   801043b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010446f:	8b 06                	mov    (%esi),%eax
80104471:	85 c0                	test   %eax,%eax
80104473:	75 0b                	jne    80104480 <holding+0x20>
  popcli();
80104475:	e8 86 ff ff ff       	call   80104400 <popcli>
}
8010447a:	89 d8                	mov    %ebx,%eax
8010447c:	5b                   	pop    %ebx
8010447d:	5e                   	pop    %esi
8010447e:	5d                   	pop    %ebp
8010447f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104480:	8b 5e 08             	mov    0x8(%esi),%ebx
80104483:	e8 a8 f3 ff ff       	call   80103830 <mycpu>
80104488:	39 c3                	cmp    %eax,%ebx
8010448a:	0f 94 c3             	sete   %bl
  popcli();
8010448d:	e8 6e ff ff ff       	call   80104400 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104492:	0f b6 db             	movzbl %bl,%ebx
}
80104495:	89 d8                	mov    %ebx,%eax
80104497:	5b                   	pop    %ebx
80104498:	5e                   	pop    %esi
80104499:	5d                   	pop    %ebp
8010449a:	c3                   	ret    
8010449b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010449f:	90                   	nop

801044a0 <acquire>:
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
801044a5:	e8 06 ff ff ff       	call   801043b0 <pushcli>
  if(holding(lk))
801044aa:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044ad:	83 ec 0c             	sub    $0xc,%esp
801044b0:	53                   	push   %ebx
801044b1:	e8 aa ff ff ff       	call   80104460 <holding>
801044b6:	83 c4 10             	add    $0x10,%esp
801044b9:	85 c0                	test   %eax,%eax
801044bb:	0f 85 83 00 00 00    	jne    80104544 <acquire+0xa4>
801044c1:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
801044c3:	ba 01 00 00 00       	mov    $0x1,%edx
801044c8:	eb 09                	jmp    801044d3 <acquire+0x33>
801044ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044d3:	89 d0                	mov    %edx,%eax
801044d5:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
801044d8:	85 c0                	test   %eax,%eax
801044da:	75 f4                	jne    801044d0 <acquire+0x30>
  __sync_synchronize();
801044dc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801044e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801044e4:	e8 47 f3 ff ff       	call   80103830 <mycpu>
801044e9:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801044ec:	89 e8                	mov    %ebp,%eax
801044ee:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044f0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801044f6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
801044fc:	77 22                	ja     80104520 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801044fe:	8b 50 04             	mov    0x4(%eax),%edx
80104501:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104505:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104508:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010450a:	83 fe 0a             	cmp    $0xa,%esi
8010450d:	75 e1                	jne    801044f0 <acquire+0x50>
}
8010450f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104512:	5b                   	pop    %ebx
80104513:	5e                   	pop    %esi
80104514:	5d                   	pop    %ebp
80104515:	c3                   	ret    
80104516:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
80104520:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104524:	83 c3 34             	add    $0x34,%ebx
80104527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104530:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104536:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104539:	39 d8                	cmp    %ebx,%eax
8010453b:	75 f3                	jne    80104530 <acquire+0x90>
}
8010453d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104540:	5b                   	pop    %ebx
80104541:	5e                   	pop    %esi
80104542:	5d                   	pop    %ebp
80104543:	c3                   	ret    
    panic("acquire");
80104544:	83 ec 0c             	sub    $0xc,%esp
80104547:	68 81 76 10 80       	push   $0x80107681
8010454c:	e8 3f be ff ff       	call   80100390 <panic>
80104551:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455f:	90                   	nop

80104560 <release>:
{
80104560:	55                   	push   %ebp
80104561:	89 e5                	mov    %esp,%ebp
80104563:	53                   	push   %ebx
80104564:	83 ec 10             	sub    $0x10,%esp
80104567:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010456a:	53                   	push   %ebx
8010456b:	e8 f0 fe ff ff       	call   80104460 <holding>
80104570:	83 c4 10             	add    $0x10,%esp
80104573:	85 c0                	test   %eax,%eax
80104575:	74 22                	je     80104599 <release+0x39>
  lk->pcs[0] = 0;
80104577:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010457e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104585:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010458a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104590:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104593:	c9                   	leave  
  popcli();
80104594:	e9 67 fe ff ff       	jmp    80104400 <popcli>
    panic("release");
80104599:	83 ec 0c             	sub    $0xc,%esp
8010459c:	68 89 76 10 80       	push   $0x80107689
801045a1:	e8 ea bd ff ff       	call   80100390 <panic>
801045a6:	66 90                	xchg   %ax,%ax
801045a8:	66 90                	xchg   %ax,%ax
801045aa:	66 90                	xchg   %ax,%ax
801045ac:	66 90                	xchg   %ax,%ax
801045ae:	66 90                	xchg   %ax,%ax

801045b0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	57                   	push   %edi
801045b4:	8b 55 08             	mov    0x8(%ebp),%edx
801045b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801045ba:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801045bb:	89 d0                	mov    %edx,%eax
801045bd:	09 c8                	or     %ecx,%eax
801045bf:	a8 03                	test   $0x3,%al
801045c1:	75 2d                	jne    801045f0 <memset+0x40>
    c &= 0xFF;
801045c3:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801045c7:	c1 e9 02             	shr    $0x2,%ecx
801045ca:	89 f8                	mov    %edi,%eax
801045cc:	89 fb                	mov    %edi,%ebx
801045ce:	c1 e0 18             	shl    $0x18,%eax
801045d1:	c1 e3 10             	shl    $0x10,%ebx
801045d4:	09 d8                	or     %ebx,%eax
801045d6:	09 f8                	or     %edi,%eax
801045d8:	c1 e7 08             	shl    $0x8,%edi
801045db:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801045dd:	89 d7                	mov    %edx,%edi
801045df:	fc                   	cld    
801045e0:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801045e2:	5b                   	pop    %ebx
801045e3:	89 d0                	mov    %edx,%eax
801045e5:	5f                   	pop    %edi
801045e6:	5d                   	pop    %ebp
801045e7:	c3                   	ret    
801045e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ef:	90                   	nop
  asm volatile("cld; rep stosb" :
801045f0:	89 d7                	mov    %edx,%edi
801045f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801045f5:	fc                   	cld    
801045f6:	f3 aa                	rep stos %al,%es:(%edi)
801045f8:	5b                   	pop    %ebx
801045f9:	89 d0                	mov    %edx,%eax
801045fb:	5f                   	pop    %edi
801045fc:	5d                   	pop    %ebp
801045fd:	c3                   	ret    
801045fe:	66 90                	xchg   %ax,%ax

80104600 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	56                   	push   %esi
80104604:	8b 75 10             	mov    0x10(%ebp),%esi
80104607:	8b 45 08             	mov    0x8(%ebp),%eax
8010460a:	53                   	push   %ebx
8010460b:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010460e:	85 f6                	test   %esi,%esi
80104610:	74 22                	je     80104634 <memcmp+0x34>
    if(*s1 != *s2)
80104612:	0f b6 08             	movzbl (%eax),%ecx
80104615:	0f b6 1a             	movzbl (%edx),%ebx
80104618:	01 c6                	add    %eax,%esi
8010461a:	38 cb                	cmp    %cl,%bl
8010461c:	74 0c                	je     8010462a <memcmp+0x2a>
8010461e:	eb 20                	jmp    80104640 <memcmp+0x40>
80104620:	0f b6 08             	movzbl (%eax),%ecx
80104623:	0f b6 1a             	movzbl (%edx),%ebx
80104626:	38 d9                	cmp    %bl,%cl
80104628:	75 16                	jne    80104640 <memcmp+0x40>
      return *s1 - *s2;
    s1++, s2++;
8010462a:	83 c0 01             	add    $0x1,%eax
8010462d:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104630:	39 c6                	cmp    %eax,%esi
80104632:	75 ec                	jne    80104620 <memcmp+0x20>
  }

  return 0;
}
80104634:	5b                   	pop    %ebx
  return 0;
80104635:	31 c0                	xor    %eax,%eax
}
80104637:	5e                   	pop    %esi
80104638:	5d                   	pop    %ebp
80104639:	c3                   	ret    
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return *s1 - *s2;
80104640:	0f b6 c1             	movzbl %cl,%eax
80104643:	29 d8                	sub    %ebx,%eax
}
80104645:	5b                   	pop    %ebx
80104646:	5e                   	pop    %esi
80104647:	5d                   	pop    %ebp
80104648:	c3                   	ret    
80104649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104650 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	57                   	push   %edi
80104654:	8b 45 08             	mov    0x8(%ebp),%eax
80104657:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010465a:	56                   	push   %esi
8010465b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010465e:	39 c6                	cmp    %eax,%esi
80104660:	73 26                	jae    80104688 <memmove+0x38>
80104662:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104665:	39 f8                	cmp    %edi,%eax
80104667:	73 1f                	jae    80104688 <memmove+0x38>
80104669:	8d 51 ff             	lea    -0x1(%ecx),%edx
    s += n;
    d += n;
    while(n-- > 0)
8010466c:	85 c9                	test   %ecx,%ecx
8010466e:	74 0f                	je     8010467f <memmove+0x2f>
      *--d = *--s;
80104670:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104674:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104677:	83 ea 01             	sub    $0x1,%edx
8010467a:	83 fa ff             	cmp    $0xffffffff,%edx
8010467d:	75 f1                	jne    80104670 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010467f:	5e                   	pop    %esi
80104680:	5f                   	pop    %edi
80104681:	5d                   	pop    %ebp
80104682:	c3                   	ret    
80104683:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104687:	90                   	nop
80104688:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
    while(n-- > 0)
8010468b:	89 c7                	mov    %eax,%edi
8010468d:	85 c9                	test   %ecx,%ecx
8010468f:	74 ee                	je     8010467f <memmove+0x2f>
80104691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104698:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104699:	39 d6                	cmp    %edx,%esi
8010469b:	75 fb                	jne    80104698 <memmove+0x48>
}
8010469d:	5e                   	pop    %esi
8010469e:	5f                   	pop    %edi
8010469f:	5d                   	pop    %ebp
801046a0:	c3                   	ret    
801046a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046af:	90                   	nop

801046b0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
801046b0:	eb 9e                	jmp    80104650 <memmove>
801046b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046c0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	57                   	push   %edi
801046c4:	8b 7d 10             	mov    0x10(%ebp),%edi
801046c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
801046ca:	56                   	push   %esi
801046cb:	8b 75 0c             	mov    0xc(%ebp),%esi
801046ce:	53                   	push   %ebx
  while(n > 0 && *p && *p == *q)
801046cf:	85 ff                	test   %edi,%edi
801046d1:	74 2f                	je     80104702 <strncmp+0x42>
801046d3:	0f b6 11             	movzbl (%ecx),%edx
801046d6:	0f b6 1e             	movzbl (%esi),%ebx
801046d9:	84 d2                	test   %dl,%dl
801046db:	74 37                	je     80104714 <strncmp+0x54>
801046dd:	38 da                	cmp    %bl,%dl
801046df:	75 33                	jne    80104714 <strncmp+0x54>
801046e1:	01 f7                	add    %esi,%edi
801046e3:	eb 13                	jmp    801046f8 <strncmp+0x38>
801046e5:	8d 76 00             	lea    0x0(%esi),%esi
801046e8:	0f b6 11             	movzbl (%ecx),%edx
801046eb:	84 d2                	test   %dl,%dl
801046ed:	74 21                	je     80104710 <strncmp+0x50>
801046ef:	0f b6 18             	movzbl (%eax),%ebx
801046f2:	89 c6                	mov    %eax,%esi
801046f4:	38 da                	cmp    %bl,%dl
801046f6:	75 1c                	jne    80104714 <strncmp+0x54>
    n--, p++, q++;
801046f8:	8d 46 01             	lea    0x1(%esi),%eax
801046fb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801046fe:	39 f8                	cmp    %edi,%eax
80104700:	75 e6                	jne    801046e8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104702:	5b                   	pop    %ebx
    return 0;
80104703:	31 c0                	xor    %eax,%eax
}
80104705:	5e                   	pop    %esi
80104706:	5f                   	pop    %edi
80104707:	5d                   	pop    %ebp
80104708:	c3                   	ret    
80104709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104710:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104714:	0f b6 c2             	movzbl %dl,%eax
80104717:	29 d8                	sub    %ebx,%eax
}
80104719:	5b                   	pop    %ebx
8010471a:	5e                   	pop    %esi
8010471b:	5f                   	pop    %edi
8010471c:	5d                   	pop    %ebp
8010471d:	c3                   	ret    
8010471e:	66 90                	xchg   %ax,%ax

80104720 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	57                   	push   %edi
80104724:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104727:	8b 4d 08             	mov    0x8(%ebp),%ecx
{
8010472a:	56                   	push   %esi
8010472b:	53                   	push   %ebx
8010472c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  while(n-- > 0 && (*s++ = *t++) != 0)
8010472f:	eb 1a                	jmp    8010474b <strncpy+0x2b>
80104731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104738:	83 c2 01             	add    $0x1,%edx
8010473b:	0f b6 42 ff          	movzbl -0x1(%edx),%eax
8010473f:	83 c1 01             	add    $0x1,%ecx
80104742:	88 41 ff             	mov    %al,-0x1(%ecx)
80104745:	84 c0                	test   %al,%al
80104747:	74 09                	je     80104752 <strncpy+0x32>
80104749:	89 fb                	mov    %edi,%ebx
8010474b:	8d 7b ff             	lea    -0x1(%ebx),%edi
8010474e:	85 db                	test   %ebx,%ebx
80104750:	7f e6                	jg     80104738 <strncpy+0x18>
    ;
  while(n-- > 0)
80104752:	89 ce                	mov    %ecx,%esi
80104754:	85 ff                	test   %edi,%edi
80104756:	7e 1b                	jle    80104773 <strncpy+0x53>
80104758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010475f:	90                   	nop
    *s++ = 0;
80104760:	83 c6 01             	add    $0x1,%esi
80104763:	c6 46 ff 00          	movb   $0x0,-0x1(%esi)
80104767:	89 f2                	mov    %esi,%edx
80104769:	f7 d2                	not    %edx
8010476b:	01 ca                	add    %ecx,%edx
8010476d:	01 da                	add    %ebx,%edx
  while(n-- > 0)
8010476f:	85 d2                	test   %edx,%edx
80104771:	7f ed                	jg     80104760 <strncpy+0x40>
  return os;
}
80104773:	5b                   	pop    %ebx
80104774:	8b 45 08             	mov    0x8(%ebp),%eax
80104777:	5e                   	pop    %esi
80104778:	5f                   	pop    %edi
80104779:	5d                   	pop    %ebp
8010477a:	c3                   	ret    
8010477b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010477f:	90                   	nop

80104780 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	56                   	push   %esi
80104784:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104787:	8b 45 08             	mov    0x8(%ebp),%eax
8010478a:	53                   	push   %ebx
8010478b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010478e:	85 c9                	test   %ecx,%ecx
80104790:	7e 26                	jle    801047b8 <safestrcpy+0x38>
80104792:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104796:	89 c1                	mov    %eax,%ecx
80104798:	eb 17                	jmp    801047b1 <safestrcpy+0x31>
8010479a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801047a0:	83 c2 01             	add    $0x1,%edx
801047a3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801047a7:	83 c1 01             	add    $0x1,%ecx
801047aa:	88 59 ff             	mov    %bl,-0x1(%ecx)
801047ad:	84 db                	test   %bl,%bl
801047af:	74 04                	je     801047b5 <safestrcpy+0x35>
801047b1:	39 f2                	cmp    %esi,%edx
801047b3:	75 eb                	jne    801047a0 <safestrcpy+0x20>
    ;
  *s = 0;
801047b5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
801047b8:	5b                   	pop    %ebx
801047b9:	5e                   	pop    %esi
801047ba:	5d                   	pop    %ebp
801047bb:	c3                   	ret    
801047bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047c0 <strlen>:

int
strlen(const char *s)
{
801047c0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
801047c1:	31 c0                	xor    %eax,%eax
{
801047c3:	89 e5                	mov    %esp,%ebp
801047c5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
801047c8:	80 3a 00             	cmpb   $0x0,(%edx)
801047cb:	74 0c                	je     801047d9 <strlen+0x19>
801047cd:	8d 76 00             	lea    0x0(%esi),%esi
801047d0:	83 c0 01             	add    $0x1,%eax
801047d3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801047d7:	75 f7                	jne    801047d0 <strlen+0x10>
    ;
  return n;
}
801047d9:	5d                   	pop    %ebp
801047da:	c3                   	ret    

801047db <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801047db:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801047df:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801047e3:	55                   	push   %ebp
  pushl %ebx
801047e4:	53                   	push   %ebx
  pushl %esi
801047e5:	56                   	push   %esi
  pushl %edi
801047e6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801047e7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801047e9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801047eb:	5f                   	pop    %edi
  popl %esi
801047ec:	5e                   	pop    %esi
  popl %ebx
801047ed:	5b                   	pop    %ebx
  popl %ebp
801047ee:	5d                   	pop    %ebp
  ret
801047ef:	c3                   	ret    

801047f0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	53                   	push   %ebx
801047f4:	83 ec 04             	sub    $0x4,%esp
801047f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801047fa:	e8 d1 f0 ff ff       	call   801038d0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801047ff:	8b 00                	mov    (%eax),%eax
80104801:	39 d8                	cmp    %ebx,%eax
80104803:	76 1b                	jbe    80104820 <fetchint+0x30>
80104805:	8d 53 04             	lea    0x4(%ebx),%edx
80104808:	39 d0                	cmp    %edx,%eax
8010480a:	72 14                	jb     80104820 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010480c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010480f:	8b 13                	mov    (%ebx),%edx
80104811:	89 10                	mov    %edx,(%eax)
  return 0;
80104813:	31 c0                	xor    %eax,%eax
}
80104815:	83 c4 04             	add    $0x4,%esp
80104818:	5b                   	pop    %ebx
80104819:	5d                   	pop    %ebp
8010481a:	c3                   	ret    
8010481b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010481f:	90                   	nop
    return -1;
80104820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104825:	eb ee                	jmp    80104815 <fetchint+0x25>
80104827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482e:	66 90                	xchg   %ax,%ax

80104830 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	53                   	push   %ebx
80104834:	83 ec 04             	sub    $0x4,%esp
80104837:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010483a:	e8 91 f0 ff ff       	call   801038d0 <myproc>

  if(addr >= curproc->sz)
8010483f:	39 18                	cmp    %ebx,(%eax)
80104841:	76 29                	jbe    8010486c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104843:	8b 55 0c             	mov    0xc(%ebp),%edx
80104846:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104848:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010484a:	39 d3                	cmp    %edx,%ebx
8010484c:	73 1e                	jae    8010486c <fetchstr+0x3c>
    if(*s == 0)
8010484e:	80 3b 00             	cmpb   $0x0,(%ebx)
80104851:	74 35                	je     80104888 <fetchstr+0x58>
80104853:	89 d8                	mov    %ebx,%eax
80104855:	eb 0e                	jmp    80104865 <fetchstr+0x35>
80104857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010485e:	66 90                	xchg   %ax,%ax
80104860:	80 38 00             	cmpb   $0x0,(%eax)
80104863:	74 1b                	je     80104880 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104865:	83 c0 01             	add    $0x1,%eax
80104868:	39 c2                	cmp    %eax,%edx
8010486a:	77 f4                	ja     80104860 <fetchstr+0x30>
    return -1;
8010486c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104871:	83 c4 04             	add    $0x4,%esp
80104874:	5b                   	pop    %ebx
80104875:	5d                   	pop    %ebp
80104876:	c3                   	ret    
80104877:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010487e:	66 90                	xchg   %ax,%ax
80104880:	83 c4 04             	add    $0x4,%esp
80104883:	29 d8                	sub    %ebx,%eax
80104885:	5b                   	pop    %ebx
80104886:	5d                   	pop    %ebp
80104887:	c3                   	ret    
    if(*s == 0)
80104888:	31 c0                	xor    %eax,%eax
      return s - *pp;
8010488a:	eb e5                	jmp    80104871 <fetchstr+0x41>
8010488c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104890 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	56                   	push   %esi
80104894:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104895:	e8 36 f0 ff ff       	call   801038d0 <myproc>
8010489a:	8b 55 08             	mov    0x8(%ebp),%edx
8010489d:	8b 40 18             	mov    0x18(%eax),%eax
801048a0:	8b 40 44             	mov    0x44(%eax),%eax
801048a3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801048a6:	e8 25 f0 ff ff       	call   801038d0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048ab:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801048ae:	8b 00                	mov    (%eax),%eax
801048b0:	39 c6                	cmp    %eax,%esi
801048b2:	73 1c                	jae    801048d0 <argint+0x40>
801048b4:	8d 53 08             	lea    0x8(%ebx),%edx
801048b7:	39 d0                	cmp    %edx,%eax
801048b9:	72 15                	jb     801048d0 <argint+0x40>
  *ip = *(int*)(addr);
801048bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801048be:	8b 53 04             	mov    0x4(%ebx),%edx
801048c1:	89 10                	mov    %edx,(%eax)
  return 0;
801048c3:	31 c0                	xor    %eax,%eax
}
801048c5:	5b                   	pop    %ebx
801048c6:	5e                   	pop    %esi
801048c7:	5d                   	pop    %ebp
801048c8:	c3                   	ret    
801048c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801048d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801048d5:	eb ee                	jmp    801048c5 <argint+0x35>
801048d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048de:	66 90                	xchg   %ax,%ax

801048e0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	53                   	push   %ebx
801048e5:	83 ec 10             	sub    $0x10,%esp
801048e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801048eb:	e8 e0 ef ff ff       	call   801038d0 <myproc>
 
  if(argint(n, &i) < 0)
801048f0:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801048f3:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801048f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048f8:	50                   	push   %eax
801048f9:	ff 75 08             	pushl  0x8(%ebp)
801048fc:	e8 8f ff ff ff       	call   80104890 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104901:	83 c4 10             	add    $0x10,%esp
80104904:	85 c0                	test   %eax,%eax
80104906:	78 28                	js     80104930 <argptr+0x50>
80104908:	85 db                	test   %ebx,%ebx
8010490a:	78 24                	js     80104930 <argptr+0x50>
8010490c:	8b 16                	mov    (%esi),%edx
8010490e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104911:	39 c2                	cmp    %eax,%edx
80104913:	76 1b                	jbe    80104930 <argptr+0x50>
80104915:	01 c3                	add    %eax,%ebx
80104917:	39 da                	cmp    %ebx,%edx
80104919:	72 15                	jb     80104930 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010491b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010491e:	89 02                	mov    %eax,(%edx)
  return 0;
80104920:	31 c0                	xor    %eax,%eax
}
80104922:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104925:	5b                   	pop    %ebx
80104926:	5e                   	pop    %esi
80104927:	5d                   	pop    %ebp
80104928:	c3                   	ret    
80104929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104935:	eb eb                	jmp    80104922 <argptr+0x42>
80104937:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010493e:	66 90                	xchg   %ax,%ax

80104940 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104940:	55                   	push   %ebp
80104941:	89 e5                	mov    %esp,%ebp
80104943:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104946:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104949:	50                   	push   %eax
8010494a:	ff 75 08             	pushl  0x8(%ebp)
8010494d:	e8 3e ff ff ff       	call   80104890 <argint>
80104952:	83 c4 10             	add    $0x10,%esp
80104955:	85 c0                	test   %eax,%eax
80104957:	78 17                	js     80104970 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104959:	83 ec 08             	sub    $0x8,%esp
8010495c:	ff 75 0c             	pushl  0xc(%ebp)
8010495f:	ff 75 f4             	pushl  -0xc(%ebp)
80104962:	e8 c9 fe ff ff       	call   80104830 <fetchstr>
80104967:	83 c4 10             	add    $0x10,%esp
}
8010496a:	c9                   	leave  
8010496b:	c3                   	ret    
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104970:	c9                   	leave  
    return -1;
80104971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104976:	c3                   	ret    
80104977:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010497e:	66 90                	xchg   %ax,%ax

80104980 <syscall>:
[SYS_getCount] sys_getCount,
};

void
syscall(void)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104987:	e8 44 ef ff ff       	call   801038d0 <myproc>
8010498c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010498e:	8b 40 18             	mov    0x18(%eax),%eax
80104991:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104994:	8d 50 ff             	lea    -0x1(%eax),%edx
80104997:	83 fa 16             	cmp    $0x16,%edx
8010499a:	77 1c                	ja     801049b8 <syscall+0x38>
8010499c:	8b 14 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%edx
801049a3:	85 d2                	test   %edx,%edx
801049a5:	74 11                	je     801049b8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801049a7:	ff d2                	call   *%edx
801049a9:	8b 53 18             	mov    0x18(%ebx),%edx
801049ac:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801049af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b2:	c9                   	leave  
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
801049b8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
801049b9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
801049bc:	50                   	push   %eax
801049bd:	ff 73 10             	pushl  0x10(%ebx)
801049c0:	68 91 76 10 80       	push   $0x80107691
801049c5:	e8 e6 bc ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
801049ca:	8b 43 18             	mov    0x18(%ebx),%eax
801049cd:	83 c4 10             	add    $0x10,%esp
801049d0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801049d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049da:	c9                   	leave  
801049db:	c3                   	ret    
801049dc:	66 90                	xchg   %ax,%ax
801049de:	66 90                	xchg   %ax,%ax

801049e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	57                   	push   %edi
801049e4:	56                   	push   %esi
801049e5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801049e6:	8d 5d da             	lea    -0x26(%ebp),%ebx
{
801049e9:	83 ec 34             	sub    $0x34,%esp
801049ec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801049ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801049f2:	53                   	push   %ebx
801049f3:	50                   	push   %eax
{
801049f4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801049f7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801049fa:	e8 d1 d5 ff ff       	call   80101fd0 <nameiparent>
801049ff:	83 c4 10             	add    $0x10,%esp
80104a02:	85 c0                	test   %eax,%eax
80104a04:	0f 84 46 01 00 00    	je     80104b50 <create+0x170>
    return 0;
  ilock(dp);
80104a0a:	83 ec 0c             	sub    $0xc,%esp
80104a0d:	89 c6                	mov    %eax,%esi
80104a0f:	50                   	push   %eax
80104a10:	e8 fb cc ff ff       	call   80101710 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104a15:	83 c4 0c             	add    $0xc,%esp
80104a18:	6a 00                	push   $0x0
80104a1a:	53                   	push   %ebx
80104a1b:	56                   	push   %esi
80104a1c:	e8 1f d2 ff ff       	call   80101c40 <dirlookup>
80104a21:	83 c4 10             	add    $0x10,%esp
80104a24:	89 c7                	mov    %eax,%edi
80104a26:	85 c0                	test   %eax,%eax
80104a28:	74 56                	je     80104a80 <create+0xa0>
    iunlockput(dp);
80104a2a:	83 ec 0c             	sub    $0xc,%esp
80104a2d:	56                   	push   %esi
80104a2e:	e8 6d cf ff ff       	call   801019a0 <iunlockput>
    ilock(ip);
80104a33:	89 3c 24             	mov    %edi,(%esp)
80104a36:	e8 d5 cc ff ff       	call   80101710 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104a3b:	83 c4 10             	add    $0x10,%esp
80104a3e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104a43:	75 1b                	jne    80104a60 <create+0x80>
80104a45:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104a4a:	75 14                	jne    80104a60 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104a4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a4f:	89 f8                	mov    %edi,%eax
80104a51:	5b                   	pop    %ebx
80104a52:	5e                   	pop    %esi
80104a53:	5f                   	pop    %edi
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104a60:	83 ec 0c             	sub    $0xc,%esp
80104a63:	57                   	push   %edi
    return 0;
80104a64:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104a66:	e8 35 cf ff ff       	call   801019a0 <iunlockput>
    return 0;
80104a6b:	83 c4 10             	add    $0x10,%esp
}
80104a6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a71:	89 f8                	mov    %edi,%eax
80104a73:	5b                   	pop    %ebx
80104a74:	5e                   	pop    %esi
80104a75:	5f                   	pop    %edi
80104a76:	5d                   	pop    %ebp
80104a77:	c3                   	ret    
80104a78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a7f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104a80:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104a84:	83 ec 08             	sub    $0x8,%esp
80104a87:	50                   	push   %eax
80104a88:	ff 36                	pushl  (%esi)
80104a8a:	e8 11 cb ff ff       	call   801015a0 <ialloc>
80104a8f:	83 c4 10             	add    $0x10,%esp
80104a92:	89 c7                	mov    %eax,%edi
80104a94:	85 c0                	test   %eax,%eax
80104a96:	0f 84 cd 00 00 00    	je     80104b69 <create+0x189>
  ilock(ip);
80104a9c:	83 ec 0c             	sub    $0xc,%esp
80104a9f:	50                   	push   %eax
80104aa0:	e8 6b cc ff ff       	call   80101710 <ilock>
  ip->major = major;
80104aa5:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104aa9:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104aad:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ab1:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104ab5:	b8 01 00 00 00       	mov    $0x1,%eax
80104aba:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104abe:	89 3c 24             	mov    %edi,(%esp)
80104ac1:	e8 9a cb ff ff       	call   80101660 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104ac6:	83 c4 10             	add    $0x10,%esp
80104ac9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104ace:	74 30                	je     80104b00 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104ad0:	83 ec 04             	sub    $0x4,%esp
80104ad3:	ff 77 04             	pushl  0x4(%edi)
80104ad6:	53                   	push   %ebx
80104ad7:	56                   	push   %esi
80104ad8:	e8 13 d4 ff ff       	call   80101ef0 <dirlink>
80104add:	83 c4 10             	add    $0x10,%esp
80104ae0:	85 c0                	test   %eax,%eax
80104ae2:	78 78                	js     80104b5c <create+0x17c>
  iunlockput(dp);
80104ae4:	83 ec 0c             	sub    $0xc,%esp
80104ae7:	56                   	push   %esi
80104ae8:	e8 b3 ce ff ff       	call   801019a0 <iunlockput>
  return ip;
80104aed:	83 c4 10             	add    $0x10,%esp
}
80104af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104af3:	89 f8                	mov    %edi,%eax
80104af5:	5b                   	pop    %ebx
80104af6:	5e                   	pop    %esi
80104af7:	5f                   	pop    %edi
80104af8:	5d                   	pop    %ebp
80104af9:	c3                   	ret    
80104afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104b00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104b03:	66 83 46 56 01       	addw   $0x1,0x56(%esi)
    iupdate(dp);
80104b08:	56                   	push   %esi
80104b09:	e8 52 cb ff ff       	call   80101660 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104b0e:	83 c4 0c             	add    $0xc,%esp
80104b11:	ff 77 04             	pushl  0x4(%edi)
80104b14:	68 3c 77 10 80       	push   $0x8010773c
80104b19:	57                   	push   %edi
80104b1a:	e8 d1 d3 ff ff       	call   80101ef0 <dirlink>
80104b1f:	83 c4 10             	add    $0x10,%esp
80104b22:	85 c0                	test   %eax,%eax
80104b24:	78 18                	js     80104b3e <create+0x15e>
80104b26:	83 ec 04             	sub    $0x4,%esp
80104b29:	ff 76 04             	pushl  0x4(%esi)
80104b2c:	68 3b 77 10 80       	push   $0x8010773b
80104b31:	57                   	push   %edi
80104b32:	e8 b9 d3 ff ff       	call   80101ef0 <dirlink>
80104b37:	83 c4 10             	add    $0x10,%esp
80104b3a:	85 c0                	test   %eax,%eax
80104b3c:	79 92                	jns    80104ad0 <create+0xf0>
      panic("create dots");
80104b3e:	83 ec 0c             	sub    $0xc,%esp
80104b41:	68 2f 77 10 80       	push   $0x8010772f
80104b46:	e8 45 b8 ff ff       	call   80100390 <panic>
80104b4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b4f:	90                   	nop
}
80104b50:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104b53:	31 ff                	xor    %edi,%edi
}
80104b55:	5b                   	pop    %ebx
80104b56:	89 f8                	mov    %edi,%eax
80104b58:	5e                   	pop    %esi
80104b59:	5f                   	pop    %edi
80104b5a:	5d                   	pop    %ebp
80104b5b:	c3                   	ret    
    panic("create: dirlink");
80104b5c:	83 ec 0c             	sub    $0xc,%esp
80104b5f:	68 3e 77 10 80       	push   $0x8010773e
80104b64:	e8 27 b8 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80104b69:	83 ec 0c             	sub    $0xc,%esp
80104b6c:	68 20 77 10 80       	push   $0x80107720
80104b71:	e8 1a b8 ff ff       	call   80100390 <panic>
80104b76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7d:	8d 76 00             	lea    0x0(%esi),%esi

80104b80 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	89 d6                	mov    %edx,%esi
80104b86:	53                   	push   %ebx
80104b87:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80104b89:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104b8c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104b8f:	50                   	push   %eax
80104b90:	6a 00                	push   $0x0
80104b92:	e8 f9 fc ff ff       	call   80104890 <argint>
80104b97:	83 c4 10             	add    $0x10,%esp
80104b9a:	85 c0                	test   %eax,%eax
80104b9c:	78 2a                	js     80104bc8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104b9e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ba2:	77 24                	ja     80104bc8 <argfd.constprop.0+0x48>
80104ba4:	e8 27 ed ff ff       	call   801038d0 <myproc>
80104ba9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104bac:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104bb0:	85 c0                	test   %eax,%eax
80104bb2:	74 14                	je     80104bc8 <argfd.constprop.0+0x48>
  if(pfd)
80104bb4:	85 db                	test   %ebx,%ebx
80104bb6:	74 02                	je     80104bba <argfd.constprop.0+0x3a>
    *pfd = fd;
80104bb8:	89 13                	mov    %edx,(%ebx)
    *pf = f;
80104bba:	89 06                	mov    %eax,(%esi)
  return 0;
80104bbc:	31 c0                	xor    %eax,%eax
}
80104bbe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104bc1:	5b                   	pop    %ebx
80104bc2:	5e                   	pop    %esi
80104bc3:	5d                   	pop    %ebp
80104bc4:	c3                   	ret    
80104bc5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bcd:	eb ef                	jmp    80104bbe <argfd.constprop.0+0x3e>
80104bcf:	90                   	nop

80104bd0 <sys_dup>:
{
80104bd0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104bd1:	31 c0                	xor    %eax,%eax
{
80104bd3:	89 e5                	mov    %esp,%ebp
80104bd5:	56                   	push   %esi
80104bd6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104bd7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104bda:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104bdd:	e8 9e ff ff ff       	call   80104b80 <argfd.constprop.0>
80104be2:	85 c0                	test   %eax,%eax
80104be4:	78 1a                	js     80104c00 <sys_dup+0x30>
  if((fd=fdalloc(f)) < 0)
80104be6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104be9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104beb:	e8 e0 ec ff ff       	call   801038d0 <myproc>
    if(curproc->ofile[fd] == 0){
80104bf0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104bf4:	85 d2                	test   %edx,%edx
80104bf6:	74 18                	je     80104c10 <sys_dup+0x40>
  for(fd = 0; fd < NOFILE; fd++){
80104bf8:	83 c3 01             	add    $0x1,%ebx
80104bfb:	83 fb 10             	cmp    $0x10,%ebx
80104bfe:	75 f0                	jne    80104bf0 <sys_dup+0x20>
}
80104c00:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104c03:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104c08:	89 d8                	mov    %ebx,%eax
80104c0a:	5b                   	pop    %ebx
80104c0b:	5e                   	pop    %esi
80104c0c:	5d                   	pop    %ebp
80104c0d:	c3                   	ret    
80104c0e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80104c10:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104c14:	83 ec 0c             	sub    $0xc,%esp
80104c17:	ff 75 f4             	pushl  -0xc(%ebp)
80104c1a:	e8 51 c2 ff ff       	call   80100e70 <filedup>
  return fd;
80104c1f:	83 c4 10             	add    $0x10,%esp
}
80104c22:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c25:	89 d8                	mov    %ebx,%eax
80104c27:	5b                   	pop    %ebx
80104c28:	5e                   	pop    %esi
80104c29:	5d                   	pop    %ebp
80104c2a:	c3                   	ret    
80104c2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c2f:	90                   	nop

80104c30 <sys_read>:
{
80104c30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c31:	31 c0                	xor    %eax,%eax
{
80104c33:	89 e5                	mov    %esp,%ebp
80104c35:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104c38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104c3b:	e8 40 ff ff ff       	call   80104b80 <argfd.constprop.0>
80104c40:	85 c0                	test   %eax,%eax
80104c42:	78 4c                	js     80104c90 <sys_read+0x60>
80104c44:	83 ec 08             	sub    $0x8,%esp
80104c47:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c4a:	50                   	push   %eax
80104c4b:	6a 02                	push   $0x2
80104c4d:	e8 3e fc ff ff       	call   80104890 <argint>
80104c52:	83 c4 10             	add    $0x10,%esp
80104c55:	85 c0                	test   %eax,%eax
80104c57:	78 37                	js     80104c90 <sys_read+0x60>
80104c59:	83 ec 04             	sub    $0x4,%esp
80104c5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104c62:	50                   	push   %eax
80104c63:	6a 01                	push   $0x1
80104c65:	e8 76 fc ff ff       	call   801048e0 <argptr>
80104c6a:	83 c4 10             	add    $0x10,%esp
80104c6d:	85 c0                	test   %eax,%eax
80104c6f:	78 1f                	js     80104c90 <sys_read+0x60>
  return fileread(f, p, n);
80104c71:	83 ec 04             	sub    $0x4,%esp
80104c74:	ff 75 f0             	pushl  -0x10(%ebp)
80104c77:	ff 75 f4             	pushl  -0xc(%ebp)
80104c7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104c7d:	e8 6e c3 ff ff       	call   80100ff0 <fileread>
80104c82:	83 c4 10             	add    $0x10,%esp
}
80104c85:	c9                   	leave  
80104c86:	c3                   	ret    
80104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8e:	66 90                	xchg   %ax,%ax
80104c90:	c9                   	leave  
    return -1;
80104c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c96:	c3                   	ret    
80104c97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c9e:	66 90                	xchg   %ax,%ax

80104ca0 <sys_write>:
{
80104ca0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ca1:	31 c0                	xor    %eax,%eax
{
80104ca3:	89 e5                	mov    %esp,%ebp
80104ca5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ca8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104cab:	e8 d0 fe ff ff       	call   80104b80 <argfd.constprop.0>
80104cb0:	85 c0                	test   %eax,%eax
80104cb2:	78 4c                	js     80104d00 <sys_write+0x60>
80104cb4:	83 ec 08             	sub    $0x8,%esp
80104cb7:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104cba:	50                   	push   %eax
80104cbb:	6a 02                	push   $0x2
80104cbd:	e8 ce fb ff ff       	call   80104890 <argint>
80104cc2:	83 c4 10             	add    $0x10,%esp
80104cc5:	85 c0                	test   %eax,%eax
80104cc7:	78 37                	js     80104d00 <sys_write+0x60>
80104cc9:	83 ec 04             	sub    $0x4,%esp
80104ccc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ccf:	ff 75 f0             	pushl  -0x10(%ebp)
80104cd2:	50                   	push   %eax
80104cd3:	6a 01                	push   $0x1
80104cd5:	e8 06 fc ff ff       	call   801048e0 <argptr>
80104cda:	83 c4 10             	add    $0x10,%esp
80104cdd:	85 c0                	test   %eax,%eax
80104cdf:	78 1f                	js     80104d00 <sys_write+0x60>
  return filewrite(f, p, n);
80104ce1:	83 ec 04             	sub    $0x4,%esp
80104ce4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ce7:	ff 75 f4             	pushl  -0xc(%ebp)
80104cea:	ff 75 ec             	pushl  -0x14(%ebp)
80104ced:	e8 8e c3 ff ff       	call   80101080 <filewrite>
80104cf2:	83 c4 10             	add    $0x10,%esp
}
80104cf5:	c9                   	leave  
80104cf6:	c3                   	ret    
80104cf7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cfe:	66 90                	xchg   %ax,%ax
80104d00:	c9                   	leave  
    return -1;
80104d01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d06:	c3                   	ret    
80104d07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d0e:	66 90                	xchg   %ax,%ax

80104d10 <sys_close>:
{
80104d10:	55                   	push   %ebp
80104d11:	89 e5                	mov    %esp,%ebp
80104d13:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80104d16:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104d19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104d1c:	e8 5f fe ff ff       	call   80104b80 <argfd.constprop.0>
80104d21:	85 c0                	test   %eax,%eax
80104d23:	78 2b                	js     80104d50 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80104d25:	e8 a6 eb ff ff       	call   801038d0 <myproc>
80104d2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104d2d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104d30:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104d37:	00 
  fileclose(f);
80104d38:	ff 75 f4             	pushl  -0xc(%ebp)
80104d3b:	e8 80 c1 ff ff       	call   80100ec0 <fileclose>
  return 0;
80104d40:	83 c4 10             	add    $0x10,%esp
80104d43:	31 c0                	xor    %eax,%eax
}
80104d45:	c9                   	leave  
80104d46:	c3                   	ret    
80104d47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d4e:	66 90                	xchg   %ax,%ax
80104d50:	c9                   	leave  
    return -1;
80104d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d56:	c3                   	ret    
80104d57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d5e:	66 90                	xchg   %ax,%ax

80104d60 <sys_fstat>:
{
80104d60:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d61:	31 c0                	xor    %eax,%eax
{
80104d63:	89 e5                	mov    %esp,%ebp
80104d65:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104d68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104d6b:	e8 10 fe ff ff       	call   80104b80 <argfd.constprop.0>
80104d70:	85 c0                	test   %eax,%eax
80104d72:	78 2c                	js     80104da0 <sys_fstat+0x40>
80104d74:	83 ec 04             	sub    $0x4,%esp
80104d77:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d7a:	6a 14                	push   $0x14
80104d7c:	50                   	push   %eax
80104d7d:	6a 01                	push   $0x1
80104d7f:	e8 5c fb ff ff       	call   801048e0 <argptr>
80104d84:	83 c4 10             	add    $0x10,%esp
80104d87:	85 c0                	test   %eax,%eax
80104d89:	78 15                	js     80104da0 <sys_fstat+0x40>
  return filestat(f, st);
80104d8b:	83 ec 08             	sub    $0x8,%esp
80104d8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104d91:	ff 75 f0             	pushl  -0x10(%ebp)
80104d94:	e8 07 c2 ff ff       	call   80100fa0 <filestat>
80104d99:	83 c4 10             	add    $0x10,%esp
}
80104d9c:	c9                   	leave  
80104d9d:	c3                   	ret    
80104d9e:	66 90                	xchg   %ax,%ax
80104da0:	c9                   	leave  
    return -1;
80104da1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104da6:	c3                   	ret    
80104da7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dae:	66 90                	xchg   %ax,%ax

80104db0 <sys_link>:
{
80104db0:	55                   	push   %ebp
80104db1:	89 e5                	mov    %esp,%ebp
80104db3:	57                   	push   %edi
80104db4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104db5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104db8:	53                   	push   %ebx
80104db9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104dbc:	50                   	push   %eax
80104dbd:	6a 00                	push   $0x0
80104dbf:	e8 7c fb ff ff       	call   80104940 <argstr>
80104dc4:	83 c4 10             	add    $0x10,%esp
80104dc7:	85 c0                	test   %eax,%eax
80104dc9:	0f 88 fb 00 00 00    	js     80104eca <sys_link+0x11a>
80104dcf:	83 ec 08             	sub    $0x8,%esp
80104dd2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104dd5:	50                   	push   %eax
80104dd6:	6a 01                	push   $0x1
80104dd8:	e8 63 fb ff ff       	call   80104940 <argstr>
80104ddd:	83 c4 10             	add    $0x10,%esp
80104de0:	85 c0                	test   %eax,%eax
80104de2:	0f 88 e2 00 00 00    	js     80104eca <sys_link+0x11a>
  begin_op();
80104de8:	e8 a3 de ff ff       	call   80102c90 <begin_op>
  if((ip = namei(old)) == 0){
80104ded:	83 ec 0c             	sub    $0xc,%esp
80104df0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104df3:	e8 b8 d1 ff ff       	call   80101fb0 <namei>
80104df8:	83 c4 10             	add    $0x10,%esp
80104dfb:	89 c3                	mov    %eax,%ebx
80104dfd:	85 c0                	test   %eax,%eax
80104dff:	0f 84 e4 00 00 00    	je     80104ee9 <sys_link+0x139>
  ilock(ip);
80104e05:	83 ec 0c             	sub    $0xc,%esp
80104e08:	50                   	push   %eax
80104e09:	e8 02 c9 ff ff       	call   80101710 <ilock>
  if(ip->type == T_DIR){
80104e0e:	83 c4 10             	add    $0x10,%esp
80104e11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e16:	0f 84 b5 00 00 00    	je     80104ed1 <sys_link+0x121>
  iupdate(ip);
80104e1c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
80104e1f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104e24:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104e27:	53                   	push   %ebx
80104e28:	e8 33 c8 ff ff       	call   80101660 <iupdate>
  iunlock(ip);
80104e2d:	89 1c 24             	mov    %ebx,(%esp)
80104e30:	e8 bb c9 ff ff       	call   801017f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104e35:	58                   	pop    %eax
80104e36:	5a                   	pop    %edx
80104e37:	57                   	push   %edi
80104e38:	ff 75 d0             	pushl  -0x30(%ebp)
80104e3b:	e8 90 d1 ff ff       	call   80101fd0 <nameiparent>
80104e40:	83 c4 10             	add    $0x10,%esp
80104e43:	89 c6                	mov    %eax,%esi
80104e45:	85 c0                	test   %eax,%eax
80104e47:	74 5b                	je     80104ea4 <sys_link+0xf4>
  ilock(dp);
80104e49:	83 ec 0c             	sub    $0xc,%esp
80104e4c:	50                   	push   %eax
80104e4d:	e8 be c8 ff ff       	call   80101710 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104e52:	83 c4 10             	add    $0x10,%esp
80104e55:	8b 03                	mov    (%ebx),%eax
80104e57:	39 06                	cmp    %eax,(%esi)
80104e59:	75 3d                	jne    80104e98 <sys_link+0xe8>
80104e5b:	83 ec 04             	sub    $0x4,%esp
80104e5e:	ff 73 04             	pushl  0x4(%ebx)
80104e61:	57                   	push   %edi
80104e62:	56                   	push   %esi
80104e63:	e8 88 d0 ff ff       	call   80101ef0 <dirlink>
80104e68:	83 c4 10             	add    $0x10,%esp
80104e6b:	85 c0                	test   %eax,%eax
80104e6d:	78 29                	js     80104e98 <sys_link+0xe8>
  iunlockput(dp);
80104e6f:	83 ec 0c             	sub    $0xc,%esp
80104e72:	56                   	push   %esi
80104e73:	e8 28 cb ff ff       	call   801019a0 <iunlockput>
  iput(ip);
80104e78:	89 1c 24             	mov    %ebx,(%esp)
80104e7b:	e8 c0 c9 ff ff       	call   80101840 <iput>
  end_op();
80104e80:	e8 7b de ff ff       	call   80102d00 <end_op>
  return 0;
80104e85:	83 c4 10             	add    $0x10,%esp
80104e88:	31 c0                	xor    %eax,%eax
}
80104e8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e8d:	5b                   	pop    %ebx
80104e8e:	5e                   	pop    %esi
80104e8f:	5f                   	pop    %edi
80104e90:	5d                   	pop    %ebp
80104e91:	c3                   	ret    
80104e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80104e98:	83 ec 0c             	sub    $0xc,%esp
80104e9b:	56                   	push   %esi
80104e9c:	e8 ff ca ff ff       	call   801019a0 <iunlockput>
    goto bad;
80104ea1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80104ea4:	83 ec 0c             	sub    $0xc,%esp
80104ea7:	53                   	push   %ebx
80104ea8:	e8 63 c8 ff ff       	call   80101710 <ilock>
  ip->nlink--;
80104ead:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104eb2:	89 1c 24             	mov    %ebx,(%esp)
80104eb5:	e8 a6 c7 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104eba:	89 1c 24             	mov    %ebx,(%esp)
80104ebd:	e8 de ca ff ff       	call   801019a0 <iunlockput>
  end_op();
80104ec2:	e8 39 de ff ff       	call   80102d00 <end_op>
  return -1;
80104ec7:	83 c4 10             	add    $0x10,%esp
80104eca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ecf:	eb b9                	jmp    80104e8a <sys_link+0xda>
    iunlockput(ip);
80104ed1:	83 ec 0c             	sub    $0xc,%esp
80104ed4:	53                   	push   %ebx
80104ed5:	e8 c6 ca ff ff       	call   801019a0 <iunlockput>
    end_op();
80104eda:	e8 21 de ff ff       	call   80102d00 <end_op>
    return -1;
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ee7:	eb a1                	jmp    80104e8a <sys_link+0xda>
    end_op();
80104ee9:	e8 12 de ff ff       	call   80102d00 <end_op>
    return -1;
80104eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ef3:	eb 95                	jmp    80104e8a <sys_link+0xda>
80104ef5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104f00 <sys_unlink>:
{
80104f00:	55                   	push   %ebp
80104f01:	89 e5                	mov    %esp,%ebp
80104f03:	57                   	push   %edi
80104f04:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80104f05:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80104f08:	53                   	push   %ebx
80104f09:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80104f0c:	50                   	push   %eax
80104f0d:	6a 00                	push   $0x0
80104f0f:	e8 2c fa ff ff       	call   80104940 <argstr>
80104f14:	83 c4 10             	add    $0x10,%esp
80104f17:	85 c0                	test   %eax,%eax
80104f19:	0f 88 91 01 00 00    	js     801050b0 <sys_unlink+0x1b0>
  begin_op();
80104f1f:	e8 6c dd ff ff       	call   80102c90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104f24:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104f27:	83 ec 08             	sub    $0x8,%esp
80104f2a:	53                   	push   %ebx
80104f2b:	ff 75 c0             	pushl  -0x40(%ebp)
80104f2e:	e8 9d d0 ff ff       	call   80101fd0 <nameiparent>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	89 c6                	mov    %eax,%esi
80104f38:	85 c0                	test   %eax,%eax
80104f3a:	0f 84 7a 01 00 00    	je     801050ba <sys_unlink+0x1ba>
  ilock(dp);
80104f40:	83 ec 0c             	sub    $0xc,%esp
80104f43:	50                   	push   %eax
80104f44:	e8 c7 c7 ff ff       	call   80101710 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104f49:	58                   	pop    %eax
80104f4a:	5a                   	pop    %edx
80104f4b:	68 3c 77 10 80       	push   $0x8010773c
80104f50:	53                   	push   %ebx
80104f51:	e8 ca cc ff ff       	call   80101c20 <namecmp>
80104f56:	83 c4 10             	add    $0x10,%esp
80104f59:	85 c0                	test   %eax,%eax
80104f5b:	0f 84 0f 01 00 00    	je     80105070 <sys_unlink+0x170>
80104f61:	83 ec 08             	sub    $0x8,%esp
80104f64:	68 3b 77 10 80       	push   $0x8010773b
80104f69:	53                   	push   %ebx
80104f6a:	e8 b1 cc ff ff       	call   80101c20 <namecmp>
80104f6f:	83 c4 10             	add    $0x10,%esp
80104f72:	85 c0                	test   %eax,%eax
80104f74:	0f 84 f6 00 00 00    	je     80105070 <sys_unlink+0x170>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104f7a:	83 ec 04             	sub    $0x4,%esp
80104f7d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104f80:	50                   	push   %eax
80104f81:	53                   	push   %ebx
80104f82:	56                   	push   %esi
80104f83:	e8 b8 cc ff ff       	call   80101c40 <dirlookup>
80104f88:	83 c4 10             	add    $0x10,%esp
80104f8b:	89 c3                	mov    %eax,%ebx
80104f8d:	85 c0                	test   %eax,%eax
80104f8f:	0f 84 db 00 00 00    	je     80105070 <sys_unlink+0x170>
  ilock(ip);
80104f95:	83 ec 0c             	sub    $0xc,%esp
80104f98:	50                   	push   %eax
80104f99:	e8 72 c7 ff ff       	call   80101710 <ilock>
  if(ip->nlink < 1)
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104fa6:	0f 8e 37 01 00 00    	jle    801050e3 <sys_unlink+0x1e3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104fac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fb1:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104fb4:	74 6a                	je     80105020 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80104fb6:	83 ec 04             	sub    $0x4,%esp
80104fb9:	6a 10                	push   $0x10
80104fbb:	6a 00                	push   $0x0
80104fbd:	57                   	push   %edi
80104fbe:	e8 ed f5 ff ff       	call   801045b0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104fc3:	6a 10                	push   $0x10
80104fc5:	ff 75 c4             	pushl  -0x3c(%ebp)
80104fc8:	57                   	push   %edi
80104fc9:	56                   	push   %esi
80104fca:	e8 21 cb ff ff       	call   80101af0 <writei>
80104fcf:	83 c4 20             	add    $0x20,%esp
80104fd2:	83 f8 10             	cmp    $0x10,%eax
80104fd5:	0f 85 fb 00 00 00    	jne    801050d6 <sys_unlink+0x1d6>
  if(ip->type == T_DIR){
80104fdb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fe0:	0f 84 aa 00 00 00    	je     80105090 <sys_unlink+0x190>
  iunlockput(dp);
80104fe6:	83 ec 0c             	sub    $0xc,%esp
80104fe9:	56                   	push   %esi
80104fea:	e8 b1 c9 ff ff       	call   801019a0 <iunlockput>
  ip->nlink--;
80104fef:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104ff4:	89 1c 24             	mov    %ebx,(%esp)
80104ff7:	e8 64 c6 ff ff       	call   80101660 <iupdate>
  iunlockput(ip);
80104ffc:	89 1c 24             	mov    %ebx,(%esp)
80104fff:	e8 9c c9 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105004:	e8 f7 dc ff ff       	call   80102d00 <end_op>
  return 0;
80105009:	83 c4 10             	add    $0x10,%esp
8010500c:	31 c0                	xor    %eax,%eax
}
8010500e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105011:	5b                   	pop    %ebx
80105012:	5e                   	pop    %esi
80105013:	5f                   	pop    %edi
80105014:	5d                   	pop    %ebp
80105015:	c3                   	ret    
80105016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010501d:	8d 76 00             	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105020:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105024:	76 90                	jbe    80104fb6 <sys_unlink+0xb6>
80105026:	ba 20 00 00 00       	mov    $0x20,%edx
8010502b:	eb 0f                	jmp    8010503c <sys_unlink+0x13c>
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
80105030:	83 c2 10             	add    $0x10,%edx
80105033:	39 53 58             	cmp    %edx,0x58(%ebx)
80105036:	0f 86 7a ff ff ff    	jbe    80104fb6 <sys_unlink+0xb6>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010503c:	6a 10                	push   $0x10
8010503e:	52                   	push   %edx
8010503f:	57                   	push   %edi
80105040:	53                   	push   %ebx
80105041:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105044:	e8 a7 c9 ff ff       	call   801019f0 <readi>
80105049:	83 c4 10             	add    $0x10,%esp
8010504c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010504f:	83 f8 10             	cmp    $0x10,%eax
80105052:	75 75                	jne    801050c9 <sys_unlink+0x1c9>
    if(de.inum != 0)
80105054:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105059:	74 d5                	je     80105030 <sys_unlink+0x130>
    iunlockput(ip);
8010505b:	83 ec 0c             	sub    $0xc,%esp
8010505e:	53                   	push   %ebx
8010505f:	e8 3c c9 ff ff       	call   801019a0 <iunlockput>
    goto bad;
80105064:	83 c4 10             	add    $0x10,%esp
80105067:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506e:	66 90                	xchg   %ax,%ax
  iunlockput(dp);
80105070:	83 ec 0c             	sub    $0xc,%esp
80105073:	56                   	push   %esi
80105074:	e8 27 c9 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105079:	e8 82 dc ff ff       	call   80102d00 <end_op>
  return -1;
8010507e:	83 c4 10             	add    $0x10,%esp
80105081:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105086:	eb 86                	jmp    8010500e <sys_unlink+0x10e>
80105088:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508f:	90                   	nop
    iupdate(dp);
80105090:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105093:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105098:	56                   	push   %esi
80105099:	e8 c2 c5 ff ff       	call   80101660 <iupdate>
8010509e:	83 c4 10             	add    $0x10,%esp
801050a1:	e9 40 ff ff ff       	jmp    80104fe6 <sys_unlink+0xe6>
801050a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	e9 54 ff ff ff       	jmp    8010500e <sys_unlink+0x10e>
    end_op();
801050ba:	e8 41 dc ff ff       	call   80102d00 <end_op>
    return -1;
801050bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050c4:	e9 45 ff ff ff       	jmp    8010500e <sys_unlink+0x10e>
      panic("isdirempty: readi");
801050c9:	83 ec 0c             	sub    $0xc,%esp
801050cc:	68 60 77 10 80       	push   $0x80107760
801050d1:	e8 ba b2 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801050d6:	83 ec 0c             	sub    $0xc,%esp
801050d9:	68 72 77 10 80       	push   $0x80107772
801050de:	e8 ad b2 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801050e3:	83 ec 0c             	sub    $0xc,%esp
801050e6:	68 4e 77 10 80       	push   $0x8010774e
801050eb:	e8 a0 b2 ff ff       	call   80100390 <panic>

801050f0 <sys_open>:

int
sys_open(void)
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801050f8:	53                   	push   %ebx
801050f9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801050fc:	50                   	push   %eax
801050fd:	6a 00                	push   $0x0
801050ff:	e8 3c f8 ff ff       	call   80104940 <argstr>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
80105109:	0f 88 8e 00 00 00    	js     8010519d <sys_open+0xad>
8010510f:	83 ec 08             	sub    $0x8,%esp
80105112:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105115:	50                   	push   %eax
80105116:	6a 01                	push   $0x1
80105118:	e8 73 f7 ff ff       	call   80104890 <argint>
8010511d:	83 c4 10             	add    $0x10,%esp
80105120:	85 c0                	test   %eax,%eax
80105122:	78 79                	js     8010519d <sys_open+0xad>
    return -1;

  begin_op();
80105124:	e8 67 db ff ff       	call   80102c90 <begin_op>

  if(omode & O_CREATE){
80105129:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
8010512d:	75 79                	jne    801051a8 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
8010512f:	83 ec 0c             	sub    $0xc,%esp
80105132:	ff 75 e0             	pushl  -0x20(%ebp)
80105135:	e8 76 ce ff ff       	call   80101fb0 <namei>
8010513a:	83 c4 10             	add    $0x10,%esp
8010513d:	89 c6                	mov    %eax,%esi
8010513f:	85 c0                	test   %eax,%eax
80105141:	0f 84 7e 00 00 00    	je     801051c5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105147:	83 ec 0c             	sub    $0xc,%esp
8010514a:	50                   	push   %eax
8010514b:	e8 c0 c5 ff ff       	call   80101710 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105150:	83 c4 10             	add    $0x10,%esp
80105153:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105158:	0f 84 c2 00 00 00    	je     80105220 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010515e:	e8 9d bc ff ff       	call   80100e00 <filealloc>
80105163:	89 c7                	mov    %eax,%edi
80105165:	85 c0                	test   %eax,%eax
80105167:	74 23                	je     8010518c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105169:	e8 62 e7 ff ff       	call   801038d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010516e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105170:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105174:	85 d2                	test   %edx,%edx
80105176:	74 60                	je     801051d8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105178:	83 c3 01             	add    $0x1,%ebx
8010517b:	83 fb 10             	cmp    $0x10,%ebx
8010517e:	75 f0                	jne    80105170 <sys_open+0x80>
    if(f)
      fileclose(f);
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	57                   	push   %edi
80105184:	e8 37 bd ff ff       	call   80100ec0 <fileclose>
80105189:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010518c:	83 ec 0c             	sub    $0xc,%esp
8010518f:	56                   	push   %esi
80105190:	e8 0b c8 ff ff       	call   801019a0 <iunlockput>
    end_op();
80105195:	e8 66 db ff ff       	call   80102d00 <end_op>
    return -1;
8010519a:	83 c4 10             	add    $0x10,%esp
8010519d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051a2:	eb 6d                	jmp    80105211 <sys_open+0x121>
801051a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
801051a8:	83 ec 0c             	sub    $0xc,%esp
801051ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
801051ae:	31 c9                	xor    %ecx,%ecx
801051b0:	ba 02 00 00 00       	mov    $0x2,%edx
801051b5:	6a 00                	push   $0x0
801051b7:	e8 24 f8 ff ff       	call   801049e0 <create>
    if(ip == 0){
801051bc:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
801051bf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801051c1:	85 c0                	test   %eax,%eax
801051c3:	75 99                	jne    8010515e <sys_open+0x6e>
      end_op();
801051c5:	e8 36 db ff ff       	call   80102d00 <end_op>
      return -1;
801051ca:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801051cf:	eb 40                	jmp    80105211 <sys_open+0x121>
801051d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801051d8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801051db:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801051df:	56                   	push   %esi
801051e0:	e8 0b c6 ff ff       	call   801017f0 <iunlock>
  end_op();
801051e5:	e8 16 db ff ff       	call   80102d00 <end_op>

  f->type = FD_INODE;
801051ea:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801051f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801051f3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801051f6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801051f9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801051fb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105202:	f7 d0                	not    %eax
80105204:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105207:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
8010520a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010520d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105211:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105214:	89 d8                	mov    %ebx,%eax
80105216:	5b                   	pop    %ebx
80105217:	5e                   	pop    %esi
80105218:	5f                   	pop    %edi
80105219:	5d                   	pop    %ebp
8010521a:	c3                   	ret    
8010521b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010521f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105220:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105223:	85 c9                	test   %ecx,%ecx
80105225:	0f 84 33 ff ff ff    	je     8010515e <sys_open+0x6e>
8010522b:	e9 5c ff ff ff       	jmp    8010518c <sys_open+0x9c>

80105230 <sys_mkdir>:

int
sys_mkdir(void)
{
80105230:	55                   	push   %ebp
80105231:	89 e5                	mov    %esp,%ebp
80105233:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105236:	e8 55 da ff ff       	call   80102c90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010523b:	83 ec 08             	sub    $0x8,%esp
8010523e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105241:	50                   	push   %eax
80105242:	6a 00                	push   $0x0
80105244:	e8 f7 f6 ff ff       	call   80104940 <argstr>
80105249:	83 c4 10             	add    $0x10,%esp
8010524c:	85 c0                	test   %eax,%eax
8010524e:	78 30                	js     80105280 <sys_mkdir+0x50>
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105256:	31 c9                	xor    %ecx,%ecx
80105258:	ba 01 00 00 00       	mov    $0x1,%edx
8010525d:	6a 00                	push   $0x0
8010525f:	e8 7c f7 ff ff       	call   801049e0 <create>
80105264:	83 c4 10             	add    $0x10,%esp
80105267:	85 c0                	test   %eax,%eax
80105269:	74 15                	je     80105280 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010526b:	83 ec 0c             	sub    $0xc,%esp
8010526e:	50                   	push   %eax
8010526f:	e8 2c c7 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105274:	e8 87 da ff ff       	call   80102d00 <end_op>
  return 0;
80105279:	83 c4 10             	add    $0x10,%esp
8010527c:	31 c0                	xor    %eax,%eax
}
8010527e:	c9                   	leave  
8010527f:	c3                   	ret    
    end_op();
80105280:	e8 7b da ff ff       	call   80102d00 <end_op>
    return -1;
80105285:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010528a:	c9                   	leave  
8010528b:	c3                   	ret    
8010528c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_mknod>:

int
sys_mknod(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105296:	e8 f5 d9 ff ff       	call   80102c90 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010529b:	83 ec 08             	sub    $0x8,%esp
8010529e:	8d 45 ec             	lea    -0x14(%ebp),%eax
801052a1:	50                   	push   %eax
801052a2:	6a 00                	push   $0x0
801052a4:	e8 97 f6 ff ff       	call   80104940 <argstr>
801052a9:	83 c4 10             	add    $0x10,%esp
801052ac:	85 c0                	test   %eax,%eax
801052ae:	78 60                	js     80105310 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801052b0:	83 ec 08             	sub    $0x8,%esp
801052b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801052b6:	50                   	push   %eax
801052b7:	6a 01                	push   $0x1
801052b9:	e8 d2 f5 ff ff       	call   80104890 <argint>
  if((argstr(0, &path)) < 0 ||
801052be:	83 c4 10             	add    $0x10,%esp
801052c1:	85 c0                	test   %eax,%eax
801052c3:	78 4b                	js     80105310 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801052c5:	83 ec 08             	sub    $0x8,%esp
801052c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052cb:	50                   	push   %eax
801052cc:	6a 02                	push   $0x2
801052ce:	e8 bd f5 ff ff       	call   80104890 <argint>
     argint(1, &major) < 0 ||
801052d3:	83 c4 10             	add    $0x10,%esp
801052d6:	85 c0                	test   %eax,%eax
801052d8:	78 36                	js     80105310 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801052da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801052de:	83 ec 0c             	sub    $0xc,%esp
801052e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801052e5:	ba 03 00 00 00       	mov    $0x3,%edx
801052ea:	50                   	push   %eax
801052eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801052ee:	e8 ed f6 ff ff       	call   801049e0 <create>
     argint(2, &minor) < 0 ||
801052f3:	83 c4 10             	add    $0x10,%esp
801052f6:	85 c0                	test   %eax,%eax
801052f8:	74 16                	je     80105310 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801052fa:	83 ec 0c             	sub    $0xc,%esp
801052fd:	50                   	push   %eax
801052fe:	e8 9d c6 ff ff       	call   801019a0 <iunlockput>
  end_op();
80105303:	e8 f8 d9 ff ff       	call   80102d00 <end_op>
  return 0;
80105308:	83 c4 10             	add    $0x10,%esp
8010530b:	31 c0                	xor    %eax,%eax
}
8010530d:	c9                   	leave  
8010530e:	c3                   	ret    
8010530f:	90                   	nop
    end_op();
80105310:	e8 eb d9 ff ff       	call   80102d00 <end_op>
    return -1;
80105315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010531a:	c9                   	leave  
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105320 <sys_chdir>:

int
sys_chdir(void)
{
80105320:	55                   	push   %ebp
80105321:	89 e5                	mov    %esp,%ebp
80105323:	56                   	push   %esi
80105324:	53                   	push   %ebx
80105325:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105328:	e8 a3 e5 ff ff       	call   801038d0 <myproc>
8010532d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010532f:	e8 5c d9 ff ff       	call   80102c90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105334:	83 ec 08             	sub    $0x8,%esp
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533a:	50                   	push   %eax
8010533b:	6a 00                	push   $0x0
8010533d:	e8 fe f5 ff ff       	call   80104940 <argstr>
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	85 c0                	test   %eax,%eax
80105347:	78 77                	js     801053c0 <sys_chdir+0xa0>
80105349:	83 ec 0c             	sub    $0xc,%esp
8010534c:	ff 75 f4             	pushl  -0xc(%ebp)
8010534f:	e8 5c cc ff ff       	call   80101fb0 <namei>
80105354:	83 c4 10             	add    $0x10,%esp
80105357:	89 c3                	mov    %eax,%ebx
80105359:	85 c0                	test   %eax,%eax
8010535b:	74 63                	je     801053c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010535d:	83 ec 0c             	sub    $0xc,%esp
80105360:	50                   	push   %eax
80105361:	e8 aa c3 ff ff       	call   80101710 <ilock>
  if(ip->type != T_DIR){
80105366:	83 c4 10             	add    $0x10,%esp
80105369:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010536e:	75 30                	jne    801053a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	53                   	push   %ebx
80105374:	e8 77 c4 ff ff       	call   801017f0 <iunlock>
  iput(curproc->cwd);
80105379:	58                   	pop    %eax
8010537a:	ff 76 68             	pushl  0x68(%esi)
8010537d:	e8 be c4 ff ff       	call   80101840 <iput>
  end_op();
80105382:	e8 79 d9 ff ff       	call   80102d00 <end_op>
  curproc->cwd = ip;
80105387:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010538a:	83 c4 10             	add    $0x10,%esp
8010538d:	31 c0                	xor    %eax,%eax
}
8010538f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105392:	5b                   	pop    %ebx
80105393:	5e                   	pop    %esi
80105394:	5d                   	pop    %ebp
80105395:	c3                   	ret    
80105396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010539d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801053a0:	83 ec 0c             	sub    $0xc,%esp
801053a3:	53                   	push   %ebx
801053a4:	e8 f7 c5 ff ff       	call   801019a0 <iunlockput>
    end_op();
801053a9:	e8 52 d9 ff ff       	call   80102d00 <end_op>
    return -1;
801053ae:	83 c4 10             	add    $0x10,%esp
801053b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053b6:	eb d7                	jmp    8010538f <sys_chdir+0x6f>
801053b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bf:	90                   	nop
    end_op();
801053c0:	e8 3b d9 ff ff       	call   80102d00 <end_op>
    return -1;
801053c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053ca:	eb c3                	jmp    8010538f <sys_chdir+0x6f>
801053cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053d0 <sys_exec>:

int
sys_exec(void)
{
801053d0:	55                   	push   %ebp
801053d1:	89 e5                	mov    %esp,%ebp
801053d3:	57                   	push   %edi
801053d4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053d5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801053db:	53                   	push   %ebx
801053dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801053e2:	50                   	push   %eax
801053e3:	6a 00                	push   $0x0
801053e5:	e8 56 f5 ff ff       	call   80104940 <argstr>
801053ea:	83 c4 10             	add    $0x10,%esp
801053ed:	85 c0                	test   %eax,%eax
801053ef:	0f 88 87 00 00 00    	js     8010547c <sys_exec+0xac>
801053f5:	83 ec 08             	sub    $0x8,%esp
801053f8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801053fe:	50                   	push   %eax
801053ff:	6a 01                	push   $0x1
80105401:	e8 8a f4 ff ff       	call   80104890 <argint>
80105406:	83 c4 10             	add    $0x10,%esp
80105409:	85 c0                	test   %eax,%eax
8010540b:	78 6f                	js     8010547c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010540d:	83 ec 04             	sub    $0x4,%esp
80105410:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105416:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105418:	68 80 00 00 00       	push   $0x80
8010541d:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105423:	6a 00                	push   $0x0
80105425:	50                   	push   %eax
80105426:	e8 85 f1 ff ff       	call   801045b0 <memset>
8010542b:	83 c4 10             	add    $0x10,%esp
8010542e:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105430:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105436:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
8010543d:	83 ec 08             	sub    $0x8,%esp
80105440:	57                   	push   %edi
80105441:	01 f0                	add    %esi,%eax
80105443:	50                   	push   %eax
80105444:	e8 a7 f3 ff ff       	call   801047f0 <fetchint>
80105449:	83 c4 10             	add    $0x10,%esp
8010544c:	85 c0                	test   %eax,%eax
8010544e:	78 2c                	js     8010547c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105450:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105456:	85 c0                	test   %eax,%eax
80105458:	74 36                	je     80105490 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010545a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105460:	83 ec 08             	sub    $0x8,%esp
80105463:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105466:	52                   	push   %edx
80105467:	50                   	push   %eax
80105468:	e8 c3 f3 ff ff       	call   80104830 <fetchstr>
8010546d:	83 c4 10             	add    $0x10,%esp
80105470:	85 c0                	test   %eax,%eax
80105472:	78 08                	js     8010547c <sys_exec+0xac>
  for(i=0;; i++){
80105474:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105477:	83 fb 20             	cmp    $0x20,%ebx
8010547a:	75 b4                	jne    80105430 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010547c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010547f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105484:	5b                   	pop    %ebx
80105485:	5e                   	pop    %esi
80105486:	5f                   	pop    %edi
80105487:	5d                   	pop    %ebp
80105488:	c3                   	ret    
80105489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105490:	83 ec 08             	sub    $0x8,%esp
80105493:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105499:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801054a0:	00 00 00 00 
  return exec(path, argv);
801054a4:	50                   	push   %eax
801054a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801054ab:	e8 d0 b5 ff ff       	call   80100a80 <exec>
801054b0:	83 c4 10             	add    $0x10,%esp
}
801054b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b6:	5b                   	pop    %ebx
801054b7:	5e                   	pop    %esi
801054b8:	5f                   	pop    %edi
801054b9:	5d                   	pop    %ebp
801054ba:	c3                   	ret    
801054bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054bf:	90                   	nop

801054c0 <sys_pipe>:

int
sys_pipe(void)
{
801054c0:	55                   	push   %ebp
801054c1:	89 e5                	mov    %esp,%ebp
801054c3:	57                   	push   %edi
801054c4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054c5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801054c8:	53                   	push   %ebx
801054c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801054cc:	6a 08                	push   $0x8
801054ce:	50                   	push   %eax
801054cf:	6a 00                	push   $0x0
801054d1:	e8 0a f4 ff ff       	call   801048e0 <argptr>
801054d6:	83 c4 10             	add    $0x10,%esp
801054d9:	85 c0                	test   %eax,%eax
801054db:	78 4a                	js     80105527 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801054dd:	83 ec 08             	sub    $0x8,%esp
801054e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801054e3:	50                   	push   %eax
801054e4:	8d 45 e0             	lea    -0x20(%ebp),%eax
801054e7:	50                   	push   %eax
801054e8:	e8 53 de ff ff       	call   80103340 <pipealloc>
801054ed:	83 c4 10             	add    $0x10,%esp
801054f0:	85 c0                	test   %eax,%eax
801054f2:	78 33                	js     80105527 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801054f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801054f7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801054f9:	e8 d2 e3 ff ff       	call   801038d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054fe:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105500:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105504:	85 f6                	test   %esi,%esi
80105506:	74 28                	je     80105530 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105508:	83 c3 01             	add    $0x1,%ebx
8010550b:	83 fb 10             	cmp    $0x10,%ebx
8010550e:	75 f0                	jne    80105500 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105510:	83 ec 0c             	sub    $0xc,%esp
80105513:	ff 75 e0             	pushl  -0x20(%ebp)
80105516:	e8 a5 b9 ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
8010551b:	58                   	pop    %eax
8010551c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010551f:	e8 9c b9 ff ff       	call   80100ec0 <fileclose>
    return -1;
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010552c:	eb 53                	jmp    80105581 <sys_pipe+0xc1>
8010552e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105530:	8d 73 08             	lea    0x8(%ebx),%esi
80105533:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105537:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
8010553a:	e8 91 e3 ff ff       	call   801038d0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010553f:	31 d2                	xor    %edx,%edx
80105541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105548:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010554c:	85 c9                	test   %ecx,%ecx
8010554e:	74 20                	je     80105570 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105550:	83 c2 01             	add    $0x1,%edx
80105553:	83 fa 10             	cmp    $0x10,%edx
80105556:	75 f0                	jne    80105548 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105558:	e8 73 e3 ff ff       	call   801038d0 <myproc>
8010555d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105564:	00 
80105565:	eb a9                	jmp    80105510 <sys_pipe+0x50>
80105567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010556e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105570:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105574:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105577:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105579:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010557c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010557f:	31 c0                	xor    %eax,%eax
}
80105581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105584:	5b                   	pop    %ebx
80105585:	5e                   	pop    %esi
80105586:	5f                   	pop    %edi
80105587:	5d                   	pop    %ebp
80105588:	c3                   	ret    
80105589:	66 90                	xchg   %ax,%ax
8010558b:	66 90                	xchg   %ax,%ax
8010558d:	66 90                	xchg   %ax,%ax
8010558f:	90                   	nop

80105590 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105590:	e9 db e4 ff ff       	jmp    80103a70 <fork>
80105595:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010559c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055a0 <sys_exit>:
}

int
sys_exit(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	83 ec 08             	sub    $0x8,%esp
  exit();
801055a6:	e8 45 e7 ff ff       	call   80103cf0 <exit>
  return 0;  // not reached
}
801055ab:	31 c0                	xor    %eax,%eax
801055ad:	c9                   	leave  
801055ae:	c3                   	ret    
801055af:	90                   	nop

801055b0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
801055b0:	e9 7b e9 ff ff       	jmp    80103f30 <wait>
801055b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_kill>:
}

int
sys_kill(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801055c6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055c9:	50                   	push   %eax
801055ca:	6a 00                	push   $0x0
801055cc:	e8 bf f2 ff ff       	call   80104890 <argint>
801055d1:	83 c4 10             	add    $0x10,%esp
801055d4:	85 c0                	test   %eax,%eax
801055d6:	78 18                	js     801055f0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055d8:	83 ec 0c             	sub    $0xc,%esp
801055db:	ff 75 f4             	pushl  -0xc(%ebp)
801055de:	e8 9d ea ff ff       	call   80104080 <kill>
801055e3:	83 c4 10             	add    $0x10,%esp
}
801055e6:	c9                   	leave  
801055e7:	c3                   	ret    
801055e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop
801055f0:	c9                   	leave  
    return -1;
801055f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055f6:	c3                   	ret    
801055f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055fe:	66 90                	xchg   %ax,%ax

80105600 <sys_getpid>:

int
sys_getpid(void)
{
80105600:	55                   	push   %ebp
80105601:	89 e5                	mov    %esp,%ebp
80105603:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105606:	e8 c5 e2 ff ff       	call   801038d0 <myproc>
8010560b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010560e:	c9                   	leave  
8010560f:	c3                   	ret    

80105610 <sys_sbrk>:

int
sys_sbrk(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105614:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105617:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010561a:	50                   	push   %eax
8010561b:	6a 00                	push   $0x0
8010561d:	e8 6e f2 ff ff       	call   80104890 <argint>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	78 27                	js     80105650 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105629:	e8 a2 e2 ff ff       	call   801038d0 <myproc>
  if(growproc(n) < 0)
8010562e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105631:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105633:	ff 75 f4             	pushl  -0xc(%ebp)
80105636:	e8 b5 e3 ff ff       	call   801039f0 <growproc>
8010563b:	83 c4 10             	add    $0x10,%esp
8010563e:	85 c0                	test   %eax,%eax
80105640:	78 0e                	js     80105650 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105642:	89 d8                	mov    %ebx,%eax
80105644:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105647:	c9                   	leave  
80105648:	c3                   	ret    
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105650:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105655:	eb eb                	jmp    80105642 <sys_sbrk+0x32>
80105657:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010565e:	66 90                	xchg   %ax,%ax

80105660 <sys_sleep>:

int
sys_sleep(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105664:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105667:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010566a:	50                   	push   %eax
8010566b:	6a 00                	push   $0x0
8010566d:	e8 1e f2 ff ff       	call   80104890 <argint>
80105672:	83 c4 10             	add    $0x10,%esp
80105675:	85 c0                	test   %eax,%eax
80105677:	0f 88 8a 00 00 00    	js     80105707 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
8010567d:	83 ec 0c             	sub    $0xc,%esp
80105680:	68 60 4c 11 80       	push   $0x80114c60
80105685:	e8 16 ee ff ff       	call   801044a0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010568a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
8010568d:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  while(ticks - ticks0 < n){
80105693:	83 c4 10             	add    $0x10,%esp
80105696:	85 d2                	test   %edx,%edx
80105698:	75 27                	jne    801056c1 <sys_sleep+0x61>
8010569a:	eb 54                	jmp    801056f0 <sys_sleep+0x90>
8010569c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056a0:	83 ec 08             	sub    $0x8,%esp
801056a3:	68 60 4c 11 80       	push   $0x80114c60
801056a8:	68 a0 54 11 80       	push   $0x801154a0
801056ad:	e8 be e7 ff ff       	call   80103e70 <sleep>
  while(ticks - ticks0 < n){
801056b2:	a1 a0 54 11 80       	mov    0x801154a0,%eax
801056b7:	83 c4 10             	add    $0x10,%esp
801056ba:	29 d8                	sub    %ebx,%eax
801056bc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801056bf:	73 2f                	jae    801056f0 <sys_sleep+0x90>
    if(myproc()->killed){
801056c1:	e8 0a e2 ff ff       	call   801038d0 <myproc>
801056c6:	8b 40 24             	mov    0x24(%eax),%eax
801056c9:	85 c0                	test   %eax,%eax
801056cb:	74 d3                	je     801056a0 <sys_sleep+0x40>
      release(&tickslock);
801056cd:	83 ec 0c             	sub    $0xc,%esp
801056d0:	68 60 4c 11 80       	push   $0x80114c60
801056d5:	e8 86 ee ff ff       	call   80104560 <release>
      return -1;
801056da:	83 c4 10             	add    $0x10,%esp
801056dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
801056e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056e5:	c9                   	leave  
801056e6:	c3                   	ret    
801056e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	68 60 4c 11 80       	push   $0x80114c60
801056f8:	e8 63 ee ff ff       	call   80104560 <release>
  return 0;
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	31 c0                	xor    %eax,%eax
}
80105702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105705:	c9                   	leave  
80105706:	c3                   	ret    
    return -1;
80105707:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570c:	eb f4                	jmp    80105702 <sys_sleep+0xa2>
8010570e:	66 90                	xchg   %ax,%ax

80105710 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	53                   	push   %ebx
80105714:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105717:	68 60 4c 11 80       	push   $0x80114c60
8010571c:	e8 7f ed ff ff       	call   801044a0 <acquire>
  xticks = ticks;
80105721:	8b 1d a0 54 11 80    	mov    0x801154a0,%ebx
  release(&tickslock);
80105727:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
8010572e:	e8 2d ee ff ff       	call   80104560 <release>
  return xticks;
}
80105733:	89 d8                	mov    %ebx,%eax
80105735:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105738:	c9                   	leave  
80105739:	c3                   	ret    
8010573a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105740 <sys_getChild>:

int
sys_getChild(int processID) 
{
	return getChild(processID);
80105740:	e9 7b ea ff ff       	jmp    801041c0 <getChild>
80105745:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105750 <sys_getCount>:
}

int
sys_getCount(int a)
{
	return getCount(a);
80105750:	e9 ab ea ff ff       	jmp    80104200 <getCount>

80105755 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105755:	1e                   	push   %ds
  pushl %es
80105756:	06                   	push   %es
  pushl %fs
80105757:	0f a0                	push   %fs
  pushl %gs
80105759:	0f a8                	push   %gs
  pushal
8010575b:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
8010575c:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105760:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105762:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105764:	54                   	push   %esp
  call trap
80105765:	e8 c6 00 00 00       	call   80105830 <trap>
  addl $4, %esp
8010576a:	83 c4 04             	add    $0x4,%esp

8010576d <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010576d:	61                   	popa   
  popl %gs
8010576e:	0f a9                	pop    %gs
  popl %fs
80105770:	0f a1                	pop    %fs
  popl %es
80105772:	07                   	pop    %es
  popl %ds
80105773:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105774:	83 c4 08             	add    $0x8,%esp
  iret
80105777:	cf                   	iret   
80105778:	66 90                	xchg   %ax,%ax
8010577a:	66 90                	xchg   %ax,%ax
8010577c:	66 90                	xchg   %ax,%ax
8010577e:	66 90                	xchg   %ax,%ax

80105780 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105780:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105781:	31 c0                	xor    %eax,%eax
{
80105783:	89 e5                	mov    %esp,%ebp
80105785:	83 ec 08             	sub    $0x8,%esp
80105788:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105790:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105797:	c7 04 c5 a2 4c 11 80 	movl   $0x8e000008,-0x7feeb35e(,%eax,8)
8010579e:	08 00 00 8e 
801057a2:	66 89 14 c5 a0 4c 11 	mov    %dx,-0x7feeb360(,%eax,8)
801057a9:	80 
801057aa:	c1 ea 10             	shr    $0x10,%edx
801057ad:	66 89 14 c5 a6 4c 11 	mov    %dx,-0x7feeb35a(,%eax,8)
801057b4:	80 
  for(i = 0; i < 256; i++)
801057b5:	83 c0 01             	add    $0x1,%eax
801057b8:	3d 00 01 00 00       	cmp    $0x100,%eax
801057bd:	75 d1                	jne    80105790 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801057bf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057c2:	a1 08 a1 10 80       	mov    0x8010a108,%eax
801057c7:	c7 05 a2 4e 11 80 08 	movl   $0xef000008,0x80114ea2
801057ce:	00 00 ef 
  initlock(&tickslock, "time");
801057d1:	68 81 77 10 80       	push   $0x80107781
801057d6:	68 60 4c 11 80       	push   $0x80114c60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801057db:	66 a3 a0 4e 11 80    	mov    %ax,0x80114ea0
801057e1:	c1 e8 10             	shr    $0x10,%eax
801057e4:	66 a3 a6 4e 11 80    	mov    %ax,0x80114ea6
  initlock(&tickslock, "time");
801057ea:	e8 51 eb ff ff       	call   80104340 <initlock>
}
801057ef:	83 c4 10             	add    $0x10,%esp
801057f2:	c9                   	leave  
801057f3:	c3                   	ret    
801057f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057ff:	90                   	nop

80105800 <idtinit>:

void
idtinit(void)
{
80105800:	55                   	push   %ebp
  pd[0] = size-1;
80105801:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105806:	89 e5                	mov    %esp,%ebp
80105808:	83 ec 10             	sub    $0x10,%esp
8010580b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010580f:	b8 a0 4c 11 80       	mov    $0x80114ca0,%eax
80105814:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105818:	c1 e8 10             	shr    $0x10,%eax
8010581b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010581f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105822:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105825:	c9                   	leave  
80105826:	c3                   	ret    
80105827:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010582e:	66 90                	xchg   %ax,%ax

80105830 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105830:	55                   	push   %ebp
80105831:	89 e5                	mov    %esp,%ebp
80105833:	57                   	push   %edi
80105834:	56                   	push   %esi
80105835:	53                   	push   %ebx
80105836:	83 ec 1c             	sub    $0x1c,%esp
80105839:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
8010583c:	8b 47 30             	mov    0x30(%edi),%eax
8010583f:	83 f8 40             	cmp    $0x40,%eax
80105842:	0f 84 b8 01 00 00    	je     80105a00 <trap+0x1d0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105848:	83 e8 20             	sub    $0x20,%eax
8010584b:	83 f8 1f             	cmp    $0x1f,%eax
8010584e:	77 10                	ja     80105860 <trap+0x30>
80105850:	ff 24 85 28 78 10 80 	jmp    *-0x7fef87d8(,%eax,4)
80105857:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010585e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105860:	e8 6b e0 ff ff       	call   801038d0 <myproc>
80105865:	8b 5f 38             	mov    0x38(%edi),%ebx
80105868:	85 c0                	test   %eax,%eax
8010586a:	0f 84 17 02 00 00    	je     80105a87 <trap+0x257>
80105870:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105874:	0f 84 0d 02 00 00    	je     80105a87 <trap+0x257>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010587a:	0f 20 d1             	mov    %cr2,%ecx
8010587d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105880:	e8 2b e0 ff ff       	call   801038b0 <cpuid>
80105885:	8b 77 30             	mov    0x30(%edi),%esi
80105888:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010588b:	8b 47 34             	mov    0x34(%edi),%eax
8010588e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105891:	e8 3a e0 ff ff       	call   801038d0 <myproc>
80105896:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105899:	e8 32 e0 ff ff       	call   801038d0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010589e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
801058a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
801058a4:	51                   	push   %ecx
801058a5:	53                   	push   %ebx
801058a6:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
801058a7:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058aa:	ff 75 e4             	pushl  -0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
801058ad:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058b0:	56                   	push   %esi
801058b1:	52                   	push   %edx
801058b2:	ff 70 10             	pushl  0x10(%eax)
801058b5:	68 e4 77 10 80       	push   $0x801077e4
801058ba:	e8 f1 ad ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801058bf:	83 c4 20             	add    $0x20,%esp
801058c2:	e8 09 e0 ff ff       	call   801038d0 <myproc>
801058c7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801058ce:	e8 fd df ff ff       	call   801038d0 <myproc>
801058d3:	85 c0                	test   %eax,%eax
801058d5:	74 1d                	je     801058f4 <trap+0xc4>
801058d7:	e8 f4 df ff ff       	call   801038d0 <myproc>
801058dc:	8b 50 24             	mov    0x24(%eax),%edx
801058df:	85 d2                	test   %edx,%edx
801058e1:	74 11                	je     801058f4 <trap+0xc4>
801058e3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801058e7:	83 e0 03             	and    $0x3,%eax
801058ea:	66 83 f8 03          	cmp    $0x3,%ax
801058ee:	0f 84 44 01 00 00    	je     80105a38 <trap+0x208>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801058f4:	e8 d7 df ff ff       	call   801038d0 <myproc>
801058f9:	85 c0                	test   %eax,%eax
801058fb:	74 0b                	je     80105908 <trap+0xd8>
801058fd:	e8 ce df ff ff       	call   801038d0 <myproc>
80105902:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105906:	74 38                	je     80105940 <trap+0x110>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105908:	e8 c3 df ff ff       	call   801038d0 <myproc>
8010590d:	85 c0                	test   %eax,%eax
8010590f:	74 1d                	je     8010592e <trap+0xfe>
80105911:	e8 ba df ff ff       	call   801038d0 <myproc>
80105916:	8b 40 24             	mov    0x24(%eax),%eax
80105919:	85 c0                	test   %eax,%eax
8010591b:	74 11                	je     8010592e <trap+0xfe>
8010591d:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105921:	83 e0 03             	and    $0x3,%eax
80105924:	66 83 f8 03          	cmp    $0x3,%ax
80105928:	0f 84 fb 00 00 00    	je     80105a29 <trap+0x1f9>
    exit();
}
8010592e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105931:	5b                   	pop    %ebx
80105932:	5e                   	pop    %esi
80105933:	5f                   	pop    %edi
80105934:	5d                   	pop    %ebp
80105935:	c3                   	ret    
80105936:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010593d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105940:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105944:	75 c2                	jne    80105908 <trap+0xd8>
    yield();
80105946:	e8 d5 e4 ff ff       	call   80103e20 <yield>
8010594b:	eb bb                	jmp    80105908 <trap+0xd8>
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105950:	e8 5b df ff ff       	call   801038b0 <cpuid>
80105955:	85 c0                	test   %eax,%eax
80105957:	0f 84 eb 00 00 00    	je     80105a48 <trap+0x218>
    lapiceoi();
8010595d:	e8 de ce ff ff       	call   80102840 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105962:	e8 69 df ff ff       	call   801038d0 <myproc>
80105967:	85 c0                	test   %eax,%eax
80105969:	0f 85 68 ff ff ff    	jne    801058d7 <trap+0xa7>
8010596f:	eb 83                	jmp    801058f4 <trap+0xc4>
80105971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105978:	e8 83 cd ff ff       	call   80102700 <kbdintr>
    lapiceoi();
8010597d:	e8 be ce ff ff       	call   80102840 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105982:	e8 49 df ff ff       	call   801038d0 <myproc>
80105987:	85 c0                	test   %eax,%eax
80105989:	0f 85 48 ff ff ff    	jne    801058d7 <trap+0xa7>
8010598f:	e9 60 ff ff ff       	jmp    801058f4 <trap+0xc4>
80105994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105998:	e8 83 02 00 00       	call   80105c20 <uartintr>
    lapiceoi();
8010599d:	e8 9e ce ff ff       	call   80102840 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059a2:	e8 29 df ff ff       	call   801038d0 <myproc>
801059a7:	85 c0                	test   %eax,%eax
801059a9:	0f 85 28 ff ff ff    	jne    801058d7 <trap+0xa7>
801059af:	e9 40 ff ff ff       	jmp    801058f4 <trap+0xc4>
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801059b8:	8b 77 38             	mov    0x38(%edi),%esi
801059bb:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
801059bf:	e8 ec de ff ff       	call   801038b0 <cpuid>
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
801059c6:	50                   	push   %eax
801059c7:	68 8c 77 10 80       	push   $0x8010778c
801059cc:	e8 df ac ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801059d1:	e8 6a ce ff ff       	call   80102840 <lapiceoi>
    break;
801059d6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d9:	e8 f2 de ff ff       	call   801038d0 <myproc>
801059de:	85 c0                	test   %eax,%eax
801059e0:	0f 85 f1 fe ff ff    	jne    801058d7 <trap+0xa7>
801059e6:	e9 09 ff ff ff       	jmp    801058f4 <trap+0xc4>
801059eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop
    ideintr();
801059f0:	e8 5b c7 ff ff       	call   80102150 <ideintr>
801059f5:	e9 63 ff ff ff       	jmp    8010595d <trap+0x12d>
801059fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105a00:	e8 cb de ff ff       	call   801038d0 <myproc>
80105a05:	8b 58 24             	mov    0x24(%eax),%ebx
80105a08:	85 db                	test   %ebx,%ebx
80105a0a:	75 74                	jne    80105a80 <trap+0x250>
    myproc()->tf = tf;
80105a0c:	e8 bf de ff ff       	call   801038d0 <myproc>
80105a11:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105a14:	e8 67 ef ff ff       	call   80104980 <syscall>
    if(myproc()->killed)
80105a19:	e8 b2 de ff ff       	call   801038d0 <myproc>
80105a1e:	8b 48 24             	mov    0x24(%eax),%ecx
80105a21:	85 c9                	test   %ecx,%ecx
80105a23:	0f 84 05 ff ff ff    	je     8010592e <trap+0xfe>
}
80105a29:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a2c:	5b                   	pop    %ebx
80105a2d:	5e                   	pop    %esi
80105a2e:	5f                   	pop    %edi
80105a2f:	5d                   	pop    %ebp
      exit();
80105a30:	e9 bb e2 ff ff       	jmp    80103cf0 <exit>
80105a35:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105a38:	e8 b3 e2 ff ff       	call   80103cf0 <exit>
80105a3d:	e9 b2 fe ff ff       	jmp    801058f4 <trap+0xc4>
80105a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	68 60 4c 11 80       	push   $0x80114c60
80105a50:	e8 4b ea ff ff       	call   801044a0 <acquire>
      wakeup(&ticks);
80105a55:	c7 04 24 a0 54 11 80 	movl   $0x801154a0,(%esp)
      ticks++;
80105a5c:	83 05 a0 54 11 80 01 	addl   $0x1,0x801154a0
      wakeup(&ticks);
80105a63:	e8 b8 e5 ff ff       	call   80104020 <wakeup>
      release(&tickslock);
80105a68:	c7 04 24 60 4c 11 80 	movl   $0x80114c60,(%esp)
80105a6f:	e8 ec ea ff ff       	call   80104560 <release>
80105a74:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105a77:	e9 e1 fe ff ff       	jmp    8010595d <trap+0x12d>
80105a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      exit();
80105a80:	e8 6b e2 ff ff       	call   80103cf0 <exit>
80105a85:	eb 85                	jmp    80105a0c <trap+0x1dc>
80105a87:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105a8a:	e8 21 de ff ff       	call   801038b0 <cpuid>
80105a8f:	83 ec 0c             	sub    $0xc,%esp
80105a92:	56                   	push   %esi
80105a93:	53                   	push   %ebx
80105a94:	50                   	push   %eax
80105a95:	ff 77 30             	pushl  0x30(%edi)
80105a98:	68 b0 77 10 80       	push   $0x801077b0
80105a9d:	e8 0e ac ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105aa2:	83 c4 14             	add    $0x14,%esp
80105aa5:	68 86 77 10 80       	push   $0x80107786
80105aaa:	e8 e1 a8 ff ff       	call   80100390 <panic>
80105aaf:	90                   	nop

80105ab0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ab0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105ab5:	85 c0                	test   %eax,%eax
80105ab7:	74 17                	je     80105ad0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105ab9:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105abe:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105abf:	a8 01                	test   $0x1,%al
80105ac1:	74 0d                	je     80105ad0 <uartgetc+0x20>
80105ac3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ac8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ac9:	0f b6 c0             	movzbl %al,%eax
80105acc:	c3                   	ret    
80105acd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ad5:	c3                   	ret    
80105ad6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105add:	8d 76 00             	lea    0x0(%esi),%esi

80105ae0 <uartputc.part.0>:
uartputc(int c)
80105ae0:	55                   	push   %ebp
80105ae1:	89 e5                	mov    %esp,%ebp
80105ae3:	57                   	push   %edi
80105ae4:	89 c7                	mov    %eax,%edi
80105ae6:	56                   	push   %esi
80105ae7:	be fd 03 00 00       	mov    $0x3fd,%esi
80105aec:	53                   	push   %ebx
80105aed:	bb 80 00 00 00       	mov    $0x80,%ebx
80105af2:	83 ec 0c             	sub    $0xc,%esp
80105af5:	eb 1b                	jmp    80105b12 <uartputc.part.0+0x32>
80105af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105afe:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105b00:	83 ec 0c             	sub    $0xc,%esp
80105b03:	6a 0a                	push   $0xa
80105b05:	e8 56 cd ff ff       	call   80102860 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b0a:	83 c4 10             	add    $0x10,%esp
80105b0d:	83 eb 01             	sub    $0x1,%ebx
80105b10:	74 07                	je     80105b19 <uartputc.part.0+0x39>
80105b12:	89 f2                	mov    %esi,%edx
80105b14:	ec                   	in     (%dx),%al
80105b15:	a8 20                	test   $0x20,%al
80105b17:	74 e7                	je     80105b00 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b19:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b1e:	89 f8                	mov    %edi,%eax
80105b20:	ee                   	out    %al,(%dx)
}
80105b21:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b24:	5b                   	pop    %ebx
80105b25:	5e                   	pop    %esi
80105b26:	5f                   	pop    %edi
80105b27:	5d                   	pop    %ebp
80105b28:	c3                   	ret    
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b30 <uartinit>:
{
80105b30:	55                   	push   %ebp
80105b31:	31 c9                	xor    %ecx,%ecx
80105b33:	89 c8                	mov    %ecx,%eax
80105b35:	89 e5                	mov    %esp,%ebp
80105b37:	57                   	push   %edi
80105b38:	56                   	push   %esi
80105b39:	53                   	push   %ebx
80105b3a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b3f:	89 da                	mov    %ebx,%edx
80105b41:	83 ec 0c             	sub    $0xc,%esp
80105b44:	ee                   	out    %al,(%dx)
80105b45:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b4a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b4f:	89 fa                	mov    %edi,%edx
80105b51:	ee                   	out    %al,(%dx)
80105b52:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b57:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b5c:	ee                   	out    %al,(%dx)
80105b5d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b62:	89 c8                	mov    %ecx,%eax
80105b64:	89 f2                	mov    %esi,%edx
80105b66:	ee                   	out    %al,(%dx)
80105b67:	b8 03 00 00 00       	mov    $0x3,%eax
80105b6c:	89 fa                	mov    %edi,%edx
80105b6e:	ee                   	out    %al,(%dx)
80105b6f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105b74:	89 c8                	mov    %ecx,%eax
80105b76:	ee                   	out    %al,(%dx)
80105b77:	b8 01 00 00 00       	mov    $0x1,%eax
80105b7c:	89 f2                	mov    %esi,%edx
80105b7e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b7f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105b84:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105b85:	3c ff                	cmp    $0xff,%al
80105b87:	74 56                	je     80105bdf <uartinit+0xaf>
  uart = 1;
80105b89:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105b90:	00 00 00 
80105b93:	89 da                	mov    %ebx,%edx
80105b95:	ec                   	in     (%dx),%al
80105b96:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b9b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105b9c:	83 ec 08             	sub    $0x8,%esp
80105b9f:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80105ba4:	bb a8 78 10 80       	mov    $0x801078a8,%ebx
  ioapicenable(IRQ_COM1, 0);
80105ba9:	6a 00                	push   $0x0
80105bab:	6a 04                	push   $0x4
80105bad:	e8 ee c7 ff ff       	call   801023a0 <ioapicenable>
80105bb2:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105bb5:	b8 78 00 00 00       	mov    $0x78,%eax
80105bba:	eb 08                	jmp    80105bc4 <uartinit+0x94>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80105bc4:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105bca:	85 d2                	test   %edx,%edx
80105bcc:	74 08                	je     80105bd6 <uartinit+0xa6>
    uartputc(*p);
80105bce:	0f be c0             	movsbl %al,%eax
80105bd1:	e8 0a ff ff ff       	call   80105ae0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80105bd6:	89 f0                	mov    %esi,%eax
80105bd8:	83 c3 01             	add    $0x1,%ebx
80105bdb:	84 c0                	test   %al,%al
80105bdd:	75 e1                	jne    80105bc0 <uartinit+0x90>
}
80105bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105be2:	5b                   	pop    %ebx
80105be3:	5e                   	pop    %esi
80105be4:	5f                   	pop    %edi
80105be5:	5d                   	pop    %ebp
80105be6:	c3                   	ret    
80105be7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bee:	66 90                	xchg   %ax,%ax

80105bf0 <uartputc>:
{
80105bf0:	55                   	push   %ebp
  if(!uart)
80105bf1:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105bf7:	89 e5                	mov    %esp,%ebp
80105bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105bfc:	85 d2                	test   %edx,%edx
80105bfe:	74 10                	je     80105c10 <uartputc+0x20>
}
80105c00:	5d                   	pop    %ebp
80105c01:	e9 da fe ff ff       	jmp    80105ae0 <uartputc.part.0>
80105c06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c0d:	8d 76 00             	lea    0x0(%esi),%esi
80105c10:	5d                   	pop    %ebp
80105c11:	c3                   	ret    
80105c12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105c20 <uartintr>:

void
uartintr(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c26:	68 b0 5a 10 80       	push   $0x80105ab0
80105c2b:	e8 30 ac ff ff       	call   80100860 <consoleintr>
}
80105c30:	83 c4 10             	add    $0x10,%esp
80105c33:	c9                   	leave  
80105c34:	c3                   	ret    

80105c35 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c35:	6a 00                	push   $0x0
  pushl $0
80105c37:	6a 00                	push   $0x0
  jmp alltraps
80105c39:	e9 17 fb ff ff       	jmp    80105755 <alltraps>

80105c3e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $1
80105c40:	6a 01                	push   $0x1
  jmp alltraps
80105c42:	e9 0e fb ff ff       	jmp    80105755 <alltraps>

80105c47 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c47:	6a 00                	push   $0x0
  pushl $2
80105c49:	6a 02                	push   $0x2
  jmp alltraps
80105c4b:	e9 05 fb ff ff       	jmp    80105755 <alltraps>

80105c50 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c50:	6a 00                	push   $0x0
  pushl $3
80105c52:	6a 03                	push   $0x3
  jmp alltraps
80105c54:	e9 fc fa ff ff       	jmp    80105755 <alltraps>

80105c59 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c59:	6a 00                	push   $0x0
  pushl $4
80105c5b:	6a 04                	push   $0x4
  jmp alltraps
80105c5d:	e9 f3 fa ff ff       	jmp    80105755 <alltraps>

80105c62 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c62:	6a 00                	push   $0x0
  pushl $5
80105c64:	6a 05                	push   $0x5
  jmp alltraps
80105c66:	e9 ea fa ff ff       	jmp    80105755 <alltraps>

80105c6b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c6b:	6a 00                	push   $0x0
  pushl $6
80105c6d:	6a 06                	push   $0x6
  jmp alltraps
80105c6f:	e9 e1 fa ff ff       	jmp    80105755 <alltraps>

80105c74 <vector7>:
.globl vector7
vector7:
  pushl $0
80105c74:	6a 00                	push   $0x0
  pushl $7
80105c76:	6a 07                	push   $0x7
  jmp alltraps
80105c78:	e9 d8 fa ff ff       	jmp    80105755 <alltraps>

80105c7d <vector8>:
.globl vector8
vector8:
  pushl $8
80105c7d:	6a 08                	push   $0x8
  jmp alltraps
80105c7f:	e9 d1 fa ff ff       	jmp    80105755 <alltraps>

80105c84 <vector9>:
.globl vector9
vector9:
  pushl $0
80105c84:	6a 00                	push   $0x0
  pushl $9
80105c86:	6a 09                	push   $0x9
  jmp alltraps
80105c88:	e9 c8 fa ff ff       	jmp    80105755 <alltraps>

80105c8d <vector10>:
.globl vector10
vector10:
  pushl $10
80105c8d:	6a 0a                	push   $0xa
  jmp alltraps
80105c8f:	e9 c1 fa ff ff       	jmp    80105755 <alltraps>

80105c94 <vector11>:
.globl vector11
vector11:
  pushl $11
80105c94:	6a 0b                	push   $0xb
  jmp alltraps
80105c96:	e9 ba fa ff ff       	jmp    80105755 <alltraps>

80105c9b <vector12>:
.globl vector12
vector12:
  pushl $12
80105c9b:	6a 0c                	push   $0xc
  jmp alltraps
80105c9d:	e9 b3 fa ff ff       	jmp    80105755 <alltraps>

80105ca2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105ca2:	6a 0d                	push   $0xd
  jmp alltraps
80105ca4:	e9 ac fa ff ff       	jmp    80105755 <alltraps>

80105ca9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105ca9:	6a 0e                	push   $0xe
  jmp alltraps
80105cab:	e9 a5 fa ff ff       	jmp    80105755 <alltraps>

80105cb0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105cb0:	6a 00                	push   $0x0
  pushl $15
80105cb2:	6a 0f                	push   $0xf
  jmp alltraps
80105cb4:	e9 9c fa ff ff       	jmp    80105755 <alltraps>

80105cb9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105cb9:	6a 00                	push   $0x0
  pushl $16
80105cbb:	6a 10                	push   $0x10
  jmp alltraps
80105cbd:	e9 93 fa ff ff       	jmp    80105755 <alltraps>

80105cc2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cc2:	6a 11                	push   $0x11
  jmp alltraps
80105cc4:	e9 8c fa ff ff       	jmp    80105755 <alltraps>

80105cc9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cc9:	6a 00                	push   $0x0
  pushl $18
80105ccb:	6a 12                	push   $0x12
  jmp alltraps
80105ccd:	e9 83 fa ff ff       	jmp    80105755 <alltraps>

80105cd2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $19
80105cd4:	6a 13                	push   $0x13
  jmp alltraps
80105cd6:	e9 7a fa ff ff       	jmp    80105755 <alltraps>

80105cdb <vector20>:
.globl vector20
vector20:
  pushl $0
80105cdb:	6a 00                	push   $0x0
  pushl $20
80105cdd:	6a 14                	push   $0x14
  jmp alltraps
80105cdf:	e9 71 fa ff ff       	jmp    80105755 <alltraps>

80105ce4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105ce4:	6a 00                	push   $0x0
  pushl $21
80105ce6:	6a 15                	push   $0x15
  jmp alltraps
80105ce8:	e9 68 fa ff ff       	jmp    80105755 <alltraps>

80105ced <vector22>:
.globl vector22
vector22:
  pushl $0
80105ced:	6a 00                	push   $0x0
  pushl $22
80105cef:	6a 16                	push   $0x16
  jmp alltraps
80105cf1:	e9 5f fa ff ff       	jmp    80105755 <alltraps>

80105cf6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $23
80105cf8:	6a 17                	push   $0x17
  jmp alltraps
80105cfa:	e9 56 fa ff ff       	jmp    80105755 <alltraps>

80105cff <vector24>:
.globl vector24
vector24:
  pushl $0
80105cff:	6a 00                	push   $0x0
  pushl $24
80105d01:	6a 18                	push   $0x18
  jmp alltraps
80105d03:	e9 4d fa ff ff       	jmp    80105755 <alltraps>

80105d08 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d08:	6a 00                	push   $0x0
  pushl $25
80105d0a:	6a 19                	push   $0x19
  jmp alltraps
80105d0c:	e9 44 fa ff ff       	jmp    80105755 <alltraps>

80105d11 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d11:	6a 00                	push   $0x0
  pushl $26
80105d13:	6a 1a                	push   $0x1a
  jmp alltraps
80105d15:	e9 3b fa ff ff       	jmp    80105755 <alltraps>

80105d1a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $27
80105d1c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d1e:	e9 32 fa ff ff       	jmp    80105755 <alltraps>

80105d23 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d23:	6a 00                	push   $0x0
  pushl $28
80105d25:	6a 1c                	push   $0x1c
  jmp alltraps
80105d27:	e9 29 fa ff ff       	jmp    80105755 <alltraps>

80105d2c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d2c:	6a 00                	push   $0x0
  pushl $29
80105d2e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d30:	e9 20 fa ff ff       	jmp    80105755 <alltraps>

80105d35 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d35:	6a 00                	push   $0x0
  pushl $30
80105d37:	6a 1e                	push   $0x1e
  jmp alltraps
80105d39:	e9 17 fa ff ff       	jmp    80105755 <alltraps>

80105d3e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $31
80105d40:	6a 1f                	push   $0x1f
  jmp alltraps
80105d42:	e9 0e fa ff ff       	jmp    80105755 <alltraps>

80105d47 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d47:	6a 00                	push   $0x0
  pushl $32
80105d49:	6a 20                	push   $0x20
  jmp alltraps
80105d4b:	e9 05 fa ff ff       	jmp    80105755 <alltraps>

80105d50 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d50:	6a 00                	push   $0x0
  pushl $33
80105d52:	6a 21                	push   $0x21
  jmp alltraps
80105d54:	e9 fc f9 ff ff       	jmp    80105755 <alltraps>

80105d59 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $34
80105d5b:	6a 22                	push   $0x22
  jmp alltraps
80105d5d:	e9 f3 f9 ff ff       	jmp    80105755 <alltraps>

80105d62 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $35
80105d64:	6a 23                	push   $0x23
  jmp alltraps
80105d66:	e9 ea f9 ff ff       	jmp    80105755 <alltraps>

80105d6b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d6b:	6a 00                	push   $0x0
  pushl $36
80105d6d:	6a 24                	push   $0x24
  jmp alltraps
80105d6f:	e9 e1 f9 ff ff       	jmp    80105755 <alltraps>

80105d74 <vector37>:
.globl vector37
vector37:
  pushl $0
80105d74:	6a 00                	push   $0x0
  pushl $37
80105d76:	6a 25                	push   $0x25
  jmp alltraps
80105d78:	e9 d8 f9 ff ff       	jmp    80105755 <alltraps>

80105d7d <vector38>:
.globl vector38
vector38:
  pushl $0
80105d7d:	6a 00                	push   $0x0
  pushl $38
80105d7f:	6a 26                	push   $0x26
  jmp alltraps
80105d81:	e9 cf f9 ff ff       	jmp    80105755 <alltraps>

80105d86 <vector39>:
.globl vector39
vector39:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $39
80105d88:	6a 27                	push   $0x27
  jmp alltraps
80105d8a:	e9 c6 f9 ff ff       	jmp    80105755 <alltraps>

80105d8f <vector40>:
.globl vector40
vector40:
  pushl $0
80105d8f:	6a 00                	push   $0x0
  pushl $40
80105d91:	6a 28                	push   $0x28
  jmp alltraps
80105d93:	e9 bd f9 ff ff       	jmp    80105755 <alltraps>

80105d98 <vector41>:
.globl vector41
vector41:
  pushl $0
80105d98:	6a 00                	push   $0x0
  pushl $41
80105d9a:	6a 29                	push   $0x29
  jmp alltraps
80105d9c:	e9 b4 f9 ff ff       	jmp    80105755 <alltraps>

80105da1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105da1:	6a 00                	push   $0x0
  pushl $42
80105da3:	6a 2a                	push   $0x2a
  jmp alltraps
80105da5:	e9 ab f9 ff ff       	jmp    80105755 <alltraps>

80105daa <vector43>:
.globl vector43
vector43:
  pushl $0
80105daa:	6a 00                	push   $0x0
  pushl $43
80105dac:	6a 2b                	push   $0x2b
  jmp alltraps
80105dae:	e9 a2 f9 ff ff       	jmp    80105755 <alltraps>

80105db3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105db3:	6a 00                	push   $0x0
  pushl $44
80105db5:	6a 2c                	push   $0x2c
  jmp alltraps
80105db7:	e9 99 f9 ff ff       	jmp    80105755 <alltraps>

80105dbc <vector45>:
.globl vector45
vector45:
  pushl $0
80105dbc:	6a 00                	push   $0x0
  pushl $45
80105dbe:	6a 2d                	push   $0x2d
  jmp alltraps
80105dc0:	e9 90 f9 ff ff       	jmp    80105755 <alltraps>

80105dc5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105dc5:	6a 00                	push   $0x0
  pushl $46
80105dc7:	6a 2e                	push   $0x2e
  jmp alltraps
80105dc9:	e9 87 f9 ff ff       	jmp    80105755 <alltraps>

80105dce <vector47>:
.globl vector47
vector47:
  pushl $0
80105dce:	6a 00                	push   $0x0
  pushl $47
80105dd0:	6a 2f                	push   $0x2f
  jmp alltraps
80105dd2:	e9 7e f9 ff ff       	jmp    80105755 <alltraps>

80105dd7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105dd7:	6a 00                	push   $0x0
  pushl $48
80105dd9:	6a 30                	push   $0x30
  jmp alltraps
80105ddb:	e9 75 f9 ff ff       	jmp    80105755 <alltraps>

80105de0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105de0:	6a 00                	push   $0x0
  pushl $49
80105de2:	6a 31                	push   $0x31
  jmp alltraps
80105de4:	e9 6c f9 ff ff       	jmp    80105755 <alltraps>

80105de9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105de9:	6a 00                	push   $0x0
  pushl $50
80105deb:	6a 32                	push   $0x32
  jmp alltraps
80105ded:	e9 63 f9 ff ff       	jmp    80105755 <alltraps>

80105df2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105df2:	6a 00                	push   $0x0
  pushl $51
80105df4:	6a 33                	push   $0x33
  jmp alltraps
80105df6:	e9 5a f9 ff ff       	jmp    80105755 <alltraps>

80105dfb <vector52>:
.globl vector52
vector52:
  pushl $0
80105dfb:	6a 00                	push   $0x0
  pushl $52
80105dfd:	6a 34                	push   $0x34
  jmp alltraps
80105dff:	e9 51 f9 ff ff       	jmp    80105755 <alltraps>

80105e04 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e04:	6a 00                	push   $0x0
  pushl $53
80105e06:	6a 35                	push   $0x35
  jmp alltraps
80105e08:	e9 48 f9 ff ff       	jmp    80105755 <alltraps>

80105e0d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e0d:	6a 00                	push   $0x0
  pushl $54
80105e0f:	6a 36                	push   $0x36
  jmp alltraps
80105e11:	e9 3f f9 ff ff       	jmp    80105755 <alltraps>

80105e16 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e16:	6a 00                	push   $0x0
  pushl $55
80105e18:	6a 37                	push   $0x37
  jmp alltraps
80105e1a:	e9 36 f9 ff ff       	jmp    80105755 <alltraps>

80105e1f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e1f:	6a 00                	push   $0x0
  pushl $56
80105e21:	6a 38                	push   $0x38
  jmp alltraps
80105e23:	e9 2d f9 ff ff       	jmp    80105755 <alltraps>

80105e28 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e28:	6a 00                	push   $0x0
  pushl $57
80105e2a:	6a 39                	push   $0x39
  jmp alltraps
80105e2c:	e9 24 f9 ff ff       	jmp    80105755 <alltraps>

80105e31 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e31:	6a 00                	push   $0x0
  pushl $58
80105e33:	6a 3a                	push   $0x3a
  jmp alltraps
80105e35:	e9 1b f9 ff ff       	jmp    80105755 <alltraps>

80105e3a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e3a:	6a 00                	push   $0x0
  pushl $59
80105e3c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e3e:	e9 12 f9 ff ff       	jmp    80105755 <alltraps>

80105e43 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e43:	6a 00                	push   $0x0
  pushl $60
80105e45:	6a 3c                	push   $0x3c
  jmp alltraps
80105e47:	e9 09 f9 ff ff       	jmp    80105755 <alltraps>

80105e4c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e4c:	6a 00                	push   $0x0
  pushl $61
80105e4e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e50:	e9 00 f9 ff ff       	jmp    80105755 <alltraps>

80105e55 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e55:	6a 00                	push   $0x0
  pushl $62
80105e57:	6a 3e                	push   $0x3e
  jmp alltraps
80105e59:	e9 f7 f8 ff ff       	jmp    80105755 <alltraps>

80105e5e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e5e:	6a 00                	push   $0x0
  pushl $63
80105e60:	6a 3f                	push   $0x3f
  jmp alltraps
80105e62:	e9 ee f8 ff ff       	jmp    80105755 <alltraps>

80105e67 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e67:	6a 00                	push   $0x0
  pushl $64
80105e69:	6a 40                	push   $0x40
  jmp alltraps
80105e6b:	e9 e5 f8 ff ff       	jmp    80105755 <alltraps>

80105e70 <vector65>:
.globl vector65
vector65:
  pushl $0
80105e70:	6a 00                	push   $0x0
  pushl $65
80105e72:	6a 41                	push   $0x41
  jmp alltraps
80105e74:	e9 dc f8 ff ff       	jmp    80105755 <alltraps>

80105e79 <vector66>:
.globl vector66
vector66:
  pushl $0
80105e79:	6a 00                	push   $0x0
  pushl $66
80105e7b:	6a 42                	push   $0x42
  jmp alltraps
80105e7d:	e9 d3 f8 ff ff       	jmp    80105755 <alltraps>

80105e82 <vector67>:
.globl vector67
vector67:
  pushl $0
80105e82:	6a 00                	push   $0x0
  pushl $67
80105e84:	6a 43                	push   $0x43
  jmp alltraps
80105e86:	e9 ca f8 ff ff       	jmp    80105755 <alltraps>

80105e8b <vector68>:
.globl vector68
vector68:
  pushl $0
80105e8b:	6a 00                	push   $0x0
  pushl $68
80105e8d:	6a 44                	push   $0x44
  jmp alltraps
80105e8f:	e9 c1 f8 ff ff       	jmp    80105755 <alltraps>

80105e94 <vector69>:
.globl vector69
vector69:
  pushl $0
80105e94:	6a 00                	push   $0x0
  pushl $69
80105e96:	6a 45                	push   $0x45
  jmp alltraps
80105e98:	e9 b8 f8 ff ff       	jmp    80105755 <alltraps>

80105e9d <vector70>:
.globl vector70
vector70:
  pushl $0
80105e9d:	6a 00                	push   $0x0
  pushl $70
80105e9f:	6a 46                	push   $0x46
  jmp alltraps
80105ea1:	e9 af f8 ff ff       	jmp    80105755 <alltraps>

80105ea6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ea6:	6a 00                	push   $0x0
  pushl $71
80105ea8:	6a 47                	push   $0x47
  jmp alltraps
80105eaa:	e9 a6 f8 ff ff       	jmp    80105755 <alltraps>

80105eaf <vector72>:
.globl vector72
vector72:
  pushl $0
80105eaf:	6a 00                	push   $0x0
  pushl $72
80105eb1:	6a 48                	push   $0x48
  jmp alltraps
80105eb3:	e9 9d f8 ff ff       	jmp    80105755 <alltraps>

80105eb8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105eb8:	6a 00                	push   $0x0
  pushl $73
80105eba:	6a 49                	push   $0x49
  jmp alltraps
80105ebc:	e9 94 f8 ff ff       	jmp    80105755 <alltraps>

80105ec1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ec1:	6a 00                	push   $0x0
  pushl $74
80105ec3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ec5:	e9 8b f8 ff ff       	jmp    80105755 <alltraps>

80105eca <vector75>:
.globl vector75
vector75:
  pushl $0
80105eca:	6a 00                	push   $0x0
  pushl $75
80105ecc:	6a 4b                	push   $0x4b
  jmp alltraps
80105ece:	e9 82 f8 ff ff       	jmp    80105755 <alltraps>

80105ed3 <vector76>:
.globl vector76
vector76:
  pushl $0
80105ed3:	6a 00                	push   $0x0
  pushl $76
80105ed5:	6a 4c                	push   $0x4c
  jmp alltraps
80105ed7:	e9 79 f8 ff ff       	jmp    80105755 <alltraps>

80105edc <vector77>:
.globl vector77
vector77:
  pushl $0
80105edc:	6a 00                	push   $0x0
  pushl $77
80105ede:	6a 4d                	push   $0x4d
  jmp alltraps
80105ee0:	e9 70 f8 ff ff       	jmp    80105755 <alltraps>

80105ee5 <vector78>:
.globl vector78
vector78:
  pushl $0
80105ee5:	6a 00                	push   $0x0
  pushl $78
80105ee7:	6a 4e                	push   $0x4e
  jmp alltraps
80105ee9:	e9 67 f8 ff ff       	jmp    80105755 <alltraps>

80105eee <vector79>:
.globl vector79
vector79:
  pushl $0
80105eee:	6a 00                	push   $0x0
  pushl $79
80105ef0:	6a 4f                	push   $0x4f
  jmp alltraps
80105ef2:	e9 5e f8 ff ff       	jmp    80105755 <alltraps>

80105ef7 <vector80>:
.globl vector80
vector80:
  pushl $0
80105ef7:	6a 00                	push   $0x0
  pushl $80
80105ef9:	6a 50                	push   $0x50
  jmp alltraps
80105efb:	e9 55 f8 ff ff       	jmp    80105755 <alltraps>

80105f00 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f00:	6a 00                	push   $0x0
  pushl $81
80105f02:	6a 51                	push   $0x51
  jmp alltraps
80105f04:	e9 4c f8 ff ff       	jmp    80105755 <alltraps>

80105f09 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f09:	6a 00                	push   $0x0
  pushl $82
80105f0b:	6a 52                	push   $0x52
  jmp alltraps
80105f0d:	e9 43 f8 ff ff       	jmp    80105755 <alltraps>

80105f12 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f12:	6a 00                	push   $0x0
  pushl $83
80105f14:	6a 53                	push   $0x53
  jmp alltraps
80105f16:	e9 3a f8 ff ff       	jmp    80105755 <alltraps>

80105f1b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f1b:	6a 00                	push   $0x0
  pushl $84
80105f1d:	6a 54                	push   $0x54
  jmp alltraps
80105f1f:	e9 31 f8 ff ff       	jmp    80105755 <alltraps>

80105f24 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f24:	6a 00                	push   $0x0
  pushl $85
80105f26:	6a 55                	push   $0x55
  jmp alltraps
80105f28:	e9 28 f8 ff ff       	jmp    80105755 <alltraps>

80105f2d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f2d:	6a 00                	push   $0x0
  pushl $86
80105f2f:	6a 56                	push   $0x56
  jmp alltraps
80105f31:	e9 1f f8 ff ff       	jmp    80105755 <alltraps>

80105f36 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f36:	6a 00                	push   $0x0
  pushl $87
80105f38:	6a 57                	push   $0x57
  jmp alltraps
80105f3a:	e9 16 f8 ff ff       	jmp    80105755 <alltraps>

80105f3f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f3f:	6a 00                	push   $0x0
  pushl $88
80105f41:	6a 58                	push   $0x58
  jmp alltraps
80105f43:	e9 0d f8 ff ff       	jmp    80105755 <alltraps>

80105f48 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f48:	6a 00                	push   $0x0
  pushl $89
80105f4a:	6a 59                	push   $0x59
  jmp alltraps
80105f4c:	e9 04 f8 ff ff       	jmp    80105755 <alltraps>

80105f51 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f51:	6a 00                	push   $0x0
  pushl $90
80105f53:	6a 5a                	push   $0x5a
  jmp alltraps
80105f55:	e9 fb f7 ff ff       	jmp    80105755 <alltraps>

80105f5a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f5a:	6a 00                	push   $0x0
  pushl $91
80105f5c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f5e:	e9 f2 f7 ff ff       	jmp    80105755 <alltraps>

80105f63 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f63:	6a 00                	push   $0x0
  pushl $92
80105f65:	6a 5c                	push   $0x5c
  jmp alltraps
80105f67:	e9 e9 f7 ff ff       	jmp    80105755 <alltraps>

80105f6c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f6c:	6a 00                	push   $0x0
  pushl $93
80105f6e:	6a 5d                	push   $0x5d
  jmp alltraps
80105f70:	e9 e0 f7 ff ff       	jmp    80105755 <alltraps>

80105f75 <vector94>:
.globl vector94
vector94:
  pushl $0
80105f75:	6a 00                	push   $0x0
  pushl $94
80105f77:	6a 5e                	push   $0x5e
  jmp alltraps
80105f79:	e9 d7 f7 ff ff       	jmp    80105755 <alltraps>

80105f7e <vector95>:
.globl vector95
vector95:
  pushl $0
80105f7e:	6a 00                	push   $0x0
  pushl $95
80105f80:	6a 5f                	push   $0x5f
  jmp alltraps
80105f82:	e9 ce f7 ff ff       	jmp    80105755 <alltraps>

80105f87 <vector96>:
.globl vector96
vector96:
  pushl $0
80105f87:	6a 00                	push   $0x0
  pushl $96
80105f89:	6a 60                	push   $0x60
  jmp alltraps
80105f8b:	e9 c5 f7 ff ff       	jmp    80105755 <alltraps>

80105f90 <vector97>:
.globl vector97
vector97:
  pushl $0
80105f90:	6a 00                	push   $0x0
  pushl $97
80105f92:	6a 61                	push   $0x61
  jmp alltraps
80105f94:	e9 bc f7 ff ff       	jmp    80105755 <alltraps>

80105f99 <vector98>:
.globl vector98
vector98:
  pushl $0
80105f99:	6a 00                	push   $0x0
  pushl $98
80105f9b:	6a 62                	push   $0x62
  jmp alltraps
80105f9d:	e9 b3 f7 ff ff       	jmp    80105755 <alltraps>

80105fa2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105fa2:	6a 00                	push   $0x0
  pushl $99
80105fa4:	6a 63                	push   $0x63
  jmp alltraps
80105fa6:	e9 aa f7 ff ff       	jmp    80105755 <alltraps>

80105fab <vector100>:
.globl vector100
vector100:
  pushl $0
80105fab:	6a 00                	push   $0x0
  pushl $100
80105fad:	6a 64                	push   $0x64
  jmp alltraps
80105faf:	e9 a1 f7 ff ff       	jmp    80105755 <alltraps>

80105fb4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fb4:	6a 00                	push   $0x0
  pushl $101
80105fb6:	6a 65                	push   $0x65
  jmp alltraps
80105fb8:	e9 98 f7 ff ff       	jmp    80105755 <alltraps>

80105fbd <vector102>:
.globl vector102
vector102:
  pushl $0
80105fbd:	6a 00                	push   $0x0
  pushl $102
80105fbf:	6a 66                	push   $0x66
  jmp alltraps
80105fc1:	e9 8f f7 ff ff       	jmp    80105755 <alltraps>

80105fc6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105fc6:	6a 00                	push   $0x0
  pushl $103
80105fc8:	6a 67                	push   $0x67
  jmp alltraps
80105fca:	e9 86 f7 ff ff       	jmp    80105755 <alltraps>

80105fcf <vector104>:
.globl vector104
vector104:
  pushl $0
80105fcf:	6a 00                	push   $0x0
  pushl $104
80105fd1:	6a 68                	push   $0x68
  jmp alltraps
80105fd3:	e9 7d f7 ff ff       	jmp    80105755 <alltraps>

80105fd8 <vector105>:
.globl vector105
vector105:
  pushl $0
80105fd8:	6a 00                	push   $0x0
  pushl $105
80105fda:	6a 69                	push   $0x69
  jmp alltraps
80105fdc:	e9 74 f7 ff ff       	jmp    80105755 <alltraps>

80105fe1 <vector106>:
.globl vector106
vector106:
  pushl $0
80105fe1:	6a 00                	push   $0x0
  pushl $106
80105fe3:	6a 6a                	push   $0x6a
  jmp alltraps
80105fe5:	e9 6b f7 ff ff       	jmp    80105755 <alltraps>

80105fea <vector107>:
.globl vector107
vector107:
  pushl $0
80105fea:	6a 00                	push   $0x0
  pushl $107
80105fec:	6a 6b                	push   $0x6b
  jmp alltraps
80105fee:	e9 62 f7 ff ff       	jmp    80105755 <alltraps>

80105ff3 <vector108>:
.globl vector108
vector108:
  pushl $0
80105ff3:	6a 00                	push   $0x0
  pushl $108
80105ff5:	6a 6c                	push   $0x6c
  jmp alltraps
80105ff7:	e9 59 f7 ff ff       	jmp    80105755 <alltraps>

80105ffc <vector109>:
.globl vector109
vector109:
  pushl $0
80105ffc:	6a 00                	push   $0x0
  pushl $109
80105ffe:	6a 6d                	push   $0x6d
  jmp alltraps
80106000:	e9 50 f7 ff ff       	jmp    80105755 <alltraps>

80106005 <vector110>:
.globl vector110
vector110:
  pushl $0
80106005:	6a 00                	push   $0x0
  pushl $110
80106007:	6a 6e                	push   $0x6e
  jmp alltraps
80106009:	e9 47 f7 ff ff       	jmp    80105755 <alltraps>

8010600e <vector111>:
.globl vector111
vector111:
  pushl $0
8010600e:	6a 00                	push   $0x0
  pushl $111
80106010:	6a 6f                	push   $0x6f
  jmp alltraps
80106012:	e9 3e f7 ff ff       	jmp    80105755 <alltraps>

80106017 <vector112>:
.globl vector112
vector112:
  pushl $0
80106017:	6a 00                	push   $0x0
  pushl $112
80106019:	6a 70                	push   $0x70
  jmp alltraps
8010601b:	e9 35 f7 ff ff       	jmp    80105755 <alltraps>

80106020 <vector113>:
.globl vector113
vector113:
  pushl $0
80106020:	6a 00                	push   $0x0
  pushl $113
80106022:	6a 71                	push   $0x71
  jmp alltraps
80106024:	e9 2c f7 ff ff       	jmp    80105755 <alltraps>

80106029 <vector114>:
.globl vector114
vector114:
  pushl $0
80106029:	6a 00                	push   $0x0
  pushl $114
8010602b:	6a 72                	push   $0x72
  jmp alltraps
8010602d:	e9 23 f7 ff ff       	jmp    80105755 <alltraps>

80106032 <vector115>:
.globl vector115
vector115:
  pushl $0
80106032:	6a 00                	push   $0x0
  pushl $115
80106034:	6a 73                	push   $0x73
  jmp alltraps
80106036:	e9 1a f7 ff ff       	jmp    80105755 <alltraps>

8010603b <vector116>:
.globl vector116
vector116:
  pushl $0
8010603b:	6a 00                	push   $0x0
  pushl $116
8010603d:	6a 74                	push   $0x74
  jmp alltraps
8010603f:	e9 11 f7 ff ff       	jmp    80105755 <alltraps>

80106044 <vector117>:
.globl vector117
vector117:
  pushl $0
80106044:	6a 00                	push   $0x0
  pushl $117
80106046:	6a 75                	push   $0x75
  jmp alltraps
80106048:	e9 08 f7 ff ff       	jmp    80105755 <alltraps>

8010604d <vector118>:
.globl vector118
vector118:
  pushl $0
8010604d:	6a 00                	push   $0x0
  pushl $118
8010604f:	6a 76                	push   $0x76
  jmp alltraps
80106051:	e9 ff f6 ff ff       	jmp    80105755 <alltraps>

80106056 <vector119>:
.globl vector119
vector119:
  pushl $0
80106056:	6a 00                	push   $0x0
  pushl $119
80106058:	6a 77                	push   $0x77
  jmp alltraps
8010605a:	e9 f6 f6 ff ff       	jmp    80105755 <alltraps>

8010605f <vector120>:
.globl vector120
vector120:
  pushl $0
8010605f:	6a 00                	push   $0x0
  pushl $120
80106061:	6a 78                	push   $0x78
  jmp alltraps
80106063:	e9 ed f6 ff ff       	jmp    80105755 <alltraps>

80106068 <vector121>:
.globl vector121
vector121:
  pushl $0
80106068:	6a 00                	push   $0x0
  pushl $121
8010606a:	6a 79                	push   $0x79
  jmp alltraps
8010606c:	e9 e4 f6 ff ff       	jmp    80105755 <alltraps>

80106071 <vector122>:
.globl vector122
vector122:
  pushl $0
80106071:	6a 00                	push   $0x0
  pushl $122
80106073:	6a 7a                	push   $0x7a
  jmp alltraps
80106075:	e9 db f6 ff ff       	jmp    80105755 <alltraps>

8010607a <vector123>:
.globl vector123
vector123:
  pushl $0
8010607a:	6a 00                	push   $0x0
  pushl $123
8010607c:	6a 7b                	push   $0x7b
  jmp alltraps
8010607e:	e9 d2 f6 ff ff       	jmp    80105755 <alltraps>

80106083 <vector124>:
.globl vector124
vector124:
  pushl $0
80106083:	6a 00                	push   $0x0
  pushl $124
80106085:	6a 7c                	push   $0x7c
  jmp alltraps
80106087:	e9 c9 f6 ff ff       	jmp    80105755 <alltraps>

8010608c <vector125>:
.globl vector125
vector125:
  pushl $0
8010608c:	6a 00                	push   $0x0
  pushl $125
8010608e:	6a 7d                	push   $0x7d
  jmp alltraps
80106090:	e9 c0 f6 ff ff       	jmp    80105755 <alltraps>

80106095 <vector126>:
.globl vector126
vector126:
  pushl $0
80106095:	6a 00                	push   $0x0
  pushl $126
80106097:	6a 7e                	push   $0x7e
  jmp alltraps
80106099:	e9 b7 f6 ff ff       	jmp    80105755 <alltraps>

8010609e <vector127>:
.globl vector127
vector127:
  pushl $0
8010609e:	6a 00                	push   $0x0
  pushl $127
801060a0:	6a 7f                	push   $0x7f
  jmp alltraps
801060a2:	e9 ae f6 ff ff       	jmp    80105755 <alltraps>

801060a7 <vector128>:
.globl vector128
vector128:
  pushl $0
801060a7:	6a 00                	push   $0x0
  pushl $128
801060a9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801060ae:	e9 a2 f6 ff ff       	jmp    80105755 <alltraps>

801060b3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $129
801060b5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060ba:	e9 96 f6 ff ff       	jmp    80105755 <alltraps>

801060bf <vector130>:
.globl vector130
vector130:
  pushl $0
801060bf:	6a 00                	push   $0x0
  pushl $130
801060c1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060c6:	e9 8a f6 ff ff       	jmp    80105755 <alltraps>

801060cb <vector131>:
.globl vector131
vector131:
  pushl $0
801060cb:	6a 00                	push   $0x0
  pushl $131
801060cd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801060d2:	e9 7e f6 ff ff       	jmp    80105755 <alltraps>

801060d7 <vector132>:
.globl vector132
vector132:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $132
801060d9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801060de:	e9 72 f6 ff ff       	jmp    80105755 <alltraps>

801060e3 <vector133>:
.globl vector133
vector133:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $133
801060e5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801060ea:	e9 66 f6 ff ff       	jmp    80105755 <alltraps>

801060ef <vector134>:
.globl vector134
vector134:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $134
801060f1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801060f6:	e9 5a f6 ff ff       	jmp    80105755 <alltraps>

801060fb <vector135>:
.globl vector135
vector135:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $135
801060fd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106102:	e9 4e f6 ff ff       	jmp    80105755 <alltraps>

80106107 <vector136>:
.globl vector136
vector136:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $136
80106109:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010610e:	e9 42 f6 ff ff       	jmp    80105755 <alltraps>

80106113 <vector137>:
.globl vector137
vector137:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $137
80106115:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010611a:	e9 36 f6 ff ff       	jmp    80105755 <alltraps>

8010611f <vector138>:
.globl vector138
vector138:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $138
80106121:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106126:	e9 2a f6 ff ff       	jmp    80105755 <alltraps>

8010612b <vector139>:
.globl vector139
vector139:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $139
8010612d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106132:	e9 1e f6 ff ff       	jmp    80105755 <alltraps>

80106137 <vector140>:
.globl vector140
vector140:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $140
80106139:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010613e:	e9 12 f6 ff ff       	jmp    80105755 <alltraps>

80106143 <vector141>:
.globl vector141
vector141:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $141
80106145:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010614a:	e9 06 f6 ff ff       	jmp    80105755 <alltraps>

8010614f <vector142>:
.globl vector142
vector142:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $142
80106151:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106156:	e9 fa f5 ff ff       	jmp    80105755 <alltraps>

8010615b <vector143>:
.globl vector143
vector143:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $143
8010615d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106162:	e9 ee f5 ff ff       	jmp    80105755 <alltraps>

80106167 <vector144>:
.globl vector144
vector144:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $144
80106169:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010616e:	e9 e2 f5 ff ff       	jmp    80105755 <alltraps>

80106173 <vector145>:
.globl vector145
vector145:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $145
80106175:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010617a:	e9 d6 f5 ff ff       	jmp    80105755 <alltraps>

8010617f <vector146>:
.globl vector146
vector146:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $146
80106181:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106186:	e9 ca f5 ff ff       	jmp    80105755 <alltraps>

8010618b <vector147>:
.globl vector147
vector147:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $147
8010618d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106192:	e9 be f5 ff ff       	jmp    80105755 <alltraps>

80106197 <vector148>:
.globl vector148
vector148:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $148
80106199:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010619e:	e9 b2 f5 ff ff       	jmp    80105755 <alltraps>

801061a3 <vector149>:
.globl vector149
vector149:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $149
801061a5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801061aa:	e9 a6 f5 ff ff       	jmp    80105755 <alltraps>

801061af <vector150>:
.globl vector150
vector150:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $150
801061b1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061b6:	e9 9a f5 ff ff       	jmp    80105755 <alltraps>

801061bb <vector151>:
.globl vector151
vector151:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $151
801061bd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061c2:	e9 8e f5 ff ff       	jmp    80105755 <alltraps>

801061c7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $152
801061c9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061ce:	e9 82 f5 ff ff       	jmp    80105755 <alltraps>

801061d3 <vector153>:
.globl vector153
vector153:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $153
801061d5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801061da:	e9 76 f5 ff ff       	jmp    80105755 <alltraps>

801061df <vector154>:
.globl vector154
vector154:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $154
801061e1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801061e6:	e9 6a f5 ff ff       	jmp    80105755 <alltraps>

801061eb <vector155>:
.globl vector155
vector155:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $155
801061ed:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801061f2:	e9 5e f5 ff ff       	jmp    80105755 <alltraps>

801061f7 <vector156>:
.globl vector156
vector156:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $156
801061f9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801061fe:	e9 52 f5 ff ff       	jmp    80105755 <alltraps>

80106203 <vector157>:
.globl vector157
vector157:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $157
80106205:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010620a:	e9 46 f5 ff ff       	jmp    80105755 <alltraps>

8010620f <vector158>:
.globl vector158
vector158:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $158
80106211:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106216:	e9 3a f5 ff ff       	jmp    80105755 <alltraps>

8010621b <vector159>:
.globl vector159
vector159:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $159
8010621d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106222:	e9 2e f5 ff ff       	jmp    80105755 <alltraps>

80106227 <vector160>:
.globl vector160
vector160:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $160
80106229:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010622e:	e9 22 f5 ff ff       	jmp    80105755 <alltraps>

80106233 <vector161>:
.globl vector161
vector161:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $161
80106235:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010623a:	e9 16 f5 ff ff       	jmp    80105755 <alltraps>

8010623f <vector162>:
.globl vector162
vector162:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $162
80106241:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106246:	e9 0a f5 ff ff       	jmp    80105755 <alltraps>

8010624b <vector163>:
.globl vector163
vector163:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $163
8010624d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106252:	e9 fe f4 ff ff       	jmp    80105755 <alltraps>

80106257 <vector164>:
.globl vector164
vector164:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $164
80106259:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010625e:	e9 f2 f4 ff ff       	jmp    80105755 <alltraps>

80106263 <vector165>:
.globl vector165
vector165:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $165
80106265:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010626a:	e9 e6 f4 ff ff       	jmp    80105755 <alltraps>

8010626f <vector166>:
.globl vector166
vector166:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $166
80106271:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106276:	e9 da f4 ff ff       	jmp    80105755 <alltraps>

8010627b <vector167>:
.globl vector167
vector167:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $167
8010627d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106282:	e9 ce f4 ff ff       	jmp    80105755 <alltraps>

80106287 <vector168>:
.globl vector168
vector168:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $168
80106289:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010628e:	e9 c2 f4 ff ff       	jmp    80105755 <alltraps>

80106293 <vector169>:
.globl vector169
vector169:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $169
80106295:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010629a:	e9 b6 f4 ff ff       	jmp    80105755 <alltraps>

8010629f <vector170>:
.globl vector170
vector170:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $170
801062a1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801062a6:	e9 aa f4 ff ff       	jmp    80105755 <alltraps>

801062ab <vector171>:
.globl vector171
vector171:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $171
801062ad:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062b2:	e9 9e f4 ff ff       	jmp    80105755 <alltraps>

801062b7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $172
801062b9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062be:	e9 92 f4 ff ff       	jmp    80105755 <alltraps>

801062c3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $173
801062c5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062ca:	e9 86 f4 ff ff       	jmp    80105755 <alltraps>

801062cf <vector174>:
.globl vector174
vector174:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $174
801062d1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801062d6:	e9 7a f4 ff ff       	jmp    80105755 <alltraps>

801062db <vector175>:
.globl vector175
vector175:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $175
801062dd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801062e2:	e9 6e f4 ff ff       	jmp    80105755 <alltraps>

801062e7 <vector176>:
.globl vector176
vector176:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $176
801062e9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801062ee:	e9 62 f4 ff ff       	jmp    80105755 <alltraps>

801062f3 <vector177>:
.globl vector177
vector177:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $177
801062f5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801062fa:	e9 56 f4 ff ff       	jmp    80105755 <alltraps>

801062ff <vector178>:
.globl vector178
vector178:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $178
80106301:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106306:	e9 4a f4 ff ff       	jmp    80105755 <alltraps>

8010630b <vector179>:
.globl vector179
vector179:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $179
8010630d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106312:	e9 3e f4 ff ff       	jmp    80105755 <alltraps>

80106317 <vector180>:
.globl vector180
vector180:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $180
80106319:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010631e:	e9 32 f4 ff ff       	jmp    80105755 <alltraps>

80106323 <vector181>:
.globl vector181
vector181:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $181
80106325:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010632a:	e9 26 f4 ff ff       	jmp    80105755 <alltraps>

8010632f <vector182>:
.globl vector182
vector182:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $182
80106331:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106336:	e9 1a f4 ff ff       	jmp    80105755 <alltraps>

8010633b <vector183>:
.globl vector183
vector183:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $183
8010633d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106342:	e9 0e f4 ff ff       	jmp    80105755 <alltraps>

80106347 <vector184>:
.globl vector184
vector184:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $184
80106349:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010634e:	e9 02 f4 ff ff       	jmp    80105755 <alltraps>

80106353 <vector185>:
.globl vector185
vector185:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $185
80106355:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010635a:	e9 f6 f3 ff ff       	jmp    80105755 <alltraps>

8010635f <vector186>:
.globl vector186
vector186:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $186
80106361:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106366:	e9 ea f3 ff ff       	jmp    80105755 <alltraps>

8010636b <vector187>:
.globl vector187
vector187:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $187
8010636d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106372:	e9 de f3 ff ff       	jmp    80105755 <alltraps>

80106377 <vector188>:
.globl vector188
vector188:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $188
80106379:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010637e:	e9 d2 f3 ff ff       	jmp    80105755 <alltraps>

80106383 <vector189>:
.globl vector189
vector189:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $189
80106385:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010638a:	e9 c6 f3 ff ff       	jmp    80105755 <alltraps>

8010638f <vector190>:
.globl vector190
vector190:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $190
80106391:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106396:	e9 ba f3 ff ff       	jmp    80105755 <alltraps>

8010639b <vector191>:
.globl vector191
vector191:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $191
8010639d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801063a2:	e9 ae f3 ff ff       	jmp    80105755 <alltraps>

801063a7 <vector192>:
.globl vector192
vector192:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $192
801063a9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801063ae:	e9 a2 f3 ff ff       	jmp    80105755 <alltraps>

801063b3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $193
801063b5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063ba:	e9 96 f3 ff ff       	jmp    80105755 <alltraps>

801063bf <vector194>:
.globl vector194
vector194:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $194
801063c1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063c6:	e9 8a f3 ff ff       	jmp    80105755 <alltraps>

801063cb <vector195>:
.globl vector195
vector195:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $195
801063cd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801063d2:	e9 7e f3 ff ff       	jmp    80105755 <alltraps>

801063d7 <vector196>:
.globl vector196
vector196:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $196
801063d9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801063de:	e9 72 f3 ff ff       	jmp    80105755 <alltraps>

801063e3 <vector197>:
.globl vector197
vector197:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $197
801063e5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801063ea:	e9 66 f3 ff ff       	jmp    80105755 <alltraps>

801063ef <vector198>:
.globl vector198
vector198:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $198
801063f1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801063f6:	e9 5a f3 ff ff       	jmp    80105755 <alltraps>

801063fb <vector199>:
.globl vector199
vector199:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $199
801063fd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106402:	e9 4e f3 ff ff       	jmp    80105755 <alltraps>

80106407 <vector200>:
.globl vector200
vector200:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $200
80106409:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010640e:	e9 42 f3 ff ff       	jmp    80105755 <alltraps>

80106413 <vector201>:
.globl vector201
vector201:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $201
80106415:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010641a:	e9 36 f3 ff ff       	jmp    80105755 <alltraps>

8010641f <vector202>:
.globl vector202
vector202:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $202
80106421:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106426:	e9 2a f3 ff ff       	jmp    80105755 <alltraps>

8010642b <vector203>:
.globl vector203
vector203:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $203
8010642d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106432:	e9 1e f3 ff ff       	jmp    80105755 <alltraps>

80106437 <vector204>:
.globl vector204
vector204:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $204
80106439:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010643e:	e9 12 f3 ff ff       	jmp    80105755 <alltraps>

80106443 <vector205>:
.globl vector205
vector205:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $205
80106445:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010644a:	e9 06 f3 ff ff       	jmp    80105755 <alltraps>

8010644f <vector206>:
.globl vector206
vector206:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $206
80106451:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106456:	e9 fa f2 ff ff       	jmp    80105755 <alltraps>

8010645b <vector207>:
.globl vector207
vector207:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $207
8010645d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106462:	e9 ee f2 ff ff       	jmp    80105755 <alltraps>

80106467 <vector208>:
.globl vector208
vector208:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $208
80106469:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010646e:	e9 e2 f2 ff ff       	jmp    80105755 <alltraps>

80106473 <vector209>:
.globl vector209
vector209:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $209
80106475:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010647a:	e9 d6 f2 ff ff       	jmp    80105755 <alltraps>

8010647f <vector210>:
.globl vector210
vector210:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $210
80106481:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106486:	e9 ca f2 ff ff       	jmp    80105755 <alltraps>

8010648b <vector211>:
.globl vector211
vector211:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $211
8010648d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106492:	e9 be f2 ff ff       	jmp    80105755 <alltraps>

80106497 <vector212>:
.globl vector212
vector212:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $212
80106499:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010649e:	e9 b2 f2 ff ff       	jmp    80105755 <alltraps>

801064a3 <vector213>:
.globl vector213
vector213:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $213
801064a5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801064aa:	e9 a6 f2 ff ff       	jmp    80105755 <alltraps>

801064af <vector214>:
.globl vector214
vector214:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $214
801064b1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064b6:	e9 9a f2 ff ff       	jmp    80105755 <alltraps>

801064bb <vector215>:
.globl vector215
vector215:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $215
801064bd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064c2:	e9 8e f2 ff ff       	jmp    80105755 <alltraps>

801064c7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $216
801064c9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064ce:	e9 82 f2 ff ff       	jmp    80105755 <alltraps>

801064d3 <vector217>:
.globl vector217
vector217:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $217
801064d5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801064da:	e9 76 f2 ff ff       	jmp    80105755 <alltraps>

801064df <vector218>:
.globl vector218
vector218:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $218
801064e1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801064e6:	e9 6a f2 ff ff       	jmp    80105755 <alltraps>

801064eb <vector219>:
.globl vector219
vector219:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $219
801064ed:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801064f2:	e9 5e f2 ff ff       	jmp    80105755 <alltraps>

801064f7 <vector220>:
.globl vector220
vector220:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $220
801064f9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801064fe:	e9 52 f2 ff ff       	jmp    80105755 <alltraps>

80106503 <vector221>:
.globl vector221
vector221:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $221
80106505:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010650a:	e9 46 f2 ff ff       	jmp    80105755 <alltraps>

8010650f <vector222>:
.globl vector222
vector222:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $222
80106511:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106516:	e9 3a f2 ff ff       	jmp    80105755 <alltraps>

8010651b <vector223>:
.globl vector223
vector223:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $223
8010651d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106522:	e9 2e f2 ff ff       	jmp    80105755 <alltraps>

80106527 <vector224>:
.globl vector224
vector224:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $224
80106529:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010652e:	e9 22 f2 ff ff       	jmp    80105755 <alltraps>

80106533 <vector225>:
.globl vector225
vector225:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $225
80106535:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010653a:	e9 16 f2 ff ff       	jmp    80105755 <alltraps>

8010653f <vector226>:
.globl vector226
vector226:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $226
80106541:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106546:	e9 0a f2 ff ff       	jmp    80105755 <alltraps>

8010654b <vector227>:
.globl vector227
vector227:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $227
8010654d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106552:	e9 fe f1 ff ff       	jmp    80105755 <alltraps>

80106557 <vector228>:
.globl vector228
vector228:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $228
80106559:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010655e:	e9 f2 f1 ff ff       	jmp    80105755 <alltraps>

80106563 <vector229>:
.globl vector229
vector229:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $229
80106565:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010656a:	e9 e6 f1 ff ff       	jmp    80105755 <alltraps>

8010656f <vector230>:
.globl vector230
vector230:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $230
80106571:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106576:	e9 da f1 ff ff       	jmp    80105755 <alltraps>

8010657b <vector231>:
.globl vector231
vector231:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $231
8010657d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106582:	e9 ce f1 ff ff       	jmp    80105755 <alltraps>

80106587 <vector232>:
.globl vector232
vector232:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $232
80106589:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010658e:	e9 c2 f1 ff ff       	jmp    80105755 <alltraps>

80106593 <vector233>:
.globl vector233
vector233:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $233
80106595:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010659a:	e9 b6 f1 ff ff       	jmp    80105755 <alltraps>

8010659f <vector234>:
.globl vector234
vector234:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $234
801065a1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801065a6:	e9 aa f1 ff ff       	jmp    80105755 <alltraps>

801065ab <vector235>:
.globl vector235
vector235:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $235
801065ad:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065b2:	e9 9e f1 ff ff       	jmp    80105755 <alltraps>

801065b7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $236
801065b9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065be:	e9 92 f1 ff ff       	jmp    80105755 <alltraps>

801065c3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $237
801065c5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065ca:	e9 86 f1 ff ff       	jmp    80105755 <alltraps>

801065cf <vector238>:
.globl vector238
vector238:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $238
801065d1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801065d6:	e9 7a f1 ff ff       	jmp    80105755 <alltraps>

801065db <vector239>:
.globl vector239
vector239:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $239
801065dd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801065e2:	e9 6e f1 ff ff       	jmp    80105755 <alltraps>

801065e7 <vector240>:
.globl vector240
vector240:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $240
801065e9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801065ee:	e9 62 f1 ff ff       	jmp    80105755 <alltraps>

801065f3 <vector241>:
.globl vector241
vector241:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $241
801065f5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801065fa:	e9 56 f1 ff ff       	jmp    80105755 <alltraps>

801065ff <vector242>:
.globl vector242
vector242:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $242
80106601:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106606:	e9 4a f1 ff ff       	jmp    80105755 <alltraps>

8010660b <vector243>:
.globl vector243
vector243:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $243
8010660d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106612:	e9 3e f1 ff ff       	jmp    80105755 <alltraps>

80106617 <vector244>:
.globl vector244
vector244:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $244
80106619:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010661e:	e9 32 f1 ff ff       	jmp    80105755 <alltraps>

80106623 <vector245>:
.globl vector245
vector245:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $245
80106625:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010662a:	e9 26 f1 ff ff       	jmp    80105755 <alltraps>

8010662f <vector246>:
.globl vector246
vector246:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $246
80106631:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106636:	e9 1a f1 ff ff       	jmp    80105755 <alltraps>

8010663b <vector247>:
.globl vector247
vector247:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $247
8010663d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106642:	e9 0e f1 ff ff       	jmp    80105755 <alltraps>

80106647 <vector248>:
.globl vector248
vector248:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $248
80106649:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010664e:	e9 02 f1 ff ff       	jmp    80105755 <alltraps>

80106653 <vector249>:
.globl vector249
vector249:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $249
80106655:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010665a:	e9 f6 f0 ff ff       	jmp    80105755 <alltraps>

8010665f <vector250>:
.globl vector250
vector250:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $250
80106661:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106666:	e9 ea f0 ff ff       	jmp    80105755 <alltraps>

8010666b <vector251>:
.globl vector251
vector251:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $251
8010666d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106672:	e9 de f0 ff ff       	jmp    80105755 <alltraps>

80106677 <vector252>:
.globl vector252
vector252:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $252
80106679:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010667e:	e9 d2 f0 ff ff       	jmp    80105755 <alltraps>

80106683 <vector253>:
.globl vector253
vector253:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $253
80106685:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010668a:	e9 c6 f0 ff ff       	jmp    80105755 <alltraps>

8010668f <vector254>:
.globl vector254
vector254:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $254
80106691:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106696:	e9 ba f0 ff ff       	jmp    80105755 <alltraps>

8010669b <vector255>:
.globl vector255
vector255:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $255
8010669d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801066a2:	e9 ae f0 ff ff       	jmp    80105755 <alltraps>
801066a7:	66 90                	xchg   %ax,%ax
801066a9:	66 90                	xchg   %ax,%ax
801066ab:	66 90                	xchg   %ax,%ax
801066ad:	66 90                	xchg   %ax,%ax
801066af:	90                   	nop

801066b0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066b0:	55                   	push   %ebp
801066b1:	89 e5                	mov    %esp,%ebp
801066b3:	57                   	push   %edi
801066b4:	56                   	push   %esi
801066b5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066b7:	c1 ea 16             	shr    $0x16,%edx
{
801066ba:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801066bb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801066be:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801066c1:	8b 07                	mov    (%edi),%eax
801066c3:	a8 01                	test   $0x1,%al
801066c5:	74 29                	je     801066f0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066cc:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801066d2:	c1 ee 0a             	shr    $0xa,%esi
}
801066d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801066d8:	89 f2                	mov    %esi,%edx
801066da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801066e0:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
801066e3:	5b                   	pop    %ebx
801066e4:	5e                   	pop    %esi
801066e5:	5f                   	pop    %edi
801066e6:	5d                   	pop    %ebp
801066e7:	c3                   	ret    
801066e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ef:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801066f0:	85 c9                	test   %ecx,%ecx
801066f2:	74 2c                	je     80106720 <walkpgdir+0x70>
801066f4:	e8 a7 be ff ff       	call   801025a0 <kalloc>
801066f9:	89 c3                	mov    %eax,%ebx
801066fb:	85 c0                	test   %eax,%eax
801066fd:	74 21                	je     80106720 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801066ff:	83 ec 04             	sub    $0x4,%esp
80106702:	68 00 10 00 00       	push   $0x1000
80106707:	6a 00                	push   $0x0
80106709:	50                   	push   %eax
8010670a:	e8 a1 de ff ff       	call   801045b0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010670f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106715:	83 c4 10             	add    $0x10,%esp
80106718:	83 c8 07             	or     $0x7,%eax
8010671b:	89 07                	mov    %eax,(%edi)
8010671d:	eb b3                	jmp    801066d2 <walkpgdir+0x22>
8010671f:	90                   	nop
}
80106720:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106723:	31 c0                	xor    %eax,%eax
}
80106725:	5b                   	pop    %ebx
80106726:	5e                   	pop    %esi
80106727:	5f                   	pop    %edi
80106728:	5d                   	pop    %ebp
80106729:	c3                   	ret    
8010672a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106730 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106730:	55                   	push   %ebp
80106731:	89 e5                	mov    %esp,%ebp
80106733:	57                   	push   %edi
80106734:	56                   	push   %esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106735:	89 d6                	mov    %edx,%esi
{
80106737:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106738:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
8010673e:	83 ec 1c             	sub    $0x1c,%esp
80106741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106744:	8b 7d 08             	mov    0x8(%ebp),%edi
80106747:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010674b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106750:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106753:	29 f7                	sub    %esi,%edi
80106755:	eb 21                	jmp    80106778 <mappages+0x48>
80106757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010675e:	66 90                	xchg   %ax,%ax
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106760:	f6 00 01             	testb  $0x1,(%eax)
80106763:	75 45                	jne    801067aa <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106765:	0b 5d 0c             	or     0xc(%ebp),%ebx
80106768:	83 cb 01             	or     $0x1,%ebx
8010676b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010676d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80106770:	74 2e                	je     801067a0 <mappages+0x70>
      break;
    a += PGSIZE;
80106772:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010677b:	b9 01 00 00 00       	mov    $0x1,%ecx
80106780:	89 f2                	mov    %esi,%edx
80106782:	8d 1c 3e             	lea    (%esi,%edi,1),%ebx
80106785:	e8 26 ff ff ff       	call   801066b0 <walkpgdir>
8010678a:	85 c0                	test   %eax,%eax
8010678c:	75 d2                	jne    80106760 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
8010678e:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106791:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106796:	5b                   	pop    %ebx
80106797:	5e                   	pop    %esi
80106798:	5f                   	pop    %edi
80106799:	5d                   	pop    %ebp
8010679a:	c3                   	ret    
8010679b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010679f:	90                   	nop
801067a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801067a3:	31 c0                	xor    %eax,%eax
}
801067a5:	5b                   	pop    %ebx
801067a6:	5e                   	pop    %esi
801067a7:	5f                   	pop    %edi
801067a8:	5d                   	pop    %ebp
801067a9:	c3                   	ret    
      panic("remap");
801067aa:	83 ec 0c             	sub    $0xc,%esp
801067ad:	68 b0 78 10 80       	push   $0x801078b0
801067b2:	e8 d9 9b ff ff       	call   80100390 <panic>
801067b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067be:	66 90                	xchg   %ax,%ax

801067c0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067c0:	55                   	push   %ebp
801067c1:	89 e5                	mov    %esp,%ebp
801067c3:	57                   	push   %edi
801067c4:	89 c7                	mov    %eax,%edi
801067c6:	56                   	push   %esi
801067c7:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067c8:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801067ce:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067d4:	83 ec 1c             	sub    $0x1c,%esp
801067d7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801067da:	39 d3                	cmp    %edx,%ebx
801067dc:	73 5a                	jae    80106838 <deallocuvm.part.0+0x78>
801067de:	89 d6                	mov    %edx,%esi
801067e0:	eb 10                	jmp    801067f2 <deallocuvm.part.0+0x32>
801067e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067e8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801067ee:	39 de                	cmp    %ebx,%esi
801067f0:	76 46                	jbe    80106838 <deallocuvm.part.0+0x78>
    pte = walkpgdir(pgdir, (char*)a, 0);
801067f2:	31 c9                	xor    %ecx,%ecx
801067f4:	89 da                	mov    %ebx,%edx
801067f6:	89 f8                	mov    %edi,%eax
801067f8:	e8 b3 fe ff ff       	call   801066b0 <walkpgdir>
    if(!pte)
801067fd:	85 c0                	test   %eax,%eax
801067ff:	74 47                	je     80106848 <deallocuvm.part.0+0x88>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106801:	8b 10                	mov    (%eax),%edx
80106803:	f6 c2 01             	test   $0x1,%dl
80106806:	74 e0                	je     801067e8 <deallocuvm.part.0+0x28>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106808:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
8010680e:	74 46                	je     80106856 <deallocuvm.part.0+0x96>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106810:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106813:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106819:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
8010681c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106822:	52                   	push   %edx
80106823:	e8 b8 bb ff ff       	call   801023e0 <kfree>
      *pte = 0;
80106828:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010682b:	83 c4 10             	add    $0x10,%esp
8010682e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106834:	39 de                	cmp    %ebx,%esi
80106836:	77 ba                	ja     801067f2 <deallocuvm.part.0+0x32>
    }
  }
  return newsz;
}
80106838:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010683b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010683e:	5b                   	pop    %ebx
8010683f:	5e                   	pop    %esi
80106840:	5f                   	pop    %edi
80106841:	5d                   	pop    %ebp
80106842:	c3                   	ret    
80106843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106847:	90                   	nop
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106848:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
8010684e:	81 c3 00 00 40 00    	add    $0x400000,%ebx
80106854:	eb 98                	jmp    801067ee <deallocuvm.part.0+0x2e>
        panic("kfree");
80106856:	83 ec 0c             	sub    $0xc,%esp
80106859:	68 46 72 10 80       	push   $0x80107246
8010685e:	e8 2d 9b ff ff       	call   80100390 <panic>
80106863:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010686a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106870 <seginit>:
{
80106870:	55                   	push   %ebp
80106871:	89 e5                	mov    %esp,%ebp
80106873:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106876:	e8 35 d0 ff ff       	call   801038b0 <cpuid>
  pd[0] = size-1;
8010687b:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106880:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106886:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010688a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106891:	ff 00 00 
80106894:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
8010689b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010689e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
801068a5:	ff 00 00 
801068a8:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
801068af:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068b2:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
801068b9:	ff 00 00 
801068bc:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
801068c3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068c6:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
801068cd:	ff 00 00 
801068d0:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
801068d7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801068da:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
801068df:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801068e3:	c1 e8 10             	shr    $0x10,%eax
801068e6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801068ea:	8d 45 f2             	lea    -0xe(%ebp),%eax
801068ed:	0f 01 10             	lgdtl  (%eax)
}
801068f0:	c9                   	leave  
801068f1:	c3                   	ret    
801068f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801068f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106900 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106900:	a1 a4 54 11 80       	mov    0x801154a4,%eax
80106905:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010690a:	0f 22 d8             	mov    %eax,%cr3
}
8010690d:	c3                   	ret    
8010690e:	66 90                	xchg   %ax,%ax

80106910 <switchuvm>:
{
80106910:	55                   	push   %ebp
80106911:	89 e5                	mov    %esp,%ebp
80106913:	57                   	push   %edi
80106914:	56                   	push   %esi
80106915:	53                   	push   %ebx
80106916:	83 ec 1c             	sub    $0x1c,%esp
80106919:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
8010691c:	85 db                	test   %ebx,%ebx
8010691e:	0f 84 cb 00 00 00    	je     801069ef <switchuvm+0xdf>
  if(p->kstack == 0)
80106924:	8b 43 08             	mov    0x8(%ebx),%eax
80106927:	85 c0                	test   %eax,%eax
80106929:	0f 84 da 00 00 00    	je     80106a09 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010692f:	8b 43 04             	mov    0x4(%ebx),%eax
80106932:	85 c0                	test   %eax,%eax
80106934:	0f 84 c2 00 00 00    	je     801069fc <switchuvm+0xec>
  pushcli();
8010693a:	e8 71 da ff ff       	call   801043b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010693f:	e8 ec ce ff ff       	call   80103830 <mycpu>
80106944:	89 c6                	mov    %eax,%esi
80106946:	e8 e5 ce ff ff       	call   80103830 <mycpu>
8010694b:	89 c7                	mov    %eax,%edi
8010694d:	e8 de ce ff ff       	call   80103830 <mycpu>
80106952:	83 c7 08             	add    $0x8,%edi
80106955:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106958:	e8 d3 ce ff ff       	call   80103830 <mycpu>
8010695d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106960:	ba 67 00 00 00       	mov    $0x67,%edx
80106965:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
8010696c:	83 c0 08             	add    $0x8,%eax
8010696f:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106976:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010697b:	83 c1 08             	add    $0x8,%ecx
8010697e:	c1 e8 18             	shr    $0x18,%eax
80106981:	c1 e9 10             	shr    $0x10,%ecx
80106984:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
8010698a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106990:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106995:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010699c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
801069a1:	e8 8a ce ff ff       	call   80103830 <mycpu>
801069a6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801069ad:	e8 7e ce ff ff       	call   80103830 <mycpu>
801069b2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801069b6:	8b 73 08             	mov    0x8(%ebx),%esi
801069b9:	81 c6 00 10 00 00    	add    $0x1000,%esi
801069bf:	e8 6c ce ff ff       	call   80103830 <mycpu>
801069c4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801069c7:	e8 64 ce ff ff       	call   80103830 <mycpu>
801069cc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801069d0:	b8 28 00 00 00       	mov    $0x28,%eax
801069d5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801069d8:	8b 43 04             	mov    0x4(%ebx),%eax
801069db:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069e0:	0f 22 d8             	mov    %eax,%cr3
}
801069e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801069e6:	5b                   	pop    %ebx
801069e7:	5e                   	pop    %esi
801069e8:	5f                   	pop    %edi
801069e9:	5d                   	pop    %ebp
  popcli();
801069ea:	e9 11 da ff ff       	jmp    80104400 <popcli>
    panic("switchuvm: no process");
801069ef:	83 ec 0c             	sub    $0xc,%esp
801069f2:	68 b6 78 10 80       	push   $0x801078b6
801069f7:	e8 94 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801069fc:	83 ec 0c             	sub    $0xc,%esp
801069ff:	68 e1 78 10 80       	push   $0x801078e1
80106a04:	e8 87 99 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106a09:	83 ec 0c             	sub    $0xc,%esp
80106a0c:	68 cc 78 10 80       	push   $0x801078cc
80106a11:	e8 7a 99 ff ff       	call   80100390 <panic>
80106a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a1d:	8d 76 00             	lea    0x0(%esi),%esi

80106a20 <inituvm>:
{
80106a20:	55                   	push   %ebp
80106a21:	89 e5                	mov    %esp,%ebp
80106a23:	57                   	push   %edi
80106a24:	56                   	push   %esi
80106a25:	53                   	push   %ebx
80106a26:	83 ec 1c             	sub    $0x1c,%esp
80106a29:	8b 45 08             	mov    0x8(%ebp),%eax
80106a2c:	8b 75 10             	mov    0x10(%ebp),%esi
80106a2f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106a32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106a35:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106a3b:	77 49                	ja     80106a86 <inituvm+0x66>
  mem = kalloc();
80106a3d:	e8 5e bb ff ff       	call   801025a0 <kalloc>
  memset(mem, 0, PGSIZE);
80106a42:	83 ec 04             	sub    $0x4,%esp
80106a45:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106a4a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106a4c:	6a 00                	push   $0x0
80106a4e:	50                   	push   %eax
80106a4f:	e8 5c db ff ff       	call   801045b0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106a54:	58                   	pop    %eax
80106a55:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106a5b:	5a                   	pop    %edx
80106a5c:	6a 06                	push   $0x6
80106a5e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a63:	31 d2                	xor    %edx,%edx
80106a65:	50                   	push   %eax
80106a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a69:	e8 c2 fc ff ff       	call   80106730 <mappages>
  memmove(mem, init, sz);
80106a6e:	89 75 10             	mov    %esi,0x10(%ebp)
80106a71:	83 c4 10             	add    $0x10,%esp
80106a74:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106a77:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106a7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a7d:	5b                   	pop    %ebx
80106a7e:	5e                   	pop    %esi
80106a7f:	5f                   	pop    %edi
80106a80:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106a81:	e9 ca db ff ff       	jmp    80104650 <memmove>
    panic("inituvm: more than a page");
80106a86:	83 ec 0c             	sub    $0xc,%esp
80106a89:	68 f5 78 10 80       	push   $0x801078f5
80106a8e:	e8 fd 98 ff ff       	call   80100390 <panic>
80106a93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106a9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106aa0 <loaduvm>:
{
80106aa0:	55                   	push   %ebp
80106aa1:	89 e5                	mov    %esp,%ebp
80106aa3:	57                   	push   %edi
80106aa4:	56                   	push   %esi
80106aa5:	53                   	push   %ebx
80106aa6:	83 ec 1c             	sub    $0x1c,%esp
80106aa9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106aac:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80106aaf:	a9 ff 0f 00 00       	test   $0xfff,%eax
80106ab4:	0f 85 8d 00 00 00    	jne    80106b47 <loaduvm+0xa7>
80106aba:	01 f0                	add    %esi,%eax
  for(i = 0; i < sz; i += PGSIZE){
80106abc:	89 f3                	mov    %esi,%ebx
80106abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ac1:	8b 45 14             	mov    0x14(%ebp),%eax
80106ac4:	01 f0                	add    %esi,%eax
80106ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80106ac9:	85 f6                	test   %esi,%esi
80106acb:	75 11                	jne    80106ade <loaduvm+0x3e>
80106acd:	eb 61                	jmp    80106b30 <loaduvm+0x90>
80106acf:	90                   	nop
80106ad0:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80106ad6:	89 f0                	mov    %esi,%eax
80106ad8:	29 d8                	sub    %ebx,%eax
80106ada:	39 c6                	cmp    %eax,%esi
80106adc:	76 52                	jbe    80106b30 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106ade:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106ae1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ae4:	31 c9                	xor    %ecx,%ecx
80106ae6:	29 da                	sub    %ebx,%edx
80106ae8:	e8 c3 fb ff ff       	call   801066b0 <walkpgdir>
80106aed:	85 c0                	test   %eax,%eax
80106aef:	74 49                	je     80106b3a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106af1:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106af3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
80106af6:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106afb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b00:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
80106b06:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b09:	29 d9                	sub    %ebx,%ecx
80106b0b:	05 00 00 00 80       	add    $0x80000000,%eax
80106b10:	57                   	push   %edi
80106b11:	51                   	push   %ecx
80106b12:	50                   	push   %eax
80106b13:	ff 75 10             	pushl  0x10(%ebp)
80106b16:	e8 d5 ae ff ff       	call   801019f0 <readi>
80106b1b:	83 c4 10             	add    $0x10,%esp
80106b1e:	39 f8                	cmp    %edi,%eax
80106b20:	74 ae                	je     80106ad0 <loaduvm+0x30>
}
80106b22:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b2a:	5b                   	pop    %ebx
80106b2b:	5e                   	pop    %esi
80106b2c:	5f                   	pop    %edi
80106b2d:	5d                   	pop    %ebp
80106b2e:	c3                   	ret    
80106b2f:	90                   	nop
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret    
      panic("loaduvm: address should exist");
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	68 0f 79 10 80       	push   $0x8010790f
80106b42:	e8 49 98 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106b47:	83 ec 0c             	sub    $0xc,%esp
80106b4a:	68 b0 79 10 80       	push   $0x801079b0
80106b4f:	e8 3c 98 ff ff       	call   80100390 <panic>
80106b54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106b5f:	90                   	nop

80106b60 <allocuvm>:
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106b69:	8b 7d 10             	mov    0x10(%ebp),%edi
80106b6c:	85 ff                	test   %edi,%edi
80106b6e:	0f 88 bc 00 00 00    	js     80106c30 <allocuvm+0xd0>
  if(newsz < oldsz)
80106b74:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106b77:	0f 82 a3 00 00 00    	jb     80106c20 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b80:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106b86:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106b8c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106b8f:	0f 86 8e 00 00 00    	jbe    80106c23 <allocuvm+0xc3>
80106b95:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106b98:	8b 7d 08             	mov    0x8(%ebp),%edi
80106b9b:	eb 42                	jmp    80106bdf <allocuvm+0x7f>
80106b9d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106ba0:	83 ec 04             	sub    $0x4,%esp
80106ba3:	68 00 10 00 00       	push   $0x1000
80106ba8:	6a 00                	push   $0x0
80106baa:	50                   	push   %eax
80106bab:	e8 00 da ff ff       	call   801045b0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106bb0:	58                   	pop    %eax
80106bb1:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106bb7:	5a                   	pop    %edx
80106bb8:	6a 06                	push   $0x6
80106bba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106bbf:	89 da                	mov    %ebx,%edx
80106bc1:	50                   	push   %eax
80106bc2:	89 f8                	mov    %edi,%eax
80106bc4:	e8 67 fb ff ff       	call   80106730 <mappages>
80106bc9:	83 c4 10             	add    $0x10,%esp
80106bcc:	85 c0                	test   %eax,%eax
80106bce:	78 70                	js     80106c40 <allocuvm+0xe0>
  for(; a < newsz; a += PGSIZE){
80106bd0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bd6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106bd9:	0f 86 a1 00 00 00    	jbe    80106c80 <allocuvm+0x120>
    mem = kalloc();
80106bdf:	e8 bc b9 ff ff       	call   801025a0 <kalloc>
80106be4:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106be6:	85 c0                	test   %eax,%eax
80106be8:	75 b6                	jne    80106ba0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106bea:	83 ec 0c             	sub    $0xc,%esp
80106bed:	68 2d 79 10 80       	push   $0x8010792d
80106bf2:	e8 b9 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106bf7:	83 c4 10             	add    $0x10,%esp
80106bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bfd:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c00:	74 2e                	je     80106c30 <allocuvm+0xd0>
80106c02:	89 c1                	mov    %eax,%ecx
80106c04:	8b 55 10             	mov    0x10(%ebp),%edx
80106c07:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80106c0a:	31 ff                	xor    %edi,%edi
80106c0c:	e8 af fb ff ff       	call   801067c0 <deallocuvm.part.0>
}
80106c11:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c14:	89 f8                	mov    %edi,%eax
80106c16:	5b                   	pop    %ebx
80106c17:	5e                   	pop    %esi
80106c18:	5f                   	pop    %edi
80106c19:	5d                   	pop    %ebp
80106c1a:	c3                   	ret    
80106c1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106c1f:	90                   	nop
    return oldsz;
80106c20:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106c23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c26:	89 f8                	mov    %edi,%eax
80106c28:	5b                   	pop    %ebx
80106c29:	5e                   	pop    %esi
80106c2a:	5f                   	pop    %edi
80106c2b:	5d                   	pop    %ebp
80106c2c:	c3                   	ret    
80106c2d:	8d 76 00             	lea    0x0(%esi),%esi
80106c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106c33:	31 ff                	xor    %edi,%edi
}
80106c35:	5b                   	pop    %ebx
80106c36:	89 f8                	mov    %edi,%eax
80106c38:	5e                   	pop    %esi
80106c39:	5f                   	pop    %edi
80106c3a:	5d                   	pop    %ebp
80106c3b:	c3                   	ret    
80106c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("allocuvm out of memory (2)\n");
80106c40:	83 ec 0c             	sub    $0xc,%esp
80106c43:	68 45 79 10 80       	push   $0x80107945
80106c48:	e8 63 9a ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106c4d:	83 c4 10             	add    $0x10,%esp
80106c50:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c53:	39 45 10             	cmp    %eax,0x10(%ebp)
80106c56:	74 0d                	je     80106c65 <allocuvm+0x105>
80106c58:	89 c1                	mov    %eax,%ecx
80106c5a:	8b 55 10             	mov    0x10(%ebp),%edx
80106c5d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c60:	e8 5b fb ff ff       	call   801067c0 <deallocuvm.part.0>
      kfree(mem);
80106c65:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106c68:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106c6a:	56                   	push   %esi
80106c6b:	e8 70 b7 ff ff       	call   801023e0 <kfree>
      return 0;
80106c70:	83 c4 10             	add    $0x10,%esp
}
80106c73:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c76:	89 f8                	mov    %edi,%eax
80106c78:	5b                   	pop    %ebx
80106c79:	5e                   	pop    %esi
80106c7a:	5f                   	pop    %edi
80106c7b:	5d                   	pop    %ebp
80106c7c:	c3                   	ret    
80106c7d:	8d 76 00             	lea    0x0(%esi),%esi
80106c80:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106c83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c86:	5b                   	pop    %ebx
80106c87:	5e                   	pop    %esi
80106c88:	89 f8                	mov    %edi,%eax
80106c8a:	5f                   	pop    %edi
80106c8b:	5d                   	pop    %ebp
80106c8c:	c3                   	ret    
80106c8d:	8d 76 00             	lea    0x0(%esi),%esi

80106c90 <deallocuvm>:
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c96:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106c99:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106c9c:	39 d1                	cmp    %edx,%ecx
80106c9e:	73 10                	jae    80106cb0 <deallocuvm+0x20>
}
80106ca0:	5d                   	pop    %ebp
80106ca1:	e9 1a fb ff ff       	jmp    801067c0 <deallocuvm.part.0>
80106ca6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cad:	8d 76 00             	lea    0x0(%esi),%esi
80106cb0:	89 d0                	mov    %edx,%eax
80106cb2:	5d                   	pop    %ebp
80106cb3:	c3                   	ret    
80106cb4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cbf:	90                   	nop

80106cc0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
80106cc6:	83 ec 0c             	sub    $0xc,%esp
80106cc9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106ccc:	85 f6                	test   %esi,%esi
80106cce:	74 59                	je     80106d29 <freevm+0x69>
  if(newsz >= oldsz)
80106cd0:	31 c9                	xor    %ecx,%ecx
80106cd2:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106cd7:	89 f0                	mov    %esi,%eax
80106cd9:	89 f3                	mov    %esi,%ebx
80106cdb:	e8 e0 fa ff ff       	call   801067c0 <deallocuvm.part.0>
freevm(pde_t *pgdir)
80106ce0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ce6:	eb 0f                	jmp    80106cf7 <freevm+0x37>
80106ce8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cef:	90                   	nop
80106cf0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106cf3:	39 df                	cmp    %ebx,%edi
80106cf5:	74 23                	je     80106d1a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106cf7:	8b 03                	mov    (%ebx),%eax
80106cf9:	a8 01                	test   $0x1,%al
80106cfb:	74 f3                	je     80106cf0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106cfd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106d02:	83 ec 0c             	sub    $0xc,%esp
80106d05:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d08:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106d0d:	50                   	push   %eax
80106d0e:	e8 cd b6 ff ff       	call   801023e0 <kfree>
80106d13:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106d16:	39 df                	cmp    %ebx,%edi
80106d18:	75 dd                	jne    80106cf7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106d1a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d20:	5b                   	pop    %ebx
80106d21:	5e                   	pop    %esi
80106d22:	5f                   	pop    %edi
80106d23:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106d24:	e9 b7 b6 ff ff       	jmp    801023e0 <kfree>
    panic("freevm: no pgdir");
80106d29:	83 ec 0c             	sub    $0xc,%esp
80106d2c:	68 61 79 10 80       	push   $0x80107961
80106d31:	e8 5a 96 ff ff       	call   80100390 <panic>
80106d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d3d:	8d 76 00             	lea    0x0(%esi),%esi

80106d40 <setupkvm>:
{
80106d40:	55                   	push   %ebp
80106d41:	89 e5                	mov    %esp,%ebp
80106d43:	56                   	push   %esi
80106d44:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106d45:	e8 56 b8 ff ff       	call   801025a0 <kalloc>
80106d4a:	89 c6                	mov    %eax,%esi
80106d4c:	85 c0                	test   %eax,%eax
80106d4e:	74 42                	je     80106d92 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80106d50:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d53:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106d58:	68 00 10 00 00       	push   $0x1000
80106d5d:	6a 00                	push   $0x0
80106d5f:	50                   	push   %eax
80106d60:	e8 4b d8 ff ff       	call   801045b0 <memset>
80106d65:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106d68:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106d6b:	83 ec 08             	sub    $0x8,%esp
80106d6e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106d71:	ff 73 0c             	pushl  0xc(%ebx)
80106d74:	8b 13                	mov    (%ebx),%edx
80106d76:	50                   	push   %eax
80106d77:	29 c1                	sub    %eax,%ecx
80106d79:	89 f0                	mov    %esi,%eax
80106d7b:	e8 b0 f9 ff ff       	call   80106730 <mappages>
80106d80:	83 c4 10             	add    $0x10,%esp
80106d83:	85 c0                	test   %eax,%eax
80106d85:	78 19                	js     80106da0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106d87:	83 c3 10             	add    $0x10,%ebx
80106d8a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106d90:	75 d6                	jne    80106d68 <setupkvm+0x28>
}
80106d92:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106d95:	89 f0                	mov    %esi,%eax
80106d97:	5b                   	pop    %ebx
80106d98:	5e                   	pop    %esi
80106d99:	5d                   	pop    %ebp
80106d9a:	c3                   	ret    
80106d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106d9f:	90                   	nop
      freevm(pgdir);
80106da0:	83 ec 0c             	sub    $0xc,%esp
80106da3:	56                   	push   %esi
      return 0;
80106da4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80106da6:	e8 15 ff ff ff       	call   80106cc0 <freevm>
      return 0;
80106dab:	83 c4 10             	add    $0x10,%esp
}
80106dae:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106db1:	89 f0                	mov    %esi,%eax
80106db3:	5b                   	pop    %ebx
80106db4:	5e                   	pop    %esi
80106db5:	5d                   	pop    %ebp
80106db6:	c3                   	ret    
80106db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dbe:	66 90                	xchg   %ax,%ax

80106dc0 <kvmalloc>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106dc6:	e8 75 ff ff ff       	call   80106d40 <setupkvm>
80106dcb:	a3 a4 54 11 80       	mov    %eax,0x801154a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106dd0:	05 00 00 00 80       	add    $0x80000000,%eax
80106dd5:	0f 22 d8             	mov    %eax,%cr3
}
80106dd8:	c9                   	leave  
80106dd9:	c3                   	ret    
80106dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106de0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106de0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106de1:	31 c9                	xor    %ecx,%ecx
{
80106de3:	89 e5                	mov    %esp,%ebp
80106de5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106de8:	8b 55 0c             	mov    0xc(%ebp),%edx
80106deb:	8b 45 08             	mov    0x8(%ebp),%eax
80106dee:	e8 bd f8 ff ff       	call   801066b0 <walkpgdir>
  if(pte == 0)
80106df3:	85 c0                	test   %eax,%eax
80106df5:	74 05                	je     80106dfc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106df7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106dfa:	c9                   	leave  
80106dfb:	c3                   	ret    
    panic("clearpteu");
80106dfc:	83 ec 0c             	sub    $0xc,%esp
80106dff:	68 72 79 10 80       	push   $0x80107972
80106e04:	e8 87 95 ff ff       	call   80100390 <panic>
80106e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e10 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e19:	e8 22 ff ff ff       	call   80106d40 <setupkvm>
80106e1e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e21:	85 c0                	test   %eax,%eax
80106e23:	0f 84 9f 00 00 00    	je     80106ec8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e2c:	85 c9                	test   %ecx,%ecx
80106e2e:	0f 84 94 00 00 00    	je     80106ec8 <copyuvm+0xb8>
80106e34:	31 ff                	xor    %edi,%edi
80106e36:	eb 4a                	jmp    80106e82 <copyuvm+0x72>
80106e38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e3f:	90                   	nop
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106e40:	83 ec 04             	sub    $0x4,%esp
80106e43:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106e49:	68 00 10 00 00       	push   $0x1000
80106e4e:	53                   	push   %ebx
80106e4f:	50                   	push   %eax
80106e50:	e8 fb d7 ff ff       	call   80104650 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106e55:	58                   	pop    %eax
80106e56:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106e5c:	5a                   	pop    %edx
80106e5d:	ff 75 e4             	pushl  -0x1c(%ebp)
80106e60:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e65:	89 fa                	mov    %edi,%edx
80106e67:	50                   	push   %eax
80106e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e6b:	e8 c0 f8 ff ff       	call   80106730 <mappages>
80106e70:	83 c4 10             	add    $0x10,%esp
80106e73:	85 c0                	test   %eax,%eax
80106e75:	78 61                	js     80106ed8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106e77:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106e7d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106e80:	76 46                	jbe    80106ec8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106e82:	8b 45 08             	mov    0x8(%ebp),%eax
80106e85:	31 c9                	xor    %ecx,%ecx
80106e87:	89 fa                	mov    %edi,%edx
80106e89:	e8 22 f8 ff ff       	call   801066b0 <walkpgdir>
80106e8e:	85 c0                	test   %eax,%eax
80106e90:	74 61                	je     80106ef3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80106e92:	8b 00                	mov    (%eax),%eax
80106e94:	a8 01                	test   $0x1,%al
80106e96:	74 4e                	je     80106ee6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106e98:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106e9a:	25 ff 0f 00 00       	and    $0xfff,%eax
80106e9f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106ea2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    if((mem = kalloc()) == 0)
80106ea8:	e8 f3 b6 ff ff       	call   801025a0 <kalloc>
80106ead:	89 c6                	mov    %eax,%esi
80106eaf:	85 c0                	test   %eax,%eax
80106eb1:	75 8d                	jne    80106e40 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106eb3:	83 ec 0c             	sub    $0xc,%esp
80106eb6:	ff 75 e0             	pushl  -0x20(%ebp)
80106eb9:	e8 02 fe ff ff       	call   80106cc0 <freevm>
  return 0;
80106ebe:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80106ec5:	83 c4 10             	add    $0x10,%esp
}
80106ec8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ece:	5b                   	pop    %ebx
80106ecf:	5e                   	pop    %esi
80106ed0:	5f                   	pop    %edi
80106ed1:	5d                   	pop    %ebp
80106ed2:	c3                   	ret    
80106ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ed7:	90                   	nop
      kfree(mem);
80106ed8:	83 ec 0c             	sub    $0xc,%esp
80106edb:	56                   	push   %esi
80106edc:	e8 ff b4 ff ff       	call   801023e0 <kfree>
      goto bad;
80106ee1:	83 c4 10             	add    $0x10,%esp
80106ee4:	eb cd                	jmp    80106eb3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80106ee6:	83 ec 0c             	sub    $0xc,%esp
80106ee9:	68 96 79 10 80       	push   $0x80107996
80106eee:	e8 9d 94 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80106ef3:	83 ec 0c             	sub    $0xc,%esp
80106ef6:	68 7c 79 10 80       	push   $0x8010797c
80106efb:	e8 90 94 ff ff       	call   80100390 <panic>

80106f00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f01:	31 c9                	xor    %ecx,%ecx
{
80106f03:	89 e5                	mov    %esp,%ebp
80106f05:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106f08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f0e:	e8 9d f7 ff ff       	call   801066b0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f13:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80106f15:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80106f16:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80106f1d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80106f20:	05 00 00 00 80       	add    $0x80000000,%eax
80106f25:	83 fa 05             	cmp    $0x5,%edx
80106f28:	ba 00 00 00 00       	mov    $0x0,%edx
80106f2d:	0f 45 c2             	cmovne %edx,%eax
}
80106f30:	c3                   	ret    
80106f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f3f:	90                   	nop

80106f40 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106f40:	55                   	push   %ebp
80106f41:	89 e5                	mov    %esp,%ebp
80106f43:	57                   	push   %edi
80106f44:	56                   	push   %esi
80106f45:	53                   	push   %ebx
80106f46:	83 ec 0c             	sub    $0xc,%esp
80106f49:	8b 75 14             	mov    0x14(%ebp),%esi
80106f4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106f4f:	85 f6                	test   %esi,%esi
80106f51:	75 38                	jne    80106f8b <copyout+0x4b>
80106f53:	eb 6b                	jmp    80106fc0 <copyout+0x80>
80106f55:	8d 76 00             	lea    0x0(%esi),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106f58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f5b:	89 fb                	mov    %edi,%ebx
80106f5d:	29 d3                	sub    %edx,%ebx
80106f5f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106f65:	39 f3                	cmp    %esi,%ebx
80106f67:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106f6a:	29 fa                	sub    %edi,%edx
80106f6c:	83 ec 04             	sub    $0x4,%esp
80106f6f:	01 c2                	add    %eax,%edx
80106f71:	53                   	push   %ebx
80106f72:	ff 75 10             	pushl  0x10(%ebp)
80106f75:	52                   	push   %edx
80106f76:	e8 d5 d6 ff ff       	call   80104650 <memmove>
    len -= n;
    buf += n;
80106f7b:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80106f7e:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80106f84:	83 c4 10             	add    $0x10,%esp
80106f87:	29 de                	sub    %ebx,%esi
80106f89:	74 35                	je     80106fc0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80106f8b:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f8d:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80106f90:	89 55 0c             	mov    %edx,0xc(%ebp)
80106f93:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80106f99:	57                   	push   %edi
80106f9a:	ff 75 08             	pushl  0x8(%ebp)
80106f9d:	e8 5e ff ff ff       	call   80106f00 <uva2ka>
    if(pa0 == 0)
80106fa2:	83 c4 10             	add    $0x10,%esp
80106fa5:	85 c0                	test   %eax,%eax
80106fa7:	75 af                	jne    80106f58 <copyout+0x18>
  }
  return 0;
}
80106fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106fac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106fb1:	5b                   	pop    %ebx
80106fb2:	5e                   	pop    %esi
80106fb3:	5f                   	pop    %edi
80106fb4:	5d                   	pop    %ebp
80106fb5:	c3                   	ret    
80106fb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
80106fc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106fc3:	31 c0                	xor    %eax,%eax
}
80106fc5:	5b                   	pop    %ebx
80106fc6:	5e                   	pop    %esi
80106fc7:	5f                   	pop    %edi
80106fc8:	5d                   	pop    %ebp
80106fc9:	c3                   	ret    
