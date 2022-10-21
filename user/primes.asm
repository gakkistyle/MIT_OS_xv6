
user/_primes：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <PipeLine>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void PipeLine(int fds[])
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
    int out, nextOut;

    int fdsNext[2] = {-1};   // a very important procedure that assign -1 to the first entry. Otherwise the output sequence can be out of order.
   c:	fc042a23          	sw	zero,-44(s0)
  10:	57fd                	li	a5,-1
  12:	fcf42823          	sw	a5,-48(s0)
    close(fds[1]);
  16:	4148                	lw	a0,4(a0)
  18:	00000097          	auipc	ra,0x0
  1c:	40e080e7          	jalr	1038(ra) # 426 <close>
    if (read(fds[0], &out, sizeof(out)) > 0) {
  20:	4611                	li	a2,4
  22:	fdc40593          	addi	a1,s0,-36
  26:	4088                	lw	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	3ee080e7          	jalr	1006(ra) # 416 <read>
  30:	0aa05363          	blez	a0,d6 <PipeLine+0xd6>
        printf("prime %d\n", out);
  34:	fdc42583          	lw	a1,-36(s0)
  38:	00001517          	auipc	a0,0x1
  3c:	8e050513          	addi	a0,a0,-1824 # 918 <malloc+0xe4>
  40:	00000097          	auipc	ra,0x0
  44:	736080e7          	jalr	1846(ra) # 776 <printf>

        while (read(fds[0], &nextOut, sizeof(nextOut)) > 0) {
  48:	4611                	li	a2,4
  4a:	fd840593          	addi	a1,s0,-40
  4e:	4088                	lw	a0,0(s1)
  50:	00000097          	auipc	ra,0x0
  54:	3c6080e7          	jalr	966(ra) # 416 <read>
  58:	04a05863          	blez	a0,a8 <PipeLine+0xa8>
            if (nextOut % out != 0) {
  5c:	fd842783          	lw	a5,-40(s0)
  60:	fdc42703          	lw	a4,-36(s0)
  64:	02e7e7bb          	remw	a5,a5,a4
  68:	d3e5                	beqz	a5,48 <PipeLine+0x48>
                if (fdsNext[0] < 0) {
  6a:	fd042783          	lw	a5,-48(s0)
  6e:	0007cc63          	bltz	a5,86 <PipeLine+0x86>
                    if (pid == 0) {
                        PipeLine(fdsNext);
                        exit(0);
                    }
                }
                write(fdsNext[1], &nextOut, sizeof(nextOut));
  72:	4611                	li	a2,4
  74:	fd840593          	addi	a1,s0,-40
  78:	fd442503          	lw	a0,-44(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3a2080e7          	jalr	930(ra) # 41e <write>
  84:	b7d1                	j	48 <PipeLine+0x48>
                    pipe(fdsNext);        // only pipe when needed.
  86:	fd040513          	addi	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	384080e7          	jalr	900(ra) # 40e <pipe>
                    int pid = fork();
  92:	00000097          	auipc	ra,0x0
  96:	364080e7          	jalr	868(ra) # 3f6 <fork>
                    if (pid == 0) {
  9a:	fd61                	bnez	a0,72 <PipeLine+0x72>
                        PipeLine(fdsNext);
  9c:	fd040513          	addi	a0,s0,-48
  a0:	00000097          	auipc	ra,0x0
  a4:	f60080e7          	jalr	-160(ra) # 0 <PipeLine>
            }
        }
        close(fdsNext[1]);   //the close func before the wait syscall is essential, not close can result in the lack of fd.
  a8:	fd442503          	lw	a0,-44(s0)
  ac:	00000097          	auipc	ra,0x0
  b0:	37a080e7          	jalr	890(ra) # 426 <close>
        wait(0);
  b4:	4501                	li	a0,0
  b6:	00000097          	auipc	ra,0x0
  ba:	350080e7          	jalr	848(ra) # 406 <wait>
        close(fdsNext[1]);   //the close func after the wait syscall is not neccessary to get things right.
  be:	fd442503          	lw	a0,-44(s0)
  c2:	00000097          	auipc	ra,0x0
  c6:	364080e7          	jalr	868(ra) # 426 <close>
        close(fdsNext[0]);
  ca:	fd042503          	lw	a0,-48(s0)
  ce:	00000097          	auipc	ra,0x0
  d2:	358080e7          	jalr	856(ra) # 426 <close>
    }
    exit(0);
  d6:	4501                	li	a0,0
  d8:	00000097          	auipc	ra,0x0
  dc:	326080e7          	jalr	806(ra) # 3fe <exit>

00000000000000e0 <main>:
}

int
main(int argc, char *argv[])
{
  e0:	7179                	addi	sp,sp,-48
  e2:	f406                	sd	ra,40(sp)
  e4:	f022                	sd	s0,32(sp)
  e6:	ec26                	sd	s1,24(sp)
  e8:	1800                	addi	s0,sp,48
    if(argc > 1) {
  ea:	4785                	li	a5,1
  ec:	02a7d063          	bge	a5,a0,10c <main+0x2c>
        fprintf(2, "primes should not have arguments\n");
  f0:	00001597          	auipc	a1,0x1
  f4:	83858593          	addi	a1,a1,-1992 # 928 <malloc+0xf4>
  f8:	4509                	li	a0,2
  fa:	00000097          	auipc	ra,0x0
  fe:	64e080e7          	jalr	1614(ra) # 748 <fprintf>
        exit(1);
 102:	4505                	li	a0,1
 104:	00000097          	auipc	ra,0x0
 108:	2fa080e7          	jalr	762(ra) # 3fe <exit>
    }

    int fds[2];
    pipe(fds);
 10c:	fd840513          	addi	a0,s0,-40
 110:	00000097          	auipc	ra,0x0
 114:	2fe080e7          	jalr	766(ra) # 40e <pipe>

    int pid = fork();
 118:	00000097          	auipc	ra,0x0
 11c:	2de080e7          	jalr	734(ra) # 3f6 <fork>

    if (pid == 0) {
 120:	cd31                	beqz	a0,17c <main+0x9c>
        PipeLine(fds);
    } else {
        for (int i = 2; i <= 35; i++) {
 122:	4789                	li	a5,2
 124:	fcf42a23          	sw	a5,-44(s0)
 128:	02300493          	li	s1,35
            write(fds[1], &i, sizeof(i));
 12c:	4611                	li	a2,4
 12e:	fd440593          	addi	a1,s0,-44
 132:	fdc42503          	lw	a0,-36(s0)
 136:	00000097          	auipc	ra,0x0
 13a:	2e8080e7          	jalr	744(ra) # 41e <write>
        for (int i = 2; i <= 35; i++) {
 13e:	fd442783          	lw	a5,-44(s0)
 142:	2785                	addiw	a5,a5,1
 144:	0007871b          	sext.w	a4,a5
 148:	fcf42a23          	sw	a5,-44(s0)
 14c:	fee4d0e3          	bge	s1,a4,12c <main+0x4c>
        }
        close(fds[1]);
 150:	fdc42503          	lw	a0,-36(s0)
 154:	00000097          	auipc	ra,0x0
 158:	2d2080e7          	jalr	722(ra) # 426 <close>
        wait(0);
 15c:	4501                	li	a0,0
 15e:	00000097          	auipc	ra,0x0
 162:	2a8080e7          	jalr	680(ra) # 406 <wait>
        close(fds[0]);
 166:	fd842503          	lw	a0,-40(s0)
 16a:	00000097          	auipc	ra,0x0
 16e:	2bc080e7          	jalr	700(ra) # 426 <close>
    }
    
    exit(0);
 172:	4501                	li	a0,0
 174:	00000097          	auipc	ra,0x0
 178:	28a080e7          	jalr	650(ra) # 3fe <exit>
        PipeLine(fds);
 17c:	fd840513          	addi	a0,s0,-40
 180:	00000097          	auipc	ra,0x0
 184:	e80080e7          	jalr	-384(ra) # 0 <PipeLine>

0000000000000188 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e422                	sd	s0,8(sp)
 18c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 18e:	87aa                	mv	a5,a0
 190:	0585                	addi	a1,a1,1
 192:	0785                	addi	a5,a5,1
 194:	fff5c703          	lbu	a4,-1(a1)
 198:	fee78fa3          	sb	a4,-1(a5)
 19c:	fb75                	bnez	a4,190 <strcpy+0x8>
    ;
  return os;
}
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cb91                	beqz	a5,1c2 <strcmp+0x1e>
 1b0:	0005c703          	lbu	a4,0(a1)
 1b4:	00f71763          	bne	a4,a5,1c2 <strcmp+0x1e>
    p++, q++;
 1b8:	0505                	addi	a0,a0,1
 1ba:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	fbe5                	bnez	a5,1b0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1c2:	0005c503          	lbu	a0,0(a1)
}
 1c6:	40a7853b          	subw	a0,a5,a0
 1ca:	6422                	ld	s0,8(sp)
 1cc:	0141                	addi	sp,sp,16
 1ce:	8082                	ret

00000000000001d0 <strlen>:

uint
strlen(const char *s)
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e422                	sd	s0,8(sp)
 1d4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	cf91                	beqz	a5,1f6 <strlen+0x26>
 1dc:	0505                	addi	a0,a0,1
 1de:	87aa                	mv	a5,a0
 1e0:	4685                	li	a3,1
 1e2:	9e89                	subw	a3,a3,a0
 1e4:	00f6853b          	addw	a0,a3,a5
 1e8:	0785                	addi	a5,a5,1
 1ea:	fff7c703          	lbu	a4,-1(a5)
 1ee:	fb7d                	bnez	a4,1e4 <strlen+0x14>
    ;
  return n;
}
 1f0:	6422                	ld	s0,8(sp)
 1f2:	0141                	addi	sp,sp,16
 1f4:	8082                	ret
  for(n = 0; s[n]; n++)
 1f6:	4501                	li	a0,0
 1f8:	bfe5                	j	1f0 <strlen+0x20>

