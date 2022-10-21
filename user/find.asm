
user/_find：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "user/user.h"
#include "kernel/fs.h"

void
find(char *path, char *file)
{
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	23813823          	sd	s8,560(sp)
  2c:	0500                	addi	s0,sp,640
  2e:	892a                	mv	s2,a0
  30:	89ae                	mv	s3,a1
    int fd;
    struct dirent de;
    struct stat st;

    // check the path
    if((fd = open(path, 0)) < 0){
  32:	4581                	li	a1,0
  34:	00000097          	auipc	ra,0x0
  38:	4e0080e7          	jalr	1248(ra) # 514 <open>
  3c:	06054663          	bltz	a0,a8 <find+0xa8>
  40:	84aa                	mv	s1,a0
        fprintf(2, "find: cannot open the dir: %s\n", path);
        return;
    }

    if(fstat(fd, &st) < 0){
  42:	d8840593          	addi	a1,s0,-632
  46:	00000097          	auipc	ra,0x0
  4a:	4e6080e7          	jalr	1254(ra) # 52c <fstat>
  4e:	06054863          	bltz	a0,be <find+0xbe>
        fprintf(2, "find : cannot stat the dir: %s\n", path);
        close(fd);
        return;
    }

    if(st.type != T_DIR) {
  52:	d9041703          	lh	a4,-624(s0)
  56:	4785                	li	a5,1
  58:	08f70363          	beq	a4,a5,de <find+0xde>
        fprintf(2, "find : the first arg should be dir: %s\n", path);
  5c:	864a                	mv	a2,s2
  5e:	00001597          	auipc	a1,0x1
  62:	9d258593          	addi	a1,a1,-1582 # a30 <malloc+0x126>
  66:	4509                	li	a0,2
  68:	00000097          	auipc	ra,0x0
  6c:	7b6080e7          	jalr	1974(ra) # 81e <fprintf>
        close(fd);
  70:	8526                	mv	a0,s1
  72:	00000097          	auipc	ra,0x0
  76:	48a080e7          	jalr	1162(ra) # 4fc <close>
        if (st.type == T_DIR && strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0) {
            find(buf, file);
        } 
    }
    close(fd);
}
  7a:	27813083          	ld	ra,632(sp)
  7e:	27013403          	ld	s0,624(sp)
  82:	26813483          	ld	s1,616(sp)
  86:	26013903          	ld	s2,608(sp)
  8a:	25813983          	ld	s3,600(sp)
  8e:	25013a03          	ld	s4,592(sp)
  92:	24813a83          	ld	s5,584(sp)
  96:	24013b03          	ld	s6,576(sp)
  9a:	23813b83          	ld	s7,568(sp)
  9e:	23013c03          	ld	s8,560(sp)
  a2:	28010113          	addi	sp,sp,640
  a6:	8082                	ret
        fprintf(2, "find: cannot open the dir: %s\n", path);
  a8:	864a                	mv	a2,s2
  aa:	00001597          	auipc	a1,0x1
  ae:	94658593          	addi	a1,a1,-1722 # 9f0 <malloc+0xe6>
  b2:	4509                	li	a0,2
  b4:	00000097          	auipc	ra,0x0
  b8:	76a080e7          	jalr	1898(ra) # 81e <fprintf>
        return;
  bc:	bf7d                	j	7a <find+0x7a>
        fprintf(2, "find : cannot stat the dir: %s\n", path);
  be:	864a                	mv	a2,s2
  c0:	00001597          	auipc	a1,0x1
  c4:	95058593          	addi	a1,a1,-1712 # a10 <malloc+0x106>
  c8:	4509                	li	a0,2
  ca:	00000097          	auipc	ra,0x0
  ce:	754080e7          	jalr	1876(ra) # 81e <fprintf>
        close(fd);
  d2:	8526                	mv	a0,s1
  d4:	00000097          	auipc	ra,0x0
  d8:	428080e7          	jalr	1064(ra) # 4fc <close>
        return;
  dc:	bf79                	j	7a <find+0x7a>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
  de:	854a                	mv	a0,s2
  e0:	00000097          	auipc	ra,0x0
  e4:	1c6080e7          	jalr	454(ra) # 2a6 <strlen>
  e8:	2541                	addiw	a0,a0,16
  ea:	20000793          	li	a5,512
  ee:	04a7ea63          	bltu	a5,a0,142 <find+0x142>
    strcpy(buf, path);
  f2:	85ca                	mv	a1,s2
  f4:	db040513          	addi	a0,s0,-592
  f8:	00000097          	auipc	ra,0x0
  fc:	166080e7          	jalr	358(ra) # 25e <strcpy>
    p = buf+strlen(buf);
 100:	db040513          	addi	a0,s0,-592
 104:	00000097          	auipc	ra,0x0
 108:	1a2080e7          	jalr	418(ra) # 2a6 <strlen>
 10c:	02051913          	slli	s2,a0,0x20
 110:	02095913          	srli	s2,s2,0x20
 114:	db040793          	addi	a5,s0,-592
 118:	993e                	add	s2,s2,a5
    *p++ = '/';
 11a:	00190a13          	addi	s4,s2,1
 11e:	02f00793          	li	a5,47
 122:	00f90023          	sb	a5,0(s2)
        if (st.type == T_DIR && strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0) {
 126:	4a85                	li	s5,1
 128:	00001b97          	auipc	s7,0x1
 12c:	960b8b93          	addi	s7,s7,-1696 # a88 <malloc+0x17e>
 130:	00001c17          	auipc	s8,0x1
 134:	960c0c13          	addi	s8,s8,-1696 # a90 <malloc+0x186>
            printf("%s\n", buf);
 138:	00001b17          	auipc	s6,0x1
 13c:	948b0b13          	addi	s6,s6,-1720 # a80 <malloc+0x176>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 140:	a0a9                	j	18a <find+0x18a>
        printf("ls: path too long\n");
 142:	00001517          	auipc	a0,0x1
 146:	91650513          	addi	a0,a0,-1770 # a58 <malloc+0x14e>
 14a:	00000097          	auipc	ra,0x0
 14e:	702080e7          	jalr	1794(ra) # 84c <printf>
        close(fd);
 152:	8526                	mv	a0,s1
 154:	00000097          	auipc	ra,0x0
 158:	3a8080e7          	jalr	936(ra) # 4fc <close>
        return;
 15c:	bf39                	j	7a <find+0x7a>
            printf("ls: cannot stat %s\n", buf);
 15e:	db040593          	addi	a1,s0,-592
 162:	00001517          	auipc	a0,0x1
 166:	90e50513          	addi	a0,a0,-1778 # a70 <malloc+0x166>
 16a:	00000097          	auipc	ra,0x0
 16e:	6e2080e7          	jalr	1762(ra) # 84c <printf>
            continue;
 172:	a821                	j	18a <find+0x18a>
            printf("%s\n", buf);
 174:	db040593          	addi	a1,s0,-592
 178:	855a                	mv	a0,s6
 17a:	00000097          	auipc	ra,0x0
 17e:	6d2080e7          	jalr	1746(ra) # 84c <printf>
        if (st.type == T_DIR && strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0) {
 182:	d9041783          	lh	a5,-624(s0)
 186:	05578d63          	beq	a5,s5,1e0 <find+0x1e0>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 18a:	4641                	li	a2,16
 18c:	da040593          	addi	a1,s0,-608
 190:	8526                	mv	a0,s1
 192:	00000097          	auipc	ra,0x0
 196:	35a080e7          	jalr	858(ra) # 4ec <read>
 19a:	47c1                	li	a5,16
 19c:	06f51a63          	bne	a0,a5,210 <find+0x210>
        if(de.inum == 0)
 1a0:	da045783          	lhu	a5,-608(s0)
 1a4:	d3fd                	beqz	a5,18a <find+0x18a>
        memmove(p, de.name, DIRSIZ);
 1a6:	4639                	li	a2,14
 1a8:	da240593          	addi	a1,s0,-606
 1ac:	8552                	mv	a0,s4
 1ae:	00000097          	auipc	ra,0x0
 1b2:	270080e7          	jalr	624(ra) # 41e <memmove>
        p[DIRSIZ] = 0;
 1b6:	000907a3          	sb	zero,15(s2)
        if(stat(buf, &st) < 0){
 1ba:	d8840593          	addi	a1,s0,-632
 1be:	db040513          	addi	a0,s0,-592
 1c2:	00000097          	auipc	ra,0x0
 1c6:	1cc080e7          	jalr	460(ra) # 38e <stat>
 1ca:	f8054ae3          	bltz	a0,15e <find+0x15e>
        if (strcmp(file, de.name) == 0) {
 1ce:	da240593          	addi	a1,s0,-606
 1d2:	854e                	mv	a0,s3
 1d4:	00000097          	auipc	ra,0x0
 1d8:	0a6080e7          	jalr	166(ra) # 27a <strcmp>
 1dc:	f15d                	bnez	a0,182 <find+0x182>
 1de:	bf59                	j	174 <find+0x174>
        if (st.type == T_DIR && strcmp(".", de.name) != 0 && strcmp("..", de.name) != 0) {
 1e0:	da240593          	addi	a1,s0,-606
 1e4:	855e                	mv	a0,s7
 1e6:	00000097          	auipc	ra,0x0
 1ea:	094080e7          	jalr	148(ra) # 27a <strcmp>
 1ee:	dd51                	beqz	a0,18a <find+0x18a>
 1f0:	da240593          	addi	a1,s0,-606
 1f4:	8562                	mv	a0,s8
 1f6:	00000097          	auipc	ra,0x0
 1fa:	084080e7          	jalr	132(ra) # 27a <strcmp>
 1fe:	d551                	beqz	a0,18a <find+0x18a>
            find(buf, file);
 200:	85ce                	mv	a1,s3
 202:	db040513          	addi	a0,s0,-592
 206:	00000097          	auipc	ra,0x0
 20a:	dfa080e7          	jalr	-518(ra) # 0 <find>
 20e:	bfb5                	j	18a <find+0x18a>
    close(fd);
 210:	8526                	mv	a0,s1
 212:	00000097          	auipc	ra,0x0
 216:	2ea080e7          	jalr	746(ra) # 4fc <close>
 21a:	b585                	j	7a <find+0x7a>

000000000000021c <main>:

int
main(int argc, char *argv[])
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e406                	sd	ra,8(sp)
 220:	e022                	sd	s0,0(sp)
 222:	0800                	addi	s0,sp,16
    if(argc != 3){
 224:	470d                	li	a4,3
 226:	02e50063          	beq	a0,a4,246 <main+0x2a>
        fprintf(2, "Usage: find files...\n");
 22a:	00001597          	auipc	a1,0x1
 22e:	86e58593          	addi	a1,a1,-1938 # a98 <malloc+0x18e>
 232:	4509                	li	a0,2
 234:	00000097          	auipc	ra,0x0
 238:	5ea080e7          	jalr	1514(ra) # 81e <fprintf>
        exit(1);
 23c:	4505                	li	a0,1
 23e:	00000097          	auipc	ra,0x0
 242:	296080e7          	jalr	662(ra) # 4d4 <exit>
 246:	87ae                	mv	a5,a1
    }

    find(argv[1], argv[2]);
 248:	698c                	ld	a1,16(a1)
 24a:	6788                	ld	a0,8(a5)
 24c:	00000097          	auipc	ra,0x0
 250:	db4080e7          	jalr	-588(ra) # 0 <find>
    exit(0);
 254:	4501                	li	a0,0
 256:	00000097          	auipc	ra,0x0
 25a:	27e080e7          	jalr	638(ra) # 4d4 <exit>

000000000000025e <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 264:	87aa                	mv	a5,a0
 266:	0585                	addi	a1,a1,1
 268:	0785                	addi	a5,a5,1
 26a:	fff5c703          	lbu	a4,-1(a1)
 26e:	fee78fa3          	sb	a4,-1(a5)
 272:	fb75                	bnez	a4,266 <strcpy+0x8>
    ;
  return os;
}
 274:	6422                	ld	s0,8(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret

000000000000027a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 280:	00054783          	lbu	a5,0(a0)
 284:	cb91                	beqz	a5,298 <strcmp+0x1e>
 286:	0005c703          	lbu	a4,0(a1)
 28a:	00f71763          	bne	a4,a5,298 <strcmp+0x1e>
    p++, q++;
 28e:	0505                	addi	a0,a0,1
 290:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 292:	00054783          	lbu	a5,0(a0)
 296:	fbe5                	bnez	a5,286 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 298:	0005c503          	lbu	a0,0(a1)
}
 29c:	40a7853b          	subw	a0,a5,a0
 2a0:	6422                	ld	s0,8(sp)
 2a2:	0141                	addi	sp,sp,16
 2a4:	8082                	ret

00000000000002a6 <strlen>:

uint
strlen(const char *s)
{
 2a6:	1141                	addi	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2ac:	00054783          	lbu	a5,0(a0)
 2b0:	cf91                	beqz	a5,2cc <strlen+0x26>
 2b2:	0505                	addi	a0,a0,1
 2b4:	87aa                	mv	a5,a0
 2b6:	4685                	li	a3,1
 2b8:	9e89                	subw	a3,a3,a0
 2ba:	00f6853b          	addw	a0,a3,a5
 2be:	0785                	addi	a5,a5,1
 2c0:	fff7c703          	lbu	a4,-1(a5)
 2c4:	fb7d                	bnez	a4,2ba <strlen+0x14>
    ;
  return n;
}
 2c6:	6422                	ld	s0,8(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
  for(n = 0; s[n]; n++)
 2cc:	4501                	li	a0,0
 2ce:	bfe5                	j	2c6 <strlen+0x20>

00000000000002d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e422                	sd	s0,8(sp)
 2d4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2d6:	ce09                	beqz	a2,2f0 <memset+0x20>
 2d8:	87aa                	mv	a5,a0
 2da:	fff6071b          	addiw	a4,a2,-1
 2de:	1702                	slli	a4,a4,0x20
 2e0:	9301                	srli	a4,a4,0x20
 2e2:	0705                	addi	a4,a4,1
 2e4:	972a                	add	a4,a4,a0
    cdst[i] = c;
 2e6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2ea:	0785                	addi	a5,a5,1
 2ec:	fee79de3          	bne	a5,a4,2e6 <memset+0x16>
  }
  return dst;
}
 2f0:	6422                	ld	s0,8(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <strchr>:

char*
strchr(const char *s, char c)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2fc:	00054783          	lbu	a5,0(a0)
 300:	cb99                	beqz	a5,316 <strchr+0x20>
    if(*s == c)
 302:	00f58763          	beq	a1,a5,310 <strchr+0x1a>
  for(; *s; s++)
 306:	0505                	addi	a0,a0,1
 308:	00054783          	lbu	a5,0(a0)
 30c:	fbfd                	bnez	a5,302 <strchr+0xc>
      return (char*)s;
  return 0;
 30e:	4501                	li	a0,0
}
 310:	6422                	ld	s0,8(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret
  return 0;
 316:	4501                	li	a0,0
 318:	bfe5                	j	310 <strchr+0x1a>

000000000000031a <gets>:

char*
gets(char *buf, int max)
{
 31a:	711d                	addi	sp,sp,-96
 31c:	ec86                	sd	ra,88(sp)
 31e:	e8a2                	sd	s0,80(sp)
 320:	e4a6                	sd	s1,72(sp)
 322:	e0ca                	sd	s2,64(sp)
 324:	fc4e                	sd	s3,56(sp)
 326:	f852                	sd	s4,48(sp)
 328:	f456                	sd	s5,40(sp)
 32a:	f05a                	sd	s6,32(sp)
 32c:	ec5e                	sd	s7,24(sp)
 32e:	1080                	addi	s0,sp,96
 330:	8baa                	mv	s7,a0
 332:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 334:	892a                	mv	s2,a0
 336:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 338:	4aa9                	li	s5,10
 33a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 33c:	89a6                	mv	s3,s1
 33e:	2485                	addiw	s1,s1,1
 340:	0344d863          	bge	s1,s4,370 <gets+0x56>
    cc = read(0, &c, 1);
 344:	4605                	li	a2,1
 346:	faf40593          	addi	a1,s0,-81
 34a:	4501                	li	a0,0
 34c:	00000097          	auipc	ra,0x0
 350:	1a0080e7          	jalr	416(ra) # 4ec <read>
    if(cc < 1)
 354:	00a05e63          	blez	a0,370 <gets+0x56>
    buf[i++] = c;
 358:	faf44783          	lbu	a5,-81(s0)
 35c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 360:	01578763          	beq	a5,s5,36e <gets+0x54>
 364:	0905                	addi	s2,s2,1
 366:	fd679be3          	bne	a5,s6,33c <gets+0x22>
  for(i=0; i+1 < max; ){
 36a:	89a6                	mv	s3,s1
 36c:	a011                	j	370 <gets+0x56>
 36e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 370:	99de                	add	s3,s3,s7
 372:	00098023          	sb	zero,0(s3)
  return buf;
}
 376:	855e                	mv	a0,s7
 378:	60e6                	ld	ra,88(sp)
 37a:	6446                	ld	s0,80(sp)
 37c:	64a6                	ld	s1,72(sp)
 37e:	6906                	ld	s2,64(sp)
 380:	79e2                	ld	s3,56(sp)
 382:	7a42                	ld	s4,48(sp)
 384:	7aa2                	ld	s5,40(sp)
 386:	7b02                	ld	s6,32(sp)
 388:	6be2                	ld	s7,24(sp)
 38a:	6125                	addi	sp,sp,96
 38c:	8082                	ret

000000000000038e <stat>:

int
stat(const char *n, struct stat *st)
{
 38e:	1101                	addi	sp,sp,-32
 390:	ec06                	sd	ra,24(sp)
 392:	e822                	sd	s0,16(sp)
 394:	e426                	sd	s1,8(sp)
 396:	e04a                	sd	s2,0(sp)
 398:	1000                	addi	s0,sp,32
 39a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 39c:	4581                	li	a1,0
 39e:	00000097          	auipc	ra,0x0
 3a2:	176080e7          	jalr	374(ra) # 514 <open>
  if(fd < 0)
 3a6:	02054563          	bltz	a0,3d0 <stat+0x42>
 3aa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3ac:	85ca                	mv	a1,s2
 3ae:	00000097          	auipc	ra,0x0
 3b2:	17e080e7          	jalr	382(ra) # 52c <fstat>
 3b6:	892a                	mv	s2,a0
  close(fd);
 3b8:	8526                	mv	a0,s1
 3ba:	00000097          	auipc	ra,0x0
 3be:	142080e7          	jalr	322(ra) # 4fc <close>
  return r;
}
 3c2:	854a                	mv	a0,s2
 3c4:	60e2                	ld	ra,24(sp)
 3c6:	6442                	ld	s0,16(sp)
 3c8:	64a2                	ld	s1,8(sp)
 3ca:	6902                	ld	s2,0(sp)
 3cc:	6105                	addi	sp,sp,32
 3ce:	8082                	ret
    return -1;
 3d0:	597d                	li	s2,-1
 3d2:	bfc5                	j	3c2 <stat+0x34>

00000000000003d4 <atoi>:

int
atoi(const char *s)
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3da:	00054603          	lbu	a2,0(a0)
 3de:	fd06079b          	addiw	a5,a2,-48
 3e2:	0ff7f793          	andi	a5,a5,255
 3e6:	4725                	li	a4,9
 3e8:	02f76963          	bltu	a4,a5,41a <atoi+0x46>
 3ec:	86aa                	mv	a3,a0
  n = 0;
 3ee:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 3f0:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 3f2:	0685                	addi	a3,a3,1
 3f4:	0025179b          	slliw	a5,a0,0x2
 3f8:	9fa9                	addw	a5,a5,a0
 3fa:	0017979b          	slliw	a5,a5,0x1
 3fe:	9fb1                	addw	a5,a5,a2
 400:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 404:	0006c603          	lbu	a2,0(a3)
 408:	fd06071b          	addiw	a4,a2,-48
 40c:	0ff77713          	andi	a4,a4,255
 410:	fee5f1e3          	bgeu	a1,a4,3f2 <atoi+0x1e>
  return n;
}
 414:	6422                	ld	s0,8(sp)
 416:	0141                	addi	sp,sp,16
 418:	8082                	ret
  n = 0;
 41a:	4501                	li	a0,0
 41c:	bfe5                	j	414 <atoi+0x40>

000000000000041e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e422                	sd	s0,8(sp)
 422:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 424:	02b57663          	bgeu	a0,a1,450 <memmove+0x32>
    while(n-- > 0)
 428:	02c05163          	blez	a2,44a <memmove+0x2c>
 42c:	fff6079b          	addiw	a5,a2,-1
 430:	1782                	slli	a5,a5,0x20
 432:	9381                	srli	a5,a5,0x20
 434:	0785                	addi	a5,a5,1
 436:	97aa                	add	a5,a5,a0
  dst = vdst;
 438:	872a                	mv	a4,a0
      *dst++ = *src++;
 43a:	0585                	addi	a1,a1,1
 43c:	0705                	addi	a4,a4,1
 43e:	fff5c683          	lbu	a3,-1(a1)
 442:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 446:	fee79ae3          	bne	a5,a4,43a <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44a:	6422                	ld	s0,8(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret
    dst += n;
 450:	00c50733          	add	a4,a0,a2
    src += n;
 454:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 456:	fec05ae3          	blez	a2,44a <memmove+0x2c>
 45a:	fff6079b          	addiw	a5,a2,-1
 45e:	1782                	slli	a5,a5,0x20
 460:	9381                	srli	a5,a5,0x20
 462:	fff7c793          	not	a5,a5
 466:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 468:	15fd                	addi	a1,a1,-1
 46a:	177d                	addi	a4,a4,-1
 46c:	0005c683          	lbu	a3,0(a1)
 470:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 474:	fee79ae3          	bne	a5,a4,468 <memmove+0x4a>
 478:	bfc9                	j	44a <memmove+0x2c>

000000000000047a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e422                	sd	s0,8(sp)
 47e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 480:	ca05                	beqz	a2,4b0 <memcmp+0x36>
 482:	fff6069b          	addiw	a3,a2,-1
 486:	1682                	slli	a3,a3,0x20
 488:	9281                	srli	a3,a3,0x20
 48a:	0685                	addi	a3,a3,1
 48c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 48e:	00054783          	lbu	a5,0(a0)
 492:	0005c703          	lbu	a4,0(a1)
 496:	00e79863          	bne	a5,a4,4a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49a:	0505                	addi	a0,a0,1
    p2++;
 49c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 49e:	fed518e3          	bne	a0,a3,48e <memcmp+0x14>
  }
  return 0;
 4a2:	4501                	li	a0,0
 4a4:	a019                	j	4aa <memcmp+0x30>
      return *p1 - *p2;
 4a6:	40e7853b          	subw	a0,a5,a4
}
 4aa:	6422                	ld	s0,8(sp)
 4ac:	0141                	addi	sp,sp,16
 4ae:	8082                	ret
  return 0;
 4b0:	4501                	li	a0,0
 4b2:	bfe5                	j	4aa <memcmp+0x30>

00000000000004b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b4:	1141                	addi	sp,sp,-16
 4b6:	e406                	sd	ra,8(sp)
 4b8:	e022                	sd	s0,0(sp)
 4ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4bc:	00000097          	auipc	ra,0x0
 4c0:	f62080e7          	jalr	-158(ra) # 41e <memmove>
}
 4c4:	60a2                	ld	ra,8(sp)
 4c6:	6402                	ld	s0,0(sp)
 4c8:	0141                	addi	sp,sp,16
 4ca:	8082                	ret

00000000000004cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4cc:	4885                	li	a7,1
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d4:	4889                	li	a7,2
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 4dc:	488d                	li	a7,3
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e4:	4891                	li	a7,4
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <read>:
.global read
read:
 li a7, SYS_read
 4ec:	4895                	li	a7,5
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <write>:
.global write
write:
 li a7, SYS_write
 4f4:	48c1                	li	a7,16
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <close>:
.global close
close:
 li a7, SYS_close
 4fc:	48d5                	li	a7,21
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <kill>:
.global kill
kill:
 li a7, SYS_kill
 504:	4899                	li	a7,6
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <exec>:
.global exec
exec:
 li a7, SYS_exec
 50c:	489d                	li	a7,7
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <open>:
.global open
open:
 li a7, SYS_open
 514:	48bd                	li	a7,15
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51c:	48c5                	li	a7,17
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 524:	48c9                	li	a7,18
 ecall
 526:	00000073          	ecall
 ret
 52a:	8082                	ret

000000000000052c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52c:	48a1                	li	a7,8
 ecall
 52e:	00000073          	ecall
 ret
 532:	8082                	ret

0000000000000534 <link>:
.global link
link:
 li a7, SYS_link
 534:	48cd                	li	a7,19
 ecall
 536:	00000073          	ecall
 ret
 53a:	8082                	ret

000000000000053c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53c:	48d1                	li	a7,20
 ecall
 53e:	00000073          	ecall
 ret
 542:	8082                	ret

0000000000000544 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 544:	48a5                	li	a7,9
 ecall
 546:	00000073          	ecall
 ret
 54a:	8082                	ret

000000000000054c <dup>:
.global dup
dup:
 li a7, SYS_dup
 54c:	48a9                	li	a7,10
 ecall
 54e:	00000073          	ecall
 ret
 552:	8082                	ret

0000000000000554 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 554:	48ad                	li	a7,11
 ecall
 556:	00000073          	ecall
 ret
 55a:	8082                	ret

000000000000055c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55c:	48b1                	li	a7,12
 ecall
 55e:	00000073          	ecall
 ret
 562:	8082                	ret

0000000000000564 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 564:	48b5                	li	a7,13
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56c:	48b9                	li	a7,14
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 574:	1101                	addi	sp,sp,-32
 576:	ec06                	sd	ra,24(sp)
 578:	e822                	sd	s0,16(sp)
 57a:	1000                	addi	s0,sp,32
 57c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 580:	4605                	li	a2,1
 582:	fef40593          	addi	a1,s0,-17
 586:	00000097          	auipc	ra,0x0
 58a:	f6e080e7          	jalr	-146(ra) # 4f4 <write>
}
 58e:	60e2                	ld	ra,24(sp)
 590:	6442                	ld	s0,16(sp)
 592:	6105                	addi	sp,sp,32
 594:	8082                	ret

0000000000000596 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 596:	7139                	addi	sp,sp,-64
 598:	fc06                	sd	ra,56(sp)
 59a:	f822                	sd	s0,48(sp)
 59c:	f426                	sd	s1,40(sp)
 59e:	f04a                	sd	s2,32(sp)
 5a0:	ec4e                	sd	s3,24(sp)
 5a2:	0080                	addi	s0,sp,64
 5a4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5a6:	c299                	beqz	a3,5ac <printint+0x16>
 5a8:	0805c863          	bltz	a1,638 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5ac:	2581                	sext.w	a1,a1
  neg = 0;
 5ae:	4881                	li	a7,0
 5b0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5b4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b6:	2601                	sext.w	a2,a2
 5b8:	00000517          	auipc	a0,0x0
 5bc:	50050513          	addi	a0,a0,1280 # ab8 <digits>
 5c0:	883a                	mv	a6,a4
 5c2:	2705                	addiw	a4,a4,1
 5c4:	02c5f7bb          	remuw	a5,a1,a2
 5c8:	1782                	slli	a5,a5,0x20
 5ca:	9381                	srli	a5,a5,0x20
 5cc:	97aa                	add	a5,a5,a0
 5ce:	0007c783          	lbu	a5,0(a5)
 5d2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d6:	0005879b          	sext.w	a5,a1
 5da:	02c5d5bb          	divuw	a1,a1,a2
 5de:	0685                	addi	a3,a3,1
 5e0:	fec7f0e3          	bgeu	a5,a2,5c0 <printint+0x2a>
  if(neg)
 5e4:	00088b63          	beqz	a7,5fa <printint+0x64>
    buf[i++] = '-';
 5e8:	fd040793          	addi	a5,s0,-48
 5ec:	973e                	add	a4,a4,a5
 5ee:	02d00793          	li	a5,45
 5f2:	fef70823          	sb	a5,-16(a4)
 5f6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5fa:	02e05863          	blez	a4,62a <printint+0x94>
 5fe:	fc040793          	addi	a5,s0,-64
 602:	00e78933          	add	s2,a5,a4
 606:	fff78993          	addi	s3,a5,-1
 60a:	99ba                	add	s3,s3,a4
 60c:	377d                	addiw	a4,a4,-1
 60e:	1702                	slli	a4,a4,0x20
 610:	9301                	srli	a4,a4,0x20
 612:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 616:	fff94583          	lbu	a1,-1(s2)
 61a:	8526                	mv	a0,s1
 61c:	00000097          	auipc	ra,0x0
 620:	f58080e7          	jalr	-168(ra) # 574 <putc>
  while(--i >= 0)
 624:	197d                	addi	s2,s2,-1
 626:	ff3918e3          	bne	s2,s3,616 <printint+0x80>
}
 62a:	70e2                	ld	ra,56(sp)
 62c:	7442                	ld	s0,48(sp)
 62e:	74a2                	ld	s1,40(sp)
 630:	7902                	ld	s2,32(sp)
 632:	69e2                	ld	s3,24(sp)
 634:	6121                	addi	sp,sp,64
 636:	8082                	ret
    x = -xx;
 638:	40b005bb          	negw	a1,a1
    neg = 1;
 63c:	4885                	li	a7,1
    x = -xx;
 63e:	bf8d                	j	5b0 <printint+0x1a>

