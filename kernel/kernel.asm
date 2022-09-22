
kernel/kernel：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	83010113          	addi	sp,sp,-2000 # 80009830 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	00009617          	auipc	a2,0x9
    8000004e:	fe660613          	addi	a2,a2,-26 # 80009030 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	b3478793          	addi	a5,a5,-1228 # 80005b90 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd87ff>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e1878793          	addi	a5,a5,-488 # 80000ebe <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000ec:	715d                	addi	sp,sp,-80
    800000ee:	e486                	sd	ra,72(sp)
    800000f0:	e0a2                	sd	s0,64(sp)
    800000f2:	fc26                	sd	s1,56(sp)
    800000f4:	f84a                	sd	s2,48(sp)
    800000f6:	f44e                	sd	s3,40(sp)
    800000f8:	f052                	sd	s4,32(sp)
    800000fa:	ec56                	sd	s5,24(sp)
    800000fc:	0880                	addi	s0,sp,80
    800000fe:	8a2a                	mv	s4,a0
    80000100:	84ae                	mv	s1,a1
    80000102:	89b2                	mv	s3,a2
  int i;

  acquire(&cons.lock);
    80000104:	00011517          	auipc	a0,0x11
    80000108:	72c50513          	addi	a0,a0,1836 # 80011830 <cons>
    8000010c:	00001097          	auipc	ra,0x1
    80000110:	b04080e7          	jalr	-1276(ra) # 80000c10 <acquire>
  for(i = 0; i < n; i++){
    80000114:	05305b63          	blez	s3,8000016a <consolewrite+0x7e>
    80000118:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011a:	5afd                	li	s5,-1
    8000011c:	4685                	li	a3,1
    8000011e:	8626                	mv	a2,s1
    80000120:	85d2                	mv	a1,s4
    80000122:	fbf40513          	addi	a0,s0,-65
    80000126:	00002097          	auipc	ra,0x2
    8000012a:	37a080e7          	jalr	890(ra) # 800024a0 <either_copyin>
    8000012e:	01550c63          	beq	a0,s5,80000146 <consolewrite+0x5a>
      break;
    uartputc(c);
    80000132:	fbf44503          	lbu	a0,-65(s0)
    80000136:	00000097          	auipc	ra,0x0
    8000013a:	7aa080e7          	jalr	1962(ra) # 800008e0 <uartputc>
  for(i = 0; i < n; i++){
    8000013e:	2905                	addiw	s2,s2,1
    80000140:	0485                	addi	s1,s1,1
    80000142:	fd299de3          	bne	s3,s2,8000011c <consolewrite+0x30>
  }
  release(&cons.lock);
    80000146:	00011517          	auipc	a0,0x11
    8000014a:	6ea50513          	addi	a0,a0,1770 # 80011830 <cons>
    8000014e:	00001097          	auipc	ra,0x1
    80000152:	b76080e7          	jalr	-1162(ra) # 80000cc4 <release>

  return i;
}
    80000156:	854a                	mv	a0,s2
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	7942                	ld	s2,48(sp)
    80000160:	79a2                	ld	s3,40(sp)
    80000162:	7a02                	ld	s4,32(sp)
    80000164:	6ae2                	ld	s5,24(sp)
    80000166:	6161                	addi	sp,sp,80
    80000168:	8082                	ret
  for(i = 0; i < n; i++){
    8000016a:	4901                	li	s2,0
    8000016c:	bfe9                	j	80000146 <consolewrite+0x5a>

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	7119                	addi	sp,sp,-128
    80000170:	fc86                	sd	ra,120(sp)
    80000172:	f8a2                	sd	s0,112(sp)
    80000174:	f4a6                	sd	s1,104(sp)
    80000176:	f0ca                	sd	s2,96(sp)
    80000178:	ecce                	sd	s3,88(sp)
    8000017a:	e8d2                	sd	s4,80(sp)
    8000017c:	e4d6                	sd	s5,72(sp)
    8000017e:	e0da                	sd	s6,64(sp)
    80000180:	fc5e                	sd	s7,56(sp)
    80000182:	f862                	sd	s8,48(sp)
    80000184:	f466                	sd	s9,40(sp)
    80000186:	f06a                	sd	s10,32(sp)
    80000188:	ec6e                	sd	s11,24(sp)
    8000018a:	0100                	addi	s0,sp,128
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8aae                	mv	s5,a1
    80000190:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000196:	00011517          	auipc	a0,0x11
    8000019a:	69a50513          	addi	a0,a0,1690 # 80011830 <cons>
    8000019e:	00001097          	auipc	ra,0x1
    800001a2:	a72080e7          	jalr	-1422(ra) # 80000c10 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800001a6:	00011497          	auipc	s1,0x11
    800001aa:	68a48493          	addi	s1,s1,1674 # 80011830 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001ae:	89a6                	mv	s3,s1
    800001b0:	00011917          	auipc	s2,0x11
    800001b4:	71890913          	addi	s2,s2,1816 # 800118c8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    800001b8:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001ba:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    800001bc:	4da9                	li	s11,10
  while(n > 0){
    800001be:	07405863          	blez	s4,8000022e <consoleread+0xc0>
    while(cons.r == cons.w){
    800001c2:	0984a783          	lw	a5,152(s1)
    800001c6:	09c4a703          	lw	a4,156(s1)
    800001ca:	02f71463          	bne	a4,a5,800001f2 <consoleread+0x84>
      if(myproc()->killed){
    800001ce:	00002097          	auipc	ra,0x2
    800001d2:	810080e7          	jalr	-2032(ra) # 800019de <myproc>
    800001d6:	591c                	lw	a5,48(a0)
    800001d8:	e7b5                	bnez	a5,80000244 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    800001da:	85ce                	mv	a1,s3
    800001dc:	854a                	mv	a0,s2
    800001de:	00002097          	auipc	ra,0x2
    800001e2:	00c080e7          	jalr	12(ra) # 800021ea <sleep>
    while(cons.r == cons.w){
    800001e6:	0984a783          	lw	a5,152(s1)
    800001ea:	09c4a703          	lw	a4,156(s1)
    800001ee:	fef700e3          	beq	a4,a5,800001ce <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    800001f2:	0017871b          	addiw	a4,a5,1
    800001f6:	08e4ac23          	sw	a4,152(s1)
    800001fa:	07f7f713          	andi	a4,a5,127
    800001fe:	9726                	add	a4,a4,s1
    80000200:	01874703          	lbu	a4,24(a4)
    80000204:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000208:	079c0663          	beq	s8,s9,80000274 <consoleread+0x106>
    cbuf = c;
    8000020c:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	f8f40613          	addi	a2,s0,-113
    80000216:	85d6                	mv	a1,s5
    80000218:	855a                	mv	a0,s6
    8000021a:	00002097          	auipc	ra,0x2
    8000021e:	230080e7          	jalr	560(ra) # 8000244a <either_copyout>
    80000222:	01a50663          	beq	a0,s10,8000022e <consoleread+0xc0>
    dst++;
    80000226:	0a85                	addi	s5,s5,1
    --n;
    80000228:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    8000022a:	f9bc1ae3          	bne	s8,s11,800001be <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    8000022e:	00011517          	auipc	a0,0x11
    80000232:	60250513          	addi	a0,a0,1538 # 80011830 <cons>
    80000236:	00001097          	auipc	ra,0x1
    8000023a:	a8e080e7          	jalr	-1394(ra) # 80000cc4 <release>

  return target - n;
    8000023e:	414b853b          	subw	a0,s7,s4
    80000242:	a811                	j	80000256 <consoleread+0xe8>
        release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	5ec50513          	addi	a0,a0,1516 # 80011830 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	a78080e7          	jalr	-1416(ra) # 80000cc4 <release>
        return -1;
    80000254:	557d                	li	a0,-1
}
    80000256:	70e6                	ld	ra,120(sp)
    80000258:	7446                	ld	s0,112(sp)
    8000025a:	74a6                	ld	s1,104(sp)
    8000025c:	7906                	ld	s2,96(sp)
    8000025e:	69e6                	ld	s3,88(sp)
    80000260:	6a46                	ld	s4,80(sp)
    80000262:	6aa6                	ld	s5,72(sp)
    80000264:	6b06                	ld	s6,64(sp)
    80000266:	7be2                	ld	s7,56(sp)
    80000268:	7c42                	ld	s8,48(sp)
    8000026a:	7ca2                	ld	s9,40(sp)
    8000026c:	7d02                	ld	s10,32(sp)
    8000026e:	6de2                	ld	s11,24(sp)
    80000270:	6109                	addi	sp,sp,128
    80000272:	8082                	ret
      if(n < target){
    80000274:	000a071b          	sext.w	a4,s4
    80000278:	fb777be3          	bgeu	a4,s7,8000022e <consoleread+0xc0>
        cons.r--;
    8000027c:	00011717          	auipc	a4,0x11
    80000280:	64f72623          	sw	a5,1612(a4) # 800118c8 <cons+0x98>
    80000284:	b76d                	j	8000022e <consoleread+0xc0>

0000000080000286 <consputc>:
{
    80000286:	1141                	addi	sp,sp,-16
    80000288:	e406                	sd	ra,8(sp)
    8000028a:	e022                	sd	s0,0(sp)
    8000028c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000028e:	10000793          	li	a5,256
    80000292:	00f50a63          	beq	a0,a5,800002a6 <consputc+0x20>
    uartputc_sync(c);
    80000296:	00000097          	auipc	ra,0x0
    8000029a:	564080e7          	jalr	1380(ra) # 800007fa <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	552080e7          	jalr	1362(ra) # 800007fa <uartputc_sync>
    800002b0:	02000513          	li	a0,32
    800002b4:	00000097          	auipc	ra,0x0
    800002b8:	546080e7          	jalr	1350(ra) # 800007fa <uartputc_sync>
    800002bc:	4521                	li	a0,8
    800002be:	00000097          	auipc	ra,0x0
    800002c2:	53c080e7          	jalr	1340(ra) # 800007fa <uartputc_sync>
    800002c6:	bfe1                	j	8000029e <consputc+0x18>

00000000800002c8 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002c8:	1101                	addi	sp,sp,-32
    800002ca:	ec06                	sd	ra,24(sp)
    800002cc:	e822                	sd	s0,16(sp)
    800002ce:	e426                	sd	s1,8(sp)
    800002d0:	e04a                	sd	s2,0(sp)
    800002d2:	1000                	addi	s0,sp,32
    800002d4:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002d6:	00011517          	auipc	a0,0x11
    800002da:	55a50513          	addi	a0,a0,1370 # 80011830 <cons>
    800002de:	00001097          	auipc	ra,0x1
    800002e2:	932080e7          	jalr	-1742(ra) # 80000c10 <acquire>

  switch(c){
    800002e6:	47d5                	li	a5,21
    800002e8:	0af48663          	beq	s1,a5,80000394 <consoleintr+0xcc>
    800002ec:	0297ca63          	blt	a5,s1,80000320 <consoleintr+0x58>
    800002f0:	47a1                	li	a5,8
    800002f2:	0ef48763          	beq	s1,a5,800003e0 <consoleintr+0x118>
    800002f6:	47c1                	li	a5,16
    800002f8:	10f49a63          	bne	s1,a5,8000040c <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    800002fc:	00002097          	auipc	ra,0x2
    80000300:	1fa080e7          	jalr	506(ra) # 800024f6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000304:	00011517          	auipc	a0,0x11
    80000308:	52c50513          	addi	a0,a0,1324 # 80011830 <cons>
    8000030c:	00001097          	auipc	ra,0x1
    80000310:	9b8080e7          	jalr	-1608(ra) # 80000cc4 <release>
}
    80000314:	60e2                	ld	ra,24(sp)
    80000316:	6442                	ld	s0,16(sp)
    80000318:	64a2                	ld	s1,8(sp)
    8000031a:	6902                	ld	s2,0(sp)
    8000031c:	6105                	addi	sp,sp,32
    8000031e:	8082                	ret
  switch(c){
    80000320:	07f00793          	li	a5,127
    80000324:	0af48e63          	beq	s1,a5,800003e0 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80000328:	00011717          	auipc	a4,0x11
    8000032c:	50870713          	addi	a4,a4,1288 # 80011830 <cons>
    80000330:	0a072783          	lw	a5,160(a4)
    80000334:	09872703          	lw	a4,152(a4)
    80000338:	9f99                	subw	a5,a5,a4
    8000033a:	07f00713          	li	a4,127
    8000033e:	fcf763e3          	bltu	a4,a5,80000304 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000342:	47b5                	li	a5,13
    80000344:	0cf48763          	beq	s1,a5,80000412 <consoleintr+0x14a>
      consputc(c);
    80000348:	8526                	mv	a0,s1
    8000034a:	00000097          	auipc	ra,0x0
    8000034e:	f3c080e7          	jalr	-196(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000352:	00011797          	auipc	a5,0x11
    80000356:	4de78793          	addi	a5,a5,1246 # 80011830 <cons>
    8000035a:	0a07a703          	lw	a4,160(a5)
    8000035e:	0017069b          	addiw	a3,a4,1
    80000362:	0006861b          	sext.w	a2,a3
    80000366:	0ad7a023          	sw	a3,160(a5)
    8000036a:	07f77713          	andi	a4,a4,127
    8000036e:	97ba                	add	a5,a5,a4
    80000370:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000374:	47a9                	li	a5,10
    80000376:	0cf48563          	beq	s1,a5,80000440 <consoleintr+0x178>
    8000037a:	4791                	li	a5,4
    8000037c:	0cf48263          	beq	s1,a5,80000440 <consoleintr+0x178>
    80000380:	00011797          	auipc	a5,0x11
    80000384:	5487a783          	lw	a5,1352(a5) # 800118c8 <cons+0x98>
    80000388:	0807879b          	addiw	a5,a5,128
    8000038c:	f6f61ce3          	bne	a2,a5,80000304 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000390:	863e                	mv	a2,a5
    80000392:	a07d                	j	80000440 <consoleintr+0x178>
    while(cons.e != cons.w &&
    80000394:	00011717          	auipc	a4,0x11
    80000398:	49c70713          	addi	a4,a4,1180 # 80011830 <cons>
    8000039c:	0a072783          	lw	a5,160(a4)
    800003a0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003a4:	00011497          	auipc	s1,0x11
    800003a8:	48c48493          	addi	s1,s1,1164 # 80011830 <cons>
    while(cons.e != cons.w &&
    800003ac:	4929                	li	s2,10
    800003ae:	f4f70be3          	beq	a4,a5,80000304 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b2:	37fd                	addiw	a5,a5,-1
    800003b4:	07f7f713          	andi	a4,a5,127
    800003b8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ba:	01874703          	lbu	a4,24(a4)
    800003be:	f52703e3          	beq	a4,s2,80000304 <consoleintr+0x3c>
      cons.e--;
    800003c2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003c6:	10000513          	li	a0,256
    800003ca:	00000097          	auipc	ra,0x0
    800003ce:	ebc080e7          	jalr	-324(ra) # 80000286 <consputc>
    while(cons.e != cons.w &&
    800003d2:	0a04a783          	lw	a5,160(s1)
    800003d6:	09c4a703          	lw	a4,156(s1)
    800003da:	fcf71ce3          	bne	a4,a5,800003b2 <consoleintr+0xea>
    800003de:	b71d                	j	80000304 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003e0:	00011717          	auipc	a4,0x11
    800003e4:	45070713          	addi	a4,a4,1104 # 80011830 <cons>
    800003e8:	0a072783          	lw	a5,160(a4)
    800003ec:	09c72703          	lw	a4,156(a4)
    800003f0:	f0f70ae3          	beq	a4,a5,80000304 <consoleintr+0x3c>
      cons.e--;
    800003f4:	37fd                	addiw	a5,a5,-1
    800003f6:	00011717          	auipc	a4,0x11
    800003fa:	4cf72d23          	sw	a5,1242(a4) # 800118d0 <cons+0xa0>
      consputc(BACKSPACE);
    800003fe:	10000513          	li	a0,256
    80000402:	00000097          	auipc	ra,0x0
    80000406:	e84080e7          	jalr	-380(ra) # 80000286 <consputc>
    8000040a:	bded                	j	80000304 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000040c:	ee048ce3          	beqz	s1,80000304 <consoleintr+0x3c>
    80000410:	bf21                	j	80000328 <consoleintr+0x60>
      consputc(c);
    80000412:	4529                	li	a0,10
    80000414:	00000097          	auipc	ra,0x0
    80000418:	e72080e7          	jalr	-398(ra) # 80000286 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000041c:	00011797          	auipc	a5,0x11
    80000420:	41478793          	addi	a5,a5,1044 # 80011830 <cons>
    80000424:	0a07a703          	lw	a4,160(a5)
    80000428:	0017069b          	addiw	a3,a4,1
    8000042c:	0006861b          	sext.w	a2,a3
    80000430:	0ad7a023          	sw	a3,160(a5)
    80000434:	07f77713          	andi	a4,a4,127
    80000438:	97ba                	add	a5,a5,a4
    8000043a:	4729                	li	a4,10
    8000043c:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000440:	00011797          	auipc	a5,0x11
    80000444:	48c7a623          	sw	a2,1164(a5) # 800118cc <cons+0x9c>
        wakeup(&cons.r);
    80000448:	00011517          	auipc	a0,0x11
    8000044c:	48050513          	addi	a0,a0,1152 # 800118c8 <cons+0x98>
    80000450:	00002097          	auipc	ra,0x2
    80000454:	f20080e7          	jalr	-224(ra) # 80002370 <wakeup>
    80000458:	b575                	j	80000304 <consoleintr+0x3c>

000000008000045a <consoleinit>:

void
consoleinit(void)
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e406                	sd	ra,8(sp)
    8000045e:	e022                	sd	s0,0(sp)
    80000460:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000462:	00008597          	auipc	a1,0x8
    80000466:	bae58593          	addi	a1,a1,-1106 # 80008010 <etext+0x10>
    8000046a:	00011517          	auipc	a0,0x11
    8000046e:	3c650513          	addi	a0,a0,966 # 80011830 <cons>
    80000472:	00000097          	auipc	ra,0x0
    80000476:	70e080e7          	jalr	1806(ra) # 80000b80 <initlock>

  uartinit();
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	330080e7          	jalr	816(ra) # 800007aa <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000482:	00021797          	auipc	a5,0x21
    80000486:	52e78793          	addi	a5,a5,1326 # 800219b0 <devsw>
    8000048a:	00000717          	auipc	a4,0x0
    8000048e:	ce470713          	addi	a4,a4,-796 # 8000016e <consoleread>
    80000492:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000494:	00000717          	auipc	a4,0x0
    80000498:	c5870713          	addi	a4,a4,-936 # 800000ec <consolewrite>
    8000049c:	ef98                	sd	a4,24(a5)
}
    8000049e:	60a2                	ld	ra,8(sp)
    800004a0:	6402                	ld	s0,0(sp)
    800004a2:	0141                	addi	sp,sp,16
    800004a4:	8082                	ret

00000000800004a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004a6:	7179                	addi	sp,sp,-48
    800004a8:	f406                	sd	ra,40(sp)
    800004aa:	f022                	sd	s0,32(sp)
    800004ac:	ec26                	sd	s1,24(sp)
    800004ae:	e84a                	sd	s2,16(sp)
    800004b0:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004b2:	c219                	beqz	a2,800004b8 <printint+0x12>
    800004b4:	08054663          	bltz	a0,80000540 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004b8:	2501                	sext.w	a0,a0
    800004ba:	4881                	li	a7,0
    800004bc:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004c0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004c2:	2581                	sext.w	a1,a1
    800004c4:	00008617          	auipc	a2,0x8
    800004c8:	b7c60613          	addi	a2,a2,-1156 # 80008040 <digits>
    800004cc:	883a                	mv	a6,a4
    800004ce:	2705                	addiw	a4,a4,1
    800004d0:	02b577bb          	remuw	a5,a0,a1
    800004d4:	1782                	slli	a5,a5,0x20
    800004d6:	9381                	srli	a5,a5,0x20
    800004d8:	97b2                	add	a5,a5,a2
    800004da:	0007c783          	lbu	a5,0(a5)
    800004de:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004e2:	0005079b          	sext.w	a5,a0
    800004e6:	02b5553b          	divuw	a0,a0,a1
    800004ea:	0685                	addi	a3,a3,1
    800004ec:	feb7f0e3          	bgeu	a5,a1,800004cc <printint+0x26>

  if(sign)
    800004f0:	00088b63          	beqz	a7,80000506 <printint+0x60>
    buf[i++] = '-';
    800004f4:	fe040793          	addi	a5,s0,-32
    800004f8:	973e                	add	a4,a4,a5
    800004fa:	02d00793          	li	a5,45
    800004fe:	fef70823          	sb	a5,-16(a4)
    80000502:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000506:	02e05763          	blez	a4,80000534 <printint+0x8e>
    8000050a:	fd040793          	addi	a5,s0,-48
    8000050e:	00e784b3          	add	s1,a5,a4
    80000512:	fff78913          	addi	s2,a5,-1
    80000516:	993a                	add	s2,s2,a4
    80000518:	377d                	addiw	a4,a4,-1
    8000051a:	1702                	slli	a4,a4,0x20
    8000051c:	9301                	srli	a4,a4,0x20
    8000051e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000522:	fff4c503          	lbu	a0,-1(s1)
    80000526:	00000097          	auipc	ra,0x0
    8000052a:	d60080e7          	jalr	-672(ra) # 80000286 <consputc>
  while(--i >= 0)
    8000052e:	14fd                	addi	s1,s1,-1
    80000530:	ff2499e3          	bne	s1,s2,80000522 <printint+0x7c>
}
    80000534:	70a2                	ld	ra,40(sp)
    80000536:	7402                	ld	s0,32(sp)
    80000538:	64e2                	ld	s1,24(sp)
    8000053a:	6942                	ld	s2,16(sp)
    8000053c:	6145                	addi	sp,sp,48
    8000053e:	8082                	ret
    x = -xx;
    80000540:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000544:	4885                	li	a7,1
    x = -xx;
    80000546:	bf9d                	j	800004bc <printint+0x16>

0000000080000548 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000548:	1101                	addi	sp,sp,-32
    8000054a:	ec06                	sd	ra,24(sp)
    8000054c:	e822                	sd	s0,16(sp)
    8000054e:	e426                	sd	s1,8(sp)
    80000550:	1000                	addi	s0,sp,32
    80000552:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000554:	00011797          	auipc	a5,0x11
    80000558:	3807ae23          	sw	zero,924(a5) # 800118f0 <pr+0x18>
  printf("panic: ");
    8000055c:	00008517          	auipc	a0,0x8
    80000560:	abc50513          	addi	a0,a0,-1348 # 80008018 <etext+0x18>
    80000564:	00000097          	auipc	ra,0x0
    80000568:	02e080e7          	jalr	46(ra) # 80000592 <printf>
  printf(s);
    8000056c:	8526                	mv	a0,s1
    8000056e:	00000097          	auipc	ra,0x0
    80000572:	024080e7          	jalr	36(ra) # 80000592 <printf>
  printf("\n");
    80000576:	00008517          	auipc	a0,0x8
    8000057a:	b5250513          	addi	a0,a0,-1198 # 800080c8 <digits+0x88>
    8000057e:	00000097          	auipc	ra,0x0
    80000582:	014080e7          	jalr	20(ra) # 80000592 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000586:	4785                	li	a5,1
    80000588:	00009717          	auipc	a4,0x9
    8000058c:	a6f72c23          	sw	a5,-1416(a4) # 80009000 <panicked>
  for(;;)
    80000590:	a001                	j	80000590 <panic+0x48>

0000000080000592 <printf>:
{
    80000592:	7131                	addi	sp,sp,-192
    80000594:	fc86                	sd	ra,120(sp)
    80000596:	f8a2                	sd	s0,112(sp)
    80000598:	f4a6                	sd	s1,104(sp)
    8000059a:	f0ca                	sd	s2,96(sp)
    8000059c:	ecce                	sd	s3,88(sp)
    8000059e:	e8d2                	sd	s4,80(sp)
    800005a0:	e4d6                	sd	s5,72(sp)
    800005a2:	e0da                	sd	s6,64(sp)
    800005a4:	fc5e                	sd	s7,56(sp)
    800005a6:	f862                	sd	s8,48(sp)
    800005a8:	f466                	sd	s9,40(sp)
    800005aa:	f06a                	sd	s10,32(sp)
    800005ac:	ec6e                	sd	s11,24(sp)
    800005ae:	0100                	addi	s0,sp,128
    800005b0:	8a2a                	mv	s4,a0
    800005b2:	e40c                	sd	a1,8(s0)
    800005b4:	e810                	sd	a2,16(s0)
    800005b6:	ec14                	sd	a3,24(s0)
    800005b8:	f018                	sd	a4,32(s0)
    800005ba:	f41c                	sd	a5,40(s0)
    800005bc:	03043823          	sd	a6,48(s0)
    800005c0:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c4:	00011d97          	auipc	s11,0x11
    800005c8:	32cdad83          	lw	s11,812(s11) # 800118f0 <pr+0x18>
  if(locking)
    800005cc:	020d9b63          	bnez	s11,80000602 <printf+0x70>
  if (fmt == 0)
    800005d0:	040a0263          	beqz	s4,80000614 <printf+0x82>
  va_start(ap, fmt);
    800005d4:	00840793          	addi	a5,s0,8
    800005d8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005dc:	000a4503          	lbu	a0,0(s4)
    800005e0:	16050263          	beqz	a0,80000744 <printf+0x1b2>
    800005e4:	4481                	li	s1,0
    if(c != '%'){
    800005e6:	02500a93          	li	s5,37
    switch(c){
    800005ea:	07000b13          	li	s6,112
  consputc('x');
    800005ee:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800005f0:	00008b97          	auipc	s7,0x8
    800005f4:	a50b8b93          	addi	s7,s7,-1456 # 80008040 <digits>
    switch(c){
    800005f8:	07300c93          	li	s9,115
    800005fc:	06400c13          	li	s8,100
    80000600:	a82d                	j	8000063a <printf+0xa8>
    acquire(&pr.lock);
    80000602:	00011517          	auipc	a0,0x11
    80000606:	2d650513          	addi	a0,a0,726 # 800118d8 <pr>
    8000060a:	00000097          	auipc	ra,0x0
    8000060e:	606080e7          	jalr	1542(ra) # 80000c10 <acquire>
    80000612:	bf7d                	j	800005d0 <printf+0x3e>
    panic("null fmt");
    80000614:	00008517          	auipc	a0,0x8
    80000618:	a1450513          	addi	a0,a0,-1516 # 80008028 <etext+0x28>
    8000061c:	00000097          	auipc	ra,0x0
    80000620:	f2c080e7          	jalr	-212(ra) # 80000548 <panic>
      consputc(c);
    80000624:	00000097          	auipc	ra,0x0
    80000628:	c62080e7          	jalr	-926(ra) # 80000286 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062c:	2485                	addiw	s1,s1,1
    8000062e:	009a07b3          	add	a5,s4,s1
    80000632:	0007c503          	lbu	a0,0(a5)
    80000636:	10050763          	beqz	a0,80000744 <printf+0x1b2>
    if(c != '%'){
    8000063a:	ff5515e3          	bne	a0,s5,80000624 <printf+0x92>
    c = fmt[++i] & 0xff;
    8000063e:	2485                	addiw	s1,s1,1
    80000640:	009a07b3          	add	a5,s4,s1
    80000644:	0007c783          	lbu	a5,0(a5)
    80000648:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000064c:	cfe5                	beqz	a5,80000744 <printf+0x1b2>
    switch(c){
    8000064e:	05678a63          	beq	a5,s6,800006a2 <printf+0x110>
    80000652:	02fb7663          	bgeu	s6,a5,8000067e <printf+0xec>
    80000656:	09978963          	beq	a5,s9,800006e8 <printf+0x156>
    8000065a:	07800713          	li	a4,120
    8000065e:	0ce79863          	bne	a5,a4,8000072e <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000662:	f8843783          	ld	a5,-120(s0)
    80000666:	00878713          	addi	a4,a5,8
    8000066a:	f8e43423          	sd	a4,-120(s0)
    8000066e:	4605                	li	a2,1
    80000670:	85ea                	mv	a1,s10
    80000672:	4388                	lw	a0,0(a5)
    80000674:	00000097          	auipc	ra,0x0
    80000678:	e32080e7          	jalr	-462(ra) # 800004a6 <printint>
      break;
    8000067c:	bf45                	j	8000062c <printf+0x9a>
    switch(c){
    8000067e:	0b578263          	beq	a5,s5,80000722 <printf+0x190>
    80000682:	0b879663          	bne	a5,s8,8000072e <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80000686:	f8843783          	ld	a5,-120(s0)
    8000068a:	00878713          	addi	a4,a5,8
    8000068e:	f8e43423          	sd	a4,-120(s0)
    80000692:	4605                	li	a2,1
    80000694:	45a9                	li	a1,10
    80000696:	4388                	lw	a0,0(a5)
    80000698:	00000097          	auipc	ra,0x0
    8000069c:	e0e080e7          	jalr	-498(ra) # 800004a6 <printint>
      break;
    800006a0:	b771                	j	8000062c <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006a2:	f8843783          	ld	a5,-120(s0)
    800006a6:	00878713          	addi	a4,a5,8
    800006aa:	f8e43423          	sd	a4,-120(s0)
    800006ae:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006b2:	03000513          	li	a0,48
    800006b6:	00000097          	auipc	ra,0x0
    800006ba:	bd0080e7          	jalr	-1072(ra) # 80000286 <consputc>
  consputc('x');
    800006be:	07800513          	li	a0,120
    800006c2:	00000097          	auipc	ra,0x0
    800006c6:	bc4080e7          	jalr	-1084(ra) # 80000286 <consputc>
    800006ca:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006cc:	03c9d793          	srli	a5,s3,0x3c
    800006d0:	97de                	add	a5,a5,s7
    800006d2:	0007c503          	lbu	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	bb0080e7          	jalr	-1104(ra) # 80000286 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006de:	0992                	slli	s3,s3,0x4
    800006e0:	397d                	addiw	s2,s2,-1
    800006e2:	fe0915e3          	bnez	s2,800006cc <printf+0x13a>
    800006e6:	b799                	j	8000062c <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	addi	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	0007b903          	ld	s2,0(a5)
    800006f8:	00090e63          	beqz	s2,80000714 <printf+0x182>
      for(; *s; s++)
    800006fc:	00094503          	lbu	a0,0(s2)
    80000700:	d515                	beqz	a0,8000062c <printf+0x9a>
        consputc(*s);
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b84080e7          	jalr	-1148(ra) # 80000286 <consputc>
      for(; *s; s++)
    8000070a:	0905                	addi	s2,s2,1
    8000070c:	00094503          	lbu	a0,0(s2)
    80000710:	f96d                	bnez	a0,80000702 <printf+0x170>
    80000712:	bf29                	j	8000062c <printf+0x9a>
        s = "(null)";
    80000714:	00008917          	auipc	s2,0x8
    80000718:	90c90913          	addi	s2,s2,-1780 # 80008020 <etext+0x20>
      for(; *s; s++)
    8000071c:	02800513          	li	a0,40
    80000720:	b7cd                	j	80000702 <printf+0x170>
      consputc('%');
    80000722:	8556                	mv	a0,s5
    80000724:	00000097          	auipc	ra,0x0
    80000728:	b62080e7          	jalr	-1182(ra) # 80000286 <consputc>
      break;
    8000072c:	b701                	j	8000062c <printf+0x9a>
      consputc('%');
    8000072e:	8556                	mv	a0,s5
    80000730:	00000097          	auipc	ra,0x0
    80000734:	b56080e7          	jalr	-1194(ra) # 80000286 <consputc>
      consputc(c);
    80000738:	854a                	mv	a0,s2
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	b4c080e7          	jalr	-1204(ra) # 80000286 <consputc>
      break;
    80000742:	b5ed                	j	8000062c <printf+0x9a>
  if(locking)
    80000744:	020d9163          	bnez	s11,80000766 <printf+0x1d4>
}
    80000748:	70e6                	ld	ra,120(sp)
    8000074a:	7446                	ld	s0,112(sp)
    8000074c:	74a6                	ld	s1,104(sp)
    8000074e:	7906                	ld	s2,96(sp)
    80000750:	69e6                	ld	s3,88(sp)
    80000752:	6a46                	ld	s4,80(sp)
    80000754:	6aa6                	ld	s5,72(sp)
    80000756:	6b06                	ld	s6,64(sp)
    80000758:	7be2                	ld	s7,56(sp)
    8000075a:	7c42                	ld	s8,48(sp)
    8000075c:	7ca2                	ld	s9,40(sp)
    8000075e:	7d02                	ld	s10,32(sp)
    80000760:	6de2                	ld	s11,24(sp)
    80000762:	6129                	addi	sp,sp,192
    80000764:	8082                	ret
    release(&pr.lock);
    80000766:	00011517          	auipc	a0,0x11
    8000076a:	17250513          	addi	a0,a0,370 # 800118d8 <pr>
    8000076e:	00000097          	auipc	ra,0x0
    80000772:	556080e7          	jalr	1366(ra) # 80000cc4 <release>
}
    80000776:	bfc9                	j	80000748 <printf+0x1b6>

0000000080000778 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000778:	1101                	addi	sp,sp,-32
    8000077a:	ec06                	sd	ra,24(sp)
    8000077c:	e822                	sd	s0,16(sp)
    8000077e:	e426                	sd	s1,8(sp)
    80000780:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80000782:	00011497          	auipc	s1,0x11
    80000786:	15648493          	addi	s1,s1,342 # 800118d8 <pr>
    8000078a:	00008597          	auipc	a1,0x8
    8000078e:	8ae58593          	addi	a1,a1,-1874 # 80008038 <etext+0x38>
    80000792:	8526                	mv	a0,s1
    80000794:	00000097          	auipc	ra,0x0
    80000798:	3ec080e7          	jalr	1004(ra) # 80000b80 <initlock>
  pr.locking = 1;
    8000079c:	4785                	li	a5,1
    8000079e:	cc9c                	sw	a5,24(s1)
}
    800007a0:	60e2                	ld	ra,24(sp)
    800007a2:	6442                	ld	s0,16(sp)
    800007a4:	64a2                	ld	s1,8(sp)
    800007a6:	6105                	addi	sp,sp,32
    800007a8:	8082                	ret

00000000800007aa <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007aa:	1141                	addi	sp,sp,-16
    800007ac:	e406                	sd	ra,8(sp)
    800007ae:	e022                	sd	s0,0(sp)
    800007b0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007b2:	100007b7          	lui	a5,0x10000
    800007b6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007ba:	f8000713          	li	a4,-128
    800007be:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007c2:	470d                	li	a4,3
    800007c4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007c8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800007cc:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800007d0:	469d                	li	a3,7
    800007d2:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800007d6:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800007da:	00008597          	auipc	a1,0x8
    800007de:	87e58593          	addi	a1,a1,-1922 # 80008058 <digits+0x18>
    800007e2:	00011517          	auipc	a0,0x11
    800007e6:	11650513          	addi	a0,a0,278 # 800118f8 <uart_tx_lock>
    800007ea:	00000097          	auipc	ra,0x0
    800007ee:	396080e7          	jalr	918(ra) # 80000b80 <initlock>
}
    800007f2:	60a2                	ld	ra,8(sp)
    800007f4:	6402                	ld	s0,0(sp)
    800007f6:	0141                	addi	sp,sp,16
    800007f8:	8082                	ret

00000000800007fa <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800007fa:	1101                	addi	sp,sp,-32
    800007fc:	ec06                	sd	ra,24(sp)
    800007fe:	e822                	sd	s0,16(sp)
    80000800:	e426                	sd	s1,8(sp)
    80000802:	1000                	addi	s0,sp,32
    80000804:	84aa                	mv	s1,a0
  push_off();
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	3be080e7          	jalr	958(ra) # 80000bc4 <push_off>

  if(panicked){
    8000080e:	00008797          	auipc	a5,0x8
    80000812:	7f27a783          	lw	a5,2034(a5) # 80009000 <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000816:	10000737          	lui	a4,0x10000
  if(panicked){
    8000081a:	c391                	beqz	a5,8000081e <uartputc_sync+0x24>
    for(;;)
    8000081c:	a001                	j	8000081c <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000081e:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000822:	0ff7f793          	andi	a5,a5,255
    80000826:	0207f793          	andi	a5,a5,32
    8000082a:	dbf5                	beqz	a5,8000081e <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000082c:	0ff4f793          	andi	a5,s1,255
    80000830:	10000737          	lui	a4,0x10000
    80000834:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80000838:	00000097          	auipc	ra,0x0
    8000083c:	42c080e7          	jalr	1068(ra) # 80000c64 <pop_off>
}
    80000840:	60e2                	ld	ra,24(sp)
    80000842:	6442                	ld	s0,16(sp)
    80000844:	64a2                	ld	s1,8(sp)
    80000846:	6105                	addi	sp,sp,32
    80000848:	8082                	ret

000000008000084a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000084a:	00008797          	auipc	a5,0x8
    8000084e:	7ba7a783          	lw	a5,1978(a5) # 80009004 <uart_tx_r>
    80000852:	00008717          	auipc	a4,0x8
    80000856:	7b672703          	lw	a4,1974(a4) # 80009008 <uart_tx_w>
    8000085a:	08f70263          	beq	a4,a5,800008de <uartstart+0x94>
{
    8000085e:	7139                	addi	sp,sp,-64
    80000860:	fc06                	sd	ra,56(sp)
    80000862:	f822                	sd	s0,48(sp)
    80000864:	f426                	sd	s1,40(sp)
    80000866:	f04a                	sd	s2,32(sp)
    80000868:	ec4e                	sd	s3,24(sp)
    8000086a:	e852                	sd	s4,16(sp)
    8000086c:	e456                	sd	s5,8(sp)
    8000086e:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000870:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r];
    80000874:	00011a17          	auipc	s4,0x11
    80000878:	084a0a13          	addi	s4,s4,132 # 800118f8 <uart_tx_lock>
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    8000087c:	00008497          	auipc	s1,0x8
    80000880:	78848493          	addi	s1,s1,1928 # 80009004 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    80000884:	00008997          	auipc	s3,0x8
    80000888:	78498993          	addi	s3,s3,1924 # 80009008 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000088c:	00594703          	lbu	a4,5(s2) # 10000005 <_entry-0x6ffffffb>
    80000890:	0ff77713          	andi	a4,a4,255
    80000894:	02077713          	andi	a4,a4,32
    80000898:	cb15                	beqz	a4,800008cc <uartstart+0x82>
    int c = uart_tx_buf[uart_tx_r];
    8000089a:	00fa0733          	add	a4,s4,a5
    8000089e:	01874a83          	lbu	s5,24(a4)
    uart_tx_r = (uart_tx_r + 1) % UART_TX_BUF_SIZE;
    800008a2:	2785                	addiw	a5,a5,1
    800008a4:	41f7d71b          	sraiw	a4,a5,0x1f
    800008a8:	01b7571b          	srliw	a4,a4,0x1b
    800008ac:	9fb9                	addw	a5,a5,a4
    800008ae:	8bfd                	andi	a5,a5,31
    800008b0:	9f99                	subw	a5,a5,a4
    800008b2:	c09c                	sw	a5,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800008b4:	8526                	mv	a0,s1
    800008b6:	00002097          	auipc	ra,0x2
    800008ba:	aba080e7          	jalr	-1350(ra) # 80002370 <wakeup>
    
    WriteReg(THR, c);
    800008be:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800008c2:	409c                	lw	a5,0(s1)
    800008c4:	0009a703          	lw	a4,0(s3)
    800008c8:	fcf712e3          	bne	a4,a5,8000088c <uartstart+0x42>
  }
}
    800008cc:	70e2                	ld	ra,56(sp)
    800008ce:	7442                	ld	s0,48(sp)
    800008d0:	74a2                	ld	s1,40(sp)
    800008d2:	7902                	ld	s2,32(sp)
    800008d4:	69e2                	ld	s3,24(sp)
    800008d6:	6a42                	ld	s4,16(sp)
    800008d8:	6aa2                	ld	s5,8(sp)
    800008da:	6121                	addi	sp,sp,64
    800008dc:	8082                	ret
    800008de:	8082                	ret

00000000800008e0 <uartputc>:
{
    800008e0:	7179                	addi	sp,sp,-48
    800008e2:	f406                	sd	ra,40(sp)
    800008e4:	f022                	sd	s0,32(sp)
    800008e6:	ec26                	sd	s1,24(sp)
    800008e8:	e84a                	sd	s2,16(sp)
    800008ea:	e44e                	sd	s3,8(sp)
    800008ec:	e052                	sd	s4,0(sp)
    800008ee:	1800                	addi	s0,sp,48
    800008f0:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800008f2:	00011517          	auipc	a0,0x11
    800008f6:	00650513          	addi	a0,a0,6 # 800118f8 <uart_tx_lock>
    800008fa:	00000097          	auipc	ra,0x0
    800008fe:	316080e7          	jalr	790(ra) # 80000c10 <acquire>
  if(panicked){
    80000902:	00008797          	auipc	a5,0x8
    80000906:	6fe7a783          	lw	a5,1790(a5) # 80009000 <panicked>
    8000090a:	c391                	beqz	a5,8000090e <uartputc+0x2e>
    for(;;)
    8000090c:	a001                	j	8000090c <uartputc+0x2c>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    8000090e:	00008717          	auipc	a4,0x8
    80000912:	6fa72703          	lw	a4,1786(a4) # 80009008 <uart_tx_w>
    80000916:	0017079b          	addiw	a5,a4,1
    8000091a:	41f7d69b          	sraiw	a3,a5,0x1f
    8000091e:	01b6d69b          	srliw	a3,a3,0x1b
    80000922:	9fb5                	addw	a5,a5,a3
    80000924:	8bfd                	andi	a5,a5,31
    80000926:	9f95                	subw	a5,a5,a3
    80000928:	00008697          	auipc	a3,0x8
    8000092c:	6dc6a683          	lw	a3,1756(a3) # 80009004 <uart_tx_r>
    80000930:	04f69263          	bne	a3,a5,80000974 <uartputc+0x94>
      sleep(&uart_tx_r, &uart_tx_lock);
    80000934:	00011a17          	auipc	s4,0x11
    80000938:	fc4a0a13          	addi	s4,s4,-60 # 800118f8 <uart_tx_lock>
    8000093c:	00008497          	auipc	s1,0x8
    80000940:	6c848493          	addi	s1,s1,1736 # 80009004 <uart_tx_r>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000944:	00008917          	auipc	s2,0x8
    80000948:	6c490913          	addi	s2,s2,1732 # 80009008 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    8000094c:	85d2                	mv	a1,s4
    8000094e:	8526                	mv	a0,s1
    80000950:	00002097          	auipc	ra,0x2
    80000954:	89a080e7          	jalr	-1894(ra) # 800021ea <sleep>
    if(((uart_tx_w + 1) % UART_TX_BUF_SIZE) == uart_tx_r){
    80000958:	00092703          	lw	a4,0(s2)
    8000095c:	0017079b          	addiw	a5,a4,1
    80000960:	41f7d69b          	sraiw	a3,a5,0x1f
    80000964:	01b6d69b          	srliw	a3,a3,0x1b
    80000968:	9fb5                	addw	a5,a5,a3
    8000096a:	8bfd                	andi	a5,a5,31
    8000096c:	9f95                	subw	a5,a5,a3
    8000096e:	4094                	lw	a3,0(s1)
    80000970:	fcf68ee3          	beq	a3,a5,8000094c <uartputc+0x6c>
      uart_tx_buf[uart_tx_w] = c;
    80000974:	00011497          	auipc	s1,0x11
    80000978:	f8448493          	addi	s1,s1,-124 # 800118f8 <uart_tx_lock>
    8000097c:	9726                	add	a4,a4,s1
    8000097e:	01370c23          	sb	s3,24(a4)
      uart_tx_w = (uart_tx_w + 1) % UART_TX_BUF_SIZE;
    80000982:	00008717          	auipc	a4,0x8
    80000986:	68f72323          	sw	a5,1670(a4) # 80009008 <uart_tx_w>
      uartstart();
    8000098a:	00000097          	auipc	ra,0x0
    8000098e:	ec0080e7          	jalr	-320(ra) # 8000084a <uartstart>
      release(&uart_tx_lock);
    80000992:	8526                	mv	a0,s1
    80000994:	00000097          	auipc	ra,0x0
    80000998:	330080e7          	jalr	816(ra) # 80000cc4 <release>
}
    8000099c:	70a2                	ld	ra,40(sp)
    8000099e:	7402                	ld	s0,32(sp)
    800009a0:	64e2                	ld	s1,24(sp)
    800009a2:	6942                	ld	s2,16(sp)
    800009a4:	69a2                	ld	s3,8(sp)
    800009a6:	6a02                	ld	s4,0(sp)
    800009a8:	6145                	addi	sp,sp,48
    800009aa:	8082                	ret

00000000800009ac <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ac:	1141                	addi	sp,sp,-16
    800009ae:	e422                	sd	s0,8(sp)
    800009b0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009b2:	100007b7          	lui	a5,0x10000
    800009b6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009ba:	8b85                	andi	a5,a5,1
    800009bc:	cb91                	beqz	a5,800009d0 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009be:	100007b7          	lui	a5,0x10000
    800009c2:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800009c6:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800009ca:	6422                	ld	s0,8(sp)
    800009cc:	0141                	addi	sp,sp,16
    800009ce:	8082                	ret
    return -1;
    800009d0:	557d                	li	a0,-1
    800009d2:	bfe5                	j	800009ca <uartgetc+0x1e>

00000000800009d4 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    800009d4:	1101                	addi	sp,sp,-32
    800009d6:	ec06                	sd	ra,24(sp)
    800009d8:	e822                	sd	s0,16(sp)
    800009da:	e426                	sd	s1,8(sp)
    800009dc:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800009de:	54fd                	li	s1,-1
    int c = uartgetc();
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	fcc080e7          	jalr	-52(ra) # 800009ac <uartgetc>
    if(c == -1)
    800009e8:	00950763          	beq	a0,s1,800009f6 <uartintr+0x22>
      break;
    consoleintr(c);
    800009ec:	00000097          	auipc	ra,0x0
    800009f0:	8dc080e7          	jalr	-1828(ra) # 800002c8 <consoleintr>
  while(1){
    800009f4:	b7f5                	j	800009e0 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800009f6:	00011497          	auipc	s1,0x11
    800009fa:	f0248493          	addi	s1,s1,-254 # 800118f8 <uart_tx_lock>
    800009fe:	8526                	mv	a0,s1
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	210080e7          	jalr	528(ra) # 80000c10 <acquire>
  uartstart();
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	e42080e7          	jalr	-446(ra) # 8000084a <uartstart>
  release(&uart_tx_lock);
    80000a10:	8526                	mv	a0,s1
    80000a12:	00000097          	auipc	ra,0x0
    80000a16:	2b2080e7          	jalr	690(ra) # 80000cc4 <release>
}
    80000a1a:	60e2                	ld	ra,24(sp)
    80000a1c:	6442                	ld	s0,16(sp)
    80000a1e:	64a2                	ld	s1,8(sp)
    80000a20:	6105                	addi	sp,sp,32
    80000a22:	8082                	ret

0000000080000a24 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a24:	1101                	addi	sp,sp,-32
    80000a26:	ec06                	sd	ra,24(sp)
    80000a28:	e822                	sd	s0,16(sp)
    80000a2a:	e426                	sd	s1,8(sp)
    80000a2c:	e04a                	sd	s2,0(sp)
    80000a2e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a30:	03451793          	slli	a5,a0,0x34
    80000a34:	ebb9                	bnez	a5,80000a8a <kfree+0x66>
    80000a36:	84aa                	mv	s1,a0
    80000a38:	00025797          	auipc	a5,0x25
    80000a3c:	5c878793          	addi	a5,a5,1480 # 80026000 <end>
    80000a40:	04f56563          	bltu	a0,a5,80000a8a <kfree+0x66>
    80000a44:	47c5                	li	a5,17
    80000a46:	07ee                	slli	a5,a5,0x1b
    80000a48:	04f57163          	bgeu	a0,a5,80000a8a <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a4c:	6605                	lui	a2,0x1
    80000a4e:	4585                	li	a1,1
    80000a50:	00000097          	auipc	ra,0x0
    80000a54:	2bc080e7          	jalr	700(ra) # 80000d0c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a58:	00011917          	auipc	s2,0x11
    80000a5c:	ed890913          	addi	s2,s2,-296 # 80011930 <kmem>
    80000a60:	854a                	mv	a0,s2
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	1ae080e7          	jalr	430(ra) # 80000c10 <acquire>
  r->next = kmem.freelist;
    80000a6a:	01893783          	ld	a5,24(s2)
    80000a6e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a70:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a74:	854a                	mv	a0,s2
    80000a76:	00000097          	auipc	ra,0x0
    80000a7a:	24e080e7          	jalr	590(ra) # 80000cc4 <release>
}
    80000a7e:	60e2                	ld	ra,24(sp)
    80000a80:	6442                	ld	s0,16(sp)
    80000a82:	64a2                	ld	s1,8(sp)
    80000a84:	6902                	ld	s2,0(sp)
    80000a86:	6105                	addi	sp,sp,32
    80000a88:	8082                	ret
    panic("kfree");
    80000a8a:	00007517          	auipc	a0,0x7
    80000a8e:	5d650513          	addi	a0,a0,1494 # 80008060 <digits+0x20>
    80000a92:	00000097          	auipc	ra,0x0
    80000a96:	ab6080e7          	jalr	-1354(ra) # 80000548 <panic>

0000000080000a9a <freerange>:
{
    80000a9a:	7179                	addi	sp,sp,-48
    80000a9c:	f406                	sd	ra,40(sp)
    80000a9e:	f022                	sd	s0,32(sp)
    80000aa0:	ec26                	sd	s1,24(sp)
    80000aa2:	e84a                	sd	s2,16(sp)
    80000aa4:	e44e                	sd	s3,8(sp)
    80000aa6:	e052                	sd	s4,0(sp)
    80000aa8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000aaa:	6785                	lui	a5,0x1
    80000aac:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    80000ab0:	94aa                	add	s1,s1,a0
    80000ab2:	757d                	lui	a0,0xfffff
    80000ab4:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ab6:	94be                	add	s1,s1,a5
    80000ab8:	0095ee63          	bltu	a1,s1,80000ad4 <freerange+0x3a>
    80000abc:	892e                	mv	s2,a1
    kfree(p);
    80000abe:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	6985                	lui	s3,0x1
    kfree(p);
    80000ac2:	01448533          	add	a0,s1,s4
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f5e080e7          	jalr	-162(ra) # 80000a24 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ace:	94ce                	add	s1,s1,s3
    80000ad0:	fe9979e3          	bgeu	s2,s1,80000ac2 <freerange+0x28>
}
    80000ad4:	70a2                	ld	ra,40(sp)
    80000ad6:	7402                	ld	s0,32(sp)
    80000ad8:	64e2                	ld	s1,24(sp)
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
    80000ae0:	6145                	addi	sp,sp,48
    80000ae2:	8082                	ret

0000000080000ae4 <kinit>:
{
    80000ae4:	1141                	addi	sp,sp,-16
    80000ae6:	e406                	sd	ra,8(sp)
    80000ae8:	e022                	sd	s0,0(sp)
    80000aea:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000aec:	00007597          	auipc	a1,0x7
    80000af0:	57c58593          	addi	a1,a1,1404 # 80008068 <digits+0x28>
    80000af4:	00011517          	auipc	a0,0x11
    80000af8:	e3c50513          	addi	a0,a0,-452 # 80011930 <kmem>
    80000afc:	00000097          	auipc	ra,0x0
    80000b00:	084080e7          	jalr	132(ra) # 80000b80 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b04:	45c5                	li	a1,17
    80000b06:	05ee                	slli	a1,a1,0x1b
    80000b08:	00025517          	auipc	a0,0x25
    80000b0c:	4f850513          	addi	a0,a0,1272 # 80026000 <end>
    80000b10:	00000097          	auipc	ra,0x0
    80000b14:	f8a080e7          	jalr	-118(ra) # 80000a9a <freerange>
}
    80000b18:	60a2                	ld	ra,8(sp)
    80000b1a:	6402                	ld	s0,0(sp)
    80000b1c:	0141                	addi	sp,sp,16
    80000b1e:	8082                	ret

0000000080000b20 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b20:	1101                	addi	sp,sp,-32
    80000b22:	ec06                	sd	ra,24(sp)
    80000b24:	e822                	sd	s0,16(sp)
    80000b26:	e426                	sd	s1,8(sp)
    80000b28:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2a:	00011497          	auipc	s1,0x11
    80000b2e:	e0648493          	addi	s1,s1,-506 # 80011930 <kmem>
    80000b32:	8526                	mv	a0,s1
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	0dc080e7          	jalr	220(ra) # 80000c10 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c885                	beqz	s1,80000b6e <kalloc+0x4e>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00011517          	auipc	a0,0x11
    80000b46:	dee50513          	addi	a0,a0,-530 # 80011930 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	00000097          	auipc	ra,0x0
    80000b50:	178080e7          	jalr	376(ra) # 80000cc4 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b54:	6605                	lui	a2,0x1
    80000b56:	4595                	li	a1,5
    80000b58:	8526                	mv	a0,s1
    80000b5a:	00000097          	auipc	ra,0x0
    80000b5e:	1b2080e7          	jalr	434(ra) # 80000d0c <memset>
  return (void*)r;
}
    80000b62:	8526                	mv	a0,s1
    80000b64:	60e2                	ld	ra,24(sp)
    80000b66:	6442                	ld	s0,16(sp)
    80000b68:	64a2                	ld	s1,8(sp)
    80000b6a:	6105                	addi	sp,sp,32
    80000b6c:	8082                	ret
  release(&kmem.lock);
    80000b6e:	00011517          	auipc	a0,0x11
    80000b72:	dc250513          	addi	a0,a0,-574 # 80011930 <kmem>
    80000b76:	00000097          	auipc	ra,0x0
    80000b7a:	14e080e7          	jalr	334(ra) # 80000cc4 <release>
  if(r)
    80000b7e:	b7d5                	j	80000b62 <kalloc+0x42>

0000000080000b80 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b80:	1141                	addi	sp,sp,-16
    80000b82:	e422                	sd	s0,8(sp)
    80000b84:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b86:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b88:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b8c:	00053823          	sd	zero,16(a0)
}
    80000b90:	6422                	ld	s0,8(sp)
    80000b92:	0141                	addi	sp,sp,16
    80000b94:	8082                	ret

0000000080000b96 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b96:	411c                	lw	a5,0(a0)
    80000b98:	e399                	bnez	a5,80000b9e <holding+0x8>
    80000b9a:	4501                	li	a0,0
  return r;
}
    80000b9c:	8082                	ret
{
    80000b9e:	1101                	addi	sp,sp,-32
    80000ba0:	ec06                	sd	ra,24(sp)
    80000ba2:	e822                	sd	s0,16(sp)
    80000ba4:	e426                	sd	s1,8(sp)
    80000ba6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba8:	6904                	ld	s1,16(a0)
    80000baa:	00001097          	auipc	ra,0x1
    80000bae:	e18080e7          	jalr	-488(ra) # 800019c2 <mycpu>
    80000bb2:	40a48533          	sub	a0,s1,a0
    80000bb6:	00153513          	seqz	a0,a0
}
    80000bba:	60e2                	ld	ra,24(sp)
    80000bbc:	6442                	ld	s0,16(sp)
    80000bbe:	64a2                	ld	s1,8(sp)
    80000bc0:	6105                	addi	sp,sp,32
    80000bc2:	8082                	ret

0000000080000bc4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bc4:	1101                	addi	sp,sp,-32
    80000bc6:	ec06                	sd	ra,24(sp)
    80000bc8:	e822                	sd	s0,16(sp)
    80000bca:	e426                	sd	s1,8(sp)
    80000bcc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bce:	100024f3          	csrr	s1,sstatus
    80000bd2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bd6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bd8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bdc:	00001097          	auipc	ra,0x1
    80000be0:	de6080e7          	jalr	-538(ra) # 800019c2 <mycpu>
    80000be4:	5d3c                	lw	a5,120(a0)
    80000be6:	cf89                	beqz	a5,80000c00 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000be8:	00001097          	auipc	ra,0x1
    80000bec:	dda080e7          	jalr	-550(ra) # 800019c2 <mycpu>
    80000bf0:	5d3c                	lw	a5,120(a0)
    80000bf2:	2785                	addiw	a5,a5,1
    80000bf4:	dd3c                	sw	a5,120(a0)
}
    80000bf6:	60e2                	ld	ra,24(sp)
    80000bf8:	6442                	ld	s0,16(sp)
    80000bfa:	64a2                	ld	s1,8(sp)
    80000bfc:	6105                	addi	sp,sp,32
    80000bfe:	8082                	ret
    mycpu()->intena = old;
    80000c00:	00001097          	auipc	ra,0x1
    80000c04:	dc2080e7          	jalr	-574(ra) # 800019c2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c08:	8085                	srli	s1,s1,0x1
    80000c0a:	8885                	andi	s1,s1,1
    80000c0c:	dd64                	sw	s1,124(a0)
    80000c0e:	bfe9                	j	80000be8 <push_off+0x24>

0000000080000c10 <acquire>:
{
    80000c10:	1101                	addi	sp,sp,-32
    80000c12:	ec06                	sd	ra,24(sp)
    80000c14:	e822                	sd	s0,16(sp)
    80000c16:	e426                	sd	s1,8(sp)
    80000c18:	1000                	addi	s0,sp,32
    80000c1a:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c1c:	00000097          	auipc	ra,0x0
    80000c20:	fa8080e7          	jalr	-88(ra) # 80000bc4 <push_off>
  if(holding(lk))
    80000c24:	8526                	mv	a0,s1
    80000c26:	00000097          	auipc	ra,0x0
    80000c2a:	f70080e7          	jalr	-144(ra) # 80000b96 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c2e:	4705                	li	a4,1
  if(holding(lk))
    80000c30:	e115                	bnez	a0,80000c54 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c32:	87ba                	mv	a5,a4
    80000c34:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c38:	2781                	sext.w	a5,a5
    80000c3a:	ffe5                	bnez	a5,80000c32 <acquire+0x22>
  __sync_synchronize();
    80000c3c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c40:	00001097          	auipc	ra,0x1
    80000c44:	d82080e7          	jalr	-638(ra) # 800019c2 <mycpu>
    80000c48:	e888                	sd	a0,16(s1)
}
    80000c4a:	60e2                	ld	ra,24(sp)
    80000c4c:	6442                	ld	s0,16(sp)
    80000c4e:	64a2                	ld	s1,8(sp)
    80000c50:	6105                	addi	sp,sp,32
    80000c52:	8082                	ret
    panic("acquire");
    80000c54:	00007517          	auipc	a0,0x7
    80000c58:	41c50513          	addi	a0,a0,1052 # 80008070 <digits+0x30>
    80000c5c:	00000097          	auipc	ra,0x0
    80000c60:	8ec080e7          	jalr	-1812(ra) # 80000548 <panic>

0000000080000c64 <pop_off>:

void
pop_off(void)
{
    80000c64:	1141                	addi	sp,sp,-16
    80000c66:	e406                	sd	ra,8(sp)
    80000c68:	e022                	sd	s0,0(sp)
    80000c6a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c6c:	00001097          	auipc	ra,0x1
    80000c70:	d56080e7          	jalr	-682(ra) # 800019c2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c74:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c78:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7a:	e78d                	bnez	a5,80000ca4 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c7c:	5d3c                	lw	a5,120(a0)
    80000c7e:	02f05b63          	blez	a5,80000cb4 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000c82:	37fd                	addiw	a5,a5,-1
    80000c84:	0007871b          	sext.w	a4,a5
    80000c88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8a:	eb09                	bnez	a4,80000c9c <pop_off+0x38>
    80000c8c:	5d7c                	lw	a5,124(a0)
    80000c8e:	c799                	beqz	a5,80000c9c <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9c:	60a2                	ld	ra,8(sp)
    80000c9e:	6402                	ld	s0,0(sp)
    80000ca0:	0141                	addi	sp,sp,16
    80000ca2:	8082                	ret
    panic("pop_off - interruptible");
    80000ca4:	00007517          	auipc	a0,0x7
    80000ca8:	3d450513          	addi	a0,a0,980 # 80008078 <digits+0x38>
    80000cac:	00000097          	auipc	ra,0x0
    80000cb0:	89c080e7          	jalr	-1892(ra) # 80000548 <panic>
    panic("pop_off");
    80000cb4:	00007517          	auipc	a0,0x7
    80000cb8:	3dc50513          	addi	a0,a0,988 # 80008090 <digits+0x50>
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	88c080e7          	jalr	-1908(ra) # 80000548 <panic>

0000000080000cc4 <release>:
{
    80000cc4:	1101                	addi	sp,sp,-32
    80000cc6:	ec06                	sd	ra,24(sp)
    80000cc8:	e822                	sd	s0,16(sp)
    80000cca:	e426                	sd	s1,8(sp)
    80000ccc:	1000                	addi	s0,sp,32
    80000cce:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cd0:	00000097          	auipc	ra,0x0
    80000cd4:	ec6080e7          	jalr	-314(ra) # 80000b96 <holding>
    80000cd8:	c115                	beqz	a0,80000cfc <release+0x38>
  lk->cpu = 0;
    80000cda:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cde:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000ce2:	0f50000f          	fence	iorw,ow
    80000ce6:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000cea:	00000097          	auipc	ra,0x0
    80000cee:	f7a080e7          	jalr	-134(ra) # 80000c64 <pop_off>
}
    80000cf2:	60e2                	ld	ra,24(sp)
    80000cf4:	6442                	ld	s0,16(sp)
    80000cf6:	64a2                	ld	s1,8(sp)
    80000cf8:	6105                	addi	sp,sp,32
    80000cfa:	8082                	ret
    panic("release");
    80000cfc:	00007517          	auipc	a0,0x7
    80000d00:	39c50513          	addi	a0,a0,924 # 80008098 <digits+0x58>
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	844080e7          	jalr	-1980(ra) # 80000548 <panic>

0000000080000d0c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d0c:	1141                	addi	sp,sp,-16
    80000d0e:	e422                	sd	s0,8(sp)
    80000d10:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d12:	ce09                	beqz	a2,80000d2c <memset+0x20>
    80000d14:	87aa                	mv	a5,a0
    80000d16:	fff6071b          	addiw	a4,a2,-1
    80000d1a:	1702                	slli	a4,a4,0x20
    80000d1c:	9301                	srli	a4,a4,0x20
    80000d1e:	0705                	addi	a4,a4,1
    80000d20:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d22:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d26:	0785                	addi	a5,a5,1
    80000d28:	fee79de3          	bne	a5,a4,80000d22 <memset+0x16>
  }
  return dst;
}
    80000d2c:	6422                	ld	s0,8(sp)
    80000d2e:	0141                	addi	sp,sp,16
    80000d30:	8082                	ret

0000000080000d32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d32:	1141                	addi	sp,sp,-16
    80000d34:	e422                	sd	s0,8(sp)
    80000d36:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d38:	ca05                	beqz	a2,80000d68 <memcmp+0x36>
    80000d3a:	fff6069b          	addiw	a3,a2,-1
    80000d3e:	1682                	slli	a3,a3,0x20
    80000d40:	9281                	srli	a3,a3,0x20
    80000d42:	0685                	addi	a3,a3,1
    80000d44:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d46:	00054783          	lbu	a5,0(a0)
    80000d4a:	0005c703          	lbu	a4,0(a1)
    80000d4e:	00e79863          	bne	a5,a4,80000d5e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d52:	0505                	addi	a0,a0,1
    80000d54:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d56:	fed518e3          	bne	a0,a3,80000d46 <memcmp+0x14>
  }

  return 0;
    80000d5a:	4501                	li	a0,0
    80000d5c:	a019                	j	80000d62 <memcmp+0x30>
      return *s1 - *s2;
    80000d5e:	40e7853b          	subw	a0,a5,a4
}
    80000d62:	6422                	ld	s0,8(sp)
    80000d64:	0141                	addi	sp,sp,16
    80000d66:	8082                	ret
  return 0;
    80000d68:	4501                	li	a0,0
    80000d6a:	bfe5                	j	80000d62 <memcmp+0x30>

0000000080000d6c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d6c:	1141                	addi	sp,sp,-16
    80000d6e:	e422                	sd	s0,8(sp)
    80000d70:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d72:	02a5e563          	bltu	a1,a0,80000d9c <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d76:	fff6069b          	addiw	a3,a2,-1
    80000d7a:	ce11                	beqz	a2,80000d96 <memmove+0x2a>
    80000d7c:	1682                	slli	a3,a3,0x20
    80000d7e:	9281                	srli	a3,a3,0x20
    80000d80:	0685                	addi	a3,a3,1
    80000d82:	96ae                	add	a3,a3,a1
    80000d84:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000d86:	0585                	addi	a1,a1,1
    80000d88:	0785                	addi	a5,a5,1
    80000d8a:	fff5c703          	lbu	a4,-1(a1)
    80000d8e:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000d92:	fed59ae3          	bne	a1,a3,80000d86 <memmove+0x1a>

  return dst;
}
    80000d96:	6422                	ld	s0,8(sp)
    80000d98:	0141                	addi	sp,sp,16
    80000d9a:	8082                	ret
  if(s < d && s + n > d){
    80000d9c:	02061713          	slli	a4,a2,0x20
    80000da0:	9301                	srli	a4,a4,0x20
    80000da2:	00e587b3          	add	a5,a1,a4
    80000da6:	fcf578e3          	bgeu	a0,a5,80000d76 <memmove+0xa>
    d += n;
    80000daa:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000dac:	fff6069b          	addiw	a3,a2,-1
    80000db0:	d27d                	beqz	a2,80000d96 <memmove+0x2a>
    80000db2:	02069613          	slli	a2,a3,0x20
    80000db6:	9201                	srli	a2,a2,0x20
    80000db8:	fff64613          	not	a2,a2
    80000dbc:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000dbe:	17fd                	addi	a5,a5,-1
    80000dc0:	177d                	addi	a4,a4,-1
    80000dc2:	0007c683          	lbu	a3,0(a5)
    80000dc6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000dca:	fec79ae3          	bne	a5,a2,80000dbe <memmove+0x52>
    80000dce:	b7e1                	j	80000d96 <memmove+0x2a>

0000000080000dd0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000dd0:	1141                	addi	sp,sp,-16
    80000dd2:	e406                	sd	ra,8(sp)
    80000dd4:	e022                	sd	s0,0(sp)
    80000dd6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dd8:	00000097          	auipc	ra,0x0
    80000ddc:	f94080e7          	jalr	-108(ra) # 80000d6c <memmove>
}
    80000de0:	60a2                	ld	ra,8(sp)
    80000de2:	6402                	ld	s0,0(sp)
    80000de4:	0141                	addi	sp,sp,16
    80000de6:	8082                	ret

0000000080000de8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000de8:	1141                	addi	sp,sp,-16
    80000dea:	e422                	sd	s0,8(sp)
    80000dec:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dee:	ce11                	beqz	a2,80000e0a <strncmp+0x22>
    80000df0:	00054783          	lbu	a5,0(a0)
    80000df4:	cf89                	beqz	a5,80000e0e <strncmp+0x26>
    80000df6:	0005c703          	lbu	a4,0(a1)
    80000dfa:	00f71a63          	bne	a4,a5,80000e0e <strncmp+0x26>
    n--, p++, q++;
    80000dfe:	367d                	addiw	a2,a2,-1
    80000e00:	0505                	addi	a0,a0,1
    80000e02:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e04:	f675                	bnez	a2,80000df0 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e06:	4501                	li	a0,0
    80000e08:	a809                	j	80000e1a <strncmp+0x32>
    80000e0a:	4501                	li	a0,0
    80000e0c:	a039                	j	80000e1a <strncmp+0x32>
  if(n == 0)
    80000e0e:	ca09                	beqz	a2,80000e20 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e10:	00054503          	lbu	a0,0(a0)
    80000e14:	0005c783          	lbu	a5,0(a1)
    80000e18:	9d1d                	subw	a0,a0,a5
}
    80000e1a:	6422                	ld	s0,8(sp)
    80000e1c:	0141                	addi	sp,sp,16
    80000e1e:	8082                	ret
    return 0;
    80000e20:	4501                	li	a0,0
    80000e22:	bfe5                	j	80000e1a <strncmp+0x32>

0000000080000e24 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e24:	1141                	addi	sp,sp,-16
    80000e26:	e422                	sd	s0,8(sp)
    80000e28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e2a:	872a                	mv	a4,a0
    80000e2c:	8832                	mv	a6,a2
    80000e2e:	367d                	addiw	a2,a2,-1
    80000e30:	01005963          	blez	a6,80000e42 <strncpy+0x1e>
    80000e34:	0705                	addi	a4,a4,1
    80000e36:	0005c783          	lbu	a5,0(a1)
    80000e3a:	fef70fa3          	sb	a5,-1(a4)
    80000e3e:	0585                	addi	a1,a1,1
    80000e40:	f7f5                	bnez	a5,80000e2c <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e42:	86ba                	mv	a3,a4
    80000e44:	00c05c63          	blez	a2,80000e5c <strncpy+0x38>
    *s++ = 0;
    80000e48:	0685                	addi	a3,a3,1
    80000e4a:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000e4e:	fff6c793          	not	a5,a3
    80000e52:	9fb9                	addw	a5,a5,a4
    80000e54:	010787bb          	addw	a5,a5,a6
    80000e58:	fef048e3          	bgtz	a5,80000e48 <strncpy+0x24>
  return os;
}
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e422                	sd	s0,8(sp)
    80000e66:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e68:	02c05363          	blez	a2,80000e8e <safestrcpy+0x2c>
    80000e6c:	fff6069b          	addiw	a3,a2,-1
    80000e70:	1682                	slli	a3,a3,0x20
    80000e72:	9281                	srli	a3,a3,0x20
    80000e74:	96ae                	add	a3,a3,a1
    80000e76:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e78:	00d58963          	beq	a1,a3,80000e8a <safestrcpy+0x28>
    80000e7c:	0585                	addi	a1,a1,1
    80000e7e:	0785                	addi	a5,a5,1
    80000e80:	fff5c703          	lbu	a4,-1(a1)
    80000e84:	fee78fa3          	sb	a4,-1(a5)
    80000e88:	fb65                	bnez	a4,80000e78 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e8a:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e8e:	6422                	ld	s0,8(sp)
    80000e90:	0141                	addi	sp,sp,16
    80000e92:	8082                	ret

0000000080000e94 <strlen>:

int
strlen(const char *s)
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e422                	sd	s0,8(sp)
    80000e98:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e9a:	00054783          	lbu	a5,0(a0)
    80000e9e:	cf91                	beqz	a5,80000eba <strlen+0x26>
    80000ea0:	0505                	addi	a0,a0,1
    80000ea2:	87aa                	mv	a5,a0
    80000ea4:	4685                	li	a3,1
    80000ea6:	9e89                	subw	a3,a3,a0
    80000ea8:	00f6853b          	addw	a0,a3,a5
    80000eac:	0785                	addi	a5,a5,1
    80000eae:	fff7c703          	lbu	a4,-1(a5)
    80000eb2:	fb7d                	bnez	a4,80000ea8 <strlen+0x14>
    ;
  return n;
}
    80000eb4:	6422                	ld	s0,8(sp)
    80000eb6:	0141                	addi	sp,sp,16
    80000eb8:	8082                	ret
  for(n = 0; s[n]; n++)
    80000eba:	4501                	li	a0,0
    80000ebc:	bfe5                	j	80000eb4 <strlen+0x20>

0000000080000ebe <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ebe:	1141                	addi	sp,sp,-16
    80000ec0:	e406                	sd	ra,8(sp)
    80000ec2:	e022                	sd	s0,0(sp)
    80000ec4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ec6:	00001097          	auipc	ra,0x1
    80000eca:	aec080e7          	jalr	-1300(ra) # 800019b2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ece:	00008717          	auipc	a4,0x8
    80000ed2:	13e70713          	addi	a4,a4,318 # 8000900c <started>
  if(cpuid() == 0){
    80000ed6:	c139                	beqz	a0,80000f1c <main+0x5e>
    while(started == 0)
    80000ed8:	431c                	lw	a5,0(a4)
    80000eda:	2781                	sext.w	a5,a5
    80000edc:	dff5                	beqz	a5,80000ed8 <main+0x1a>
      ;
    __sync_synchronize();
    80000ede:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ee2:	00001097          	auipc	ra,0x1
    80000ee6:	ad0080e7          	jalr	-1328(ra) # 800019b2 <cpuid>
    80000eea:	85aa                	mv	a1,a0
    80000eec:	00007517          	auipc	a0,0x7
    80000ef0:	1cc50513          	addi	a0,a0,460 # 800080b8 <digits+0x78>
    80000ef4:	fffff097          	auipc	ra,0xfffff
    80000ef8:	69e080e7          	jalr	1694(ra) # 80000592 <printf>
    kvminithart();    // turn on paging
    80000efc:	00000097          	auipc	ra,0x0
    80000f00:	0d8080e7          	jalr	216(ra) # 80000fd4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f04:	00001097          	auipc	ra,0x1
    80000f08:	732080e7          	jalr	1842(ra) # 80002636 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f0c:	00005097          	auipc	ra,0x5
    80000f10:	cc4080e7          	jalr	-828(ra) # 80005bd0 <plicinithart>
  }

  scheduler();        
    80000f14:	00001097          	auipc	ra,0x1
    80000f18:	ffa080e7          	jalr	-6(ra) # 80001f0e <scheduler>
    consoleinit();
    80000f1c:	fffff097          	auipc	ra,0xfffff
    80000f20:	53e080e7          	jalr	1342(ra) # 8000045a <consoleinit>
    printfinit();
    80000f24:	00000097          	auipc	ra,0x0
    80000f28:	854080e7          	jalr	-1964(ra) # 80000778 <printfinit>
    printf("\n");
    80000f2c:	00007517          	auipc	a0,0x7
    80000f30:	19c50513          	addi	a0,a0,412 # 800080c8 <digits+0x88>
    80000f34:	fffff097          	auipc	ra,0xfffff
    80000f38:	65e080e7          	jalr	1630(ra) # 80000592 <printf>
    printf("xv6 kernel is booting\n");
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	16450513          	addi	a0,a0,356 # 800080a0 <digits+0x60>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	64e080e7          	jalr	1614(ra) # 80000592 <printf>
    printf("\n");
    80000f4c:	00007517          	auipc	a0,0x7
    80000f50:	17c50513          	addi	a0,a0,380 # 800080c8 <digits+0x88>
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	63e080e7          	jalr	1598(ra) # 80000592 <printf>
    kinit();         // physical page allocator
    80000f5c:	00000097          	auipc	ra,0x0
    80000f60:	b88080e7          	jalr	-1144(ra) # 80000ae4 <kinit>
    kvminit();       // create kernel page table
    80000f64:	00000097          	auipc	ra,0x0
    80000f68:	2a0080e7          	jalr	672(ra) # 80001204 <kvminit>
    kvminithart();   // turn on paging
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	068080e7          	jalr	104(ra) # 80000fd4 <kvminithart>
    procinit();      // process table
    80000f74:	00001097          	auipc	ra,0x1
    80000f78:	96e080e7          	jalr	-1682(ra) # 800018e2 <procinit>
    trapinit();      // trap vectors
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	692080e7          	jalr	1682(ra) # 8000260e <trapinit>
    trapinithart();  // install kernel trap vector
    80000f84:	00001097          	auipc	ra,0x1
    80000f88:	6b2080e7          	jalr	1714(ra) # 80002636 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f8c:	00005097          	auipc	ra,0x5
    80000f90:	c2e080e7          	jalr	-978(ra) # 80005bba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f94:	00005097          	auipc	ra,0x5
    80000f98:	c3c080e7          	jalr	-964(ra) # 80005bd0 <plicinithart>
    binit();         // buffer cache
    80000f9c:	00002097          	auipc	ra,0x2
    80000fa0:	ddc080e7          	jalr	-548(ra) # 80002d78 <binit>
    iinit();         // inode cache
    80000fa4:	00002097          	auipc	ra,0x2
    80000fa8:	46c080e7          	jalr	1132(ra) # 80003410 <iinit>
    fileinit();      // file table
    80000fac:	00003097          	auipc	ra,0x3
    80000fb0:	406080e7          	jalr	1030(ra) # 800043b2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000fb4:	00005097          	auipc	ra,0x5
    80000fb8:	d24080e7          	jalr	-732(ra) # 80005cd8 <virtio_disk_init>
    userinit();      // first user process
    80000fbc:	00001097          	auipc	ra,0x1
    80000fc0:	cec080e7          	jalr	-788(ra) # 80001ca8 <userinit>
    __sync_synchronize();
    80000fc4:	0ff0000f          	fence
    started = 1;
    80000fc8:	4785                	li	a5,1
    80000fca:	00008717          	auipc	a4,0x8
    80000fce:	04f72123          	sw	a5,66(a4) # 8000900c <started>
    80000fd2:	b789                	j	80000f14 <main+0x56>

0000000080000fd4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000fd4:	1141                	addi	sp,sp,-16
    80000fd6:	e422                	sd	s0,8(sp)
    80000fd8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    80000fda:	00008797          	auipc	a5,0x8
    80000fde:	0367b783          	ld	a5,54(a5) # 80009010 <kernel_pagetable>
    80000fe2:	83b1                	srli	a5,a5,0xc
    80000fe4:	577d                	li	a4,-1
    80000fe6:	177e                	slli	a4,a4,0x3f
    80000fe8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000fea:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000fee:	12000073          	sfence.vma
  sfence_vma();
}
    80000ff2:	6422                	ld	s0,8(sp)
    80000ff4:	0141                	addi	sp,sp,16
    80000ff6:	8082                	ret

0000000080000ff8 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000ff8:	7139                	addi	sp,sp,-64
    80000ffa:	fc06                	sd	ra,56(sp)
    80000ffc:	f822                	sd	s0,48(sp)
    80000ffe:	f426                	sd	s1,40(sp)
    80001000:	f04a                	sd	s2,32(sp)
    80001002:	ec4e                	sd	s3,24(sp)
    80001004:	e852                	sd	s4,16(sp)
    80001006:	e456                	sd	s5,8(sp)
    80001008:	e05a                	sd	s6,0(sp)
    8000100a:	0080                	addi	s0,sp,64
    8000100c:	84aa                	mv	s1,a0
    8000100e:	89ae                	mv	s3,a1
    80001010:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001012:	57fd                	li	a5,-1
    80001014:	83e9                	srli	a5,a5,0x1a
    80001016:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001018:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000101a:	04b7f263          	bgeu	a5,a1,8000105e <walk+0x66>
    panic("walk");
    8000101e:	00007517          	auipc	a0,0x7
    80001022:	0b250513          	addi	a0,a0,178 # 800080d0 <digits+0x90>
    80001026:	fffff097          	auipc	ra,0xfffff
    8000102a:	522080e7          	jalr	1314(ra) # 80000548 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000102e:	060a8663          	beqz	s5,8000109a <walk+0xa2>
    80001032:	00000097          	auipc	ra,0x0
    80001036:	aee080e7          	jalr	-1298(ra) # 80000b20 <kalloc>
    8000103a:	84aa                	mv	s1,a0
    8000103c:	c529                	beqz	a0,80001086 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000103e:	6605                	lui	a2,0x1
    80001040:	4581                	li	a1,0
    80001042:	00000097          	auipc	ra,0x0
    80001046:	cca080e7          	jalr	-822(ra) # 80000d0c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000104a:	00c4d793          	srli	a5,s1,0xc
    8000104e:	07aa                	slli	a5,a5,0xa
    80001050:	0017e793          	ori	a5,a5,1
    80001054:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80001058:	3a5d                	addiw	s4,s4,-9
    8000105a:	036a0063          	beq	s4,s6,8000107a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000105e:	0149d933          	srl	s2,s3,s4
    80001062:	1ff97913          	andi	s2,s2,511
    80001066:	090e                	slli	s2,s2,0x3
    80001068:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000106a:	00093483          	ld	s1,0(s2)
    8000106e:	0014f793          	andi	a5,s1,1
    80001072:	dfd5                	beqz	a5,8000102e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001074:	80a9                	srli	s1,s1,0xa
    80001076:	04b2                	slli	s1,s1,0xc
    80001078:	b7c5                	j	80001058 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000107a:	00c9d513          	srli	a0,s3,0xc
    8000107e:	1ff57513          	andi	a0,a0,511
    80001082:	050e                	slli	a0,a0,0x3
    80001084:	9526                	add	a0,a0,s1
}
    80001086:	70e2                	ld	ra,56(sp)
    80001088:	7442                	ld	s0,48(sp)
    8000108a:	74a2                	ld	s1,40(sp)
    8000108c:	7902                	ld	s2,32(sp)
    8000108e:	69e2                	ld	s3,24(sp)
    80001090:	6a42                	ld	s4,16(sp)
    80001092:	6aa2                	ld	s5,8(sp)
    80001094:	6b02                	ld	s6,0(sp)
    80001096:	6121                	addi	sp,sp,64
    80001098:	8082                	ret
        return 0;
    8000109a:	4501                	li	a0,0
    8000109c:	b7ed                	j	80001086 <walk+0x8e>

000000008000109e <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000109e:	57fd                	li	a5,-1
    800010a0:	83e9                	srli	a5,a5,0x1a
    800010a2:	00b7f463          	bgeu	a5,a1,800010aa <walkaddr+0xc>
    return 0;
    800010a6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800010a8:	8082                	ret
{
    800010aa:	1141                	addi	sp,sp,-16
    800010ac:	e406                	sd	ra,8(sp)
    800010ae:	e022                	sd	s0,0(sp)
    800010b0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800010b2:	4601                	li	a2,0
    800010b4:	00000097          	auipc	ra,0x0
    800010b8:	f44080e7          	jalr	-188(ra) # 80000ff8 <walk>
  if(pte == 0)
    800010bc:	c105                	beqz	a0,800010dc <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800010be:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800010c0:	0117f693          	andi	a3,a5,17
    800010c4:	4745                	li	a4,17
    return 0;
    800010c6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800010c8:	00e68663          	beq	a3,a4,800010d4 <walkaddr+0x36>
}
    800010cc:	60a2                	ld	ra,8(sp)
    800010ce:	6402                	ld	s0,0(sp)
    800010d0:	0141                	addi	sp,sp,16
    800010d2:	8082                	ret
  pa = PTE2PA(*pte);
    800010d4:	00a7d513          	srli	a0,a5,0xa
    800010d8:	0532                	slli	a0,a0,0xc
  return pa;
    800010da:	bfcd                	j	800010cc <walkaddr+0x2e>
    return 0;
    800010dc:	4501                	li	a0,0
    800010de:	b7fd                	j	800010cc <walkaddr+0x2e>

00000000800010e0 <kvmpa>:
// a physical address. only needed for
// addresses on the stack.
// assumes va is page aligned.
uint64
kvmpa(uint64 va)
{
    800010e0:	1101                	addi	sp,sp,-32
    800010e2:	ec06                	sd	ra,24(sp)
    800010e4:	e822                	sd	s0,16(sp)
    800010e6:	e426                	sd	s1,8(sp)
    800010e8:	1000                	addi	s0,sp,32
    800010ea:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800010ec:	1552                	slli	a0,a0,0x34
    800010ee:	03455493          	srli	s1,a0,0x34
  pte_t *pte;
  uint64 pa;
  
  pte = walk(kernel_pagetable, va, 0);
    800010f2:	4601                	li	a2,0
    800010f4:	00008517          	auipc	a0,0x8
    800010f8:	f1c53503          	ld	a0,-228(a0) # 80009010 <kernel_pagetable>
    800010fc:	00000097          	auipc	ra,0x0
    80001100:	efc080e7          	jalr	-260(ra) # 80000ff8 <walk>
  if(pte == 0)
    80001104:	cd09                	beqz	a0,8000111e <kvmpa+0x3e>
    panic("kvmpa");
  if((*pte & PTE_V) == 0)
    80001106:	6108                	ld	a0,0(a0)
    80001108:	00157793          	andi	a5,a0,1
    8000110c:	c38d                	beqz	a5,8000112e <kvmpa+0x4e>
    panic("kvmpa");
  pa = PTE2PA(*pte);
    8000110e:	8129                	srli	a0,a0,0xa
    80001110:	0532                	slli	a0,a0,0xc
  return pa+off;
}
    80001112:	9526                	add	a0,a0,s1
    80001114:	60e2                	ld	ra,24(sp)
    80001116:	6442                	ld	s0,16(sp)
    80001118:	64a2                	ld	s1,8(sp)
    8000111a:	6105                	addi	sp,sp,32
    8000111c:	8082                	ret
    panic("kvmpa");
    8000111e:	00007517          	auipc	a0,0x7
    80001122:	fba50513          	addi	a0,a0,-70 # 800080d8 <digits+0x98>
    80001126:	fffff097          	auipc	ra,0xfffff
    8000112a:	422080e7          	jalr	1058(ra) # 80000548 <panic>
    panic("kvmpa");
    8000112e:	00007517          	auipc	a0,0x7
    80001132:	faa50513          	addi	a0,a0,-86 # 800080d8 <digits+0x98>
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	412080e7          	jalr	1042(ra) # 80000548 <panic>

000000008000113e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000113e:	715d                	addi	sp,sp,-80
    80001140:	e486                	sd	ra,72(sp)
    80001142:	e0a2                	sd	s0,64(sp)
    80001144:	fc26                	sd	s1,56(sp)
    80001146:	f84a                	sd	s2,48(sp)
    80001148:	f44e                	sd	s3,40(sp)
    8000114a:	f052                	sd	s4,32(sp)
    8000114c:	ec56                	sd	s5,24(sp)
    8000114e:	e85a                	sd	s6,16(sp)
    80001150:	e45e                	sd	s7,8(sp)
    80001152:	0880                	addi	s0,sp,80
    80001154:	8aaa                	mv	s5,a0
    80001156:	8b3a                	mv	s6,a4
  uint64 a, last;
  pte_t *pte;

  a = PGROUNDDOWN(va);
    80001158:	777d                	lui	a4,0xfffff
    8000115a:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000115e:	167d                	addi	a2,a2,-1
    80001160:	00b609b3          	add	s3,a2,a1
    80001164:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001168:	893e                	mv	s2,a5
    8000116a:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000116e:	6b85                	lui	s7,0x1
    80001170:	012a04b3          	add	s1,s4,s2
    if((pte = walk(pagetable, a, 1)) == 0)
    80001174:	4605                	li	a2,1
    80001176:	85ca                	mv	a1,s2
    80001178:	8556                	mv	a0,s5
    8000117a:	00000097          	auipc	ra,0x0
    8000117e:	e7e080e7          	jalr	-386(ra) # 80000ff8 <walk>
    80001182:	c51d                	beqz	a0,800011b0 <mappages+0x72>
    if(*pte & PTE_V)
    80001184:	611c                	ld	a5,0(a0)
    80001186:	8b85                	andi	a5,a5,1
    80001188:	ef81                	bnez	a5,800011a0 <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000118a:	80b1                	srli	s1,s1,0xc
    8000118c:	04aa                	slli	s1,s1,0xa
    8000118e:	0164e4b3          	or	s1,s1,s6
    80001192:	0014e493          	ori	s1,s1,1
    80001196:	e104                	sd	s1,0(a0)
    if(a == last)
    80001198:	03390863          	beq	s2,s3,800011c8 <mappages+0x8a>
    a += PGSIZE;
    8000119c:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000119e:	bfc9                	j	80001170 <mappages+0x32>
      panic("remap");
    800011a0:	00007517          	auipc	a0,0x7
    800011a4:	f4050513          	addi	a0,a0,-192 # 800080e0 <digits+0xa0>
    800011a8:	fffff097          	auipc	ra,0xfffff
    800011ac:	3a0080e7          	jalr	928(ra) # 80000548 <panic>
      return -1;
    800011b0:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011b2:	60a6                	ld	ra,72(sp)
    800011b4:	6406                	ld	s0,64(sp)
    800011b6:	74e2                	ld	s1,56(sp)
    800011b8:	7942                	ld	s2,48(sp)
    800011ba:	79a2                	ld	s3,40(sp)
    800011bc:	7a02                	ld	s4,32(sp)
    800011be:	6ae2                	ld	s5,24(sp)
    800011c0:	6b42                	ld	s6,16(sp)
    800011c2:	6ba2                	ld	s7,8(sp)
    800011c4:	6161                	addi	sp,sp,80
    800011c6:	8082                	ret
  return 0;
    800011c8:	4501                	li	a0,0
    800011ca:	b7e5                	j	800011b2 <mappages+0x74>

00000000800011cc <kvmmap>:
{
    800011cc:	1141                	addi	sp,sp,-16
    800011ce:	e406                	sd	ra,8(sp)
    800011d0:	e022                	sd	s0,0(sp)
    800011d2:	0800                	addi	s0,sp,16
    800011d4:	8736                	mv	a4,a3
  if(mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800011d6:	86ae                	mv	a3,a1
    800011d8:	85aa                	mv	a1,a0
    800011da:	00008517          	auipc	a0,0x8
    800011de:	e3653503          	ld	a0,-458(a0) # 80009010 <kernel_pagetable>
    800011e2:	00000097          	auipc	ra,0x0
    800011e6:	f5c080e7          	jalr	-164(ra) # 8000113e <mappages>
    800011ea:	e509                	bnez	a0,800011f4 <kvmmap+0x28>
}
    800011ec:	60a2                	ld	ra,8(sp)
    800011ee:	6402                	ld	s0,0(sp)
    800011f0:	0141                	addi	sp,sp,16
    800011f2:	8082                	ret
    panic("kvmmap");
    800011f4:	00007517          	auipc	a0,0x7
    800011f8:	ef450513          	addi	a0,a0,-268 # 800080e8 <digits+0xa8>
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	34c080e7          	jalr	844(ra) # 80000548 <panic>

0000000080001204 <kvminit>:
{
    80001204:	1101                	addi	sp,sp,-32
    80001206:	ec06                	sd	ra,24(sp)
    80001208:	e822                	sd	s0,16(sp)
    8000120a:	e426                	sd	s1,8(sp)
    8000120c:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t) kalloc();
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	912080e7          	jalr	-1774(ra) # 80000b20 <kalloc>
    80001216:	00008797          	auipc	a5,0x8
    8000121a:	dea7bd23          	sd	a0,-518(a5) # 80009010 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    8000121e:	6605                	lui	a2,0x1
    80001220:	4581                	li	a1,0
    80001222:	00000097          	auipc	ra,0x0
    80001226:	aea080e7          	jalr	-1302(ra) # 80000d0c <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000122a:	4699                	li	a3,6
    8000122c:	6605                	lui	a2,0x1
    8000122e:	100005b7          	lui	a1,0x10000
    80001232:	10000537          	lui	a0,0x10000
    80001236:	00000097          	auipc	ra,0x0
    8000123a:	f96080e7          	jalr	-106(ra) # 800011cc <kvmmap>
  kvmmap(VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000123e:	4699                	li	a3,6
    80001240:	6605                	lui	a2,0x1
    80001242:	100015b7          	lui	a1,0x10001
    80001246:	10001537          	lui	a0,0x10001
    8000124a:	00000097          	auipc	ra,0x0
    8000124e:	f82080e7          	jalr	-126(ra) # 800011cc <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001252:	4699                	li	a3,6
    80001254:	6641                	lui	a2,0x10
    80001256:	020005b7          	lui	a1,0x2000
    8000125a:	02000537          	lui	a0,0x2000
    8000125e:	00000097          	auipc	ra,0x0
    80001262:	f6e080e7          	jalr	-146(ra) # 800011cc <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001266:	4699                	li	a3,6
    80001268:	00400637          	lui	a2,0x400
    8000126c:	0c0005b7          	lui	a1,0xc000
    80001270:	0c000537          	lui	a0,0xc000
    80001274:	00000097          	auipc	ra,0x0
    80001278:	f58080e7          	jalr	-168(ra) # 800011cc <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000127c:	00007497          	auipc	s1,0x7
    80001280:	d8448493          	addi	s1,s1,-636 # 80008000 <etext>
    80001284:	46a9                	li	a3,10
    80001286:	80007617          	auipc	a2,0x80007
    8000128a:	d7a60613          	addi	a2,a2,-646 # 8000 <_entry-0x7fff8000>
    8000128e:	4585                	li	a1,1
    80001290:	05fe                	slli	a1,a1,0x1f
    80001292:	852e                	mv	a0,a1
    80001294:	00000097          	auipc	ra,0x0
    80001298:	f38080e7          	jalr	-200(ra) # 800011cc <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000129c:	4699                	li	a3,6
    8000129e:	4645                	li	a2,17
    800012a0:	066e                	slli	a2,a2,0x1b
    800012a2:	8e05                	sub	a2,a2,s1
    800012a4:	85a6                	mv	a1,s1
    800012a6:	8526                	mv	a0,s1
    800012a8:	00000097          	auipc	ra,0x0
    800012ac:	f24080e7          	jalr	-220(ra) # 800011cc <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012b0:	46a9                	li	a3,10
    800012b2:	6605                	lui	a2,0x1
    800012b4:	00006597          	auipc	a1,0x6
    800012b8:	d4c58593          	addi	a1,a1,-692 # 80007000 <_trampoline>
    800012bc:	04000537          	lui	a0,0x4000
    800012c0:	157d                	addi	a0,a0,-1
    800012c2:	0532                	slli	a0,a0,0xc
    800012c4:	00000097          	auipc	ra,0x0
    800012c8:	f08080e7          	jalr	-248(ra) # 800011cc <kvmmap>
}
    800012cc:	60e2                	ld	ra,24(sp)
    800012ce:	6442                	ld	s0,16(sp)
    800012d0:	64a2                	ld	s1,8(sp)
    800012d2:	6105                	addi	sp,sp,32
    800012d4:	8082                	ret

00000000800012d6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012d6:	715d                	addi	sp,sp,-80
    800012d8:	e486                	sd	ra,72(sp)
    800012da:	e0a2                	sd	s0,64(sp)
    800012dc:	fc26                	sd	s1,56(sp)
    800012de:	f84a                	sd	s2,48(sp)
    800012e0:	f44e                	sd	s3,40(sp)
    800012e2:	f052                	sd	s4,32(sp)
    800012e4:	ec56                	sd	s5,24(sp)
    800012e6:	e85a                	sd	s6,16(sp)
    800012e8:	e45e                	sd	s7,8(sp)
    800012ea:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800012ec:	03459793          	slli	a5,a1,0x34
    800012f0:	e795                	bnez	a5,8000131c <uvmunmap+0x46>
    800012f2:	8a2a                	mv	s4,a0
    800012f4:	892e                	mv	s2,a1
    800012f6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800012f8:	0632                	slli	a2,a2,0xc
    800012fa:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800012fe:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001300:	6b05                	lui	s6,0x1
    80001302:	0735e863          	bltu	a1,s3,80001372 <uvmunmap+0x9c>
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
  }
}
    80001306:	60a6                	ld	ra,72(sp)
    80001308:	6406                	ld	s0,64(sp)
    8000130a:	74e2                	ld	s1,56(sp)
    8000130c:	7942                	ld	s2,48(sp)
    8000130e:	79a2                	ld	s3,40(sp)
    80001310:	7a02                	ld	s4,32(sp)
    80001312:	6ae2                	ld	s5,24(sp)
    80001314:	6b42                	ld	s6,16(sp)
    80001316:	6ba2                	ld	s7,8(sp)
    80001318:	6161                	addi	sp,sp,80
    8000131a:	8082                	ret
    panic("uvmunmap: not aligned");
    8000131c:	00007517          	auipc	a0,0x7
    80001320:	dd450513          	addi	a0,a0,-556 # 800080f0 <digits+0xb0>
    80001324:	fffff097          	auipc	ra,0xfffff
    80001328:	224080e7          	jalr	548(ra) # 80000548 <panic>
      panic("uvmunmap: walk");
    8000132c:	00007517          	auipc	a0,0x7
    80001330:	ddc50513          	addi	a0,a0,-548 # 80008108 <digits+0xc8>
    80001334:	fffff097          	auipc	ra,0xfffff
    80001338:	214080e7          	jalr	532(ra) # 80000548 <panic>
      panic("uvmunmap: not mapped");
    8000133c:	00007517          	auipc	a0,0x7
    80001340:	ddc50513          	addi	a0,a0,-548 # 80008118 <digits+0xd8>
    80001344:	fffff097          	auipc	ra,0xfffff
    80001348:	204080e7          	jalr	516(ra) # 80000548 <panic>
      panic("uvmunmap: not a leaf");
    8000134c:	00007517          	auipc	a0,0x7
    80001350:	de450513          	addi	a0,a0,-540 # 80008130 <digits+0xf0>
    80001354:	fffff097          	auipc	ra,0xfffff
    80001358:	1f4080e7          	jalr	500(ra) # 80000548 <panic>
      uint64 pa = PTE2PA(*pte);
    8000135c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000135e:	0532                	slli	a0,a0,0xc
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	6c4080e7          	jalr	1732(ra) # 80000a24 <kfree>
    *pte = 0;
    80001368:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000136c:	995a                	add	s2,s2,s6
    8000136e:	f9397ce3          	bgeu	s2,s3,80001306 <uvmunmap+0x30>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001372:	4601                	li	a2,0
    80001374:	85ca                	mv	a1,s2
    80001376:	8552                	mv	a0,s4
    80001378:	00000097          	auipc	ra,0x0
    8000137c:	c80080e7          	jalr	-896(ra) # 80000ff8 <walk>
    80001380:	84aa                	mv	s1,a0
    80001382:	d54d                	beqz	a0,8000132c <uvmunmap+0x56>
    if((*pte & PTE_V) == 0)
    80001384:	6108                	ld	a0,0(a0)
    80001386:	00157793          	andi	a5,a0,1
    8000138a:	dbcd                	beqz	a5,8000133c <uvmunmap+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000138c:	3ff57793          	andi	a5,a0,1023
    80001390:	fb778ee3          	beq	a5,s7,8000134c <uvmunmap+0x76>
    if(do_free){
    80001394:	fc0a8ae3          	beqz	s5,80001368 <uvmunmap+0x92>
    80001398:	b7d1                	j	8000135c <uvmunmap+0x86>

000000008000139a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000139a:	1101                	addi	sp,sp,-32
    8000139c:	ec06                	sd	ra,24(sp)
    8000139e:	e822                	sd	s0,16(sp)
    800013a0:	e426                	sd	s1,8(sp)
    800013a2:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013a4:	fffff097          	auipc	ra,0xfffff
    800013a8:	77c080e7          	jalr	1916(ra) # 80000b20 <kalloc>
    800013ac:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013ae:	c519                	beqz	a0,800013bc <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013b0:	6605                	lui	a2,0x1
    800013b2:	4581                	li	a1,0
    800013b4:	00000097          	auipc	ra,0x0
    800013b8:	958080e7          	jalr	-1704(ra) # 80000d0c <memset>
  return pagetable;
}
    800013bc:	8526                	mv	a0,s1
    800013be:	60e2                	ld	ra,24(sp)
    800013c0:	6442                	ld	s0,16(sp)
    800013c2:	64a2                	ld	s1,8(sp)
    800013c4:	6105                	addi	sp,sp,32
    800013c6:	8082                	ret

00000000800013c8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800013c8:	7179                	addi	sp,sp,-48
    800013ca:	f406                	sd	ra,40(sp)
    800013cc:	f022                	sd	s0,32(sp)
    800013ce:	ec26                	sd	s1,24(sp)
    800013d0:	e84a                	sd	s2,16(sp)
    800013d2:	e44e                	sd	s3,8(sp)
    800013d4:	e052                	sd	s4,0(sp)
    800013d6:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013d8:	6785                	lui	a5,0x1
    800013da:	04f67863          	bgeu	a2,a5,8000142a <uvminit+0x62>
    800013de:	8a2a                	mv	s4,a0
    800013e0:	89ae                	mv	s3,a1
    800013e2:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800013e4:	fffff097          	auipc	ra,0xfffff
    800013e8:	73c080e7          	jalr	1852(ra) # 80000b20 <kalloc>
    800013ec:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800013ee:	6605                	lui	a2,0x1
    800013f0:	4581                	li	a1,0
    800013f2:	00000097          	auipc	ra,0x0
    800013f6:	91a080e7          	jalr	-1766(ra) # 80000d0c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800013fa:	4779                	li	a4,30
    800013fc:	86ca                	mv	a3,s2
    800013fe:	6605                	lui	a2,0x1
    80001400:	4581                	li	a1,0
    80001402:	8552                	mv	a0,s4
    80001404:	00000097          	auipc	ra,0x0
    80001408:	d3a080e7          	jalr	-710(ra) # 8000113e <mappages>
  memmove(mem, src, sz);
    8000140c:	8626                	mv	a2,s1
    8000140e:	85ce                	mv	a1,s3
    80001410:	854a                	mv	a0,s2
    80001412:	00000097          	auipc	ra,0x0
    80001416:	95a080e7          	jalr	-1702(ra) # 80000d6c <memmove>
}
    8000141a:	70a2                	ld	ra,40(sp)
    8000141c:	7402                	ld	s0,32(sp)
    8000141e:	64e2                	ld	s1,24(sp)
    80001420:	6942                	ld	s2,16(sp)
    80001422:	69a2                	ld	s3,8(sp)
    80001424:	6a02                	ld	s4,0(sp)
    80001426:	6145                	addi	sp,sp,48
    80001428:	8082                	ret
    panic("inituvm: more than a page");
    8000142a:	00007517          	auipc	a0,0x7
    8000142e:	d1e50513          	addi	a0,a0,-738 # 80008148 <digits+0x108>
    80001432:	fffff097          	auipc	ra,0xfffff
    80001436:	116080e7          	jalr	278(ra) # 80000548 <panic>

000000008000143a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000143a:	1101                	addi	sp,sp,-32
    8000143c:	ec06                	sd	ra,24(sp)
    8000143e:	e822                	sd	s0,16(sp)
    80001440:	e426                	sd	s1,8(sp)
    80001442:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001444:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001446:	00b67d63          	bgeu	a2,a1,80001460 <uvmdealloc+0x26>
    8000144a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000144c:	6785                	lui	a5,0x1
    8000144e:	17fd                	addi	a5,a5,-1
    80001450:	00f60733          	add	a4,a2,a5
    80001454:	767d                	lui	a2,0xfffff
    80001456:	8f71                	and	a4,a4,a2
    80001458:	97ae                	add	a5,a5,a1
    8000145a:	8ff1                	and	a5,a5,a2
    8000145c:	00f76863          	bltu	a4,a5,8000146c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001460:	8526                	mv	a0,s1
    80001462:	60e2                	ld	ra,24(sp)
    80001464:	6442                	ld	s0,16(sp)
    80001466:	64a2                	ld	s1,8(sp)
    80001468:	6105                	addi	sp,sp,32
    8000146a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000146c:	8f99                	sub	a5,a5,a4
    8000146e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001470:	4685                	li	a3,1
    80001472:	0007861b          	sext.w	a2,a5
    80001476:	85ba                	mv	a1,a4
    80001478:	00000097          	auipc	ra,0x0
    8000147c:	e5e080e7          	jalr	-418(ra) # 800012d6 <uvmunmap>
    80001480:	b7c5                	j	80001460 <uvmdealloc+0x26>

0000000080001482 <uvmalloc>:
  if(newsz < oldsz)
    80001482:	0ab66163          	bltu	a2,a1,80001524 <uvmalloc+0xa2>
{
    80001486:	7139                	addi	sp,sp,-64
    80001488:	fc06                	sd	ra,56(sp)
    8000148a:	f822                	sd	s0,48(sp)
    8000148c:	f426                	sd	s1,40(sp)
    8000148e:	f04a                	sd	s2,32(sp)
    80001490:	ec4e                	sd	s3,24(sp)
    80001492:	e852                	sd	s4,16(sp)
    80001494:	e456                	sd	s5,8(sp)
    80001496:	0080                	addi	s0,sp,64
    80001498:	8aaa                	mv	s5,a0
    8000149a:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000149c:	6985                	lui	s3,0x1
    8000149e:	19fd                	addi	s3,s3,-1
    800014a0:	95ce                	add	a1,a1,s3
    800014a2:	79fd                	lui	s3,0xfffff
    800014a4:	0135f9b3          	and	s3,a1,s3
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014a8:	08c9f063          	bgeu	s3,a2,80001528 <uvmalloc+0xa6>
    800014ac:	894e                	mv	s2,s3
    mem = kalloc();
    800014ae:	fffff097          	auipc	ra,0xfffff
    800014b2:	672080e7          	jalr	1650(ra) # 80000b20 <kalloc>
    800014b6:	84aa                	mv	s1,a0
    if(mem == 0){
    800014b8:	c51d                	beqz	a0,800014e6 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014ba:	6605                	lui	a2,0x1
    800014bc:	4581                	li	a1,0
    800014be:	00000097          	auipc	ra,0x0
    800014c2:	84e080e7          	jalr	-1970(ra) # 80000d0c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800014c6:	4779                	li	a4,30
    800014c8:	86a6                	mv	a3,s1
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ca                	mv	a1,s2
    800014ce:	8556                	mv	a0,s5
    800014d0:	00000097          	auipc	ra,0x0
    800014d4:	c6e080e7          	jalr	-914(ra) # 8000113e <mappages>
    800014d8:	e905                	bnez	a0,80001508 <uvmalloc+0x86>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014da:	6785                	lui	a5,0x1
    800014dc:	993e                	add	s2,s2,a5
    800014de:	fd4968e3          	bltu	s2,s4,800014ae <uvmalloc+0x2c>
  return newsz;
    800014e2:	8552                	mv	a0,s4
    800014e4:	a809                	j	800014f6 <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800014e6:	864e                	mv	a2,s3
    800014e8:	85ca                	mv	a1,s2
    800014ea:	8556                	mv	a0,s5
    800014ec:	00000097          	auipc	ra,0x0
    800014f0:	f4e080e7          	jalr	-178(ra) # 8000143a <uvmdealloc>
      return 0;
    800014f4:	4501                	li	a0,0
}
    800014f6:	70e2                	ld	ra,56(sp)
    800014f8:	7442                	ld	s0,48(sp)
    800014fa:	74a2                	ld	s1,40(sp)
    800014fc:	7902                	ld	s2,32(sp)
    800014fe:	69e2                	ld	s3,24(sp)
    80001500:	6a42                	ld	s4,16(sp)
    80001502:	6aa2                	ld	s5,8(sp)
    80001504:	6121                	addi	sp,sp,64
    80001506:	8082                	ret
      kfree(mem);
    80001508:	8526                	mv	a0,s1
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	51a080e7          	jalr	1306(ra) # 80000a24 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001512:	864e                	mv	a2,s3
    80001514:	85ca                	mv	a1,s2
    80001516:	8556                	mv	a0,s5
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	f22080e7          	jalr	-222(ra) # 8000143a <uvmdealloc>
      return 0;
    80001520:	4501                	li	a0,0
    80001522:	bfd1                	j	800014f6 <uvmalloc+0x74>
    return oldsz;
    80001524:	852e                	mv	a0,a1
}
    80001526:	8082                	ret
  return newsz;
    80001528:	8532                	mv	a0,a2
    8000152a:	b7f1                	j	800014f6 <uvmalloc+0x74>

000000008000152c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000152c:	7179                	addi	sp,sp,-48
    8000152e:	f406                	sd	ra,40(sp)
    80001530:	f022                	sd	s0,32(sp)
    80001532:	ec26                	sd	s1,24(sp)
    80001534:	e84a                	sd	s2,16(sp)
    80001536:	e44e                	sd	s3,8(sp)
    80001538:	e052                	sd	s4,0(sp)
    8000153a:	1800                	addi	s0,sp,48
    8000153c:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000153e:	84aa                	mv	s1,a0
    80001540:	6905                	lui	s2,0x1
    80001542:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001544:	4985                	li	s3,1
    80001546:	a821                	j	8000155e <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001548:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000154a:	0532                	slli	a0,a0,0xc
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	fe0080e7          	jalr	-32(ra) # 8000152c <freewalk>
      pagetable[i] = 0;
    80001554:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001558:	04a1                	addi	s1,s1,8
    8000155a:	03248163          	beq	s1,s2,8000157c <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000155e:	6088                	ld	a0,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001560:	00f57793          	andi	a5,a0,15
    80001564:	ff3782e3          	beq	a5,s3,80001548 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001568:	8905                	andi	a0,a0,1
    8000156a:	d57d                	beqz	a0,80001558 <freewalk+0x2c>
      panic("freewalk: leaf");
    8000156c:	00007517          	auipc	a0,0x7
    80001570:	bfc50513          	addi	a0,a0,-1028 # 80008168 <digits+0x128>
    80001574:	fffff097          	auipc	ra,0xfffff
    80001578:	fd4080e7          	jalr	-44(ra) # 80000548 <panic>
    }
  }
  kfree((void*)pagetable);
    8000157c:	8552                	mv	a0,s4
    8000157e:	fffff097          	auipc	ra,0xfffff
    80001582:	4a6080e7          	jalr	1190(ra) # 80000a24 <kfree>
}
    80001586:	70a2                	ld	ra,40(sp)
    80001588:	7402                	ld	s0,32(sp)
    8000158a:	64e2                	ld	s1,24(sp)
    8000158c:	6942                	ld	s2,16(sp)
    8000158e:	69a2                	ld	s3,8(sp)
    80001590:	6a02                	ld	s4,0(sp)
    80001592:	6145                	addi	sp,sp,48
    80001594:	8082                	ret

0000000080001596 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001596:	1101                	addi	sp,sp,-32
    80001598:	ec06                	sd	ra,24(sp)
    8000159a:	e822                	sd	s0,16(sp)
    8000159c:	e426                	sd	s1,8(sp)
    8000159e:	1000                	addi	s0,sp,32
    800015a0:	84aa                	mv	s1,a0
  if(sz > 0)
    800015a2:	e999                	bnez	a1,800015b8 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015a4:	8526                	mv	a0,s1
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	f86080e7          	jalr	-122(ra) # 8000152c <freewalk>
}
    800015ae:	60e2                	ld	ra,24(sp)
    800015b0:	6442                	ld	s0,16(sp)
    800015b2:	64a2                	ld	s1,8(sp)
    800015b4:	6105                	addi	sp,sp,32
    800015b6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015b8:	6605                	lui	a2,0x1
    800015ba:	167d                	addi	a2,a2,-1
    800015bc:	962e                	add	a2,a2,a1
    800015be:	4685                	li	a3,1
    800015c0:	8231                	srli	a2,a2,0xc
    800015c2:	4581                	li	a1,0
    800015c4:	00000097          	auipc	ra,0x0
    800015c8:	d12080e7          	jalr	-750(ra) # 800012d6 <uvmunmap>
    800015cc:	bfe1                	j	800015a4 <uvmfree+0xe>

00000000800015ce <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800015ce:	c679                	beqz	a2,8000169c <uvmcopy+0xce>
{
    800015d0:	715d                	addi	sp,sp,-80
    800015d2:	e486                	sd	ra,72(sp)
    800015d4:	e0a2                	sd	s0,64(sp)
    800015d6:	fc26                	sd	s1,56(sp)
    800015d8:	f84a                	sd	s2,48(sp)
    800015da:	f44e                	sd	s3,40(sp)
    800015dc:	f052                	sd	s4,32(sp)
    800015de:	ec56                	sd	s5,24(sp)
    800015e0:	e85a                	sd	s6,16(sp)
    800015e2:	e45e                	sd	s7,8(sp)
    800015e4:	0880                	addi	s0,sp,80
    800015e6:	8b2a                	mv	s6,a0
    800015e8:	8aae                	mv	s5,a1
    800015ea:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800015ec:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800015ee:	4601                	li	a2,0
    800015f0:	85ce                	mv	a1,s3
    800015f2:	855a                	mv	a0,s6
    800015f4:	00000097          	auipc	ra,0x0
    800015f8:	a04080e7          	jalr	-1532(ra) # 80000ff8 <walk>
    800015fc:	c531                	beqz	a0,80001648 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800015fe:	6118                	ld	a4,0(a0)
    80001600:	00177793          	andi	a5,a4,1
    80001604:	cbb1                	beqz	a5,80001658 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001606:	00a75593          	srli	a1,a4,0xa
    8000160a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000160e:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001612:	fffff097          	auipc	ra,0xfffff
    80001616:	50e080e7          	jalr	1294(ra) # 80000b20 <kalloc>
    8000161a:	892a                	mv	s2,a0
    8000161c:	c939                	beqz	a0,80001672 <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    8000161e:	6605                	lui	a2,0x1
    80001620:	85de                	mv	a1,s7
    80001622:	fffff097          	auipc	ra,0xfffff
    80001626:	74a080e7          	jalr	1866(ra) # 80000d6c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000162a:	8726                	mv	a4,s1
    8000162c:	86ca                	mv	a3,s2
    8000162e:	6605                	lui	a2,0x1
    80001630:	85ce                	mv	a1,s3
    80001632:	8556                	mv	a0,s5
    80001634:	00000097          	auipc	ra,0x0
    80001638:	b0a080e7          	jalr	-1270(ra) # 8000113e <mappages>
    8000163c:	e515                	bnez	a0,80001668 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    8000163e:	6785                	lui	a5,0x1
    80001640:	99be                	add	s3,s3,a5
    80001642:	fb49e6e3          	bltu	s3,s4,800015ee <uvmcopy+0x20>
    80001646:	a081                	j	80001686 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001648:	00007517          	auipc	a0,0x7
    8000164c:	b3050513          	addi	a0,a0,-1232 # 80008178 <digits+0x138>
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	ef8080e7          	jalr	-264(ra) # 80000548 <panic>
      panic("uvmcopy: page not present");
    80001658:	00007517          	auipc	a0,0x7
    8000165c:	b4050513          	addi	a0,a0,-1216 # 80008198 <digits+0x158>
    80001660:	fffff097          	auipc	ra,0xfffff
    80001664:	ee8080e7          	jalr	-280(ra) # 80000548 <panic>
      kfree(mem);
    80001668:	854a                	mv	a0,s2
    8000166a:	fffff097          	auipc	ra,0xfffff
    8000166e:	3ba080e7          	jalr	954(ra) # 80000a24 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001672:	4685                	li	a3,1
    80001674:	00c9d613          	srli	a2,s3,0xc
    80001678:	4581                	li	a1,0
    8000167a:	8556                	mv	a0,s5
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	c5a080e7          	jalr	-934(ra) # 800012d6 <uvmunmap>
  return -1;
    80001684:	557d                	li	a0,-1
}
    80001686:	60a6                	ld	ra,72(sp)
    80001688:	6406                	ld	s0,64(sp)
    8000168a:	74e2                	ld	s1,56(sp)
    8000168c:	7942                	ld	s2,48(sp)
    8000168e:	79a2                	ld	s3,40(sp)
    80001690:	7a02                	ld	s4,32(sp)
    80001692:	6ae2                	ld	s5,24(sp)
    80001694:	6b42                	ld	s6,16(sp)
    80001696:	6ba2                	ld	s7,8(sp)
    80001698:	6161                	addi	sp,sp,80
    8000169a:	8082                	ret
  return 0;
    8000169c:	4501                	li	a0,0
}
    8000169e:	8082                	ret

00000000800016a0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016a0:	1141                	addi	sp,sp,-16
    800016a2:	e406                	sd	ra,8(sp)
    800016a4:	e022                	sd	s0,0(sp)
    800016a6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016a8:	4601                	li	a2,0
    800016aa:	00000097          	auipc	ra,0x0
    800016ae:	94e080e7          	jalr	-1714(ra) # 80000ff8 <walk>
  if(pte == 0)
    800016b2:	c901                	beqz	a0,800016c2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016b4:	611c                	ld	a5,0(a0)
    800016b6:	9bbd                	andi	a5,a5,-17
    800016b8:	e11c                	sd	a5,0(a0)
}
    800016ba:	60a2                	ld	ra,8(sp)
    800016bc:	6402                	ld	s0,0(sp)
    800016be:	0141                	addi	sp,sp,16
    800016c0:	8082                	ret
    panic("uvmclear");
    800016c2:	00007517          	auipc	a0,0x7
    800016c6:	af650513          	addi	a0,a0,-1290 # 800081b8 <digits+0x178>
    800016ca:	fffff097          	auipc	ra,0xfffff
    800016ce:	e7e080e7          	jalr	-386(ra) # 80000548 <panic>

00000000800016d2 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800016d2:	c6bd                	beqz	a3,80001740 <copyout+0x6e>
{
    800016d4:	715d                	addi	sp,sp,-80
    800016d6:	e486                	sd	ra,72(sp)
    800016d8:	e0a2                	sd	s0,64(sp)
    800016da:	fc26                	sd	s1,56(sp)
    800016dc:	f84a                	sd	s2,48(sp)
    800016de:	f44e                	sd	s3,40(sp)
    800016e0:	f052                	sd	s4,32(sp)
    800016e2:	ec56                	sd	s5,24(sp)
    800016e4:	e85a                	sd	s6,16(sp)
    800016e6:	e45e                	sd	s7,8(sp)
    800016e8:	e062                	sd	s8,0(sp)
    800016ea:	0880                	addi	s0,sp,80
    800016ec:	8b2a                	mv	s6,a0
    800016ee:	8c2e                	mv	s8,a1
    800016f0:	8a32                	mv	s4,a2
    800016f2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800016f4:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    800016f6:	6a85                	lui	s5,0x1
    800016f8:	a015                	j	8000171c <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800016fa:	9562                	add	a0,a0,s8
    800016fc:	0004861b          	sext.w	a2,s1
    80001700:	85d2                	mv	a1,s4
    80001702:	41250533          	sub	a0,a0,s2
    80001706:	fffff097          	auipc	ra,0xfffff
    8000170a:	666080e7          	jalr	1638(ra) # 80000d6c <memmove>

    len -= n;
    8000170e:	409989b3          	sub	s3,s3,s1
    src += n;
    80001712:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    80001714:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001718:	02098263          	beqz	s3,8000173c <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    8000171c:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001720:	85ca                	mv	a1,s2
    80001722:	855a                	mv	a0,s6
    80001724:	00000097          	auipc	ra,0x0
    80001728:	97a080e7          	jalr	-1670(ra) # 8000109e <walkaddr>
    if(pa0 == 0)
    8000172c:	cd01                	beqz	a0,80001744 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    8000172e:	418904b3          	sub	s1,s2,s8
    80001732:	94d6                	add	s1,s1,s5
    if(n > len)
    80001734:	fc99f3e3          	bgeu	s3,s1,800016fa <copyout+0x28>
    80001738:	84ce                	mv	s1,s3
    8000173a:	b7c1                	j	800016fa <copyout+0x28>
  }
  return 0;
    8000173c:	4501                	li	a0,0
    8000173e:	a021                	j	80001746 <copyout+0x74>
    80001740:	4501                	li	a0,0
}
    80001742:	8082                	ret
      return -1;
    80001744:	557d                	li	a0,-1
}
    80001746:	60a6                	ld	ra,72(sp)
    80001748:	6406                	ld	s0,64(sp)
    8000174a:	74e2                	ld	s1,56(sp)
    8000174c:	7942                	ld	s2,48(sp)
    8000174e:	79a2                	ld	s3,40(sp)
    80001750:	7a02                	ld	s4,32(sp)
    80001752:	6ae2                	ld	s5,24(sp)
    80001754:	6b42                	ld	s6,16(sp)
    80001756:	6ba2                	ld	s7,8(sp)
    80001758:	6c02                	ld	s8,0(sp)
    8000175a:	6161                	addi	sp,sp,80
    8000175c:	8082                	ret

000000008000175e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000175e:	c6bd                	beqz	a3,800017cc <copyin+0x6e>
{
    80001760:	715d                	addi	sp,sp,-80
    80001762:	e486                	sd	ra,72(sp)
    80001764:	e0a2                	sd	s0,64(sp)
    80001766:	fc26                	sd	s1,56(sp)
    80001768:	f84a                	sd	s2,48(sp)
    8000176a:	f44e                	sd	s3,40(sp)
    8000176c:	f052                	sd	s4,32(sp)
    8000176e:	ec56                	sd	s5,24(sp)
    80001770:	e85a                	sd	s6,16(sp)
    80001772:	e45e                	sd	s7,8(sp)
    80001774:	e062                	sd	s8,0(sp)
    80001776:	0880                	addi	s0,sp,80
    80001778:	8b2a                	mv	s6,a0
    8000177a:	8a2e                	mv	s4,a1
    8000177c:	8c32                	mv	s8,a2
    8000177e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001780:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001782:	6a85                	lui	s5,0x1
    80001784:	a015                	j	800017a8 <copyin+0x4a>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001786:	9562                	add	a0,a0,s8
    80001788:	0004861b          	sext.w	a2,s1
    8000178c:	412505b3          	sub	a1,a0,s2
    80001790:	8552                	mv	a0,s4
    80001792:	fffff097          	auipc	ra,0xfffff
    80001796:	5da080e7          	jalr	1498(ra) # 80000d6c <memmove>

    len -= n;
    8000179a:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000179e:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017a0:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017a4:	02098263          	beqz	s3,800017c8 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    800017a8:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017ac:	85ca                	mv	a1,s2
    800017ae:	855a                	mv	a0,s6
    800017b0:	00000097          	auipc	ra,0x0
    800017b4:	8ee080e7          	jalr	-1810(ra) # 8000109e <walkaddr>
    if(pa0 == 0)
    800017b8:	cd01                	beqz	a0,800017d0 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    800017ba:	418904b3          	sub	s1,s2,s8
    800017be:	94d6                	add	s1,s1,s5
    if(n > len)
    800017c0:	fc99f3e3          	bgeu	s3,s1,80001786 <copyin+0x28>
    800017c4:	84ce                	mv	s1,s3
    800017c6:	b7c1                	j	80001786 <copyin+0x28>
  }
  return 0;
    800017c8:	4501                	li	a0,0
    800017ca:	a021                	j	800017d2 <copyin+0x74>
    800017cc:	4501                	li	a0,0
}
    800017ce:	8082                	ret
      return -1;
    800017d0:	557d                	li	a0,-1
}
    800017d2:	60a6                	ld	ra,72(sp)
    800017d4:	6406                	ld	s0,64(sp)
    800017d6:	74e2                	ld	s1,56(sp)
    800017d8:	7942                	ld	s2,48(sp)
    800017da:	79a2                	ld	s3,40(sp)
    800017dc:	7a02                	ld	s4,32(sp)
    800017de:	6ae2                	ld	s5,24(sp)
    800017e0:	6b42                	ld	s6,16(sp)
    800017e2:	6ba2                	ld	s7,8(sp)
    800017e4:	6c02                	ld	s8,0(sp)
    800017e6:	6161                	addi	sp,sp,80
    800017e8:	8082                	ret

00000000800017ea <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800017ea:	c6c5                	beqz	a3,80001892 <copyinstr+0xa8>
{
    800017ec:	715d                	addi	sp,sp,-80
    800017ee:	e486                	sd	ra,72(sp)
    800017f0:	e0a2                	sd	s0,64(sp)
    800017f2:	fc26                	sd	s1,56(sp)
    800017f4:	f84a                	sd	s2,48(sp)
    800017f6:	f44e                	sd	s3,40(sp)
    800017f8:	f052                	sd	s4,32(sp)
    800017fa:	ec56                	sd	s5,24(sp)
    800017fc:	e85a                	sd	s6,16(sp)
    800017fe:	e45e                	sd	s7,8(sp)
    80001800:	0880                	addi	s0,sp,80
    80001802:	8a2a                	mv	s4,a0
    80001804:	8b2e                	mv	s6,a1
    80001806:	8bb2                	mv	s7,a2
    80001808:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    8000180a:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000180c:	6985                	lui	s3,0x1
    8000180e:	a035                	j	8000183a <copyinstr+0x50>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001810:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001814:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001816:	0017b793          	seqz	a5,a5
    8000181a:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    8000181e:	60a6                	ld	ra,72(sp)
    80001820:	6406                	ld	s0,64(sp)
    80001822:	74e2                	ld	s1,56(sp)
    80001824:	7942                	ld	s2,48(sp)
    80001826:	79a2                	ld	s3,40(sp)
    80001828:	7a02                	ld	s4,32(sp)
    8000182a:	6ae2                	ld	s5,24(sp)
    8000182c:	6b42                	ld	s6,16(sp)
    8000182e:	6ba2                	ld	s7,8(sp)
    80001830:	6161                	addi	sp,sp,80
    80001832:	8082                	ret
    srcva = va0 + PGSIZE;
    80001834:	01390bb3          	add	s7,s2,s3
  while(got_null == 0 && max > 0){
    80001838:	c8a9                	beqz	s1,8000188a <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    8000183a:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    8000183e:	85ca                	mv	a1,s2
    80001840:	8552                	mv	a0,s4
    80001842:	00000097          	auipc	ra,0x0
    80001846:	85c080e7          	jalr	-1956(ra) # 8000109e <walkaddr>
    if(pa0 == 0)
    8000184a:	c131                	beqz	a0,8000188e <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    8000184c:	41790833          	sub	a6,s2,s7
    80001850:	984e                	add	a6,a6,s3
    if(n > max)
    80001852:	0104f363          	bgeu	s1,a6,80001858 <copyinstr+0x6e>
    80001856:	8826                	mv	a6,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80001858:	955e                	add	a0,a0,s7
    8000185a:	41250533          	sub	a0,a0,s2
    while(n > 0){
    8000185e:	fc080be3          	beqz	a6,80001834 <copyinstr+0x4a>
    80001862:	985a                	add	a6,a6,s6
    80001864:	87da                	mv	a5,s6
      if(*p == '\0'){
    80001866:	41650633          	sub	a2,a0,s6
    8000186a:	14fd                	addi	s1,s1,-1
    8000186c:	9b26                	add	s6,s6,s1
    8000186e:	00f60733          	add	a4,a2,a5
    80001872:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd9000>
    80001876:	df49                	beqz	a4,80001810 <copyinstr+0x26>
        *dst = *p;
    80001878:	00e78023          	sb	a4,0(a5)
      --max;
    8000187c:	40fb04b3          	sub	s1,s6,a5
      dst++;
    80001880:	0785                	addi	a5,a5,1
    while(n > 0){
    80001882:	ff0796e3          	bne	a5,a6,8000186e <copyinstr+0x84>
      dst++;
    80001886:	8b42                	mv	s6,a6
    80001888:	b775                	j	80001834 <copyinstr+0x4a>
    8000188a:	4781                	li	a5,0
    8000188c:	b769                	j	80001816 <copyinstr+0x2c>
      return -1;
    8000188e:	557d                	li	a0,-1
    80001890:	b779                	j	8000181e <copyinstr+0x34>
  int got_null = 0;
    80001892:	4781                	li	a5,0
  if(got_null){
    80001894:	0017b793          	seqz	a5,a5
    80001898:	40f00533          	neg	a0,a5
}
    8000189c:	8082                	ret

000000008000189e <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    8000189e:	1101                	addi	sp,sp,-32
    800018a0:	ec06                	sd	ra,24(sp)
    800018a2:	e822                	sd	s0,16(sp)
    800018a4:	e426                	sd	s1,8(sp)
    800018a6:	1000                	addi	s0,sp,32
    800018a8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800018aa:	fffff097          	auipc	ra,0xfffff
    800018ae:	2ec080e7          	jalr	748(ra) # 80000b96 <holding>
    800018b2:	c909                	beqz	a0,800018c4 <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    800018b4:	749c                	ld	a5,40(s1)
    800018b6:	00978f63          	beq	a5,s1,800018d4 <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    800018ba:	60e2                	ld	ra,24(sp)
    800018bc:	6442                	ld	s0,16(sp)
    800018be:	64a2                	ld	s1,8(sp)
    800018c0:	6105                	addi	sp,sp,32
    800018c2:	8082                	ret
    panic("wakeup1");
    800018c4:	00007517          	auipc	a0,0x7
    800018c8:	90450513          	addi	a0,a0,-1788 # 800081c8 <digits+0x188>
    800018cc:	fffff097          	auipc	ra,0xfffff
    800018d0:	c7c080e7          	jalr	-900(ra) # 80000548 <panic>
  if(p->chan == p && p->state == SLEEPING) {
    800018d4:	4c98                	lw	a4,24(s1)
    800018d6:	4785                	li	a5,1
    800018d8:	fef711e3          	bne	a4,a5,800018ba <wakeup1+0x1c>
    p->state = RUNNABLE;
    800018dc:	4789                	li	a5,2
    800018de:	cc9c                	sw	a5,24(s1)
}
    800018e0:	bfe9                	j	800018ba <wakeup1+0x1c>

00000000800018e2 <procinit>:
{
    800018e2:	715d                	addi	sp,sp,-80
    800018e4:	e486                	sd	ra,72(sp)
    800018e6:	e0a2                	sd	s0,64(sp)
    800018e8:	fc26                	sd	s1,56(sp)
    800018ea:	f84a                	sd	s2,48(sp)
    800018ec:	f44e                	sd	s3,40(sp)
    800018ee:	f052                	sd	s4,32(sp)
    800018f0:	ec56                	sd	s5,24(sp)
    800018f2:	e85a                	sd	s6,16(sp)
    800018f4:	e45e                	sd	s7,8(sp)
    800018f6:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    800018f8:	00007597          	auipc	a1,0x7
    800018fc:	8d858593          	addi	a1,a1,-1832 # 800081d0 <digits+0x190>
    80001900:	00010517          	auipc	a0,0x10
    80001904:	05050513          	addi	a0,a0,80 # 80011950 <pid_lock>
    80001908:	fffff097          	auipc	ra,0xfffff
    8000190c:	278080e7          	jalr	632(ra) # 80000b80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001910:	00010917          	auipc	s2,0x10
    80001914:	45890913          	addi	s2,s2,1112 # 80011d68 <proc>
      initlock(&p->lock, "proc");
    80001918:	00007b97          	auipc	s7,0x7
    8000191c:	8c0b8b93          	addi	s7,s7,-1856 # 800081d8 <digits+0x198>
      uint64 va = KSTACK((int) (p - proc));
    80001920:	8b4a                	mv	s6,s2
    80001922:	00006a97          	auipc	s5,0x6
    80001926:	6dea8a93          	addi	s5,s5,1758 # 80008000 <etext>
    8000192a:	040009b7          	lui	s3,0x4000
    8000192e:	19fd                	addi	s3,s3,-1
    80001930:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001932:	00016a17          	auipc	s4,0x16
    80001936:	e36a0a13          	addi	s4,s4,-458 # 80017768 <tickslock>
      initlock(&p->lock, "proc");
    8000193a:	85de                	mv	a1,s7
    8000193c:	854a                	mv	a0,s2
    8000193e:	fffff097          	auipc	ra,0xfffff
    80001942:	242080e7          	jalr	578(ra) # 80000b80 <initlock>
      char *pa = kalloc();
    80001946:	fffff097          	auipc	ra,0xfffff
    8000194a:	1da080e7          	jalr	474(ra) # 80000b20 <kalloc>
    8000194e:	85aa                	mv	a1,a0
      if(pa == 0)
    80001950:	c929                	beqz	a0,800019a2 <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    80001952:	416904b3          	sub	s1,s2,s6
    80001956:	848d                	srai	s1,s1,0x3
    80001958:	000ab783          	ld	a5,0(s5)
    8000195c:	02f484b3          	mul	s1,s1,a5
    80001960:	2485                	addiw	s1,s1,1
    80001962:	00d4949b          	slliw	s1,s1,0xd
    80001966:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000196a:	4699                	li	a3,6
    8000196c:	6605                	lui	a2,0x1
    8000196e:	8526                	mv	a0,s1
    80001970:	00000097          	auipc	ra,0x0
    80001974:	85c080e7          	jalr	-1956(ra) # 800011cc <kvmmap>
      p->kstack = va;
    80001978:	04993023          	sd	s1,64(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000197c:	16890913          	addi	s2,s2,360
    80001980:	fb491de3          	bne	s2,s4,8000193a <procinit+0x58>
  kvminithart();
    80001984:	fffff097          	auipc	ra,0xfffff
    80001988:	650080e7          	jalr	1616(ra) # 80000fd4 <kvminithart>
}
    8000198c:	60a6                	ld	ra,72(sp)
    8000198e:	6406                	ld	s0,64(sp)
    80001990:	74e2                	ld	s1,56(sp)
    80001992:	7942                	ld	s2,48(sp)
    80001994:	79a2                	ld	s3,40(sp)
    80001996:	7a02                	ld	s4,32(sp)
    80001998:	6ae2                	ld	s5,24(sp)
    8000199a:	6b42                	ld	s6,16(sp)
    8000199c:	6ba2                	ld	s7,8(sp)
    8000199e:	6161                	addi	sp,sp,80
    800019a0:	8082                	ret
        panic("kalloc");
    800019a2:	00007517          	auipc	a0,0x7
    800019a6:	83e50513          	addi	a0,a0,-1986 # 800081e0 <digits+0x1a0>
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	b9e080e7          	jalr	-1122(ra) # 80000548 <panic>

00000000800019b2 <cpuid>:
{
    800019b2:	1141                	addi	sp,sp,-16
    800019b4:	e422                	sd	s0,8(sp)
    800019b6:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800019b8:	8512                	mv	a0,tp
}
    800019ba:	2501                	sext.w	a0,a0
    800019bc:	6422                	ld	s0,8(sp)
    800019be:	0141                	addi	sp,sp,16
    800019c0:	8082                	ret

00000000800019c2 <mycpu>:
mycpu(void) {
    800019c2:	1141                	addi	sp,sp,-16
    800019c4:	e422                	sd	s0,8(sp)
    800019c6:	0800                	addi	s0,sp,16
    800019c8:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    800019ca:	2781                	sext.w	a5,a5
    800019cc:	079e                	slli	a5,a5,0x7
}
    800019ce:	00010517          	auipc	a0,0x10
    800019d2:	f9a50513          	addi	a0,a0,-102 # 80011968 <cpus>
    800019d6:	953e                	add	a0,a0,a5
    800019d8:	6422                	ld	s0,8(sp)
    800019da:	0141                	addi	sp,sp,16
    800019dc:	8082                	ret

00000000800019de <myproc>:
myproc(void) {
    800019de:	1101                	addi	sp,sp,-32
    800019e0:	ec06                	sd	ra,24(sp)
    800019e2:	e822                	sd	s0,16(sp)
    800019e4:	e426                	sd	s1,8(sp)
    800019e6:	1000                	addi	s0,sp,32
  push_off();
    800019e8:	fffff097          	auipc	ra,0xfffff
    800019ec:	1dc080e7          	jalr	476(ra) # 80000bc4 <push_off>
    800019f0:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    800019f2:	2781                	sext.w	a5,a5
    800019f4:	079e                	slli	a5,a5,0x7
    800019f6:	00010717          	auipc	a4,0x10
    800019fa:	f5a70713          	addi	a4,a4,-166 # 80011950 <pid_lock>
    800019fe:	97ba                	add	a5,a5,a4
    80001a00:	6f84                	ld	s1,24(a5)
  pop_off();
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	262080e7          	jalr	610(ra) # 80000c64 <pop_off>
}
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	60e2                	ld	ra,24(sp)
    80001a0e:	6442                	ld	s0,16(sp)
    80001a10:	64a2                	ld	s1,8(sp)
    80001a12:	6105                	addi	sp,sp,32
    80001a14:	8082                	ret

0000000080001a16 <forkret>:
{
    80001a16:	1141                	addi	sp,sp,-16
    80001a18:	e406                	sd	ra,8(sp)
    80001a1a:	e022                	sd	s0,0(sp)
    80001a1c:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001a1e:	00000097          	auipc	ra,0x0
    80001a22:	fc0080e7          	jalr	-64(ra) # 800019de <myproc>
    80001a26:	fffff097          	auipc	ra,0xfffff
    80001a2a:	29e080e7          	jalr	670(ra) # 80000cc4 <release>
  if (first) {
    80001a2e:	00007797          	auipc	a5,0x7
    80001a32:	de27a783          	lw	a5,-542(a5) # 80008810 <first.1662>
    80001a36:	eb89                	bnez	a5,80001a48 <forkret+0x32>
  usertrapret();
    80001a38:	00001097          	auipc	ra,0x1
    80001a3c:	c16080e7          	jalr	-1002(ra) # 8000264e <usertrapret>
}
    80001a40:	60a2                	ld	ra,8(sp)
    80001a42:	6402                	ld	s0,0(sp)
    80001a44:	0141                	addi	sp,sp,16
    80001a46:	8082                	ret
    first = 0;
    80001a48:	00007797          	auipc	a5,0x7
    80001a4c:	dc07a423          	sw	zero,-568(a5) # 80008810 <first.1662>
    fsinit(ROOTDEV);
    80001a50:	4505                	li	a0,1
    80001a52:	00002097          	auipc	ra,0x2
    80001a56:	93e080e7          	jalr	-1730(ra) # 80003390 <fsinit>
    80001a5a:	bff9                	j	80001a38 <forkret+0x22>

0000000080001a5c <allocpid>:
allocpid() {
    80001a5c:	1101                	addi	sp,sp,-32
    80001a5e:	ec06                	sd	ra,24(sp)
    80001a60:	e822                	sd	s0,16(sp)
    80001a62:	e426                	sd	s1,8(sp)
    80001a64:	e04a                	sd	s2,0(sp)
    80001a66:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001a68:	00010917          	auipc	s2,0x10
    80001a6c:	ee890913          	addi	s2,s2,-280 # 80011950 <pid_lock>
    80001a70:	854a                	mv	a0,s2
    80001a72:	fffff097          	auipc	ra,0xfffff
    80001a76:	19e080e7          	jalr	414(ra) # 80000c10 <acquire>
  pid = nextpid;
    80001a7a:	00007797          	auipc	a5,0x7
    80001a7e:	d9a78793          	addi	a5,a5,-614 # 80008814 <nextpid>
    80001a82:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001a84:	0014871b          	addiw	a4,s1,1
    80001a88:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001a8a:	854a                	mv	a0,s2
    80001a8c:	fffff097          	auipc	ra,0xfffff
    80001a90:	238080e7          	jalr	568(ra) # 80000cc4 <release>
}
    80001a94:	8526                	mv	a0,s1
    80001a96:	60e2                	ld	ra,24(sp)
    80001a98:	6442                	ld	s0,16(sp)
    80001a9a:	64a2                	ld	s1,8(sp)
    80001a9c:	6902                	ld	s2,0(sp)
    80001a9e:	6105                	addi	sp,sp,32
    80001aa0:	8082                	ret

0000000080001aa2 <proc_pagetable>:
{
    80001aa2:	1101                	addi	sp,sp,-32
    80001aa4:	ec06                	sd	ra,24(sp)
    80001aa6:	e822                	sd	s0,16(sp)
    80001aa8:	e426                	sd	s1,8(sp)
    80001aaa:	e04a                	sd	s2,0(sp)
    80001aac:	1000                	addi	s0,sp,32
    80001aae:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001ab0:	00000097          	auipc	ra,0x0
    80001ab4:	8ea080e7          	jalr	-1814(ra) # 8000139a <uvmcreate>
    80001ab8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001aba:	c121                	beqz	a0,80001afa <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001abc:	4729                	li	a4,10
    80001abe:	00005697          	auipc	a3,0x5
    80001ac2:	54268693          	addi	a3,a3,1346 # 80007000 <_trampoline>
    80001ac6:	6605                	lui	a2,0x1
    80001ac8:	040005b7          	lui	a1,0x4000
    80001acc:	15fd                	addi	a1,a1,-1
    80001ace:	05b2                	slli	a1,a1,0xc
    80001ad0:	fffff097          	auipc	ra,0xfffff
    80001ad4:	66e080e7          	jalr	1646(ra) # 8000113e <mappages>
    80001ad8:	02054863          	bltz	a0,80001b08 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001adc:	4719                	li	a4,6
    80001ade:	05893683          	ld	a3,88(s2)
    80001ae2:	6605                	lui	a2,0x1
    80001ae4:	020005b7          	lui	a1,0x2000
    80001ae8:	15fd                	addi	a1,a1,-1
    80001aea:	05b6                	slli	a1,a1,0xd
    80001aec:	8526                	mv	a0,s1
    80001aee:	fffff097          	auipc	ra,0xfffff
    80001af2:	650080e7          	jalr	1616(ra) # 8000113e <mappages>
    80001af6:	02054163          	bltz	a0,80001b18 <proc_pagetable+0x76>
}
    80001afa:	8526                	mv	a0,s1
    80001afc:	60e2                	ld	ra,24(sp)
    80001afe:	6442                	ld	s0,16(sp)
    80001b00:	64a2                	ld	s1,8(sp)
    80001b02:	6902                	ld	s2,0(sp)
    80001b04:	6105                	addi	sp,sp,32
    80001b06:	8082                	ret
    uvmfree(pagetable, 0);
    80001b08:	4581                	li	a1,0
    80001b0a:	8526                	mv	a0,s1
    80001b0c:	00000097          	auipc	ra,0x0
    80001b10:	a8a080e7          	jalr	-1398(ra) # 80001596 <uvmfree>
    return 0;
    80001b14:	4481                	li	s1,0
    80001b16:	b7d5                	j	80001afa <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b18:	4681                	li	a3,0
    80001b1a:	4605                	li	a2,1
    80001b1c:	040005b7          	lui	a1,0x4000
    80001b20:	15fd                	addi	a1,a1,-1
    80001b22:	05b2                	slli	a1,a1,0xc
    80001b24:	8526                	mv	a0,s1
    80001b26:	fffff097          	auipc	ra,0xfffff
    80001b2a:	7b0080e7          	jalr	1968(ra) # 800012d6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001b2e:	4581                	li	a1,0
    80001b30:	8526                	mv	a0,s1
    80001b32:	00000097          	auipc	ra,0x0
    80001b36:	a64080e7          	jalr	-1436(ra) # 80001596 <uvmfree>
    return 0;
    80001b3a:	4481                	li	s1,0
    80001b3c:	bf7d                	j	80001afa <proc_pagetable+0x58>

0000000080001b3e <proc_freepagetable>:
{
    80001b3e:	1101                	addi	sp,sp,-32
    80001b40:	ec06                	sd	ra,24(sp)
    80001b42:	e822                	sd	s0,16(sp)
    80001b44:	e426                	sd	s1,8(sp)
    80001b46:	e04a                	sd	s2,0(sp)
    80001b48:	1000                	addi	s0,sp,32
    80001b4a:	84aa                	mv	s1,a0
    80001b4c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001b4e:	4681                	li	a3,0
    80001b50:	4605                	li	a2,1
    80001b52:	040005b7          	lui	a1,0x4000
    80001b56:	15fd                	addi	a1,a1,-1
    80001b58:	05b2                	slli	a1,a1,0xc
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	77c080e7          	jalr	1916(ra) # 800012d6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001b62:	4681                	li	a3,0
    80001b64:	4605                	li	a2,1
    80001b66:	020005b7          	lui	a1,0x2000
    80001b6a:	15fd                	addi	a1,a1,-1
    80001b6c:	05b6                	slli	a1,a1,0xd
    80001b6e:	8526                	mv	a0,s1
    80001b70:	fffff097          	auipc	ra,0xfffff
    80001b74:	766080e7          	jalr	1894(ra) # 800012d6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001b78:	85ca                	mv	a1,s2
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	00000097          	auipc	ra,0x0
    80001b80:	a1a080e7          	jalr	-1510(ra) # 80001596 <uvmfree>
}
    80001b84:	60e2                	ld	ra,24(sp)
    80001b86:	6442                	ld	s0,16(sp)
    80001b88:	64a2                	ld	s1,8(sp)
    80001b8a:	6902                	ld	s2,0(sp)
    80001b8c:	6105                	addi	sp,sp,32
    80001b8e:	8082                	ret

0000000080001b90 <freeproc>:
{
    80001b90:	1101                	addi	sp,sp,-32
    80001b92:	ec06                	sd	ra,24(sp)
    80001b94:	e822                	sd	s0,16(sp)
    80001b96:	e426                	sd	s1,8(sp)
    80001b98:	1000                	addi	s0,sp,32
    80001b9a:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001b9c:	6d28                	ld	a0,88(a0)
    80001b9e:	c509                	beqz	a0,80001ba8 <freeproc+0x18>
    kfree((void*)p->trapframe);
    80001ba0:	fffff097          	auipc	ra,0xfffff
    80001ba4:	e84080e7          	jalr	-380(ra) # 80000a24 <kfree>
  p->trapframe = 0;
    80001ba8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001bac:	68a8                	ld	a0,80(s1)
    80001bae:	c511                	beqz	a0,80001bba <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001bb0:	64ac                	ld	a1,72(s1)
    80001bb2:	00000097          	auipc	ra,0x0
    80001bb6:	f8c080e7          	jalr	-116(ra) # 80001b3e <proc_freepagetable>
  p->pagetable = 0;
    80001bba:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001bbe:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001bc2:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001bc6:	0204b023          	sd	zero,32(s1)
  p->name[0] = 0;
    80001bca:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001bce:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    80001bd2:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001bd6:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001bda:	0004ac23          	sw	zero,24(s1)
}
    80001bde:	60e2                	ld	ra,24(sp)
    80001be0:	6442                	ld	s0,16(sp)
    80001be2:	64a2                	ld	s1,8(sp)
    80001be4:	6105                	addi	sp,sp,32
    80001be6:	8082                	ret

0000000080001be8 <allocproc>:
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	e04a                	sd	s2,0(sp)
    80001bf2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bf4:	00010497          	auipc	s1,0x10
    80001bf8:	17448493          	addi	s1,s1,372 # 80011d68 <proc>
    80001bfc:	00016917          	auipc	s2,0x16
    80001c00:	b6c90913          	addi	s2,s2,-1172 # 80017768 <tickslock>
    acquire(&p->lock);
    80001c04:	8526                	mv	a0,s1
    80001c06:	fffff097          	auipc	ra,0xfffff
    80001c0a:	00a080e7          	jalr	10(ra) # 80000c10 <acquire>
    if(p->state == UNUSED) {
    80001c0e:	4c9c                	lw	a5,24(s1)
    80001c10:	cf81                	beqz	a5,80001c28 <allocproc+0x40>
      release(&p->lock);
    80001c12:	8526                	mv	a0,s1
    80001c14:	fffff097          	auipc	ra,0xfffff
    80001c18:	0b0080e7          	jalr	176(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c1c:	16848493          	addi	s1,s1,360
    80001c20:	ff2492e3          	bne	s1,s2,80001c04 <allocproc+0x1c>
  return 0;
    80001c24:	4481                	li	s1,0
    80001c26:	a0b9                	j	80001c74 <allocproc+0x8c>
  p->pid = allocpid();
    80001c28:	00000097          	auipc	ra,0x0
    80001c2c:	e34080e7          	jalr	-460(ra) # 80001a5c <allocpid>
    80001c30:	dc88                	sw	a0,56(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001c32:	fffff097          	auipc	ra,0xfffff
    80001c36:	eee080e7          	jalr	-274(ra) # 80000b20 <kalloc>
    80001c3a:	892a                	mv	s2,a0
    80001c3c:	eca8                	sd	a0,88(s1)
    80001c3e:	c131                	beqz	a0,80001c82 <allocproc+0x9a>
  p->pagetable = proc_pagetable(p);
    80001c40:	8526                	mv	a0,s1
    80001c42:	00000097          	auipc	ra,0x0
    80001c46:	e60080e7          	jalr	-416(ra) # 80001aa2 <proc_pagetable>
    80001c4a:	892a                	mv	s2,a0
    80001c4c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001c4e:	c129                	beqz	a0,80001c90 <allocproc+0xa8>
  memset(&p->context, 0, sizeof(p->context));
    80001c50:	07000613          	li	a2,112
    80001c54:	4581                	li	a1,0
    80001c56:	06048513          	addi	a0,s1,96
    80001c5a:	fffff097          	auipc	ra,0xfffff
    80001c5e:	0b2080e7          	jalr	178(ra) # 80000d0c <memset>
  p->context.ra = (uint64)forkret;
    80001c62:	00000797          	auipc	a5,0x0
    80001c66:	db478793          	addi	a5,a5,-588 # 80001a16 <forkret>
    80001c6a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001c6c:	60bc                	ld	a5,64(s1)
    80001c6e:	6705                	lui	a4,0x1
    80001c70:	97ba                	add	a5,a5,a4
    80001c72:	f4bc                	sd	a5,104(s1)
}
    80001c74:	8526                	mv	a0,s1
    80001c76:	60e2                	ld	ra,24(sp)
    80001c78:	6442                	ld	s0,16(sp)
    80001c7a:	64a2                	ld	s1,8(sp)
    80001c7c:	6902                	ld	s2,0(sp)
    80001c7e:	6105                	addi	sp,sp,32
    80001c80:	8082                	ret
    release(&p->lock);
    80001c82:	8526                	mv	a0,s1
    80001c84:	fffff097          	auipc	ra,0xfffff
    80001c88:	040080e7          	jalr	64(ra) # 80000cc4 <release>
    return 0;
    80001c8c:	84ca                	mv	s1,s2
    80001c8e:	b7dd                	j	80001c74 <allocproc+0x8c>
    freeproc(p);
    80001c90:	8526                	mv	a0,s1
    80001c92:	00000097          	auipc	ra,0x0
    80001c96:	efe080e7          	jalr	-258(ra) # 80001b90 <freeproc>
    release(&p->lock);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	fffff097          	auipc	ra,0xfffff
    80001ca0:	028080e7          	jalr	40(ra) # 80000cc4 <release>
    return 0;
    80001ca4:	84ca                	mv	s1,s2
    80001ca6:	b7f9                	j	80001c74 <allocproc+0x8c>

0000000080001ca8 <userinit>:
{
    80001ca8:	1101                	addi	sp,sp,-32
    80001caa:	ec06                	sd	ra,24(sp)
    80001cac:	e822                	sd	s0,16(sp)
    80001cae:	e426                	sd	s1,8(sp)
    80001cb0:	1000                	addi	s0,sp,32
  p = allocproc();
    80001cb2:	00000097          	auipc	ra,0x0
    80001cb6:	f36080e7          	jalr	-202(ra) # 80001be8 <allocproc>
    80001cba:	84aa                	mv	s1,a0
  initproc = p;
    80001cbc:	00007797          	auipc	a5,0x7
    80001cc0:	34a7be23          	sd	a0,860(a5) # 80009018 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001cc4:	03400613          	li	a2,52
    80001cc8:	00007597          	auipc	a1,0x7
    80001ccc:	b5858593          	addi	a1,a1,-1192 # 80008820 <initcode>
    80001cd0:	6928                	ld	a0,80(a0)
    80001cd2:	fffff097          	auipc	ra,0xfffff
    80001cd6:	6f6080e7          	jalr	1782(ra) # 800013c8 <uvminit>
  p->sz = PGSIZE;
    80001cda:	6785                	lui	a5,0x1
    80001cdc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001cde:	6cb8                	ld	a4,88(s1)
    80001ce0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ce4:	6cb8                	ld	a4,88(s1)
    80001ce6:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001ce8:	4641                	li	a2,16
    80001cea:	00006597          	auipc	a1,0x6
    80001cee:	4fe58593          	addi	a1,a1,1278 # 800081e8 <digits+0x1a8>
    80001cf2:	15848513          	addi	a0,s1,344
    80001cf6:	fffff097          	auipc	ra,0xfffff
    80001cfa:	16c080e7          	jalr	364(ra) # 80000e62 <safestrcpy>
  p->cwd = namei("/");
    80001cfe:	00006517          	auipc	a0,0x6
    80001d02:	4fa50513          	addi	a0,a0,1274 # 800081f8 <digits+0x1b8>
    80001d06:	00002097          	auipc	ra,0x2
    80001d0a:	0b2080e7          	jalr	178(ra) # 80003db8 <namei>
    80001d0e:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d12:	4789                	li	a5,2
    80001d14:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d16:	8526                	mv	a0,s1
    80001d18:	fffff097          	auipc	ra,0xfffff
    80001d1c:	fac080e7          	jalr	-84(ra) # 80000cc4 <release>
}
    80001d20:	60e2                	ld	ra,24(sp)
    80001d22:	6442                	ld	s0,16(sp)
    80001d24:	64a2                	ld	s1,8(sp)
    80001d26:	6105                	addi	sp,sp,32
    80001d28:	8082                	ret

0000000080001d2a <growproc>:
{
    80001d2a:	1101                	addi	sp,sp,-32
    80001d2c:	ec06                	sd	ra,24(sp)
    80001d2e:	e822                	sd	s0,16(sp)
    80001d30:	e426                	sd	s1,8(sp)
    80001d32:	e04a                	sd	s2,0(sp)
    80001d34:	1000                	addi	s0,sp,32
    80001d36:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001d38:	00000097          	auipc	ra,0x0
    80001d3c:	ca6080e7          	jalr	-858(ra) # 800019de <myproc>
    80001d40:	892a                	mv	s2,a0
  sz = p->sz;
    80001d42:	652c                	ld	a1,72(a0)
    80001d44:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001d48:	00904f63          	bgtz	s1,80001d66 <growproc+0x3c>
  } else if(n < 0){
    80001d4c:	0204cc63          	bltz	s1,80001d84 <growproc+0x5a>
  p->sz = sz;
    80001d50:	1602                	slli	a2,a2,0x20
    80001d52:	9201                	srli	a2,a2,0x20
    80001d54:	04c93423          	sd	a2,72(s2)
  return 0;
    80001d58:	4501                	li	a0,0
}
    80001d5a:	60e2                	ld	ra,24(sp)
    80001d5c:	6442                	ld	s0,16(sp)
    80001d5e:	64a2                	ld	s1,8(sp)
    80001d60:	6902                	ld	s2,0(sp)
    80001d62:	6105                	addi	sp,sp,32
    80001d64:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001d66:	9e25                	addw	a2,a2,s1
    80001d68:	1602                	slli	a2,a2,0x20
    80001d6a:	9201                	srli	a2,a2,0x20
    80001d6c:	1582                	slli	a1,a1,0x20
    80001d6e:	9181                	srli	a1,a1,0x20
    80001d70:	6928                	ld	a0,80(a0)
    80001d72:	fffff097          	auipc	ra,0xfffff
    80001d76:	710080e7          	jalr	1808(ra) # 80001482 <uvmalloc>
    80001d7a:	0005061b          	sext.w	a2,a0
    80001d7e:	fa69                	bnez	a2,80001d50 <growproc+0x26>
      return -1;
    80001d80:	557d                	li	a0,-1
    80001d82:	bfe1                	j	80001d5a <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001d84:	9e25                	addw	a2,a2,s1
    80001d86:	1602                	slli	a2,a2,0x20
    80001d88:	9201                	srli	a2,a2,0x20
    80001d8a:	1582                	slli	a1,a1,0x20
    80001d8c:	9181                	srli	a1,a1,0x20
    80001d8e:	6928                	ld	a0,80(a0)
    80001d90:	fffff097          	auipc	ra,0xfffff
    80001d94:	6aa080e7          	jalr	1706(ra) # 8000143a <uvmdealloc>
    80001d98:	0005061b          	sext.w	a2,a0
    80001d9c:	bf55                	j	80001d50 <growproc+0x26>

0000000080001d9e <fork>:
{
    80001d9e:	7179                	addi	sp,sp,-48
    80001da0:	f406                	sd	ra,40(sp)
    80001da2:	f022                	sd	s0,32(sp)
    80001da4:	ec26                	sd	s1,24(sp)
    80001da6:	e84a                	sd	s2,16(sp)
    80001da8:	e44e                	sd	s3,8(sp)
    80001daa:	e052                	sd	s4,0(sp)
    80001dac:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001dae:	00000097          	auipc	ra,0x0
    80001db2:	c30080e7          	jalr	-976(ra) # 800019de <myproc>
    80001db6:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001db8:	00000097          	auipc	ra,0x0
    80001dbc:	e30080e7          	jalr	-464(ra) # 80001be8 <allocproc>
    80001dc0:	c175                	beqz	a0,80001ea4 <fork+0x106>
    80001dc2:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001dc4:	04893603          	ld	a2,72(s2)
    80001dc8:	692c                	ld	a1,80(a0)
    80001dca:	05093503          	ld	a0,80(s2)
    80001dce:	00000097          	auipc	ra,0x0
    80001dd2:	800080e7          	jalr	-2048(ra) # 800015ce <uvmcopy>
    80001dd6:	04054863          	bltz	a0,80001e26 <fork+0x88>
  np->sz = p->sz;
    80001dda:	04893783          	ld	a5,72(s2)
    80001dde:	04f9b423          	sd	a5,72(s3) # 4000048 <_entry-0x7bffffb8>
  np->parent = p;
    80001de2:	0329b023          	sd	s2,32(s3)
  *(np->trapframe) = *(p->trapframe);
    80001de6:	05893683          	ld	a3,88(s2)
    80001dea:	87b6                	mv	a5,a3
    80001dec:	0589b703          	ld	a4,88(s3)
    80001df0:	12068693          	addi	a3,a3,288
    80001df4:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001df8:	6788                	ld	a0,8(a5)
    80001dfa:	6b8c                	ld	a1,16(a5)
    80001dfc:	6f90                	ld	a2,24(a5)
    80001dfe:	01073023          	sd	a6,0(a4)
    80001e02:	e708                	sd	a0,8(a4)
    80001e04:	eb0c                	sd	a1,16(a4)
    80001e06:	ef10                	sd	a2,24(a4)
    80001e08:	02078793          	addi	a5,a5,32
    80001e0c:	02070713          	addi	a4,a4,32
    80001e10:	fed792e3          	bne	a5,a3,80001df4 <fork+0x56>
  np->trapframe->a0 = 0;
    80001e14:	0589b783          	ld	a5,88(s3)
    80001e18:	0607b823          	sd	zero,112(a5)
    80001e1c:	0d000493          	li	s1,208
  for(i = 0; i < NOFILE; i++)
    80001e20:	15000a13          	li	s4,336
    80001e24:	a03d                	j	80001e52 <fork+0xb4>
    freeproc(np);
    80001e26:	854e                	mv	a0,s3
    80001e28:	00000097          	auipc	ra,0x0
    80001e2c:	d68080e7          	jalr	-664(ra) # 80001b90 <freeproc>
    release(&np->lock);
    80001e30:	854e                	mv	a0,s3
    80001e32:	fffff097          	auipc	ra,0xfffff
    80001e36:	e92080e7          	jalr	-366(ra) # 80000cc4 <release>
    return -1;
    80001e3a:	54fd                	li	s1,-1
    80001e3c:	a899                	j	80001e92 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e3e:	00002097          	auipc	ra,0x2
    80001e42:	606080e7          	jalr	1542(ra) # 80004444 <filedup>
    80001e46:	009987b3          	add	a5,s3,s1
    80001e4a:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001e4c:	04a1                	addi	s1,s1,8
    80001e4e:	01448763          	beq	s1,s4,80001e5c <fork+0xbe>
    if(p->ofile[i])
    80001e52:	009907b3          	add	a5,s2,s1
    80001e56:	6388                	ld	a0,0(a5)
    80001e58:	f17d                	bnez	a0,80001e3e <fork+0xa0>
    80001e5a:	bfcd                	j	80001e4c <fork+0xae>
  np->cwd = idup(p->cwd);
    80001e5c:	15093503          	ld	a0,336(s2)
    80001e60:	00001097          	auipc	ra,0x1
    80001e64:	76a080e7          	jalr	1898(ra) # 800035ca <idup>
    80001e68:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001e6c:	4641                	li	a2,16
    80001e6e:	15890593          	addi	a1,s2,344
    80001e72:	15898513          	addi	a0,s3,344
    80001e76:	fffff097          	auipc	ra,0xfffff
    80001e7a:	fec080e7          	jalr	-20(ra) # 80000e62 <safestrcpy>
  pid = np->pid;
    80001e7e:	0389a483          	lw	s1,56(s3)
  np->state = RUNNABLE;
    80001e82:	4789                	li	a5,2
    80001e84:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001e88:	854e                	mv	a0,s3
    80001e8a:	fffff097          	auipc	ra,0xfffff
    80001e8e:	e3a080e7          	jalr	-454(ra) # 80000cc4 <release>
}
    80001e92:	8526                	mv	a0,s1
    80001e94:	70a2                	ld	ra,40(sp)
    80001e96:	7402                	ld	s0,32(sp)
    80001e98:	64e2                	ld	s1,24(sp)
    80001e9a:	6942                	ld	s2,16(sp)
    80001e9c:	69a2                	ld	s3,8(sp)
    80001e9e:	6a02                	ld	s4,0(sp)
    80001ea0:	6145                	addi	sp,sp,48
    80001ea2:	8082                	ret
    return -1;
    80001ea4:	54fd                	li	s1,-1
    80001ea6:	b7f5                	j	80001e92 <fork+0xf4>

0000000080001ea8 <reparent>:
{
    80001ea8:	7179                	addi	sp,sp,-48
    80001eaa:	f406                	sd	ra,40(sp)
    80001eac:	f022                	sd	s0,32(sp)
    80001eae:	ec26                	sd	s1,24(sp)
    80001eb0:	e84a                	sd	s2,16(sp)
    80001eb2:	e44e                	sd	s3,8(sp)
    80001eb4:	e052                	sd	s4,0(sp)
    80001eb6:	1800                	addi	s0,sp,48
    80001eb8:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001eba:	00010497          	auipc	s1,0x10
    80001ebe:	eae48493          	addi	s1,s1,-338 # 80011d68 <proc>
      pp->parent = initproc;
    80001ec2:	00007a17          	auipc	s4,0x7
    80001ec6:	156a0a13          	addi	s4,s4,342 # 80009018 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001eca:	00016997          	auipc	s3,0x16
    80001ece:	89e98993          	addi	s3,s3,-1890 # 80017768 <tickslock>
    80001ed2:	a029                	j	80001edc <reparent+0x34>
    80001ed4:	16848493          	addi	s1,s1,360
    80001ed8:	03348363          	beq	s1,s3,80001efe <reparent+0x56>
    if(pp->parent == p){
    80001edc:	709c                	ld	a5,32(s1)
    80001ede:	ff279be3          	bne	a5,s2,80001ed4 <reparent+0x2c>
      acquire(&pp->lock);
    80001ee2:	8526                	mv	a0,s1
    80001ee4:	fffff097          	auipc	ra,0xfffff
    80001ee8:	d2c080e7          	jalr	-724(ra) # 80000c10 <acquire>
      pp->parent = initproc;
    80001eec:	000a3783          	ld	a5,0(s4)
    80001ef0:	f09c                	sd	a5,32(s1)
      release(&pp->lock);
    80001ef2:	8526                	mv	a0,s1
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	dd0080e7          	jalr	-560(ra) # 80000cc4 <release>
    80001efc:	bfe1                	j	80001ed4 <reparent+0x2c>
}
    80001efe:	70a2                	ld	ra,40(sp)
    80001f00:	7402                	ld	s0,32(sp)
    80001f02:	64e2                	ld	s1,24(sp)
    80001f04:	6942                	ld	s2,16(sp)
    80001f06:	69a2                	ld	s3,8(sp)
    80001f08:	6a02                	ld	s4,0(sp)
    80001f0a:	6145                	addi	sp,sp,48
    80001f0c:	8082                	ret

0000000080001f0e <scheduler>:
{
    80001f0e:	715d                	addi	sp,sp,-80
    80001f10:	e486                	sd	ra,72(sp)
    80001f12:	e0a2                	sd	s0,64(sp)
    80001f14:	fc26                	sd	s1,56(sp)
    80001f16:	f84a                	sd	s2,48(sp)
    80001f18:	f44e                	sd	s3,40(sp)
    80001f1a:	f052                	sd	s4,32(sp)
    80001f1c:	ec56                	sd	s5,24(sp)
    80001f1e:	e85a                	sd	s6,16(sp)
    80001f20:	e45e                	sd	s7,8(sp)
    80001f22:	e062                	sd	s8,0(sp)
    80001f24:	0880                	addi	s0,sp,80
    80001f26:	8792                	mv	a5,tp
  int id = r_tp();
    80001f28:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f2a:	00779b13          	slli	s6,a5,0x7
    80001f2e:	00010717          	auipc	a4,0x10
    80001f32:	a2270713          	addi	a4,a4,-1502 # 80011950 <pid_lock>
    80001f36:	975a                	add	a4,a4,s6
    80001f38:	00073c23          	sd	zero,24(a4)
        swtch(&c->context, &p->context);
    80001f3c:	00010717          	auipc	a4,0x10
    80001f40:	a3470713          	addi	a4,a4,-1484 # 80011970 <cpus+0x8>
    80001f44:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f46:	4c0d                	li	s8,3
        c->proc = p;
    80001f48:	079e                	slli	a5,a5,0x7
    80001f4a:	00010a17          	auipc	s4,0x10
    80001f4e:	a06a0a13          	addi	s4,s4,-1530 # 80011950 <pid_lock>
    80001f52:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f54:	00016997          	auipc	s3,0x16
    80001f58:	81498993          	addi	s3,s3,-2028 # 80017768 <tickslock>
        found = 1;
    80001f5c:	4b85                	li	s7,1
    80001f5e:	a899                	j	80001fb4 <scheduler+0xa6>
        p->state = RUNNING;
    80001f60:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001f64:	009a3c23          	sd	s1,24(s4)
        swtch(&c->context, &p->context);
    80001f68:	06048593          	addi	a1,s1,96
    80001f6c:	855a                	mv	a0,s6
    80001f6e:	00000097          	auipc	ra,0x0
    80001f72:	636080e7          	jalr	1590(ra) # 800025a4 <swtch>
        c->proc = 0;
    80001f76:	000a3c23          	sd	zero,24(s4)
        found = 1;
    80001f7a:	8ade                	mv	s5,s7
      release(&p->lock);
    80001f7c:	8526                	mv	a0,s1
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	d46080e7          	jalr	-698(ra) # 80000cc4 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f86:	16848493          	addi	s1,s1,360
    80001f8a:	01348b63          	beq	s1,s3,80001fa0 <scheduler+0x92>
      acquire(&p->lock);
    80001f8e:	8526                	mv	a0,s1
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	c80080e7          	jalr	-896(ra) # 80000c10 <acquire>
      if(p->state == RUNNABLE) {
    80001f98:	4c9c                	lw	a5,24(s1)
    80001f9a:	ff2791e3          	bne	a5,s2,80001f7c <scheduler+0x6e>
    80001f9e:	b7c9                	j	80001f60 <scheduler+0x52>
    if(found == 0) {
    80001fa0:	000a9a63          	bnez	s5,80001fb4 <scheduler+0xa6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fa4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fa8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fac:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001fb0:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fb4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001fb8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001fbc:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001fc0:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fc2:	00010497          	auipc	s1,0x10
    80001fc6:	da648493          	addi	s1,s1,-602 # 80011d68 <proc>
      if(p->state == RUNNABLE) {
    80001fca:	4909                	li	s2,2
    80001fcc:	b7c9                	j	80001f8e <scheduler+0x80>

0000000080001fce <sched>:
{
    80001fce:	7179                	addi	sp,sp,-48
    80001fd0:	f406                	sd	ra,40(sp)
    80001fd2:	f022                	sd	s0,32(sp)
    80001fd4:	ec26                	sd	s1,24(sp)
    80001fd6:	e84a                	sd	s2,16(sp)
    80001fd8:	e44e                	sd	s3,8(sp)
    80001fda:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fdc:	00000097          	auipc	ra,0x0
    80001fe0:	a02080e7          	jalr	-1534(ra) # 800019de <myproc>
    80001fe4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	bb0080e7          	jalr	-1104(ra) # 80000b96 <holding>
    80001fee:	c93d                	beqz	a0,80002064 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ff0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ff2:	2781                	sext.w	a5,a5
    80001ff4:	079e                	slli	a5,a5,0x7
    80001ff6:	00010717          	auipc	a4,0x10
    80001ffa:	95a70713          	addi	a4,a4,-1702 # 80011950 <pid_lock>
    80001ffe:	97ba                	add	a5,a5,a4
    80002000:	0907a703          	lw	a4,144(a5)
    80002004:	4785                	li	a5,1
    80002006:	06f71763          	bne	a4,a5,80002074 <sched+0xa6>
  if(p->state == RUNNING)
    8000200a:	4c98                	lw	a4,24(s1)
    8000200c:	478d                	li	a5,3
    8000200e:	06f70b63          	beq	a4,a5,80002084 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002012:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002016:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002018:	efb5                	bnez	a5,80002094 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000201a:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000201c:	00010917          	auipc	s2,0x10
    80002020:	93490913          	addi	s2,s2,-1740 # 80011950 <pid_lock>
    80002024:	2781                	sext.w	a5,a5
    80002026:	079e                	slli	a5,a5,0x7
    80002028:	97ca                	add	a5,a5,s2
    8000202a:	0947a983          	lw	s3,148(a5)
    8000202e:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002030:	2781                	sext.w	a5,a5
    80002032:	079e                	slli	a5,a5,0x7
    80002034:	00010597          	auipc	a1,0x10
    80002038:	93c58593          	addi	a1,a1,-1732 # 80011970 <cpus+0x8>
    8000203c:	95be                	add	a1,a1,a5
    8000203e:	06048513          	addi	a0,s1,96
    80002042:	00000097          	auipc	ra,0x0
    80002046:	562080e7          	jalr	1378(ra) # 800025a4 <swtch>
    8000204a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000204c:	2781                	sext.w	a5,a5
    8000204e:	079e                	slli	a5,a5,0x7
    80002050:	97ca                	add	a5,a5,s2
    80002052:	0937aa23          	sw	s3,148(a5)
}
    80002056:	70a2                	ld	ra,40(sp)
    80002058:	7402                	ld	s0,32(sp)
    8000205a:	64e2                	ld	s1,24(sp)
    8000205c:	6942                	ld	s2,16(sp)
    8000205e:	69a2                	ld	s3,8(sp)
    80002060:	6145                	addi	sp,sp,48
    80002062:	8082                	ret
    panic("sched p->lock");
    80002064:	00006517          	auipc	a0,0x6
    80002068:	19c50513          	addi	a0,a0,412 # 80008200 <digits+0x1c0>
    8000206c:	ffffe097          	auipc	ra,0xffffe
    80002070:	4dc080e7          	jalr	1244(ra) # 80000548 <panic>
    panic("sched locks");
    80002074:	00006517          	auipc	a0,0x6
    80002078:	19c50513          	addi	a0,a0,412 # 80008210 <digits+0x1d0>
    8000207c:	ffffe097          	auipc	ra,0xffffe
    80002080:	4cc080e7          	jalr	1228(ra) # 80000548 <panic>
    panic("sched running");
    80002084:	00006517          	auipc	a0,0x6
    80002088:	19c50513          	addi	a0,a0,412 # 80008220 <digits+0x1e0>
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	4bc080e7          	jalr	1212(ra) # 80000548 <panic>
    panic("sched interruptible");
    80002094:	00006517          	auipc	a0,0x6
    80002098:	19c50513          	addi	a0,a0,412 # 80008230 <digits+0x1f0>
    8000209c:	ffffe097          	auipc	ra,0xffffe
    800020a0:	4ac080e7          	jalr	1196(ra) # 80000548 <panic>

00000000800020a4 <exit>:
{
    800020a4:	7179                	addi	sp,sp,-48
    800020a6:	f406                	sd	ra,40(sp)
    800020a8:	f022                	sd	s0,32(sp)
    800020aa:	ec26                	sd	s1,24(sp)
    800020ac:	e84a                	sd	s2,16(sp)
    800020ae:	e44e                	sd	s3,8(sp)
    800020b0:	e052                	sd	s4,0(sp)
    800020b2:	1800                	addi	s0,sp,48
    800020b4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800020b6:	00000097          	auipc	ra,0x0
    800020ba:	928080e7          	jalr	-1752(ra) # 800019de <myproc>
    800020be:	89aa                	mv	s3,a0
  if(p == initproc)
    800020c0:	00007797          	auipc	a5,0x7
    800020c4:	f587b783          	ld	a5,-168(a5) # 80009018 <initproc>
    800020c8:	0d050493          	addi	s1,a0,208
    800020cc:	15050913          	addi	s2,a0,336
    800020d0:	02a79363          	bne	a5,a0,800020f6 <exit+0x52>
    panic("init exiting");
    800020d4:	00006517          	auipc	a0,0x6
    800020d8:	17450513          	addi	a0,a0,372 # 80008248 <digits+0x208>
    800020dc:	ffffe097          	auipc	ra,0xffffe
    800020e0:	46c080e7          	jalr	1132(ra) # 80000548 <panic>
      fileclose(f);
    800020e4:	00002097          	auipc	ra,0x2
    800020e8:	3b2080e7          	jalr	946(ra) # 80004496 <fileclose>
      p->ofile[fd] = 0;
    800020ec:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800020f0:	04a1                	addi	s1,s1,8
    800020f2:	01248563          	beq	s1,s2,800020fc <exit+0x58>
    if(p->ofile[fd]){
    800020f6:	6088                	ld	a0,0(s1)
    800020f8:	f575                	bnez	a0,800020e4 <exit+0x40>
    800020fa:	bfdd                	j	800020f0 <exit+0x4c>
  begin_op();
    800020fc:	00002097          	auipc	ra,0x2
    80002100:	ec8080e7          	jalr	-312(ra) # 80003fc4 <begin_op>
  iput(p->cwd);
    80002104:	1509b503          	ld	a0,336(s3)
    80002108:	00001097          	auipc	ra,0x1
    8000210c:	6ba080e7          	jalr	1722(ra) # 800037c2 <iput>
  end_op();
    80002110:	00002097          	auipc	ra,0x2
    80002114:	f34080e7          	jalr	-204(ra) # 80004044 <end_op>
  p->cwd = 0;
    80002118:	1409b823          	sd	zero,336(s3)
  acquire(&initproc->lock);
    8000211c:	00007497          	auipc	s1,0x7
    80002120:	efc48493          	addi	s1,s1,-260 # 80009018 <initproc>
    80002124:	6088                	ld	a0,0(s1)
    80002126:	fffff097          	auipc	ra,0xfffff
    8000212a:	aea080e7          	jalr	-1302(ra) # 80000c10 <acquire>
  wakeup1(initproc);
    8000212e:	6088                	ld	a0,0(s1)
    80002130:	fffff097          	auipc	ra,0xfffff
    80002134:	76e080e7          	jalr	1902(ra) # 8000189e <wakeup1>
  release(&initproc->lock);
    80002138:	6088                	ld	a0,0(s1)
    8000213a:	fffff097          	auipc	ra,0xfffff
    8000213e:	b8a080e7          	jalr	-1142(ra) # 80000cc4 <release>
  acquire(&p->lock);
    80002142:	854e                	mv	a0,s3
    80002144:	fffff097          	auipc	ra,0xfffff
    80002148:	acc080e7          	jalr	-1332(ra) # 80000c10 <acquire>
  struct proc *original_parent = p->parent;
    8000214c:	0209b483          	ld	s1,32(s3)
  release(&p->lock);
    80002150:	854e                	mv	a0,s3
    80002152:	fffff097          	auipc	ra,0xfffff
    80002156:	b72080e7          	jalr	-1166(ra) # 80000cc4 <release>
  acquire(&original_parent->lock);
    8000215a:	8526                	mv	a0,s1
    8000215c:	fffff097          	auipc	ra,0xfffff
    80002160:	ab4080e7          	jalr	-1356(ra) # 80000c10 <acquire>
  acquire(&p->lock);
    80002164:	854e                	mv	a0,s3
    80002166:	fffff097          	auipc	ra,0xfffff
    8000216a:	aaa080e7          	jalr	-1366(ra) # 80000c10 <acquire>
  reparent(p);
    8000216e:	854e                	mv	a0,s3
    80002170:	00000097          	auipc	ra,0x0
    80002174:	d38080e7          	jalr	-712(ra) # 80001ea8 <reparent>
  wakeup1(original_parent);
    80002178:	8526                	mv	a0,s1
    8000217a:	fffff097          	auipc	ra,0xfffff
    8000217e:	724080e7          	jalr	1828(ra) # 8000189e <wakeup1>
  p->xstate = status;
    80002182:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    80002186:	4791                	li	a5,4
    80002188:	00f9ac23          	sw	a5,24(s3)
  release(&original_parent->lock);
    8000218c:	8526                	mv	a0,s1
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	b36080e7          	jalr	-1226(ra) # 80000cc4 <release>
  sched();
    80002196:	00000097          	auipc	ra,0x0
    8000219a:	e38080e7          	jalr	-456(ra) # 80001fce <sched>
  panic("zombie exit");
    8000219e:	00006517          	auipc	a0,0x6
    800021a2:	0ba50513          	addi	a0,a0,186 # 80008258 <digits+0x218>
    800021a6:	ffffe097          	auipc	ra,0xffffe
    800021aa:	3a2080e7          	jalr	930(ra) # 80000548 <panic>

00000000800021ae <yield>:
{
    800021ae:	1101                	addi	sp,sp,-32
    800021b0:	ec06                	sd	ra,24(sp)
    800021b2:	e822                	sd	s0,16(sp)
    800021b4:	e426                	sd	s1,8(sp)
    800021b6:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800021b8:	00000097          	auipc	ra,0x0
    800021bc:	826080e7          	jalr	-2010(ra) # 800019de <myproc>
    800021c0:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	a4e080e7          	jalr	-1458(ra) # 80000c10 <acquire>
  p->state = RUNNABLE;
    800021ca:	4789                	li	a5,2
    800021cc:	cc9c                	sw	a5,24(s1)
  sched();
    800021ce:	00000097          	auipc	ra,0x0
    800021d2:	e00080e7          	jalr	-512(ra) # 80001fce <sched>
  release(&p->lock);
    800021d6:	8526                	mv	a0,s1
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	aec080e7          	jalr	-1300(ra) # 80000cc4 <release>
}
    800021e0:	60e2                	ld	ra,24(sp)
    800021e2:	6442                	ld	s0,16(sp)
    800021e4:	64a2                	ld	s1,8(sp)
    800021e6:	6105                	addi	sp,sp,32
    800021e8:	8082                	ret

00000000800021ea <sleep>:
{
    800021ea:	7179                	addi	sp,sp,-48
    800021ec:	f406                	sd	ra,40(sp)
    800021ee:	f022                	sd	s0,32(sp)
    800021f0:	ec26                	sd	s1,24(sp)
    800021f2:	e84a                	sd	s2,16(sp)
    800021f4:	e44e                	sd	s3,8(sp)
    800021f6:	1800                	addi	s0,sp,48
    800021f8:	89aa                	mv	s3,a0
    800021fa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	7e2080e7          	jalr	2018(ra) # 800019de <myproc>
    80002204:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    80002206:	05250663          	beq	a0,s2,80002252 <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	a06080e7          	jalr	-1530(ra) # 80000c10 <acquire>
    release(lk);
    80002212:	854a                	mv	a0,s2
    80002214:	fffff097          	auipc	ra,0xfffff
    80002218:	ab0080e7          	jalr	-1360(ra) # 80000cc4 <release>
  p->chan = chan;
    8000221c:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    80002220:	4785                	li	a5,1
    80002222:	cc9c                	sw	a5,24(s1)
  sched();
    80002224:	00000097          	auipc	ra,0x0
    80002228:	daa080e7          	jalr	-598(ra) # 80001fce <sched>
  p->chan = 0;
    8000222c:	0204b423          	sd	zero,40(s1)
    release(&p->lock);
    80002230:	8526                	mv	a0,s1
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	a92080e7          	jalr	-1390(ra) # 80000cc4 <release>
    acquire(lk);
    8000223a:	854a                	mv	a0,s2
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	9d4080e7          	jalr	-1580(ra) # 80000c10 <acquire>
}
    80002244:	70a2                	ld	ra,40(sp)
    80002246:	7402                	ld	s0,32(sp)
    80002248:	64e2                	ld	s1,24(sp)
    8000224a:	6942                	ld	s2,16(sp)
    8000224c:	69a2                	ld	s3,8(sp)
    8000224e:	6145                	addi	sp,sp,48
    80002250:	8082                	ret
  p->chan = chan;
    80002252:	03353423          	sd	s3,40(a0)
  p->state = SLEEPING;
    80002256:	4785                	li	a5,1
    80002258:	cd1c                	sw	a5,24(a0)
  sched();
    8000225a:	00000097          	auipc	ra,0x0
    8000225e:	d74080e7          	jalr	-652(ra) # 80001fce <sched>
  p->chan = 0;
    80002262:	0204b423          	sd	zero,40(s1)
  if(lk != &p->lock){
    80002266:	bff9                	j	80002244 <sleep+0x5a>

0000000080002268 <wait>:
{
    80002268:	715d                	addi	sp,sp,-80
    8000226a:	e486                	sd	ra,72(sp)
    8000226c:	e0a2                	sd	s0,64(sp)
    8000226e:	fc26                	sd	s1,56(sp)
    80002270:	f84a                	sd	s2,48(sp)
    80002272:	f44e                	sd	s3,40(sp)
    80002274:	f052                	sd	s4,32(sp)
    80002276:	ec56                	sd	s5,24(sp)
    80002278:	e85a                	sd	s6,16(sp)
    8000227a:	e45e                	sd	s7,8(sp)
    8000227c:	e062                	sd	s8,0(sp)
    8000227e:	0880                	addi	s0,sp,80
    80002280:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002282:	fffff097          	auipc	ra,0xfffff
    80002286:	75c080e7          	jalr	1884(ra) # 800019de <myproc>
    8000228a:	892a                	mv	s2,a0
  acquire(&p->lock);
    8000228c:	8c2a                	mv	s8,a0
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	982080e7          	jalr	-1662(ra) # 80000c10 <acquire>
    havekids = 0;
    80002296:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    80002298:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    8000229a:	00015997          	auipc	s3,0x15
    8000229e:	4ce98993          	addi	s3,s3,1230 # 80017768 <tickslock>
        havekids = 1;
    800022a2:	4a85                	li	s5,1
    havekids = 0;
    800022a4:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800022a6:	00010497          	auipc	s1,0x10
    800022aa:	ac248493          	addi	s1,s1,-1342 # 80011d68 <proc>
    800022ae:	a08d                	j	80002310 <wait+0xa8>
          pid = np->pid;
    800022b0:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800022b4:	000b0e63          	beqz	s6,800022d0 <wait+0x68>
    800022b8:	4691                	li	a3,4
    800022ba:	03448613          	addi	a2,s1,52
    800022be:	85da                	mv	a1,s6
    800022c0:	05093503          	ld	a0,80(s2)
    800022c4:	fffff097          	auipc	ra,0xfffff
    800022c8:	40e080e7          	jalr	1038(ra) # 800016d2 <copyout>
    800022cc:	02054263          	bltz	a0,800022f0 <wait+0x88>
          freeproc(np);
    800022d0:	8526                	mv	a0,s1
    800022d2:	00000097          	auipc	ra,0x0
    800022d6:	8be080e7          	jalr	-1858(ra) # 80001b90 <freeproc>
          release(&np->lock);
    800022da:	8526                	mv	a0,s1
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	9e8080e7          	jalr	-1560(ra) # 80000cc4 <release>
          release(&p->lock);
    800022e4:	854a                	mv	a0,s2
    800022e6:	fffff097          	auipc	ra,0xfffff
    800022ea:	9de080e7          	jalr	-1570(ra) # 80000cc4 <release>
          return pid;
    800022ee:	a8a9                	j	80002348 <wait+0xe0>
            release(&np->lock);
    800022f0:	8526                	mv	a0,s1
    800022f2:	fffff097          	auipc	ra,0xfffff
    800022f6:	9d2080e7          	jalr	-1582(ra) # 80000cc4 <release>
            release(&p->lock);
    800022fa:	854a                	mv	a0,s2
    800022fc:	fffff097          	auipc	ra,0xfffff
    80002300:	9c8080e7          	jalr	-1592(ra) # 80000cc4 <release>
            return -1;
    80002304:	59fd                	li	s3,-1
    80002306:	a089                	j	80002348 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002308:	16848493          	addi	s1,s1,360
    8000230c:	03348463          	beq	s1,s3,80002334 <wait+0xcc>
      if(np->parent == p){
    80002310:	709c                	ld	a5,32(s1)
    80002312:	ff279be3          	bne	a5,s2,80002308 <wait+0xa0>
        acquire(&np->lock);
    80002316:	8526                	mv	a0,s1
    80002318:	fffff097          	auipc	ra,0xfffff
    8000231c:	8f8080e7          	jalr	-1800(ra) # 80000c10 <acquire>
        if(np->state == ZOMBIE){
    80002320:	4c9c                	lw	a5,24(s1)
    80002322:	f94787e3          	beq	a5,s4,800022b0 <wait+0x48>
        release(&np->lock);
    80002326:	8526                	mv	a0,s1
    80002328:	fffff097          	auipc	ra,0xfffff
    8000232c:	99c080e7          	jalr	-1636(ra) # 80000cc4 <release>
        havekids = 1;
    80002330:	8756                	mv	a4,s5
    80002332:	bfd9                	j	80002308 <wait+0xa0>
    if(!havekids || p->killed){
    80002334:	c701                	beqz	a4,8000233c <wait+0xd4>
    80002336:	03092783          	lw	a5,48(s2)
    8000233a:	c785                	beqz	a5,80002362 <wait+0xfa>
      release(&p->lock);
    8000233c:	854a                	mv	a0,s2
    8000233e:	fffff097          	auipc	ra,0xfffff
    80002342:	986080e7          	jalr	-1658(ra) # 80000cc4 <release>
      return -1;
    80002346:	59fd                	li	s3,-1
}
    80002348:	854e                	mv	a0,s3
    8000234a:	60a6                	ld	ra,72(sp)
    8000234c:	6406                	ld	s0,64(sp)
    8000234e:	74e2                	ld	s1,56(sp)
    80002350:	7942                	ld	s2,48(sp)
    80002352:	79a2                	ld	s3,40(sp)
    80002354:	7a02                	ld	s4,32(sp)
    80002356:	6ae2                	ld	s5,24(sp)
    80002358:	6b42                	ld	s6,16(sp)
    8000235a:	6ba2                	ld	s7,8(sp)
    8000235c:	6c02                	ld	s8,0(sp)
    8000235e:	6161                	addi	sp,sp,80
    80002360:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    80002362:	85e2                	mv	a1,s8
    80002364:	854a                	mv	a0,s2
    80002366:	00000097          	auipc	ra,0x0
    8000236a:	e84080e7          	jalr	-380(ra) # 800021ea <sleep>
    havekids = 0;
    8000236e:	bf1d                	j	800022a4 <wait+0x3c>

0000000080002370 <wakeup>:
{
    80002370:	7139                	addi	sp,sp,-64
    80002372:	fc06                	sd	ra,56(sp)
    80002374:	f822                	sd	s0,48(sp)
    80002376:	f426                	sd	s1,40(sp)
    80002378:	f04a                	sd	s2,32(sp)
    8000237a:	ec4e                	sd	s3,24(sp)
    8000237c:	e852                	sd	s4,16(sp)
    8000237e:	e456                	sd	s5,8(sp)
    80002380:	0080                	addi	s0,sp,64
    80002382:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80002384:	00010497          	auipc	s1,0x10
    80002388:	9e448493          	addi	s1,s1,-1564 # 80011d68 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    8000238c:	4985                	li	s3,1
      p->state = RUNNABLE;
    8000238e:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002390:	00015917          	auipc	s2,0x15
    80002394:	3d890913          	addi	s2,s2,984 # 80017768 <tickslock>
    80002398:	a821                	j	800023b0 <wakeup+0x40>
      p->state = RUNNABLE;
    8000239a:	0154ac23          	sw	s5,24(s1)
    release(&p->lock);
    8000239e:	8526                	mv	a0,s1
    800023a0:	fffff097          	auipc	ra,0xfffff
    800023a4:	924080e7          	jalr	-1756(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800023a8:	16848493          	addi	s1,s1,360
    800023ac:	01248e63          	beq	s1,s2,800023c8 <wakeup+0x58>
    acquire(&p->lock);
    800023b0:	8526                	mv	a0,s1
    800023b2:	fffff097          	auipc	ra,0xfffff
    800023b6:	85e080e7          	jalr	-1954(ra) # 80000c10 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800023ba:	4c9c                	lw	a5,24(s1)
    800023bc:	ff3791e3          	bne	a5,s3,8000239e <wakeup+0x2e>
    800023c0:	749c                	ld	a5,40(s1)
    800023c2:	fd479ee3          	bne	a5,s4,8000239e <wakeup+0x2e>
    800023c6:	bfd1                	j	8000239a <wakeup+0x2a>
}
    800023c8:	70e2                	ld	ra,56(sp)
    800023ca:	7442                	ld	s0,48(sp)
    800023cc:	74a2                	ld	s1,40(sp)
    800023ce:	7902                	ld	s2,32(sp)
    800023d0:	69e2                	ld	s3,24(sp)
    800023d2:	6a42                	ld	s4,16(sp)
    800023d4:	6aa2                	ld	s5,8(sp)
    800023d6:	6121                	addi	sp,sp,64
    800023d8:	8082                	ret

00000000800023da <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800023da:	7179                	addi	sp,sp,-48
    800023dc:	f406                	sd	ra,40(sp)
    800023de:	f022                	sd	s0,32(sp)
    800023e0:	ec26                	sd	s1,24(sp)
    800023e2:	e84a                	sd	s2,16(sp)
    800023e4:	e44e                	sd	s3,8(sp)
    800023e6:	1800                	addi	s0,sp,48
    800023e8:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800023ea:	00010497          	auipc	s1,0x10
    800023ee:	97e48493          	addi	s1,s1,-1666 # 80011d68 <proc>
    800023f2:	00015997          	auipc	s3,0x15
    800023f6:	37698993          	addi	s3,s3,886 # 80017768 <tickslock>
    acquire(&p->lock);
    800023fa:	8526                	mv	a0,s1
    800023fc:	fffff097          	auipc	ra,0xfffff
    80002400:	814080e7          	jalr	-2028(ra) # 80000c10 <acquire>
    if(p->pid == pid){
    80002404:	5c9c                	lw	a5,56(s1)
    80002406:	01278d63          	beq	a5,s2,80002420 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000240a:	8526                	mv	a0,s1
    8000240c:	fffff097          	auipc	ra,0xfffff
    80002410:	8b8080e7          	jalr	-1864(ra) # 80000cc4 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002414:	16848493          	addi	s1,s1,360
    80002418:	ff3491e3          	bne	s1,s3,800023fa <kill+0x20>
  }
  return -1;
    8000241c:	557d                	li	a0,-1
    8000241e:	a821                	j	80002436 <kill+0x5c>
      p->killed = 1;
    80002420:	4785                	li	a5,1
    80002422:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    80002424:	4c98                	lw	a4,24(s1)
    80002426:	00f70f63          	beq	a4,a5,80002444 <kill+0x6a>
      release(&p->lock);
    8000242a:	8526                	mv	a0,s1
    8000242c:	fffff097          	auipc	ra,0xfffff
    80002430:	898080e7          	jalr	-1896(ra) # 80000cc4 <release>
      return 0;
    80002434:	4501                	li	a0,0
}
    80002436:	70a2                	ld	ra,40(sp)
    80002438:	7402                	ld	s0,32(sp)
    8000243a:	64e2                	ld	s1,24(sp)
    8000243c:	6942                	ld	s2,16(sp)
    8000243e:	69a2                	ld	s3,8(sp)
    80002440:	6145                	addi	sp,sp,48
    80002442:	8082                	ret
        p->state = RUNNABLE;
    80002444:	4789                	li	a5,2
    80002446:	cc9c                	sw	a5,24(s1)
    80002448:	b7cd                	j	8000242a <kill+0x50>

000000008000244a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000244a:	7179                	addi	sp,sp,-48
    8000244c:	f406                	sd	ra,40(sp)
    8000244e:	f022                	sd	s0,32(sp)
    80002450:	ec26                	sd	s1,24(sp)
    80002452:	e84a                	sd	s2,16(sp)
    80002454:	e44e                	sd	s3,8(sp)
    80002456:	e052                	sd	s4,0(sp)
    80002458:	1800                	addi	s0,sp,48
    8000245a:	84aa                	mv	s1,a0
    8000245c:	892e                	mv	s2,a1
    8000245e:	89b2                	mv	s3,a2
    80002460:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002462:	fffff097          	auipc	ra,0xfffff
    80002466:	57c080e7          	jalr	1404(ra) # 800019de <myproc>
  if(user_dst){
    8000246a:	c08d                	beqz	s1,8000248c <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    8000246c:	86d2                	mv	a3,s4
    8000246e:	864e                	mv	a2,s3
    80002470:	85ca                	mv	a1,s2
    80002472:	6928                	ld	a0,80(a0)
    80002474:	fffff097          	auipc	ra,0xfffff
    80002478:	25e080e7          	jalr	606(ra) # 800016d2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000247c:	70a2                	ld	ra,40(sp)
    8000247e:	7402                	ld	s0,32(sp)
    80002480:	64e2                	ld	s1,24(sp)
    80002482:	6942                	ld	s2,16(sp)
    80002484:	69a2                	ld	s3,8(sp)
    80002486:	6a02                	ld	s4,0(sp)
    80002488:	6145                	addi	sp,sp,48
    8000248a:	8082                	ret
    memmove((char *)dst, src, len);
    8000248c:	000a061b          	sext.w	a2,s4
    80002490:	85ce                	mv	a1,s3
    80002492:	854a                	mv	a0,s2
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	8d8080e7          	jalr	-1832(ra) # 80000d6c <memmove>
    return 0;
    8000249c:	8526                	mv	a0,s1
    8000249e:	bff9                	j	8000247c <either_copyout+0x32>

00000000800024a0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800024a0:	7179                	addi	sp,sp,-48
    800024a2:	f406                	sd	ra,40(sp)
    800024a4:	f022                	sd	s0,32(sp)
    800024a6:	ec26                	sd	s1,24(sp)
    800024a8:	e84a                	sd	s2,16(sp)
    800024aa:	e44e                	sd	s3,8(sp)
    800024ac:	e052                	sd	s4,0(sp)
    800024ae:	1800                	addi	s0,sp,48
    800024b0:	892a                	mv	s2,a0
    800024b2:	84ae                	mv	s1,a1
    800024b4:	89b2                	mv	s3,a2
    800024b6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800024b8:	fffff097          	auipc	ra,0xfffff
    800024bc:	526080e7          	jalr	1318(ra) # 800019de <myproc>
  if(user_src){
    800024c0:	c08d                	beqz	s1,800024e2 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800024c2:	86d2                	mv	a3,s4
    800024c4:	864e                	mv	a2,s3
    800024c6:	85ca                	mv	a1,s2
    800024c8:	6928                	ld	a0,80(a0)
    800024ca:	fffff097          	auipc	ra,0xfffff
    800024ce:	294080e7          	jalr	660(ra) # 8000175e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800024d2:	70a2                	ld	ra,40(sp)
    800024d4:	7402                	ld	s0,32(sp)
    800024d6:	64e2                	ld	s1,24(sp)
    800024d8:	6942                	ld	s2,16(sp)
    800024da:	69a2                	ld	s3,8(sp)
    800024dc:	6a02                	ld	s4,0(sp)
    800024de:	6145                	addi	sp,sp,48
    800024e0:	8082                	ret
    memmove(dst, (char*)src, len);
    800024e2:	000a061b          	sext.w	a2,s4
    800024e6:	85ce                	mv	a1,s3
    800024e8:	854a                	mv	a0,s2
    800024ea:	fffff097          	auipc	ra,0xfffff
    800024ee:	882080e7          	jalr	-1918(ra) # 80000d6c <memmove>
    return 0;
    800024f2:	8526                	mv	a0,s1
    800024f4:	bff9                	j	800024d2 <either_copyin+0x32>

00000000800024f6 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800024f6:	715d                	addi	sp,sp,-80
    800024f8:	e486                	sd	ra,72(sp)
    800024fa:	e0a2                	sd	s0,64(sp)
    800024fc:	fc26                	sd	s1,56(sp)
    800024fe:	f84a                	sd	s2,48(sp)
    80002500:	f44e                	sd	s3,40(sp)
    80002502:	f052                	sd	s4,32(sp)
    80002504:	ec56                	sd	s5,24(sp)
    80002506:	e85a                	sd	s6,16(sp)
    80002508:	e45e                	sd	s7,8(sp)
    8000250a:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000250c:	00006517          	auipc	a0,0x6
    80002510:	bbc50513          	addi	a0,a0,-1092 # 800080c8 <digits+0x88>
    80002514:	ffffe097          	auipc	ra,0xffffe
    80002518:	07e080e7          	jalr	126(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000251c:	00010497          	auipc	s1,0x10
    80002520:	9a448493          	addi	s1,s1,-1628 # 80011ec0 <proc+0x158>
    80002524:	00015917          	auipc	s2,0x15
    80002528:	39c90913          	addi	s2,s2,924 # 800178c0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000252c:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    8000252e:	00006997          	auipc	s3,0x6
    80002532:	d3a98993          	addi	s3,s3,-710 # 80008268 <digits+0x228>
    printf("%d %s %s", p->pid, state, p->name);
    80002536:	00006a97          	auipc	s5,0x6
    8000253a:	d3aa8a93          	addi	s5,s5,-710 # 80008270 <digits+0x230>
    printf("\n");
    8000253e:	00006a17          	auipc	s4,0x6
    80002542:	b8aa0a13          	addi	s4,s4,-1142 # 800080c8 <digits+0x88>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002546:	00006b97          	auipc	s7,0x6
    8000254a:	d62b8b93          	addi	s7,s7,-670 # 800082a8 <states.1702>
    8000254e:	a00d                	j	80002570 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002550:	ee06a583          	lw	a1,-288(a3)
    80002554:	8556                	mv	a0,s5
    80002556:	ffffe097          	auipc	ra,0xffffe
    8000255a:	03c080e7          	jalr	60(ra) # 80000592 <printf>
    printf("\n");
    8000255e:	8552                	mv	a0,s4
    80002560:	ffffe097          	auipc	ra,0xffffe
    80002564:	032080e7          	jalr	50(ra) # 80000592 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002568:	16848493          	addi	s1,s1,360
    8000256c:	03248163          	beq	s1,s2,8000258e <procdump+0x98>
    if(p->state == UNUSED)
    80002570:	86a6                	mv	a3,s1
    80002572:	ec04a783          	lw	a5,-320(s1)
    80002576:	dbed                	beqz	a5,80002568 <procdump+0x72>
      state = "???";
    80002578:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000257a:	fcfb6be3          	bltu	s6,a5,80002550 <procdump+0x5a>
    8000257e:	1782                	slli	a5,a5,0x20
    80002580:	9381                	srli	a5,a5,0x20
    80002582:	078e                	slli	a5,a5,0x3
    80002584:	97de                	add	a5,a5,s7
    80002586:	6390                	ld	a2,0(a5)
    80002588:	f661                	bnez	a2,80002550 <procdump+0x5a>
      state = "???";
    8000258a:	864e                	mv	a2,s3
    8000258c:	b7d1                	j	80002550 <procdump+0x5a>
  }
}
    8000258e:	60a6                	ld	ra,72(sp)
    80002590:	6406                	ld	s0,64(sp)
    80002592:	74e2                	ld	s1,56(sp)
    80002594:	7942                	ld	s2,48(sp)
    80002596:	79a2                	ld	s3,40(sp)
    80002598:	7a02                	ld	s4,32(sp)
    8000259a:	6ae2                	ld	s5,24(sp)
    8000259c:	6b42                	ld	s6,16(sp)
    8000259e:	6ba2                	ld	s7,8(sp)
    800025a0:	6161                	addi	sp,sp,80
    800025a2:	8082                	ret

00000000800025a4 <swtch>:
    800025a4:	00153023          	sd	ra,0(a0)
    800025a8:	00253423          	sd	sp,8(a0)
    800025ac:	e900                	sd	s0,16(a0)
    800025ae:	ed04                	sd	s1,24(a0)
    800025b0:	03253023          	sd	s2,32(a0)
    800025b4:	03353423          	sd	s3,40(a0)
    800025b8:	03453823          	sd	s4,48(a0)
    800025bc:	03553c23          	sd	s5,56(a0)
    800025c0:	05653023          	sd	s6,64(a0)
    800025c4:	05753423          	sd	s7,72(a0)
    800025c8:	05853823          	sd	s8,80(a0)
    800025cc:	05953c23          	sd	s9,88(a0)
    800025d0:	07a53023          	sd	s10,96(a0)
    800025d4:	07b53423          	sd	s11,104(a0)
    800025d8:	0005b083          	ld	ra,0(a1)
    800025dc:	0085b103          	ld	sp,8(a1)
    800025e0:	6980                	ld	s0,16(a1)
    800025e2:	6d84                	ld	s1,24(a1)
    800025e4:	0205b903          	ld	s2,32(a1)
    800025e8:	0285b983          	ld	s3,40(a1)
    800025ec:	0305ba03          	ld	s4,48(a1)
    800025f0:	0385ba83          	ld	s5,56(a1)
    800025f4:	0405bb03          	ld	s6,64(a1)
    800025f8:	0485bb83          	ld	s7,72(a1)
    800025fc:	0505bc03          	ld	s8,80(a1)
    80002600:	0585bc83          	ld	s9,88(a1)
    80002604:	0605bd03          	ld	s10,96(a1)
    80002608:	0685bd83          	ld	s11,104(a1)
    8000260c:	8082                	ret

000000008000260e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000260e:	1141                	addi	sp,sp,-16
    80002610:	e406                	sd	ra,8(sp)
    80002612:	e022                	sd	s0,0(sp)
    80002614:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002616:	00006597          	auipc	a1,0x6
    8000261a:	cba58593          	addi	a1,a1,-838 # 800082d0 <states.1702+0x28>
    8000261e:	00015517          	auipc	a0,0x15
    80002622:	14a50513          	addi	a0,a0,330 # 80017768 <tickslock>
    80002626:	ffffe097          	auipc	ra,0xffffe
    8000262a:	55a080e7          	jalr	1370(ra) # 80000b80 <initlock>
}
    8000262e:	60a2                	ld	ra,8(sp)
    80002630:	6402                	ld	s0,0(sp)
    80002632:	0141                	addi	sp,sp,16
    80002634:	8082                	ret

0000000080002636 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002636:	1141                	addi	sp,sp,-16
    80002638:	e422                	sd	s0,8(sp)
    8000263a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000263c:	00003797          	auipc	a5,0x3
    80002640:	4c478793          	addi	a5,a5,1220 # 80005b00 <kernelvec>
    80002644:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002648:	6422                	ld	s0,8(sp)
    8000264a:	0141                	addi	sp,sp,16
    8000264c:	8082                	ret

000000008000264e <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000264e:	1141                	addi	sp,sp,-16
    80002650:	e406                	sd	ra,8(sp)
    80002652:	e022                	sd	s0,0(sp)
    80002654:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002656:	fffff097          	auipc	ra,0xfffff
    8000265a:	388080e7          	jalr	904(ra) # 800019de <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000265e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002662:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002664:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80002668:	00005617          	auipc	a2,0x5
    8000266c:	99860613          	addi	a2,a2,-1640 # 80007000 <_trampoline>
    80002670:	00005697          	auipc	a3,0x5
    80002674:	99068693          	addi	a3,a3,-1648 # 80007000 <_trampoline>
    80002678:	8e91                	sub	a3,a3,a2
    8000267a:	040007b7          	lui	a5,0x4000
    8000267e:	17fd                	addi	a5,a5,-1
    80002680:	07b2                	slli	a5,a5,0xc
    80002682:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002684:	10569073          	csrw	stvec,a3

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002688:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000268a:	180026f3          	csrr	a3,satp
    8000268e:	e314                	sd	a3,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002690:	6d38                	ld	a4,88(a0)
    80002692:	6134                	ld	a3,64(a0)
    80002694:	6585                	lui	a1,0x1
    80002696:	96ae                	add	a3,a3,a1
    80002698:	e714                	sd	a3,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000269a:	6d38                	ld	a4,88(a0)
    8000269c:	00000697          	auipc	a3,0x0
    800026a0:	13868693          	addi	a3,a3,312 # 800027d4 <usertrap>
    800026a4:	eb14                	sd	a3,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800026a6:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800026a8:	8692                	mv	a3,tp
    800026aa:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800026ac:	100026f3          	csrr	a3,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800026b0:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800026b4:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800026b8:	10069073          	csrw	sstatus,a3
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800026bc:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800026be:	6f18                	ld	a4,24(a4)
    800026c0:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800026c4:	692c                	ld	a1,80(a0)
    800026c6:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    800026c8:	00005717          	auipc	a4,0x5
    800026cc:	9c870713          	addi	a4,a4,-1592 # 80007090 <userret>
    800026d0:	8f11                	sub	a4,a4,a2
    800026d2:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    800026d4:	577d                	li	a4,-1
    800026d6:	177e                	slli	a4,a4,0x3f
    800026d8:	8dd9                	or	a1,a1,a4
    800026da:	02000537          	lui	a0,0x2000
    800026de:	157d                	addi	a0,a0,-1
    800026e0:	0536                	slli	a0,a0,0xd
    800026e2:	9782                	jalr	a5
}
    800026e4:	60a2                	ld	ra,8(sp)
    800026e6:	6402                	ld	s0,0(sp)
    800026e8:	0141                	addi	sp,sp,16
    800026ea:	8082                	ret

00000000800026ec <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800026ec:	1101                	addi	sp,sp,-32
    800026ee:	ec06                	sd	ra,24(sp)
    800026f0:	e822                	sd	s0,16(sp)
    800026f2:	e426                	sd	s1,8(sp)
    800026f4:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    800026f6:	00015497          	auipc	s1,0x15
    800026fa:	07248493          	addi	s1,s1,114 # 80017768 <tickslock>
    800026fe:	8526                	mv	a0,s1
    80002700:	ffffe097          	auipc	ra,0xffffe
    80002704:	510080e7          	jalr	1296(ra) # 80000c10 <acquire>
  ticks++;
    80002708:	00007517          	auipc	a0,0x7
    8000270c:	91850513          	addi	a0,a0,-1768 # 80009020 <ticks>
    80002710:	411c                	lw	a5,0(a0)
    80002712:	2785                	addiw	a5,a5,1
    80002714:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80002716:	00000097          	auipc	ra,0x0
    8000271a:	c5a080e7          	jalr	-934(ra) # 80002370 <wakeup>
  release(&tickslock);
    8000271e:	8526                	mv	a0,s1
    80002720:	ffffe097          	auipc	ra,0xffffe
    80002724:	5a4080e7          	jalr	1444(ra) # 80000cc4 <release>
}
    80002728:	60e2                	ld	ra,24(sp)
    8000272a:	6442                	ld	s0,16(sp)
    8000272c:	64a2                	ld	s1,8(sp)
    8000272e:	6105                	addi	sp,sp,32
    80002730:	8082                	ret

0000000080002732 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002732:	1101                	addi	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000273c:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if((scause & 0x8000000000000000L) &&
    80002740:	00074d63          	bltz	a4,8000275a <devintr+0x28>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000001L){
    80002744:	57fd                	li	a5,-1
    80002746:	17fe                	slli	a5,a5,0x3f
    80002748:	0785                	addi	a5,a5,1
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    8000274a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    8000274c:	06f70363          	beq	a4,a5,800027b2 <devintr+0x80>
  }
}
    80002750:	60e2                	ld	ra,24(sp)
    80002752:	6442                	ld	s0,16(sp)
    80002754:	64a2                	ld	s1,8(sp)
    80002756:	6105                	addi	sp,sp,32
    80002758:	8082                	ret
     (scause & 0xff) == 9){
    8000275a:	0ff77793          	andi	a5,a4,255
  if((scause & 0x8000000000000000L) &&
    8000275e:	46a5                	li	a3,9
    80002760:	fed792e3          	bne	a5,a3,80002744 <devintr+0x12>
    int irq = plic_claim();
    80002764:	00003097          	auipc	ra,0x3
    80002768:	4a4080e7          	jalr	1188(ra) # 80005c08 <plic_claim>
    8000276c:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    8000276e:	47a9                	li	a5,10
    80002770:	02f50763          	beq	a0,a5,8000279e <devintr+0x6c>
    } else if(irq == VIRTIO0_IRQ){
    80002774:	4785                	li	a5,1
    80002776:	02f50963          	beq	a0,a5,800027a8 <devintr+0x76>
    return 1;
    8000277a:	4505                	li	a0,1
    } else if(irq){
    8000277c:	d8f1                	beqz	s1,80002750 <devintr+0x1e>
      printf("unexpected interrupt irq=%d\n", irq);
    8000277e:	85a6                	mv	a1,s1
    80002780:	00006517          	auipc	a0,0x6
    80002784:	b5850513          	addi	a0,a0,-1192 # 800082d8 <states.1702+0x30>
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	e0a080e7          	jalr	-502(ra) # 80000592 <printf>
      plic_complete(irq);
    80002790:	8526                	mv	a0,s1
    80002792:	00003097          	auipc	ra,0x3
    80002796:	49a080e7          	jalr	1178(ra) # 80005c2c <plic_complete>
    return 1;
    8000279a:	4505                	li	a0,1
    8000279c:	bf55                	j	80002750 <devintr+0x1e>
      uartintr();
    8000279e:	ffffe097          	auipc	ra,0xffffe
    800027a2:	236080e7          	jalr	566(ra) # 800009d4 <uartintr>
    800027a6:	b7ed                	j	80002790 <devintr+0x5e>
      virtio_disk_intr();
    800027a8:	00004097          	auipc	ra,0x4
    800027ac:	914080e7          	jalr	-1772(ra) # 800060bc <virtio_disk_intr>
    800027b0:	b7c5                	j	80002790 <devintr+0x5e>
    if(cpuid() == 0){
    800027b2:	fffff097          	auipc	ra,0xfffff
    800027b6:	200080e7          	jalr	512(ra) # 800019b2 <cpuid>
    800027ba:	c901                	beqz	a0,800027ca <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    800027bc:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    800027c0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    800027c2:	14479073          	csrw	sip,a5
    return 2;
    800027c6:	4509                	li	a0,2
    800027c8:	b761                	j	80002750 <devintr+0x1e>
      clockintr();
    800027ca:	00000097          	auipc	ra,0x0
    800027ce:	f22080e7          	jalr	-222(ra) # 800026ec <clockintr>
    800027d2:	b7ed                	j	800027bc <devintr+0x8a>

00000000800027d4 <usertrap>:
{
    800027d4:	1101                	addi	sp,sp,-32
    800027d6:	ec06                	sd	ra,24(sp)
    800027d8:	e822                	sd	s0,16(sp)
    800027da:	e426                	sd	s1,8(sp)
    800027dc:	e04a                	sd	s2,0(sp)
    800027de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027e0:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800027e4:	1007f793          	andi	a5,a5,256
    800027e8:	e3ad                	bnez	a5,8000284a <usertrap+0x76>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027ea:	00003797          	auipc	a5,0x3
    800027ee:	31678793          	addi	a5,a5,790 # 80005b00 <kernelvec>
    800027f2:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800027f6:	fffff097          	auipc	ra,0xfffff
    800027fa:	1e8080e7          	jalr	488(ra) # 800019de <myproc>
    800027fe:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002800:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002802:	14102773          	csrr	a4,sepc
    80002806:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002808:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000280c:	47a1                	li	a5,8
    8000280e:	04f71c63          	bne	a4,a5,80002866 <usertrap+0x92>
    if(p->killed)
    80002812:	591c                	lw	a5,48(a0)
    80002814:	e3b9                	bnez	a5,8000285a <usertrap+0x86>
    p->trapframe->epc += 4;
    80002816:	6cb8                	ld	a4,88(s1)
    80002818:	6f1c                	ld	a5,24(a4)
    8000281a:	0791                	addi	a5,a5,4
    8000281c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000281e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002822:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002826:	10079073          	csrw	sstatus,a5
    syscall();
    8000282a:	00000097          	auipc	ra,0x0
    8000282e:	2e0080e7          	jalr	736(ra) # 80002b0a <syscall>
  if(p->killed)
    80002832:	589c                	lw	a5,48(s1)
    80002834:	ebc1                	bnez	a5,800028c4 <usertrap+0xf0>
  usertrapret();
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	e18080e7          	jalr	-488(ra) # 8000264e <usertrapret>
}
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	64a2                	ld	s1,8(sp)
    80002844:	6902                	ld	s2,0(sp)
    80002846:	6105                	addi	sp,sp,32
    80002848:	8082                	ret
    panic("usertrap: not from user mode");
    8000284a:	00006517          	auipc	a0,0x6
    8000284e:	aae50513          	addi	a0,a0,-1362 # 800082f8 <states.1702+0x50>
    80002852:	ffffe097          	auipc	ra,0xffffe
    80002856:	cf6080e7          	jalr	-778(ra) # 80000548 <panic>
      exit(-1);
    8000285a:	557d                	li	a0,-1
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	848080e7          	jalr	-1976(ra) # 800020a4 <exit>
    80002864:	bf4d                	j	80002816 <usertrap+0x42>
  } else if((which_dev = devintr()) != 0){
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	ecc080e7          	jalr	-308(ra) # 80002732 <devintr>
    8000286e:	892a                	mv	s2,a0
    80002870:	c501                	beqz	a0,80002878 <usertrap+0xa4>
  if(p->killed)
    80002872:	589c                	lw	a5,48(s1)
    80002874:	c3a1                	beqz	a5,800028b4 <usertrap+0xe0>
    80002876:	a815                	j	800028aa <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002878:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    8000287c:	5c90                	lw	a2,56(s1)
    8000287e:	00006517          	auipc	a0,0x6
    80002882:	a9a50513          	addi	a0,a0,-1382 # 80008318 <states.1702+0x70>
    80002886:	ffffe097          	auipc	ra,0xffffe
    8000288a:	d0c080e7          	jalr	-756(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000288e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002892:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002896:	00006517          	auipc	a0,0x6
    8000289a:	ab250513          	addi	a0,a0,-1358 # 80008348 <states.1702+0xa0>
    8000289e:	ffffe097          	auipc	ra,0xffffe
    800028a2:	cf4080e7          	jalr	-780(ra) # 80000592 <printf>
    p->killed = 1;
    800028a6:	4785                	li	a5,1
    800028a8:	d89c                	sw	a5,48(s1)
    exit(-1);
    800028aa:	557d                	li	a0,-1
    800028ac:	fffff097          	auipc	ra,0xfffff
    800028b0:	7f8080e7          	jalr	2040(ra) # 800020a4 <exit>
  if(which_dev == 2)
    800028b4:	4789                	li	a5,2
    800028b6:	f8f910e3          	bne	s2,a5,80002836 <usertrap+0x62>
    yield();
    800028ba:	00000097          	auipc	ra,0x0
    800028be:	8f4080e7          	jalr	-1804(ra) # 800021ae <yield>
    800028c2:	bf95                	j	80002836 <usertrap+0x62>
  int which_dev = 0;
    800028c4:	4901                	li	s2,0
    800028c6:	b7d5                	j	800028aa <usertrap+0xd6>

00000000800028c8 <kerneltrap>:
{
    800028c8:	7179                	addi	sp,sp,-48
    800028ca:	f406                	sd	ra,40(sp)
    800028cc:	f022                	sd	s0,32(sp)
    800028ce:	ec26                	sd	s1,24(sp)
    800028d0:	e84a                	sd	s2,16(sp)
    800028d2:	e44e                	sd	s3,8(sp)
    800028d4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028d6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028da:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028de:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028e2:	1004f793          	andi	a5,s1,256
    800028e6:	cb85                	beqz	a5,80002916 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028e8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028ec:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028ee:	ef85                	bnez	a5,80002926 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    800028f0:	00000097          	auipc	ra,0x0
    800028f4:	e42080e7          	jalr	-446(ra) # 80002732 <devintr>
    800028f8:	cd1d                	beqz	a0,80002936 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800028fa:	4789                	li	a5,2
    800028fc:	06f50a63          	beq	a0,a5,80002970 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002900:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002904:	10049073          	csrw	sstatus,s1
}
    80002908:	70a2                	ld	ra,40(sp)
    8000290a:	7402                	ld	s0,32(sp)
    8000290c:	64e2                	ld	s1,24(sp)
    8000290e:	6942                	ld	s2,16(sp)
    80002910:	69a2                	ld	s3,8(sp)
    80002912:	6145                	addi	sp,sp,48
    80002914:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002916:	00006517          	auipc	a0,0x6
    8000291a:	a5250513          	addi	a0,a0,-1454 # 80008368 <states.1702+0xc0>
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	c2a080e7          	jalr	-982(ra) # 80000548 <panic>
    panic("kerneltrap: interrupts enabled");
    80002926:	00006517          	auipc	a0,0x6
    8000292a:	a6a50513          	addi	a0,a0,-1430 # 80008390 <states.1702+0xe8>
    8000292e:	ffffe097          	auipc	ra,0xffffe
    80002932:	c1a080e7          	jalr	-998(ra) # 80000548 <panic>
    printf("scause %p\n", scause);
    80002936:	85ce                	mv	a1,s3
    80002938:	00006517          	auipc	a0,0x6
    8000293c:	a7850513          	addi	a0,a0,-1416 # 800083b0 <states.1702+0x108>
    80002940:	ffffe097          	auipc	ra,0xffffe
    80002944:	c52080e7          	jalr	-942(ra) # 80000592 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002948:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000294c:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002950:	00006517          	auipc	a0,0x6
    80002954:	a7050513          	addi	a0,a0,-1424 # 800083c0 <states.1702+0x118>
    80002958:	ffffe097          	auipc	ra,0xffffe
    8000295c:	c3a080e7          	jalr	-966(ra) # 80000592 <printf>
    panic("kerneltrap");
    80002960:	00006517          	auipc	a0,0x6
    80002964:	a7850513          	addi	a0,a0,-1416 # 800083d8 <states.1702+0x130>
    80002968:	ffffe097          	auipc	ra,0xffffe
    8000296c:	be0080e7          	jalr	-1056(ra) # 80000548 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002970:	fffff097          	auipc	ra,0xfffff
    80002974:	06e080e7          	jalr	110(ra) # 800019de <myproc>
    80002978:	d541                	beqz	a0,80002900 <kerneltrap+0x38>
    8000297a:	fffff097          	auipc	ra,0xfffff
    8000297e:	064080e7          	jalr	100(ra) # 800019de <myproc>
    80002982:	4d18                	lw	a4,24(a0)
    80002984:	478d                	li	a5,3
    80002986:	f6f71de3          	bne	a4,a5,80002900 <kerneltrap+0x38>
    yield();
    8000298a:	00000097          	auipc	ra,0x0
    8000298e:	824080e7          	jalr	-2012(ra) # 800021ae <yield>
    80002992:	b7bd                	j	80002900 <kerneltrap+0x38>

0000000080002994 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002994:	1101                	addi	sp,sp,-32
    80002996:	ec06                	sd	ra,24(sp)
    80002998:	e822                	sd	s0,16(sp)
    8000299a:	e426                	sd	s1,8(sp)
    8000299c:	1000                	addi	s0,sp,32
    8000299e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800029a0:	fffff097          	auipc	ra,0xfffff
    800029a4:	03e080e7          	jalr	62(ra) # 800019de <myproc>
  switch (n) {
    800029a8:	4795                	li	a5,5
    800029aa:	0497e163          	bltu	a5,s1,800029ec <argraw+0x58>
    800029ae:	048a                	slli	s1,s1,0x2
    800029b0:	00006717          	auipc	a4,0x6
    800029b4:	a6070713          	addi	a4,a4,-1440 # 80008410 <states.1702+0x168>
    800029b8:	94ba                	add	s1,s1,a4
    800029ba:	409c                	lw	a5,0(s1)
    800029bc:	97ba                	add	a5,a5,a4
    800029be:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800029c0:	6d3c                	ld	a5,88(a0)
    800029c2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800029c4:	60e2                	ld	ra,24(sp)
    800029c6:	6442                	ld	s0,16(sp)
    800029c8:	64a2                	ld	s1,8(sp)
    800029ca:	6105                	addi	sp,sp,32
    800029cc:	8082                	ret
    return p->trapframe->a1;
    800029ce:	6d3c                	ld	a5,88(a0)
    800029d0:	7fa8                	ld	a0,120(a5)
    800029d2:	bfcd                	j	800029c4 <argraw+0x30>
    return p->trapframe->a2;
    800029d4:	6d3c                	ld	a5,88(a0)
    800029d6:	63c8                	ld	a0,128(a5)
    800029d8:	b7f5                	j	800029c4 <argraw+0x30>
    return p->trapframe->a3;
    800029da:	6d3c                	ld	a5,88(a0)
    800029dc:	67c8                	ld	a0,136(a5)
    800029de:	b7dd                	j	800029c4 <argraw+0x30>
    return p->trapframe->a4;
    800029e0:	6d3c                	ld	a5,88(a0)
    800029e2:	6bc8                	ld	a0,144(a5)
    800029e4:	b7c5                	j	800029c4 <argraw+0x30>
    return p->trapframe->a5;
    800029e6:	6d3c                	ld	a5,88(a0)
    800029e8:	6fc8                	ld	a0,152(a5)
    800029ea:	bfe9                	j	800029c4 <argraw+0x30>
  panic("argraw");
    800029ec:	00006517          	auipc	a0,0x6
    800029f0:	9fc50513          	addi	a0,a0,-1540 # 800083e8 <states.1702+0x140>
    800029f4:	ffffe097          	auipc	ra,0xffffe
    800029f8:	b54080e7          	jalr	-1196(ra) # 80000548 <panic>

00000000800029fc <fetchaddr>:
{
    800029fc:	1101                	addi	sp,sp,-32
    800029fe:	ec06                	sd	ra,24(sp)
    80002a00:	e822                	sd	s0,16(sp)
    80002a02:	e426                	sd	s1,8(sp)
    80002a04:	e04a                	sd	s2,0(sp)
    80002a06:	1000                	addi	s0,sp,32
    80002a08:	84aa                	mv	s1,a0
    80002a0a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002a0c:	fffff097          	auipc	ra,0xfffff
    80002a10:	fd2080e7          	jalr	-46(ra) # 800019de <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002a14:	653c                	ld	a5,72(a0)
    80002a16:	02f4f863          	bgeu	s1,a5,80002a46 <fetchaddr+0x4a>
    80002a1a:	00848713          	addi	a4,s1,8
    80002a1e:	02e7e663          	bltu	a5,a4,80002a4a <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002a22:	46a1                	li	a3,8
    80002a24:	8626                	mv	a2,s1
    80002a26:	85ca                	mv	a1,s2
    80002a28:	6928                	ld	a0,80(a0)
    80002a2a:	fffff097          	auipc	ra,0xfffff
    80002a2e:	d34080e7          	jalr	-716(ra) # 8000175e <copyin>
    80002a32:	00a03533          	snez	a0,a0
    80002a36:	40a00533          	neg	a0,a0
}
    80002a3a:	60e2                	ld	ra,24(sp)
    80002a3c:	6442                	ld	s0,16(sp)
    80002a3e:	64a2                	ld	s1,8(sp)
    80002a40:	6902                	ld	s2,0(sp)
    80002a42:	6105                	addi	sp,sp,32
    80002a44:	8082                	ret
    return -1;
    80002a46:	557d                	li	a0,-1
    80002a48:	bfcd                	j	80002a3a <fetchaddr+0x3e>
    80002a4a:	557d                	li	a0,-1
    80002a4c:	b7fd                	j	80002a3a <fetchaddr+0x3e>

0000000080002a4e <fetchstr>:
{
    80002a4e:	7179                	addi	sp,sp,-48
    80002a50:	f406                	sd	ra,40(sp)
    80002a52:	f022                	sd	s0,32(sp)
    80002a54:	ec26                	sd	s1,24(sp)
    80002a56:	e84a                	sd	s2,16(sp)
    80002a58:	e44e                	sd	s3,8(sp)
    80002a5a:	1800                	addi	s0,sp,48
    80002a5c:	892a                	mv	s2,a0
    80002a5e:	84ae                	mv	s1,a1
    80002a60:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002a62:	fffff097          	auipc	ra,0xfffff
    80002a66:	f7c080e7          	jalr	-132(ra) # 800019de <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002a6a:	86ce                	mv	a3,s3
    80002a6c:	864a                	mv	a2,s2
    80002a6e:	85a6                	mv	a1,s1
    80002a70:	6928                	ld	a0,80(a0)
    80002a72:	fffff097          	auipc	ra,0xfffff
    80002a76:	d78080e7          	jalr	-648(ra) # 800017ea <copyinstr>
  if(err < 0)
    80002a7a:	00054763          	bltz	a0,80002a88 <fetchstr+0x3a>
  return strlen(buf);
    80002a7e:	8526                	mv	a0,s1
    80002a80:	ffffe097          	auipc	ra,0xffffe
    80002a84:	414080e7          	jalr	1044(ra) # 80000e94 <strlen>
}
    80002a88:	70a2                	ld	ra,40(sp)
    80002a8a:	7402                	ld	s0,32(sp)
    80002a8c:	64e2                	ld	s1,24(sp)
    80002a8e:	6942                	ld	s2,16(sp)
    80002a90:	69a2                	ld	s3,8(sp)
    80002a92:	6145                	addi	sp,sp,48
    80002a94:	8082                	ret

0000000080002a96 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002a96:	1101                	addi	sp,sp,-32
    80002a98:	ec06                	sd	ra,24(sp)
    80002a9a:	e822                	sd	s0,16(sp)
    80002a9c:	e426                	sd	s1,8(sp)
    80002a9e:	1000                	addi	s0,sp,32
    80002aa0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002aa2:	00000097          	auipc	ra,0x0
    80002aa6:	ef2080e7          	jalr	-270(ra) # 80002994 <argraw>
    80002aaa:	c088                	sw	a0,0(s1)
  return 0;
}
    80002aac:	4501                	li	a0,0
    80002aae:	60e2                	ld	ra,24(sp)
    80002ab0:	6442                	ld	s0,16(sp)
    80002ab2:	64a2                	ld	s1,8(sp)
    80002ab4:	6105                	addi	sp,sp,32
    80002ab6:	8082                	ret

0000000080002ab8 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002ab8:	1101                	addi	sp,sp,-32
    80002aba:	ec06                	sd	ra,24(sp)
    80002abc:	e822                	sd	s0,16(sp)
    80002abe:	e426                	sd	s1,8(sp)
    80002ac0:	1000                	addi	s0,sp,32
    80002ac2:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002ac4:	00000097          	auipc	ra,0x0
    80002ac8:	ed0080e7          	jalr	-304(ra) # 80002994 <argraw>
    80002acc:	e088                	sd	a0,0(s1)
  return 0;
}
    80002ace:	4501                	li	a0,0
    80002ad0:	60e2                	ld	ra,24(sp)
    80002ad2:	6442                	ld	s0,16(sp)
    80002ad4:	64a2                	ld	s1,8(sp)
    80002ad6:	6105                	addi	sp,sp,32
    80002ad8:	8082                	ret

0000000080002ada <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002ada:	1101                	addi	sp,sp,-32
    80002adc:	ec06                	sd	ra,24(sp)
    80002ade:	e822                	sd	s0,16(sp)
    80002ae0:	e426                	sd	s1,8(sp)
    80002ae2:	e04a                	sd	s2,0(sp)
    80002ae4:	1000                	addi	s0,sp,32
    80002ae6:	84ae                	mv	s1,a1
    80002ae8:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002aea:	00000097          	auipc	ra,0x0
    80002aee:	eaa080e7          	jalr	-342(ra) # 80002994 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002af2:	864a                	mv	a2,s2
    80002af4:	85a6                	mv	a1,s1
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	f58080e7          	jalr	-168(ra) # 80002a4e <fetchstr>
}
    80002afe:	60e2                	ld	ra,24(sp)
    80002b00:	6442                	ld	s0,16(sp)
    80002b02:	64a2                	ld	s1,8(sp)
    80002b04:	6902                	ld	s2,0(sp)
    80002b06:	6105                	addi	sp,sp,32
    80002b08:	8082                	ret

0000000080002b0a <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80002b0a:	1101                	addi	sp,sp,-32
    80002b0c:	ec06                	sd	ra,24(sp)
    80002b0e:	e822                	sd	s0,16(sp)
    80002b10:	e426                	sd	s1,8(sp)
    80002b12:	e04a                	sd	s2,0(sp)
    80002b14:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002b16:	fffff097          	auipc	ra,0xfffff
    80002b1a:	ec8080e7          	jalr	-312(ra) # 800019de <myproc>
    80002b1e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002b20:	05853903          	ld	s2,88(a0)
    80002b24:	0a893783          	ld	a5,168(s2)
    80002b28:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002b2c:	37fd                	addiw	a5,a5,-1
    80002b2e:	4751                	li	a4,20
    80002b30:	00f76f63          	bltu	a4,a5,80002b4e <syscall+0x44>
    80002b34:	00369713          	slli	a4,a3,0x3
    80002b38:	00006797          	auipc	a5,0x6
    80002b3c:	8f078793          	addi	a5,a5,-1808 # 80008428 <syscalls>
    80002b40:	97ba                	add	a5,a5,a4
    80002b42:	639c                	ld	a5,0(a5)
    80002b44:	c789                	beqz	a5,80002b4e <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    80002b46:	9782                	jalr	a5
    80002b48:	06a93823          	sd	a0,112(s2)
    80002b4c:	a839                	j	80002b6a <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002b4e:	15848613          	addi	a2,s1,344
    80002b52:	5c8c                	lw	a1,56(s1)
    80002b54:	00006517          	auipc	a0,0x6
    80002b58:	89c50513          	addi	a0,a0,-1892 # 800083f0 <states.1702+0x148>
    80002b5c:	ffffe097          	auipc	ra,0xffffe
    80002b60:	a36080e7          	jalr	-1482(ra) # 80000592 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002b64:	6cbc                	ld	a5,88(s1)
    80002b66:	577d                	li	a4,-1
    80002b68:	fbb8                	sd	a4,112(a5)
  }
}
    80002b6a:	60e2                	ld	ra,24(sp)
    80002b6c:	6442                	ld	s0,16(sp)
    80002b6e:	64a2                	ld	s1,8(sp)
    80002b70:	6902                	ld	s2,0(sp)
    80002b72:	6105                	addi	sp,sp,32
    80002b74:	8082                	ret

0000000080002b76 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002b76:	1101                	addi	sp,sp,-32
    80002b78:	ec06                	sd	ra,24(sp)
    80002b7a:	e822                	sd	s0,16(sp)
    80002b7c:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    80002b7e:	fec40593          	addi	a1,s0,-20
    80002b82:	4501                	li	a0,0
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	f12080e7          	jalr	-238(ra) # 80002a96 <argint>
    return -1;
    80002b8c:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002b8e:	00054963          	bltz	a0,80002ba0 <sys_exit+0x2a>
  exit(n);
    80002b92:	fec42503          	lw	a0,-20(s0)
    80002b96:	fffff097          	auipc	ra,0xfffff
    80002b9a:	50e080e7          	jalr	1294(ra) # 800020a4 <exit>
  return 0;  // not reached
    80002b9e:	4781                	li	a5,0
}
    80002ba0:	853e                	mv	a0,a5
    80002ba2:	60e2                	ld	ra,24(sp)
    80002ba4:	6442                	ld	s0,16(sp)
    80002ba6:	6105                	addi	sp,sp,32
    80002ba8:	8082                	ret

0000000080002baa <sys_getpid>:

uint64
sys_getpid(void)
{
    80002baa:	1141                	addi	sp,sp,-16
    80002bac:	e406                	sd	ra,8(sp)
    80002bae:	e022                	sd	s0,0(sp)
    80002bb0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002bb2:	fffff097          	auipc	ra,0xfffff
    80002bb6:	e2c080e7          	jalr	-468(ra) # 800019de <myproc>
}
    80002bba:	5d08                	lw	a0,56(a0)
    80002bbc:	60a2                	ld	ra,8(sp)
    80002bbe:	6402                	ld	s0,0(sp)
    80002bc0:	0141                	addi	sp,sp,16
    80002bc2:	8082                	ret

0000000080002bc4 <sys_fork>:

uint64
sys_fork(void)
{
    80002bc4:	1141                	addi	sp,sp,-16
    80002bc6:	e406                	sd	ra,8(sp)
    80002bc8:	e022                	sd	s0,0(sp)
    80002bca:	0800                	addi	s0,sp,16
  return fork();
    80002bcc:	fffff097          	auipc	ra,0xfffff
    80002bd0:	1d2080e7          	jalr	466(ra) # 80001d9e <fork>
}
    80002bd4:	60a2                	ld	ra,8(sp)
    80002bd6:	6402                	ld	s0,0(sp)
    80002bd8:	0141                	addi	sp,sp,16
    80002bda:	8082                	ret

0000000080002bdc <sys_wait>:

uint64
sys_wait(void)
{
    80002bdc:	1101                	addi	sp,sp,-32
    80002bde:	ec06                	sd	ra,24(sp)
    80002be0:	e822                	sd	s0,16(sp)
    80002be2:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002be4:	fe840593          	addi	a1,s0,-24
    80002be8:	4501                	li	a0,0
    80002bea:	00000097          	auipc	ra,0x0
    80002bee:	ece080e7          	jalr	-306(ra) # 80002ab8 <argaddr>
    80002bf2:	87aa                	mv	a5,a0
    return -1;
    80002bf4:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002bf6:	0007c863          	bltz	a5,80002c06 <sys_wait+0x2a>
  return wait(p);
    80002bfa:	fe843503          	ld	a0,-24(s0)
    80002bfe:	fffff097          	auipc	ra,0xfffff
    80002c02:	66a080e7          	jalr	1642(ra) # 80002268 <wait>
}
    80002c06:	60e2                	ld	ra,24(sp)
    80002c08:	6442                	ld	s0,16(sp)
    80002c0a:	6105                	addi	sp,sp,32
    80002c0c:	8082                	ret

0000000080002c0e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c0e:	7179                	addi	sp,sp,-48
    80002c10:	f406                	sd	ra,40(sp)
    80002c12:	f022                	sd	s0,32(sp)
    80002c14:	ec26                	sd	s1,24(sp)
    80002c16:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002c18:	fdc40593          	addi	a1,s0,-36
    80002c1c:	4501                	li	a0,0
    80002c1e:	00000097          	auipc	ra,0x0
    80002c22:	e78080e7          	jalr	-392(ra) # 80002a96 <argint>
    80002c26:	87aa                	mv	a5,a0
    return -1;
    80002c28:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002c2a:	0207c063          	bltz	a5,80002c4a <sys_sbrk+0x3c>
  addr = myproc()->sz;
    80002c2e:	fffff097          	auipc	ra,0xfffff
    80002c32:	db0080e7          	jalr	-592(ra) # 800019de <myproc>
    80002c36:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002c38:	fdc42503          	lw	a0,-36(s0)
    80002c3c:	fffff097          	auipc	ra,0xfffff
    80002c40:	0ee080e7          	jalr	238(ra) # 80001d2a <growproc>
    80002c44:	00054863          	bltz	a0,80002c54 <sys_sbrk+0x46>
    return -1;
  return addr;
    80002c48:	8526                	mv	a0,s1
}
    80002c4a:	70a2                	ld	ra,40(sp)
    80002c4c:	7402                	ld	s0,32(sp)
    80002c4e:	64e2                	ld	s1,24(sp)
    80002c50:	6145                	addi	sp,sp,48
    80002c52:	8082                	ret
    return -1;
    80002c54:	557d                	li	a0,-1
    80002c56:	bfd5                	j	80002c4a <sys_sbrk+0x3c>

0000000080002c58 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002c58:	7139                	addi	sp,sp,-64
    80002c5a:	fc06                	sd	ra,56(sp)
    80002c5c:	f822                	sd	s0,48(sp)
    80002c5e:	f426                	sd	s1,40(sp)
    80002c60:	f04a                	sd	s2,32(sp)
    80002c62:	ec4e                	sd	s3,24(sp)
    80002c64:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    80002c66:	fcc40593          	addi	a1,s0,-52
    80002c6a:	4501                	li	a0,0
    80002c6c:	00000097          	auipc	ra,0x0
    80002c70:	e2a080e7          	jalr	-470(ra) # 80002a96 <argint>
    return -1;
    80002c74:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    80002c76:	06054563          	bltz	a0,80002ce0 <sys_sleep+0x88>
  acquire(&tickslock);
    80002c7a:	00015517          	auipc	a0,0x15
    80002c7e:	aee50513          	addi	a0,a0,-1298 # 80017768 <tickslock>
    80002c82:	ffffe097          	auipc	ra,0xffffe
    80002c86:	f8e080e7          	jalr	-114(ra) # 80000c10 <acquire>
  ticks0 = ticks;
    80002c8a:	00006917          	auipc	s2,0x6
    80002c8e:	39692903          	lw	s2,918(s2) # 80009020 <ticks>
  while(ticks - ticks0 < n){
    80002c92:	fcc42783          	lw	a5,-52(s0)
    80002c96:	cf85                	beqz	a5,80002cce <sys_sleep+0x76>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002c98:	00015997          	auipc	s3,0x15
    80002c9c:	ad098993          	addi	s3,s3,-1328 # 80017768 <tickslock>
    80002ca0:	00006497          	auipc	s1,0x6
    80002ca4:	38048493          	addi	s1,s1,896 # 80009020 <ticks>
    if(myproc()->killed){
    80002ca8:	fffff097          	auipc	ra,0xfffff
    80002cac:	d36080e7          	jalr	-714(ra) # 800019de <myproc>
    80002cb0:	591c                	lw	a5,48(a0)
    80002cb2:	ef9d                	bnez	a5,80002cf0 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002cb4:	85ce                	mv	a1,s3
    80002cb6:	8526                	mv	a0,s1
    80002cb8:	fffff097          	auipc	ra,0xfffff
    80002cbc:	532080e7          	jalr	1330(ra) # 800021ea <sleep>
  while(ticks - ticks0 < n){
    80002cc0:	409c                	lw	a5,0(s1)
    80002cc2:	412787bb          	subw	a5,a5,s2
    80002cc6:	fcc42703          	lw	a4,-52(s0)
    80002cca:	fce7efe3          	bltu	a5,a4,80002ca8 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002cce:	00015517          	auipc	a0,0x15
    80002cd2:	a9a50513          	addi	a0,a0,-1382 # 80017768 <tickslock>
    80002cd6:	ffffe097          	auipc	ra,0xffffe
    80002cda:	fee080e7          	jalr	-18(ra) # 80000cc4 <release>
  return 0;
    80002cde:	4781                	li	a5,0
}
    80002ce0:	853e                	mv	a0,a5
    80002ce2:	70e2                	ld	ra,56(sp)
    80002ce4:	7442                	ld	s0,48(sp)
    80002ce6:	74a2                	ld	s1,40(sp)
    80002ce8:	7902                	ld	s2,32(sp)
    80002cea:	69e2                	ld	s3,24(sp)
    80002cec:	6121                	addi	sp,sp,64
    80002cee:	8082                	ret
      release(&tickslock);
    80002cf0:	00015517          	auipc	a0,0x15
    80002cf4:	a7850513          	addi	a0,a0,-1416 # 80017768 <tickslock>
    80002cf8:	ffffe097          	auipc	ra,0xffffe
    80002cfc:	fcc080e7          	jalr	-52(ra) # 80000cc4 <release>
      return -1;
    80002d00:	57fd                	li	a5,-1
    80002d02:	bff9                	j	80002ce0 <sys_sleep+0x88>

0000000080002d04 <sys_kill>:

uint64
sys_kill(void)
{
    80002d04:	1101                	addi	sp,sp,-32
    80002d06:	ec06                	sd	ra,24(sp)
    80002d08:	e822                	sd	s0,16(sp)
    80002d0a:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002d0c:	fec40593          	addi	a1,s0,-20
    80002d10:	4501                	li	a0,0
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	d84080e7          	jalr	-636(ra) # 80002a96 <argint>
    80002d1a:	87aa                	mv	a5,a0
    return -1;
    80002d1c:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002d1e:	0007c863          	bltz	a5,80002d2e <sys_kill+0x2a>
  return kill(pid);
    80002d22:	fec42503          	lw	a0,-20(s0)
    80002d26:	fffff097          	auipc	ra,0xfffff
    80002d2a:	6b4080e7          	jalr	1716(ra) # 800023da <kill>
}
    80002d2e:	60e2                	ld	ra,24(sp)
    80002d30:	6442                	ld	s0,16(sp)
    80002d32:	6105                	addi	sp,sp,32
    80002d34:	8082                	ret

0000000080002d36 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002d36:	1101                	addi	sp,sp,-32
    80002d38:	ec06                	sd	ra,24(sp)
    80002d3a:	e822                	sd	s0,16(sp)
    80002d3c:	e426                	sd	s1,8(sp)
    80002d3e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002d40:	00015517          	auipc	a0,0x15
    80002d44:	a2850513          	addi	a0,a0,-1496 # 80017768 <tickslock>
    80002d48:	ffffe097          	auipc	ra,0xffffe
    80002d4c:	ec8080e7          	jalr	-312(ra) # 80000c10 <acquire>
  xticks = ticks;
    80002d50:	00006497          	auipc	s1,0x6
    80002d54:	2d04a483          	lw	s1,720(s1) # 80009020 <ticks>
  release(&tickslock);
    80002d58:	00015517          	auipc	a0,0x15
    80002d5c:	a1050513          	addi	a0,a0,-1520 # 80017768 <tickslock>
    80002d60:	ffffe097          	auipc	ra,0xffffe
    80002d64:	f64080e7          	jalr	-156(ra) # 80000cc4 <release>
  return xticks;
}
    80002d68:	02049513          	slli	a0,s1,0x20
    80002d6c:	9101                	srli	a0,a0,0x20
    80002d6e:	60e2                	ld	ra,24(sp)
    80002d70:	6442                	ld	s0,16(sp)
    80002d72:	64a2                	ld	s1,8(sp)
    80002d74:	6105                	addi	sp,sp,32
    80002d76:	8082                	ret

0000000080002d78 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002d78:	7179                	addi	sp,sp,-48
    80002d7a:	f406                	sd	ra,40(sp)
    80002d7c:	f022                	sd	s0,32(sp)
    80002d7e:	ec26                	sd	s1,24(sp)
    80002d80:	e84a                	sd	s2,16(sp)
    80002d82:	e44e                	sd	s3,8(sp)
    80002d84:	e052                	sd	s4,0(sp)
    80002d86:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002d88:	00005597          	auipc	a1,0x5
    80002d8c:	75058593          	addi	a1,a1,1872 # 800084d8 <syscalls+0xb0>
    80002d90:	00015517          	auipc	a0,0x15
    80002d94:	9f050513          	addi	a0,a0,-1552 # 80017780 <bcache>
    80002d98:	ffffe097          	auipc	ra,0xffffe
    80002d9c:	de8080e7          	jalr	-536(ra) # 80000b80 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002da0:	0001d797          	auipc	a5,0x1d
    80002da4:	9e078793          	addi	a5,a5,-1568 # 8001f780 <bcache+0x8000>
    80002da8:	0001d717          	auipc	a4,0x1d
    80002dac:	c4070713          	addi	a4,a4,-960 # 8001f9e8 <bcache+0x8268>
    80002db0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002db4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002db8:	00015497          	auipc	s1,0x15
    80002dbc:	9e048493          	addi	s1,s1,-1568 # 80017798 <bcache+0x18>
    b->next = bcache.head.next;
    80002dc0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002dc2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002dc4:	00005a17          	auipc	s4,0x5
    80002dc8:	71ca0a13          	addi	s4,s4,1820 # 800084e0 <syscalls+0xb8>
    b->next = bcache.head.next;
    80002dcc:	2b893783          	ld	a5,696(s2)
    80002dd0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002dd2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002dd6:	85d2                	mv	a1,s4
    80002dd8:	01048513          	addi	a0,s1,16
    80002ddc:	00001097          	auipc	ra,0x1
    80002de0:	4ac080e7          	jalr	1196(ra) # 80004288 <initsleeplock>
    bcache.head.next->prev = b;
    80002de4:	2b893783          	ld	a5,696(s2)
    80002de8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002dea:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002dee:	45848493          	addi	s1,s1,1112
    80002df2:	fd349de3          	bne	s1,s3,80002dcc <binit+0x54>
  }
}
    80002df6:	70a2                	ld	ra,40(sp)
    80002df8:	7402                	ld	s0,32(sp)
    80002dfa:	64e2                	ld	s1,24(sp)
    80002dfc:	6942                	ld	s2,16(sp)
    80002dfe:	69a2                	ld	s3,8(sp)
    80002e00:	6a02                	ld	s4,0(sp)
    80002e02:	6145                	addi	sp,sp,48
    80002e04:	8082                	ret

0000000080002e06 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002e06:	7179                	addi	sp,sp,-48
    80002e08:	f406                	sd	ra,40(sp)
    80002e0a:	f022                	sd	s0,32(sp)
    80002e0c:	ec26                	sd	s1,24(sp)
    80002e0e:	e84a                	sd	s2,16(sp)
    80002e10:	e44e                	sd	s3,8(sp)
    80002e12:	1800                	addi	s0,sp,48
    80002e14:	89aa                	mv	s3,a0
    80002e16:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002e18:	00015517          	auipc	a0,0x15
    80002e1c:	96850513          	addi	a0,a0,-1688 # 80017780 <bcache>
    80002e20:	ffffe097          	auipc	ra,0xffffe
    80002e24:	df0080e7          	jalr	-528(ra) # 80000c10 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002e28:	0001d497          	auipc	s1,0x1d
    80002e2c:	c104b483          	ld	s1,-1008(s1) # 8001fa38 <bcache+0x82b8>
    80002e30:	0001d797          	auipc	a5,0x1d
    80002e34:	bb878793          	addi	a5,a5,-1096 # 8001f9e8 <bcache+0x8268>
    80002e38:	02f48f63          	beq	s1,a5,80002e76 <bread+0x70>
    80002e3c:	873e                	mv	a4,a5
    80002e3e:	a021                	j	80002e46 <bread+0x40>
    80002e40:	68a4                	ld	s1,80(s1)
    80002e42:	02e48a63          	beq	s1,a4,80002e76 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002e46:	449c                	lw	a5,8(s1)
    80002e48:	ff379ce3          	bne	a5,s3,80002e40 <bread+0x3a>
    80002e4c:	44dc                	lw	a5,12(s1)
    80002e4e:	ff2799e3          	bne	a5,s2,80002e40 <bread+0x3a>
      b->refcnt++;
    80002e52:	40bc                	lw	a5,64(s1)
    80002e54:	2785                	addiw	a5,a5,1
    80002e56:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002e58:	00015517          	auipc	a0,0x15
    80002e5c:	92850513          	addi	a0,a0,-1752 # 80017780 <bcache>
    80002e60:	ffffe097          	auipc	ra,0xffffe
    80002e64:	e64080e7          	jalr	-412(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    80002e68:	01048513          	addi	a0,s1,16
    80002e6c:	00001097          	auipc	ra,0x1
    80002e70:	456080e7          	jalr	1110(ra) # 800042c2 <acquiresleep>
      return b;
    80002e74:	a8b9                	j	80002ed2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e76:	0001d497          	auipc	s1,0x1d
    80002e7a:	bba4b483          	ld	s1,-1094(s1) # 8001fa30 <bcache+0x82b0>
    80002e7e:	0001d797          	auipc	a5,0x1d
    80002e82:	b6a78793          	addi	a5,a5,-1174 # 8001f9e8 <bcache+0x8268>
    80002e86:	00f48863          	beq	s1,a5,80002e96 <bread+0x90>
    80002e8a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002e8c:	40bc                	lw	a5,64(s1)
    80002e8e:	cf81                	beqz	a5,80002ea6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002e90:	64a4                	ld	s1,72(s1)
    80002e92:	fee49de3          	bne	s1,a4,80002e8c <bread+0x86>
  panic("bget: no buffers");
    80002e96:	00005517          	auipc	a0,0x5
    80002e9a:	65250513          	addi	a0,a0,1618 # 800084e8 <syscalls+0xc0>
    80002e9e:	ffffd097          	auipc	ra,0xffffd
    80002ea2:	6aa080e7          	jalr	1706(ra) # 80000548 <panic>
      b->dev = dev;
    80002ea6:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002eaa:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002eae:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002eb2:	4785                	li	a5,1
    80002eb4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002eb6:	00015517          	auipc	a0,0x15
    80002eba:	8ca50513          	addi	a0,a0,-1846 # 80017780 <bcache>
    80002ebe:	ffffe097          	auipc	ra,0xffffe
    80002ec2:	e06080e7          	jalr	-506(ra) # 80000cc4 <release>
      acquiresleep(&b->lock);
    80002ec6:	01048513          	addi	a0,s1,16
    80002eca:	00001097          	auipc	ra,0x1
    80002ece:	3f8080e7          	jalr	1016(ra) # 800042c2 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002ed2:	409c                	lw	a5,0(s1)
    80002ed4:	cb89                	beqz	a5,80002ee6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ed6:	8526                	mv	a0,s1
    80002ed8:	70a2                	ld	ra,40(sp)
    80002eda:	7402                	ld	s0,32(sp)
    80002edc:	64e2                	ld	s1,24(sp)
    80002ede:	6942                	ld	s2,16(sp)
    80002ee0:	69a2                	ld	s3,8(sp)
    80002ee2:	6145                	addi	sp,sp,48
    80002ee4:	8082                	ret
    virtio_disk_rw(b, 0);
    80002ee6:	4581                	li	a1,0
    80002ee8:	8526                	mv	a0,s1
    80002eea:	00003097          	auipc	ra,0x3
    80002eee:	f32080e7          	jalr	-206(ra) # 80005e1c <virtio_disk_rw>
    b->valid = 1;
    80002ef2:	4785                	li	a5,1
    80002ef4:	c09c                	sw	a5,0(s1)
  return b;
    80002ef6:	b7c5                	j	80002ed6 <bread+0xd0>

0000000080002ef8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002ef8:	1101                	addi	sp,sp,-32
    80002efa:	ec06                	sd	ra,24(sp)
    80002efc:	e822                	sd	s0,16(sp)
    80002efe:	e426                	sd	s1,8(sp)
    80002f00:	1000                	addi	s0,sp,32
    80002f02:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f04:	0541                	addi	a0,a0,16
    80002f06:	00001097          	auipc	ra,0x1
    80002f0a:	456080e7          	jalr	1110(ra) # 8000435c <holdingsleep>
    80002f0e:	cd01                	beqz	a0,80002f26 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002f10:	4585                	li	a1,1
    80002f12:	8526                	mv	a0,s1
    80002f14:	00003097          	auipc	ra,0x3
    80002f18:	f08080e7          	jalr	-248(ra) # 80005e1c <virtio_disk_rw>
}
    80002f1c:	60e2                	ld	ra,24(sp)
    80002f1e:	6442                	ld	s0,16(sp)
    80002f20:	64a2                	ld	s1,8(sp)
    80002f22:	6105                	addi	sp,sp,32
    80002f24:	8082                	ret
    panic("bwrite");
    80002f26:	00005517          	auipc	a0,0x5
    80002f2a:	5da50513          	addi	a0,a0,1498 # 80008500 <syscalls+0xd8>
    80002f2e:	ffffd097          	auipc	ra,0xffffd
    80002f32:	61a080e7          	jalr	1562(ra) # 80000548 <panic>

0000000080002f36 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002f36:	1101                	addi	sp,sp,-32
    80002f38:	ec06                	sd	ra,24(sp)
    80002f3a:	e822                	sd	s0,16(sp)
    80002f3c:	e426                	sd	s1,8(sp)
    80002f3e:	e04a                	sd	s2,0(sp)
    80002f40:	1000                	addi	s0,sp,32
    80002f42:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002f44:	01050913          	addi	s2,a0,16
    80002f48:	854a                	mv	a0,s2
    80002f4a:	00001097          	auipc	ra,0x1
    80002f4e:	412080e7          	jalr	1042(ra) # 8000435c <holdingsleep>
    80002f52:	c92d                	beqz	a0,80002fc4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002f54:	854a                	mv	a0,s2
    80002f56:	00001097          	auipc	ra,0x1
    80002f5a:	3c2080e7          	jalr	962(ra) # 80004318 <releasesleep>

  acquire(&bcache.lock);
    80002f5e:	00015517          	auipc	a0,0x15
    80002f62:	82250513          	addi	a0,a0,-2014 # 80017780 <bcache>
    80002f66:	ffffe097          	auipc	ra,0xffffe
    80002f6a:	caa080e7          	jalr	-854(ra) # 80000c10 <acquire>
  b->refcnt--;
    80002f6e:	40bc                	lw	a5,64(s1)
    80002f70:	37fd                	addiw	a5,a5,-1
    80002f72:	0007871b          	sext.w	a4,a5
    80002f76:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002f78:	eb05                	bnez	a4,80002fa8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002f7a:	68bc                	ld	a5,80(s1)
    80002f7c:	64b8                	ld	a4,72(s1)
    80002f7e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002f80:	64bc                	ld	a5,72(s1)
    80002f82:	68b8                	ld	a4,80(s1)
    80002f84:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002f86:	0001c797          	auipc	a5,0x1c
    80002f8a:	7fa78793          	addi	a5,a5,2042 # 8001f780 <bcache+0x8000>
    80002f8e:	2b87b703          	ld	a4,696(a5)
    80002f92:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002f94:	0001d717          	auipc	a4,0x1d
    80002f98:	a5470713          	addi	a4,a4,-1452 # 8001f9e8 <bcache+0x8268>
    80002f9c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002f9e:	2b87b703          	ld	a4,696(a5)
    80002fa2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002fa4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002fa8:	00014517          	auipc	a0,0x14
    80002fac:	7d850513          	addi	a0,a0,2008 # 80017780 <bcache>
    80002fb0:	ffffe097          	auipc	ra,0xffffe
    80002fb4:	d14080e7          	jalr	-748(ra) # 80000cc4 <release>
}
    80002fb8:	60e2                	ld	ra,24(sp)
    80002fba:	6442                	ld	s0,16(sp)
    80002fbc:	64a2                	ld	s1,8(sp)
    80002fbe:	6902                	ld	s2,0(sp)
    80002fc0:	6105                	addi	sp,sp,32
    80002fc2:	8082                	ret
    panic("brelse");
    80002fc4:	00005517          	auipc	a0,0x5
    80002fc8:	54450513          	addi	a0,a0,1348 # 80008508 <syscalls+0xe0>
    80002fcc:	ffffd097          	auipc	ra,0xffffd
    80002fd0:	57c080e7          	jalr	1404(ra) # 80000548 <panic>

0000000080002fd4 <bpin>:

void
bpin(struct buf *b) {
    80002fd4:	1101                	addi	sp,sp,-32
    80002fd6:	ec06                	sd	ra,24(sp)
    80002fd8:	e822                	sd	s0,16(sp)
    80002fda:	e426                	sd	s1,8(sp)
    80002fdc:	1000                	addi	s0,sp,32
    80002fde:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002fe0:	00014517          	auipc	a0,0x14
    80002fe4:	7a050513          	addi	a0,a0,1952 # 80017780 <bcache>
    80002fe8:	ffffe097          	auipc	ra,0xffffe
    80002fec:	c28080e7          	jalr	-984(ra) # 80000c10 <acquire>
  b->refcnt++;
    80002ff0:	40bc                	lw	a5,64(s1)
    80002ff2:	2785                	addiw	a5,a5,1
    80002ff4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ff6:	00014517          	auipc	a0,0x14
    80002ffa:	78a50513          	addi	a0,a0,1930 # 80017780 <bcache>
    80002ffe:	ffffe097          	auipc	ra,0xffffe
    80003002:	cc6080e7          	jalr	-826(ra) # 80000cc4 <release>
}
    80003006:	60e2                	ld	ra,24(sp)
    80003008:	6442                	ld	s0,16(sp)
    8000300a:	64a2                	ld	s1,8(sp)
    8000300c:	6105                	addi	sp,sp,32
    8000300e:	8082                	ret

0000000080003010 <bunpin>:

void
bunpin(struct buf *b) {
    80003010:	1101                	addi	sp,sp,-32
    80003012:	ec06                	sd	ra,24(sp)
    80003014:	e822                	sd	s0,16(sp)
    80003016:	e426                	sd	s1,8(sp)
    80003018:	1000                	addi	s0,sp,32
    8000301a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000301c:	00014517          	auipc	a0,0x14
    80003020:	76450513          	addi	a0,a0,1892 # 80017780 <bcache>
    80003024:	ffffe097          	auipc	ra,0xffffe
    80003028:	bec080e7          	jalr	-1044(ra) # 80000c10 <acquire>
  b->refcnt--;
    8000302c:	40bc                	lw	a5,64(s1)
    8000302e:	37fd                	addiw	a5,a5,-1
    80003030:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003032:	00014517          	auipc	a0,0x14
    80003036:	74e50513          	addi	a0,a0,1870 # 80017780 <bcache>
    8000303a:	ffffe097          	auipc	ra,0xffffe
    8000303e:	c8a080e7          	jalr	-886(ra) # 80000cc4 <release>
}
    80003042:	60e2                	ld	ra,24(sp)
    80003044:	6442                	ld	s0,16(sp)
    80003046:	64a2                	ld	s1,8(sp)
    80003048:	6105                	addi	sp,sp,32
    8000304a:	8082                	ret

000000008000304c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000304c:	1101                	addi	sp,sp,-32
    8000304e:	ec06                	sd	ra,24(sp)
    80003050:	e822                	sd	s0,16(sp)
    80003052:	e426                	sd	s1,8(sp)
    80003054:	e04a                	sd	s2,0(sp)
    80003056:	1000                	addi	s0,sp,32
    80003058:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000305a:	00d5d59b          	srliw	a1,a1,0xd
    8000305e:	0001d797          	auipc	a5,0x1d
    80003062:	dfe7a783          	lw	a5,-514(a5) # 8001fe5c <sb+0x1c>
    80003066:	9dbd                	addw	a1,a1,a5
    80003068:	00000097          	auipc	ra,0x0
    8000306c:	d9e080e7          	jalr	-610(ra) # 80002e06 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003070:	0074f713          	andi	a4,s1,7
    80003074:	4785                	li	a5,1
    80003076:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    8000307a:	14ce                	slli	s1,s1,0x33
    8000307c:	90d9                	srli	s1,s1,0x36
    8000307e:	00950733          	add	a4,a0,s1
    80003082:	05874703          	lbu	a4,88(a4)
    80003086:	00e7f6b3          	and	a3,a5,a4
    8000308a:	c69d                	beqz	a3,800030b8 <bfree+0x6c>
    8000308c:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000308e:	94aa                	add	s1,s1,a0
    80003090:	fff7c793          	not	a5,a5
    80003094:	8ff9                	and	a5,a5,a4
    80003096:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    8000309a:	00001097          	auipc	ra,0x1
    8000309e:	100080e7          	jalr	256(ra) # 8000419a <log_write>
  brelse(bp);
    800030a2:	854a                	mv	a0,s2
    800030a4:	00000097          	auipc	ra,0x0
    800030a8:	e92080e7          	jalr	-366(ra) # 80002f36 <brelse>
}
    800030ac:	60e2                	ld	ra,24(sp)
    800030ae:	6442                	ld	s0,16(sp)
    800030b0:	64a2                	ld	s1,8(sp)
    800030b2:	6902                	ld	s2,0(sp)
    800030b4:	6105                	addi	sp,sp,32
    800030b6:	8082                	ret
    panic("freeing free block");
    800030b8:	00005517          	auipc	a0,0x5
    800030bc:	45850513          	addi	a0,a0,1112 # 80008510 <syscalls+0xe8>
    800030c0:	ffffd097          	auipc	ra,0xffffd
    800030c4:	488080e7          	jalr	1160(ra) # 80000548 <panic>

00000000800030c8 <balloc>:
{
    800030c8:	711d                	addi	sp,sp,-96
    800030ca:	ec86                	sd	ra,88(sp)
    800030cc:	e8a2                	sd	s0,80(sp)
    800030ce:	e4a6                	sd	s1,72(sp)
    800030d0:	e0ca                	sd	s2,64(sp)
    800030d2:	fc4e                	sd	s3,56(sp)
    800030d4:	f852                	sd	s4,48(sp)
    800030d6:	f456                	sd	s5,40(sp)
    800030d8:	f05a                	sd	s6,32(sp)
    800030da:	ec5e                	sd	s7,24(sp)
    800030dc:	e862                	sd	s8,16(sp)
    800030de:	e466                	sd	s9,8(sp)
    800030e0:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800030e2:	0001d797          	auipc	a5,0x1d
    800030e6:	d627a783          	lw	a5,-670(a5) # 8001fe44 <sb+0x4>
    800030ea:	cbd1                	beqz	a5,8000317e <balloc+0xb6>
    800030ec:	8baa                	mv	s7,a0
    800030ee:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800030f0:	0001db17          	auipc	s6,0x1d
    800030f4:	d50b0b13          	addi	s6,s6,-688 # 8001fe40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030f8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800030fa:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800030fc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800030fe:	6c89                	lui	s9,0x2
    80003100:	a831                	j	8000311c <balloc+0x54>
    brelse(bp);
    80003102:	854a                	mv	a0,s2
    80003104:	00000097          	auipc	ra,0x0
    80003108:	e32080e7          	jalr	-462(ra) # 80002f36 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000310c:	015c87bb          	addw	a5,s9,s5
    80003110:	00078a9b          	sext.w	s5,a5
    80003114:	004b2703          	lw	a4,4(s6)
    80003118:	06eaf363          	bgeu	s5,a4,8000317e <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    8000311c:	41fad79b          	sraiw	a5,s5,0x1f
    80003120:	0137d79b          	srliw	a5,a5,0x13
    80003124:	015787bb          	addw	a5,a5,s5
    80003128:	40d7d79b          	sraiw	a5,a5,0xd
    8000312c:	01cb2583          	lw	a1,28(s6)
    80003130:	9dbd                	addw	a1,a1,a5
    80003132:	855e                	mv	a0,s7
    80003134:	00000097          	auipc	ra,0x0
    80003138:	cd2080e7          	jalr	-814(ra) # 80002e06 <bread>
    8000313c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000313e:	004b2503          	lw	a0,4(s6)
    80003142:	000a849b          	sext.w	s1,s5
    80003146:	8662                	mv	a2,s8
    80003148:	faa4fde3          	bgeu	s1,a0,80003102 <balloc+0x3a>
      m = 1 << (bi % 8);
    8000314c:	41f6579b          	sraiw	a5,a2,0x1f
    80003150:	01d7d69b          	srliw	a3,a5,0x1d
    80003154:	00c6873b          	addw	a4,a3,a2
    80003158:	00777793          	andi	a5,a4,7
    8000315c:	9f95                	subw	a5,a5,a3
    8000315e:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003162:	4037571b          	sraiw	a4,a4,0x3
    80003166:	00e906b3          	add	a3,s2,a4
    8000316a:	0586c683          	lbu	a3,88(a3)
    8000316e:	00d7f5b3          	and	a1,a5,a3
    80003172:	cd91                	beqz	a1,8000318e <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003174:	2605                	addiw	a2,a2,1
    80003176:	2485                	addiw	s1,s1,1
    80003178:	fd4618e3          	bne	a2,s4,80003148 <balloc+0x80>
    8000317c:	b759                	j	80003102 <balloc+0x3a>
  panic("balloc: out of blocks");
    8000317e:	00005517          	auipc	a0,0x5
    80003182:	3aa50513          	addi	a0,a0,938 # 80008528 <syscalls+0x100>
    80003186:	ffffd097          	auipc	ra,0xffffd
    8000318a:	3c2080e7          	jalr	962(ra) # 80000548 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000318e:	974a                	add	a4,a4,s2
    80003190:	8fd5                	or	a5,a5,a3
    80003192:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    80003196:	854a                	mv	a0,s2
    80003198:	00001097          	auipc	ra,0x1
    8000319c:	002080e7          	jalr	2(ra) # 8000419a <log_write>
        brelse(bp);
    800031a0:	854a                	mv	a0,s2
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	d94080e7          	jalr	-620(ra) # 80002f36 <brelse>
  bp = bread(dev, bno);
    800031aa:	85a6                	mv	a1,s1
    800031ac:	855e                	mv	a0,s7
    800031ae:	00000097          	auipc	ra,0x0
    800031b2:	c58080e7          	jalr	-936(ra) # 80002e06 <bread>
    800031b6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800031b8:	40000613          	li	a2,1024
    800031bc:	4581                	li	a1,0
    800031be:	05850513          	addi	a0,a0,88
    800031c2:	ffffe097          	auipc	ra,0xffffe
    800031c6:	b4a080e7          	jalr	-1206(ra) # 80000d0c <memset>
  log_write(bp);
    800031ca:	854a                	mv	a0,s2
    800031cc:	00001097          	auipc	ra,0x1
    800031d0:	fce080e7          	jalr	-50(ra) # 8000419a <log_write>
  brelse(bp);
    800031d4:	854a                	mv	a0,s2
    800031d6:	00000097          	auipc	ra,0x0
    800031da:	d60080e7          	jalr	-672(ra) # 80002f36 <brelse>
}
    800031de:	8526                	mv	a0,s1
    800031e0:	60e6                	ld	ra,88(sp)
    800031e2:	6446                	ld	s0,80(sp)
    800031e4:	64a6                	ld	s1,72(sp)
    800031e6:	6906                	ld	s2,64(sp)
    800031e8:	79e2                	ld	s3,56(sp)
    800031ea:	7a42                	ld	s4,48(sp)
    800031ec:	7aa2                	ld	s5,40(sp)
    800031ee:	7b02                	ld	s6,32(sp)
    800031f0:	6be2                	ld	s7,24(sp)
    800031f2:	6c42                	ld	s8,16(sp)
    800031f4:	6ca2                	ld	s9,8(sp)
    800031f6:	6125                	addi	sp,sp,96
    800031f8:	8082                	ret

00000000800031fa <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    800031fa:	7179                	addi	sp,sp,-48
    800031fc:	f406                	sd	ra,40(sp)
    800031fe:	f022                	sd	s0,32(sp)
    80003200:	ec26                	sd	s1,24(sp)
    80003202:	e84a                	sd	s2,16(sp)
    80003204:	e44e                	sd	s3,8(sp)
    80003206:	e052                	sd	s4,0(sp)
    80003208:	1800                	addi	s0,sp,48
    8000320a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000320c:	47ad                	li	a5,11
    8000320e:	04b7fe63          	bgeu	a5,a1,8000326a <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80003212:	ff45849b          	addiw	s1,a1,-12
    80003216:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000321a:	0ff00793          	li	a5,255
    8000321e:	0ae7e363          	bltu	a5,a4,800032c4 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80003222:	08052583          	lw	a1,128(a0)
    80003226:	c5ad                	beqz	a1,80003290 <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    80003228:	00092503          	lw	a0,0(s2)
    8000322c:	00000097          	auipc	ra,0x0
    80003230:	bda080e7          	jalr	-1062(ra) # 80002e06 <bread>
    80003234:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003236:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000323a:	02049593          	slli	a1,s1,0x20
    8000323e:	9181                	srli	a1,a1,0x20
    80003240:	058a                	slli	a1,a1,0x2
    80003242:	00b784b3          	add	s1,a5,a1
    80003246:	0004a983          	lw	s3,0(s1)
    8000324a:	04098d63          	beqz	s3,800032a4 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    8000324e:	8552                	mv	a0,s4
    80003250:	00000097          	auipc	ra,0x0
    80003254:	ce6080e7          	jalr	-794(ra) # 80002f36 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    80003258:	854e                	mv	a0,s3
    8000325a:	70a2                	ld	ra,40(sp)
    8000325c:	7402                	ld	s0,32(sp)
    8000325e:	64e2                	ld	s1,24(sp)
    80003260:	6942                	ld	s2,16(sp)
    80003262:	69a2                	ld	s3,8(sp)
    80003264:	6a02                	ld	s4,0(sp)
    80003266:	6145                	addi	sp,sp,48
    80003268:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    8000326a:	02059493          	slli	s1,a1,0x20
    8000326e:	9081                	srli	s1,s1,0x20
    80003270:	048a                	slli	s1,s1,0x2
    80003272:	94aa                	add	s1,s1,a0
    80003274:	0504a983          	lw	s3,80(s1)
    80003278:	fe0990e3          	bnez	s3,80003258 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    8000327c:	4108                	lw	a0,0(a0)
    8000327e:	00000097          	auipc	ra,0x0
    80003282:	e4a080e7          	jalr	-438(ra) # 800030c8 <balloc>
    80003286:	0005099b          	sext.w	s3,a0
    8000328a:	0534a823          	sw	s3,80(s1)
    8000328e:	b7e9                	j	80003258 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    80003290:	4108                	lw	a0,0(a0)
    80003292:	00000097          	auipc	ra,0x0
    80003296:	e36080e7          	jalr	-458(ra) # 800030c8 <balloc>
    8000329a:	0005059b          	sext.w	a1,a0
    8000329e:	08b92023          	sw	a1,128(s2)
    800032a2:	b759                	j	80003228 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    800032a4:	00092503          	lw	a0,0(s2)
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	e20080e7          	jalr	-480(ra) # 800030c8 <balloc>
    800032b0:	0005099b          	sext.w	s3,a0
    800032b4:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    800032b8:	8552                	mv	a0,s4
    800032ba:	00001097          	auipc	ra,0x1
    800032be:	ee0080e7          	jalr	-288(ra) # 8000419a <log_write>
    800032c2:	b771                	j	8000324e <bmap+0x54>
  panic("bmap: out of range");
    800032c4:	00005517          	auipc	a0,0x5
    800032c8:	27c50513          	addi	a0,a0,636 # 80008540 <syscalls+0x118>
    800032cc:	ffffd097          	auipc	ra,0xffffd
    800032d0:	27c080e7          	jalr	636(ra) # 80000548 <panic>

00000000800032d4 <iget>:
{
    800032d4:	7179                	addi	sp,sp,-48
    800032d6:	f406                	sd	ra,40(sp)
    800032d8:	f022                	sd	s0,32(sp)
    800032da:	ec26                	sd	s1,24(sp)
    800032dc:	e84a                	sd	s2,16(sp)
    800032de:	e44e                	sd	s3,8(sp)
    800032e0:	e052                	sd	s4,0(sp)
    800032e2:	1800                	addi	s0,sp,48
    800032e4:	89aa                	mv	s3,a0
    800032e6:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    800032e8:	0001d517          	auipc	a0,0x1d
    800032ec:	b7850513          	addi	a0,a0,-1160 # 8001fe60 <icache>
    800032f0:	ffffe097          	auipc	ra,0xffffe
    800032f4:	920080e7          	jalr	-1760(ra) # 80000c10 <acquire>
  empty = 0;
    800032f8:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    800032fa:	0001d497          	auipc	s1,0x1d
    800032fe:	b7e48493          	addi	s1,s1,-1154 # 8001fe78 <icache+0x18>
    80003302:	0001e697          	auipc	a3,0x1e
    80003306:	60668693          	addi	a3,a3,1542 # 80021908 <log>
    8000330a:	a039                	j	80003318 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000330c:	02090b63          	beqz	s2,80003342 <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003310:	08848493          	addi	s1,s1,136
    80003314:	02d48a63          	beq	s1,a3,80003348 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003318:	449c                	lw	a5,8(s1)
    8000331a:	fef059e3          	blez	a5,8000330c <iget+0x38>
    8000331e:	4098                	lw	a4,0(s1)
    80003320:	ff3716e3          	bne	a4,s3,8000330c <iget+0x38>
    80003324:	40d8                	lw	a4,4(s1)
    80003326:	ff4713e3          	bne	a4,s4,8000330c <iget+0x38>
      ip->ref++;
    8000332a:	2785                	addiw	a5,a5,1
    8000332c:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    8000332e:	0001d517          	auipc	a0,0x1d
    80003332:	b3250513          	addi	a0,a0,-1230 # 8001fe60 <icache>
    80003336:	ffffe097          	auipc	ra,0xffffe
    8000333a:	98e080e7          	jalr	-1650(ra) # 80000cc4 <release>
      return ip;
    8000333e:	8926                	mv	s2,s1
    80003340:	a03d                	j	8000336e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003342:	f7f9                	bnez	a5,80003310 <iget+0x3c>
    80003344:	8926                	mv	s2,s1
    80003346:	b7e9                	j	80003310 <iget+0x3c>
  if(empty == 0)
    80003348:	02090c63          	beqz	s2,80003380 <iget+0xac>
  ip->dev = dev;
    8000334c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003350:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003354:	4785                	li	a5,1
    80003356:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000335a:	04092023          	sw	zero,64(s2)
  release(&icache.lock);
    8000335e:	0001d517          	auipc	a0,0x1d
    80003362:	b0250513          	addi	a0,a0,-1278 # 8001fe60 <icache>
    80003366:	ffffe097          	auipc	ra,0xffffe
    8000336a:	95e080e7          	jalr	-1698(ra) # 80000cc4 <release>
}
    8000336e:	854a                	mv	a0,s2
    80003370:	70a2                	ld	ra,40(sp)
    80003372:	7402                	ld	s0,32(sp)
    80003374:	64e2                	ld	s1,24(sp)
    80003376:	6942                	ld	s2,16(sp)
    80003378:	69a2                	ld	s3,8(sp)
    8000337a:	6a02                	ld	s4,0(sp)
    8000337c:	6145                	addi	sp,sp,48
    8000337e:	8082                	ret
    panic("iget: no inodes");
    80003380:	00005517          	auipc	a0,0x5
    80003384:	1d850513          	addi	a0,a0,472 # 80008558 <syscalls+0x130>
    80003388:	ffffd097          	auipc	ra,0xffffd
    8000338c:	1c0080e7          	jalr	448(ra) # 80000548 <panic>

0000000080003390 <fsinit>:
fsinit(int dev) {
    80003390:	7179                	addi	sp,sp,-48
    80003392:	f406                	sd	ra,40(sp)
    80003394:	f022                	sd	s0,32(sp)
    80003396:	ec26                	sd	s1,24(sp)
    80003398:	e84a                	sd	s2,16(sp)
    8000339a:	e44e                	sd	s3,8(sp)
    8000339c:	1800                	addi	s0,sp,48
    8000339e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800033a0:	4585                	li	a1,1
    800033a2:	00000097          	auipc	ra,0x0
    800033a6:	a64080e7          	jalr	-1436(ra) # 80002e06 <bread>
    800033aa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800033ac:	0001d997          	auipc	s3,0x1d
    800033b0:	a9498993          	addi	s3,s3,-1388 # 8001fe40 <sb>
    800033b4:	02000613          	li	a2,32
    800033b8:	05850593          	addi	a1,a0,88
    800033bc:	854e                	mv	a0,s3
    800033be:	ffffe097          	auipc	ra,0xffffe
    800033c2:	9ae080e7          	jalr	-1618(ra) # 80000d6c <memmove>
  brelse(bp);
    800033c6:	8526                	mv	a0,s1
    800033c8:	00000097          	auipc	ra,0x0
    800033cc:	b6e080e7          	jalr	-1170(ra) # 80002f36 <brelse>
  if(sb.magic != FSMAGIC)
    800033d0:	0009a703          	lw	a4,0(s3)
    800033d4:	102037b7          	lui	a5,0x10203
    800033d8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800033dc:	02f71263          	bne	a4,a5,80003400 <fsinit+0x70>
  initlog(dev, &sb);
    800033e0:	0001d597          	auipc	a1,0x1d
    800033e4:	a6058593          	addi	a1,a1,-1440 # 8001fe40 <sb>
    800033e8:	854a                	mv	a0,s2
    800033ea:	00001097          	auipc	ra,0x1
    800033ee:	b38080e7          	jalr	-1224(ra) # 80003f22 <initlog>
}
    800033f2:	70a2                	ld	ra,40(sp)
    800033f4:	7402                	ld	s0,32(sp)
    800033f6:	64e2                	ld	s1,24(sp)
    800033f8:	6942                	ld	s2,16(sp)
    800033fa:	69a2                	ld	s3,8(sp)
    800033fc:	6145                	addi	sp,sp,48
    800033fe:	8082                	ret
    panic("invalid file system");
    80003400:	00005517          	auipc	a0,0x5
    80003404:	16850513          	addi	a0,a0,360 # 80008568 <syscalls+0x140>
    80003408:	ffffd097          	auipc	ra,0xffffd
    8000340c:	140080e7          	jalr	320(ra) # 80000548 <panic>

0000000080003410 <iinit>:
{
    80003410:	7179                	addi	sp,sp,-48
    80003412:	f406                	sd	ra,40(sp)
    80003414:	f022                	sd	s0,32(sp)
    80003416:	ec26                	sd	s1,24(sp)
    80003418:	e84a                	sd	s2,16(sp)
    8000341a:	e44e                	sd	s3,8(sp)
    8000341c:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000341e:	00005597          	auipc	a1,0x5
    80003422:	16258593          	addi	a1,a1,354 # 80008580 <syscalls+0x158>
    80003426:	0001d517          	auipc	a0,0x1d
    8000342a:	a3a50513          	addi	a0,a0,-1478 # 8001fe60 <icache>
    8000342e:	ffffd097          	auipc	ra,0xffffd
    80003432:	752080e7          	jalr	1874(ra) # 80000b80 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003436:	0001d497          	auipc	s1,0x1d
    8000343a:	a5248493          	addi	s1,s1,-1454 # 8001fe88 <icache+0x28>
    8000343e:	0001e997          	auipc	s3,0x1e
    80003442:	4da98993          	addi	s3,s3,1242 # 80021918 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    80003446:	00005917          	auipc	s2,0x5
    8000344a:	14290913          	addi	s2,s2,322 # 80008588 <syscalls+0x160>
    8000344e:	85ca                	mv	a1,s2
    80003450:	8526                	mv	a0,s1
    80003452:	00001097          	auipc	ra,0x1
    80003456:	e36080e7          	jalr	-458(ra) # 80004288 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000345a:	08848493          	addi	s1,s1,136
    8000345e:	ff3498e3          	bne	s1,s3,8000344e <iinit+0x3e>
}
    80003462:	70a2                	ld	ra,40(sp)
    80003464:	7402                	ld	s0,32(sp)
    80003466:	64e2                	ld	s1,24(sp)
    80003468:	6942                	ld	s2,16(sp)
    8000346a:	69a2                	ld	s3,8(sp)
    8000346c:	6145                	addi	sp,sp,48
    8000346e:	8082                	ret

0000000080003470 <ialloc>:
{
    80003470:	715d                	addi	sp,sp,-80
    80003472:	e486                	sd	ra,72(sp)
    80003474:	e0a2                	sd	s0,64(sp)
    80003476:	fc26                	sd	s1,56(sp)
    80003478:	f84a                	sd	s2,48(sp)
    8000347a:	f44e                	sd	s3,40(sp)
    8000347c:	f052                	sd	s4,32(sp)
    8000347e:	ec56                	sd	s5,24(sp)
    80003480:	e85a                	sd	s6,16(sp)
    80003482:	e45e                	sd	s7,8(sp)
    80003484:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003486:	0001d717          	auipc	a4,0x1d
    8000348a:	9c672703          	lw	a4,-1594(a4) # 8001fe4c <sb+0xc>
    8000348e:	4785                	li	a5,1
    80003490:	04e7fa63          	bgeu	a5,a4,800034e4 <ialloc+0x74>
    80003494:	8aaa                	mv	s5,a0
    80003496:	8bae                	mv	s7,a1
    80003498:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    8000349a:	0001da17          	auipc	s4,0x1d
    8000349e:	9a6a0a13          	addi	s4,s4,-1626 # 8001fe40 <sb>
    800034a2:	00048b1b          	sext.w	s6,s1
    800034a6:	0044d593          	srli	a1,s1,0x4
    800034aa:	018a2783          	lw	a5,24(s4)
    800034ae:	9dbd                	addw	a1,a1,a5
    800034b0:	8556                	mv	a0,s5
    800034b2:	00000097          	auipc	ra,0x0
    800034b6:	954080e7          	jalr	-1708(ra) # 80002e06 <bread>
    800034ba:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034bc:	05850993          	addi	s3,a0,88
    800034c0:	00f4f793          	andi	a5,s1,15
    800034c4:	079a                	slli	a5,a5,0x6
    800034c6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034c8:	00099783          	lh	a5,0(s3)
    800034cc:	c785                	beqz	a5,800034f4 <ialloc+0x84>
    brelse(bp);
    800034ce:	00000097          	auipc	ra,0x0
    800034d2:	a68080e7          	jalr	-1432(ra) # 80002f36 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034d6:	0485                	addi	s1,s1,1
    800034d8:	00ca2703          	lw	a4,12(s4)
    800034dc:	0004879b          	sext.w	a5,s1
    800034e0:	fce7e1e3          	bltu	a5,a4,800034a2 <ialloc+0x32>
  panic("ialloc: no inodes");
    800034e4:	00005517          	auipc	a0,0x5
    800034e8:	0ac50513          	addi	a0,a0,172 # 80008590 <syscalls+0x168>
    800034ec:	ffffd097          	auipc	ra,0xffffd
    800034f0:	05c080e7          	jalr	92(ra) # 80000548 <panic>
      memset(dip, 0, sizeof(*dip));
    800034f4:	04000613          	li	a2,64
    800034f8:	4581                	li	a1,0
    800034fa:	854e                	mv	a0,s3
    800034fc:	ffffe097          	auipc	ra,0xffffe
    80003500:	810080e7          	jalr	-2032(ra) # 80000d0c <memset>
      dip->type = type;
    80003504:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003508:	854a                	mv	a0,s2
    8000350a:	00001097          	auipc	ra,0x1
    8000350e:	c90080e7          	jalr	-880(ra) # 8000419a <log_write>
      brelse(bp);
    80003512:	854a                	mv	a0,s2
    80003514:	00000097          	auipc	ra,0x0
    80003518:	a22080e7          	jalr	-1502(ra) # 80002f36 <brelse>
      return iget(dev, inum);
    8000351c:	85da                	mv	a1,s6
    8000351e:	8556                	mv	a0,s5
    80003520:	00000097          	auipc	ra,0x0
    80003524:	db4080e7          	jalr	-588(ra) # 800032d4 <iget>
}
    80003528:	60a6                	ld	ra,72(sp)
    8000352a:	6406                	ld	s0,64(sp)
    8000352c:	74e2                	ld	s1,56(sp)
    8000352e:	7942                	ld	s2,48(sp)
    80003530:	79a2                	ld	s3,40(sp)
    80003532:	7a02                	ld	s4,32(sp)
    80003534:	6ae2                	ld	s5,24(sp)
    80003536:	6b42                	ld	s6,16(sp)
    80003538:	6ba2                	ld	s7,8(sp)
    8000353a:	6161                	addi	sp,sp,80
    8000353c:	8082                	ret

000000008000353e <iupdate>:
{
    8000353e:	1101                	addi	sp,sp,-32
    80003540:	ec06                	sd	ra,24(sp)
    80003542:	e822                	sd	s0,16(sp)
    80003544:	e426                	sd	s1,8(sp)
    80003546:	e04a                	sd	s2,0(sp)
    80003548:	1000                	addi	s0,sp,32
    8000354a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000354c:	415c                	lw	a5,4(a0)
    8000354e:	0047d79b          	srliw	a5,a5,0x4
    80003552:	0001d597          	auipc	a1,0x1d
    80003556:	9065a583          	lw	a1,-1786(a1) # 8001fe58 <sb+0x18>
    8000355a:	9dbd                	addw	a1,a1,a5
    8000355c:	4108                	lw	a0,0(a0)
    8000355e:	00000097          	auipc	ra,0x0
    80003562:	8a8080e7          	jalr	-1880(ra) # 80002e06 <bread>
    80003566:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003568:	05850793          	addi	a5,a0,88
    8000356c:	40c8                	lw	a0,4(s1)
    8000356e:	893d                	andi	a0,a0,15
    80003570:	051a                	slli	a0,a0,0x6
    80003572:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80003574:	04449703          	lh	a4,68(s1)
    80003578:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    8000357c:	04649703          	lh	a4,70(s1)
    80003580:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003584:	04849703          	lh	a4,72(s1)
    80003588:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    8000358c:	04a49703          	lh	a4,74(s1)
    80003590:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003594:	44f8                	lw	a4,76(s1)
    80003596:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003598:	03400613          	li	a2,52
    8000359c:	05048593          	addi	a1,s1,80
    800035a0:	0531                	addi	a0,a0,12
    800035a2:	ffffd097          	auipc	ra,0xffffd
    800035a6:	7ca080e7          	jalr	1994(ra) # 80000d6c <memmove>
  log_write(bp);
    800035aa:	854a                	mv	a0,s2
    800035ac:	00001097          	auipc	ra,0x1
    800035b0:	bee080e7          	jalr	-1042(ra) # 8000419a <log_write>
  brelse(bp);
    800035b4:	854a                	mv	a0,s2
    800035b6:	00000097          	auipc	ra,0x0
    800035ba:	980080e7          	jalr	-1664(ra) # 80002f36 <brelse>
}
    800035be:	60e2                	ld	ra,24(sp)
    800035c0:	6442                	ld	s0,16(sp)
    800035c2:	64a2                	ld	s1,8(sp)
    800035c4:	6902                	ld	s2,0(sp)
    800035c6:	6105                	addi	sp,sp,32
    800035c8:	8082                	ret

00000000800035ca <idup>:
{
    800035ca:	1101                	addi	sp,sp,-32
    800035cc:	ec06                	sd	ra,24(sp)
    800035ce:	e822                	sd	s0,16(sp)
    800035d0:	e426                	sd	s1,8(sp)
    800035d2:	1000                	addi	s0,sp,32
    800035d4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800035d6:	0001d517          	auipc	a0,0x1d
    800035da:	88a50513          	addi	a0,a0,-1910 # 8001fe60 <icache>
    800035de:	ffffd097          	auipc	ra,0xffffd
    800035e2:	632080e7          	jalr	1586(ra) # 80000c10 <acquire>
  ip->ref++;
    800035e6:	449c                	lw	a5,8(s1)
    800035e8:	2785                	addiw	a5,a5,1
    800035ea:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800035ec:	0001d517          	auipc	a0,0x1d
    800035f0:	87450513          	addi	a0,a0,-1932 # 8001fe60 <icache>
    800035f4:	ffffd097          	auipc	ra,0xffffd
    800035f8:	6d0080e7          	jalr	1744(ra) # 80000cc4 <release>
}
    800035fc:	8526                	mv	a0,s1
    800035fe:	60e2                	ld	ra,24(sp)
    80003600:	6442                	ld	s0,16(sp)
    80003602:	64a2                	ld	s1,8(sp)
    80003604:	6105                	addi	sp,sp,32
    80003606:	8082                	ret

0000000080003608 <ilock>:
{
    80003608:	1101                	addi	sp,sp,-32
    8000360a:	ec06                	sd	ra,24(sp)
    8000360c:	e822                	sd	s0,16(sp)
    8000360e:	e426                	sd	s1,8(sp)
    80003610:	e04a                	sd	s2,0(sp)
    80003612:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003614:	c115                	beqz	a0,80003638 <ilock+0x30>
    80003616:	84aa                	mv	s1,a0
    80003618:	451c                	lw	a5,8(a0)
    8000361a:	00f05f63          	blez	a5,80003638 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000361e:	0541                	addi	a0,a0,16
    80003620:	00001097          	auipc	ra,0x1
    80003624:	ca2080e7          	jalr	-862(ra) # 800042c2 <acquiresleep>
  if(ip->valid == 0){
    80003628:	40bc                	lw	a5,64(s1)
    8000362a:	cf99                	beqz	a5,80003648 <ilock+0x40>
}
    8000362c:	60e2                	ld	ra,24(sp)
    8000362e:	6442                	ld	s0,16(sp)
    80003630:	64a2                	ld	s1,8(sp)
    80003632:	6902                	ld	s2,0(sp)
    80003634:	6105                	addi	sp,sp,32
    80003636:	8082                	ret
    panic("ilock");
    80003638:	00005517          	auipc	a0,0x5
    8000363c:	f7050513          	addi	a0,a0,-144 # 800085a8 <syscalls+0x180>
    80003640:	ffffd097          	auipc	ra,0xffffd
    80003644:	f08080e7          	jalr	-248(ra) # 80000548 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003648:	40dc                	lw	a5,4(s1)
    8000364a:	0047d79b          	srliw	a5,a5,0x4
    8000364e:	0001d597          	auipc	a1,0x1d
    80003652:	80a5a583          	lw	a1,-2038(a1) # 8001fe58 <sb+0x18>
    80003656:	9dbd                	addw	a1,a1,a5
    80003658:	4088                	lw	a0,0(s1)
    8000365a:	fffff097          	auipc	ra,0xfffff
    8000365e:	7ac080e7          	jalr	1964(ra) # 80002e06 <bread>
    80003662:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003664:	05850593          	addi	a1,a0,88
    80003668:	40dc                	lw	a5,4(s1)
    8000366a:	8bbd                	andi	a5,a5,15
    8000366c:	079a                	slli	a5,a5,0x6
    8000366e:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003670:	00059783          	lh	a5,0(a1)
    80003674:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003678:	00259783          	lh	a5,2(a1)
    8000367c:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003680:	00459783          	lh	a5,4(a1)
    80003684:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003688:	00659783          	lh	a5,6(a1)
    8000368c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003690:	459c                	lw	a5,8(a1)
    80003692:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003694:	03400613          	li	a2,52
    80003698:	05b1                	addi	a1,a1,12
    8000369a:	05048513          	addi	a0,s1,80
    8000369e:	ffffd097          	auipc	ra,0xffffd
    800036a2:	6ce080e7          	jalr	1742(ra) # 80000d6c <memmove>
    brelse(bp);
    800036a6:	854a                	mv	a0,s2
    800036a8:	00000097          	auipc	ra,0x0
    800036ac:	88e080e7          	jalr	-1906(ra) # 80002f36 <brelse>
    ip->valid = 1;
    800036b0:	4785                	li	a5,1
    800036b2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800036b4:	04449783          	lh	a5,68(s1)
    800036b8:	fbb5                	bnez	a5,8000362c <ilock+0x24>
      panic("ilock: no type");
    800036ba:	00005517          	auipc	a0,0x5
    800036be:	ef650513          	addi	a0,a0,-266 # 800085b0 <syscalls+0x188>
    800036c2:	ffffd097          	auipc	ra,0xffffd
    800036c6:	e86080e7          	jalr	-378(ra) # 80000548 <panic>

00000000800036ca <iunlock>:
{
    800036ca:	1101                	addi	sp,sp,-32
    800036cc:	ec06                	sd	ra,24(sp)
    800036ce:	e822                	sd	s0,16(sp)
    800036d0:	e426                	sd	s1,8(sp)
    800036d2:	e04a                	sd	s2,0(sp)
    800036d4:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036d6:	c905                	beqz	a0,80003706 <iunlock+0x3c>
    800036d8:	84aa                	mv	s1,a0
    800036da:	01050913          	addi	s2,a0,16
    800036de:	854a                	mv	a0,s2
    800036e0:	00001097          	auipc	ra,0x1
    800036e4:	c7c080e7          	jalr	-900(ra) # 8000435c <holdingsleep>
    800036e8:	cd19                	beqz	a0,80003706 <iunlock+0x3c>
    800036ea:	449c                	lw	a5,8(s1)
    800036ec:	00f05d63          	blez	a5,80003706 <iunlock+0x3c>
  releasesleep(&ip->lock);
    800036f0:	854a                	mv	a0,s2
    800036f2:	00001097          	auipc	ra,0x1
    800036f6:	c26080e7          	jalr	-986(ra) # 80004318 <releasesleep>
}
    800036fa:	60e2                	ld	ra,24(sp)
    800036fc:	6442                	ld	s0,16(sp)
    800036fe:	64a2                	ld	s1,8(sp)
    80003700:	6902                	ld	s2,0(sp)
    80003702:	6105                	addi	sp,sp,32
    80003704:	8082                	ret
    panic("iunlock");
    80003706:	00005517          	auipc	a0,0x5
    8000370a:	eba50513          	addi	a0,a0,-326 # 800085c0 <syscalls+0x198>
    8000370e:	ffffd097          	auipc	ra,0xffffd
    80003712:	e3a080e7          	jalr	-454(ra) # 80000548 <panic>

0000000080003716 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003716:	7179                	addi	sp,sp,-48
    80003718:	f406                	sd	ra,40(sp)
    8000371a:	f022                	sd	s0,32(sp)
    8000371c:	ec26                	sd	s1,24(sp)
    8000371e:	e84a                	sd	s2,16(sp)
    80003720:	e44e                	sd	s3,8(sp)
    80003722:	e052                	sd	s4,0(sp)
    80003724:	1800                	addi	s0,sp,48
    80003726:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003728:	05050493          	addi	s1,a0,80
    8000372c:	08050913          	addi	s2,a0,128
    80003730:	a021                	j	80003738 <itrunc+0x22>
    80003732:	0491                	addi	s1,s1,4
    80003734:	01248d63          	beq	s1,s2,8000374e <itrunc+0x38>
    if(ip->addrs[i]){
    80003738:	408c                	lw	a1,0(s1)
    8000373a:	dde5                	beqz	a1,80003732 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    8000373c:	0009a503          	lw	a0,0(s3)
    80003740:	00000097          	auipc	ra,0x0
    80003744:	90c080e7          	jalr	-1780(ra) # 8000304c <bfree>
      ip->addrs[i] = 0;
    80003748:	0004a023          	sw	zero,0(s1)
    8000374c:	b7dd                	j	80003732 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000374e:	0809a583          	lw	a1,128(s3)
    80003752:	e185                	bnez	a1,80003772 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003754:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003758:	854e                	mv	a0,s3
    8000375a:	00000097          	auipc	ra,0x0
    8000375e:	de4080e7          	jalr	-540(ra) # 8000353e <iupdate>
}
    80003762:	70a2                	ld	ra,40(sp)
    80003764:	7402                	ld	s0,32(sp)
    80003766:	64e2                	ld	s1,24(sp)
    80003768:	6942                	ld	s2,16(sp)
    8000376a:	69a2                	ld	s3,8(sp)
    8000376c:	6a02                	ld	s4,0(sp)
    8000376e:	6145                	addi	sp,sp,48
    80003770:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003772:	0009a503          	lw	a0,0(s3)
    80003776:	fffff097          	auipc	ra,0xfffff
    8000377a:	690080e7          	jalr	1680(ra) # 80002e06 <bread>
    8000377e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003780:	05850493          	addi	s1,a0,88
    80003784:	45850913          	addi	s2,a0,1112
    80003788:	a811                	j	8000379c <itrunc+0x86>
        bfree(ip->dev, a[j]);
    8000378a:	0009a503          	lw	a0,0(s3)
    8000378e:	00000097          	auipc	ra,0x0
    80003792:	8be080e7          	jalr	-1858(ra) # 8000304c <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003796:	0491                	addi	s1,s1,4
    80003798:	01248563          	beq	s1,s2,800037a2 <itrunc+0x8c>
      if(a[j])
    8000379c:	408c                	lw	a1,0(s1)
    8000379e:	dde5                	beqz	a1,80003796 <itrunc+0x80>
    800037a0:	b7ed                	j	8000378a <itrunc+0x74>
    brelse(bp);
    800037a2:	8552                	mv	a0,s4
    800037a4:	fffff097          	auipc	ra,0xfffff
    800037a8:	792080e7          	jalr	1938(ra) # 80002f36 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800037ac:	0809a583          	lw	a1,128(s3)
    800037b0:	0009a503          	lw	a0,0(s3)
    800037b4:	00000097          	auipc	ra,0x0
    800037b8:	898080e7          	jalr	-1896(ra) # 8000304c <bfree>
    ip->addrs[NDIRECT] = 0;
    800037bc:	0809a023          	sw	zero,128(s3)
    800037c0:	bf51                	j	80003754 <itrunc+0x3e>

00000000800037c2 <iput>:
{
    800037c2:	1101                	addi	sp,sp,-32
    800037c4:	ec06                	sd	ra,24(sp)
    800037c6:	e822                	sd	s0,16(sp)
    800037c8:	e426                	sd	s1,8(sp)
    800037ca:	e04a                	sd	s2,0(sp)
    800037cc:	1000                	addi	s0,sp,32
    800037ce:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800037d0:	0001c517          	auipc	a0,0x1c
    800037d4:	69050513          	addi	a0,a0,1680 # 8001fe60 <icache>
    800037d8:	ffffd097          	auipc	ra,0xffffd
    800037dc:	438080e7          	jalr	1080(ra) # 80000c10 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037e0:	4498                	lw	a4,8(s1)
    800037e2:	4785                	li	a5,1
    800037e4:	02f70363          	beq	a4,a5,8000380a <iput+0x48>
  ip->ref--;
    800037e8:	449c                	lw	a5,8(s1)
    800037ea:	37fd                	addiw	a5,a5,-1
    800037ec:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800037ee:	0001c517          	auipc	a0,0x1c
    800037f2:	67250513          	addi	a0,a0,1650 # 8001fe60 <icache>
    800037f6:	ffffd097          	auipc	ra,0xffffd
    800037fa:	4ce080e7          	jalr	1230(ra) # 80000cc4 <release>
}
    800037fe:	60e2                	ld	ra,24(sp)
    80003800:	6442                	ld	s0,16(sp)
    80003802:	64a2                	ld	s1,8(sp)
    80003804:	6902                	ld	s2,0(sp)
    80003806:	6105                	addi	sp,sp,32
    80003808:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000380a:	40bc                	lw	a5,64(s1)
    8000380c:	dff1                	beqz	a5,800037e8 <iput+0x26>
    8000380e:	04a49783          	lh	a5,74(s1)
    80003812:	fbf9                	bnez	a5,800037e8 <iput+0x26>
    acquiresleep(&ip->lock);
    80003814:	01048913          	addi	s2,s1,16
    80003818:	854a                	mv	a0,s2
    8000381a:	00001097          	auipc	ra,0x1
    8000381e:	aa8080e7          	jalr	-1368(ra) # 800042c2 <acquiresleep>
    release(&icache.lock);
    80003822:	0001c517          	auipc	a0,0x1c
    80003826:	63e50513          	addi	a0,a0,1598 # 8001fe60 <icache>
    8000382a:	ffffd097          	auipc	ra,0xffffd
    8000382e:	49a080e7          	jalr	1178(ra) # 80000cc4 <release>
    itrunc(ip);
    80003832:	8526                	mv	a0,s1
    80003834:	00000097          	auipc	ra,0x0
    80003838:	ee2080e7          	jalr	-286(ra) # 80003716 <itrunc>
    ip->type = 0;
    8000383c:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003840:	8526                	mv	a0,s1
    80003842:	00000097          	auipc	ra,0x0
    80003846:	cfc080e7          	jalr	-772(ra) # 8000353e <iupdate>
    ip->valid = 0;
    8000384a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000384e:	854a                	mv	a0,s2
    80003850:	00001097          	auipc	ra,0x1
    80003854:	ac8080e7          	jalr	-1336(ra) # 80004318 <releasesleep>
    acquire(&icache.lock);
    80003858:	0001c517          	auipc	a0,0x1c
    8000385c:	60850513          	addi	a0,a0,1544 # 8001fe60 <icache>
    80003860:	ffffd097          	auipc	ra,0xffffd
    80003864:	3b0080e7          	jalr	944(ra) # 80000c10 <acquire>
    80003868:	b741                	j	800037e8 <iput+0x26>

000000008000386a <iunlockput>:
{
    8000386a:	1101                	addi	sp,sp,-32
    8000386c:	ec06                	sd	ra,24(sp)
    8000386e:	e822                	sd	s0,16(sp)
    80003870:	e426                	sd	s1,8(sp)
    80003872:	1000                	addi	s0,sp,32
    80003874:	84aa                	mv	s1,a0
  iunlock(ip);
    80003876:	00000097          	auipc	ra,0x0
    8000387a:	e54080e7          	jalr	-428(ra) # 800036ca <iunlock>
  iput(ip);
    8000387e:	8526                	mv	a0,s1
    80003880:	00000097          	auipc	ra,0x0
    80003884:	f42080e7          	jalr	-190(ra) # 800037c2 <iput>
}
    80003888:	60e2                	ld	ra,24(sp)
    8000388a:	6442                	ld	s0,16(sp)
    8000388c:	64a2                	ld	s1,8(sp)
    8000388e:	6105                	addi	sp,sp,32
    80003890:	8082                	ret

0000000080003892 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003892:	1141                	addi	sp,sp,-16
    80003894:	e422                	sd	s0,8(sp)
    80003896:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003898:	411c                	lw	a5,0(a0)
    8000389a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000389c:	415c                	lw	a5,4(a0)
    8000389e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800038a0:	04451783          	lh	a5,68(a0)
    800038a4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800038a8:	04a51783          	lh	a5,74(a0)
    800038ac:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800038b0:	04c56783          	lwu	a5,76(a0)
    800038b4:	e99c                	sd	a5,16(a1)
}
    800038b6:	6422                	ld	s0,8(sp)
    800038b8:	0141                	addi	sp,sp,16
    800038ba:	8082                	ret

00000000800038bc <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038bc:	457c                	lw	a5,76(a0)
    800038be:	0ed7e863          	bltu	a5,a3,800039ae <readi+0xf2>
{
    800038c2:	7159                	addi	sp,sp,-112
    800038c4:	f486                	sd	ra,104(sp)
    800038c6:	f0a2                	sd	s0,96(sp)
    800038c8:	eca6                	sd	s1,88(sp)
    800038ca:	e8ca                	sd	s2,80(sp)
    800038cc:	e4ce                	sd	s3,72(sp)
    800038ce:	e0d2                	sd	s4,64(sp)
    800038d0:	fc56                	sd	s5,56(sp)
    800038d2:	f85a                	sd	s6,48(sp)
    800038d4:	f45e                	sd	s7,40(sp)
    800038d6:	f062                	sd	s8,32(sp)
    800038d8:	ec66                	sd	s9,24(sp)
    800038da:	e86a                	sd	s10,16(sp)
    800038dc:	e46e                	sd	s11,8(sp)
    800038de:	1880                	addi	s0,sp,112
    800038e0:	8baa                	mv	s7,a0
    800038e2:	8c2e                	mv	s8,a1
    800038e4:	8ab2                	mv	s5,a2
    800038e6:	84b6                	mv	s1,a3
    800038e8:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800038ea:	9f35                	addw	a4,a4,a3
    return 0;
    800038ec:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800038ee:	08d76f63          	bltu	a4,a3,8000398c <readi+0xd0>
  if(off + n > ip->size)
    800038f2:	00e7f463          	bgeu	a5,a4,800038fa <readi+0x3e>
    n = ip->size - off;
    800038f6:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038fa:	0a0b0863          	beqz	s6,800039aa <readi+0xee>
    800038fe:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003900:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003904:	5cfd                	li	s9,-1
    80003906:	a82d                	j	80003940 <readi+0x84>
    80003908:	020a1d93          	slli	s11,s4,0x20
    8000390c:	020ddd93          	srli	s11,s11,0x20
    80003910:	05890613          	addi	a2,s2,88
    80003914:	86ee                	mv	a3,s11
    80003916:	963a                	add	a2,a2,a4
    80003918:	85d6                	mv	a1,s5
    8000391a:	8562                	mv	a0,s8
    8000391c:	fffff097          	auipc	ra,0xfffff
    80003920:	b2e080e7          	jalr	-1234(ra) # 8000244a <either_copyout>
    80003924:	05950d63          	beq	a0,s9,8000397e <readi+0xc2>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003928:	854a                	mv	a0,s2
    8000392a:	fffff097          	auipc	ra,0xfffff
    8000392e:	60c080e7          	jalr	1548(ra) # 80002f36 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003932:	013a09bb          	addw	s3,s4,s3
    80003936:	009a04bb          	addw	s1,s4,s1
    8000393a:	9aee                	add	s5,s5,s11
    8000393c:	0569f663          	bgeu	s3,s6,80003988 <readi+0xcc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003940:	000ba903          	lw	s2,0(s7)
    80003944:	00a4d59b          	srliw	a1,s1,0xa
    80003948:	855e                	mv	a0,s7
    8000394a:	00000097          	auipc	ra,0x0
    8000394e:	8b0080e7          	jalr	-1872(ra) # 800031fa <bmap>
    80003952:	0005059b          	sext.w	a1,a0
    80003956:	854a                	mv	a0,s2
    80003958:	fffff097          	auipc	ra,0xfffff
    8000395c:	4ae080e7          	jalr	1198(ra) # 80002e06 <bread>
    80003960:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003962:	3ff4f713          	andi	a4,s1,1023
    80003966:	40ed07bb          	subw	a5,s10,a4
    8000396a:	413b06bb          	subw	a3,s6,s3
    8000396e:	8a3e                	mv	s4,a5
    80003970:	2781                	sext.w	a5,a5
    80003972:	0006861b          	sext.w	a2,a3
    80003976:	f8f679e3          	bgeu	a2,a5,80003908 <readi+0x4c>
    8000397a:	8a36                	mv	s4,a3
    8000397c:	b771                	j	80003908 <readi+0x4c>
      brelse(bp);
    8000397e:	854a                	mv	a0,s2
    80003980:	fffff097          	auipc	ra,0xfffff
    80003984:	5b6080e7          	jalr	1462(ra) # 80002f36 <brelse>
  }
  return tot;
    80003988:	0009851b          	sext.w	a0,s3
}
    8000398c:	70a6                	ld	ra,104(sp)
    8000398e:	7406                	ld	s0,96(sp)
    80003990:	64e6                	ld	s1,88(sp)
    80003992:	6946                	ld	s2,80(sp)
    80003994:	69a6                	ld	s3,72(sp)
    80003996:	6a06                	ld	s4,64(sp)
    80003998:	7ae2                	ld	s5,56(sp)
    8000399a:	7b42                	ld	s6,48(sp)
    8000399c:	7ba2                	ld	s7,40(sp)
    8000399e:	7c02                	ld	s8,32(sp)
    800039a0:	6ce2                	ld	s9,24(sp)
    800039a2:	6d42                	ld	s10,16(sp)
    800039a4:	6da2                	ld	s11,8(sp)
    800039a6:	6165                	addi	sp,sp,112
    800039a8:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800039aa:	89da                	mv	s3,s6
    800039ac:	bff1                	j	80003988 <readi+0xcc>
    return 0;
    800039ae:	4501                	li	a0,0
}
    800039b0:	8082                	ret

00000000800039b2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800039b2:	457c                	lw	a5,76(a0)
    800039b4:	10d7e663          	bltu	a5,a3,80003ac0 <writei+0x10e>
{
    800039b8:	7159                	addi	sp,sp,-112
    800039ba:	f486                	sd	ra,104(sp)
    800039bc:	f0a2                	sd	s0,96(sp)
    800039be:	eca6                	sd	s1,88(sp)
    800039c0:	e8ca                	sd	s2,80(sp)
    800039c2:	e4ce                	sd	s3,72(sp)
    800039c4:	e0d2                	sd	s4,64(sp)
    800039c6:	fc56                	sd	s5,56(sp)
    800039c8:	f85a                	sd	s6,48(sp)
    800039ca:	f45e                	sd	s7,40(sp)
    800039cc:	f062                	sd	s8,32(sp)
    800039ce:	ec66                	sd	s9,24(sp)
    800039d0:	e86a                	sd	s10,16(sp)
    800039d2:	e46e                	sd	s11,8(sp)
    800039d4:	1880                	addi	s0,sp,112
    800039d6:	8baa                	mv	s7,a0
    800039d8:	8c2e                	mv	s8,a1
    800039da:	8ab2                	mv	s5,a2
    800039dc:	8936                	mv	s2,a3
    800039de:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800039e0:	00e687bb          	addw	a5,a3,a4
    800039e4:	0ed7e063          	bltu	a5,a3,80003ac4 <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800039e8:	00043737          	lui	a4,0x43
    800039ec:	0cf76e63          	bltu	a4,a5,80003ac8 <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039f0:	0a0b0763          	beqz	s6,80003a9e <writei+0xec>
    800039f4:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    800039f6:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039fa:	5cfd                	li	s9,-1
    800039fc:	a091                	j	80003a40 <writei+0x8e>
    800039fe:	02099d93          	slli	s11,s3,0x20
    80003a02:	020ddd93          	srli	s11,s11,0x20
    80003a06:	05848513          	addi	a0,s1,88
    80003a0a:	86ee                	mv	a3,s11
    80003a0c:	8656                	mv	a2,s5
    80003a0e:	85e2                	mv	a1,s8
    80003a10:	953a                	add	a0,a0,a4
    80003a12:	fffff097          	auipc	ra,0xfffff
    80003a16:	a8e080e7          	jalr	-1394(ra) # 800024a0 <either_copyin>
    80003a1a:	07950263          	beq	a0,s9,80003a7e <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003a1e:	8526                	mv	a0,s1
    80003a20:	00000097          	auipc	ra,0x0
    80003a24:	77a080e7          	jalr	1914(ra) # 8000419a <log_write>
    brelse(bp);
    80003a28:	8526                	mv	a0,s1
    80003a2a:	fffff097          	auipc	ra,0xfffff
    80003a2e:	50c080e7          	jalr	1292(ra) # 80002f36 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a32:	01498a3b          	addw	s4,s3,s4
    80003a36:	0129893b          	addw	s2,s3,s2
    80003a3a:	9aee                	add	s5,s5,s11
    80003a3c:	056a7663          	bgeu	s4,s6,80003a88 <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003a40:	000ba483          	lw	s1,0(s7)
    80003a44:	00a9559b          	srliw	a1,s2,0xa
    80003a48:	855e                	mv	a0,s7
    80003a4a:	fffff097          	auipc	ra,0xfffff
    80003a4e:	7b0080e7          	jalr	1968(ra) # 800031fa <bmap>
    80003a52:	0005059b          	sext.w	a1,a0
    80003a56:	8526                	mv	a0,s1
    80003a58:	fffff097          	auipc	ra,0xfffff
    80003a5c:	3ae080e7          	jalr	942(ra) # 80002e06 <bread>
    80003a60:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003a62:	3ff97713          	andi	a4,s2,1023
    80003a66:	40ed07bb          	subw	a5,s10,a4
    80003a6a:	414b06bb          	subw	a3,s6,s4
    80003a6e:	89be                	mv	s3,a5
    80003a70:	2781                	sext.w	a5,a5
    80003a72:	0006861b          	sext.w	a2,a3
    80003a76:	f8f674e3          	bgeu	a2,a5,800039fe <writei+0x4c>
    80003a7a:	89b6                	mv	s3,a3
    80003a7c:	b749                	j	800039fe <writei+0x4c>
      brelse(bp);
    80003a7e:	8526                	mv	a0,s1
    80003a80:	fffff097          	auipc	ra,0xfffff
    80003a84:	4b6080e7          	jalr	1206(ra) # 80002f36 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003a88:	04cba783          	lw	a5,76(s7)
    80003a8c:	0127f463          	bgeu	a5,s2,80003a94 <writei+0xe2>
      ip->size = off;
    80003a90:	052ba623          	sw	s2,76(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003a94:	855e                	mv	a0,s7
    80003a96:	00000097          	auipc	ra,0x0
    80003a9a:	aa8080e7          	jalr	-1368(ra) # 8000353e <iupdate>
  }

  return n;
    80003a9e:	000b051b          	sext.w	a0,s6
}
    80003aa2:	70a6                	ld	ra,104(sp)
    80003aa4:	7406                	ld	s0,96(sp)
    80003aa6:	64e6                	ld	s1,88(sp)
    80003aa8:	6946                	ld	s2,80(sp)
    80003aaa:	69a6                	ld	s3,72(sp)
    80003aac:	6a06                	ld	s4,64(sp)
    80003aae:	7ae2                	ld	s5,56(sp)
    80003ab0:	7b42                	ld	s6,48(sp)
    80003ab2:	7ba2                	ld	s7,40(sp)
    80003ab4:	7c02                	ld	s8,32(sp)
    80003ab6:	6ce2                	ld	s9,24(sp)
    80003ab8:	6d42                	ld	s10,16(sp)
    80003aba:	6da2                	ld	s11,8(sp)
    80003abc:	6165                	addi	sp,sp,112
    80003abe:	8082                	ret
    return -1;
    80003ac0:	557d                	li	a0,-1
}
    80003ac2:	8082                	ret
    return -1;
    80003ac4:	557d                	li	a0,-1
    80003ac6:	bff1                	j	80003aa2 <writei+0xf0>
    return -1;
    80003ac8:	557d                	li	a0,-1
    80003aca:	bfe1                	j	80003aa2 <writei+0xf0>

0000000080003acc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003acc:	1141                	addi	sp,sp,-16
    80003ace:	e406                	sd	ra,8(sp)
    80003ad0:	e022                	sd	s0,0(sp)
    80003ad2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003ad4:	4639                	li	a2,14
    80003ad6:	ffffd097          	auipc	ra,0xffffd
    80003ada:	312080e7          	jalr	786(ra) # 80000de8 <strncmp>
}
    80003ade:	60a2                	ld	ra,8(sp)
    80003ae0:	6402                	ld	s0,0(sp)
    80003ae2:	0141                	addi	sp,sp,16
    80003ae4:	8082                	ret

0000000080003ae6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003ae6:	7139                	addi	sp,sp,-64
    80003ae8:	fc06                	sd	ra,56(sp)
    80003aea:	f822                	sd	s0,48(sp)
    80003aec:	f426                	sd	s1,40(sp)
    80003aee:	f04a                	sd	s2,32(sp)
    80003af0:	ec4e                	sd	s3,24(sp)
    80003af2:	e852                	sd	s4,16(sp)
    80003af4:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003af6:	04451703          	lh	a4,68(a0)
    80003afa:	4785                	li	a5,1
    80003afc:	00f71a63          	bne	a4,a5,80003b10 <dirlookup+0x2a>
    80003b00:	892a                	mv	s2,a0
    80003b02:	89ae                	mv	s3,a1
    80003b04:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b06:	457c                	lw	a5,76(a0)
    80003b08:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003b0a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b0c:	e79d                	bnez	a5,80003b3a <dirlookup+0x54>
    80003b0e:	a8a5                	j	80003b86 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003b10:	00005517          	auipc	a0,0x5
    80003b14:	ab850513          	addi	a0,a0,-1352 # 800085c8 <syscalls+0x1a0>
    80003b18:	ffffd097          	auipc	ra,0xffffd
    80003b1c:	a30080e7          	jalr	-1488(ra) # 80000548 <panic>
      panic("dirlookup read");
    80003b20:	00005517          	auipc	a0,0x5
    80003b24:	ac050513          	addi	a0,a0,-1344 # 800085e0 <syscalls+0x1b8>
    80003b28:	ffffd097          	auipc	ra,0xffffd
    80003b2c:	a20080e7          	jalr	-1504(ra) # 80000548 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003b30:	24c1                	addiw	s1,s1,16
    80003b32:	04c92783          	lw	a5,76(s2)
    80003b36:	04f4f763          	bgeu	s1,a5,80003b84 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003b3a:	4741                	li	a4,16
    80003b3c:	86a6                	mv	a3,s1
    80003b3e:	fc040613          	addi	a2,s0,-64
    80003b42:	4581                	li	a1,0
    80003b44:	854a                	mv	a0,s2
    80003b46:	00000097          	auipc	ra,0x0
    80003b4a:	d76080e7          	jalr	-650(ra) # 800038bc <readi>
    80003b4e:	47c1                	li	a5,16
    80003b50:	fcf518e3          	bne	a0,a5,80003b20 <dirlookup+0x3a>
    if(de.inum == 0)
    80003b54:	fc045783          	lhu	a5,-64(s0)
    80003b58:	dfe1                	beqz	a5,80003b30 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003b5a:	fc240593          	addi	a1,s0,-62
    80003b5e:	854e                	mv	a0,s3
    80003b60:	00000097          	auipc	ra,0x0
    80003b64:	f6c080e7          	jalr	-148(ra) # 80003acc <namecmp>
    80003b68:	f561                	bnez	a0,80003b30 <dirlookup+0x4a>
      if(poff)
    80003b6a:	000a0463          	beqz	s4,80003b72 <dirlookup+0x8c>
        *poff = off;
    80003b6e:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b72:	fc045583          	lhu	a1,-64(s0)
    80003b76:	00092503          	lw	a0,0(s2)
    80003b7a:	fffff097          	auipc	ra,0xfffff
    80003b7e:	75a080e7          	jalr	1882(ra) # 800032d4 <iget>
    80003b82:	a011                	j	80003b86 <dirlookup+0xa0>
  return 0;
    80003b84:	4501                	li	a0,0
}
    80003b86:	70e2                	ld	ra,56(sp)
    80003b88:	7442                	ld	s0,48(sp)
    80003b8a:	74a2                	ld	s1,40(sp)
    80003b8c:	7902                	ld	s2,32(sp)
    80003b8e:	69e2                	ld	s3,24(sp)
    80003b90:	6a42                	ld	s4,16(sp)
    80003b92:	6121                	addi	sp,sp,64
    80003b94:	8082                	ret

0000000080003b96 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b96:	711d                	addi	sp,sp,-96
    80003b98:	ec86                	sd	ra,88(sp)
    80003b9a:	e8a2                	sd	s0,80(sp)
    80003b9c:	e4a6                	sd	s1,72(sp)
    80003b9e:	e0ca                	sd	s2,64(sp)
    80003ba0:	fc4e                	sd	s3,56(sp)
    80003ba2:	f852                	sd	s4,48(sp)
    80003ba4:	f456                	sd	s5,40(sp)
    80003ba6:	f05a                	sd	s6,32(sp)
    80003ba8:	ec5e                	sd	s7,24(sp)
    80003baa:	e862                	sd	s8,16(sp)
    80003bac:	e466                	sd	s9,8(sp)
    80003bae:	1080                	addi	s0,sp,96
    80003bb0:	84aa                	mv	s1,a0
    80003bb2:	8b2e                	mv	s6,a1
    80003bb4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003bb6:	00054703          	lbu	a4,0(a0)
    80003bba:	02f00793          	li	a5,47
    80003bbe:	02f70363          	beq	a4,a5,80003be4 <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003bc2:	ffffe097          	auipc	ra,0xffffe
    80003bc6:	e1c080e7          	jalr	-484(ra) # 800019de <myproc>
    80003bca:	15053503          	ld	a0,336(a0)
    80003bce:	00000097          	auipc	ra,0x0
    80003bd2:	9fc080e7          	jalr	-1540(ra) # 800035ca <idup>
    80003bd6:	89aa                	mv	s3,a0
  while(*path == '/')
    80003bd8:	02f00913          	li	s2,47
  len = path - s;
    80003bdc:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003bde:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003be0:	4c05                	li	s8,1
    80003be2:	a865                	j	80003c9a <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003be4:	4585                	li	a1,1
    80003be6:	4505                	li	a0,1
    80003be8:	fffff097          	auipc	ra,0xfffff
    80003bec:	6ec080e7          	jalr	1772(ra) # 800032d4 <iget>
    80003bf0:	89aa                	mv	s3,a0
    80003bf2:	b7dd                	j	80003bd8 <namex+0x42>
      iunlockput(ip);
    80003bf4:	854e                	mv	a0,s3
    80003bf6:	00000097          	auipc	ra,0x0
    80003bfa:	c74080e7          	jalr	-908(ra) # 8000386a <iunlockput>
      return 0;
    80003bfe:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003c00:	854e                	mv	a0,s3
    80003c02:	60e6                	ld	ra,88(sp)
    80003c04:	6446                	ld	s0,80(sp)
    80003c06:	64a6                	ld	s1,72(sp)
    80003c08:	6906                	ld	s2,64(sp)
    80003c0a:	79e2                	ld	s3,56(sp)
    80003c0c:	7a42                	ld	s4,48(sp)
    80003c0e:	7aa2                	ld	s5,40(sp)
    80003c10:	7b02                	ld	s6,32(sp)
    80003c12:	6be2                	ld	s7,24(sp)
    80003c14:	6c42                	ld	s8,16(sp)
    80003c16:	6ca2                	ld	s9,8(sp)
    80003c18:	6125                	addi	sp,sp,96
    80003c1a:	8082                	ret
      iunlock(ip);
    80003c1c:	854e                	mv	a0,s3
    80003c1e:	00000097          	auipc	ra,0x0
    80003c22:	aac080e7          	jalr	-1364(ra) # 800036ca <iunlock>
      return ip;
    80003c26:	bfe9                	j	80003c00 <namex+0x6a>
      iunlockput(ip);
    80003c28:	854e                	mv	a0,s3
    80003c2a:	00000097          	auipc	ra,0x0
    80003c2e:	c40080e7          	jalr	-960(ra) # 8000386a <iunlockput>
      return 0;
    80003c32:	89d2                	mv	s3,s4
    80003c34:	b7f1                	j	80003c00 <namex+0x6a>
  len = path - s;
    80003c36:	40b48633          	sub	a2,s1,a1
    80003c3a:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003c3e:	094cd463          	bge	s9,s4,80003cc6 <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003c42:	4639                	li	a2,14
    80003c44:	8556                	mv	a0,s5
    80003c46:	ffffd097          	auipc	ra,0xffffd
    80003c4a:	126080e7          	jalr	294(ra) # 80000d6c <memmove>
  while(*path == '/')
    80003c4e:	0004c783          	lbu	a5,0(s1)
    80003c52:	01279763          	bne	a5,s2,80003c60 <namex+0xca>
    path++;
    80003c56:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c58:	0004c783          	lbu	a5,0(s1)
    80003c5c:	ff278de3          	beq	a5,s2,80003c56 <namex+0xc0>
    ilock(ip);
    80003c60:	854e                	mv	a0,s3
    80003c62:	00000097          	auipc	ra,0x0
    80003c66:	9a6080e7          	jalr	-1626(ra) # 80003608 <ilock>
    if(ip->type != T_DIR){
    80003c6a:	04499783          	lh	a5,68(s3)
    80003c6e:	f98793e3          	bne	a5,s8,80003bf4 <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003c72:	000b0563          	beqz	s6,80003c7c <namex+0xe6>
    80003c76:	0004c783          	lbu	a5,0(s1)
    80003c7a:	d3cd                	beqz	a5,80003c1c <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003c7c:	865e                	mv	a2,s7
    80003c7e:	85d6                	mv	a1,s5
    80003c80:	854e                	mv	a0,s3
    80003c82:	00000097          	auipc	ra,0x0
    80003c86:	e64080e7          	jalr	-412(ra) # 80003ae6 <dirlookup>
    80003c8a:	8a2a                	mv	s4,a0
    80003c8c:	dd51                	beqz	a0,80003c28 <namex+0x92>
    iunlockput(ip);
    80003c8e:	854e                	mv	a0,s3
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	bda080e7          	jalr	-1062(ra) # 8000386a <iunlockput>
    ip = next;
    80003c98:	89d2                	mv	s3,s4
  while(*path == '/')
    80003c9a:	0004c783          	lbu	a5,0(s1)
    80003c9e:	05279763          	bne	a5,s2,80003cec <namex+0x156>
    path++;
    80003ca2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003ca4:	0004c783          	lbu	a5,0(s1)
    80003ca8:	ff278de3          	beq	a5,s2,80003ca2 <namex+0x10c>
  if(*path == 0)
    80003cac:	c79d                	beqz	a5,80003cda <namex+0x144>
    path++;
    80003cae:	85a6                	mv	a1,s1
  len = path - s;
    80003cb0:	8a5e                	mv	s4,s7
    80003cb2:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003cb4:	01278963          	beq	a5,s2,80003cc6 <namex+0x130>
    80003cb8:	dfbd                	beqz	a5,80003c36 <namex+0xa0>
    path++;
    80003cba:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003cbc:	0004c783          	lbu	a5,0(s1)
    80003cc0:	ff279ce3          	bne	a5,s2,80003cb8 <namex+0x122>
    80003cc4:	bf8d                	j	80003c36 <namex+0xa0>
    memmove(name, s, len);
    80003cc6:	2601                	sext.w	a2,a2
    80003cc8:	8556                	mv	a0,s5
    80003cca:	ffffd097          	auipc	ra,0xffffd
    80003cce:	0a2080e7          	jalr	162(ra) # 80000d6c <memmove>
    name[len] = 0;
    80003cd2:	9a56                	add	s4,s4,s5
    80003cd4:	000a0023          	sb	zero,0(s4)
    80003cd8:	bf9d                	j	80003c4e <namex+0xb8>
  if(nameiparent){
    80003cda:	f20b03e3          	beqz	s6,80003c00 <namex+0x6a>
    iput(ip);
    80003cde:	854e                	mv	a0,s3
    80003ce0:	00000097          	auipc	ra,0x0
    80003ce4:	ae2080e7          	jalr	-1310(ra) # 800037c2 <iput>
    return 0;
    80003ce8:	4981                	li	s3,0
    80003cea:	bf19                	j	80003c00 <namex+0x6a>
  if(*path == 0)
    80003cec:	d7fd                	beqz	a5,80003cda <namex+0x144>
  while(*path != '/' && *path != 0)
    80003cee:	0004c783          	lbu	a5,0(s1)
    80003cf2:	85a6                	mv	a1,s1
    80003cf4:	b7d1                	j	80003cb8 <namex+0x122>

0000000080003cf6 <dirlink>:
{
    80003cf6:	7139                	addi	sp,sp,-64
    80003cf8:	fc06                	sd	ra,56(sp)
    80003cfa:	f822                	sd	s0,48(sp)
    80003cfc:	f426                	sd	s1,40(sp)
    80003cfe:	f04a                	sd	s2,32(sp)
    80003d00:	ec4e                	sd	s3,24(sp)
    80003d02:	e852                	sd	s4,16(sp)
    80003d04:	0080                	addi	s0,sp,64
    80003d06:	892a                	mv	s2,a0
    80003d08:	8a2e                	mv	s4,a1
    80003d0a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003d0c:	4601                	li	a2,0
    80003d0e:	00000097          	auipc	ra,0x0
    80003d12:	dd8080e7          	jalr	-552(ra) # 80003ae6 <dirlookup>
    80003d16:	e93d                	bnez	a0,80003d8c <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d18:	04c92483          	lw	s1,76(s2)
    80003d1c:	c49d                	beqz	s1,80003d4a <dirlink+0x54>
    80003d1e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d20:	4741                	li	a4,16
    80003d22:	86a6                	mv	a3,s1
    80003d24:	fc040613          	addi	a2,s0,-64
    80003d28:	4581                	li	a1,0
    80003d2a:	854a                	mv	a0,s2
    80003d2c:	00000097          	auipc	ra,0x0
    80003d30:	b90080e7          	jalr	-1136(ra) # 800038bc <readi>
    80003d34:	47c1                	li	a5,16
    80003d36:	06f51163          	bne	a0,a5,80003d98 <dirlink+0xa2>
    if(de.inum == 0)
    80003d3a:	fc045783          	lhu	a5,-64(s0)
    80003d3e:	c791                	beqz	a5,80003d4a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d40:	24c1                	addiw	s1,s1,16
    80003d42:	04c92783          	lw	a5,76(s2)
    80003d46:	fcf4ede3          	bltu	s1,a5,80003d20 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003d4a:	4639                	li	a2,14
    80003d4c:	85d2                	mv	a1,s4
    80003d4e:	fc240513          	addi	a0,s0,-62
    80003d52:	ffffd097          	auipc	ra,0xffffd
    80003d56:	0d2080e7          	jalr	210(ra) # 80000e24 <strncpy>
  de.inum = inum;
    80003d5a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d5e:	4741                	li	a4,16
    80003d60:	86a6                	mv	a3,s1
    80003d62:	fc040613          	addi	a2,s0,-64
    80003d66:	4581                	li	a1,0
    80003d68:	854a                	mv	a0,s2
    80003d6a:	00000097          	auipc	ra,0x0
    80003d6e:	c48080e7          	jalr	-952(ra) # 800039b2 <writei>
    80003d72:	872a                	mv	a4,a0
    80003d74:	47c1                	li	a5,16
  return 0;
    80003d76:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d78:	02f71863          	bne	a4,a5,80003da8 <dirlink+0xb2>
}
    80003d7c:	70e2                	ld	ra,56(sp)
    80003d7e:	7442                	ld	s0,48(sp)
    80003d80:	74a2                	ld	s1,40(sp)
    80003d82:	7902                	ld	s2,32(sp)
    80003d84:	69e2                	ld	s3,24(sp)
    80003d86:	6a42                	ld	s4,16(sp)
    80003d88:	6121                	addi	sp,sp,64
    80003d8a:	8082                	ret
    iput(ip);
    80003d8c:	00000097          	auipc	ra,0x0
    80003d90:	a36080e7          	jalr	-1482(ra) # 800037c2 <iput>
    return -1;
    80003d94:	557d                	li	a0,-1
    80003d96:	b7dd                	j	80003d7c <dirlink+0x86>
      panic("dirlink read");
    80003d98:	00005517          	auipc	a0,0x5
    80003d9c:	85850513          	addi	a0,a0,-1960 # 800085f0 <syscalls+0x1c8>
    80003da0:	ffffc097          	auipc	ra,0xffffc
    80003da4:	7a8080e7          	jalr	1960(ra) # 80000548 <panic>
    panic("dirlink");
    80003da8:	00005517          	auipc	a0,0x5
    80003dac:	96850513          	addi	a0,a0,-1688 # 80008710 <syscalls+0x2e8>
    80003db0:	ffffc097          	auipc	ra,0xffffc
    80003db4:	798080e7          	jalr	1944(ra) # 80000548 <panic>

0000000080003db8 <namei>:

struct inode*
namei(char *path)
{
    80003db8:	1101                	addi	sp,sp,-32
    80003dba:	ec06                	sd	ra,24(sp)
    80003dbc:	e822                	sd	s0,16(sp)
    80003dbe:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003dc0:	fe040613          	addi	a2,s0,-32
    80003dc4:	4581                	li	a1,0
    80003dc6:	00000097          	auipc	ra,0x0
    80003dca:	dd0080e7          	jalr	-560(ra) # 80003b96 <namex>
}
    80003dce:	60e2                	ld	ra,24(sp)
    80003dd0:	6442                	ld	s0,16(sp)
    80003dd2:	6105                	addi	sp,sp,32
    80003dd4:	8082                	ret

0000000080003dd6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003dd6:	1141                	addi	sp,sp,-16
    80003dd8:	e406                	sd	ra,8(sp)
    80003dda:	e022                	sd	s0,0(sp)
    80003ddc:	0800                	addi	s0,sp,16
    80003dde:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003de0:	4585                	li	a1,1
    80003de2:	00000097          	auipc	ra,0x0
    80003de6:	db4080e7          	jalr	-588(ra) # 80003b96 <namex>
}
    80003dea:	60a2                	ld	ra,8(sp)
    80003dec:	6402                	ld	s0,0(sp)
    80003dee:	0141                	addi	sp,sp,16
    80003df0:	8082                	ret

0000000080003df2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003df2:	1101                	addi	sp,sp,-32
    80003df4:	ec06                	sd	ra,24(sp)
    80003df6:	e822                	sd	s0,16(sp)
    80003df8:	e426                	sd	s1,8(sp)
    80003dfa:	e04a                	sd	s2,0(sp)
    80003dfc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003dfe:	0001e917          	auipc	s2,0x1e
    80003e02:	b0a90913          	addi	s2,s2,-1270 # 80021908 <log>
    80003e06:	01892583          	lw	a1,24(s2)
    80003e0a:	02892503          	lw	a0,40(s2)
    80003e0e:	fffff097          	auipc	ra,0xfffff
    80003e12:	ff8080e7          	jalr	-8(ra) # 80002e06 <bread>
    80003e16:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003e18:	02c92683          	lw	a3,44(s2)
    80003e1c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003e1e:	02d05763          	blez	a3,80003e4c <write_head+0x5a>
    80003e22:	0001e797          	auipc	a5,0x1e
    80003e26:	b1678793          	addi	a5,a5,-1258 # 80021938 <log+0x30>
    80003e2a:	05c50713          	addi	a4,a0,92
    80003e2e:	36fd                	addiw	a3,a3,-1
    80003e30:	1682                	slli	a3,a3,0x20
    80003e32:	9281                	srli	a3,a3,0x20
    80003e34:	068a                	slli	a3,a3,0x2
    80003e36:	0001e617          	auipc	a2,0x1e
    80003e3a:	b0660613          	addi	a2,a2,-1274 # 8002193c <log+0x34>
    80003e3e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003e40:	4390                	lw	a2,0(a5)
    80003e42:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e44:	0791                	addi	a5,a5,4
    80003e46:	0711                	addi	a4,a4,4
    80003e48:	fed79ce3          	bne	a5,a3,80003e40 <write_head+0x4e>
  }
  bwrite(buf);
    80003e4c:	8526                	mv	a0,s1
    80003e4e:	fffff097          	auipc	ra,0xfffff
    80003e52:	0aa080e7          	jalr	170(ra) # 80002ef8 <bwrite>
  brelse(buf);
    80003e56:	8526                	mv	a0,s1
    80003e58:	fffff097          	auipc	ra,0xfffff
    80003e5c:	0de080e7          	jalr	222(ra) # 80002f36 <brelse>
}
    80003e60:	60e2                	ld	ra,24(sp)
    80003e62:	6442                	ld	s0,16(sp)
    80003e64:	64a2                	ld	s1,8(sp)
    80003e66:	6902                	ld	s2,0(sp)
    80003e68:	6105                	addi	sp,sp,32
    80003e6a:	8082                	ret

0000000080003e6c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e6c:	0001e797          	auipc	a5,0x1e
    80003e70:	ac87a783          	lw	a5,-1336(a5) # 80021934 <log+0x2c>
    80003e74:	0af05663          	blez	a5,80003f20 <install_trans+0xb4>
{
    80003e78:	7139                	addi	sp,sp,-64
    80003e7a:	fc06                	sd	ra,56(sp)
    80003e7c:	f822                	sd	s0,48(sp)
    80003e7e:	f426                	sd	s1,40(sp)
    80003e80:	f04a                	sd	s2,32(sp)
    80003e82:	ec4e                	sd	s3,24(sp)
    80003e84:	e852                	sd	s4,16(sp)
    80003e86:	e456                	sd	s5,8(sp)
    80003e88:	0080                	addi	s0,sp,64
    80003e8a:	0001ea97          	auipc	s5,0x1e
    80003e8e:	aaea8a93          	addi	s5,s5,-1362 # 80021938 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e92:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003e94:	0001e997          	auipc	s3,0x1e
    80003e98:	a7498993          	addi	s3,s3,-1420 # 80021908 <log>
    80003e9c:	0189a583          	lw	a1,24(s3)
    80003ea0:	014585bb          	addw	a1,a1,s4
    80003ea4:	2585                	addiw	a1,a1,1
    80003ea6:	0289a503          	lw	a0,40(s3)
    80003eaa:	fffff097          	auipc	ra,0xfffff
    80003eae:	f5c080e7          	jalr	-164(ra) # 80002e06 <bread>
    80003eb2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003eb4:	000aa583          	lw	a1,0(s5)
    80003eb8:	0289a503          	lw	a0,40(s3)
    80003ebc:	fffff097          	auipc	ra,0xfffff
    80003ec0:	f4a080e7          	jalr	-182(ra) # 80002e06 <bread>
    80003ec4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003ec6:	40000613          	li	a2,1024
    80003eca:	05890593          	addi	a1,s2,88
    80003ece:	05850513          	addi	a0,a0,88
    80003ed2:	ffffd097          	auipc	ra,0xffffd
    80003ed6:	e9a080e7          	jalr	-358(ra) # 80000d6c <memmove>
    bwrite(dbuf);  // write dst to disk
    80003eda:	8526                	mv	a0,s1
    80003edc:	fffff097          	auipc	ra,0xfffff
    80003ee0:	01c080e7          	jalr	28(ra) # 80002ef8 <bwrite>
    bunpin(dbuf);
    80003ee4:	8526                	mv	a0,s1
    80003ee6:	fffff097          	auipc	ra,0xfffff
    80003eea:	12a080e7          	jalr	298(ra) # 80003010 <bunpin>
    brelse(lbuf);
    80003eee:	854a                	mv	a0,s2
    80003ef0:	fffff097          	auipc	ra,0xfffff
    80003ef4:	046080e7          	jalr	70(ra) # 80002f36 <brelse>
    brelse(dbuf);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	fffff097          	auipc	ra,0xfffff
    80003efe:	03c080e7          	jalr	60(ra) # 80002f36 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f02:	2a05                	addiw	s4,s4,1
    80003f04:	0a91                	addi	s5,s5,4
    80003f06:	02c9a783          	lw	a5,44(s3)
    80003f0a:	f8fa49e3          	blt	s4,a5,80003e9c <install_trans+0x30>
}
    80003f0e:	70e2                	ld	ra,56(sp)
    80003f10:	7442                	ld	s0,48(sp)
    80003f12:	74a2                	ld	s1,40(sp)
    80003f14:	7902                	ld	s2,32(sp)
    80003f16:	69e2                	ld	s3,24(sp)
    80003f18:	6a42                	ld	s4,16(sp)
    80003f1a:	6aa2                	ld	s5,8(sp)
    80003f1c:	6121                	addi	sp,sp,64
    80003f1e:	8082                	ret
    80003f20:	8082                	ret

0000000080003f22 <initlog>:
{
    80003f22:	7179                	addi	sp,sp,-48
    80003f24:	f406                	sd	ra,40(sp)
    80003f26:	f022                	sd	s0,32(sp)
    80003f28:	ec26                	sd	s1,24(sp)
    80003f2a:	e84a                	sd	s2,16(sp)
    80003f2c:	e44e                	sd	s3,8(sp)
    80003f2e:	1800                	addi	s0,sp,48
    80003f30:	892a                	mv	s2,a0
    80003f32:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003f34:	0001e497          	auipc	s1,0x1e
    80003f38:	9d448493          	addi	s1,s1,-1580 # 80021908 <log>
    80003f3c:	00004597          	auipc	a1,0x4
    80003f40:	6c458593          	addi	a1,a1,1732 # 80008600 <syscalls+0x1d8>
    80003f44:	8526                	mv	a0,s1
    80003f46:	ffffd097          	auipc	ra,0xffffd
    80003f4a:	c3a080e7          	jalr	-966(ra) # 80000b80 <initlock>
  log.start = sb->logstart;
    80003f4e:	0149a583          	lw	a1,20(s3)
    80003f52:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003f54:	0109a783          	lw	a5,16(s3)
    80003f58:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003f5a:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003f5e:	854a                	mv	a0,s2
    80003f60:	fffff097          	auipc	ra,0xfffff
    80003f64:	ea6080e7          	jalr	-346(ra) # 80002e06 <bread>
  log.lh.n = lh->n;
    80003f68:	4d3c                	lw	a5,88(a0)
    80003f6a:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003f6c:	02f05563          	blez	a5,80003f96 <initlog+0x74>
    80003f70:	05c50713          	addi	a4,a0,92
    80003f74:	0001e697          	auipc	a3,0x1e
    80003f78:	9c468693          	addi	a3,a3,-1596 # 80021938 <log+0x30>
    80003f7c:	37fd                	addiw	a5,a5,-1
    80003f7e:	1782                	slli	a5,a5,0x20
    80003f80:	9381                	srli	a5,a5,0x20
    80003f82:	078a                	slli	a5,a5,0x2
    80003f84:	06050613          	addi	a2,a0,96
    80003f88:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003f8a:	4310                	lw	a2,0(a4)
    80003f8c:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003f8e:	0711                	addi	a4,a4,4
    80003f90:	0691                	addi	a3,a3,4
    80003f92:	fef71ce3          	bne	a4,a5,80003f8a <initlog+0x68>
  brelse(buf);
    80003f96:	fffff097          	auipc	ra,0xfffff
    80003f9a:	fa0080e7          	jalr	-96(ra) # 80002f36 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
    80003f9e:	00000097          	auipc	ra,0x0
    80003fa2:	ece080e7          	jalr	-306(ra) # 80003e6c <install_trans>
  log.lh.n = 0;
    80003fa6:	0001e797          	auipc	a5,0x1e
    80003faa:	9807a723          	sw	zero,-1650(a5) # 80021934 <log+0x2c>
  write_head(); // clear the log
    80003fae:	00000097          	auipc	ra,0x0
    80003fb2:	e44080e7          	jalr	-444(ra) # 80003df2 <write_head>
}
    80003fb6:	70a2                	ld	ra,40(sp)
    80003fb8:	7402                	ld	s0,32(sp)
    80003fba:	64e2                	ld	s1,24(sp)
    80003fbc:	6942                	ld	s2,16(sp)
    80003fbe:	69a2                	ld	s3,8(sp)
    80003fc0:	6145                	addi	sp,sp,48
    80003fc2:	8082                	ret

0000000080003fc4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003fc4:	1101                	addi	sp,sp,-32
    80003fc6:	ec06                	sd	ra,24(sp)
    80003fc8:	e822                	sd	s0,16(sp)
    80003fca:	e426                	sd	s1,8(sp)
    80003fcc:	e04a                	sd	s2,0(sp)
    80003fce:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003fd0:	0001e517          	auipc	a0,0x1e
    80003fd4:	93850513          	addi	a0,a0,-1736 # 80021908 <log>
    80003fd8:	ffffd097          	auipc	ra,0xffffd
    80003fdc:	c38080e7          	jalr	-968(ra) # 80000c10 <acquire>
  while(1){
    if(log.committing){
    80003fe0:	0001e497          	auipc	s1,0x1e
    80003fe4:	92848493          	addi	s1,s1,-1752 # 80021908 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003fe8:	4979                	li	s2,30
    80003fea:	a039                	j	80003ff8 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003fec:	85a6                	mv	a1,s1
    80003fee:	8526                	mv	a0,s1
    80003ff0:	ffffe097          	auipc	ra,0xffffe
    80003ff4:	1fa080e7          	jalr	506(ra) # 800021ea <sleep>
    if(log.committing){
    80003ff8:	50dc                	lw	a5,36(s1)
    80003ffa:	fbed                	bnez	a5,80003fec <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ffc:	509c                	lw	a5,32(s1)
    80003ffe:	0017871b          	addiw	a4,a5,1
    80004002:	0007069b          	sext.w	a3,a4
    80004006:	0027179b          	slliw	a5,a4,0x2
    8000400a:	9fb9                	addw	a5,a5,a4
    8000400c:	0017979b          	slliw	a5,a5,0x1
    80004010:	54d8                	lw	a4,44(s1)
    80004012:	9fb9                	addw	a5,a5,a4
    80004014:	00f95963          	bge	s2,a5,80004026 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004018:	85a6                	mv	a1,s1
    8000401a:	8526                	mv	a0,s1
    8000401c:	ffffe097          	auipc	ra,0xffffe
    80004020:	1ce080e7          	jalr	462(ra) # 800021ea <sleep>
    80004024:	bfd1                	j	80003ff8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004026:	0001e517          	auipc	a0,0x1e
    8000402a:	8e250513          	addi	a0,a0,-1822 # 80021908 <log>
    8000402e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80004030:	ffffd097          	auipc	ra,0xffffd
    80004034:	c94080e7          	jalr	-876(ra) # 80000cc4 <release>
      break;
    }
  }
}
    80004038:	60e2                	ld	ra,24(sp)
    8000403a:	6442                	ld	s0,16(sp)
    8000403c:	64a2                	ld	s1,8(sp)
    8000403e:	6902                	ld	s2,0(sp)
    80004040:	6105                	addi	sp,sp,32
    80004042:	8082                	ret

0000000080004044 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004044:	7139                	addi	sp,sp,-64
    80004046:	fc06                	sd	ra,56(sp)
    80004048:	f822                	sd	s0,48(sp)
    8000404a:	f426                	sd	s1,40(sp)
    8000404c:	f04a                	sd	s2,32(sp)
    8000404e:	ec4e                	sd	s3,24(sp)
    80004050:	e852                	sd	s4,16(sp)
    80004052:	e456                	sd	s5,8(sp)
    80004054:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004056:	0001e497          	auipc	s1,0x1e
    8000405a:	8b248493          	addi	s1,s1,-1870 # 80021908 <log>
    8000405e:	8526                	mv	a0,s1
    80004060:	ffffd097          	auipc	ra,0xffffd
    80004064:	bb0080e7          	jalr	-1104(ra) # 80000c10 <acquire>
  log.outstanding -= 1;
    80004068:	509c                	lw	a5,32(s1)
    8000406a:	37fd                	addiw	a5,a5,-1
    8000406c:	0007891b          	sext.w	s2,a5
    80004070:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004072:	50dc                	lw	a5,36(s1)
    80004074:	efb9                	bnez	a5,800040d2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80004076:	06091663          	bnez	s2,800040e2 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000407a:	0001e497          	auipc	s1,0x1e
    8000407e:	88e48493          	addi	s1,s1,-1906 # 80021908 <log>
    80004082:	4785                	li	a5,1
    80004084:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004086:	8526                	mv	a0,s1
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	c3c080e7          	jalr	-964(ra) # 80000cc4 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004090:	54dc                	lw	a5,44(s1)
    80004092:	06f04763          	bgtz	a5,80004100 <end_op+0xbc>
    acquire(&log.lock);
    80004096:	0001e497          	auipc	s1,0x1e
    8000409a:	87248493          	addi	s1,s1,-1934 # 80021908 <log>
    8000409e:	8526                	mv	a0,s1
    800040a0:	ffffd097          	auipc	ra,0xffffd
    800040a4:	b70080e7          	jalr	-1168(ra) # 80000c10 <acquire>
    log.committing = 0;
    800040a8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800040ac:	8526                	mv	a0,s1
    800040ae:	ffffe097          	auipc	ra,0xffffe
    800040b2:	2c2080e7          	jalr	706(ra) # 80002370 <wakeup>
    release(&log.lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	ffffd097          	auipc	ra,0xffffd
    800040bc:	c0c080e7          	jalr	-1012(ra) # 80000cc4 <release>
}
    800040c0:	70e2                	ld	ra,56(sp)
    800040c2:	7442                	ld	s0,48(sp)
    800040c4:	74a2                	ld	s1,40(sp)
    800040c6:	7902                	ld	s2,32(sp)
    800040c8:	69e2                	ld	s3,24(sp)
    800040ca:	6a42                	ld	s4,16(sp)
    800040cc:	6aa2                	ld	s5,8(sp)
    800040ce:	6121                	addi	sp,sp,64
    800040d0:	8082                	ret
    panic("log.committing");
    800040d2:	00004517          	auipc	a0,0x4
    800040d6:	53650513          	addi	a0,a0,1334 # 80008608 <syscalls+0x1e0>
    800040da:	ffffc097          	auipc	ra,0xffffc
    800040de:	46e080e7          	jalr	1134(ra) # 80000548 <panic>
    wakeup(&log);
    800040e2:	0001e497          	auipc	s1,0x1e
    800040e6:	82648493          	addi	s1,s1,-2010 # 80021908 <log>
    800040ea:	8526                	mv	a0,s1
    800040ec:	ffffe097          	auipc	ra,0xffffe
    800040f0:	284080e7          	jalr	644(ra) # 80002370 <wakeup>
  release(&log.lock);
    800040f4:	8526                	mv	a0,s1
    800040f6:	ffffd097          	auipc	ra,0xffffd
    800040fa:	bce080e7          	jalr	-1074(ra) # 80000cc4 <release>
  if(do_commit){
    800040fe:	b7c9                	j	800040c0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004100:	0001ea97          	auipc	s5,0x1e
    80004104:	838a8a93          	addi	s5,s5,-1992 # 80021938 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004108:	0001ea17          	auipc	s4,0x1e
    8000410c:	800a0a13          	addi	s4,s4,-2048 # 80021908 <log>
    80004110:	018a2583          	lw	a1,24(s4)
    80004114:	012585bb          	addw	a1,a1,s2
    80004118:	2585                	addiw	a1,a1,1
    8000411a:	028a2503          	lw	a0,40(s4)
    8000411e:	fffff097          	auipc	ra,0xfffff
    80004122:	ce8080e7          	jalr	-792(ra) # 80002e06 <bread>
    80004126:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004128:	000aa583          	lw	a1,0(s5)
    8000412c:	028a2503          	lw	a0,40(s4)
    80004130:	fffff097          	auipc	ra,0xfffff
    80004134:	cd6080e7          	jalr	-810(ra) # 80002e06 <bread>
    80004138:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000413a:	40000613          	li	a2,1024
    8000413e:	05850593          	addi	a1,a0,88
    80004142:	05848513          	addi	a0,s1,88
    80004146:	ffffd097          	auipc	ra,0xffffd
    8000414a:	c26080e7          	jalr	-986(ra) # 80000d6c <memmove>
    bwrite(to);  // write the log
    8000414e:	8526                	mv	a0,s1
    80004150:	fffff097          	auipc	ra,0xfffff
    80004154:	da8080e7          	jalr	-600(ra) # 80002ef8 <bwrite>
    brelse(from);
    80004158:	854e                	mv	a0,s3
    8000415a:	fffff097          	auipc	ra,0xfffff
    8000415e:	ddc080e7          	jalr	-548(ra) # 80002f36 <brelse>
    brelse(to);
    80004162:	8526                	mv	a0,s1
    80004164:	fffff097          	auipc	ra,0xfffff
    80004168:	dd2080e7          	jalr	-558(ra) # 80002f36 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000416c:	2905                	addiw	s2,s2,1
    8000416e:	0a91                	addi	s5,s5,4
    80004170:	02ca2783          	lw	a5,44(s4)
    80004174:	f8f94ee3          	blt	s2,a5,80004110 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004178:	00000097          	auipc	ra,0x0
    8000417c:	c7a080e7          	jalr	-902(ra) # 80003df2 <write_head>
    install_trans(); // Now install writes to home locations
    80004180:	00000097          	auipc	ra,0x0
    80004184:	cec080e7          	jalr	-788(ra) # 80003e6c <install_trans>
    log.lh.n = 0;
    80004188:	0001d797          	auipc	a5,0x1d
    8000418c:	7a07a623          	sw	zero,1964(a5) # 80021934 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004190:	00000097          	auipc	ra,0x0
    80004194:	c62080e7          	jalr	-926(ra) # 80003df2 <write_head>
    80004198:	bdfd                	j	80004096 <end_op+0x52>

000000008000419a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000419a:	1101                	addi	sp,sp,-32
    8000419c:	ec06                	sd	ra,24(sp)
    8000419e:	e822                	sd	s0,16(sp)
    800041a0:	e426                	sd	s1,8(sp)
    800041a2:	e04a                	sd	s2,0(sp)
    800041a4:	1000                	addi	s0,sp,32
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800041a6:	0001d717          	auipc	a4,0x1d
    800041aa:	78e72703          	lw	a4,1934(a4) # 80021934 <log+0x2c>
    800041ae:	47f5                	li	a5,29
    800041b0:	08e7c063          	blt	a5,a4,80004230 <log_write+0x96>
    800041b4:	84aa                	mv	s1,a0
    800041b6:	0001d797          	auipc	a5,0x1d
    800041ba:	76e7a783          	lw	a5,1902(a5) # 80021924 <log+0x1c>
    800041be:	37fd                	addiw	a5,a5,-1
    800041c0:	06f75863          	bge	a4,a5,80004230 <log_write+0x96>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800041c4:	0001d797          	auipc	a5,0x1d
    800041c8:	7647a783          	lw	a5,1892(a5) # 80021928 <log+0x20>
    800041cc:	06f05a63          	blez	a5,80004240 <log_write+0xa6>
    panic("log_write outside of trans");

  acquire(&log.lock);
    800041d0:	0001d917          	auipc	s2,0x1d
    800041d4:	73890913          	addi	s2,s2,1848 # 80021908 <log>
    800041d8:	854a                	mv	a0,s2
    800041da:	ffffd097          	auipc	ra,0xffffd
    800041de:	a36080e7          	jalr	-1482(ra) # 80000c10 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    800041e2:	02c92603          	lw	a2,44(s2)
    800041e6:	06c05563          	blez	a2,80004250 <log_write+0xb6>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041ea:	44cc                	lw	a1,12(s1)
    800041ec:	0001d717          	auipc	a4,0x1d
    800041f0:	74c70713          	addi	a4,a4,1868 # 80021938 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800041f4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorbtion
    800041f6:	4314                	lw	a3,0(a4)
    800041f8:	04b68d63          	beq	a3,a1,80004252 <log_write+0xb8>
  for (i = 0; i < log.lh.n; i++) {
    800041fc:	2785                	addiw	a5,a5,1
    800041fe:	0711                	addi	a4,a4,4
    80004200:	fec79be3          	bne	a5,a2,800041f6 <log_write+0x5c>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004204:	0621                	addi	a2,a2,8
    80004206:	060a                	slli	a2,a2,0x2
    80004208:	0001d797          	auipc	a5,0x1d
    8000420c:	70078793          	addi	a5,a5,1792 # 80021908 <log>
    80004210:	963e                	add	a2,a2,a5
    80004212:	44dc                	lw	a5,12(s1)
    80004214:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004216:	8526                	mv	a0,s1
    80004218:	fffff097          	auipc	ra,0xfffff
    8000421c:	dbc080e7          	jalr	-580(ra) # 80002fd4 <bpin>
    log.lh.n++;
    80004220:	0001d717          	auipc	a4,0x1d
    80004224:	6e870713          	addi	a4,a4,1768 # 80021908 <log>
    80004228:	575c                	lw	a5,44(a4)
    8000422a:	2785                	addiw	a5,a5,1
    8000422c:	d75c                	sw	a5,44(a4)
    8000422e:	a83d                	j	8000426c <log_write+0xd2>
    panic("too big a transaction");
    80004230:	00004517          	auipc	a0,0x4
    80004234:	3e850513          	addi	a0,a0,1000 # 80008618 <syscalls+0x1f0>
    80004238:	ffffc097          	auipc	ra,0xffffc
    8000423c:	310080e7          	jalr	784(ra) # 80000548 <panic>
    panic("log_write outside of trans");
    80004240:	00004517          	auipc	a0,0x4
    80004244:	3f050513          	addi	a0,a0,1008 # 80008630 <syscalls+0x208>
    80004248:	ffffc097          	auipc	ra,0xffffc
    8000424c:	300080e7          	jalr	768(ra) # 80000548 <panic>
  for (i = 0; i < log.lh.n; i++) {
    80004250:	4781                	li	a5,0
  log.lh.block[i] = b->blockno;
    80004252:	00878713          	addi	a4,a5,8
    80004256:	00271693          	slli	a3,a4,0x2
    8000425a:	0001d717          	auipc	a4,0x1d
    8000425e:	6ae70713          	addi	a4,a4,1710 # 80021908 <log>
    80004262:	9736                	add	a4,a4,a3
    80004264:	44d4                	lw	a3,12(s1)
    80004266:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004268:	faf607e3          	beq	a2,a5,80004216 <log_write+0x7c>
  }
  release(&log.lock);
    8000426c:	0001d517          	auipc	a0,0x1d
    80004270:	69c50513          	addi	a0,a0,1692 # 80021908 <log>
    80004274:	ffffd097          	auipc	ra,0xffffd
    80004278:	a50080e7          	jalr	-1456(ra) # 80000cc4 <release>
}
    8000427c:	60e2                	ld	ra,24(sp)
    8000427e:	6442                	ld	s0,16(sp)
    80004280:	64a2                	ld	s1,8(sp)
    80004282:	6902                	ld	s2,0(sp)
    80004284:	6105                	addi	sp,sp,32
    80004286:	8082                	ret

0000000080004288 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004288:	1101                	addi	sp,sp,-32
    8000428a:	ec06                	sd	ra,24(sp)
    8000428c:	e822                	sd	s0,16(sp)
    8000428e:	e426                	sd	s1,8(sp)
    80004290:	e04a                	sd	s2,0(sp)
    80004292:	1000                	addi	s0,sp,32
    80004294:	84aa                	mv	s1,a0
    80004296:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004298:	00004597          	auipc	a1,0x4
    8000429c:	3b858593          	addi	a1,a1,952 # 80008650 <syscalls+0x228>
    800042a0:	0521                	addi	a0,a0,8
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	8de080e7          	jalr	-1826(ra) # 80000b80 <initlock>
  lk->name = name;
    800042aa:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800042ae:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800042b2:	0204a423          	sw	zero,40(s1)
}
    800042b6:	60e2                	ld	ra,24(sp)
    800042b8:	6442                	ld	s0,16(sp)
    800042ba:	64a2                	ld	s1,8(sp)
    800042bc:	6902                	ld	s2,0(sp)
    800042be:	6105                	addi	sp,sp,32
    800042c0:	8082                	ret

00000000800042c2 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800042c2:	1101                	addi	sp,sp,-32
    800042c4:	ec06                	sd	ra,24(sp)
    800042c6:	e822                	sd	s0,16(sp)
    800042c8:	e426                	sd	s1,8(sp)
    800042ca:	e04a                	sd	s2,0(sp)
    800042cc:	1000                	addi	s0,sp,32
    800042ce:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800042d0:	00850913          	addi	s2,a0,8
    800042d4:	854a                	mv	a0,s2
    800042d6:	ffffd097          	auipc	ra,0xffffd
    800042da:	93a080e7          	jalr	-1734(ra) # 80000c10 <acquire>
  while (lk->locked) {
    800042de:	409c                	lw	a5,0(s1)
    800042e0:	cb89                	beqz	a5,800042f2 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800042e2:	85ca                	mv	a1,s2
    800042e4:	8526                	mv	a0,s1
    800042e6:	ffffe097          	auipc	ra,0xffffe
    800042ea:	f04080e7          	jalr	-252(ra) # 800021ea <sleep>
  while (lk->locked) {
    800042ee:	409c                	lw	a5,0(s1)
    800042f0:	fbed                	bnez	a5,800042e2 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800042f2:	4785                	li	a5,1
    800042f4:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	6e8080e7          	jalr	1768(ra) # 800019de <myproc>
    800042fe:	5d1c                	lw	a5,56(a0)
    80004300:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004302:	854a                	mv	a0,s2
    80004304:	ffffd097          	auipc	ra,0xffffd
    80004308:	9c0080e7          	jalr	-1600(ra) # 80000cc4 <release>
}
    8000430c:	60e2                	ld	ra,24(sp)
    8000430e:	6442                	ld	s0,16(sp)
    80004310:	64a2                	ld	s1,8(sp)
    80004312:	6902                	ld	s2,0(sp)
    80004314:	6105                	addi	sp,sp,32
    80004316:	8082                	ret

0000000080004318 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004318:	1101                	addi	sp,sp,-32
    8000431a:	ec06                	sd	ra,24(sp)
    8000431c:	e822                	sd	s0,16(sp)
    8000431e:	e426                	sd	s1,8(sp)
    80004320:	e04a                	sd	s2,0(sp)
    80004322:	1000                	addi	s0,sp,32
    80004324:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004326:	00850913          	addi	s2,a0,8
    8000432a:	854a                	mv	a0,s2
    8000432c:	ffffd097          	auipc	ra,0xffffd
    80004330:	8e4080e7          	jalr	-1820(ra) # 80000c10 <acquire>
  lk->locked = 0;
    80004334:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004338:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000433c:	8526                	mv	a0,s1
    8000433e:	ffffe097          	auipc	ra,0xffffe
    80004342:	032080e7          	jalr	50(ra) # 80002370 <wakeup>
  release(&lk->lk);
    80004346:	854a                	mv	a0,s2
    80004348:	ffffd097          	auipc	ra,0xffffd
    8000434c:	97c080e7          	jalr	-1668(ra) # 80000cc4 <release>
}
    80004350:	60e2                	ld	ra,24(sp)
    80004352:	6442                	ld	s0,16(sp)
    80004354:	64a2                	ld	s1,8(sp)
    80004356:	6902                	ld	s2,0(sp)
    80004358:	6105                	addi	sp,sp,32
    8000435a:	8082                	ret

000000008000435c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000435c:	7179                	addi	sp,sp,-48
    8000435e:	f406                	sd	ra,40(sp)
    80004360:	f022                	sd	s0,32(sp)
    80004362:	ec26                	sd	s1,24(sp)
    80004364:	e84a                	sd	s2,16(sp)
    80004366:	e44e                	sd	s3,8(sp)
    80004368:	1800                	addi	s0,sp,48
    8000436a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000436c:	00850913          	addi	s2,a0,8
    80004370:	854a                	mv	a0,s2
    80004372:	ffffd097          	auipc	ra,0xffffd
    80004376:	89e080e7          	jalr	-1890(ra) # 80000c10 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000437a:	409c                	lw	a5,0(s1)
    8000437c:	ef99                	bnez	a5,8000439a <holdingsleep+0x3e>
    8000437e:	4481                	li	s1,0
  release(&lk->lk);
    80004380:	854a                	mv	a0,s2
    80004382:	ffffd097          	auipc	ra,0xffffd
    80004386:	942080e7          	jalr	-1726(ra) # 80000cc4 <release>
  return r;
}
    8000438a:	8526                	mv	a0,s1
    8000438c:	70a2                	ld	ra,40(sp)
    8000438e:	7402                	ld	s0,32(sp)
    80004390:	64e2                	ld	s1,24(sp)
    80004392:	6942                	ld	s2,16(sp)
    80004394:	69a2                	ld	s3,8(sp)
    80004396:	6145                	addi	sp,sp,48
    80004398:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000439a:	0284a983          	lw	s3,40(s1)
    8000439e:	ffffd097          	auipc	ra,0xffffd
    800043a2:	640080e7          	jalr	1600(ra) # 800019de <myproc>
    800043a6:	5d04                	lw	s1,56(a0)
    800043a8:	413484b3          	sub	s1,s1,s3
    800043ac:	0014b493          	seqz	s1,s1
    800043b0:	bfc1                	j	80004380 <holdingsleep+0x24>

00000000800043b2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800043b2:	1141                	addi	sp,sp,-16
    800043b4:	e406                	sd	ra,8(sp)
    800043b6:	e022                	sd	s0,0(sp)
    800043b8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800043ba:	00004597          	auipc	a1,0x4
    800043be:	2a658593          	addi	a1,a1,678 # 80008660 <syscalls+0x238>
    800043c2:	0001d517          	auipc	a0,0x1d
    800043c6:	68e50513          	addi	a0,a0,1678 # 80021a50 <ftable>
    800043ca:	ffffc097          	auipc	ra,0xffffc
    800043ce:	7b6080e7          	jalr	1974(ra) # 80000b80 <initlock>
}
    800043d2:	60a2                	ld	ra,8(sp)
    800043d4:	6402                	ld	s0,0(sp)
    800043d6:	0141                	addi	sp,sp,16
    800043d8:	8082                	ret

00000000800043da <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800043da:	1101                	addi	sp,sp,-32
    800043dc:	ec06                	sd	ra,24(sp)
    800043de:	e822                	sd	s0,16(sp)
    800043e0:	e426                	sd	s1,8(sp)
    800043e2:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800043e4:	0001d517          	auipc	a0,0x1d
    800043e8:	66c50513          	addi	a0,a0,1644 # 80021a50 <ftable>
    800043ec:	ffffd097          	auipc	ra,0xffffd
    800043f0:	824080e7          	jalr	-2012(ra) # 80000c10 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800043f4:	0001d497          	auipc	s1,0x1d
    800043f8:	67448493          	addi	s1,s1,1652 # 80021a68 <ftable+0x18>
    800043fc:	0001e717          	auipc	a4,0x1e
    80004400:	60c70713          	addi	a4,a4,1548 # 80022a08 <ftable+0xfb8>
    if(f->ref == 0){
    80004404:	40dc                	lw	a5,4(s1)
    80004406:	cf99                	beqz	a5,80004424 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004408:	02848493          	addi	s1,s1,40
    8000440c:	fee49ce3          	bne	s1,a4,80004404 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004410:	0001d517          	auipc	a0,0x1d
    80004414:	64050513          	addi	a0,a0,1600 # 80021a50 <ftable>
    80004418:	ffffd097          	auipc	ra,0xffffd
    8000441c:	8ac080e7          	jalr	-1876(ra) # 80000cc4 <release>
  return 0;
    80004420:	4481                	li	s1,0
    80004422:	a819                	j	80004438 <filealloc+0x5e>
      f->ref = 1;
    80004424:	4785                	li	a5,1
    80004426:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004428:	0001d517          	auipc	a0,0x1d
    8000442c:	62850513          	addi	a0,a0,1576 # 80021a50 <ftable>
    80004430:	ffffd097          	auipc	ra,0xffffd
    80004434:	894080e7          	jalr	-1900(ra) # 80000cc4 <release>
}
    80004438:	8526                	mv	a0,s1
    8000443a:	60e2                	ld	ra,24(sp)
    8000443c:	6442                	ld	s0,16(sp)
    8000443e:	64a2                	ld	s1,8(sp)
    80004440:	6105                	addi	sp,sp,32
    80004442:	8082                	ret

0000000080004444 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004444:	1101                	addi	sp,sp,-32
    80004446:	ec06                	sd	ra,24(sp)
    80004448:	e822                	sd	s0,16(sp)
    8000444a:	e426                	sd	s1,8(sp)
    8000444c:	1000                	addi	s0,sp,32
    8000444e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004450:	0001d517          	auipc	a0,0x1d
    80004454:	60050513          	addi	a0,a0,1536 # 80021a50 <ftable>
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	7b8080e7          	jalr	1976(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    80004460:	40dc                	lw	a5,4(s1)
    80004462:	02f05263          	blez	a5,80004486 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004466:	2785                	addiw	a5,a5,1
    80004468:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000446a:	0001d517          	auipc	a0,0x1d
    8000446e:	5e650513          	addi	a0,a0,1510 # 80021a50 <ftable>
    80004472:	ffffd097          	auipc	ra,0xffffd
    80004476:	852080e7          	jalr	-1966(ra) # 80000cc4 <release>
  return f;
}
    8000447a:	8526                	mv	a0,s1
    8000447c:	60e2                	ld	ra,24(sp)
    8000447e:	6442                	ld	s0,16(sp)
    80004480:	64a2                	ld	s1,8(sp)
    80004482:	6105                	addi	sp,sp,32
    80004484:	8082                	ret
    panic("filedup");
    80004486:	00004517          	auipc	a0,0x4
    8000448a:	1e250513          	addi	a0,a0,482 # 80008668 <syscalls+0x240>
    8000448e:	ffffc097          	auipc	ra,0xffffc
    80004492:	0ba080e7          	jalr	186(ra) # 80000548 <panic>

0000000080004496 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004496:	7139                	addi	sp,sp,-64
    80004498:	fc06                	sd	ra,56(sp)
    8000449a:	f822                	sd	s0,48(sp)
    8000449c:	f426                	sd	s1,40(sp)
    8000449e:	f04a                	sd	s2,32(sp)
    800044a0:	ec4e                	sd	s3,24(sp)
    800044a2:	e852                	sd	s4,16(sp)
    800044a4:	e456                	sd	s5,8(sp)
    800044a6:	0080                	addi	s0,sp,64
    800044a8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800044aa:	0001d517          	auipc	a0,0x1d
    800044ae:	5a650513          	addi	a0,a0,1446 # 80021a50 <ftable>
    800044b2:	ffffc097          	auipc	ra,0xffffc
    800044b6:	75e080e7          	jalr	1886(ra) # 80000c10 <acquire>
  if(f->ref < 1)
    800044ba:	40dc                	lw	a5,4(s1)
    800044bc:	06f05163          	blez	a5,8000451e <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    800044c0:	37fd                	addiw	a5,a5,-1
    800044c2:	0007871b          	sext.w	a4,a5
    800044c6:	c0dc                	sw	a5,4(s1)
    800044c8:	06e04363          	bgtz	a4,8000452e <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800044cc:	0004a903          	lw	s2,0(s1)
    800044d0:	0094ca83          	lbu	s5,9(s1)
    800044d4:	0104ba03          	ld	s4,16(s1)
    800044d8:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    800044dc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800044e0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800044e4:	0001d517          	auipc	a0,0x1d
    800044e8:	56c50513          	addi	a0,a0,1388 # 80021a50 <ftable>
    800044ec:	ffffc097          	auipc	ra,0xffffc
    800044f0:	7d8080e7          	jalr	2008(ra) # 80000cc4 <release>

  if(ff.type == FD_PIPE){
    800044f4:	4785                	li	a5,1
    800044f6:	04f90d63          	beq	s2,a5,80004550 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800044fa:	3979                	addiw	s2,s2,-2
    800044fc:	4785                	li	a5,1
    800044fe:	0527e063          	bltu	a5,s2,8000453e <fileclose+0xa8>
    begin_op();
    80004502:	00000097          	auipc	ra,0x0
    80004506:	ac2080e7          	jalr	-1342(ra) # 80003fc4 <begin_op>
    iput(ff.ip);
    8000450a:	854e                	mv	a0,s3
    8000450c:	fffff097          	auipc	ra,0xfffff
    80004510:	2b6080e7          	jalr	694(ra) # 800037c2 <iput>
    end_op();
    80004514:	00000097          	auipc	ra,0x0
    80004518:	b30080e7          	jalr	-1232(ra) # 80004044 <end_op>
    8000451c:	a00d                	j	8000453e <fileclose+0xa8>
    panic("fileclose");
    8000451e:	00004517          	auipc	a0,0x4
    80004522:	15250513          	addi	a0,a0,338 # 80008670 <syscalls+0x248>
    80004526:	ffffc097          	auipc	ra,0xffffc
    8000452a:	022080e7          	jalr	34(ra) # 80000548 <panic>
    release(&ftable.lock);
    8000452e:	0001d517          	auipc	a0,0x1d
    80004532:	52250513          	addi	a0,a0,1314 # 80021a50 <ftable>
    80004536:	ffffc097          	auipc	ra,0xffffc
    8000453a:	78e080e7          	jalr	1934(ra) # 80000cc4 <release>
  }
}
    8000453e:	70e2                	ld	ra,56(sp)
    80004540:	7442                	ld	s0,48(sp)
    80004542:	74a2                	ld	s1,40(sp)
    80004544:	7902                	ld	s2,32(sp)
    80004546:	69e2                	ld	s3,24(sp)
    80004548:	6a42                	ld	s4,16(sp)
    8000454a:	6aa2                	ld	s5,8(sp)
    8000454c:	6121                	addi	sp,sp,64
    8000454e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004550:	85d6                	mv	a1,s5
    80004552:	8552                	mv	a0,s4
    80004554:	00000097          	auipc	ra,0x0
    80004558:	372080e7          	jalr	882(ra) # 800048c6 <pipeclose>
    8000455c:	b7cd                	j	8000453e <fileclose+0xa8>

000000008000455e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000455e:	715d                	addi	sp,sp,-80
    80004560:	e486                	sd	ra,72(sp)
    80004562:	e0a2                	sd	s0,64(sp)
    80004564:	fc26                	sd	s1,56(sp)
    80004566:	f84a                	sd	s2,48(sp)
    80004568:	f44e                	sd	s3,40(sp)
    8000456a:	0880                	addi	s0,sp,80
    8000456c:	84aa                	mv	s1,a0
    8000456e:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004570:	ffffd097          	auipc	ra,0xffffd
    80004574:	46e080e7          	jalr	1134(ra) # 800019de <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004578:	409c                	lw	a5,0(s1)
    8000457a:	37f9                	addiw	a5,a5,-2
    8000457c:	4705                	li	a4,1
    8000457e:	04f76763          	bltu	a4,a5,800045cc <filestat+0x6e>
    80004582:	892a                	mv	s2,a0
    ilock(f->ip);
    80004584:	6c88                	ld	a0,24(s1)
    80004586:	fffff097          	auipc	ra,0xfffff
    8000458a:	082080e7          	jalr	130(ra) # 80003608 <ilock>
    stati(f->ip, &st);
    8000458e:	fb840593          	addi	a1,s0,-72
    80004592:	6c88                	ld	a0,24(s1)
    80004594:	fffff097          	auipc	ra,0xfffff
    80004598:	2fe080e7          	jalr	766(ra) # 80003892 <stati>
    iunlock(f->ip);
    8000459c:	6c88                	ld	a0,24(s1)
    8000459e:	fffff097          	auipc	ra,0xfffff
    800045a2:	12c080e7          	jalr	300(ra) # 800036ca <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800045a6:	46e1                	li	a3,24
    800045a8:	fb840613          	addi	a2,s0,-72
    800045ac:	85ce                	mv	a1,s3
    800045ae:	05093503          	ld	a0,80(s2)
    800045b2:	ffffd097          	auipc	ra,0xffffd
    800045b6:	120080e7          	jalr	288(ra) # 800016d2 <copyout>
    800045ba:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    800045be:	60a6                	ld	ra,72(sp)
    800045c0:	6406                	ld	s0,64(sp)
    800045c2:	74e2                	ld	s1,56(sp)
    800045c4:	7942                	ld	s2,48(sp)
    800045c6:	79a2                	ld	s3,40(sp)
    800045c8:	6161                	addi	sp,sp,80
    800045ca:	8082                	ret
  return -1;
    800045cc:	557d                	li	a0,-1
    800045ce:	bfc5                	j	800045be <filestat+0x60>

00000000800045d0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800045d0:	7179                	addi	sp,sp,-48
    800045d2:	f406                	sd	ra,40(sp)
    800045d4:	f022                	sd	s0,32(sp)
    800045d6:	ec26                	sd	s1,24(sp)
    800045d8:	e84a                	sd	s2,16(sp)
    800045da:	e44e                	sd	s3,8(sp)
    800045dc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800045de:	00854783          	lbu	a5,8(a0)
    800045e2:	c3d5                	beqz	a5,80004686 <fileread+0xb6>
    800045e4:	84aa                	mv	s1,a0
    800045e6:	89ae                	mv	s3,a1
    800045e8:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800045ea:	411c                	lw	a5,0(a0)
    800045ec:	4705                	li	a4,1
    800045ee:	04e78963          	beq	a5,a4,80004640 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800045f2:	470d                	li	a4,3
    800045f4:	04e78d63          	beq	a5,a4,8000464e <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800045f8:	4709                	li	a4,2
    800045fa:	06e79e63          	bne	a5,a4,80004676 <fileread+0xa6>
    ilock(f->ip);
    800045fe:	6d08                	ld	a0,24(a0)
    80004600:	fffff097          	auipc	ra,0xfffff
    80004604:	008080e7          	jalr	8(ra) # 80003608 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004608:	874a                	mv	a4,s2
    8000460a:	5094                	lw	a3,32(s1)
    8000460c:	864e                	mv	a2,s3
    8000460e:	4585                	li	a1,1
    80004610:	6c88                	ld	a0,24(s1)
    80004612:	fffff097          	auipc	ra,0xfffff
    80004616:	2aa080e7          	jalr	682(ra) # 800038bc <readi>
    8000461a:	892a                	mv	s2,a0
    8000461c:	00a05563          	blez	a0,80004626 <fileread+0x56>
      f->off += r;
    80004620:	509c                	lw	a5,32(s1)
    80004622:	9fa9                	addw	a5,a5,a0
    80004624:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004626:	6c88                	ld	a0,24(s1)
    80004628:	fffff097          	auipc	ra,0xfffff
    8000462c:	0a2080e7          	jalr	162(ra) # 800036ca <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80004630:	854a                	mv	a0,s2
    80004632:	70a2                	ld	ra,40(sp)
    80004634:	7402                	ld	s0,32(sp)
    80004636:	64e2                	ld	s1,24(sp)
    80004638:	6942                	ld	s2,16(sp)
    8000463a:	69a2                	ld	s3,8(sp)
    8000463c:	6145                	addi	sp,sp,48
    8000463e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004640:	6908                	ld	a0,16(a0)
    80004642:	00000097          	auipc	ra,0x0
    80004646:	418080e7          	jalr	1048(ra) # 80004a5a <piperead>
    8000464a:	892a                	mv	s2,a0
    8000464c:	b7d5                	j	80004630 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000464e:	02451783          	lh	a5,36(a0)
    80004652:	03079693          	slli	a3,a5,0x30
    80004656:	92c1                	srli	a3,a3,0x30
    80004658:	4725                	li	a4,9
    8000465a:	02d76863          	bltu	a4,a3,8000468a <fileread+0xba>
    8000465e:	0792                	slli	a5,a5,0x4
    80004660:	0001d717          	auipc	a4,0x1d
    80004664:	35070713          	addi	a4,a4,848 # 800219b0 <devsw>
    80004668:	97ba                	add	a5,a5,a4
    8000466a:	639c                	ld	a5,0(a5)
    8000466c:	c38d                	beqz	a5,8000468e <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000466e:	4505                	li	a0,1
    80004670:	9782                	jalr	a5
    80004672:	892a                	mv	s2,a0
    80004674:	bf75                	j	80004630 <fileread+0x60>
    panic("fileread");
    80004676:	00004517          	auipc	a0,0x4
    8000467a:	00a50513          	addi	a0,a0,10 # 80008680 <syscalls+0x258>
    8000467e:	ffffc097          	auipc	ra,0xffffc
    80004682:	eca080e7          	jalr	-310(ra) # 80000548 <panic>
    return -1;
    80004686:	597d                	li	s2,-1
    80004688:	b765                	j	80004630 <fileread+0x60>
      return -1;
    8000468a:	597d                	li	s2,-1
    8000468c:	b755                	j	80004630 <fileread+0x60>
    8000468e:	597d                	li	s2,-1
    80004690:	b745                	j	80004630 <fileread+0x60>

0000000080004692 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004692:	00954783          	lbu	a5,9(a0)
    80004696:	14078563          	beqz	a5,800047e0 <filewrite+0x14e>
{
    8000469a:	715d                	addi	sp,sp,-80
    8000469c:	e486                	sd	ra,72(sp)
    8000469e:	e0a2                	sd	s0,64(sp)
    800046a0:	fc26                	sd	s1,56(sp)
    800046a2:	f84a                	sd	s2,48(sp)
    800046a4:	f44e                	sd	s3,40(sp)
    800046a6:	f052                	sd	s4,32(sp)
    800046a8:	ec56                	sd	s5,24(sp)
    800046aa:	e85a                	sd	s6,16(sp)
    800046ac:	e45e                	sd	s7,8(sp)
    800046ae:	e062                	sd	s8,0(sp)
    800046b0:	0880                	addi	s0,sp,80
    800046b2:	892a                	mv	s2,a0
    800046b4:	8aae                	mv	s5,a1
    800046b6:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800046b8:	411c                	lw	a5,0(a0)
    800046ba:	4705                	li	a4,1
    800046bc:	02e78263          	beq	a5,a4,800046e0 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800046c0:	470d                	li	a4,3
    800046c2:	02e78563          	beq	a5,a4,800046ec <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800046c6:	4709                	li	a4,2
    800046c8:	10e79463          	bne	a5,a4,800047d0 <filewrite+0x13e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800046cc:	0ec05e63          	blez	a2,800047c8 <filewrite+0x136>
    int i = 0;
    800046d0:	4981                	li	s3,0
    800046d2:	6b05                	lui	s6,0x1
    800046d4:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    800046d8:	6b85                	lui	s7,0x1
    800046da:	c00b8b9b          	addiw	s7,s7,-1024
    800046de:	a851                	j	80004772 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    800046e0:	6908                	ld	a0,16(a0)
    800046e2:	00000097          	auipc	ra,0x0
    800046e6:	254080e7          	jalr	596(ra) # 80004936 <pipewrite>
    800046ea:	a85d                	j	800047a0 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800046ec:	02451783          	lh	a5,36(a0)
    800046f0:	03079693          	slli	a3,a5,0x30
    800046f4:	92c1                	srli	a3,a3,0x30
    800046f6:	4725                	li	a4,9
    800046f8:	0ed76663          	bltu	a4,a3,800047e4 <filewrite+0x152>
    800046fc:	0792                	slli	a5,a5,0x4
    800046fe:	0001d717          	auipc	a4,0x1d
    80004702:	2b270713          	addi	a4,a4,690 # 800219b0 <devsw>
    80004706:	97ba                	add	a5,a5,a4
    80004708:	679c                	ld	a5,8(a5)
    8000470a:	cff9                	beqz	a5,800047e8 <filewrite+0x156>
    ret = devsw[f->major].write(1, addr, n);
    8000470c:	4505                	li	a0,1
    8000470e:	9782                	jalr	a5
    80004710:	a841                	j	800047a0 <filewrite+0x10e>
    80004712:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80004716:	00000097          	auipc	ra,0x0
    8000471a:	8ae080e7          	jalr	-1874(ra) # 80003fc4 <begin_op>
      ilock(f->ip);
    8000471e:	01893503          	ld	a0,24(s2)
    80004722:	fffff097          	auipc	ra,0xfffff
    80004726:	ee6080e7          	jalr	-282(ra) # 80003608 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000472a:	8762                	mv	a4,s8
    8000472c:	02092683          	lw	a3,32(s2)
    80004730:	01598633          	add	a2,s3,s5
    80004734:	4585                	li	a1,1
    80004736:	01893503          	ld	a0,24(s2)
    8000473a:	fffff097          	auipc	ra,0xfffff
    8000473e:	278080e7          	jalr	632(ra) # 800039b2 <writei>
    80004742:	84aa                	mv	s1,a0
    80004744:	02a05f63          	blez	a0,80004782 <filewrite+0xf0>
        f->off += r;
    80004748:	02092783          	lw	a5,32(s2)
    8000474c:	9fa9                	addw	a5,a5,a0
    8000474e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004752:	01893503          	ld	a0,24(s2)
    80004756:	fffff097          	auipc	ra,0xfffff
    8000475a:	f74080e7          	jalr	-140(ra) # 800036ca <iunlock>
      end_op();
    8000475e:	00000097          	auipc	ra,0x0
    80004762:	8e6080e7          	jalr	-1818(ra) # 80004044 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004766:	049c1963          	bne	s8,s1,800047b8 <filewrite+0x126>
        panic("short filewrite");
      i += r;
    8000476a:	013489bb          	addw	s3,s1,s3
    while(i < n){
    8000476e:	0349d663          	bge	s3,s4,8000479a <filewrite+0x108>
      int n1 = n - i;
    80004772:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004776:	84be                	mv	s1,a5
    80004778:	2781                	sext.w	a5,a5
    8000477a:	f8fb5ce3          	bge	s6,a5,80004712 <filewrite+0x80>
    8000477e:	84de                	mv	s1,s7
    80004780:	bf49                	j	80004712 <filewrite+0x80>
      iunlock(f->ip);
    80004782:	01893503          	ld	a0,24(s2)
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	f44080e7          	jalr	-188(ra) # 800036ca <iunlock>
      end_op();
    8000478e:	00000097          	auipc	ra,0x0
    80004792:	8b6080e7          	jalr	-1866(ra) # 80004044 <end_op>
      if(r < 0)
    80004796:	fc04d8e3          	bgez	s1,80004766 <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    8000479a:	8552                	mv	a0,s4
    8000479c:	033a1863          	bne	s4,s3,800047cc <filewrite+0x13a>
  } else {
    panic("filewrite");
  }

  return ret;
}
    800047a0:	60a6                	ld	ra,72(sp)
    800047a2:	6406                	ld	s0,64(sp)
    800047a4:	74e2                	ld	s1,56(sp)
    800047a6:	7942                	ld	s2,48(sp)
    800047a8:	79a2                	ld	s3,40(sp)
    800047aa:	7a02                	ld	s4,32(sp)
    800047ac:	6ae2                	ld	s5,24(sp)
    800047ae:	6b42                	ld	s6,16(sp)
    800047b0:	6ba2                	ld	s7,8(sp)
    800047b2:	6c02                	ld	s8,0(sp)
    800047b4:	6161                	addi	sp,sp,80
    800047b6:	8082                	ret
        panic("short filewrite");
    800047b8:	00004517          	auipc	a0,0x4
    800047bc:	ed850513          	addi	a0,a0,-296 # 80008690 <syscalls+0x268>
    800047c0:	ffffc097          	auipc	ra,0xffffc
    800047c4:	d88080e7          	jalr	-632(ra) # 80000548 <panic>
    int i = 0;
    800047c8:	4981                	li	s3,0
    800047ca:	bfc1                	j	8000479a <filewrite+0x108>
    ret = (i == n ? n : -1);
    800047cc:	557d                	li	a0,-1
    800047ce:	bfc9                	j	800047a0 <filewrite+0x10e>
    panic("filewrite");
    800047d0:	00004517          	auipc	a0,0x4
    800047d4:	ed050513          	addi	a0,a0,-304 # 800086a0 <syscalls+0x278>
    800047d8:	ffffc097          	auipc	ra,0xffffc
    800047dc:	d70080e7          	jalr	-656(ra) # 80000548 <panic>
    return -1;
    800047e0:	557d                	li	a0,-1
}
    800047e2:	8082                	ret
      return -1;
    800047e4:	557d                	li	a0,-1
    800047e6:	bf6d                	j	800047a0 <filewrite+0x10e>
    800047e8:	557d                	li	a0,-1
    800047ea:	bf5d                	j	800047a0 <filewrite+0x10e>

00000000800047ec <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800047ec:	7179                	addi	sp,sp,-48
    800047ee:	f406                	sd	ra,40(sp)
    800047f0:	f022                	sd	s0,32(sp)
    800047f2:	ec26                	sd	s1,24(sp)
    800047f4:	e84a                	sd	s2,16(sp)
    800047f6:	e44e                	sd	s3,8(sp)
    800047f8:	e052                	sd	s4,0(sp)
    800047fa:	1800                	addi	s0,sp,48
    800047fc:	84aa                	mv	s1,a0
    800047fe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004800:	0005b023          	sd	zero,0(a1)
    80004804:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004808:	00000097          	auipc	ra,0x0
    8000480c:	bd2080e7          	jalr	-1070(ra) # 800043da <filealloc>
    80004810:	e088                	sd	a0,0(s1)
    80004812:	c551                	beqz	a0,8000489e <pipealloc+0xb2>
    80004814:	00000097          	auipc	ra,0x0
    80004818:	bc6080e7          	jalr	-1082(ra) # 800043da <filealloc>
    8000481c:	00aa3023          	sd	a0,0(s4)
    80004820:	c92d                	beqz	a0,80004892 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004822:	ffffc097          	auipc	ra,0xffffc
    80004826:	2fe080e7          	jalr	766(ra) # 80000b20 <kalloc>
    8000482a:	892a                	mv	s2,a0
    8000482c:	c125                	beqz	a0,8000488c <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    8000482e:	4985                	li	s3,1
    80004830:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004834:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004838:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000483c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004840:	00004597          	auipc	a1,0x4
    80004844:	e7058593          	addi	a1,a1,-400 # 800086b0 <syscalls+0x288>
    80004848:	ffffc097          	auipc	ra,0xffffc
    8000484c:	338080e7          	jalr	824(ra) # 80000b80 <initlock>
  (*f0)->type = FD_PIPE;
    80004850:	609c                	ld	a5,0(s1)
    80004852:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004856:	609c                	ld	a5,0(s1)
    80004858:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000485c:	609c                	ld	a5,0(s1)
    8000485e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004862:	609c                	ld	a5,0(s1)
    80004864:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004868:	000a3783          	ld	a5,0(s4)
    8000486c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004870:	000a3783          	ld	a5,0(s4)
    80004874:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004878:	000a3783          	ld	a5,0(s4)
    8000487c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004880:	000a3783          	ld	a5,0(s4)
    80004884:	0127b823          	sd	s2,16(a5)
  return 0;
    80004888:	4501                	li	a0,0
    8000488a:	a025                	j	800048b2 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000488c:	6088                	ld	a0,0(s1)
    8000488e:	e501                	bnez	a0,80004896 <pipealloc+0xaa>
    80004890:	a039                	j	8000489e <pipealloc+0xb2>
    80004892:	6088                	ld	a0,0(s1)
    80004894:	c51d                	beqz	a0,800048c2 <pipealloc+0xd6>
    fileclose(*f0);
    80004896:	00000097          	auipc	ra,0x0
    8000489a:	c00080e7          	jalr	-1024(ra) # 80004496 <fileclose>
  if(*f1)
    8000489e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800048a2:	557d                	li	a0,-1
  if(*f1)
    800048a4:	c799                	beqz	a5,800048b2 <pipealloc+0xc6>
    fileclose(*f1);
    800048a6:	853e                	mv	a0,a5
    800048a8:	00000097          	auipc	ra,0x0
    800048ac:	bee080e7          	jalr	-1042(ra) # 80004496 <fileclose>
  return -1;
    800048b0:	557d                	li	a0,-1
}
    800048b2:	70a2                	ld	ra,40(sp)
    800048b4:	7402                	ld	s0,32(sp)
    800048b6:	64e2                	ld	s1,24(sp)
    800048b8:	6942                	ld	s2,16(sp)
    800048ba:	69a2                	ld	s3,8(sp)
    800048bc:	6a02                	ld	s4,0(sp)
    800048be:	6145                	addi	sp,sp,48
    800048c0:	8082                	ret
  return -1;
    800048c2:	557d                	li	a0,-1
    800048c4:	b7fd                	j	800048b2 <pipealloc+0xc6>

00000000800048c6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800048c6:	1101                	addi	sp,sp,-32
    800048c8:	ec06                	sd	ra,24(sp)
    800048ca:	e822                	sd	s0,16(sp)
    800048cc:	e426                	sd	s1,8(sp)
    800048ce:	e04a                	sd	s2,0(sp)
    800048d0:	1000                	addi	s0,sp,32
    800048d2:	84aa                	mv	s1,a0
    800048d4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800048d6:	ffffc097          	auipc	ra,0xffffc
    800048da:	33a080e7          	jalr	826(ra) # 80000c10 <acquire>
  if(writable){
    800048de:	02090d63          	beqz	s2,80004918 <pipeclose+0x52>
    pi->writeopen = 0;
    800048e2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800048e6:	21848513          	addi	a0,s1,536
    800048ea:	ffffe097          	auipc	ra,0xffffe
    800048ee:	a86080e7          	jalr	-1402(ra) # 80002370 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800048f2:	2204b783          	ld	a5,544(s1)
    800048f6:	eb95                	bnez	a5,8000492a <pipeclose+0x64>
    release(&pi->lock);
    800048f8:	8526                	mv	a0,s1
    800048fa:	ffffc097          	auipc	ra,0xffffc
    800048fe:	3ca080e7          	jalr	970(ra) # 80000cc4 <release>
    kfree((char*)pi);
    80004902:	8526                	mv	a0,s1
    80004904:	ffffc097          	auipc	ra,0xffffc
    80004908:	120080e7          	jalr	288(ra) # 80000a24 <kfree>
  } else
    release(&pi->lock);
}
    8000490c:	60e2                	ld	ra,24(sp)
    8000490e:	6442                	ld	s0,16(sp)
    80004910:	64a2                	ld	s1,8(sp)
    80004912:	6902                	ld	s2,0(sp)
    80004914:	6105                	addi	sp,sp,32
    80004916:	8082                	ret
    pi->readopen = 0;
    80004918:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000491c:	21c48513          	addi	a0,s1,540
    80004920:	ffffe097          	auipc	ra,0xffffe
    80004924:	a50080e7          	jalr	-1456(ra) # 80002370 <wakeup>
    80004928:	b7e9                	j	800048f2 <pipeclose+0x2c>
    release(&pi->lock);
    8000492a:	8526                	mv	a0,s1
    8000492c:	ffffc097          	auipc	ra,0xffffc
    80004930:	398080e7          	jalr	920(ra) # 80000cc4 <release>
}
    80004934:	bfe1                	j	8000490c <pipeclose+0x46>

0000000080004936 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004936:	7119                	addi	sp,sp,-128
    80004938:	fc86                	sd	ra,120(sp)
    8000493a:	f8a2                	sd	s0,112(sp)
    8000493c:	f4a6                	sd	s1,104(sp)
    8000493e:	f0ca                	sd	s2,96(sp)
    80004940:	ecce                	sd	s3,88(sp)
    80004942:	e8d2                	sd	s4,80(sp)
    80004944:	e4d6                	sd	s5,72(sp)
    80004946:	e0da                	sd	s6,64(sp)
    80004948:	fc5e                	sd	s7,56(sp)
    8000494a:	f862                	sd	s8,48(sp)
    8000494c:	f466                	sd	s9,40(sp)
    8000494e:	f06a                	sd	s10,32(sp)
    80004950:	ec6e                	sd	s11,24(sp)
    80004952:	0100                	addi	s0,sp,128
    80004954:	84aa                	mv	s1,a0
    80004956:	8cae                	mv	s9,a1
    80004958:	8b32                	mv	s6,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    8000495a:	ffffd097          	auipc	ra,0xffffd
    8000495e:	084080e7          	jalr	132(ra) # 800019de <myproc>
    80004962:	892a                	mv	s2,a0

  acquire(&pi->lock);
    80004964:	8526                	mv	a0,s1
    80004966:	ffffc097          	auipc	ra,0xffffc
    8000496a:	2aa080e7          	jalr	682(ra) # 80000c10 <acquire>
  for(i = 0; i < n; i++){
    8000496e:	0d605963          	blez	s6,80004a40 <pipewrite+0x10a>
    80004972:	89a6                	mv	s3,s1
    80004974:	3b7d                	addiw	s6,s6,-1
    80004976:	1b02                	slli	s6,s6,0x20
    80004978:	020b5b13          	srli	s6,s6,0x20
    8000497c:	4b81                	li	s7,0
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || pr->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    8000497e:	21848a93          	addi	s5,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004982:	21c48a13          	addi	s4,s1,540
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004986:	5dfd                	li	s11,-1
    80004988:	000b8d1b          	sext.w	s10,s7
    8000498c:	8c6a                	mv	s8,s10
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    8000498e:	2184a783          	lw	a5,536(s1)
    80004992:	21c4a703          	lw	a4,540(s1)
    80004996:	2007879b          	addiw	a5,a5,512
    8000499a:	02f71b63          	bne	a4,a5,800049d0 <pipewrite+0x9a>
      if(pi->readopen == 0 || pr->killed){
    8000499e:	2204a783          	lw	a5,544(s1)
    800049a2:	cbad                	beqz	a5,80004a14 <pipewrite+0xde>
    800049a4:	03092783          	lw	a5,48(s2)
    800049a8:	e7b5                	bnez	a5,80004a14 <pipewrite+0xde>
      wakeup(&pi->nread);
    800049aa:	8556                	mv	a0,s5
    800049ac:	ffffe097          	auipc	ra,0xffffe
    800049b0:	9c4080e7          	jalr	-1596(ra) # 80002370 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800049b4:	85ce                	mv	a1,s3
    800049b6:	8552                	mv	a0,s4
    800049b8:	ffffe097          	auipc	ra,0xffffe
    800049bc:	832080e7          	jalr	-1998(ra) # 800021ea <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    800049c0:	2184a783          	lw	a5,536(s1)
    800049c4:	21c4a703          	lw	a4,540(s1)
    800049c8:	2007879b          	addiw	a5,a5,512
    800049cc:	fcf709e3          	beq	a4,a5,8000499e <pipewrite+0x68>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800049d0:	4685                	li	a3,1
    800049d2:	019b8633          	add	a2,s7,s9
    800049d6:	f8f40593          	addi	a1,s0,-113
    800049da:	05093503          	ld	a0,80(s2)
    800049de:	ffffd097          	auipc	ra,0xffffd
    800049e2:	d80080e7          	jalr	-640(ra) # 8000175e <copyin>
    800049e6:	05b50e63          	beq	a0,s11,80004a42 <pipewrite+0x10c>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800049ea:	21c4a783          	lw	a5,540(s1)
    800049ee:	0017871b          	addiw	a4,a5,1
    800049f2:	20e4ae23          	sw	a4,540(s1)
    800049f6:	1ff7f793          	andi	a5,a5,511
    800049fa:	97a6                	add	a5,a5,s1
    800049fc:	f8f44703          	lbu	a4,-113(s0)
    80004a00:	00e78c23          	sb	a4,24(a5)
  for(i = 0; i < n; i++){
    80004a04:	001d0c1b          	addiw	s8,s10,1
    80004a08:	001b8793          	addi	a5,s7,1 # 1001 <_entry-0x7fffefff>
    80004a0c:	036b8b63          	beq	s7,s6,80004a42 <pipewrite+0x10c>
    80004a10:	8bbe                	mv	s7,a5
    80004a12:	bf9d                	j	80004988 <pipewrite+0x52>
        release(&pi->lock);
    80004a14:	8526                	mv	a0,s1
    80004a16:	ffffc097          	auipc	ra,0xffffc
    80004a1a:	2ae080e7          	jalr	686(ra) # 80000cc4 <release>
        return -1;
    80004a1e:	5c7d                	li	s8,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);
  return i;
}
    80004a20:	8562                	mv	a0,s8
    80004a22:	70e6                	ld	ra,120(sp)
    80004a24:	7446                	ld	s0,112(sp)
    80004a26:	74a6                	ld	s1,104(sp)
    80004a28:	7906                	ld	s2,96(sp)
    80004a2a:	69e6                	ld	s3,88(sp)
    80004a2c:	6a46                	ld	s4,80(sp)
    80004a2e:	6aa6                	ld	s5,72(sp)
    80004a30:	6b06                	ld	s6,64(sp)
    80004a32:	7be2                	ld	s7,56(sp)
    80004a34:	7c42                	ld	s8,48(sp)
    80004a36:	7ca2                	ld	s9,40(sp)
    80004a38:	7d02                	ld	s10,32(sp)
    80004a3a:	6de2                	ld	s11,24(sp)
    80004a3c:	6109                	addi	sp,sp,128
    80004a3e:	8082                	ret
  for(i = 0; i < n; i++){
    80004a40:	4c01                	li	s8,0
  wakeup(&pi->nread);
    80004a42:	21848513          	addi	a0,s1,536
    80004a46:	ffffe097          	auipc	ra,0xffffe
    80004a4a:	92a080e7          	jalr	-1750(ra) # 80002370 <wakeup>
  release(&pi->lock);
    80004a4e:	8526                	mv	a0,s1
    80004a50:	ffffc097          	auipc	ra,0xffffc
    80004a54:	274080e7          	jalr	628(ra) # 80000cc4 <release>
  return i;
    80004a58:	b7e1                	j	80004a20 <pipewrite+0xea>

0000000080004a5a <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004a5a:	715d                	addi	sp,sp,-80
    80004a5c:	e486                	sd	ra,72(sp)
    80004a5e:	e0a2                	sd	s0,64(sp)
    80004a60:	fc26                	sd	s1,56(sp)
    80004a62:	f84a                	sd	s2,48(sp)
    80004a64:	f44e                	sd	s3,40(sp)
    80004a66:	f052                	sd	s4,32(sp)
    80004a68:	ec56                	sd	s5,24(sp)
    80004a6a:	e85a                	sd	s6,16(sp)
    80004a6c:	0880                	addi	s0,sp,80
    80004a6e:	84aa                	mv	s1,a0
    80004a70:	892e                	mv	s2,a1
    80004a72:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004a74:	ffffd097          	auipc	ra,0xffffd
    80004a78:	f6a080e7          	jalr	-150(ra) # 800019de <myproc>
    80004a7c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004a7e:	8b26                	mv	s6,s1
    80004a80:	8526                	mv	a0,s1
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	18e080e7          	jalr	398(ra) # 80000c10 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a8a:	2184a703          	lw	a4,536(s1)
    80004a8e:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004a92:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004a96:	02f71463          	bne	a4,a5,80004abe <piperead+0x64>
    80004a9a:	2244a783          	lw	a5,548(s1)
    80004a9e:	c385                	beqz	a5,80004abe <piperead+0x64>
    if(pr->killed){
    80004aa0:	030a2783          	lw	a5,48(s4)
    80004aa4:	ebc1                	bnez	a5,80004b34 <piperead+0xda>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004aa6:	85da                	mv	a1,s6
    80004aa8:	854e                	mv	a0,s3
    80004aaa:	ffffd097          	auipc	ra,0xffffd
    80004aae:	740080e7          	jalr	1856(ra) # 800021ea <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004ab2:	2184a703          	lw	a4,536(s1)
    80004ab6:	21c4a783          	lw	a5,540(s1)
    80004aba:	fef700e3          	beq	a4,a5,80004a9a <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004abe:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ac0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004ac2:	05505363          	blez	s5,80004b08 <piperead+0xae>
    if(pi->nread == pi->nwrite)
    80004ac6:	2184a783          	lw	a5,536(s1)
    80004aca:	21c4a703          	lw	a4,540(s1)
    80004ace:	02f70d63          	beq	a4,a5,80004b08 <piperead+0xae>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004ad2:	0017871b          	addiw	a4,a5,1
    80004ad6:	20e4ac23          	sw	a4,536(s1)
    80004ada:	1ff7f793          	andi	a5,a5,511
    80004ade:	97a6                	add	a5,a5,s1
    80004ae0:	0187c783          	lbu	a5,24(a5)
    80004ae4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004ae8:	4685                	li	a3,1
    80004aea:	fbf40613          	addi	a2,s0,-65
    80004aee:	85ca                	mv	a1,s2
    80004af0:	050a3503          	ld	a0,80(s4)
    80004af4:	ffffd097          	auipc	ra,0xffffd
    80004af8:	bde080e7          	jalr	-1058(ra) # 800016d2 <copyout>
    80004afc:	01650663          	beq	a0,s6,80004b08 <piperead+0xae>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004b00:	2985                	addiw	s3,s3,1
    80004b02:	0905                	addi	s2,s2,1
    80004b04:	fd3a91e3          	bne	s5,s3,80004ac6 <piperead+0x6c>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004b08:	21c48513          	addi	a0,s1,540
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	864080e7          	jalr	-1948(ra) # 80002370 <wakeup>
  release(&pi->lock);
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffc097          	auipc	ra,0xffffc
    80004b1a:	1ae080e7          	jalr	430(ra) # 80000cc4 <release>
  return i;
}
    80004b1e:	854e                	mv	a0,s3
    80004b20:	60a6                	ld	ra,72(sp)
    80004b22:	6406                	ld	s0,64(sp)
    80004b24:	74e2                	ld	s1,56(sp)
    80004b26:	7942                	ld	s2,48(sp)
    80004b28:	79a2                	ld	s3,40(sp)
    80004b2a:	7a02                	ld	s4,32(sp)
    80004b2c:	6ae2                	ld	s5,24(sp)
    80004b2e:	6b42                	ld	s6,16(sp)
    80004b30:	6161                	addi	sp,sp,80
    80004b32:	8082                	ret
      release(&pi->lock);
    80004b34:	8526                	mv	a0,s1
    80004b36:	ffffc097          	auipc	ra,0xffffc
    80004b3a:	18e080e7          	jalr	398(ra) # 80000cc4 <release>
      return -1;
    80004b3e:	59fd                	li	s3,-1
    80004b40:	bff9                	j	80004b1e <piperead+0xc4>

0000000080004b42 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    80004b42:	df010113          	addi	sp,sp,-528
    80004b46:	20113423          	sd	ra,520(sp)
    80004b4a:	20813023          	sd	s0,512(sp)
    80004b4e:	ffa6                	sd	s1,504(sp)
    80004b50:	fbca                	sd	s2,496(sp)
    80004b52:	f7ce                	sd	s3,488(sp)
    80004b54:	f3d2                	sd	s4,480(sp)
    80004b56:	efd6                	sd	s5,472(sp)
    80004b58:	ebda                	sd	s6,464(sp)
    80004b5a:	e7de                	sd	s7,456(sp)
    80004b5c:	e3e2                	sd	s8,448(sp)
    80004b5e:	ff66                	sd	s9,440(sp)
    80004b60:	fb6a                	sd	s10,432(sp)
    80004b62:	f76e                	sd	s11,424(sp)
    80004b64:	0c00                	addi	s0,sp,528
    80004b66:	84aa                	mv	s1,a0
    80004b68:	dea43c23          	sd	a0,-520(s0)
    80004b6c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004b70:	ffffd097          	auipc	ra,0xffffd
    80004b74:	e6e080e7          	jalr	-402(ra) # 800019de <myproc>
    80004b78:	892a                	mv	s2,a0

  begin_op();
    80004b7a:	fffff097          	auipc	ra,0xfffff
    80004b7e:	44a080e7          	jalr	1098(ra) # 80003fc4 <begin_op>

  if((ip = namei(path)) == 0){
    80004b82:	8526                	mv	a0,s1
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	234080e7          	jalr	564(ra) # 80003db8 <namei>
    80004b8c:	c92d                	beqz	a0,80004bfe <exec+0xbc>
    80004b8e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004b90:	fffff097          	auipc	ra,0xfffff
    80004b94:	a78080e7          	jalr	-1416(ra) # 80003608 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004b98:	04000713          	li	a4,64
    80004b9c:	4681                	li	a3,0
    80004b9e:	e4840613          	addi	a2,s0,-440
    80004ba2:	4581                	li	a1,0
    80004ba4:	8526                	mv	a0,s1
    80004ba6:	fffff097          	auipc	ra,0xfffff
    80004baa:	d16080e7          	jalr	-746(ra) # 800038bc <readi>
    80004bae:	04000793          	li	a5,64
    80004bb2:	00f51a63          	bne	a0,a5,80004bc6 <exec+0x84>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004bb6:	e4842703          	lw	a4,-440(s0)
    80004bba:	464c47b7          	lui	a5,0x464c4
    80004bbe:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004bc2:	04f70463          	beq	a4,a5,80004c0a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004bc6:	8526                	mv	a0,s1
    80004bc8:	fffff097          	auipc	ra,0xfffff
    80004bcc:	ca2080e7          	jalr	-862(ra) # 8000386a <iunlockput>
    end_op();
    80004bd0:	fffff097          	auipc	ra,0xfffff
    80004bd4:	474080e7          	jalr	1140(ra) # 80004044 <end_op>
  }
  return -1;
    80004bd8:	557d                	li	a0,-1
}
    80004bda:	20813083          	ld	ra,520(sp)
    80004bde:	20013403          	ld	s0,512(sp)
    80004be2:	74fe                	ld	s1,504(sp)
    80004be4:	795e                	ld	s2,496(sp)
    80004be6:	79be                	ld	s3,488(sp)
    80004be8:	7a1e                	ld	s4,480(sp)
    80004bea:	6afe                	ld	s5,472(sp)
    80004bec:	6b5e                	ld	s6,464(sp)
    80004bee:	6bbe                	ld	s7,456(sp)
    80004bf0:	6c1e                	ld	s8,448(sp)
    80004bf2:	7cfa                	ld	s9,440(sp)
    80004bf4:	7d5a                	ld	s10,432(sp)
    80004bf6:	7dba                	ld	s11,424(sp)
    80004bf8:	21010113          	addi	sp,sp,528
    80004bfc:	8082                	ret
    end_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	446080e7          	jalr	1094(ra) # 80004044 <end_op>
    return -1;
    80004c06:	557d                	li	a0,-1
    80004c08:	bfc9                	j	80004bda <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004c0a:	854a                	mv	a0,s2
    80004c0c:	ffffd097          	auipc	ra,0xffffd
    80004c10:	e96080e7          	jalr	-362(ra) # 80001aa2 <proc_pagetable>
    80004c14:	8baa                	mv	s7,a0
    80004c16:	d945                	beqz	a0,80004bc6 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c18:	e6842983          	lw	s3,-408(s0)
    80004c1c:	e8045783          	lhu	a5,-384(s0)
    80004c20:	c7ad                	beqz	a5,80004c8a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004c22:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004c24:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004c26:	6c85                	lui	s9,0x1
    80004c28:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004c2c:	def43823          	sd	a5,-528(s0)
    80004c30:	a42d                	j	80004e5a <exec+0x318>
    panic("loadseg: va must be page aligned");

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004c32:	00004517          	auipc	a0,0x4
    80004c36:	a8650513          	addi	a0,a0,-1402 # 800086b8 <syscalls+0x290>
    80004c3a:	ffffc097          	auipc	ra,0xffffc
    80004c3e:	90e080e7          	jalr	-1778(ra) # 80000548 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004c42:	8756                	mv	a4,s5
    80004c44:	012d86bb          	addw	a3,s11,s2
    80004c48:	4581                	li	a1,0
    80004c4a:	8526                	mv	a0,s1
    80004c4c:	fffff097          	auipc	ra,0xfffff
    80004c50:	c70080e7          	jalr	-912(ra) # 800038bc <readi>
    80004c54:	2501                	sext.w	a0,a0
    80004c56:	1aaa9963          	bne	s5,a0,80004e08 <exec+0x2c6>
  for(i = 0; i < sz; i += PGSIZE){
    80004c5a:	6785                	lui	a5,0x1
    80004c5c:	0127893b          	addw	s2,a5,s2
    80004c60:	77fd                	lui	a5,0xfffff
    80004c62:	01478a3b          	addw	s4,a5,s4
    80004c66:	1f897163          	bgeu	s2,s8,80004e48 <exec+0x306>
    pa = walkaddr(pagetable, va + i);
    80004c6a:	02091593          	slli	a1,s2,0x20
    80004c6e:	9181                	srli	a1,a1,0x20
    80004c70:	95ea                	add	a1,a1,s10
    80004c72:	855e                	mv	a0,s7
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	42a080e7          	jalr	1066(ra) # 8000109e <walkaddr>
    80004c7c:	862a                	mv	a2,a0
    if(pa == 0)
    80004c7e:	d955                	beqz	a0,80004c32 <exec+0xf0>
      n = PGSIZE;
    80004c80:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004c82:	fd9a70e3          	bgeu	s4,s9,80004c42 <exec+0x100>
      n = sz - i;
    80004c86:	8ad2                	mv	s5,s4
    80004c88:	bf6d                	j	80004c42 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG+1], stackbase;
    80004c8a:	4901                	li	s2,0
  iunlockput(ip);
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	fffff097          	auipc	ra,0xfffff
    80004c92:	bdc080e7          	jalr	-1060(ra) # 8000386a <iunlockput>
  end_op();
    80004c96:	fffff097          	auipc	ra,0xfffff
    80004c9a:	3ae080e7          	jalr	942(ra) # 80004044 <end_op>
  p = myproc();
    80004c9e:	ffffd097          	auipc	ra,0xffffd
    80004ca2:	d40080e7          	jalr	-704(ra) # 800019de <myproc>
    80004ca6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004ca8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004cac:	6785                	lui	a5,0x1
    80004cae:	17fd                	addi	a5,a5,-1
    80004cb0:	993e                	add	s2,s2,a5
    80004cb2:	757d                	lui	a0,0xfffff
    80004cb4:	00a977b3          	and	a5,s2,a0
    80004cb8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004cbc:	6609                	lui	a2,0x2
    80004cbe:	963e                	add	a2,a2,a5
    80004cc0:	85be                	mv	a1,a5
    80004cc2:	855e                	mv	a0,s7
    80004cc4:	ffffc097          	auipc	ra,0xffffc
    80004cc8:	7be080e7          	jalr	1982(ra) # 80001482 <uvmalloc>
    80004ccc:	8b2a                	mv	s6,a0
  ip = 0;
    80004cce:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    80004cd0:	12050c63          	beqz	a0,80004e08 <exec+0x2c6>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004cd4:	75f9                	lui	a1,0xffffe
    80004cd6:	95aa                	add	a1,a1,a0
    80004cd8:	855e                	mv	a0,s7
    80004cda:	ffffd097          	auipc	ra,0xffffd
    80004cde:	9c6080e7          	jalr	-1594(ra) # 800016a0 <uvmclear>
  stackbase = sp - PGSIZE;
    80004ce2:	7c7d                	lui	s8,0xfffff
    80004ce4:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004ce6:	e0043783          	ld	a5,-512(s0)
    80004cea:	6388                	ld	a0,0(a5)
    80004cec:	c535                	beqz	a0,80004d58 <exec+0x216>
    80004cee:	e8840993          	addi	s3,s0,-376
    80004cf2:	f8840c93          	addi	s9,s0,-120
  sp = sz;
    80004cf6:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	19c080e7          	jalr	412(ra) # 80000e94 <strlen>
    80004d00:	2505                	addiw	a0,a0,1
    80004d02:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004d06:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004d0a:	13896363          	bltu	s2,s8,80004e30 <exec+0x2ee>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004d0e:	e0043d83          	ld	s11,-512(s0)
    80004d12:	000dba03          	ld	s4,0(s11)
    80004d16:	8552                	mv	a0,s4
    80004d18:	ffffc097          	auipc	ra,0xffffc
    80004d1c:	17c080e7          	jalr	380(ra) # 80000e94 <strlen>
    80004d20:	0015069b          	addiw	a3,a0,1
    80004d24:	8652                	mv	a2,s4
    80004d26:	85ca                	mv	a1,s2
    80004d28:	855e                	mv	a0,s7
    80004d2a:	ffffd097          	auipc	ra,0xffffd
    80004d2e:	9a8080e7          	jalr	-1624(ra) # 800016d2 <copyout>
    80004d32:	10054363          	bltz	a0,80004e38 <exec+0x2f6>
    ustack[argc] = sp;
    80004d36:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004d3a:	0485                	addi	s1,s1,1
    80004d3c:	008d8793          	addi	a5,s11,8
    80004d40:	e0f43023          	sd	a5,-512(s0)
    80004d44:	008db503          	ld	a0,8(s11)
    80004d48:	c911                	beqz	a0,80004d5c <exec+0x21a>
    if(argc >= MAXARG)
    80004d4a:	09a1                	addi	s3,s3,8
    80004d4c:	fb3c96e3          	bne	s9,s3,80004cf8 <exec+0x1b6>
  sz = sz1;
    80004d50:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004d54:	4481                	li	s1,0
    80004d56:	a84d                	j	80004e08 <exec+0x2c6>
  sp = sz;
    80004d58:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004d5a:	4481                	li	s1,0
  ustack[argc] = 0;
    80004d5c:	00349793          	slli	a5,s1,0x3
    80004d60:	f9040713          	addi	a4,s0,-112
    80004d64:	97ba                	add	a5,a5,a4
    80004d66:	ee07bc23          	sd	zero,-264(a5) # ef8 <_entry-0x7ffff108>
  sp -= (argc+1) * sizeof(uint64);
    80004d6a:	00148693          	addi	a3,s1,1
    80004d6e:	068e                	slli	a3,a3,0x3
    80004d70:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004d74:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004d78:	01897663          	bgeu	s2,s8,80004d84 <exec+0x242>
  sz = sz1;
    80004d7c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004d80:	4481                	li	s1,0
    80004d82:	a059                	j	80004e08 <exec+0x2c6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004d84:	e8840613          	addi	a2,s0,-376
    80004d88:	85ca                	mv	a1,s2
    80004d8a:	855e                	mv	a0,s7
    80004d8c:	ffffd097          	auipc	ra,0xffffd
    80004d90:	946080e7          	jalr	-1722(ra) # 800016d2 <copyout>
    80004d94:	0a054663          	bltz	a0,80004e40 <exec+0x2fe>
  p->trapframe->a1 = sp;
    80004d98:	058ab783          	ld	a5,88(s5)
    80004d9c:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004da0:	df843783          	ld	a5,-520(s0)
    80004da4:	0007c703          	lbu	a4,0(a5)
    80004da8:	cf11                	beqz	a4,80004dc4 <exec+0x282>
    80004daa:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004dac:	02f00693          	li	a3,47
    80004db0:	a029                	j	80004dba <exec+0x278>
  for(last=s=path; *s; s++)
    80004db2:	0785                	addi	a5,a5,1
    80004db4:	fff7c703          	lbu	a4,-1(a5)
    80004db8:	c711                	beqz	a4,80004dc4 <exec+0x282>
    if(*s == '/')
    80004dba:	fed71ce3          	bne	a4,a3,80004db2 <exec+0x270>
      last = s+1;
    80004dbe:	def43c23          	sd	a5,-520(s0)
    80004dc2:	bfc5                	j	80004db2 <exec+0x270>
  safestrcpy(p->name, last, sizeof(p->name));
    80004dc4:	4641                	li	a2,16
    80004dc6:	df843583          	ld	a1,-520(s0)
    80004dca:	158a8513          	addi	a0,s5,344
    80004dce:	ffffc097          	auipc	ra,0xffffc
    80004dd2:	094080e7          	jalr	148(ra) # 80000e62 <safestrcpy>
  oldpagetable = p->pagetable;
    80004dd6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004dda:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004dde:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004de2:	058ab783          	ld	a5,88(s5)
    80004de6:	e6043703          	ld	a4,-416(s0)
    80004dea:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004dec:	058ab783          	ld	a5,88(s5)
    80004df0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004df4:	85ea                	mv	a1,s10
    80004df6:	ffffd097          	auipc	ra,0xffffd
    80004dfa:	d48080e7          	jalr	-696(ra) # 80001b3e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004dfe:	0004851b          	sext.w	a0,s1
    80004e02:	bbe1                	j	80004bda <exec+0x98>
    80004e04:	e1243423          	sd	s2,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004e08:	e0843583          	ld	a1,-504(s0)
    80004e0c:	855e                	mv	a0,s7
    80004e0e:	ffffd097          	auipc	ra,0xffffd
    80004e12:	d30080e7          	jalr	-720(ra) # 80001b3e <proc_freepagetable>
  if(ip){
    80004e16:	da0498e3          	bnez	s1,80004bc6 <exec+0x84>
  return -1;
    80004e1a:	557d                	li	a0,-1
    80004e1c:	bb7d                	j	80004bda <exec+0x98>
    80004e1e:	e1243423          	sd	s2,-504(s0)
    80004e22:	b7dd                	j	80004e08 <exec+0x2c6>
    80004e24:	e1243423          	sd	s2,-504(s0)
    80004e28:	b7c5                	j	80004e08 <exec+0x2c6>
    80004e2a:	e1243423          	sd	s2,-504(s0)
    80004e2e:	bfe9                	j	80004e08 <exec+0x2c6>
  sz = sz1;
    80004e30:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004e34:	4481                	li	s1,0
    80004e36:	bfc9                	j	80004e08 <exec+0x2c6>
  sz = sz1;
    80004e38:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004e3c:	4481                	li	s1,0
    80004e3e:	b7e9                	j	80004e08 <exec+0x2c6>
  sz = sz1;
    80004e40:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004e44:	4481                	li	s1,0
    80004e46:	b7c9                	j	80004e08 <exec+0x2c6>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e48:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004e4c:	2b05                	addiw	s6,s6,1
    80004e4e:	0389899b          	addiw	s3,s3,56
    80004e52:	e8045783          	lhu	a5,-384(s0)
    80004e56:	e2fb5be3          	bge	s6,a5,80004c8c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004e5a:	2981                	sext.w	s3,s3
    80004e5c:	03800713          	li	a4,56
    80004e60:	86ce                	mv	a3,s3
    80004e62:	e1040613          	addi	a2,s0,-496
    80004e66:	4581                	li	a1,0
    80004e68:	8526                	mv	a0,s1
    80004e6a:	fffff097          	auipc	ra,0xfffff
    80004e6e:	a52080e7          	jalr	-1454(ra) # 800038bc <readi>
    80004e72:	03800793          	li	a5,56
    80004e76:	f8f517e3          	bne	a0,a5,80004e04 <exec+0x2c2>
    if(ph.type != ELF_PROG_LOAD)
    80004e7a:	e1042783          	lw	a5,-496(s0)
    80004e7e:	4705                	li	a4,1
    80004e80:	fce796e3          	bne	a5,a4,80004e4c <exec+0x30a>
    if(ph.memsz < ph.filesz)
    80004e84:	e3843603          	ld	a2,-456(s0)
    80004e88:	e3043783          	ld	a5,-464(s0)
    80004e8c:	f8f669e3          	bltu	a2,a5,80004e1e <exec+0x2dc>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004e90:	e2043783          	ld	a5,-480(s0)
    80004e94:	963e                	add	a2,a2,a5
    80004e96:	f8f667e3          	bltu	a2,a5,80004e24 <exec+0x2e2>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004e9a:	85ca                	mv	a1,s2
    80004e9c:	855e                	mv	a0,s7
    80004e9e:	ffffc097          	auipc	ra,0xffffc
    80004ea2:	5e4080e7          	jalr	1508(ra) # 80001482 <uvmalloc>
    80004ea6:	e0a43423          	sd	a0,-504(s0)
    80004eaa:	d141                	beqz	a0,80004e2a <exec+0x2e8>
    if(ph.vaddr % PGSIZE != 0)
    80004eac:	e2043d03          	ld	s10,-480(s0)
    80004eb0:	df043783          	ld	a5,-528(s0)
    80004eb4:	00fd77b3          	and	a5,s10,a5
    80004eb8:	fba1                	bnez	a5,80004e08 <exec+0x2c6>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004eba:	e1842d83          	lw	s11,-488(s0)
    80004ebe:	e3042c03          	lw	s8,-464(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004ec2:	f80c03e3          	beqz	s8,80004e48 <exec+0x306>
    80004ec6:	8a62                	mv	s4,s8
    80004ec8:	4901                	li	s2,0
    80004eca:	b345                	j	80004c6a <exec+0x128>

0000000080004ecc <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004ecc:	7179                	addi	sp,sp,-48
    80004ece:	f406                	sd	ra,40(sp)
    80004ed0:	f022                	sd	s0,32(sp)
    80004ed2:	ec26                	sd	s1,24(sp)
    80004ed4:	e84a                	sd	s2,16(sp)
    80004ed6:	1800                	addi	s0,sp,48
    80004ed8:	892e                	mv	s2,a1
    80004eda:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    80004edc:	fdc40593          	addi	a1,s0,-36
    80004ee0:	ffffe097          	auipc	ra,0xffffe
    80004ee4:	bb6080e7          	jalr	-1098(ra) # 80002a96 <argint>
    80004ee8:	04054063          	bltz	a0,80004f28 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004eec:	fdc42703          	lw	a4,-36(s0)
    80004ef0:	47bd                	li	a5,15
    80004ef2:	02e7ed63          	bltu	a5,a4,80004f2c <argfd+0x60>
    80004ef6:	ffffd097          	auipc	ra,0xffffd
    80004efa:	ae8080e7          	jalr	-1304(ra) # 800019de <myproc>
    80004efe:	fdc42703          	lw	a4,-36(s0)
    80004f02:	01a70793          	addi	a5,a4,26
    80004f06:	078e                	slli	a5,a5,0x3
    80004f08:	953e                	add	a0,a0,a5
    80004f0a:	611c                	ld	a5,0(a0)
    80004f0c:	c395                	beqz	a5,80004f30 <argfd+0x64>
    return -1;
  if(pfd)
    80004f0e:	00090463          	beqz	s2,80004f16 <argfd+0x4a>
    *pfd = fd;
    80004f12:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004f16:	4501                	li	a0,0
  if(pf)
    80004f18:	c091                	beqz	s1,80004f1c <argfd+0x50>
    *pf = f;
    80004f1a:	e09c                	sd	a5,0(s1)
}
    80004f1c:	70a2                	ld	ra,40(sp)
    80004f1e:	7402                	ld	s0,32(sp)
    80004f20:	64e2                	ld	s1,24(sp)
    80004f22:	6942                	ld	s2,16(sp)
    80004f24:	6145                	addi	sp,sp,48
    80004f26:	8082                	ret
    return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	bfcd                	j	80004f1c <argfd+0x50>
    return -1;
    80004f2c:	557d                	li	a0,-1
    80004f2e:	b7fd                	j	80004f1c <argfd+0x50>
    80004f30:	557d                	li	a0,-1
    80004f32:	b7ed                	j	80004f1c <argfd+0x50>

0000000080004f34 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004f34:	1101                	addi	sp,sp,-32
    80004f36:	ec06                	sd	ra,24(sp)
    80004f38:	e822                	sd	s0,16(sp)
    80004f3a:	e426                	sd	s1,8(sp)
    80004f3c:	1000                	addi	s0,sp,32
    80004f3e:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004f40:	ffffd097          	auipc	ra,0xffffd
    80004f44:	a9e080e7          	jalr	-1378(ra) # 800019de <myproc>
    80004f48:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004f4a:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffd90d0>
    80004f4e:	4501                	li	a0,0
    80004f50:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004f52:	6398                	ld	a4,0(a5)
    80004f54:	cb19                	beqz	a4,80004f6a <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004f56:	2505                	addiw	a0,a0,1
    80004f58:	07a1                	addi	a5,a5,8
    80004f5a:	fed51ce3          	bne	a0,a3,80004f52 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004f5e:	557d                	li	a0,-1
}
    80004f60:	60e2                	ld	ra,24(sp)
    80004f62:	6442                	ld	s0,16(sp)
    80004f64:	64a2                	ld	s1,8(sp)
    80004f66:	6105                	addi	sp,sp,32
    80004f68:	8082                	ret
      p->ofile[fd] = f;
    80004f6a:	01a50793          	addi	a5,a0,26
    80004f6e:	078e                	slli	a5,a5,0x3
    80004f70:	963e                	add	a2,a2,a5
    80004f72:	e204                	sd	s1,0(a2)
      return fd;
    80004f74:	b7f5                	j	80004f60 <fdalloc+0x2c>

0000000080004f76 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004f76:	715d                	addi	sp,sp,-80
    80004f78:	e486                	sd	ra,72(sp)
    80004f7a:	e0a2                	sd	s0,64(sp)
    80004f7c:	fc26                	sd	s1,56(sp)
    80004f7e:	f84a                	sd	s2,48(sp)
    80004f80:	f44e                	sd	s3,40(sp)
    80004f82:	f052                	sd	s4,32(sp)
    80004f84:	ec56                	sd	s5,24(sp)
    80004f86:	0880                	addi	s0,sp,80
    80004f88:	89ae                	mv	s3,a1
    80004f8a:	8ab2                	mv	s5,a2
    80004f8c:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004f8e:	fb040593          	addi	a1,s0,-80
    80004f92:	fffff097          	auipc	ra,0xfffff
    80004f96:	e44080e7          	jalr	-444(ra) # 80003dd6 <nameiparent>
    80004f9a:	892a                	mv	s2,a0
    80004f9c:	12050e63          	beqz	a0,800050d8 <create+0x162>
    return 0;

  ilock(dp);
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	668080e7          	jalr	1640(ra) # 80003608 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004fa8:	4601                	li	a2,0
    80004faa:	fb040593          	addi	a1,s0,-80
    80004fae:	854a                	mv	a0,s2
    80004fb0:	fffff097          	auipc	ra,0xfffff
    80004fb4:	b36080e7          	jalr	-1226(ra) # 80003ae6 <dirlookup>
    80004fb8:	84aa                	mv	s1,a0
    80004fba:	c921                	beqz	a0,8000500a <create+0x94>
    iunlockput(dp);
    80004fbc:	854a                	mv	a0,s2
    80004fbe:	fffff097          	auipc	ra,0xfffff
    80004fc2:	8ac080e7          	jalr	-1876(ra) # 8000386a <iunlockput>
    ilock(ip);
    80004fc6:	8526                	mv	a0,s1
    80004fc8:	ffffe097          	auipc	ra,0xffffe
    80004fcc:	640080e7          	jalr	1600(ra) # 80003608 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004fd0:	2981                	sext.w	s3,s3
    80004fd2:	4789                	li	a5,2
    80004fd4:	02f99463          	bne	s3,a5,80004ffc <create+0x86>
    80004fd8:	0444d783          	lhu	a5,68(s1)
    80004fdc:	37f9                	addiw	a5,a5,-2
    80004fde:	17c2                	slli	a5,a5,0x30
    80004fe0:	93c1                	srli	a5,a5,0x30
    80004fe2:	4705                	li	a4,1
    80004fe4:	00f76c63          	bltu	a4,a5,80004ffc <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004fe8:	8526                	mv	a0,s1
    80004fea:	60a6                	ld	ra,72(sp)
    80004fec:	6406                	ld	s0,64(sp)
    80004fee:	74e2                	ld	s1,56(sp)
    80004ff0:	7942                	ld	s2,48(sp)
    80004ff2:	79a2                	ld	s3,40(sp)
    80004ff4:	7a02                	ld	s4,32(sp)
    80004ff6:	6ae2                	ld	s5,24(sp)
    80004ff8:	6161                	addi	sp,sp,80
    80004ffa:	8082                	ret
    iunlockput(ip);
    80004ffc:	8526                	mv	a0,s1
    80004ffe:	fffff097          	auipc	ra,0xfffff
    80005002:	86c080e7          	jalr	-1940(ra) # 8000386a <iunlockput>
    return 0;
    80005006:	4481                	li	s1,0
    80005008:	b7c5                	j	80004fe8 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    8000500a:	85ce                	mv	a1,s3
    8000500c:	00092503          	lw	a0,0(s2)
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	460080e7          	jalr	1120(ra) # 80003470 <ialloc>
    80005018:	84aa                	mv	s1,a0
    8000501a:	c521                	beqz	a0,80005062 <create+0xec>
  ilock(ip);
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	5ec080e7          	jalr	1516(ra) # 80003608 <ilock>
  ip->major = major;
    80005024:	05549323          	sh	s5,70(s1)
  ip->minor = minor;
    80005028:	05449423          	sh	s4,72(s1)
  ip->nlink = 1;
    8000502c:	4a05                	li	s4,1
    8000502e:	05449523          	sh	s4,74(s1)
  iupdate(ip);
    80005032:	8526                	mv	a0,s1
    80005034:	ffffe097          	auipc	ra,0xffffe
    80005038:	50a080e7          	jalr	1290(ra) # 8000353e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000503c:	2981                	sext.w	s3,s3
    8000503e:	03498a63          	beq	s3,s4,80005072 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005042:	40d0                	lw	a2,4(s1)
    80005044:	fb040593          	addi	a1,s0,-80
    80005048:	854a                	mv	a0,s2
    8000504a:	fffff097          	auipc	ra,0xfffff
    8000504e:	cac080e7          	jalr	-852(ra) # 80003cf6 <dirlink>
    80005052:	06054b63          	bltz	a0,800050c8 <create+0x152>
  iunlockput(dp);
    80005056:	854a                	mv	a0,s2
    80005058:	fffff097          	auipc	ra,0xfffff
    8000505c:	812080e7          	jalr	-2030(ra) # 8000386a <iunlockput>
  return ip;
    80005060:	b761                	j	80004fe8 <create+0x72>
    panic("create: ialloc");
    80005062:	00003517          	auipc	a0,0x3
    80005066:	67650513          	addi	a0,a0,1654 # 800086d8 <syscalls+0x2b0>
    8000506a:	ffffb097          	auipc	ra,0xffffb
    8000506e:	4de080e7          	jalr	1246(ra) # 80000548 <panic>
    dp->nlink++;  // for ".."
    80005072:	04a95783          	lhu	a5,74(s2)
    80005076:	2785                	addiw	a5,a5,1
    80005078:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000507c:	854a                	mv	a0,s2
    8000507e:	ffffe097          	auipc	ra,0xffffe
    80005082:	4c0080e7          	jalr	1216(ra) # 8000353e <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005086:	40d0                	lw	a2,4(s1)
    80005088:	00003597          	auipc	a1,0x3
    8000508c:	66058593          	addi	a1,a1,1632 # 800086e8 <syscalls+0x2c0>
    80005090:	8526                	mv	a0,s1
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	c64080e7          	jalr	-924(ra) # 80003cf6 <dirlink>
    8000509a:	00054f63          	bltz	a0,800050b8 <create+0x142>
    8000509e:	00492603          	lw	a2,4(s2)
    800050a2:	00003597          	auipc	a1,0x3
    800050a6:	64e58593          	addi	a1,a1,1614 # 800086f0 <syscalls+0x2c8>
    800050aa:	8526                	mv	a0,s1
    800050ac:	fffff097          	auipc	ra,0xfffff
    800050b0:	c4a080e7          	jalr	-950(ra) # 80003cf6 <dirlink>
    800050b4:	f80557e3          	bgez	a0,80005042 <create+0xcc>
      panic("create dots");
    800050b8:	00003517          	auipc	a0,0x3
    800050bc:	64050513          	addi	a0,a0,1600 # 800086f8 <syscalls+0x2d0>
    800050c0:	ffffb097          	auipc	ra,0xffffb
    800050c4:	488080e7          	jalr	1160(ra) # 80000548 <panic>
    panic("create: dirlink");
    800050c8:	00003517          	auipc	a0,0x3
    800050cc:	64050513          	addi	a0,a0,1600 # 80008708 <syscalls+0x2e0>
    800050d0:	ffffb097          	auipc	ra,0xffffb
    800050d4:	478080e7          	jalr	1144(ra) # 80000548 <panic>
    return 0;
    800050d8:	84aa                	mv	s1,a0
    800050da:	b739                	j	80004fe8 <create+0x72>

00000000800050dc <sys_dup>:
{
    800050dc:	7179                	addi	sp,sp,-48
    800050de:	f406                	sd	ra,40(sp)
    800050e0:	f022                	sd	s0,32(sp)
    800050e2:	ec26                	sd	s1,24(sp)
    800050e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800050e6:	fd840613          	addi	a2,s0,-40
    800050ea:	4581                	li	a1,0
    800050ec:	4501                	li	a0,0
    800050ee:	00000097          	auipc	ra,0x0
    800050f2:	dde080e7          	jalr	-546(ra) # 80004ecc <argfd>
    return -1;
    800050f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800050f8:	02054363          	bltz	a0,8000511e <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    800050fc:	fd843503          	ld	a0,-40(s0)
    80005100:	00000097          	auipc	ra,0x0
    80005104:	e34080e7          	jalr	-460(ra) # 80004f34 <fdalloc>
    80005108:	84aa                	mv	s1,a0
    return -1;
    8000510a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000510c:	00054963          	bltz	a0,8000511e <sys_dup+0x42>
  filedup(f);
    80005110:	fd843503          	ld	a0,-40(s0)
    80005114:	fffff097          	auipc	ra,0xfffff
    80005118:	330080e7          	jalr	816(ra) # 80004444 <filedup>
  return fd;
    8000511c:	87a6                	mv	a5,s1
}
    8000511e:	853e                	mv	a0,a5
    80005120:	70a2                	ld	ra,40(sp)
    80005122:	7402                	ld	s0,32(sp)
    80005124:	64e2                	ld	s1,24(sp)
    80005126:	6145                	addi	sp,sp,48
    80005128:	8082                	ret

000000008000512a <sys_read>:
{
    8000512a:	7179                	addi	sp,sp,-48
    8000512c:	f406                	sd	ra,40(sp)
    8000512e:	f022                	sd	s0,32(sp)
    80005130:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005132:	fe840613          	addi	a2,s0,-24
    80005136:	4581                	li	a1,0
    80005138:	4501                	li	a0,0
    8000513a:	00000097          	auipc	ra,0x0
    8000513e:	d92080e7          	jalr	-622(ra) # 80004ecc <argfd>
    return -1;
    80005142:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005144:	04054163          	bltz	a0,80005186 <sys_read+0x5c>
    80005148:	fe440593          	addi	a1,s0,-28
    8000514c:	4509                	li	a0,2
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	948080e7          	jalr	-1720(ra) # 80002a96 <argint>
    return -1;
    80005156:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005158:	02054763          	bltz	a0,80005186 <sys_read+0x5c>
    8000515c:	fd840593          	addi	a1,s0,-40
    80005160:	4505                	li	a0,1
    80005162:	ffffe097          	auipc	ra,0xffffe
    80005166:	956080e7          	jalr	-1706(ra) # 80002ab8 <argaddr>
    return -1;
    8000516a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000516c:	00054d63          	bltz	a0,80005186 <sys_read+0x5c>
  return fileread(f, p, n);
    80005170:	fe442603          	lw	a2,-28(s0)
    80005174:	fd843583          	ld	a1,-40(s0)
    80005178:	fe843503          	ld	a0,-24(s0)
    8000517c:	fffff097          	auipc	ra,0xfffff
    80005180:	454080e7          	jalr	1108(ra) # 800045d0 <fileread>
    80005184:	87aa                	mv	a5,a0
}
    80005186:	853e                	mv	a0,a5
    80005188:	70a2                	ld	ra,40(sp)
    8000518a:	7402                	ld	s0,32(sp)
    8000518c:	6145                	addi	sp,sp,48
    8000518e:	8082                	ret

0000000080005190 <sys_write>:
{
    80005190:	7179                	addi	sp,sp,-48
    80005192:	f406                	sd	ra,40(sp)
    80005194:	f022                	sd	s0,32(sp)
    80005196:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005198:	fe840613          	addi	a2,s0,-24
    8000519c:	4581                	li	a1,0
    8000519e:	4501                	li	a0,0
    800051a0:	00000097          	auipc	ra,0x0
    800051a4:	d2c080e7          	jalr	-724(ra) # 80004ecc <argfd>
    return -1;
    800051a8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051aa:	04054163          	bltz	a0,800051ec <sys_write+0x5c>
    800051ae:	fe440593          	addi	a1,s0,-28
    800051b2:	4509                	li	a0,2
    800051b4:	ffffe097          	auipc	ra,0xffffe
    800051b8:	8e2080e7          	jalr	-1822(ra) # 80002a96 <argint>
    return -1;
    800051bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051be:	02054763          	bltz	a0,800051ec <sys_write+0x5c>
    800051c2:	fd840593          	addi	a1,s0,-40
    800051c6:	4505                	li	a0,1
    800051c8:	ffffe097          	auipc	ra,0xffffe
    800051cc:	8f0080e7          	jalr	-1808(ra) # 80002ab8 <argaddr>
    return -1;
    800051d0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800051d2:	00054d63          	bltz	a0,800051ec <sys_write+0x5c>
  return filewrite(f, p, n);
    800051d6:	fe442603          	lw	a2,-28(s0)
    800051da:	fd843583          	ld	a1,-40(s0)
    800051de:	fe843503          	ld	a0,-24(s0)
    800051e2:	fffff097          	auipc	ra,0xfffff
    800051e6:	4b0080e7          	jalr	1200(ra) # 80004692 <filewrite>
    800051ea:	87aa                	mv	a5,a0
}
    800051ec:	853e                	mv	a0,a5
    800051ee:	70a2                	ld	ra,40(sp)
    800051f0:	7402                	ld	s0,32(sp)
    800051f2:	6145                	addi	sp,sp,48
    800051f4:	8082                	ret

00000000800051f6 <sys_close>:
{
    800051f6:	1101                	addi	sp,sp,-32
    800051f8:	ec06                	sd	ra,24(sp)
    800051fa:	e822                	sd	s0,16(sp)
    800051fc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800051fe:	fe040613          	addi	a2,s0,-32
    80005202:	fec40593          	addi	a1,s0,-20
    80005206:	4501                	li	a0,0
    80005208:	00000097          	auipc	ra,0x0
    8000520c:	cc4080e7          	jalr	-828(ra) # 80004ecc <argfd>
    return -1;
    80005210:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005212:	02054463          	bltz	a0,8000523a <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005216:	ffffc097          	auipc	ra,0xffffc
    8000521a:	7c8080e7          	jalr	1992(ra) # 800019de <myproc>
    8000521e:	fec42783          	lw	a5,-20(s0)
    80005222:	07e9                	addi	a5,a5,26
    80005224:	078e                	slli	a5,a5,0x3
    80005226:	97aa                	add	a5,a5,a0
    80005228:	0007b023          	sd	zero,0(a5)
  fileclose(f);
    8000522c:	fe043503          	ld	a0,-32(s0)
    80005230:	fffff097          	auipc	ra,0xfffff
    80005234:	266080e7          	jalr	614(ra) # 80004496 <fileclose>
  return 0;
    80005238:	4781                	li	a5,0
}
    8000523a:	853e                	mv	a0,a5
    8000523c:	60e2                	ld	ra,24(sp)
    8000523e:	6442                	ld	s0,16(sp)
    80005240:	6105                	addi	sp,sp,32
    80005242:	8082                	ret

0000000080005244 <sys_fstat>:
{
    80005244:	1101                	addi	sp,sp,-32
    80005246:	ec06                	sd	ra,24(sp)
    80005248:	e822                	sd	s0,16(sp)
    8000524a:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000524c:	fe840613          	addi	a2,s0,-24
    80005250:	4581                	li	a1,0
    80005252:	4501                	li	a0,0
    80005254:	00000097          	auipc	ra,0x0
    80005258:	c78080e7          	jalr	-904(ra) # 80004ecc <argfd>
    return -1;
    8000525c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000525e:	02054563          	bltz	a0,80005288 <sys_fstat+0x44>
    80005262:	fe040593          	addi	a1,s0,-32
    80005266:	4505                	li	a0,1
    80005268:	ffffe097          	auipc	ra,0xffffe
    8000526c:	850080e7          	jalr	-1968(ra) # 80002ab8 <argaddr>
    return -1;
    80005270:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80005272:	00054b63          	bltz	a0,80005288 <sys_fstat+0x44>
  return filestat(f, st);
    80005276:	fe043583          	ld	a1,-32(s0)
    8000527a:	fe843503          	ld	a0,-24(s0)
    8000527e:	fffff097          	auipc	ra,0xfffff
    80005282:	2e0080e7          	jalr	736(ra) # 8000455e <filestat>
    80005286:	87aa                	mv	a5,a0
}
    80005288:	853e                	mv	a0,a5
    8000528a:	60e2                	ld	ra,24(sp)
    8000528c:	6442                	ld	s0,16(sp)
    8000528e:	6105                	addi	sp,sp,32
    80005290:	8082                	ret

0000000080005292 <sys_link>:
{
    80005292:	7169                	addi	sp,sp,-304
    80005294:	f606                	sd	ra,296(sp)
    80005296:	f222                	sd	s0,288(sp)
    80005298:	ee26                	sd	s1,280(sp)
    8000529a:	ea4a                	sd	s2,272(sp)
    8000529c:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000529e:	08000613          	li	a2,128
    800052a2:	ed040593          	addi	a1,s0,-304
    800052a6:	4501                	li	a0,0
    800052a8:	ffffe097          	auipc	ra,0xffffe
    800052ac:	832080e7          	jalr	-1998(ra) # 80002ada <argstr>
    return -1;
    800052b0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052b2:	10054e63          	bltz	a0,800053ce <sys_link+0x13c>
    800052b6:	08000613          	li	a2,128
    800052ba:	f5040593          	addi	a1,s0,-176
    800052be:	4505                	li	a0,1
    800052c0:	ffffe097          	auipc	ra,0xffffe
    800052c4:	81a080e7          	jalr	-2022(ra) # 80002ada <argstr>
    return -1;
    800052c8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800052ca:	10054263          	bltz	a0,800053ce <sys_link+0x13c>
  begin_op();
    800052ce:	fffff097          	auipc	ra,0xfffff
    800052d2:	cf6080e7          	jalr	-778(ra) # 80003fc4 <begin_op>
  if((ip = namei(old)) == 0){
    800052d6:	ed040513          	addi	a0,s0,-304
    800052da:	fffff097          	auipc	ra,0xfffff
    800052de:	ade080e7          	jalr	-1314(ra) # 80003db8 <namei>
    800052e2:	84aa                	mv	s1,a0
    800052e4:	c551                	beqz	a0,80005370 <sys_link+0xde>
  ilock(ip);
    800052e6:	ffffe097          	auipc	ra,0xffffe
    800052ea:	322080e7          	jalr	802(ra) # 80003608 <ilock>
  if(ip->type == T_DIR){
    800052ee:	04449703          	lh	a4,68(s1)
    800052f2:	4785                	li	a5,1
    800052f4:	08f70463          	beq	a4,a5,8000537c <sys_link+0xea>
  ip->nlink++;
    800052f8:	04a4d783          	lhu	a5,74(s1)
    800052fc:	2785                	addiw	a5,a5,1
    800052fe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005302:	8526                	mv	a0,s1
    80005304:	ffffe097          	auipc	ra,0xffffe
    80005308:	23a080e7          	jalr	570(ra) # 8000353e <iupdate>
  iunlock(ip);
    8000530c:	8526                	mv	a0,s1
    8000530e:	ffffe097          	auipc	ra,0xffffe
    80005312:	3bc080e7          	jalr	956(ra) # 800036ca <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005316:	fd040593          	addi	a1,s0,-48
    8000531a:	f5040513          	addi	a0,s0,-176
    8000531e:	fffff097          	auipc	ra,0xfffff
    80005322:	ab8080e7          	jalr	-1352(ra) # 80003dd6 <nameiparent>
    80005326:	892a                	mv	s2,a0
    80005328:	c935                	beqz	a0,8000539c <sys_link+0x10a>
  ilock(dp);
    8000532a:	ffffe097          	auipc	ra,0xffffe
    8000532e:	2de080e7          	jalr	734(ra) # 80003608 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005332:	00092703          	lw	a4,0(s2)
    80005336:	409c                	lw	a5,0(s1)
    80005338:	04f71d63          	bne	a4,a5,80005392 <sys_link+0x100>
    8000533c:	40d0                	lw	a2,4(s1)
    8000533e:	fd040593          	addi	a1,s0,-48
    80005342:	854a                	mv	a0,s2
    80005344:	fffff097          	auipc	ra,0xfffff
    80005348:	9b2080e7          	jalr	-1614(ra) # 80003cf6 <dirlink>
    8000534c:	04054363          	bltz	a0,80005392 <sys_link+0x100>
  iunlockput(dp);
    80005350:	854a                	mv	a0,s2
    80005352:	ffffe097          	auipc	ra,0xffffe
    80005356:	518080e7          	jalr	1304(ra) # 8000386a <iunlockput>
  iput(ip);
    8000535a:	8526                	mv	a0,s1
    8000535c:	ffffe097          	auipc	ra,0xffffe
    80005360:	466080e7          	jalr	1126(ra) # 800037c2 <iput>
  end_op();
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	ce0080e7          	jalr	-800(ra) # 80004044 <end_op>
  return 0;
    8000536c:	4781                	li	a5,0
    8000536e:	a085                	j	800053ce <sys_link+0x13c>
    end_op();
    80005370:	fffff097          	auipc	ra,0xfffff
    80005374:	cd4080e7          	jalr	-812(ra) # 80004044 <end_op>
    return -1;
    80005378:	57fd                	li	a5,-1
    8000537a:	a891                	j	800053ce <sys_link+0x13c>
    iunlockput(ip);
    8000537c:	8526                	mv	a0,s1
    8000537e:	ffffe097          	auipc	ra,0xffffe
    80005382:	4ec080e7          	jalr	1260(ra) # 8000386a <iunlockput>
    end_op();
    80005386:	fffff097          	auipc	ra,0xfffff
    8000538a:	cbe080e7          	jalr	-834(ra) # 80004044 <end_op>
    return -1;
    8000538e:	57fd                	li	a5,-1
    80005390:	a83d                	j	800053ce <sys_link+0x13c>
    iunlockput(dp);
    80005392:	854a                	mv	a0,s2
    80005394:	ffffe097          	auipc	ra,0xffffe
    80005398:	4d6080e7          	jalr	1238(ra) # 8000386a <iunlockput>
  ilock(ip);
    8000539c:	8526                	mv	a0,s1
    8000539e:	ffffe097          	auipc	ra,0xffffe
    800053a2:	26a080e7          	jalr	618(ra) # 80003608 <ilock>
  ip->nlink--;
    800053a6:	04a4d783          	lhu	a5,74(s1)
    800053aa:	37fd                	addiw	a5,a5,-1
    800053ac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800053b0:	8526                	mv	a0,s1
    800053b2:	ffffe097          	auipc	ra,0xffffe
    800053b6:	18c080e7          	jalr	396(ra) # 8000353e <iupdate>
  iunlockput(ip);
    800053ba:	8526                	mv	a0,s1
    800053bc:	ffffe097          	auipc	ra,0xffffe
    800053c0:	4ae080e7          	jalr	1198(ra) # 8000386a <iunlockput>
  end_op();
    800053c4:	fffff097          	auipc	ra,0xfffff
    800053c8:	c80080e7          	jalr	-896(ra) # 80004044 <end_op>
  return -1;
    800053cc:	57fd                	li	a5,-1
}
    800053ce:	853e                	mv	a0,a5
    800053d0:	70b2                	ld	ra,296(sp)
    800053d2:	7412                	ld	s0,288(sp)
    800053d4:	64f2                	ld	s1,280(sp)
    800053d6:	6952                	ld	s2,272(sp)
    800053d8:	6155                	addi	sp,sp,304
    800053da:	8082                	ret

00000000800053dc <sys_unlink>:
{
    800053dc:	7151                	addi	sp,sp,-240
    800053de:	f586                	sd	ra,232(sp)
    800053e0:	f1a2                	sd	s0,224(sp)
    800053e2:	eda6                	sd	s1,216(sp)
    800053e4:	e9ca                	sd	s2,208(sp)
    800053e6:	e5ce                	sd	s3,200(sp)
    800053e8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800053ea:	08000613          	li	a2,128
    800053ee:	f3040593          	addi	a1,s0,-208
    800053f2:	4501                	li	a0,0
    800053f4:	ffffd097          	auipc	ra,0xffffd
    800053f8:	6e6080e7          	jalr	1766(ra) # 80002ada <argstr>
    800053fc:	18054163          	bltz	a0,8000557e <sys_unlink+0x1a2>
  begin_op();
    80005400:	fffff097          	auipc	ra,0xfffff
    80005404:	bc4080e7          	jalr	-1084(ra) # 80003fc4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005408:	fb040593          	addi	a1,s0,-80
    8000540c:	f3040513          	addi	a0,s0,-208
    80005410:	fffff097          	auipc	ra,0xfffff
    80005414:	9c6080e7          	jalr	-1594(ra) # 80003dd6 <nameiparent>
    80005418:	84aa                	mv	s1,a0
    8000541a:	c979                	beqz	a0,800054f0 <sys_unlink+0x114>
  ilock(dp);
    8000541c:	ffffe097          	auipc	ra,0xffffe
    80005420:	1ec080e7          	jalr	492(ra) # 80003608 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005424:	00003597          	auipc	a1,0x3
    80005428:	2c458593          	addi	a1,a1,708 # 800086e8 <syscalls+0x2c0>
    8000542c:	fb040513          	addi	a0,s0,-80
    80005430:	ffffe097          	auipc	ra,0xffffe
    80005434:	69c080e7          	jalr	1692(ra) # 80003acc <namecmp>
    80005438:	14050a63          	beqz	a0,8000558c <sys_unlink+0x1b0>
    8000543c:	00003597          	auipc	a1,0x3
    80005440:	2b458593          	addi	a1,a1,692 # 800086f0 <syscalls+0x2c8>
    80005444:	fb040513          	addi	a0,s0,-80
    80005448:	ffffe097          	auipc	ra,0xffffe
    8000544c:	684080e7          	jalr	1668(ra) # 80003acc <namecmp>
    80005450:	12050e63          	beqz	a0,8000558c <sys_unlink+0x1b0>
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005454:	f2c40613          	addi	a2,s0,-212
    80005458:	fb040593          	addi	a1,s0,-80
    8000545c:	8526                	mv	a0,s1
    8000545e:	ffffe097          	auipc	ra,0xffffe
    80005462:	688080e7          	jalr	1672(ra) # 80003ae6 <dirlookup>
    80005466:	892a                	mv	s2,a0
    80005468:	12050263          	beqz	a0,8000558c <sys_unlink+0x1b0>
  ilock(ip);
    8000546c:	ffffe097          	auipc	ra,0xffffe
    80005470:	19c080e7          	jalr	412(ra) # 80003608 <ilock>
  if(ip->nlink < 1)
    80005474:	04a91783          	lh	a5,74(s2)
    80005478:	08f05263          	blez	a5,800054fc <sys_unlink+0x120>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000547c:	04491703          	lh	a4,68(s2)
    80005480:	4785                	li	a5,1
    80005482:	08f70563          	beq	a4,a5,8000550c <sys_unlink+0x130>
  memset(&de, 0, sizeof(de));
    80005486:	4641                	li	a2,16
    80005488:	4581                	li	a1,0
    8000548a:	fc040513          	addi	a0,s0,-64
    8000548e:	ffffc097          	auipc	ra,0xffffc
    80005492:	87e080e7          	jalr	-1922(ra) # 80000d0c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005496:	4741                	li	a4,16
    80005498:	f2c42683          	lw	a3,-212(s0)
    8000549c:	fc040613          	addi	a2,s0,-64
    800054a0:	4581                	li	a1,0
    800054a2:	8526                	mv	a0,s1
    800054a4:	ffffe097          	auipc	ra,0xffffe
    800054a8:	50e080e7          	jalr	1294(ra) # 800039b2 <writei>
    800054ac:	47c1                	li	a5,16
    800054ae:	0af51563          	bne	a0,a5,80005558 <sys_unlink+0x17c>
  if(ip->type == T_DIR){
    800054b2:	04491703          	lh	a4,68(s2)
    800054b6:	4785                	li	a5,1
    800054b8:	0af70863          	beq	a4,a5,80005568 <sys_unlink+0x18c>
  iunlockput(dp);
    800054bc:	8526                	mv	a0,s1
    800054be:	ffffe097          	auipc	ra,0xffffe
    800054c2:	3ac080e7          	jalr	940(ra) # 8000386a <iunlockput>
  ip->nlink--;
    800054c6:	04a95783          	lhu	a5,74(s2)
    800054ca:	37fd                	addiw	a5,a5,-1
    800054cc:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800054d0:	854a                	mv	a0,s2
    800054d2:	ffffe097          	auipc	ra,0xffffe
    800054d6:	06c080e7          	jalr	108(ra) # 8000353e <iupdate>
  iunlockput(ip);
    800054da:	854a                	mv	a0,s2
    800054dc:	ffffe097          	auipc	ra,0xffffe
    800054e0:	38e080e7          	jalr	910(ra) # 8000386a <iunlockput>
  end_op();
    800054e4:	fffff097          	auipc	ra,0xfffff
    800054e8:	b60080e7          	jalr	-1184(ra) # 80004044 <end_op>
  return 0;
    800054ec:	4501                	li	a0,0
    800054ee:	a84d                	j	800055a0 <sys_unlink+0x1c4>
    end_op();
    800054f0:	fffff097          	auipc	ra,0xfffff
    800054f4:	b54080e7          	jalr	-1196(ra) # 80004044 <end_op>
    return -1;
    800054f8:	557d                	li	a0,-1
    800054fa:	a05d                	j	800055a0 <sys_unlink+0x1c4>
    panic("unlink: nlink < 1");
    800054fc:	00003517          	auipc	a0,0x3
    80005500:	21c50513          	addi	a0,a0,540 # 80008718 <syscalls+0x2f0>
    80005504:	ffffb097          	auipc	ra,0xffffb
    80005508:	044080e7          	jalr	68(ra) # 80000548 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000550c:	04c92703          	lw	a4,76(s2)
    80005510:	02000793          	li	a5,32
    80005514:	f6e7f9e3          	bgeu	a5,a4,80005486 <sys_unlink+0xaa>
    80005518:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000551c:	4741                	li	a4,16
    8000551e:	86ce                	mv	a3,s3
    80005520:	f1840613          	addi	a2,s0,-232
    80005524:	4581                	li	a1,0
    80005526:	854a                	mv	a0,s2
    80005528:	ffffe097          	auipc	ra,0xffffe
    8000552c:	394080e7          	jalr	916(ra) # 800038bc <readi>
    80005530:	47c1                	li	a5,16
    80005532:	00f51b63          	bne	a0,a5,80005548 <sys_unlink+0x16c>
    if(de.inum != 0)
    80005536:	f1845783          	lhu	a5,-232(s0)
    8000553a:	e7a1                	bnez	a5,80005582 <sys_unlink+0x1a6>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000553c:	29c1                	addiw	s3,s3,16
    8000553e:	04c92783          	lw	a5,76(s2)
    80005542:	fcf9ede3          	bltu	s3,a5,8000551c <sys_unlink+0x140>
    80005546:	b781                	j	80005486 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005548:	00003517          	auipc	a0,0x3
    8000554c:	1e850513          	addi	a0,a0,488 # 80008730 <syscalls+0x308>
    80005550:	ffffb097          	auipc	ra,0xffffb
    80005554:	ff8080e7          	jalr	-8(ra) # 80000548 <panic>
    panic("unlink: writei");
    80005558:	00003517          	auipc	a0,0x3
    8000555c:	1f050513          	addi	a0,a0,496 # 80008748 <syscalls+0x320>
    80005560:	ffffb097          	auipc	ra,0xffffb
    80005564:	fe8080e7          	jalr	-24(ra) # 80000548 <panic>
    dp->nlink--;
    80005568:	04a4d783          	lhu	a5,74(s1)
    8000556c:	37fd                	addiw	a5,a5,-1
    8000556e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005572:	8526                	mv	a0,s1
    80005574:	ffffe097          	auipc	ra,0xffffe
    80005578:	fca080e7          	jalr	-54(ra) # 8000353e <iupdate>
    8000557c:	b781                	j	800054bc <sys_unlink+0xe0>
    return -1;
    8000557e:	557d                	li	a0,-1
    80005580:	a005                	j	800055a0 <sys_unlink+0x1c4>
    iunlockput(ip);
    80005582:	854a                	mv	a0,s2
    80005584:	ffffe097          	auipc	ra,0xffffe
    80005588:	2e6080e7          	jalr	742(ra) # 8000386a <iunlockput>
  iunlockput(dp);
    8000558c:	8526                	mv	a0,s1
    8000558e:	ffffe097          	auipc	ra,0xffffe
    80005592:	2dc080e7          	jalr	732(ra) # 8000386a <iunlockput>
  end_op();
    80005596:	fffff097          	auipc	ra,0xfffff
    8000559a:	aae080e7          	jalr	-1362(ra) # 80004044 <end_op>
  return -1;
    8000559e:	557d                	li	a0,-1
}
    800055a0:	70ae                	ld	ra,232(sp)
    800055a2:	740e                	ld	s0,224(sp)
    800055a4:	64ee                	ld	s1,216(sp)
    800055a6:	694e                	ld	s2,208(sp)
    800055a8:	69ae                	ld	s3,200(sp)
    800055aa:	616d                	addi	sp,sp,240
    800055ac:	8082                	ret

00000000800055ae <sys_open>:

uint64
sys_open(void)
{
    800055ae:	7131                	addi	sp,sp,-192
    800055b0:	fd06                	sd	ra,184(sp)
    800055b2:	f922                	sd	s0,176(sp)
    800055b4:	f526                	sd	s1,168(sp)
    800055b6:	f14a                	sd	s2,160(sp)
    800055b8:	ed4e                	sd	s3,152(sp)
    800055ba:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800055bc:	08000613          	li	a2,128
    800055c0:	f5040593          	addi	a1,s0,-176
    800055c4:	4501                	li	a0,0
    800055c6:	ffffd097          	auipc	ra,0xffffd
    800055ca:	514080e7          	jalr	1300(ra) # 80002ada <argstr>
    return -1;
    800055ce:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    800055d0:	0c054163          	bltz	a0,80005692 <sys_open+0xe4>
    800055d4:	f4c40593          	addi	a1,s0,-180
    800055d8:	4505                	li	a0,1
    800055da:	ffffd097          	auipc	ra,0xffffd
    800055de:	4bc080e7          	jalr	1212(ra) # 80002a96 <argint>
    800055e2:	0a054863          	bltz	a0,80005692 <sys_open+0xe4>

  begin_op();
    800055e6:	fffff097          	auipc	ra,0xfffff
    800055ea:	9de080e7          	jalr	-1570(ra) # 80003fc4 <begin_op>

  if(omode & O_CREATE){
    800055ee:	f4c42783          	lw	a5,-180(s0)
    800055f2:	2007f793          	andi	a5,a5,512
    800055f6:	cbdd                	beqz	a5,800056ac <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    800055f8:	4681                	li	a3,0
    800055fa:	4601                	li	a2,0
    800055fc:	4589                	li	a1,2
    800055fe:	f5040513          	addi	a0,s0,-176
    80005602:	00000097          	auipc	ra,0x0
    80005606:	974080e7          	jalr	-1676(ra) # 80004f76 <create>
    8000560a:	892a                	mv	s2,a0
    if(ip == 0){
    8000560c:	c959                	beqz	a0,800056a2 <sys_open+0xf4>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000560e:	04491703          	lh	a4,68(s2)
    80005612:	478d                	li	a5,3
    80005614:	00f71763          	bne	a4,a5,80005622 <sys_open+0x74>
    80005618:	04695703          	lhu	a4,70(s2)
    8000561c:	47a5                	li	a5,9
    8000561e:	0ce7ec63          	bltu	a5,a4,800056f6 <sys_open+0x148>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005622:	fffff097          	auipc	ra,0xfffff
    80005626:	db8080e7          	jalr	-584(ra) # 800043da <filealloc>
    8000562a:	89aa                	mv	s3,a0
    8000562c:	10050263          	beqz	a0,80005730 <sys_open+0x182>
    80005630:	00000097          	auipc	ra,0x0
    80005634:	904080e7          	jalr	-1788(ra) # 80004f34 <fdalloc>
    80005638:	84aa                	mv	s1,a0
    8000563a:	0e054663          	bltz	a0,80005726 <sys_open+0x178>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000563e:	04491703          	lh	a4,68(s2)
    80005642:	478d                	li	a5,3
    80005644:	0cf70463          	beq	a4,a5,8000570c <sys_open+0x15e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005648:	4789                	li	a5,2
    8000564a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000564e:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80005652:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005656:	f4c42783          	lw	a5,-180(s0)
    8000565a:	0017c713          	xori	a4,a5,1
    8000565e:	8b05                	andi	a4,a4,1
    80005660:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005664:	0037f713          	andi	a4,a5,3
    80005668:	00e03733          	snez	a4,a4
    8000566c:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005670:	4007f793          	andi	a5,a5,1024
    80005674:	c791                	beqz	a5,80005680 <sys_open+0xd2>
    80005676:	04491703          	lh	a4,68(s2)
    8000567a:	4789                	li	a5,2
    8000567c:	08f70f63          	beq	a4,a5,8000571a <sys_open+0x16c>
    itrunc(ip);
  }

  iunlock(ip);
    80005680:	854a                	mv	a0,s2
    80005682:	ffffe097          	auipc	ra,0xffffe
    80005686:	048080e7          	jalr	72(ra) # 800036ca <iunlock>
  end_op();
    8000568a:	fffff097          	auipc	ra,0xfffff
    8000568e:	9ba080e7          	jalr	-1606(ra) # 80004044 <end_op>

  return fd;
}
    80005692:	8526                	mv	a0,s1
    80005694:	70ea                	ld	ra,184(sp)
    80005696:	744a                	ld	s0,176(sp)
    80005698:	74aa                	ld	s1,168(sp)
    8000569a:	790a                	ld	s2,160(sp)
    8000569c:	69ea                	ld	s3,152(sp)
    8000569e:	6129                	addi	sp,sp,192
    800056a0:	8082                	ret
      end_op();
    800056a2:	fffff097          	auipc	ra,0xfffff
    800056a6:	9a2080e7          	jalr	-1630(ra) # 80004044 <end_op>
      return -1;
    800056aa:	b7e5                	j	80005692 <sys_open+0xe4>
    if((ip = namei(path)) == 0){
    800056ac:	f5040513          	addi	a0,s0,-176
    800056b0:	ffffe097          	auipc	ra,0xffffe
    800056b4:	708080e7          	jalr	1800(ra) # 80003db8 <namei>
    800056b8:	892a                	mv	s2,a0
    800056ba:	c905                	beqz	a0,800056ea <sys_open+0x13c>
    ilock(ip);
    800056bc:	ffffe097          	auipc	ra,0xffffe
    800056c0:	f4c080e7          	jalr	-180(ra) # 80003608 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800056c4:	04491703          	lh	a4,68(s2)
    800056c8:	4785                	li	a5,1
    800056ca:	f4f712e3          	bne	a4,a5,8000560e <sys_open+0x60>
    800056ce:	f4c42783          	lw	a5,-180(s0)
    800056d2:	dba1                	beqz	a5,80005622 <sys_open+0x74>
      iunlockput(ip);
    800056d4:	854a                	mv	a0,s2
    800056d6:	ffffe097          	auipc	ra,0xffffe
    800056da:	194080e7          	jalr	404(ra) # 8000386a <iunlockput>
      end_op();
    800056de:	fffff097          	auipc	ra,0xfffff
    800056e2:	966080e7          	jalr	-1690(ra) # 80004044 <end_op>
      return -1;
    800056e6:	54fd                	li	s1,-1
    800056e8:	b76d                	j	80005692 <sys_open+0xe4>
      end_op();
    800056ea:	fffff097          	auipc	ra,0xfffff
    800056ee:	95a080e7          	jalr	-1702(ra) # 80004044 <end_op>
      return -1;
    800056f2:	54fd                	li	s1,-1
    800056f4:	bf79                	j	80005692 <sys_open+0xe4>
    iunlockput(ip);
    800056f6:	854a                	mv	a0,s2
    800056f8:	ffffe097          	auipc	ra,0xffffe
    800056fc:	172080e7          	jalr	370(ra) # 8000386a <iunlockput>
    end_op();
    80005700:	fffff097          	auipc	ra,0xfffff
    80005704:	944080e7          	jalr	-1724(ra) # 80004044 <end_op>
    return -1;
    80005708:	54fd                	li	s1,-1
    8000570a:	b761                	j	80005692 <sys_open+0xe4>
    f->type = FD_DEVICE;
    8000570c:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005710:	04691783          	lh	a5,70(s2)
    80005714:	02f99223          	sh	a5,36(s3)
    80005718:	bf2d                	j	80005652 <sys_open+0xa4>
    itrunc(ip);
    8000571a:	854a                	mv	a0,s2
    8000571c:	ffffe097          	auipc	ra,0xffffe
    80005720:	ffa080e7          	jalr	-6(ra) # 80003716 <itrunc>
    80005724:	bfb1                	j	80005680 <sys_open+0xd2>
      fileclose(f);
    80005726:	854e                	mv	a0,s3
    80005728:	fffff097          	auipc	ra,0xfffff
    8000572c:	d6e080e7          	jalr	-658(ra) # 80004496 <fileclose>
    iunlockput(ip);
    80005730:	854a                	mv	a0,s2
    80005732:	ffffe097          	auipc	ra,0xffffe
    80005736:	138080e7          	jalr	312(ra) # 8000386a <iunlockput>
    end_op();
    8000573a:	fffff097          	auipc	ra,0xfffff
    8000573e:	90a080e7          	jalr	-1782(ra) # 80004044 <end_op>
    return -1;
    80005742:	54fd                	li	s1,-1
    80005744:	b7b9                	j	80005692 <sys_open+0xe4>

0000000080005746 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005746:	7175                	addi	sp,sp,-144
    80005748:	e506                	sd	ra,136(sp)
    8000574a:	e122                	sd	s0,128(sp)
    8000574c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000574e:	fffff097          	auipc	ra,0xfffff
    80005752:	876080e7          	jalr	-1930(ra) # 80003fc4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005756:	08000613          	li	a2,128
    8000575a:	f7040593          	addi	a1,s0,-144
    8000575e:	4501                	li	a0,0
    80005760:	ffffd097          	auipc	ra,0xffffd
    80005764:	37a080e7          	jalr	890(ra) # 80002ada <argstr>
    80005768:	02054963          	bltz	a0,8000579a <sys_mkdir+0x54>
    8000576c:	4681                	li	a3,0
    8000576e:	4601                	li	a2,0
    80005770:	4585                	li	a1,1
    80005772:	f7040513          	addi	a0,s0,-144
    80005776:	00000097          	auipc	ra,0x0
    8000577a:	800080e7          	jalr	-2048(ra) # 80004f76 <create>
    8000577e:	cd11                	beqz	a0,8000579a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005780:	ffffe097          	auipc	ra,0xffffe
    80005784:	0ea080e7          	jalr	234(ra) # 8000386a <iunlockput>
  end_op();
    80005788:	fffff097          	auipc	ra,0xfffff
    8000578c:	8bc080e7          	jalr	-1860(ra) # 80004044 <end_op>
  return 0;
    80005790:	4501                	li	a0,0
}
    80005792:	60aa                	ld	ra,136(sp)
    80005794:	640a                	ld	s0,128(sp)
    80005796:	6149                	addi	sp,sp,144
    80005798:	8082                	ret
    end_op();
    8000579a:	fffff097          	auipc	ra,0xfffff
    8000579e:	8aa080e7          	jalr	-1878(ra) # 80004044 <end_op>
    return -1;
    800057a2:	557d                	li	a0,-1
    800057a4:	b7fd                	j	80005792 <sys_mkdir+0x4c>

00000000800057a6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800057a6:	7135                	addi	sp,sp,-160
    800057a8:	ed06                	sd	ra,152(sp)
    800057aa:	e922                	sd	s0,144(sp)
    800057ac:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800057ae:	fffff097          	auipc	ra,0xfffff
    800057b2:	816080e7          	jalr	-2026(ra) # 80003fc4 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057b6:	08000613          	li	a2,128
    800057ba:	f7040593          	addi	a1,s0,-144
    800057be:	4501                	li	a0,0
    800057c0:	ffffd097          	auipc	ra,0xffffd
    800057c4:	31a080e7          	jalr	794(ra) # 80002ada <argstr>
    800057c8:	04054a63          	bltz	a0,8000581c <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    800057cc:	f6c40593          	addi	a1,s0,-148
    800057d0:	4505                	li	a0,1
    800057d2:	ffffd097          	auipc	ra,0xffffd
    800057d6:	2c4080e7          	jalr	708(ra) # 80002a96 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800057da:	04054163          	bltz	a0,8000581c <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    800057de:	f6840593          	addi	a1,s0,-152
    800057e2:	4509                	li	a0,2
    800057e4:	ffffd097          	auipc	ra,0xffffd
    800057e8:	2b2080e7          	jalr	690(ra) # 80002a96 <argint>
     argint(1, &major) < 0 ||
    800057ec:	02054863          	bltz	a0,8000581c <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800057f0:	f6841683          	lh	a3,-152(s0)
    800057f4:	f6c41603          	lh	a2,-148(s0)
    800057f8:	458d                	li	a1,3
    800057fa:	f7040513          	addi	a0,s0,-144
    800057fe:	fffff097          	auipc	ra,0xfffff
    80005802:	778080e7          	jalr	1912(ra) # 80004f76 <create>
     argint(2, &minor) < 0 ||
    80005806:	c919                	beqz	a0,8000581c <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005808:	ffffe097          	auipc	ra,0xffffe
    8000580c:	062080e7          	jalr	98(ra) # 8000386a <iunlockput>
  end_op();
    80005810:	fffff097          	auipc	ra,0xfffff
    80005814:	834080e7          	jalr	-1996(ra) # 80004044 <end_op>
  return 0;
    80005818:	4501                	li	a0,0
    8000581a:	a031                	j	80005826 <sys_mknod+0x80>
    end_op();
    8000581c:	fffff097          	auipc	ra,0xfffff
    80005820:	828080e7          	jalr	-2008(ra) # 80004044 <end_op>
    return -1;
    80005824:	557d                	li	a0,-1
}
    80005826:	60ea                	ld	ra,152(sp)
    80005828:	644a                	ld	s0,144(sp)
    8000582a:	610d                	addi	sp,sp,160
    8000582c:	8082                	ret

000000008000582e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000582e:	7135                	addi	sp,sp,-160
    80005830:	ed06                	sd	ra,152(sp)
    80005832:	e922                	sd	s0,144(sp)
    80005834:	e526                	sd	s1,136(sp)
    80005836:	e14a                	sd	s2,128(sp)
    80005838:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000583a:	ffffc097          	auipc	ra,0xffffc
    8000583e:	1a4080e7          	jalr	420(ra) # 800019de <myproc>
    80005842:	892a                	mv	s2,a0
  
  begin_op();
    80005844:	ffffe097          	auipc	ra,0xffffe
    80005848:	780080e7          	jalr	1920(ra) # 80003fc4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000584c:	08000613          	li	a2,128
    80005850:	f6040593          	addi	a1,s0,-160
    80005854:	4501                	li	a0,0
    80005856:	ffffd097          	auipc	ra,0xffffd
    8000585a:	284080e7          	jalr	644(ra) # 80002ada <argstr>
    8000585e:	04054b63          	bltz	a0,800058b4 <sys_chdir+0x86>
    80005862:	f6040513          	addi	a0,s0,-160
    80005866:	ffffe097          	auipc	ra,0xffffe
    8000586a:	552080e7          	jalr	1362(ra) # 80003db8 <namei>
    8000586e:	84aa                	mv	s1,a0
    80005870:	c131                	beqz	a0,800058b4 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80005872:	ffffe097          	auipc	ra,0xffffe
    80005876:	d96080e7          	jalr	-618(ra) # 80003608 <ilock>
  if(ip->type != T_DIR){
    8000587a:	04449703          	lh	a4,68(s1)
    8000587e:	4785                	li	a5,1
    80005880:	04f71063          	bne	a4,a5,800058c0 <sys_chdir+0x92>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005884:	8526                	mv	a0,s1
    80005886:	ffffe097          	auipc	ra,0xffffe
    8000588a:	e44080e7          	jalr	-444(ra) # 800036ca <iunlock>
  iput(p->cwd);
    8000588e:	15093503          	ld	a0,336(s2)
    80005892:	ffffe097          	auipc	ra,0xffffe
    80005896:	f30080e7          	jalr	-208(ra) # 800037c2 <iput>
  end_op();
    8000589a:	ffffe097          	auipc	ra,0xffffe
    8000589e:	7aa080e7          	jalr	1962(ra) # 80004044 <end_op>
  p->cwd = ip;
    800058a2:	14993823          	sd	s1,336(s2)
  return 0;
    800058a6:	4501                	li	a0,0
}
    800058a8:	60ea                	ld	ra,152(sp)
    800058aa:	644a                	ld	s0,144(sp)
    800058ac:	64aa                	ld	s1,136(sp)
    800058ae:	690a                	ld	s2,128(sp)
    800058b0:	610d                	addi	sp,sp,160
    800058b2:	8082                	ret
    end_op();
    800058b4:	ffffe097          	auipc	ra,0xffffe
    800058b8:	790080e7          	jalr	1936(ra) # 80004044 <end_op>
    return -1;
    800058bc:	557d                	li	a0,-1
    800058be:	b7ed                	j	800058a8 <sys_chdir+0x7a>
    iunlockput(ip);
    800058c0:	8526                	mv	a0,s1
    800058c2:	ffffe097          	auipc	ra,0xffffe
    800058c6:	fa8080e7          	jalr	-88(ra) # 8000386a <iunlockput>
    end_op();
    800058ca:	ffffe097          	auipc	ra,0xffffe
    800058ce:	77a080e7          	jalr	1914(ra) # 80004044 <end_op>
    return -1;
    800058d2:	557d                	li	a0,-1
    800058d4:	bfd1                	j	800058a8 <sys_chdir+0x7a>

00000000800058d6 <sys_exec>:

uint64
sys_exec(void)
{
    800058d6:	7145                	addi	sp,sp,-464
    800058d8:	e786                	sd	ra,456(sp)
    800058da:	e3a2                	sd	s0,448(sp)
    800058dc:	ff26                	sd	s1,440(sp)
    800058de:	fb4a                	sd	s2,432(sp)
    800058e0:	f74e                	sd	s3,424(sp)
    800058e2:	f352                	sd	s4,416(sp)
    800058e4:	ef56                	sd	s5,408(sp)
    800058e6:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058e8:	08000613          	li	a2,128
    800058ec:	f4040593          	addi	a1,s0,-192
    800058f0:	4501                	li	a0,0
    800058f2:	ffffd097          	auipc	ra,0xffffd
    800058f6:	1e8080e7          	jalr	488(ra) # 80002ada <argstr>
    return -1;
    800058fa:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800058fc:	0c054a63          	bltz	a0,800059d0 <sys_exec+0xfa>
    80005900:	e3840593          	addi	a1,s0,-456
    80005904:	4505                	li	a0,1
    80005906:	ffffd097          	auipc	ra,0xffffd
    8000590a:	1b2080e7          	jalr	434(ra) # 80002ab8 <argaddr>
    8000590e:	0c054163          	bltz	a0,800059d0 <sys_exec+0xfa>
  }
  memset(argv, 0, sizeof(argv));
    80005912:	10000613          	li	a2,256
    80005916:	4581                	li	a1,0
    80005918:	e4040513          	addi	a0,s0,-448
    8000591c:	ffffb097          	auipc	ra,0xffffb
    80005920:	3f0080e7          	jalr	1008(ra) # 80000d0c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005924:	e4040493          	addi	s1,s0,-448
  memset(argv, 0, sizeof(argv));
    80005928:	89a6                	mv	s3,s1
    8000592a:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000592c:	02000a13          	li	s4,32
    80005930:	00090a9b          	sext.w	s5,s2
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005934:	00391513          	slli	a0,s2,0x3
    80005938:	e3040593          	addi	a1,s0,-464
    8000593c:	e3843783          	ld	a5,-456(s0)
    80005940:	953e                	add	a0,a0,a5
    80005942:	ffffd097          	auipc	ra,0xffffd
    80005946:	0ba080e7          	jalr	186(ra) # 800029fc <fetchaddr>
    8000594a:	02054a63          	bltz	a0,8000597e <sys_exec+0xa8>
      goto bad;
    }
    if(uarg == 0){
    8000594e:	e3043783          	ld	a5,-464(s0)
    80005952:	c3b9                	beqz	a5,80005998 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005954:	ffffb097          	auipc	ra,0xffffb
    80005958:	1cc080e7          	jalr	460(ra) # 80000b20 <kalloc>
    8000595c:	85aa                	mv	a1,a0
    8000595e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005962:	cd11                	beqz	a0,8000597e <sys_exec+0xa8>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005964:	6605                	lui	a2,0x1
    80005966:	e3043503          	ld	a0,-464(s0)
    8000596a:	ffffd097          	auipc	ra,0xffffd
    8000596e:	0e4080e7          	jalr	228(ra) # 80002a4e <fetchstr>
    80005972:	00054663          	bltz	a0,8000597e <sys_exec+0xa8>
    if(i >= NELEM(argv)){
    80005976:	0905                	addi	s2,s2,1
    80005978:	09a1                	addi	s3,s3,8
    8000597a:	fb491be3          	bne	s2,s4,80005930 <sys_exec+0x5a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000597e:	10048913          	addi	s2,s1,256
    80005982:	6088                	ld	a0,0(s1)
    80005984:	c529                	beqz	a0,800059ce <sys_exec+0xf8>
    kfree(argv[i]);
    80005986:	ffffb097          	auipc	ra,0xffffb
    8000598a:	09e080e7          	jalr	158(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000598e:	04a1                	addi	s1,s1,8
    80005990:	ff2499e3          	bne	s1,s2,80005982 <sys_exec+0xac>
  return -1;
    80005994:	597d                	li	s2,-1
    80005996:	a82d                	j	800059d0 <sys_exec+0xfa>
      argv[i] = 0;
    80005998:	0a8e                	slli	s5,s5,0x3
    8000599a:	fc040793          	addi	a5,s0,-64
    8000599e:	9abe                	add	s5,s5,a5
    800059a0:	e80ab023          	sd	zero,-384(s5)
  int ret = exec(path, argv);
    800059a4:	e4040593          	addi	a1,s0,-448
    800059a8:	f4040513          	addi	a0,s0,-192
    800059ac:	fffff097          	auipc	ra,0xfffff
    800059b0:	196080e7          	jalr	406(ra) # 80004b42 <exec>
    800059b4:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059b6:	10048993          	addi	s3,s1,256
    800059ba:	6088                	ld	a0,0(s1)
    800059bc:	c911                	beqz	a0,800059d0 <sys_exec+0xfa>
    kfree(argv[i]);
    800059be:	ffffb097          	auipc	ra,0xffffb
    800059c2:	066080e7          	jalr	102(ra) # 80000a24 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800059c6:	04a1                	addi	s1,s1,8
    800059c8:	ff3499e3          	bne	s1,s3,800059ba <sys_exec+0xe4>
    800059cc:	a011                	j	800059d0 <sys_exec+0xfa>
  return -1;
    800059ce:	597d                	li	s2,-1
}
    800059d0:	854a                	mv	a0,s2
    800059d2:	60be                	ld	ra,456(sp)
    800059d4:	641e                	ld	s0,448(sp)
    800059d6:	74fa                	ld	s1,440(sp)
    800059d8:	795a                	ld	s2,432(sp)
    800059da:	79ba                	ld	s3,424(sp)
    800059dc:	7a1a                	ld	s4,416(sp)
    800059de:	6afa                	ld	s5,408(sp)
    800059e0:	6179                	addi	sp,sp,464
    800059e2:	8082                	ret

00000000800059e4 <sys_pipe>:

uint64
sys_pipe(void)
{
    800059e4:	7139                	addi	sp,sp,-64
    800059e6:	fc06                	sd	ra,56(sp)
    800059e8:	f822                	sd	s0,48(sp)
    800059ea:	f426                	sd	s1,40(sp)
    800059ec:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800059ee:	ffffc097          	auipc	ra,0xffffc
    800059f2:	ff0080e7          	jalr	-16(ra) # 800019de <myproc>
    800059f6:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800059f8:	fd840593          	addi	a1,s0,-40
    800059fc:	4501                	li	a0,0
    800059fe:	ffffd097          	auipc	ra,0xffffd
    80005a02:	0ba080e7          	jalr	186(ra) # 80002ab8 <argaddr>
    return -1;
    80005a06:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005a08:	0e054063          	bltz	a0,80005ae8 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005a0c:	fc840593          	addi	a1,s0,-56
    80005a10:	fd040513          	addi	a0,s0,-48
    80005a14:	fffff097          	auipc	ra,0xfffff
    80005a18:	dd8080e7          	jalr	-552(ra) # 800047ec <pipealloc>
    return -1;
    80005a1c:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005a1e:	0c054563          	bltz	a0,80005ae8 <sys_pipe+0x104>
  fd0 = -1;
    80005a22:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005a26:	fd043503          	ld	a0,-48(s0)
    80005a2a:	fffff097          	auipc	ra,0xfffff
    80005a2e:	50a080e7          	jalr	1290(ra) # 80004f34 <fdalloc>
    80005a32:	fca42223          	sw	a0,-60(s0)
    80005a36:	08054c63          	bltz	a0,80005ace <sys_pipe+0xea>
    80005a3a:	fc843503          	ld	a0,-56(s0)
    80005a3e:	fffff097          	auipc	ra,0xfffff
    80005a42:	4f6080e7          	jalr	1270(ra) # 80004f34 <fdalloc>
    80005a46:	fca42023          	sw	a0,-64(s0)
    80005a4a:	06054863          	bltz	a0,80005aba <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a4e:	4691                	li	a3,4
    80005a50:	fc440613          	addi	a2,s0,-60
    80005a54:	fd843583          	ld	a1,-40(s0)
    80005a58:	68a8                	ld	a0,80(s1)
    80005a5a:	ffffc097          	auipc	ra,0xffffc
    80005a5e:	c78080e7          	jalr	-904(ra) # 800016d2 <copyout>
    80005a62:	02054063          	bltz	a0,80005a82 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005a66:	4691                	li	a3,4
    80005a68:	fc040613          	addi	a2,s0,-64
    80005a6c:	fd843583          	ld	a1,-40(s0)
    80005a70:	0591                	addi	a1,a1,4
    80005a72:	68a8                	ld	a0,80(s1)
    80005a74:	ffffc097          	auipc	ra,0xffffc
    80005a78:	c5e080e7          	jalr	-930(ra) # 800016d2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005a7c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005a7e:	06055563          	bgez	a0,80005ae8 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005a82:	fc442783          	lw	a5,-60(s0)
    80005a86:	07e9                	addi	a5,a5,26
    80005a88:	078e                	slli	a5,a5,0x3
    80005a8a:	97a6                	add	a5,a5,s1
    80005a8c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005a90:	fc042503          	lw	a0,-64(s0)
    80005a94:	0569                	addi	a0,a0,26
    80005a96:	050e                	slli	a0,a0,0x3
    80005a98:	9526                	add	a0,a0,s1
    80005a9a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005a9e:	fd043503          	ld	a0,-48(s0)
    80005aa2:	fffff097          	auipc	ra,0xfffff
    80005aa6:	9f4080e7          	jalr	-1548(ra) # 80004496 <fileclose>
    fileclose(wf);
    80005aaa:	fc843503          	ld	a0,-56(s0)
    80005aae:	fffff097          	auipc	ra,0xfffff
    80005ab2:	9e8080e7          	jalr	-1560(ra) # 80004496 <fileclose>
    return -1;
    80005ab6:	57fd                	li	a5,-1
    80005ab8:	a805                	j	80005ae8 <sys_pipe+0x104>
    if(fd0 >= 0)
    80005aba:	fc442783          	lw	a5,-60(s0)
    80005abe:	0007c863          	bltz	a5,80005ace <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005ac2:	01a78513          	addi	a0,a5,26
    80005ac6:	050e                	slli	a0,a0,0x3
    80005ac8:	9526                	add	a0,a0,s1
    80005aca:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    80005ace:	fd043503          	ld	a0,-48(s0)
    80005ad2:	fffff097          	auipc	ra,0xfffff
    80005ad6:	9c4080e7          	jalr	-1596(ra) # 80004496 <fileclose>
    fileclose(wf);
    80005ada:	fc843503          	ld	a0,-56(s0)
    80005ade:	fffff097          	auipc	ra,0xfffff
    80005ae2:	9b8080e7          	jalr	-1608(ra) # 80004496 <fileclose>
    return -1;
    80005ae6:	57fd                	li	a5,-1
}
    80005ae8:	853e                	mv	a0,a5
    80005aea:	70e2                	ld	ra,56(sp)
    80005aec:	7442                	ld	s0,48(sp)
    80005aee:	74a2                	ld	s1,40(sp)
    80005af0:	6121                	addi	sp,sp,64
    80005af2:	8082                	ret
	...

0000000080005b00 <kernelvec>:
    80005b00:	7111                	addi	sp,sp,-256
    80005b02:	e006                	sd	ra,0(sp)
    80005b04:	e40a                	sd	sp,8(sp)
    80005b06:	e80e                	sd	gp,16(sp)
    80005b08:	ec12                	sd	tp,24(sp)
    80005b0a:	f016                	sd	t0,32(sp)
    80005b0c:	f41a                	sd	t1,40(sp)
    80005b0e:	f81e                	sd	t2,48(sp)
    80005b10:	fc22                	sd	s0,56(sp)
    80005b12:	e0a6                	sd	s1,64(sp)
    80005b14:	e4aa                	sd	a0,72(sp)
    80005b16:	e8ae                	sd	a1,80(sp)
    80005b18:	ecb2                	sd	a2,88(sp)
    80005b1a:	f0b6                	sd	a3,96(sp)
    80005b1c:	f4ba                	sd	a4,104(sp)
    80005b1e:	f8be                	sd	a5,112(sp)
    80005b20:	fcc2                	sd	a6,120(sp)
    80005b22:	e146                	sd	a7,128(sp)
    80005b24:	e54a                	sd	s2,136(sp)
    80005b26:	e94e                	sd	s3,144(sp)
    80005b28:	ed52                	sd	s4,152(sp)
    80005b2a:	f156                	sd	s5,160(sp)
    80005b2c:	f55a                	sd	s6,168(sp)
    80005b2e:	f95e                	sd	s7,176(sp)
    80005b30:	fd62                	sd	s8,184(sp)
    80005b32:	e1e6                	sd	s9,192(sp)
    80005b34:	e5ea                	sd	s10,200(sp)
    80005b36:	e9ee                	sd	s11,208(sp)
    80005b38:	edf2                	sd	t3,216(sp)
    80005b3a:	f1f6                	sd	t4,224(sp)
    80005b3c:	f5fa                	sd	t5,232(sp)
    80005b3e:	f9fe                	sd	t6,240(sp)
    80005b40:	d89fc0ef          	jal	ra,800028c8 <kerneltrap>
    80005b44:	6082                	ld	ra,0(sp)
    80005b46:	6122                	ld	sp,8(sp)
    80005b48:	61c2                	ld	gp,16(sp)
    80005b4a:	7282                	ld	t0,32(sp)
    80005b4c:	7322                	ld	t1,40(sp)
    80005b4e:	73c2                	ld	t2,48(sp)
    80005b50:	7462                	ld	s0,56(sp)
    80005b52:	6486                	ld	s1,64(sp)
    80005b54:	6526                	ld	a0,72(sp)
    80005b56:	65c6                	ld	a1,80(sp)
    80005b58:	6666                	ld	a2,88(sp)
    80005b5a:	7686                	ld	a3,96(sp)
    80005b5c:	7726                	ld	a4,104(sp)
    80005b5e:	77c6                	ld	a5,112(sp)
    80005b60:	7866                	ld	a6,120(sp)
    80005b62:	688a                	ld	a7,128(sp)
    80005b64:	692a                	ld	s2,136(sp)
    80005b66:	69ca                	ld	s3,144(sp)
    80005b68:	6a6a                	ld	s4,152(sp)
    80005b6a:	7a8a                	ld	s5,160(sp)
    80005b6c:	7b2a                	ld	s6,168(sp)
    80005b6e:	7bca                	ld	s7,176(sp)
    80005b70:	7c6a                	ld	s8,184(sp)
    80005b72:	6c8e                	ld	s9,192(sp)
    80005b74:	6d2e                	ld	s10,200(sp)
    80005b76:	6dce                	ld	s11,208(sp)
    80005b78:	6e6e                	ld	t3,216(sp)
    80005b7a:	7e8e                	ld	t4,224(sp)
    80005b7c:	7f2e                	ld	t5,232(sp)
    80005b7e:	7fce                	ld	t6,240(sp)
    80005b80:	6111                	addi	sp,sp,256
    80005b82:	10200073          	sret
    80005b86:	00000013          	nop
    80005b8a:	00000013          	nop
    80005b8e:	0001                	nop

0000000080005b90 <timervec>:
    80005b90:	34051573          	csrrw	a0,mscratch,a0
    80005b94:	e10c                	sd	a1,0(a0)
    80005b96:	e510                	sd	a2,8(a0)
    80005b98:	e914                	sd	a3,16(a0)
    80005b9a:	710c                	ld	a1,32(a0)
    80005b9c:	7510                	ld	a2,40(a0)
    80005b9e:	6194                	ld	a3,0(a1)
    80005ba0:	96b2                	add	a3,a3,a2
    80005ba2:	e194                	sd	a3,0(a1)
    80005ba4:	4589                	li	a1,2
    80005ba6:	14459073          	csrw	sip,a1
    80005baa:	6914                	ld	a3,16(a0)
    80005bac:	6510                	ld	a2,8(a0)
    80005bae:	610c                	ld	a1,0(a0)
    80005bb0:	34051573          	csrrw	a0,mscratch,a0
    80005bb4:	30200073          	mret
	...

0000000080005bba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005bba:	1141                	addi	sp,sp,-16
    80005bbc:	e422                	sd	s0,8(sp)
    80005bbe:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005bc0:	0c0007b7          	lui	a5,0xc000
    80005bc4:	4705                	li	a4,1
    80005bc6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005bc8:	c3d8                	sw	a4,4(a5)
}
    80005bca:	6422                	ld	s0,8(sp)
    80005bcc:	0141                	addi	sp,sp,16
    80005bce:	8082                	ret

0000000080005bd0 <plicinithart>:

void
plicinithart(void)
{
    80005bd0:	1141                	addi	sp,sp,-16
    80005bd2:	e406                	sd	ra,8(sp)
    80005bd4:	e022                	sd	s0,0(sp)
    80005bd6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005bd8:	ffffc097          	auipc	ra,0xffffc
    80005bdc:	dda080e7          	jalr	-550(ra) # 800019b2 <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005be0:	0085171b          	slliw	a4,a0,0x8
    80005be4:	0c0027b7          	lui	a5,0xc002
    80005be8:	97ba                	add	a5,a5,a4
    80005bea:	40200713          	li	a4,1026
    80005bee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005bf2:	00d5151b          	slliw	a0,a0,0xd
    80005bf6:	0c2017b7          	lui	a5,0xc201
    80005bfa:	953e                	add	a0,a0,a5
    80005bfc:	00052023          	sw	zero,0(a0)
}
    80005c00:	60a2                	ld	ra,8(sp)
    80005c02:	6402                	ld	s0,0(sp)
    80005c04:	0141                	addi	sp,sp,16
    80005c06:	8082                	ret

0000000080005c08 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005c08:	1141                	addi	sp,sp,-16
    80005c0a:	e406                	sd	ra,8(sp)
    80005c0c:	e022                	sd	s0,0(sp)
    80005c0e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005c10:	ffffc097          	auipc	ra,0xffffc
    80005c14:	da2080e7          	jalr	-606(ra) # 800019b2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005c18:	00d5179b          	slliw	a5,a0,0xd
    80005c1c:	0c201537          	lui	a0,0xc201
    80005c20:	953e                	add	a0,a0,a5
  return irq;
}
    80005c22:	4148                	lw	a0,4(a0)
    80005c24:	60a2                	ld	ra,8(sp)
    80005c26:	6402                	ld	s0,0(sp)
    80005c28:	0141                	addi	sp,sp,16
    80005c2a:	8082                	ret

0000000080005c2c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005c2c:	1101                	addi	sp,sp,-32
    80005c2e:	ec06                	sd	ra,24(sp)
    80005c30:	e822                	sd	s0,16(sp)
    80005c32:	e426                	sd	s1,8(sp)
    80005c34:	1000                	addi	s0,sp,32
    80005c36:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005c38:	ffffc097          	auipc	ra,0xffffc
    80005c3c:	d7a080e7          	jalr	-646(ra) # 800019b2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005c40:	00d5151b          	slliw	a0,a0,0xd
    80005c44:	0c2017b7          	lui	a5,0xc201
    80005c48:	97aa                	add	a5,a5,a0
    80005c4a:	c3c4                	sw	s1,4(a5)
}
    80005c4c:	60e2                	ld	ra,24(sp)
    80005c4e:	6442                	ld	s0,16(sp)
    80005c50:	64a2                	ld	s1,8(sp)
    80005c52:	6105                	addi	sp,sp,32
    80005c54:	8082                	ret

0000000080005c56 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005c56:	1141                	addi	sp,sp,-16
    80005c58:	e406                	sd	ra,8(sp)
    80005c5a:	e022                	sd	s0,0(sp)
    80005c5c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005c5e:	479d                	li	a5,7
    80005c60:	04a7cc63          	blt	a5,a0,80005cb8 <free_desc+0x62>
    panic("virtio_disk_intr 1");
  if(disk.free[i])
    80005c64:	0001d797          	auipc	a5,0x1d
    80005c68:	39c78793          	addi	a5,a5,924 # 80023000 <disk>
    80005c6c:	00a78733          	add	a4,a5,a0
    80005c70:	6789                	lui	a5,0x2
    80005c72:	97ba                	add	a5,a5,a4
    80005c74:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    80005c78:	eba1                	bnez	a5,80005cc8 <free_desc+0x72>
    panic("virtio_disk_intr 2");
  disk.desc[i].addr = 0;
    80005c7a:	00451713          	slli	a4,a0,0x4
    80005c7e:	0001f797          	auipc	a5,0x1f
    80005c82:	3827b783          	ld	a5,898(a5) # 80025000 <disk+0x2000>
    80005c86:	97ba                	add	a5,a5,a4
    80005c88:	0007b023          	sd	zero,0(a5)
  disk.free[i] = 1;
    80005c8c:	0001d797          	auipc	a5,0x1d
    80005c90:	37478793          	addi	a5,a5,884 # 80023000 <disk>
    80005c94:	97aa                	add	a5,a5,a0
    80005c96:	6509                	lui	a0,0x2
    80005c98:	953e                	add	a0,a0,a5
    80005c9a:	4785                	li	a5,1
    80005c9c:	00f50c23          	sb	a5,24(a0) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    80005ca0:	0001f517          	auipc	a0,0x1f
    80005ca4:	37850513          	addi	a0,a0,888 # 80025018 <disk+0x2018>
    80005ca8:	ffffc097          	auipc	ra,0xffffc
    80005cac:	6c8080e7          	jalr	1736(ra) # 80002370 <wakeup>
}
    80005cb0:	60a2                	ld	ra,8(sp)
    80005cb2:	6402                	ld	s0,0(sp)
    80005cb4:	0141                	addi	sp,sp,16
    80005cb6:	8082                	ret
    panic("virtio_disk_intr 1");
    80005cb8:	00003517          	auipc	a0,0x3
    80005cbc:	aa050513          	addi	a0,a0,-1376 # 80008758 <syscalls+0x330>
    80005cc0:	ffffb097          	auipc	ra,0xffffb
    80005cc4:	888080e7          	jalr	-1912(ra) # 80000548 <panic>
    panic("virtio_disk_intr 2");
    80005cc8:	00003517          	auipc	a0,0x3
    80005ccc:	aa850513          	addi	a0,a0,-1368 # 80008770 <syscalls+0x348>
    80005cd0:	ffffb097          	auipc	ra,0xffffb
    80005cd4:	878080e7          	jalr	-1928(ra) # 80000548 <panic>

0000000080005cd8 <virtio_disk_init>:
{
    80005cd8:	1101                	addi	sp,sp,-32
    80005cda:	ec06                	sd	ra,24(sp)
    80005cdc:	e822                	sd	s0,16(sp)
    80005cde:	e426                	sd	s1,8(sp)
    80005ce0:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005ce2:	00003597          	auipc	a1,0x3
    80005ce6:	aa658593          	addi	a1,a1,-1370 # 80008788 <syscalls+0x360>
    80005cea:	0001f517          	auipc	a0,0x1f
    80005cee:	3be50513          	addi	a0,a0,958 # 800250a8 <disk+0x20a8>
    80005cf2:	ffffb097          	auipc	ra,0xffffb
    80005cf6:	e8e080e7          	jalr	-370(ra) # 80000b80 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005cfa:	100017b7          	lui	a5,0x10001
    80005cfe:	4398                	lw	a4,0(a5)
    80005d00:	2701                	sext.w	a4,a4
    80005d02:	747277b7          	lui	a5,0x74727
    80005d06:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005d0a:	0ef71163          	bne	a4,a5,80005dec <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005d0e:	100017b7          	lui	a5,0x10001
    80005d12:	43dc                	lw	a5,4(a5)
    80005d14:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005d16:	4705                	li	a4,1
    80005d18:	0ce79a63          	bne	a5,a4,80005dec <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005d1c:	100017b7          	lui	a5,0x10001
    80005d20:	479c                	lw	a5,8(a5)
    80005d22:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005d24:	4709                	li	a4,2
    80005d26:	0ce79363          	bne	a5,a4,80005dec <virtio_disk_init+0x114>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005d2a:	100017b7          	lui	a5,0x10001
    80005d2e:	47d8                	lw	a4,12(a5)
    80005d30:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005d32:	554d47b7          	lui	a5,0x554d4
    80005d36:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005d3a:	0af71963          	bne	a4,a5,80005dec <virtio_disk_init+0x114>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d3e:	100017b7          	lui	a5,0x10001
    80005d42:	4705                	li	a4,1
    80005d44:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d46:	470d                	li	a4,3
    80005d48:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005d4a:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005d4c:	c7ffe737          	lui	a4,0xc7ffe
    80005d50:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd875f>
    80005d54:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005d56:	2701                	sext.w	a4,a4
    80005d58:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d5a:	472d                	li	a4,11
    80005d5c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005d5e:	473d                	li	a4,15
    80005d60:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005d62:	6705                	lui	a4,0x1
    80005d64:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005d66:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005d6a:	5bdc                	lw	a5,52(a5)
    80005d6c:	2781                	sext.w	a5,a5
  if(max == 0)
    80005d6e:	c7d9                	beqz	a5,80005dfc <virtio_disk_init+0x124>
  if(max < NUM)
    80005d70:	471d                	li	a4,7
    80005d72:	08f77d63          	bgeu	a4,a5,80005e0c <virtio_disk_init+0x134>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005d76:	100014b7          	lui	s1,0x10001
    80005d7a:	47a1                	li	a5,8
    80005d7c:	dc9c                	sw	a5,56(s1)
  memset(disk.pages, 0, sizeof(disk.pages));
    80005d7e:	6609                	lui	a2,0x2
    80005d80:	4581                	li	a1,0
    80005d82:	0001d517          	auipc	a0,0x1d
    80005d86:	27e50513          	addi	a0,a0,638 # 80023000 <disk>
    80005d8a:	ffffb097          	auipc	ra,0xffffb
    80005d8e:	f82080e7          	jalr	-126(ra) # 80000d0c <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    80005d92:	0001d717          	auipc	a4,0x1d
    80005d96:	26e70713          	addi	a4,a4,622 # 80023000 <disk>
    80005d9a:	00c75793          	srli	a5,a4,0xc
    80005d9e:	2781                	sext.w	a5,a5
    80005da0:	c0bc                	sw	a5,64(s1)
  disk.desc = (struct VRingDesc *) disk.pages;
    80005da2:	0001f797          	auipc	a5,0x1f
    80005da6:	25e78793          	addi	a5,a5,606 # 80025000 <disk+0x2000>
    80005daa:	e398                	sd	a4,0(a5)
  disk.avail = (uint16*)(((char*)disk.desc) + NUM*sizeof(struct VRingDesc));
    80005dac:	0001d717          	auipc	a4,0x1d
    80005db0:	2d470713          	addi	a4,a4,724 # 80023080 <disk+0x80>
    80005db4:	e798                	sd	a4,8(a5)
  disk.used = (struct UsedArea *) (disk.pages + PGSIZE);
    80005db6:	0001e717          	auipc	a4,0x1e
    80005dba:	24a70713          	addi	a4,a4,586 # 80024000 <disk+0x1000>
    80005dbe:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    80005dc0:	4705                	li	a4,1
    80005dc2:	00e78c23          	sb	a4,24(a5)
    80005dc6:	00e78ca3          	sb	a4,25(a5)
    80005dca:	00e78d23          	sb	a4,26(a5)
    80005dce:	00e78da3          	sb	a4,27(a5)
    80005dd2:	00e78e23          	sb	a4,28(a5)
    80005dd6:	00e78ea3          	sb	a4,29(a5)
    80005dda:	00e78f23          	sb	a4,30(a5)
    80005dde:	00e78fa3          	sb	a4,31(a5)
}
    80005de2:	60e2                	ld	ra,24(sp)
    80005de4:	6442                	ld	s0,16(sp)
    80005de6:	64a2                	ld	s1,8(sp)
    80005de8:	6105                	addi	sp,sp,32
    80005dea:	8082                	ret
    panic("could not find virtio disk");
    80005dec:	00003517          	auipc	a0,0x3
    80005df0:	9ac50513          	addi	a0,a0,-1620 # 80008798 <syscalls+0x370>
    80005df4:	ffffa097          	auipc	ra,0xffffa
    80005df8:	754080e7          	jalr	1876(ra) # 80000548 <panic>
    panic("virtio disk has no queue 0");
    80005dfc:	00003517          	auipc	a0,0x3
    80005e00:	9bc50513          	addi	a0,a0,-1604 # 800087b8 <syscalls+0x390>
    80005e04:	ffffa097          	auipc	ra,0xffffa
    80005e08:	744080e7          	jalr	1860(ra) # 80000548 <panic>
    panic("virtio disk max queue too short");
    80005e0c:	00003517          	auipc	a0,0x3
    80005e10:	9cc50513          	addi	a0,a0,-1588 # 800087d8 <syscalls+0x3b0>
    80005e14:	ffffa097          	auipc	ra,0xffffa
    80005e18:	734080e7          	jalr	1844(ra) # 80000548 <panic>

0000000080005e1c <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005e1c:	7119                	addi	sp,sp,-128
    80005e1e:	fc86                	sd	ra,120(sp)
    80005e20:	f8a2                	sd	s0,112(sp)
    80005e22:	f4a6                	sd	s1,104(sp)
    80005e24:	f0ca                	sd	s2,96(sp)
    80005e26:	ecce                	sd	s3,88(sp)
    80005e28:	e8d2                	sd	s4,80(sp)
    80005e2a:	e4d6                	sd	s5,72(sp)
    80005e2c:	e0da                	sd	s6,64(sp)
    80005e2e:	fc5e                	sd	s7,56(sp)
    80005e30:	f862                	sd	s8,48(sp)
    80005e32:	f466                	sd	s9,40(sp)
    80005e34:	f06a                	sd	s10,32(sp)
    80005e36:	0100                	addi	s0,sp,128
    80005e38:	892a                	mv	s2,a0
    80005e3a:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005e3c:	00c52c83          	lw	s9,12(a0)
    80005e40:	001c9c9b          	slliw	s9,s9,0x1
    80005e44:	1c82                	slli	s9,s9,0x20
    80005e46:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005e4a:	0001f517          	auipc	a0,0x1f
    80005e4e:	25e50513          	addi	a0,a0,606 # 800250a8 <disk+0x20a8>
    80005e52:	ffffb097          	auipc	ra,0xffffb
    80005e56:	dbe080e7          	jalr	-578(ra) # 80000c10 <acquire>
  for(int i = 0; i < 3; i++){
    80005e5a:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005e5c:	4c21                	li	s8,8
      disk.free[i] = 0;
    80005e5e:	0001db97          	auipc	s7,0x1d
    80005e62:	1a2b8b93          	addi	s7,s7,418 # 80023000 <disk>
    80005e66:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    80005e68:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005e6a:	8a4e                	mv	s4,s3
    80005e6c:	a051                	j	80005ef0 <virtio_disk_rw+0xd4>
      disk.free[i] = 0;
    80005e6e:	00fb86b3          	add	a3,s7,a5
    80005e72:	96da                	add	a3,a3,s6
    80005e74:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005e78:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    80005e7a:	0207c563          	bltz	a5,80005ea4 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    80005e7e:	2485                	addiw	s1,s1,1
    80005e80:	0711                	addi	a4,a4,4
    80005e82:	1b548863          	beq	s1,s5,80006032 <virtio_disk_rw+0x216>
    idx[i] = alloc_desc();
    80005e86:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005e88:	0001f697          	auipc	a3,0x1f
    80005e8c:	19068693          	addi	a3,a3,400 # 80025018 <disk+0x2018>
    80005e90:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005e92:	0006c583          	lbu	a1,0(a3)
    80005e96:	fde1                	bnez	a1,80005e6e <virtio_disk_rw+0x52>
  for(int i = 0; i < NUM; i++){
    80005e98:	2785                	addiw	a5,a5,1
    80005e9a:	0685                	addi	a3,a3,1
    80005e9c:	ff879be3          	bne	a5,s8,80005e92 <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    80005ea0:	57fd                	li	a5,-1
    80005ea2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005ea4:	02905a63          	blez	s1,80005ed8 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005ea8:	f9042503          	lw	a0,-112(s0)
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	daa080e7          	jalr	-598(ra) # 80005c56 <free_desc>
      for(int j = 0; j < i; j++)
    80005eb4:	4785                	li	a5,1
    80005eb6:	0297d163          	bge	a5,s1,80005ed8 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005eba:	f9442503          	lw	a0,-108(s0)
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	d98080e7          	jalr	-616(ra) # 80005c56 <free_desc>
      for(int j = 0; j < i; j++)
    80005ec6:	4789                	li	a5,2
    80005ec8:	0097d863          	bge	a5,s1,80005ed8 <virtio_disk_rw+0xbc>
        free_desc(idx[j]);
    80005ecc:	f9842503          	lw	a0,-104(s0)
    80005ed0:	00000097          	auipc	ra,0x0
    80005ed4:	d86080e7          	jalr	-634(ra) # 80005c56 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ed8:	0001f597          	auipc	a1,0x1f
    80005edc:	1d058593          	addi	a1,a1,464 # 800250a8 <disk+0x20a8>
    80005ee0:	0001f517          	auipc	a0,0x1f
    80005ee4:	13850513          	addi	a0,a0,312 # 80025018 <disk+0x2018>
    80005ee8:	ffffc097          	auipc	ra,0xffffc
    80005eec:	302080e7          	jalr	770(ra) # 800021ea <sleep>
  for(int i = 0; i < 3; i++){
    80005ef0:	f9040713          	addi	a4,s0,-112
    80005ef4:	84ce                	mv	s1,s3
    80005ef6:	bf41                	j	80005e86 <virtio_disk_rw+0x6a>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005ef8:	0001f717          	auipc	a4,0x1f
    80005efc:	10873703          	ld	a4,264(a4) # 80025000 <disk+0x2000>
    80005f00:	973e                	add	a4,a4,a5
    80005f02:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005f06:	0001d517          	auipc	a0,0x1d
    80005f0a:	0fa50513          	addi	a0,a0,250 # 80023000 <disk>
    80005f0e:	0001f717          	auipc	a4,0x1f
    80005f12:	0f270713          	addi	a4,a4,242 # 80025000 <disk+0x2000>
    80005f16:	6310                	ld	a2,0(a4)
    80005f18:	963e                	add	a2,a2,a5
    80005f1a:	00c65583          	lhu	a1,12(a2) # 200c <_entry-0x7fffdff4>
    80005f1e:	0015e593          	ori	a1,a1,1
    80005f22:	00b61623          	sh	a1,12(a2)
  disk.desc[idx[1]].next = idx[2];
    80005f26:	f9842683          	lw	a3,-104(s0)
    80005f2a:	6310                	ld	a2,0(a4)
    80005f2c:	97b2                	add	a5,a5,a2
    80005f2e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0;
    80005f32:	20048613          	addi	a2,s1,512 # 10001200 <_entry-0x6fffee00>
    80005f36:	0612                	slli	a2,a2,0x4
    80005f38:	962a                	add	a2,a2,a0
    80005f3a:	02060823          	sb	zero,48(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005f3e:	00469793          	slli	a5,a3,0x4
    80005f42:	630c                	ld	a1,0(a4)
    80005f44:	95be                	add	a1,a1,a5
    80005f46:	6689                	lui	a3,0x2
    80005f48:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005f4c:	96ce                	add	a3,a3,s3
    80005f4e:	96aa                	add	a3,a3,a0
    80005f50:	e194                	sd	a3,0(a1)
  disk.desc[idx[2]].len = 1;
    80005f52:	6314                	ld	a3,0(a4)
    80005f54:	96be                	add	a3,a3,a5
    80005f56:	4585                	li	a1,1
    80005f58:	c68c                	sw	a1,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005f5a:	6314                	ld	a3,0(a4)
    80005f5c:	96be                	add	a3,a3,a5
    80005f5e:	4509                	li	a0,2
    80005f60:	00a69623          	sh	a0,12(a3)
  disk.desc[idx[2]].next = 0;
    80005f64:	6314                	ld	a3,0(a4)
    80005f66:	97b6                	add	a5,a5,a3
    80005f68:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005f6c:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005f70:	03263423          	sd	s2,40(a2)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk.avail[2 + (disk.avail[1] % NUM)] = idx[0];
    80005f74:	6714                	ld	a3,8(a4)
    80005f76:	0026d783          	lhu	a5,2(a3)
    80005f7a:	8b9d                	andi	a5,a5,7
    80005f7c:	2789                	addiw	a5,a5,2
    80005f7e:	0786                	slli	a5,a5,0x1
    80005f80:	97b6                	add	a5,a5,a3
    80005f82:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80005f86:	0ff0000f          	fence
  disk.avail[1] = disk.avail[1] + 1;
    80005f8a:	6718                	ld	a4,8(a4)
    80005f8c:	00275783          	lhu	a5,2(a4)
    80005f90:	2785                	addiw	a5,a5,1
    80005f92:	00f71123          	sh	a5,2(a4)

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005f96:	100017b7          	lui	a5,0x10001
    80005f9a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005f9e:	00492783          	lw	a5,4(s2)
    80005fa2:	02b79163          	bne	a5,a1,80005fc4 <virtio_disk_rw+0x1a8>
    sleep(b, &disk.vdisk_lock);
    80005fa6:	0001f997          	auipc	s3,0x1f
    80005faa:	10298993          	addi	s3,s3,258 # 800250a8 <disk+0x20a8>
  while(b->disk == 1) {
    80005fae:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005fb0:	85ce                	mv	a1,s3
    80005fb2:	854a                	mv	a0,s2
    80005fb4:	ffffc097          	auipc	ra,0xffffc
    80005fb8:	236080e7          	jalr	566(ra) # 800021ea <sleep>
  while(b->disk == 1) {
    80005fbc:	00492783          	lw	a5,4(s2)
    80005fc0:	fe9788e3          	beq	a5,s1,80005fb0 <virtio_disk_rw+0x194>
  }

  disk.info[idx[0]].b = 0;
    80005fc4:	f9042483          	lw	s1,-112(s0)
    80005fc8:	20048793          	addi	a5,s1,512
    80005fcc:	00479713          	slli	a4,a5,0x4
    80005fd0:	0001d797          	auipc	a5,0x1d
    80005fd4:	03078793          	addi	a5,a5,48 # 80023000 <disk>
    80005fd8:	97ba                	add	a5,a5,a4
    80005fda:	0207b423          	sd	zero,40(a5)
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005fde:	0001f917          	auipc	s2,0x1f
    80005fe2:	02290913          	addi	s2,s2,34 # 80025000 <disk+0x2000>
    free_desc(i);
    80005fe6:	8526                	mv	a0,s1
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	c6e080e7          	jalr	-914(ra) # 80005c56 <free_desc>
    if(disk.desc[i].flags & VRING_DESC_F_NEXT)
    80005ff0:	0492                	slli	s1,s1,0x4
    80005ff2:	00093783          	ld	a5,0(s2)
    80005ff6:	94be                	add	s1,s1,a5
    80005ff8:	00c4d783          	lhu	a5,12(s1)
    80005ffc:	8b85                	andi	a5,a5,1
    80005ffe:	c781                	beqz	a5,80006006 <virtio_disk_rw+0x1ea>
      i = disk.desc[i].next;
    80006000:	00e4d483          	lhu	s1,14(s1)
    free_desc(i);
    80006004:	b7cd                	j	80005fe6 <virtio_disk_rw+0x1ca>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006006:	0001f517          	auipc	a0,0x1f
    8000600a:	0a250513          	addi	a0,a0,162 # 800250a8 <disk+0x20a8>
    8000600e:	ffffb097          	auipc	ra,0xffffb
    80006012:	cb6080e7          	jalr	-842(ra) # 80000cc4 <release>
}
    80006016:	70e6                	ld	ra,120(sp)
    80006018:	7446                	ld	s0,112(sp)
    8000601a:	74a6                	ld	s1,104(sp)
    8000601c:	7906                	ld	s2,96(sp)
    8000601e:	69e6                	ld	s3,88(sp)
    80006020:	6a46                	ld	s4,80(sp)
    80006022:	6aa6                	ld	s5,72(sp)
    80006024:	6b06                	ld	s6,64(sp)
    80006026:	7be2                	ld	s7,56(sp)
    80006028:	7c42                	ld	s8,48(sp)
    8000602a:	7ca2                	ld	s9,40(sp)
    8000602c:	7d02                	ld	s10,32(sp)
    8000602e:	6109                	addi	sp,sp,128
    80006030:	8082                	ret
  if(write)
    80006032:	01a037b3          	snez	a5,s10
    80006036:	f8f42023          	sw	a5,-128(s0)
  buf0.reserved = 0;
    8000603a:	f8042223          	sw	zero,-124(s0)
  buf0.sector = sector;
    8000603e:	f9943423          	sd	s9,-120(s0)
  disk.desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    80006042:	f9042483          	lw	s1,-112(s0)
    80006046:	00449993          	slli	s3,s1,0x4
    8000604a:	0001fa17          	auipc	s4,0x1f
    8000604e:	fb6a0a13          	addi	s4,s4,-74 # 80025000 <disk+0x2000>
    80006052:	000a3a83          	ld	s5,0(s4)
    80006056:	9ace                	add	s5,s5,s3
    80006058:	f8040513          	addi	a0,s0,-128
    8000605c:	ffffb097          	auipc	ra,0xffffb
    80006060:	084080e7          	jalr	132(ra) # 800010e0 <kvmpa>
    80006064:	00aab023          	sd	a0,0(s5)
  disk.desc[idx[0]].len = sizeof(buf0);
    80006068:	000a3783          	ld	a5,0(s4)
    8000606c:	97ce                	add	a5,a5,s3
    8000606e:	4741                	li	a4,16
    80006070:	c798                	sw	a4,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006072:	000a3783          	ld	a5,0(s4)
    80006076:	97ce                	add	a5,a5,s3
    80006078:	4705                	li	a4,1
    8000607a:	00e79623          	sh	a4,12(a5)
  disk.desc[idx[0]].next = idx[1];
    8000607e:	f9442783          	lw	a5,-108(s0)
    80006082:	000a3703          	ld	a4,0(s4)
    80006086:	974e                	add	a4,a4,s3
    80006088:	00f71723          	sh	a5,14(a4)
  disk.desc[idx[1]].addr = (uint64) b->data;
    8000608c:	0792                	slli	a5,a5,0x4
    8000608e:	000a3703          	ld	a4,0(s4)
    80006092:	973e                	add	a4,a4,a5
    80006094:	05890693          	addi	a3,s2,88
    80006098:	e314                	sd	a3,0(a4)
  disk.desc[idx[1]].len = BSIZE;
    8000609a:	000a3703          	ld	a4,0(s4)
    8000609e:	973e                	add	a4,a4,a5
    800060a0:	40000693          	li	a3,1024
    800060a4:	c714                	sw	a3,8(a4)
  if(write)
    800060a6:	e40d19e3          	bnez	s10,80005ef8 <virtio_disk_rw+0xdc>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800060aa:	0001f717          	auipc	a4,0x1f
    800060ae:	f5673703          	ld	a4,-170(a4) # 80025000 <disk+0x2000>
    800060b2:	973e                	add	a4,a4,a5
    800060b4:	4689                	li	a3,2
    800060b6:	00d71623          	sh	a3,12(a4)
    800060ba:	b5b1                	j	80005f06 <virtio_disk_rw+0xea>

00000000800060bc <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800060bc:	1101                	addi	sp,sp,-32
    800060be:	ec06                	sd	ra,24(sp)
    800060c0:	e822                	sd	s0,16(sp)
    800060c2:	e426                	sd	s1,8(sp)
    800060c4:	e04a                	sd	s2,0(sp)
    800060c6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800060c8:	0001f517          	auipc	a0,0x1f
    800060cc:	fe050513          	addi	a0,a0,-32 # 800250a8 <disk+0x20a8>
    800060d0:	ffffb097          	auipc	ra,0xffffb
    800060d4:	b40080e7          	jalr	-1216(ra) # 80000c10 <acquire>

  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    800060d8:	0001f717          	auipc	a4,0x1f
    800060dc:	f2870713          	addi	a4,a4,-216 # 80025000 <disk+0x2000>
    800060e0:	02075783          	lhu	a5,32(a4)
    800060e4:	6b18                	ld	a4,16(a4)
    800060e6:	00275683          	lhu	a3,2(a4)
    800060ea:	8ebd                	xor	a3,a3,a5
    800060ec:	8a9d                	andi	a3,a3,7
    800060ee:	cab9                	beqz	a3,80006144 <virtio_disk_intr+0x88>
    int id = disk.used->elems[disk.used_idx].id;

    if(disk.info[id].status != 0)
    800060f0:	0001d917          	auipc	s2,0x1d
    800060f4:	f1090913          	addi	s2,s2,-240 # 80023000 <disk>
      panic("virtio_disk_intr status");
    
    disk.info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk.info[id].b);

    disk.used_idx = (disk.used_idx + 1) % NUM;
    800060f8:	0001f497          	auipc	s1,0x1f
    800060fc:	f0848493          	addi	s1,s1,-248 # 80025000 <disk+0x2000>
    int id = disk.used->elems[disk.used_idx].id;
    80006100:	078e                	slli	a5,a5,0x3
    80006102:	97ba                	add	a5,a5,a4
    80006104:	43dc                	lw	a5,4(a5)
    if(disk.info[id].status != 0)
    80006106:	20078713          	addi	a4,a5,512
    8000610a:	0712                	slli	a4,a4,0x4
    8000610c:	974a                	add	a4,a4,s2
    8000610e:	03074703          	lbu	a4,48(a4)
    80006112:	ef21                	bnez	a4,8000616a <virtio_disk_intr+0xae>
    disk.info[id].b->disk = 0;   // disk is done with buf
    80006114:	20078793          	addi	a5,a5,512
    80006118:	0792                	slli	a5,a5,0x4
    8000611a:	97ca                	add	a5,a5,s2
    8000611c:	7798                	ld	a4,40(a5)
    8000611e:	00072223          	sw	zero,4(a4)
    wakeup(disk.info[id].b);
    80006122:	7788                	ld	a0,40(a5)
    80006124:	ffffc097          	auipc	ra,0xffffc
    80006128:	24c080e7          	jalr	588(ra) # 80002370 <wakeup>
    disk.used_idx = (disk.used_idx + 1) % NUM;
    8000612c:	0204d783          	lhu	a5,32(s1)
    80006130:	2785                	addiw	a5,a5,1
    80006132:	8b9d                	andi	a5,a5,7
    80006134:	02f49023          	sh	a5,32(s1)
  while((disk.used_idx % NUM) != (disk.used->id % NUM)){
    80006138:	6898                	ld	a4,16(s1)
    8000613a:	00275683          	lhu	a3,2(a4)
    8000613e:	8a9d                	andi	a3,a3,7
    80006140:	fcf690e3          	bne	a3,a5,80006100 <virtio_disk_intr+0x44>
  }
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006144:	10001737          	lui	a4,0x10001
    80006148:	533c                	lw	a5,96(a4)
    8000614a:	8b8d                	andi	a5,a5,3
    8000614c:	d37c                	sw	a5,100(a4)

  release(&disk.vdisk_lock);
    8000614e:	0001f517          	auipc	a0,0x1f
    80006152:	f5a50513          	addi	a0,a0,-166 # 800250a8 <disk+0x20a8>
    80006156:	ffffb097          	auipc	ra,0xffffb
    8000615a:	b6e080e7          	jalr	-1170(ra) # 80000cc4 <release>
}
    8000615e:	60e2                	ld	ra,24(sp)
    80006160:	6442                	ld	s0,16(sp)
    80006162:	64a2                	ld	s1,8(sp)
    80006164:	6902                	ld	s2,0(sp)
    80006166:	6105                	addi	sp,sp,32
    80006168:	8082                	ret
      panic("virtio_disk_intr status");
    8000616a:	00002517          	auipc	a0,0x2
    8000616e:	68e50513          	addi	a0,a0,1678 # 800087f8 <syscalls+0x3d0>
    80006172:	ffffa097          	auipc	ra,0xffffa
    80006176:	3d6080e7          	jalr	982(ra) # 80000548 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051573          	csrrw	a0,sscratch,a0
    80007004:	02153423          	sd	ra,40(a0)
    80007008:	02253823          	sd	sp,48(a0)
    8000700c:	02353c23          	sd	gp,56(a0)
    80007010:	04453023          	sd	tp,64(a0)
    80007014:	04553423          	sd	t0,72(a0)
    80007018:	04653823          	sd	t1,80(a0)
    8000701c:	04753c23          	sd	t2,88(a0)
    80007020:	f120                	sd	s0,96(a0)
    80007022:	f524                	sd	s1,104(a0)
    80007024:	fd2c                	sd	a1,120(a0)
    80007026:	e150                	sd	a2,128(a0)
    80007028:	e554                	sd	a3,136(a0)
    8000702a:	e958                	sd	a4,144(a0)
    8000702c:	ed5c                	sd	a5,152(a0)
    8000702e:	0b053023          	sd	a6,160(a0)
    80007032:	0b153423          	sd	a7,168(a0)
    80007036:	0b253823          	sd	s2,176(a0)
    8000703a:	0b353c23          	sd	s3,184(a0)
    8000703e:	0d453023          	sd	s4,192(a0)
    80007042:	0d553423          	sd	s5,200(a0)
    80007046:	0d653823          	sd	s6,208(a0)
    8000704a:	0d753c23          	sd	s7,216(a0)
    8000704e:	0f853023          	sd	s8,224(a0)
    80007052:	0f953423          	sd	s9,232(a0)
    80007056:	0fa53823          	sd	s10,240(a0)
    8000705a:	0fb53c23          	sd	s11,248(a0)
    8000705e:	11c53023          	sd	t3,256(a0)
    80007062:	11d53423          	sd	t4,264(a0)
    80007066:	11e53823          	sd	t5,272(a0)
    8000706a:	11f53c23          	sd	t6,280(a0)
    8000706e:	140022f3          	csrr	t0,sscratch
    80007072:	06553823          	sd	t0,112(a0)
    80007076:	00853103          	ld	sp,8(a0)
    8000707a:	02053203          	ld	tp,32(a0)
    8000707e:	01053283          	ld	t0,16(a0)
    80007082:	00053303          	ld	t1,0(a0)
    80007086:	18031073          	csrw	satp,t1
    8000708a:	12000073          	sfence.vma
    8000708e:	8282                	jr	t0

0000000080007090 <userret>:
    80007090:	18059073          	csrw	satp,a1
    80007094:	12000073          	sfence.vma
    80007098:	07053283          	ld	t0,112(a0)
    8000709c:	14029073          	csrw	sscratch,t0
    800070a0:	02853083          	ld	ra,40(a0)
    800070a4:	03053103          	ld	sp,48(a0)
    800070a8:	03853183          	ld	gp,56(a0)
    800070ac:	04053203          	ld	tp,64(a0)
    800070b0:	04853283          	ld	t0,72(a0)
    800070b4:	05053303          	ld	t1,80(a0)
    800070b8:	05853383          	ld	t2,88(a0)
    800070bc:	7120                	ld	s0,96(a0)
    800070be:	7524                	ld	s1,104(a0)
    800070c0:	7d2c                	ld	a1,120(a0)
    800070c2:	6150                	ld	a2,128(a0)
    800070c4:	6554                	ld	a3,136(a0)
    800070c6:	6958                	ld	a4,144(a0)
    800070c8:	6d5c                	ld	a5,152(a0)
    800070ca:	0a053803          	ld	a6,160(a0)
    800070ce:	0a853883          	ld	a7,168(a0)
    800070d2:	0b053903          	ld	s2,176(a0)
    800070d6:	0b853983          	ld	s3,184(a0)
    800070da:	0c053a03          	ld	s4,192(a0)
    800070de:	0c853a83          	ld	s5,200(a0)
    800070e2:	0d053b03          	ld	s6,208(a0)
    800070e6:	0d853b83          	ld	s7,216(a0)
    800070ea:	0e053c03          	ld	s8,224(a0)
    800070ee:	0e853c83          	ld	s9,232(a0)
    800070f2:	0f053d03          	ld	s10,240(a0)
    800070f6:	0f853d83          	ld	s11,248(a0)
    800070fa:	10053e03          	ld	t3,256(a0)
    800070fe:	10853e83          	ld	t4,264(a0)
    80007102:	11053f03          	ld	t5,272(a0)
    80007106:	11853f83          	ld	t6,280(a0)
    8000710a:	14051573          	csrrw	a0,sscratch,a0
    8000710e:	10200073          	sret
	...