00000000000001fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e422                	sd	s0,8(sp)
 1fe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 200:	ce09                	beqz	a2,21a <memset+0x20>
 202:	87aa                	mv	a5,a0
 204:	fff6071b          	addiw	a4,a2,-1
 208:	1702                	slli	a4,a4,0x20
 20a:	9301                	srli	a4,a4,0x20
 20c:	0705                	addi	a4,a4,1
 20e:	972a                	add	a4,a4,a0
    cdst[i] = c;
 210:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 214:	0785                	addi	a5,a5,1
 216:	fee79de3          	bne	a5,a4,210 <memset+0x16>
  }
  return dst;
}
 21a:	6422                	ld	s0,8(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret

0000000000000220 <strchr>:

char*
strchr(const char *s, char c)
{
 220:	1141                	addi	sp,sp,-16
 222:	e422                	sd	s0,8(sp)
 224:	0800                	addi	s0,sp,16
  for(; *s; s++)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cb99                	beqz	a5,240 <strchr+0x20>
    if(*s == c)
 22c:	00f58763          	beq	a1,a5,23a <strchr+0x1a>
  for(; *s; s++)
 230:	0505                	addi	a0,a0,1
 232:	00054783          	lbu	a5,0(a0)
 236:	fbfd                	bnez	a5,22c <strchr+0xc>
      return (char*)s;
  return 0;
 238:	4501                	li	a0,0
}
 23a:	6422                	ld	s0,8(sp)
 23c:	0141                	addi	sp,sp,16
 23e:	8082                	ret
  return 0;
 240:	4501                	li	a0,0
 242:	bfe5                	j	23a <strchr+0x1a>

0000000000000244 <gets>:

char*
gets(char *buf, int max)
{
 244:	711d                	addi	sp,sp,-96
 246:	ec86                	sd	ra,88(sp)
 248:	e8a2                	sd	s0,80(sp)
 24a:	e4a6                	sd	s1,72(sp)
 24c:	e0ca                	sd	s2,64(sp)
 24e:	fc4e                	sd	s3,56(sp)
 250:	f852                	sd	s4,48(sp)
 252:	f456                	sd	s5,40(sp)
 254:	f05a                	sd	s6,32(sp)
 256:	ec5e                	sd	s7,24(sp)
 258:	1080                	addi	s0,sp,96
 25a:	8baa                	mv	s7,a0
 25c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 25e:	892a                	mv	s2,a0
 260:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 262:	4aa9                	li	s5,10
 264:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 266:	89a6                	mv	s3,s1
 268:	2485                	addiw	s1,s1,1
 26a:	0344d863          	bge	s1,s4,29a <gets+0x56>
    cc = read(0, &c, 1);
 26e:	4605                	li	a2,1
 270:	faf40593          	addi	a1,s0,-81
 274:	4501                	li	a0,0
 276:	00000097          	auipc	ra,0x0
 27a:	1a0080e7          	jalr	416(ra) # 416 <read>
    if(cc < 1)
 27e:	00a05e63          	blez	a0,29a <gets+0x56>
    buf[i++] = c;
 282:	faf44783          	lbu	a5,-81(s0)
 286:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 28a:	01578763          	beq	a5,s5,298 <gets+0x54>
 28e:	0905                	addi	s2,s2,1
 290:	fd679be3          	bne	a5,s6,266 <gets+0x22>
  for(i=0; i+1 < max; ){
 294:	89a6                	mv	s3,s1
 296:	a011                	j	29a <gets+0x56>
 298:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 29a:	99de                	add	s3,s3,s7
 29c:	00098023          	sb	zero,0(s3)
  return buf;
}
 2a0:	855e                	mv	a0,s7
 2a2:	60e6                	ld	ra,88(sp)
 2a4:	6446                	ld	s0,80(sp)
 2a6:	64a6                	ld	s1,72(sp)
 2a8:	6906                	ld	s2,64(sp)
 2aa:	79e2                	ld	s3,56(sp)
 2ac:	7a42                	ld	s4,48(sp)
 2ae:	7aa2                	ld	s5,40(sp)
 2b0:	7b02                	ld	s6,32(sp)
 2b2:	6be2                	ld	s7,24(sp)
 2b4:	6125                	addi	sp,sp,96
 2b6:	8082                	ret

00000000000002b8 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b8:	1101                	addi	sp,sp,-32
 2ba:	ec06                	sd	ra,24(sp)
 2bc:	e822                	sd	s0,16(sp)
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
 2c2:	1000                	addi	s0,sp,32
 2c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	4581                	li	a1,0
 2c8:	00000097          	auipc	ra,0x0
 2cc:	176080e7          	jalr	374(ra) # 43e <open>
  if(fd < 0)
 2d0:	02054563          	bltz	a0,2fa <stat+0x42>
 2d4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2d6:	85ca                	mv	a1,s2
 2d8:	00000097          	auipc	ra,0x0
 2dc:	17e080e7          	jalr	382(ra) # 456 <fstat>
 2e0:	892a                	mv	s2,a0
  close(fd);
 2e2:	8526                	mv	a0,s1
 2e4:	00000097          	auipc	ra,0x0
 2e8:	142080e7          	jalr	322(ra) # 426 <close>
  return r;
}
 2ec:	854a                	mv	a0,s2
 2ee:	60e2                	ld	ra,24(sp)
 2f0:	6442                	ld	s0,16(sp)
 2f2:	64a2                	ld	s1,8(sp)
 2f4:	6902                	ld	s2,0(sp)
 2f6:	6105                	addi	sp,sp,32
 2f8:	8082                	ret
    return -1;
 2fa:	597d                	li	s2,-1
 2fc:	bfc5                	j	2ec <stat+0x34>

00000000000002fe <atoi>:

int
atoi(const char *s)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e422                	sd	s0,8(sp)
 302:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 304:	00054603          	lbu	a2,0(a0)
 308:	fd06079b          	addiw	a5,a2,-48
 30c:	0ff7f793          	andi	a5,a5,255
 310:	4725                	li	a4,9
 312:	02f76963          	bltu	a4,a5,344 <atoi+0x46>
 316:	86aa                	mv	a3,a0
  n = 0;
 318:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 31a:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 31c:	0685                	addi	a3,a3,1
 31e:	0025179b          	slliw	a5,a0,0x2
 322:	9fa9                	addw	a5,a5,a0
 324:	0017979b          	slliw	a5,a5,0x1
 328:	9fb1                	addw	a5,a5,a2
 32a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 32e:	0006c603          	lbu	a2,0(a3)
 332:	fd06071b          	addiw	a4,a2,-48
 336:	0ff77713          	andi	a4,a4,255
 33a:	fee5f1e3          	bgeu	a1,a4,31c <atoi+0x1e>
  return n;
}
 33e:	6422                	ld	s0,8(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret
  n = 0;
 344:	4501                	li	a0,0
 346:	bfe5                	j	33e <atoi+0x40>

0000000000000348 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 34e:	02b57663          	bgeu	a0,a1,37a <memmove+0x32>
    while(n-- > 0)
 352:	02c05163          	blez	a2,374 <memmove+0x2c>
 356:	fff6079b          	addiw	a5,a2,-1
 35a:	1782                	slli	a5,a5,0x20
 35c:	9381                	srli	a5,a5,0x20
 35e:	0785                	addi	a5,a5,1
 360:	97aa                	add	a5,a5,a0
  dst = vdst;
 362:	872a                	mv	a4,a0
      *dst++ = *src++;
 364:	0585                	addi	a1,a1,1
 366:	0705                	addi	a4,a4,1
 368:	fff5c683          	lbu	a3,-1(a1)
 36c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 370:	fee79ae3          	bne	a5,a4,364 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 374:	6422                	ld	s0,8(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret
    dst += n;
 37a:	00c50733          	add	a4,a0,a2
    src += n;
 37e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 380:	fec05ae3          	blez	a2,374 <memmove+0x2c>
 384:	fff6079b          	addiw	a5,a2,-1
 388:	1782                	slli	a5,a5,0x20
 38a:	9381                	srli	a5,a5,0x20
 38c:	fff7c793          	not	a5,a5
 390:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 392:	15fd                	addi	a1,a1,-1
 394:	177d                	addi	a4,a4,-1
 396:	0005c683          	lbu	a3,0(a1)
 39a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 39e:	fee79ae3          	bne	a5,a4,392 <memmove+0x4a>
 3a2:	bfc9                	j	374 <memmove+0x2c>

00000000000003a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3a4:	1141                	addi	sp,sp,-16
 3a6:	e422                	sd	s0,8(sp)
 3a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3aa:	ca05                	beqz	a2,3da <memcmp+0x36>
 3ac:	fff6069b          	addiw	a3,a2,-1
 3b0:	1682                	slli	a3,a3,0x20
 3b2:	9281                	srli	a3,a3,0x20
 3b4:	0685                	addi	a3,a3,1
 3b6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3b8:	00054783          	lbu	a5,0(a0)
 3bc:	0005c703          	lbu	a4,0(a1)
 3c0:	00e79863          	bne	a5,a4,3d0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3c4:	0505                	addi	a0,a0,1
    p2++;
 3c6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3c8:	fed518e3          	bne	a0,a3,3b8 <memcmp+0x14>
  }
  return 0;
 3cc:	4501                	li	a0,0
 3ce:	a019                	j	3d4 <memcmp+0x30>
      return *p1 - *p2;
 3d0:	40e7853b          	subw	a0,a5,a4
}
 3d4:	6422                	ld	s0,8(sp)
 3d6:	0141                	addi	sp,sp,16
 3d8:	8082                	ret
  return 0;
 3da:	4501                	li	a0,0
 3dc:	bfe5                	j	3d4 <memcmp+0x30>