0000000000000640 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 640:	7119                	addi	sp,sp,-128
 642:	fc86                	sd	ra,120(sp)
 644:	f8a2                	sd	s0,112(sp)
 646:	f4a6                	sd	s1,104(sp)
 648:	f0ca                	sd	s2,96(sp)
 64a:	ecce                	sd	s3,88(sp)
 64c:	e8d2                	sd	s4,80(sp)
 64e:	e4d6                	sd	s5,72(sp)
 650:	e0da                	sd	s6,64(sp)
 652:	fc5e                	sd	s7,56(sp)
 654:	f862                	sd	s8,48(sp)
 656:	f466                	sd	s9,40(sp)
 658:	f06a                	sd	s10,32(sp)
 65a:	ec6e                	sd	s11,24(sp)
 65c:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 65e:	0005c903          	lbu	s2,0(a1)
 662:	18090f63          	beqz	s2,800 <vprintf+0x1c0>
 666:	8aaa                	mv	s5,a0
 668:	8b32                	mv	s6,a2
 66a:	00158493          	addi	s1,a1,1
  state = 0;
 66e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 670:	02500a13          	li	s4,37
      if(c == 'd'){
 674:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 678:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 67c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 680:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 684:	00000b97          	auipc	s7,0x0
 688:	434b8b93          	addi	s7,s7,1076 # ab8 <digits>
 68c:	a839                	j	6aa <vprintf+0x6a>
        putc(fd, c);
 68e:	85ca                	mv	a1,s2
 690:	8556                	mv	a0,s5
 692:	00000097          	auipc	ra,0x0
 696:	ee2080e7          	jalr	-286(ra) # 574 <putc>
 69a:	a019                	j	6a0 <vprintf+0x60>
    } else if(state == '%'){
 69c:	01498f63          	beq	s3,s4,6ba <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 6a0:	0485                	addi	s1,s1,1
 6a2:	fff4c903          	lbu	s2,-1(s1)
 6a6:	14090d63          	beqz	s2,800 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 6aa:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ae:	fe0997e3          	bnez	s3,69c <vprintf+0x5c>
      if(c == '%'){
 6b2:	fd479ee3          	bne	a5,s4,68e <vprintf+0x4e>
        state = '%';
 6b6:	89be                	mv	s3,a5
 6b8:	b7e5                	j	6a0 <vprintf+0x60>
      if(c == 'd'){
 6ba:	05878063          	beq	a5,s8,6fa <vprintf+0xba>
      } else if(c == 'l') {
 6be:	05978c63          	beq	a5,s9,716 <vprintf+0xd6>
      } else if(c == 'x') {
 6c2:	07a78863          	beq	a5,s10,732 <vprintf+0xf2>
      } else if(c == 'p') {
 6c6:	09b78463          	beq	a5,s11,74e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 6ca:	07300713          	li	a4,115
 6ce:	0ce78663          	beq	a5,a4,79a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6d2:	06300713          	li	a4,99
 6d6:	0ee78e63          	beq	a5,a4,7d2 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 6da:	11478863          	beq	a5,s4,7ea <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6de:	85d2                	mv	a1,s4
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e92080e7          	jalr	-366(ra) # 574 <putc>
        putc(fd, c);
 6ea:	85ca                	mv	a1,s2
 6ec:	8556                	mv	a0,s5
 6ee:	00000097          	auipc	ra,0x0
 6f2:	e86080e7          	jalr	-378(ra) # 574 <putc>
      }
      state = 0;
 6f6:	4981                	li	s3,0
 6f8:	b765                	j	6a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 6fa:	008b0913          	addi	s2,s6,8
 6fe:	4685                	li	a3,1
 700:	4629                	li	a2,10
 702:	000b2583          	lw	a1,0(s6)
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	e8e080e7          	jalr	-370(ra) # 596 <printint>
 710:	8b4a                	mv	s6,s2
      state = 0;
 712:	4981                	li	s3,0
 714:	b771                	j	6a0 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 716:	008b0913          	addi	s2,s6,8
 71a:	4681                	li	a3,0
 71c:	4629                	li	a2,10
 71e:	000b2583          	lw	a1,0(s6)
 722:	8556                	mv	a0,s5
 724:	00000097          	auipc	ra,0x0
 728:	e72080e7          	jalr	-398(ra) # 596 <printint>
 72c:	8b4a                	mv	s6,s2
      state = 0;
 72e:	4981                	li	s3,0
 730:	bf85                	j	6a0 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 732:	008b0913          	addi	s2,s6,8
 736:	4681                	li	a3,0
 738:	4641                	li	a2,16
 73a:	000b2583          	lw	a1,0(s6)
 73e:	8556                	mv	a0,s5
 740:	00000097          	auipc	ra,0x0
 744:	e56080e7          	jalr	-426(ra) # 596 <printint>
 748:	8b4a                	mv	s6,s2
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bf91                	j	6a0 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 74e:	008b0793          	addi	a5,s6,8
 752:	f8f43423          	sd	a5,-120(s0)
 756:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 75a:	03000593          	li	a1,48
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	e14080e7          	jalr	-492(ra) # 574 <putc>
  putc(fd, 'x');
 768:	85ea                	mv	a1,s10
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	e08080e7          	jalr	-504(ra) # 574 <putc>
 774:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 776:	03c9d793          	srli	a5,s3,0x3c
 77a:	97de                	add	a5,a5,s7
 77c:	0007c583          	lbu	a1,0(a5)
 780:	8556                	mv	a0,s5
 782:	00000097          	auipc	ra,0x0
 786:	df2080e7          	jalr	-526(ra) # 574 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 78a:	0992                	slli	s3,s3,0x4
 78c:	397d                	addiw	s2,s2,-1
 78e:	fe0914e3          	bnez	s2,776 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 792:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 796:	4981                	li	s3,0
 798:	b721                	j	6a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 79a:	008b0993          	addi	s3,s6,8
 79e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 7a2:	02090163          	beqz	s2,7c4 <vprintf+0x184>
        while(*s != 0){
 7a6:	00094583          	lbu	a1,0(s2)
 7aa:	c9a1                	beqz	a1,7fa <vprintf+0x1ba>
          putc(fd, *s);
 7ac:	8556                	mv	a0,s5
 7ae:	00000097          	auipc	ra,0x0
 7b2:	dc6080e7          	jalr	-570(ra) # 574 <putc>
          s++;
 7b6:	0905                	addi	s2,s2,1
        while(*s != 0){
 7b8:	00094583          	lbu	a1,0(s2)
 7bc:	f9e5                	bnez	a1,7ac <vprintf+0x16c>
        s = va_arg(ap, char*);
 7be:	8b4e                	mv	s6,s3
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	bdf9                	j	6a0 <vprintf+0x60>
          s = "(null)";
 7c4:	00000917          	auipc	s2,0x0
 7c8:	2ec90913          	addi	s2,s2,748 # ab0 <malloc+0x1a6>
        while(*s != 0){
 7cc:	02800593          	li	a1,40
 7d0:	bff1                	j	7ac <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 7d2:	008b0913          	addi	s2,s6,8
 7d6:	000b4583          	lbu	a1,0(s6)
 7da:	8556                	mv	a0,s5
 7dc:	00000097          	auipc	ra,0x0
 7e0:	d98080e7          	jalr	-616(ra) # 574 <putc>
 7e4:	8b4a                	mv	s6,s2
      state = 0;
 7e6:	4981                	li	s3,0
 7e8:	bd65                	j	6a0 <vprintf+0x60>
        putc(fd, c);
 7ea:	85d2                	mv	a1,s4
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	d86080e7          	jalr	-634(ra) # 574 <putc>
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	b565                	j	6a0 <vprintf+0x60>
        s = va_arg(ap, char*);
 7fa:	8b4e                	mv	s6,s3
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	b54d                	j	6a0 <vprintf+0x60>
    }
  }
}
 800:	70e6                	ld	ra,120(sp)
 802:	7446                	ld	s0,112(sp)
 804:	74a6                	ld	s1,104(sp)
 806:	7906                	ld	s2,96(sp)
 808:	69e6                	ld	s3,88(sp)
 80a:	6a46                	ld	s4,80(sp)
 80c:	6aa6                	ld	s5,72(sp)
 80e:	6b06                	ld	s6,64(sp)
 810:	7be2                	ld	s7,56(sp)
 812:	7c42                	ld	s8,48(sp)
 814:	7ca2                	ld	s9,40(sp)
 816:	7d02                	ld	s10,32(sp)
 818:	6de2                	ld	s11,24(sp)
 81a:	6109                	addi	sp,sp,128
 81c:	8082                	ret

000000000000081e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81e:	715d                	addi	sp,sp,-80
 820:	ec06                	sd	ra,24(sp)
 822:	e822                	sd	s0,16(sp)
 824:	1000                	addi	s0,sp,32
 826:	e010                	sd	a2,0(s0)
 828:	e414                	sd	a3,8(s0)
 82a:	e818                	sd	a4,16(s0)
 82c:	ec1c                	sd	a5,24(s0)
 82e:	03043023          	sd	a6,32(s0)
 832:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83a:	8622                	mv	a2,s0
 83c:	00000097          	auipc	ra,0x0
 840:	e04080e7          	jalr	-508(ra) # 640 <vprintf>
}
 844:	60e2                	ld	ra,24(sp)
 846:	6442                	ld	s0,16(sp)
 848:	6161                	addi	sp,sp,80
 84a:	8082                	ret

000000000000084c <printf>:

void
printf(const char *fmt, ...)
{
 84c:	711d                	addi	sp,sp,-96
 84e:	ec06                	sd	ra,24(sp)
 850:	e822                	sd	s0,16(sp)
 852:	1000                	addi	s0,sp,32
 854:	e40c                	sd	a1,8(s0)
 856:	e810                	sd	a2,16(s0)
 858:	ec14                	sd	a3,24(s0)
 85a:	f018                	sd	a4,32(s0)
 85c:	f41c                	sd	a5,40(s0)
 85e:	03043823          	sd	a6,48(s0)
 862:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 866:	00840613          	addi	a2,s0,8
 86a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 86e:	85aa                	mv	a1,a0
 870:	4505                	li	a0,1
 872:	00000097          	auipc	ra,0x0
 876:	dce080e7          	jalr	-562(ra) # 640 <vprintf>
}
 87a:	60e2                	ld	ra,24(sp)
 87c:	6442                	ld	s0,16(sp)
 87e:	6125                	addi	sp,sp,96
 880:	8082                	ret

0000000000000882 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 882:	1141                	addi	sp,sp,-16
 884:	e422                	sd	s0,8(sp)
 886:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 888:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88c:	00000797          	auipc	a5,0x0
 890:	2447b783          	ld	a5,580(a5) # ad0 <freep>
 894:	a805                	j	8c4 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 896:	4618                	lw	a4,8(a2)
 898:	9db9                	addw	a1,a1,a4
 89a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89e:	6398                	ld	a4,0(a5)
 8a0:	6318                	ld	a4,0(a4)
 8a2:	fee53823          	sd	a4,-16(a0)
 8a6:	a091                	j	8ea <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8a8:	ff852703          	lw	a4,-8(a0)
 8ac:	9e39                	addw	a2,a2,a4
 8ae:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 8b0:	ff053703          	ld	a4,-16(a0)
 8b4:	e398                	sd	a4,0(a5)
 8b6:	a099                	j	8fc <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8b8:	6398                	ld	a4,0(a5)
 8ba:	00e7e463          	bltu	a5,a4,8c2 <free+0x40>
 8be:	00e6ea63          	bltu	a3,a4,8d2 <free+0x50>
{
 8c2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8c4:	fed7fae3          	bgeu	a5,a3,8b8 <free+0x36>
 8c8:	6398                	ld	a4,0(a5)
 8ca:	00e6e463          	bltu	a3,a4,8d2 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ce:	fee7eae3          	bltu	a5,a4,8c2 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 8d2:	ff852583          	lw	a1,-8(a0)
 8d6:	6390                	ld	a2,0(a5)
 8d8:	02059713          	slli	a4,a1,0x20
 8dc:	9301                	srli	a4,a4,0x20
 8de:	0712                	slli	a4,a4,0x4
 8e0:	9736                	add	a4,a4,a3
 8e2:	fae60ae3          	beq	a2,a4,896 <free+0x14>
    bp->s.ptr = p->s.ptr;
 8e6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 8ea:	4790                	lw	a2,8(a5)
 8ec:	02061713          	slli	a4,a2,0x20
 8f0:	9301                	srli	a4,a4,0x20
 8f2:	0712                	slli	a4,a4,0x4
 8f4:	973e                	add	a4,a4,a5
 8f6:	fae689e3          	beq	a3,a4,8a8 <free+0x26>
  } else
    p->s.ptr = bp;
 8fa:	e394                	sd	a3,0(a5)
  freep = p;
 8fc:	00000717          	auipc	a4,0x0
 900:	1cf73a23          	sd	a5,468(a4) # ad0 <freep>
}
 904:	6422                	ld	s0,8(sp)
 906:	0141                	addi	sp,sp,16
 908:	8082                	ret