00000000000003de <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3e6:	00000097          	auipc	ra,0x0
 3ea:	f62080e7          	jalr	-158(ra) # 348 <memmove>
}
 3ee:	60a2                	ld	ra,8(sp)
 3f0:	6402                	ld	s0,0(sp)
 3f2:	0141                	addi	sp,sp,16
 3f4:	8082                	ret

00000000000003f6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3f6:	4885                	li	a7,1
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <exit>:
.global exit
exit:
 li a7, SYS_exit
 3fe:	4889                	li	a7,2
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <wait>:
.global wait
wait:
 li a7, SYS_wait
 406:	488d                	li	a7,3
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 40e:	4891                	li	a7,4
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <read>:
.global read
read:
 li a7, SYS_read
 416:	4895                	li	a7,5
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <write>:
.global write
write:
 li a7, SYS_write
 41e:	48c1                	li	a7,16
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <close>:
.global close
close:
 li a7, SYS_close
 426:	48d5                	li	a7,21
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <kill>:
.global kill
kill:
 li a7, SYS_kill
 42e:	4899                	li	a7,6
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <exec>:
.global exec
exec:
 li a7, SYS_exec
 436:	489d                	li	a7,7
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <open>:
.global open
open:
 li a7, SYS_open
 43e:	48bd                	li	a7,15
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 446:	48c5                	li	a7,17
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 44e:	48c9                	li	a7,18
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 456:	48a1                	li	a7,8
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <link>:
.global link
link:
 li a7, SYS_link
 45e:	48cd                	li	a7,19
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 466:	48d1                	li	a7,20
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 46e:	48a5                	li	a7,9
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <dup>:
.global dup
dup:
 li a7, SYS_dup
 476:	48a9                	li	a7,10
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 47e:	48ad                	li	a7,11
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 486:	48b1                	li	a7,12
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 48e:	48b5                	li	a7,13
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 496:	48b9                	li	a7,14
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 49e:	1101                	addi	sp,sp,-32
 4a0:	ec06                	sd	ra,24(sp)
 4a2:	e822                	sd	s0,16(sp)
 4a4:	1000                	addi	s0,sp,32
 4a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4aa:	4605                	li	a2,1
 4ac:	fef40593          	addi	a1,s0,-17
 4b0:	00000097          	auipc	ra,0x0
 4b4:	f6e080e7          	jalr	-146(ra) # 41e <write>
}
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	6105                	addi	sp,sp,32
 4be:	8082                	ret

00000000000004c0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c0:	7139                	addi	sp,sp,-64
 4c2:	fc06                	sd	ra,56(sp)
 4c4:	f822                	sd	s0,48(sp)
 4c6:	f426                	sd	s1,40(sp)
 4c8:	f04a                	sd	s2,32(sp)
 4ca:	ec4e                	sd	s3,24(sp)
 4cc:	0080                	addi	s0,sp,64
 4ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4d0:	c299                	beqz	a3,4d6 <printint+0x16>
 4d2:	0805c863          	bltz	a1,562 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4d6:	2581                	sext.w	a1,a1
  neg = 0;
 4d8:	4881                	li	a7,0
 4da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e0:	2601                	sext.w	a2,a2
 4e2:	00000517          	auipc	a0,0x0
 4e6:	47650513          	addi	a0,a0,1142 # 958 <digits>
 4ea:	883a                	mv	a6,a4
 4ec:	2705                	addiw	a4,a4,1
 4ee:	02c5f7bb          	remuw	a5,a1,a2
 4f2:	1782                	slli	a5,a5,0x20
 4f4:	9381                	srli	a5,a5,0x20
 4f6:	97aa                	add	a5,a5,a0
 4f8:	0007c783          	lbu	a5,0(a5)
 4fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 500:	0005879b          	sext.w	a5,a1
 504:	02c5d5bb          	divuw	a1,a1,a2
 508:	0685                	addi	a3,a3,1
 50a:	fec7f0e3          	bgeu	a5,a2,4ea <printint+0x2a>
  if(neg)
 50e:	00088b63          	beqz	a7,524 <printint+0x64>
    buf[i++] = '-';
 512:	fd040793          	addi	a5,s0,-48
 516:	973e                	add	a4,a4,a5
 518:	02d00793          	li	a5,45
 51c:	fef70823          	sb	a5,-16(a4)
 520:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 524:	02e05863          	blez	a4,554 <printint+0x94>
 528:	fc040793          	addi	a5,s0,-64
 52c:	00e78933          	add	s2,a5,a4
 530:	fff78993          	addi	s3,a5,-1
 534:	99ba                	add	s3,s3,a4
 536:	377d                	addiw	a4,a4,-1
 538:	1702                	slli	a4,a4,0x20
 53a:	9301                	srli	a4,a4,0x20
 53c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 540:	fff94583          	lbu	a1,-1(s2)
 544:	8526                	mv	a0,s1
 546:	00000097          	auipc	ra,0x0
 54a:	f58080e7          	jalr	-168(ra) # 49e <putc>
  while(--i >= 0)
 54e:	197d                	addi	s2,s2,-1
 550:	ff3918e3          	bne	s2,s3,540 <printint+0x80>
}
 554:	70e2                	ld	ra,56(sp)
 556:	7442                	ld	s0,48(sp)
 558:	74a2                	ld	s1,40(sp)
 55a:	7902                	ld	s2,32(sp)
 55c:	69e2                	ld	s3,24(sp)
 55e:	6121                	addi	sp,sp,64
 560:	8082                	ret
    x = -xx;
 562:	40b005bb          	negw	a1,a1
    neg = 1;
 566:	4885                	li	a7,1
    x = -xx;
 568:	bf8d                	j	4da <printint+0x1a>