000000000000090a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 90a:	7139                	addi	sp,sp,-64
 90c:	fc06                	sd	ra,56(sp)
 90e:	f822                	sd	s0,48(sp)
 910:	f426                	sd	s1,40(sp)
 912:	f04a                	sd	s2,32(sp)
 914:	ec4e                	sd	s3,24(sp)
 916:	e852                	sd	s4,16(sp)
 918:	e456                	sd	s5,8(sp)
 91a:	e05a                	sd	s6,0(sp)
 91c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 91e:	02051493          	slli	s1,a0,0x20
 922:	9081                	srli	s1,s1,0x20
 924:	04bd                	addi	s1,s1,15
 926:	8091                	srli	s1,s1,0x4
 928:	0014899b          	addiw	s3,s1,1
 92c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 92e:	00000517          	auipc	a0,0x0
 932:	1a253503          	ld	a0,418(a0) # ad0 <freep>
 936:	c515                	beqz	a0,962 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93a:	4798                	lw	a4,8(a5)
 93c:	02977f63          	bgeu	a4,s1,97a <malloc+0x70>
 940:	8a4e                	mv	s4,s3
 942:	0009871b          	sext.w	a4,s3
 946:	6685                	lui	a3,0x1
 948:	00d77363          	bgeu	a4,a3,94e <malloc+0x44>
 94c:	6a05                	lui	s4,0x1
 94e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 952:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 956:	00000917          	auipc	s2,0x0
 95a:	17a90913          	addi	s2,s2,378 # ad0 <freep>
  if(p == (char*)-1)
 95e:	5afd                	li	s5,-1
 960:	a88d                	j	9d2 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 962:	00000797          	auipc	a5,0x0
 966:	17678793          	addi	a5,a5,374 # ad8 <base>
 96a:	00000717          	auipc	a4,0x0
 96e:	16f73323          	sd	a5,358(a4) # ad0 <freep>
 972:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 974:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 978:	b7e1                	j	940 <malloc+0x36>
      if(p->s.size == nunits)
 97a:	02e48b63          	beq	s1,a4,9b0 <malloc+0xa6>
        p->s.size -= nunits;
 97e:	4137073b          	subw	a4,a4,s3
 982:	c798                	sw	a4,8(a5)
        p += p->s.size;
 984:	1702                	slli	a4,a4,0x20
 986:	9301                	srli	a4,a4,0x20
 988:	0712                	slli	a4,a4,0x4
 98a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 990:	00000717          	auipc	a4,0x0
 994:	14a73023          	sd	a0,320(a4) # ad0 <freep>
      return (void*)(p + 1);
 998:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 99c:	70e2                	ld	ra,56(sp)
 99e:	7442                	ld	s0,48(sp)
 9a0:	74a2                	ld	s1,40(sp)
 9a2:	7902                	ld	s2,32(sp)
 9a4:	69e2                	ld	s3,24(sp)
 9a6:	6a42                	ld	s4,16(sp)
 9a8:	6aa2                	ld	s5,8(sp)
 9aa:	6b02                	ld	s6,0(sp)
 9ac:	6121                	addi	sp,sp,64
 9ae:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 9b0:	6398                	ld	a4,0(a5)
 9b2:	e118                	sd	a4,0(a0)
 9b4:	bff1                	j	990 <malloc+0x86>
  hp->s.size = nu;
 9b6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ba:	0541                	addi	a0,a0,16
 9bc:	00000097          	auipc	ra,0x0
 9c0:	ec6080e7          	jalr	-314(ra) # 882 <free>
  return freep;
 9c4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9c8:	d971                	beqz	a0,99c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9cc:	4798                	lw	a4,8(a5)
 9ce:	fa9776e3          	bgeu	a4,s1,97a <malloc+0x70>
    if(p == freep)
 9d2:	00093703          	ld	a4,0(s2)
 9d6:	853e                	mv	a0,a5
 9d8:	fef719e3          	bne	a4,a5,9ca <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 9dc:	8552                	mv	a0,s4
 9de:	00000097          	auipc	ra,0x0
 9e2:	b7e080e7          	jalr	-1154(ra) # 55c <sbrk>
  if(p == (char*)-1)
 9e6:	fd5518e3          	bne	a0,s5,9b6 <malloc+0xac>
        return 0;
 9ea:	4501                	li	a0,0
 9ec:	bf45                	j	99c <malloc+0x92>