000000000000056a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 56a:	7119                	addi	sp,sp,-128
 56c:	fc86                	sd	ra,120(sp)
 56e:	f8a2                	sd	s0,112(sp)
 570:	f4a6                	sd	s1,104(sp)
 572:	f0ca                	sd	s2,96(sp)
 574:	ecce                	sd	s3,88(sp)
 576:	e8d2                	sd	s4,80(sp)
 578:	e4d6                	sd	s5,72(sp)
 57a:	e0da                	sd	s6,64(sp)
 57c:	fc5e                	sd	s7,56(sp)
 57e:	f862                	sd	s8,48(sp)
 580:	f466                	sd	s9,40(sp)
 582:	f06a                	sd	s10,32(sp)
 584:	ec6e                	sd	s11,24(sp)
 586:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 588:	0005c903          	lbu	s2,0(a1)
 58c:	18090f63          	beqz	s2,72a <vprintf+0x1c0>
 590:	8aaa                	mv	s5,a0
 592:	8b32                	mv	s6,a2
 594:	00158493          	addi	s1,a1,1
  state = 0;
 598:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 59a:	02500a13          	li	s4,37
      if(c == 'd'){
 59e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5a2:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5a6:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5aa:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5ae:	00000b97          	auipc	s7,0x0
 5b2:	3aab8b93          	addi	s7,s7,938 # 958 <digits>
 5b6:	a839                	j	5d4 <vprintf+0x6a>
        putc(fd, c);
 5b8:	85ca                	mv	a1,s2
 5ba:	8556                	mv	a0,s5
 5bc:	00000097          	auipc	ra,0x0
 5c0:	ee2080e7          	jalr	-286(ra) # 49e <putc>
 5c4:	a019                	j	5ca <vprintf+0x60>
    } else if(state == '%'){
 5c6:	01498f63          	beq	s3,s4,5e4 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5ca:	0485                	addi	s1,s1,1
 5cc:	fff4c903          	lbu	s2,-1(s1)
 5d0:	14090d63          	beqz	s2,72a <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5d4:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5d8:	fe0997e3          	bnez	s3,5c6 <vprintf+0x5c>
      if(c == '%'){
 5dc:	fd479ee3          	bne	a5,s4,5b8 <vprintf+0x4e>
        state = '%';
 5e0:	89be                	mv	s3,a5
 5e2:	b7e5                	j	5ca <vprintf+0x60>
      if(c == 'd'){
 5e4:	05878063          	beq	a5,s8,624 <vprintf+0xba>
      } else if(c == 'l') {
 5e8:	05978c63          	beq	a5,s9,640 <vprintf+0xd6>
      } else if(c == 'x') {
 5ec:	07a78863          	beq	a5,s10,65c <vprintf+0xf2>
      } else if(c == 'p') {
 5f0:	09b78463          	beq	a5,s11,678 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 5f4:	07300713          	li	a4,115
 5f8:	0ce78663          	beq	a5,a4,6c4 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5fc:	06300713          	li	a4,99
 600:	0ee78e63          	beq	a5,a4,6fc <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 604:	11478863          	beq	a5,s4,714 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 608:	85d2                	mv	a1,s4
 60a:	8556                	mv	a0,s5
 60c:	00000097          	auipc	ra,0x0
 610:	e92080e7          	jalr	-366(ra) # 49e <putc>
        putc(fd, c);
 614:	85ca                	mv	a1,s2
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	e86080e7          	jalr	-378(ra) # 49e <putc>
      }
      state = 0;
 620:	4981                	li	s3,0
 622:	b765                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 624:	008b0913          	addi	s2,s6,8
 628:	4685                	li	a3,1
 62a:	4629                	li	a2,10
 62c:	000b2583          	lw	a1,0(s6)
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e8e080e7          	jalr	-370(ra) # 4c0 <printint>
 63a:	8b4a                	mv	s6,s2
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b771                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b0913          	addi	s2,s6,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000b2583          	lw	a1,0(s6)
 64c:	8556                	mv	a0,s5
 64e:	00000097          	auipc	ra,0x0
 652:	e72080e7          	jalr	-398(ra) # 4c0 <printint>
 656:	8b4a                	mv	s6,s2
      state = 0;
 658:	4981                	li	s3,0
 65a:	bf85                	j	5ca <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 65c:	008b0913          	addi	s2,s6,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000b2583          	lw	a1,0(s6)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	e56080e7          	jalr	-426(ra) # 4c0 <printint>
 672:	8b4a                	mv	s6,s2
      state = 0;
 674:	4981                	li	s3,0
 676:	bf91                	j	5ca <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 678:	008b0793          	addi	a5,s6,8
 67c:	f8f43423          	sd	a5,-120(s0)
 680:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 684:	03000593          	li	a1,48
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e14080e7          	jalr	-492(ra) # 49e <putc>
  putc(fd, 'x');
 692:	85ea                	mv	a1,s10
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	e08080e7          	jalr	-504(ra) # 49e <putc>
 69e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6a0:	03c9d793          	srli	a5,s3,0x3c
 6a4:	97de                	add	a5,a5,s7
 6a6:	0007c583          	lbu	a1,0(a5)
 6aa:	8556                	mv	a0,s5
 6ac:	00000097          	auipc	ra,0x0
 6b0:	df2080e7          	jalr	-526(ra) # 49e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6b4:	0992                	slli	s3,s3,0x4
 6b6:	397d                	addiw	s2,s2,-1
 6b8:	fe0914e3          	bnez	s2,6a0 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6bc:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b721                	j	5ca <vprintf+0x60>
        s = va_arg(ap, char*);
 6c4:	008b0993          	addi	s3,s6,8
 6c8:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6cc:	02090163          	beqz	s2,6ee <vprintf+0x184>
        while(*s != 0){
 6d0:	00094583          	lbu	a1,0(s2)
 6d4:	c9a1                	beqz	a1,724 <vprintf+0x1ba>
          putc(fd, *s);
 6d6:	8556                	mv	a0,s5
 6d8:	00000097          	auipc	ra,0x0
 6dc:	dc6080e7          	jalr	-570(ra) # 49e <putc>
          s++;
 6e0:	0905                	addi	s2,s2,1
        while(*s != 0){
 6e2:	00094583          	lbu	a1,0(s2)
 6e6:	f9e5                	bnez	a1,6d6 <vprintf+0x16c>
        s = va_arg(ap, char*);
 6e8:	8b4e                	mv	s6,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	bdf9                	j	5ca <vprintf+0x60>
          s = "(null)";
 6ee:	00000917          	auipc	s2,0x0
 6f2:	26290913          	addi	s2,s2,610 # 950 <malloc+0x11c>
        while(*s != 0){
 6f6:	02800593          	li	a1,40
 6fa:	bff1                	j	6d6 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 6fc:	008b0913          	addi	s2,s6,8
 700:	000b4583          	lbu	a1,0(s6)
 704:	8556                	mv	a0,s5
 706:	00000097          	auipc	ra,0x0
 70a:	d98080e7          	jalr	-616(ra) # 49e <putc>
 70e:	8b4a                	mv	s6,s2
      state = 0;
 710:	4981                	li	s3,0
 712:	bd65                	j	5ca <vprintf+0x60>
        putc(fd, c);
 714:	85d2                	mv	a1,s4
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	d86080e7          	jalr	-634(ra) # 49e <putc>
      state = 0;
 720:	4981                	li	s3,0
 722:	b565                	j	5ca <vprintf+0x60>
        s = va_arg(ap, char*);
 724:	8b4e                	mv	s6,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	b54d                	j	5ca <vprintf+0x60>
    }
  }
}
 72a:	70e6                	ld	ra,120(sp)
 72c:	7446                	ld	s0,112(sp)
 72e:	74a6                	ld	s1,104(sp)
 730:	7906                	ld	s2,96(sp)
 732:	69e6                	ld	s3,88(sp)
 734:	6a46                	ld	s4,80(sp)
 736:	6aa6                	ld	s5,72(sp)
 738:	6b06                	ld	s6,64(sp)
 73a:	7be2                	ld	s7,56(sp)
 73c:	7c42                	ld	s8,48(sp)
 73e:	7ca2                	ld	s9,40(sp)
 740:	7d02                	ld	s10,32(sp)
 742:	6de2                	ld	s11,24(sp)
 744:	6109                	addi	sp,sp,128
 746:	8082                	ret

0000000000000748 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 748:	715d                	addi	sp,sp,-80
 74a:	ec06                	sd	ra,24(sp)
 74c:	e822                	sd	s0,16(sp)
 74e:	1000                	addi	s0,sp,32
 750:	e010                	sd	a2,0(s0)
 752:	e414                	sd	a3,8(s0)
 754:	e818                	sd	a4,16(s0)
 756:	ec1c                	sd	a5,24(s0)
 758:	03043023          	sd	a6,32(s0)
 75c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 764:	8622                	mv	a2,s0
 766:	00000097          	auipc	ra,0x0
 76a:	e04080e7          	jalr	-508(ra) # 56a <vprintf>
}
 76e:	60e2                	ld	ra,24(sp)
 770:	6442                	ld	s0,16(sp)
 772:	6161                	addi	sp,sp,80
 774:	8082                	ret

0000000000000776 <printf>:

void
printf(const char *fmt, ...)
{
 776:	711d                	addi	sp,sp,-96
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e40c                	sd	a1,8(s0)
 780:	e810                	sd	a2,16(s0)
 782:	ec14                	sd	a3,24(s0)
 784:	f018                	sd	a4,32(s0)
 786:	f41c                	sd	a5,40(s0)
 788:	03043823          	sd	a6,48(s0)
 78c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 790:	00840613          	addi	a2,s0,8
 794:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 798:	85aa                	mv	a1,a0
 79a:	4505                	li	a0,1
 79c:	00000097          	auipc	ra,0x0
 7a0:	dce080e7          	jalr	-562(ra) # 56a <vprintf>
}
 7a4:	60e2                	ld	ra,24(sp)
 7a6:	6442                	ld	s0,16(sp)
 7a8:	6125                	addi	sp,sp,96
 7aa:	8082                	ret

00000000000007ac <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ac:	1141                	addi	sp,sp,-16
 7ae:	e422                	sd	s0,8(sp)
 7b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b6:	00000797          	auipc	a5,0x0
 7ba:	1ba7b783          	ld	a5,442(a5) # 970 <freep>
 7be:	a805                	j	7ee <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c0:	4618                	lw	a4,8(a2)
 7c2:	9db9                	addw	a1,a1,a4
 7c4:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c8:	6398                	ld	a4,0(a5)
 7ca:	6318                	ld	a4,0(a4)
 7cc:	fee53823          	sd	a4,-16(a0)
 7d0:	a091                	j	814 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d2:	ff852703          	lw	a4,-8(a0)
 7d6:	9e39                	addw	a2,a2,a4
 7d8:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7da:	ff053703          	ld	a4,-16(a0)
 7de:	e398                	sd	a4,0(a5)
 7e0:	a099                	j	826 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x40>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x50>
{
 7ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x36>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059713          	slli	a4,a1,0x20
 806:	9301                	srli	a4,a4,0x20
 808:	0712                	slli	a4,a4,0x4
 80a:	9736                	add	a4,a4,a3
 80c:	fae60ae3          	beq	a2,a4,7c0 <free+0x14>
    bp->s.ptr = p->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 814:	4790                	lw	a2,8(a5)
 816:	02061713          	slli	a4,a2,0x20
 81a:	9301                	srli	a4,a4,0x20
 81c:	0712                	slli	a4,a4,0x4
 81e:	973e                	add	a4,a4,a5
 820:	fae689e3          	beq	a3,a4,7d2 <free+0x26>
  } else
    p->s.ptr = bp;
 824:	e394                	sd	a3,0(a5)
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	14f73523          	sd	a5,330(a4) # 970 <freep>
}
 82e:	6422                	ld	s0,8(sp)
 830:	0141                	addi	sp,sp,16
 832:	8082                	ret

0000000000000834 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 834:	7139                	addi	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f426                	sd	s1,40(sp)
 83c:	f04a                	sd	s2,32(sp)
 83e:	ec4e                	sd	s3,24(sp)
 840:	e852                	sd	s4,16(sp)
 842:	e456                	sd	s5,8(sp)
 844:	e05a                	sd	s6,0(sp)
 846:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 848:	02051493          	slli	s1,a0,0x20
 84c:	9081                	srli	s1,s1,0x20
 84e:	04bd                	addi	s1,s1,15
 850:	8091                	srli	s1,s1,0x4
 852:	0014899b          	addiw	s3,s1,1
 856:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 858:	00000517          	auipc	a0,0x0
 85c:	11853503          	ld	a0,280(a0) # 970 <freep>
 860:	c515                	beqz	a0,88c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 862:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 864:	4798                	lw	a4,8(a5)
 866:	02977f63          	bgeu	a4,s1,8a4 <malloc+0x70>
 86a:	8a4e                	mv	s4,s3
 86c:	0009871b          	sext.w	a4,s3
 870:	6685                	lui	a3,0x1
 872:	00d77363          	bgeu	a4,a3,878 <malloc+0x44>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 880:	00000917          	auipc	s2,0x0
 884:	0f090913          	addi	s2,s2,240 # 970 <freep>
  if(p == (char*)-1)
 888:	5afd                	li	s5,-1
 88a:	a88d                	j	8fc <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 88c:	00000797          	auipc	a5,0x0
 890:	0ec78793          	addi	a5,a5,236 # 978 <base>
 894:	00000717          	auipc	a4,0x0
 898:	0cf73e23          	sd	a5,220(a4) # 970 <freep>
 89c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 89e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8a2:	b7e1                	j	86a <malloc+0x36>
      if(p->s.size == nunits)
 8a4:	02e48b63          	beq	s1,a4,8da <malloc+0xa6>
        p->s.size -= nunits;
 8a8:	4137073b          	subw	a4,a4,s3
 8ac:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ae:	1702                	slli	a4,a4,0x20
 8b0:	9301                	srli	a4,a4,0x20
 8b2:	0712                	slli	a4,a4,0x4
 8b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ba:	00000717          	auipc	a4,0x0
 8be:	0aa73b23          	sd	a0,182(a4) # 970 <freep>
      return (void*)(p + 1);
 8c2:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8c6:	70e2                	ld	ra,56(sp)
 8c8:	7442                	ld	s0,48(sp)
 8ca:	74a2                	ld	s1,40(sp)
 8cc:	7902                	ld	s2,32(sp)
 8ce:	69e2                	ld	s3,24(sp)
 8d0:	6a42                	ld	s4,16(sp)
 8d2:	6aa2                	ld	s5,8(sp)
 8d4:	6b02                	ld	s6,0(sp)
 8d6:	6121                	addi	sp,sp,64
 8d8:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8da:	6398                	ld	a4,0(a5)
 8dc:	e118                	sd	a4,0(a0)
 8de:	bff1                	j	8ba <malloc+0x86>
  hp->s.size = nu;
 8e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8e4:	0541                	addi	a0,a0,16
 8e6:	00000097          	auipc	ra,0x0
 8ea:	ec6080e7          	jalr	-314(ra) # 7ac <free>
  return freep;
 8ee:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8f2:	d971                	beqz	a0,8c6 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f6:	4798                	lw	a4,8(a5)
 8f8:	fa9776e3          	bgeu	a4,s1,8a4 <malloc+0x70>
    if(p == freep)
 8fc:	00093703          	ld	a4,0(s2)
 900:	853e                	mv	a0,a5
 902:	fef719e3          	bne	a4,a5,8f4 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 906:	8552                	mv	a0,s4
 908:	00000097          	auipc	ra,0x0
 90c:	b7e080e7          	jalr	-1154(ra) # 486 <sbrk>
  if(p == (char*)-1)
 910:	fd5518e3          	bne	a0,s5,8e0 <malloc+0xac>
        return 0;
 914:	4501                	li	a0,0
 916:	bf45                	j	8c6 <malloc+0x92>
