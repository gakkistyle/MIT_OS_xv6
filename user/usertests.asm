
user/_usertests：     文件格式 elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	slli	a0,a0,0x1f
      10:	00005097          	auipc	ra,0x5
      14:	3a4080e7          	jalr	932(ra) # 53b4 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00005097          	auipc	ra,0x5
      26:	392080e7          	jalr	914(ra) # 53b4 <open>
    uint64 addr = addrs[ai];
      2a:	55fd                	li	a1,-1
    if(fd >= 0){
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	addi	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	slli	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	b5250513          	addi	a0,a0,-1198 # 5b90 <malloc+0x3e6>
      46:	00005097          	auipc	ra,0x5
      4a:	6a6080e7          	jalr	1702(ra) # 56ec <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00005097          	auipc	ra,0x5
      54:	324080e7          	jalr	804(ra) # 5374 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	00009797          	auipc	a5,0x9
      5c:	fc878793          	addi	a5,a5,-56 # 9020 <uninit>
      60:	0000b697          	auipc	a3,0xb
      64:	6d068693          	addi	a3,a3,1744 # b730 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	addi	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	addi	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	b3050513          	addi	a0,a0,-1232 # 5bb0 <malloc+0x406>
      88:	00005097          	auipc	ra,0x5
      8c:	664080e7          	jalr	1636(ra) # 56ec <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00005097          	auipc	ra,0x5
      96:	2e2080e7          	jalr	738(ra) # 5374 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	addi	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	addi	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	b2050513          	addi	a0,a0,-1248 # 5bc8 <malloc+0x41e>
      b0:	00005097          	auipc	ra,0x5
      b4:	304080e7          	jalr	772(ra) # 53b4 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00005097          	auipc	ra,0x5
      c0:	2e0080e7          	jalr	736(ra) # 539c <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	b2250513          	addi	a0,a0,-1246 # 5be8 <malloc+0x43e>
      ce:	00005097          	auipc	ra,0x5
      d2:	2e6080e7          	jalr	742(ra) # 53b4 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	addi	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	aea50513          	addi	a0,a0,-1302 # 5bd0 <malloc+0x426>
      ee:	00005097          	auipc	ra,0x5
      f2:	5fe080e7          	jalr	1534(ra) # 56ec <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00005097          	auipc	ra,0x5
      fc:	27c080e7          	jalr	636(ra) # 5374 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	af650513          	addi	a0,a0,-1290 # 5bf8 <malloc+0x44e>
     10a:	00005097          	auipc	ra,0x5
     10e:	5e2080e7          	jalr	1506(ra) # 56ec <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00005097          	auipc	ra,0x5
     118:	260080e7          	jalr	608(ra) # 5374 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	addi	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	addi	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	af450513          	addi	a0,a0,-1292 # 5c20 <malloc+0x476>
     134:	00005097          	auipc	ra,0x5
     138:	290080e7          	jalr	656(ra) # 53c4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	ae050513          	addi	a0,a0,-1312 # 5c20 <malloc+0x476>
     148:	00005097          	auipc	ra,0x5
     14c:	26c080e7          	jalr	620(ra) # 53b4 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	adc58593          	addi	a1,a1,-1316 # 5c30 <malloc+0x486>
     15c:	00005097          	auipc	ra,0x5
     160:	238080e7          	jalr	568(ra) # 5394 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	ab850513          	addi	a0,a0,-1352 # 5c20 <malloc+0x476>
     170:	00005097          	auipc	ra,0x5
     174:	244080e7          	jalr	580(ra) # 53b4 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	abc58593          	addi	a1,a1,-1348 # 5c38 <malloc+0x48e>
     184:	8526                	mv	a0,s1
     186:	00005097          	auipc	ra,0x5
     18a:	20e080e7          	jalr	526(ra) # 5394 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	a8c50513          	addi	a0,a0,-1396 # 5c20 <malloc+0x476>
     19c:	00005097          	auipc	ra,0x5
     1a0:	228080e7          	jalr	552(ra) # 53c4 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00005097          	auipc	ra,0x5
     1aa:	1f6080e7          	jalr	502(ra) # 539c <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00005097          	auipc	ra,0x5
     1b4:	1ec080e7          	jalr	492(ra) # 539c <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	addi	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	a7650513          	addi	a0,a0,-1418 # 5c40 <malloc+0x496>
     1d2:	00005097          	auipc	ra,0x5
     1d6:	51a080e7          	jalr	1306(ra) # 56ec <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00005097          	auipc	ra,0x5
     1e0:	198080e7          	jalr	408(ra) # 5374 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	addi	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	e44e                	sd	s3,8(sp)
     1f0:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1f2:	00008797          	auipc	a5,0x8
     1f6:	d1678793          	addi	a5,a5,-746 # 7f08 <name>
     1fa:	06100713          	li	a4,97
     1fe:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     202:	00078123          	sb	zero,2(a5)
     206:	03000493          	li	s1,48
    name[1] = '0' + i;
     20a:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     20c:	06400993          	li	s3,100
    name[1] = '0' + i;
     210:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     214:	20200593          	li	a1,514
     218:	854a                	mv	a0,s2
     21a:	00005097          	auipc	ra,0x5
     21e:	19a080e7          	jalr	410(ra) # 53b4 <open>
    close(fd);
     222:	00005097          	auipc	ra,0x5
     226:	17a080e7          	jalr	378(ra) # 539c <close>
  for(i = 0; i < N; i++){
     22a:	2485                	addiw	s1,s1,1
     22c:	0ff4f493          	andi	s1,s1,255
     230:	ff3490e3          	bne	s1,s3,210 <createtest+0x2c>
  name[0] = 'a';
     234:	00008797          	auipc	a5,0x8
     238:	cd478793          	addi	a5,a5,-812 # 7f08 <name>
     23c:	06100713          	li	a4,97
     240:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     244:	00078123          	sb	zero,2(a5)
     248:	03000493          	li	s1,48
    name[1] = '0' + i;
     24c:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     24e:	06400993          	li	s3,100
    name[1] = '0' + i;
     252:	009900a3          	sb	s1,1(s2)
    unlink(name);
     256:	854a                	mv	a0,s2
     258:	00005097          	auipc	ra,0x5
     25c:	16c080e7          	jalr	364(ra) # 53c4 <unlink>
  for(i = 0; i < N; i++){
     260:	2485                	addiw	s1,s1,1
     262:	0ff4f493          	andi	s1,s1,255
     266:	ff3496e3          	bne	s1,s3,252 <createtest+0x6e>
}
     26a:	70a2                	ld	ra,40(sp)
     26c:	7402                	ld	s0,32(sp)
     26e:	64e2                	ld	s1,24(sp)
     270:	6942                	ld	s2,16(sp)
     272:	69a2                	ld	s3,8(sp)
     274:	6145                	addi	sp,sp,48
     276:	8082                	ret

0000000000000278 <bigwrite>:
{
     278:	715d                	addi	sp,sp,-80
     27a:	e486                	sd	ra,72(sp)
     27c:	e0a2                	sd	s0,64(sp)
     27e:	fc26                	sd	s1,56(sp)
     280:	f84a                	sd	s2,48(sp)
     282:	f44e                	sd	s3,40(sp)
     284:	f052                	sd	s4,32(sp)
     286:	ec56                	sd	s5,24(sp)
     288:	e85a                	sd	s6,16(sp)
     28a:	e45e                	sd	s7,8(sp)
     28c:	0880                	addi	s0,sp,80
     28e:	8baa                	mv	s7,a0
  unlink("bigwrite");
     290:	00005517          	auipc	a0,0x5
     294:	7b050513          	addi	a0,a0,1968 # 5a40 <malloc+0x296>
     298:	00005097          	auipc	ra,0x5
     29c:	12c080e7          	jalr	300(ra) # 53c4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a4:	00005a97          	auipc	s5,0x5
     2a8:	79ca8a93          	addi	s5,s5,1948 # 5a40 <malloc+0x296>
      int cc = write(fd, buf, sz);
     2ac:	0000ba17          	auipc	s4,0xb
     2b0:	484a0a13          	addi	s4,s4,1156 # b730 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b4:	6b0d                	lui	s6,0x3
     2b6:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x4ef>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2ba:	20200593          	li	a1,514
     2be:	8556                	mv	a0,s5
     2c0:	00005097          	auipc	ra,0x5
     2c4:	0f4080e7          	jalr	244(ra) # 53b4 <open>
     2c8:	892a                	mv	s2,a0
    if(fd < 0){
     2ca:	04054d63          	bltz	a0,324 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ce:	8626                	mv	a2,s1
     2d0:	85d2                	mv	a1,s4
     2d2:	00005097          	auipc	ra,0x5
     2d6:	0c2080e7          	jalr	194(ra) # 5394 <write>
     2da:	89aa                	mv	s3,a0
      if(cc != sz){
     2dc:	06a49463          	bne	s1,a0,344 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     2e0:	8626                	mv	a2,s1
     2e2:	85d2                	mv	a1,s4
     2e4:	854a                	mv	a0,s2
     2e6:	00005097          	auipc	ra,0x5
     2ea:	0ae080e7          	jalr	174(ra) # 5394 <write>
      if(cc != sz){
     2ee:	04951963          	bne	a0,s1,340 <bigwrite+0xc8>
    close(fd);
     2f2:	854a                	mv	a0,s2
     2f4:	00005097          	auipc	ra,0x5
     2f8:	0a8080e7          	jalr	168(ra) # 539c <close>
    unlink("bigwrite");
     2fc:	8556                	mv	a0,s5
     2fe:	00005097          	auipc	ra,0x5
     302:	0c6080e7          	jalr	198(ra) # 53c4 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     306:	1d74849b          	addiw	s1,s1,471
     30a:	fb6498e3          	bne	s1,s6,2ba <bigwrite+0x42>
}
     30e:	60a6                	ld	ra,72(sp)
     310:	6406                	ld	s0,64(sp)
     312:	74e2                	ld	s1,56(sp)
     314:	7942                	ld	s2,48(sp)
     316:	79a2                	ld	s3,40(sp)
     318:	7a02                	ld	s4,32(sp)
     31a:	6ae2                	ld	s5,24(sp)
     31c:	6b42                	ld	s6,16(sp)
     31e:	6ba2                	ld	s7,8(sp)
     320:	6161                	addi	sp,sp,80
     322:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     324:	85de                	mv	a1,s7
     326:	00006517          	auipc	a0,0x6
     32a:	94250513          	addi	a0,a0,-1726 # 5c68 <malloc+0x4be>
     32e:	00005097          	auipc	ra,0x5
     332:	3be080e7          	jalr	958(ra) # 56ec <printf>
      exit(1);
     336:	4505                	li	a0,1
     338:	00005097          	auipc	ra,0x5
     33c:	03c080e7          	jalr	60(ra) # 5374 <exit>
     340:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     342:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     344:	86ce                	mv	a3,s3
     346:	8626                	mv	a2,s1
     348:	85de                	mv	a1,s7
     34a:	00006517          	auipc	a0,0x6
     34e:	93e50513          	addi	a0,a0,-1730 # 5c88 <malloc+0x4de>
     352:	00005097          	auipc	ra,0x5
     356:	39a080e7          	jalr	922(ra) # 56ec <printf>
        exit(1);
     35a:	4505                	li	a0,1
     35c:	00005097          	auipc	ra,0x5
     360:	018080e7          	jalr	24(ra) # 5374 <exit>

0000000000000364 <copyin>:
{
     364:	715d                	addi	sp,sp,-80
     366:	e486                	sd	ra,72(sp)
     368:	e0a2                	sd	s0,64(sp)
     36a:	fc26                	sd	s1,56(sp)
     36c:	f84a                	sd	s2,48(sp)
     36e:	f44e                	sd	s3,40(sp)
     370:	f052                	sd	s4,32(sp)
     372:	0880                	addi	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     374:	4785                	li	a5,1
     376:	07fe                	slli	a5,a5,0x1f
     378:	fcf43023          	sd	a5,-64(s0)
     37c:	57fd                	li	a5,-1
     37e:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     382:	fc040913          	addi	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     386:	00006a17          	auipc	s4,0x6
     38a:	91aa0a13          	addi	s4,s4,-1766 # 5ca0 <malloc+0x4f6>
    uint64 addr = addrs[ai];
     38e:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     392:	20100593          	li	a1,513
     396:	8552                	mv	a0,s4
     398:	00005097          	auipc	ra,0x5
     39c:	01c080e7          	jalr	28(ra) # 53b4 <open>
     3a0:	84aa                	mv	s1,a0
    if(fd < 0){
     3a2:	08054863          	bltz	a0,432 <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     3a6:	6609                	lui	a2,0x2
     3a8:	85ce                	mv	a1,s3
     3aa:	00005097          	auipc	ra,0x5
     3ae:	fea080e7          	jalr	-22(ra) # 5394 <write>
    if(n >= 0){
     3b2:	08055d63          	bgez	a0,44c <copyin+0xe8>
    close(fd);
     3b6:	8526                	mv	a0,s1
     3b8:	00005097          	auipc	ra,0x5
     3bc:	fe4080e7          	jalr	-28(ra) # 539c <close>
    unlink("copyin1");
     3c0:	8552                	mv	a0,s4
     3c2:	00005097          	auipc	ra,0x5
     3c6:	002080e7          	jalr	2(ra) # 53c4 <unlink>
    n = write(1, (char*)addr, 8192);
     3ca:	6609                	lui	a2,0x2
     3cc:	85ce                	mv	a1,s3
     3ce:	4505                	li	a0,1
     3d0:	00005097          	auipc	ra,0x5
     3d4:	fc4080e7          	jalr	-60(ra) # 5394 <write>
    if(n > 0){
     3d8:	08a04963          	bgtz	a0,46a <copyin+0x106>
    if(pipe(fds) < 0){
     3dc:	fb840513          	addi	a0,s0,-72
     3e0:	00005097          	auipc	ra,0x5
     3e4:	fa4080e7          	jalr	-92(ra) # 5384 <pipe>
     3e8:	0a054063          	bltz	a0,488 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     3ec:	6609                	lui	a2,0x2
     3ee:	85ce                	mv	a1,s3
     3f0:	fbc42503          	lw	a0,-68(s0)
     3f4:	00005097          	auipc	ra,0x5
     3f8:	fa0080e7          	jalr	-96(ra) # 5394 <write>
    if(n > 0){
     3fc:	0aa04363          	bgtz	a0,4a2 <copyin+0x13e>
    close(fds[0]);
     400:	fb842503          	lw	a0,-72(s0)
     404:	00005097          	auipc	ra,0x5
     408:	f98080e7          	jalr	-104(ra) # 539c <close>
    close(fds[1]);
     40c:	fbc42503          	lw	a0,-68(s0)
     410:	00005097          	auipc	ra,0x5
     414:	f8c080e7          	jalr	-116(ra) # 539c <close>
  for(int ai = 0; ai < 2; ai++){
     418:	0921                	addi	s2,s2,8
     41a:	fd040793          	addi	a5,s0,-48
     41e:	f6f918e3          	bne	s2,a5,38e <copyin+0x2a>
}
     422:	60a6                	ld	ra,72(sp)
     424:	6406                	ld	s0,64(sp)
     426:	74e2                	ld	s1,56(sp)
     428:	7942                	ld	s2,48(sp)
     42a:	79a2                	ld	s3,40(sp)
     42c:	7a02                	ld	s4,32(sp)
     42e:	6161                	addi	sp,sp,80
     430:	8082                	ret
      printf("open(copyin1) failed\n");
     432:	00006517          	auipc	a0,0x6
     436:	87650513          	addi	a0,a0,-1930 # 5ca8 <malloc+0x4fe>
     43a:	00005097          	auipc	ra,0x5
     43e:	2b2080e7          	jalr	690(ra) # 56ec <printf>
      exit(1);
     442:	4505                	li	a0,1
     444:	00005097          	auipc	ra,0x5
     448:	f30080e7          	jalr	-208(ra) # 5374 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     44c:	862a                	mv	a2,a0
     44e:	85ce                	mv	a1,s3
     450:	00006517          	auipc	a0,0x6
     454:	87050513          	addi	a0,a0,-1936 # 5cc0 <malloc+0x516>
     458:	00005097          	auipc	ra,0x5
     45c:	294080e7          	jalr	660(ra) # 56ec <printf>
      exit(1);
     460:	4505                	li	a0,1
     462:	00005097          	auipc	ra,0x5
     466:	f12080e7          	jalr	-238(ra) # 5374 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     46a:	862a                	mv	a2,a0
     46c:	85ce                	mv	a1,s3
     46e:	00006517          	auipc	a0,0x6
     472:	88250513          	addi	a0,a0,-1918 # 5cf0 <malloc+0x546>
     476:	00005097          	auipc	ra,0x5
     47a:	276080e7          	jalr	630(ra) # 56ec <printf>
      exit(1);
     47e:	4505                	li	a0,1
     480:	00005097          	auipc	ra,0x5
     484:	ef4080e7          	jalr	-268(ra) # 5374 <exit>
      printf("pipe() failed\n");
     488:	00006517          	auipc	a0,0x6
     48c:	89850513          	addi	a0,a0,-1896 # 5d20 <malloc+0x576>
     490:	00005097          	auipc	ra,0x5
     494:	25c080e7          	jalr	604(ra) # 56ec <printf>
      exit(1);
     498:	4505                	li	a0,1
     49a:	00005097          	auipc	ra,0x5
     49e:	eda080e7          	jalr	-294(ra) # 5374 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     4a2:	862a                	mv	a2,a0
     4a4:	85ce                	mv	a1,s3
     4a6:	00006517          	auipc	a0,0x6
     4aa:	88a50513          	addi	a0,a0,-1910 # 5d30 <malloc+0x586>
     4ae:	00005097          	auipc	ra,0x5
     4b2:	23e080e7          	jalr	574(ra) # 56ec <printf>
      exit(1);
     4b6:	4505                	li	a0,1
     4b8:	00005097          	auipc	ra,0x5
     4bc:	ebc080e7          	jalr	-324(ra) # 5374 <exit>

00000000000004c0 <copyout>:
{
     4c0:	711d                	addi	sp,sp,-96
     4c2:	ec86                	sd	ra,88(sp)
     4c4:	e8a2                	sd	s0,80(sp)
     4c6:	e4a6                	sd	s1,72(sp)
     4c8:	e0ca                	sd	s2,64(sp)
     4ca:	fc4e                	sd	s3,56(sp)
     4cc:	f852                	sd	s4,48(sp)
     4ce:	f456                	sd	s5,40(sp)
     4d0:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     4d2:	4785                	li	a5,1
     4d4:	07fe                	slli	a5,a5,0x1f
     4d6:	faf43823          	sd	a5,-80(s0)
     4da:	57fd                	li	a5,-1
     4dc:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     4e0:	fb040913          	addi	s2,s0,-80
    int fd = open("README", 0);
     4e4:	00006a17          	auipc	s4,0x6
     4e8:	87ca0a13          	addi	s4,s4,-1924 # 5d60 <malloc+0x5b6>
    n = write(fds[1], "x", 1);
     4ec:	00005a97          	auipc	s5,0x5
     4f0:	74ca8a93          	addi	s5,s5,1868 # 5c38 <malloc+0x48e>
    uint64 addr = addrs[ai];
     4f4:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     4f8:	4581                	li	a1,0
     4fa:	8552                	mv	a0,s4
     4fc:	00005097          	auipc	ra,0x5
     500:	eb8080e7          	jalr	-328(ra) # 53b4 <open>
     504:	84aa                	mv	s1,a0
    if(fd < 0){
     506:	08054663          	bltz	a0,592 <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     50a:	6609                	lui	a2,0x2
     50c:	85ce                	mv	a1,s3
     50e:	00005097          	auipc	ra,0x5
     512:	e7e080e7          	jalr	-386(ra) # 538c <read>
    if(n > 0){
     516:	08a04b63          	bgtz	a0,5ac <copyout+0xec>
    close(fd);
     51a:	8526                	mv	a0,s1
     51c:	00005097          	auipc	ra,0x5
     520:	e80080e7          	jalr	-384(ra) # 539c <close>
    if(pipe(fds) < 0){
     524:	fa840513          	addi	a0,s0,-88
     528:	00005097          	auipc	ra,0x5
     52c:	e5c080e7          	jalr	-420(ra) # 5384 <pipe>
     530:	08054d63          	bltz	a0,5ca <copyout+0x10a>
    n = write(fds[1], "x", 1);
     534:	4605                	li	a2,1
     536:	85d6                	mv	a1,s5
     538:	fac42503          	lw	a0,-84(s0)
     53c:	00005097          	auipc	ra,0x5
     540:	e58080e7          	jalr	-424(ra) # 5394 <write>
    if(n != 1){
     544:	4785                	li	a5,1
     546:	08f51f63          	bne	a0,a5,5e4 <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     54a:	6609                	lui	a2,0x2
     54c:	85ce                	mv	a1,s3
     54e:	fa842503          	lw	a0,-88(s0)
     552:	00005097          	auipc	ra,0x5
     556:	e3a080e7          	jalr	-454(ra) # 538c <read>
    if(n > 0){
     55a:	0aa04263          	bgtz	a0,5fe <copyout+0x13e>
    close(fds[0]);
     55e:	fa842503          	lw	a0,-88(s0)
     562:	00005097          	auipc	ra,0x5
     566:	e3a080e7          	jalr	-454(ra) # 539c <close>
    close(fds[1]);
     56a:	fac42503          	lw	a0,-84(s0)
     56e:	00005097          	auipc	ra,0x5
     572:	e2e080e7          	jalr	-466(ra) # 539c <close>
  for(int ai = 0; ai < 2; ai++){
     576:	0921                	addi	s2,s2,8
     578:	fc040793          	addi	a5,s0,-64
     57c:	f6f91ce3          	bne	s2,a5,4f4 <copyout+0x34>
}
     580:	60e6                	ld	ra,88(sp)
     582:	6446                	ld	s0,80(sp)
     584:	64a6                	ld	s1,72(sp)
     586:	6906                	ld	s2,64(sp)
     588:	79e2                	ld	s3,56(sp)
     58a:	7a42                	ld	s4,48(sp)
     58c:	7aa2                	ld	s5,40(sp)
     58e:	6125                	addi	sp,sp,96
     590:	8082                	ret
      printf("open(README) failed\n");
     592:	00005517          	auipc	a0,0x5
     596:	7d650513          	addi	a0,a0,2006 # 5d68 <malloc+0x5be>
     59a:	00005097          	auipc	ra,0x5
     59e:	152080e7          	jalr	338(ra) # 56ec <printf>
      exit(1);
     5a2:	4505                	li	a0,1
     5a4:	00005097          	auipc	ra,0x5
     5a8:	dd0080e7          	jalr	-560(ra) # 5374 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5ac:	862a                	mv	a2,a0
     5ae:	85ce                	mv	a1,s3
     5b0:	00005517          	auipc	a0,0x5
     5b4:	7d050513          	addi	a0,a0,2000 # 5d80 <malloc+0x5d6>
     5b8:	00005097          	auipc	ra,0x5
     5bc:	134080e7          	jalr	308(ra) # 56ec <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	00005097          	auipc	ra,0x5
     5c6:	db2080e7          	jalr	-590(ra) # 5374 <exit>
      printf("pipe() failed\n");
     5ca:	00005517          	auipc	a0,0x5
     5ce:	75650513          	addi	a0,a0,1878 # 5d20 <malloc+0x576>
     5d2:	00005097          	auipc	ra,0x5
     5d6:	11a080e7          	jalr	282(ra) # 56ec <printf>
      exit(1);
     5da:	4505                	li	a0,1
     5dc:	00005097          	auipc	ra,0x5
     5e0:	d98080e7          	jalr	-616(ra) # 5374 <exit>
      printf("pipe write failed\n");
     5e4:	00005517          	auipc	a0,0x5
     5e8:	7cc50513          	addi	a0,a0,1996 # 5db0 <malloc+0x606>
     5ec:	00005097          	auipc	ra,0x5
     5f0:	100080e7          	jalr	256(ra) # 56ec <printf>
      exit(1);
     5f4:	4505                	li	a0,1
     5f6:	00005097          	auipc	ra,0x5
     5fa:	d7e080e7          	jalr	-642(ra) # 5374 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     5fe:	862a                	mv	a2,a0
     600:	85ce                	mv	a1,s3
     602:	00005517          	auipc	a0,0x5
     606:	7c650513          	addi	a0,a0,1990 # 5dc8 <malloc+0x61e>
     60a:	00005097          	auipc	ra,0x5
     60e:	0e2080e7          	jalr	226(ra) # 56ec <printf>
      exit(1);
     612:	4505                	li	a0,1
     614:	00005097          	auipc	ra,0x5
     618:	d60080e7          	jalr	-672(ra) # 5374 <exit>

000000000000061c <truncate1>:
{
     61c:	711d                	addi	sp,sp,-96
     61e:	ec86                	sd	ra,88(sp)
     620:	e8a2                	sd	s0,80(sp)
     622:	e4a6                	sd	s1,72(sp)
     624:	e0ca                	sd	s2,64(sp)
     626:	fc4e                	sd	s3,56(sp)
     628:	f852                	sd	s4,48(sp)
     62a:	f456                	sd	s5,40(sp)
     62c:	1080                	addi	s0,sp,96
     62e:	8aaa                	mv	s5,a0
  unlink("truncfile");
     630:	00005517          	auipc	a0,0x5
     634:	5f050513          	addi	a0,a0,1520 # 5c20 <malloc+0x476>
     638:	00005097          	auipc	ra,0x5
     63c:	d8c080e7          	jalr	-628(ra) # 53c4 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     640:	60100593          	li	a1,1537
     644:	00005517          	auipc	a0,0x5
     648:	5dc50513          	addi	a0,a0,1500 # 5c20 <malloc+0x476>
     64c:	00005097          	auipc	ra,0x5
     650:	d68080e7          	jalr	-664(ra) # 53b4 <open>
     654:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     656:	4611                	li	a2,4
     658:	00005597          	auipc	a1,0x5
     65c:	5d858593          	addi	a1,a1,1496 # 5c30 <malloc+0x486>
     660:	00005097          	auipc	ra,0x5
     664:	d34080e7          	jalr	-716(ra) # 5394 <write>
  close(fd1);
     668:	8526                	mv	a0,s1
     66a:	00005097          	auipc	ra,0x5
     66e:	d32080e7          	jalr	-718(ra) # 539c <close>
  int fd2 = open("truncfile", O_RDONLY);
     672:	4581                	li	a1,0
     674:	00005517          	auipc	a0,0x5
     678:	5ac50513          	addi	a0,a0,1452 # 5c20 <malloc+0x476>
     67c:	00005097          	auipc	ra,0x5
     680:	d38080e7          	jalr	-712(ra) # 53b4 <open>
     684:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     686:	02000613          	li	a2,32
     68a:	fa040593          	addi	a1,s0,-96
     68e:	00005097          	auipc	ra,0x5
     692:	cfe080e7          	jalr	-770(ra) # 538c <read>
  if(n != 4){
     696:	4791                	li	a5,4
     698:	0cf51e63          	bne	a0,a5,774 <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     69c:	40100593          	li	a1,1025
     6a0:	00005517          	auipc	a0,0x5
     6a4:	58050513          	addi	a0,a0,1408 # 5c20 <malloc+0x476>
     6a8:	00005097          	auipc	ra,0x5
     6ac:	d0c080e7          	jalr	-756(ra) # 53b4 <open>
     6b0:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     6b2:	4581                	li	a1,0
     6b4:	00005517          	auipc	a0,0x5
     6b8:	56c50513          	addi	a0,a0,1388 # 5c20 <malloc+0x476>
     6bc:	00005097          	auipc	ra,0x5
     6c0:	cf8080e7          	jalr	-776(ra) # 53b4 <open>
     6c4:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     6c6:	02000613          	li	a2,32
     6ca:	fa040593          	addi	a1,s0,-96
     6ce:	00005097          	auipc	ra,0x5
     6d2:	cbe080e7          	jalr	-834(ra) # 538c <read>
     6d6:	8a2a                	mv	s4,a0
  if(n != 0){
     6d8:	ed4d                	bnez	a0,792 <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     6da:	02000613          	li	a2,32
     6de:	fa040593          	addi	a1,s0,-96
     6e2:	8526                	mv	a0,s1
     6e4:	00005097          	auipc	ra,0x5
     6e8:	ca8080e7          	jalr	-856(ra) # 538c <read>
     6ec:	8a2a                	mv	s4,a0
  if(n != 0){
     6ee:	e971                	bnez	a0,7c2 <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     6f0:	4619                	li	a2,6
     6f2:	00005597          	auipc	a1,0x5
     6f6:	76658593          	addi	a1,a1,1894 # 5e58 <malloc+0x6ae>
     6fa:	854e                	mv	a0,s3
     6fc:	00005097          	auipc	ra,0x5
     700:	c98080e7          	jalr	-872(ra) # 5394 <write>
  n = read(fd3, buf, sizeof(buf));
     704:	02000613          	li	a2,32
     708:	fa040593          	addi	a1,s0,-96
     70c:	854a                	mv	a0,s2
     70e:	00005097          	auipc	ra,0x5
     712:	c7e080e7          	jalr	-898(ra) # 538c <read>
  if(n != 6){
     716:	4799                	li	a5,6
     718:	0cf51d63          	bne	a0,a5,7f2 <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     71c:	02000613          	li	a2,32
     720:	fa040593          	addi	a1,s0,-96
     724:	8526                	mv	a0,s1
     726:	00005097          	auipc	ra,0x5
     72a:	c66080e7          	jalr	-922(ra) # 538c <read>
  if(n != 2){
     72e:	4789                	li	a5,2
     730:	0ef51063          	bne	a0,a5,810 <truncate1+0x1f4>
  unlink("truncfile");
     734:	00005517          	auipc	a0,0x5
     738:	4ec50513          	addi	a0,a0,1260 # 5c20 <malloc+0x476>
     73c:	00005097          	auipc	ra,0x5
     740:	c88080e7          	jalr	-888(ra) # 53c4 <unlink>
  close(fd1);
     744:	854e                	mv	a0,s3
     746:	00005097          	auipc	ra,0x5
     74a:	c56080e7          	jalr	-938(ra) # 539c <close>
  close(fd2);
     74e:	8526                	mv	a0,s1
     750:	00005097          	auipc	ra,0x5
     754:	c4c080e7          	jalr	-948(ra) # 539c <close>
  close(fd3);
     758:	854a                	mv	a0,s2
     75a:	00005097          	auipc	ra,0x5
     75e:	c42080e7          	jalr	-958(ra) # 539c <close>
}
     762:	60e6                	ld	ra,88(sp)
     764:	6446                	ld	s0,80(sp)
     766:	64a6                	ld	s1,72(sp)
     768:	6906                	ld	s2,64(sp)
     76a:	79e2                	ld	s3,56(sp)
     76c:	7a42                	ld	s4,48(sp)
     76e:	7aa2                	ld	s5,40(sp)
     770:	6125                	addi	sp,sp,96
     772:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     774:	862a                	mv	a2,a0
     776:	85d6                	mv	a1,s5
     778:	00005517          	auipc	a0,0x5
     77c:	68050513          	addi	a0,a0,1664 # 5df8 <malloc+0x64e>
     780:	00005097          	auipc	ra,0x5
     784:	f6c080e7          	jalr	-148(ra) # 56ec <printf>
    exit(1);
     788:	4505                	li	a0,1
     78a:	00005097          	auipc	ra,0x5
     78e:	bea080e7          	jalr	-1046(ra) # 5374 <exit>
    printf("aaa fd3=%d\n", fd3);
     792:	85ca                	mv	a1,s2
     794:	00005517          	auipc	a0,0x5
     798:	68450513          	addi	a0,a0,1668 # 5e18 <malloc+0x66e>
     79c:	00005097          	auipc	ra,0x5
     7a0:	f50080e7          	jalr	-176(ra) # 56ec <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7a4:	8652                	mv	a2,s4
     7a6:	85d6                	mv	a1,s5
     7a8:	00005517          	auipc	a0,0x5
     7ac:	68050513          	addi	a0,a0,1664 # 5e28 <malloc+0x67e>
     7b0:	00005097          	auipc	ra,0x5
     7b4:	f3c080e7          	jalr	-196(ra) # 56ec <printf>
    exit(1);
     7b8:	4505                	li	a0,1
     7ba:	00005097          	auipc	ra,0x5
     7be:	bba080e7          	jalr	-1094(ra) # 5374 <exit>
    printf("bbb fd2=%d\n", fd2);
     7c2:	85a6                	mv	a1,s1
     7c4:	00005517          	auipc	a0,0x5
     7c8:	68450513          	addi	a0,a0,1668 # 5e48 <malloc+0x69e>
     7cc:	00005097          	auipc	ra,0x5
     7d0:	f20080e7          	jalr	-224(ra) # 56ec <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     7d4:	8652                	mv	a2,s4
     7d6:	85d6                	mv	a1,s5
     7d8:	00005517          	auipc	a0,0x5
     7dc:	65050513          	addi	a0,a0,1616 # 5e28 <malloc+0x67e>
     7e0:	00005097          	auipc	ra,0x5
     7e4:	f0c080e7          	jalr	-244(ra) # 56ec <printf>
    exit(1);
     7e8:	4505                	li	a0,1
     7ea:	00005097          	auipc	ra,0x5
     7ee:	b8a080e7          	jalr	-1142(ra) # 5374 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     7f2:	862a                	mv	a2,a0
     7f4:	85d6                	mv	a1,s5
     7f6:	00005517          	auipc	a0,0x5
     7fa:	66a50513          	addi	a0,a0,1642 # 5e60 <malloc+0x6b6>
     7fe:	00005097          	auipc	ra,0x5
     802:	eee080e7          	jalr	-274(ra) # 56ec <printf>
    exit(1);
     806:	4505                	li	a0,1
     808:	00005097          	auipc	ra,0x5
     80c:	b6c080e7          	jalr	-1172(ra) # 5374 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     810:	862a                	mv	a2,a0
     812:	85d6                	mv	a1,s5
     814:	00005517          	auipc	a0,0x5
     818:	66c50513          	addi	a0,a0,1644 # 5e80 <malloc+0x6d6>
     81c:	00005097          	auipc	ra,0x5
     820:	ed0080e7          	jalr	-304(ra) # 56ec <printf>
    exit(1);
     824:	4505                	li	a0,1
     826:	00005097          	auipc	ra,0x5
     82a:	b4e080e7          	jalr	-1202(ra) # 5374 <exit>

000000000000082e <writetest>:
{
     82e:	7139                	addi	sp,sp,-64
     830:	fc06                	sd	ra,56(sp)
     832:	f822                	sd	s0,48(sp)
     834:	f426                	sd	s1,40(sp)
     836:	f04a                	sd	s2,32(sp)
     838:	ec4e                	sd	s3,24(sp)
     83a:	e852                	sd	s4,16(sp)
     83c:	e456                	sd	s5,8(sp)
     83e:	e05a                	sd	s6,0(sp)
     840:	0080                	addi	s0,sp,64
     842:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     844:	20200593          	li	a1,514
     848:	00005517          	auipc	a0,0x5
     84c:	65850513          	addi	a0,a0,1624 # 5ea0 <malloc+0x6f6>
     850:	00005097          	auipc	ra,0x5
     854:	b64080e7          	jalr	-1180(ra) # 53b4 <open>
  if(fd < 0){
     858:	0a054d63          	bltz	a0,912 <writetest+0xe4>
     85c:	892a                	mv	s2,a0
     85e:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     860:	00005997          	auipc	s3,0x5
     864:	66898993          	addi	s3,s3,1640 # 5ec8 <malloc+0x71e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     868:	00005a97          	auipc	s5,0x5
     86c:	698a8a93          	addi	s5,s5,1688 # 5f00 <malloc+0x756>
  for(i = 0; i < N; i++){
     870:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     874:	4629                	li	a2,10
     876:	85ce                	mv	a1,s3
     878:	854a                	mv	a0,s2
     87a:	00005097          	auipc	ra,0x5
     87e:	b1a080e7          	jalr	-1254(ra) # 5394 <write>
     882:	47a9                	li	a5,10
     884:	0af51563          	bne	a0,a5,92e <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     888:	4629                	li	a2,10
     88a:	85d6                	mv	a1,s5
     88c:	854a                	mv	a0,s2
     88e:	00005097          	auipc	ra,0x5
     892:	b06080e7          	jalr	-1274(ra) # 5394 <write>
     896:	47a9                	li	a5,10
     898:	0af51963          	bne	a0,a5,94a <writetest+0x11c>
  for(i = 0; i < N; i++){
     89c:	2485                	addiw	s1,s1,1
     89e:	fd449be3          	bne	s1,s4,874 <writetest+0x46>
  close(fd);
     8a2:	854a                	mv	a0,s2
     8a4:	00005097          	auipc	ra,0x5
     8a8:	af8080e7          	jalr	-1288(ra) # 539c <close>
  fd = open("small", O_RDONLY);
     8ac:	4581                	li	a1,0
     8ae:	00005517          	auipc	a0,0x5
     8b2:	5f250513          	addi	a0,a0,1522 # 5ea0 <malloc+0x6f6>
     8b6:	00005097          	auipc	ra,0x5
     8ba:	afe080e7          	jalr	-1282(ra) # 53b4 <open>
     8be:	84aa                	mv	s1,a0
  if(fd < 0){
     8c0:	0a054363          	bltz	a0,966 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     8c4:	7d000613          	li	a2,2000
     8c8:	0000b597          	auipc	a1,0xb
     8cc:	e6858593          	addi	a1,a1,-408 # b730 <buf>
     8d0:	00005097          	auipc	ra,0x5
     8d4:	abc080e7          	jalr	-1348(ra) # 538c <read>
  if(i != N*SZ*2){
     8d8:	7d000793          	li	a5,2000
     8dc:	0af51363          	bne	a0,a5,982 <writetest+0x154>
  close(fd);
     8e0:	8526                	mv	a0,s1
     8e2:	00005097          	auipc	ra,0x5
     8e6:	aba080e7          	jalr	-1350(ra) # 539c <close>
  if(unlink("small") < 0){
     8ea:	00005517          	auipc	a0,0x5
     8ee:	5b650513          	addi	a0,a0,1462 # 5ea0 <malloc+0x6f6>
     8f2:	00005097          	auipc	ra,0x5
     8f6:	ad2080e7          	jalr	-1326(ra) # 53c4 <unlink>
     8fa:	0a054263          	bltz	a0,99e <writetest+0x170>
}
     8fe:	70e2                	ld	ra,56(sp)
     900:	7442                	ld	s0,48(sp)
     902:	74a2                	ld	s1,40(sp)
     904:	7902                	ld	s2,32(sp)
     906:	69e2                	ld	s3,24(sp)
     908:	6a42                	ld	s4,16(sp)
     90a:	6aa2                	ld	s5,8(sp)
     90c:	6b02                	ld	s6,0(sp)
     90e:	6121                	addi	sp,sp,64
     910:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     912:	85da                	mv	a1,s6
     914:	00005517          	auipc	a0,0x5
     918:	59450513          	addi	a0,a0,1428 # 5ea8 <malloc+0x6fe>
     91c:	00005097          	auipc	ra,0x5
     920:	dd0080e7          	jalr	-560(ra) # 56ec <printf>
    exit(1);
     924:	4505                	li	a0,1
     926:	00005097          	auipc	ra,0x5
     92a:	a4e080e7          	jalr	-1458(ra) # 5374 <exit>
      printf("%s: error: write aa %d new file failed\n", i);
     92e:	85a6                	mv	a1,s1
     930:	00005517          	auipc	a0,0x5
     934:	5a850513          	addi	a0,a0,1448 # 5ed8 <malloc+0x72e>
     938:	00005097          	auipc	ra,0x5
     93c:	db4080e7          	jalr	-588(ra) # 56ec <printf>
      exit(1);
     940:	4505                	li	a0,1
     942:	00005097          	auipc	ra,0x5
     946:	a32080e7          	jalr	-1486(ra) # 5374 <exit>
      printf("%s: error: write bb %d new file failed\n", i);
     94a:	85a6                	mv	a1,s1
     94c:	00005517          	auipc	a0,0x5
     950:	5c450513          	addi	a0,a0,1476 # 5f10 <malloc+0x766>
     954:	00005097          	auipc	ra,0x5
     958:	d98080e7          	jalr	-616(ra) # 56ec <printf>
      exit(1);
     95c:	4505                	li	a0,1
     95e:	00005097          	auipc	ra,0x5
     962:	a16080e7          	jalr	-1514(ra) # 5374 <exit>
    printf("%s: error: open small failed!\n", s);
     966:	85da                	mv	a1,s6
     968:	00005517          	auipc	a0,0x5
     96c:	5d050513          	addi	a0,a0,1488 # 5f38 <malloc+0x78e>
     970:	00005097          	auipc	ra,0x5
     974:	d7c080e7          	jalr	-644(ra) # 56ec <printf>
    exit(1);
     978:	4505                	li	a0,1
     97a:	00005097          	auipc	ra,0x5
     97e:	9fa080e7          	jalr	-1542(ra) # 5374 <exit>
    printf("%s: read failed\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	5d450513          	addi	a0,a0,1492 # 5f58 <malloc+0x7ae>
     98c:	00005097          	auipc	ra,0x5
     990:	d60080e7          	jalr	-672(ra) # 56ec <printf>
    exit(1);
     994:	4505                	li	a0,1
     996:	00005097          	auipc	ra,0x5
     99a:	9de080e7          	jalr	-1570(ra) # 5374 <exit>
    printf("%s: unlink small failed\n", s);
     99e:	85da                	mv	a1,s6
     9a0:	00005517          	auipc	a0,0x5
     9a4:	5d050513          	addi	a0,a0,1488 # 5f70 <malloc+0x7c6>
     9a8:	00005097          	auipc	ra,0x5
     9ac:	d44080e7          	jalr	-700(ra) # 56ec <printf>
    exit(1);
     9b0:	4505                	li	a0,1
     9b2:	00005097          	auipc	ra,0x5
     9b6:	9c2080e7          	jalr	-1598(ra) # 5374 <exit>

00000000000009ba <writebig>:
{
     9ba:	7139                	addi	sp,sp,-64
     9bc:	fc06                	sd	ra,56(sp)
     9be:	f822                	sd	s0,48(sp)
     9c0:	f426                	sd	s1,40(sp)
     9c2:	f04a                	sd	s2,32(sp)
     9c4:	ec4e                	sd	s3,24(sp)
     9c6:	e852                	sd	s4,16(sp)
     9c8:	e456                	sd	s5,8(sp)
     9ca:	0080                	addi	s0,sp,64
     9cc:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9ce:	20200593          	li	a1,514
     9d2:	00005517          	auipc	a0,0x5
     9d6:	5be50513          	addi	a0,a0,1470 # 5f90 <malloc+0x7e6>
     9da:	00005097          	auipc	ra,0x5
     9de:	9da080e7          	jalr	-1574(ra) # 53b4 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000b917          	auipc	s2,0xb
     9ea:	d4a90913          	addi	s2,s2,-694 # b730 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054c63          	bltz	a0,a6a <writebig+0xb0>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	00005097          	auipc	ra,0x5
     a06:	992080e7          	jalr	-1646(ra) # 5394 <write>
     a0a:	40000793          	li	a5,1024
     a0e:	06f51c63          	bne	a0,a5,a86 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     a12:	2485                	addiw	s1,s1,1
     a14:	ff4491e3          	bne	s1,s4,9f6 <writebig+0x3c>
  close(fd);
     a18:	854e                	mv	a0,s3
     a1a:	00005097          	auipc	ra,0x5
     a1e:	982080e7          	jalr	-1662(ra) # 539c <close>
  fd = open("big", O_RDONLY);
     a22:	4581                	li	a1,0
     a24:	00005517          	auipc	a0,0x5
     a28:	56c50513          	addi	a0,a0,1388 # 5f90 <malloc+0x7e6>
     a2c:	00005097          	auipc	ra,0x5
     a30:	988080e7          	jalr	-1656(ra) # 53b4 <open>
     a34:	89aa                	mv	s3,a0
  n = 0;
     a36:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a38:	0000b917          	auipc	s2,0xb
     a3c:	cf890913          	addi	s2,s2,-776 # b730 <buf>
  if(fd < 0){
     a40:	06054163          	bltz	a0,aa2 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
     a44:	40000613          	li	a2,1024
     a48:	85ca                	mv	a1,s2
     a4a:	854e                	mv	a0,s3
     a4c:	00005097          	auipc	ra,0x5
     a50:	940080e7          	jalr	-1728(ra) # 538c <read>
    if(i == 0){
     a54:	c52d                	beqz	a0,abe <writebig+0x104>
    } else if(i != BSIZE){
     a56:	40000793          	li	a5,1024
     a5a:	0af51d63          	bne	a0,a5,b14 <writebig+0x15a>
    if(((int*)buf)[0] != n){
     a5e:	00092603          	lw	a2,0(s2)
     a62:	0c961763          	bne	a2,s1,b30 <writebig+0x176>
    n++;
     a66:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a68:	bff1                	j	a44 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     a6a:	85d6                	mv	a1,s5
     a6c:	00005517          	auipc	a0,0x5
     a70:	52c50513          	addi	a0,a0,1324 # 5f98 <malloc+0x7ee>
     a74:	00005097          	auipc	ra,0x5
     a78:	c78080e7          	jalr	-904(ra) # 56ec <printf>
    exit(1);
     a7c:	4505                	li	a0,1
     a7e:	00005097          	auipc	ra,0x5
     a82:	8f6080e7          	jalr	-1802(ra) # 5374 <exit>
      printf("%s: error: write big file failed\n", i);
     a86:	85a6                	mv	a1,s1
     a88:	00005517          	auipc	a0,0x5
     a8c:	53050513          	addi	a0,a0,1328 # 5fb8 <malloc+0x80e>
     a90:	00005097          	auipc	ra,0x5
     a94:	c5c080e7          	jalr	-932(ra) # 56ec <printf>
      exit(1);
     a98:	4505                	li	a0,1
     a9a:	00005097          	auipc	ra,0x5
     a9e:	8da080e7          	jalr	-1830(ra) # 5374 <exit>
    printf("%s: error: open big failed!\n", s);
     aa2:	85d6                	mv	a1,s5
     aa4:	00005517          	auipc	a0,0x5
     aa8:	53c50513          	addi	a0,a0,1340 # 5fe0 <malloc+0x836>
     aac:	00005097          	auipc	ra,0x5
     ab0:	c40080e7          	jalr	-960(ra) # 56ec <printf>
    exit(1);
     ab4:	4505                	li	a0,1
     ab6:	00005097          	auipc	ra,0x5
     aba:	8be080e7          	jalr	-1858(ra) # 5374 <exit>
      if(n == MAXFILE - 1){
     abe:	10b00793          	li	a5,267
     ac2:	02f48a63          	beq	s1,a5,af6 <writebig+0x13c>
  close(fd);
     ac6:	854e                	mv	a0,s3
     ac8:	00005097          	auipc	ra,0x5
     acc:	8d4080e7          	jalr	-1836(ra) # 539c <close>
  if(unlink("big") < 0){
     ad0:	00005517          	auipc	a0,0x5
     ad4:	4c050513          	addi	a0,a0,1216 # 5f90 <malloc+0x7e6>
     ad8:	00005097          	auipc	ra,0x5
     adc:	8ec080e7          	jalr	-1812(ra) # 53c4 <unlink>
     ae0:	06054663          	bltz	a0,b4c <writebig+0x192>
}
     ae4:	70e2                	ld	ra,56(sp)
     ae6:	7442                	ld	s0,48(sp)
     ae8:	74a2                	ld	s1,40(sp)
     aea:	7902                	ld	s2,32(sp)
     aec:	69e2                	ld	s3,24(sp)
     aee:	6a42                	ld	s4,16(sp)
     af0:	6aa2                	ld	s5,8(sp)
     af2:	6121                	addi	sp,sp,64
     af4:	8082                	ret
        printf("%s: read only %d blocks from big", n);
     af6:	10b00593          	li	a1,267
     afa:	00005517          	auipc	a0,0x5
     afe:	50650513          	addi	a0,a0,1286 # 6000 <malloc+0x856>
     b02:	00005097          	auipc	ra,0x5
     b06:	bea080e7          	jalr	-1046(ra) # 56ec <printf>
        exit(1);
     b0a:	4505                	li	a0,1
     b0c:	00005097          	auipc	ra,0x5
     b10:	868080e7          	jalr	-1944(ra) # 5374 <exit>
      printf("%s: read failed %d\n", i);
     b14:	85aa                	mv	a1,a0
     b16:	00005517          	auipc	a0,0x5
     b1a:	51250513          	addi	a0,a0,1298 # 6028 <malloc+0x87e>
     b1e:	00005097          	auipc	ra,0x5
     b22:	bce080e7          	jalr	-1074(ra) # 56ec <printf>
      exit(1);
     b26:	4505                	li	a0,1
     b28:	00005097          	auipc	ra,0x5
     b2c:	84c080e7          	jalr	-1972(ra) # 5374 <exit>
      printf("%s: read content of block %d is %d\n",
     b30:	85a6                	mv	a1,s1
     b32:	00005517          	auipc	a0,0x5
     b36:	50e50513          	addi	a0,a0,1294 # 6040 <malloc+0x896>
     b3a:	00005097          	auipc	ra,0x5
     b3e:	bb2080e7          	jalr	-1102(ra) # 56ec <printf>
      exit(1);
     b42:	4505                	li	a0,1
     b44:	00005097          	auipc	ra,0x5
     b48:	830080e7          	jalr	-2000(ra) # 5374 <exit>
    printf("%s: unlink big failed\n", s);
     b4c:	85d6                	mv	a1,s5
     b4e:	00005517          	auipc	a0,0x5
     b52:	51a50513          	addi	a0,a0,1306 # 6068 <malloc+0x8be>
     b56:	00005097          	auipc	ra,0x5
     b5a:	b96080e7          	jalr	-1130(ra) # 56ec <printf>
    exit(1);
     b5e:	4505                	li	a0,1
     b60:	00005097          	auipc	ra,0x5
     b64:	814080e7          	jalr	-2028(ra) # 5374 <exit>

0000000000000b68 <unlinkread>:
{
     b68:	7179                	addi	sp,sp,-48
     b6a:	f406                	sd	ra,40(sp)
     b6c:	f022                	sd	s0,32(sp)
     b6e:	ec26                	sd	s1,24(sp)
     b70:	e84a                	sd	s2,16(sp)
     b72:	e44e                	sd	s3,8(sp)
     b74:	1800                	addi	s0,sp,48
     b76:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b78:	20200593          	li	a1,514
     b7c:	00005517          	auipc	a0,0x5
     b80:	e5c50513          	addi	a0,a0,-420 # 59d8 <malloc+0x22e>
     b84:	00005097          	auipc	ra,0x5
     b88:	830080e7          	jalr	-2000(ra) # 53b4 <open>
  if(fd < 0){
     b8c:	0e054563          	bltz	a0,c76 <unlinkread+0x10e>
     b90:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b92:	4615                	li	a2,5
     b94:	00005597          	auipc	a1,0x5
     b98:	50c58593          	addi	a1,a1,1292 # 60a0 <malloc+0x8f6>
     b9c:	00004097          	auipc	ra,0x4
     ba0:	7f8080e7          	jalr	2040(ra) # 5394 <write>
  close(fd);
     ba4:	8526                	mv	a0,s1
     ba6:	00004097          	auipc	ra,0x4
     baa:	7f6080e7          	jalr	2038(ra) # 539c <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	e2850513          	addi	a0,a0,-472 # 59d8 <malloc+0x22e>
     bb8:	00004097          	auipc	ra,0x4
     bbc:	7fc080e7          	jalr	2044(ra) # 53b4 <open>
     bc0:	84aa                	mv	s1,a0
  if(fd < 0){
     bc2:	0c054863          	bltz	a0,c92 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     bc6:	00005517          	auipc	a0,0x5
     bca:	e1250513          	addi	a0,a0,-494 # 59d8 <malloc+0x22e>
     bce:	00004097          	auipc	ra,0x4
     bd2:	7f6080e7          	jalr	2038(ra) # 53c4 <unlink>
     bd6:	ed61                	bnez	a0,cae <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd8:	20200593          	li	a1,514
     bdc:	00005517          	auipc	a0,0x5
     be0:	dfc50513          	addi	a0,a0,-516 # 59d8 <malloc+0x22e>
     be4:	00004097          	auipc	ra,0x4
     be8:	7d0080e7          	jalr	2000(ra) # 53b4 <open>
     bec:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     bee:	460d                	li	a2,3
     bf0:	00005597          	auipc	a1,0x5
     bf4:	4f858593          	addi	a1,a1,1272 # 60e8 <malloc+0x93e>
     bf8:	00004097          	auipc	ra,0x4
     bfc:	79c080e7          	jalr	1948(ra) # 5394 <write>
  close(fd1);
     c00:	854a                	mv	a0,s2
     c02:	00004097          	auipc	ra,0x4
     c06:	79a080e7          	jalr	1946(ra) # 539c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     c0a:	660d                	lui	a2,0x3
     c0c:	0000b597          	auipc	a1,0xb
     c10:	b2458593          	addi	a1,a1,-1244 # b730 <buf>
     c14:	8526                	mv	a0,s1
     c16:	00004097          	auipc	ra,0x4
     c1a:	776080e7          	jalr	1910(ra) # 538c <read>
     c1e:	4795                	li	a5,5
     c20:	0af51563          	bne	a0,a5,cca <unlinkread+0x162>
  if(buf[0] != 'h'){
     c24:	0000b717          	auipc	a4,0xb
     c28:	b0c74703          	lbu	a4,-1268(a4) # b730 <buf>
     c2c:	06800793          	li	a5,104
     c30:	0af71b63          	bne	a4,a5,ce6 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     c34:	4629                	li	a2,10
     c36:	0000b597          	auipc	a1,0xb
     c3a:	afa58593          	addi	a1,a1,-1286 # b730 <buf>
     c3e:	8526                	mv	a0,s1
     c40:	00004097          	auipc	ra,0x4
     c44:	754080e7          	jalr	1876(ra) # 5394 <write>
     c48:	47a9                	li	a5,10
     c4a:	0af51c63          	bne	a0,a5,d02 <unlinkread+0x19a>
  close(fd);
     c4e:	8526                	mv	a0,s1
     c50:	00004097          	auipc	ra,0x4
     c54:	74c080e7          	jalr	1868(ra) # 539c <close>
  unlink("unlinkread");
     c58:	00005517          	auipc	a0,0x5
     c5c:	d8050513          	addi	a0,a0,-640 # 59d8 <malloc+0x22e>
     c60:	00004097          	auipc	ra,0x4
     c64:	764080e7          	jalr	1892(ra) # 53c4 <unlink>
}
     c68:	70a2                	ld	ra,40(sp)
     c6a:	7402                	ld	s0,32(sp)
     c6c:	64e2                	ld	s1,24(sp)
     c6e:	6942                	ld	s2,16(sp)
     c70:	69a2                	ld	s3,8(sp)
     c72:	6145                	addi	sp,sp,48
     c74:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c76:	85ce                	mv	a1,s3
     c78:	00005517          	auipc	a0,0x5
     c7c:	40850513          	addi	a0,a0,1032 # 6080 <malloc+0x8d6>
     c80:	00005097          	auipc	ra,0x5
     c84:	a6c080e7          	jalr	-1428(ra) # 56ec <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	00004097          	auipc	ra,0x4
     c8e:	6ea080e7          	jalr	1770(ra) # 5374 <exit>
    printf("%s: open unlinkread failed\n", s);
     c92:	85ce                	mv	a1,s3
     c94:	00005517          	auipc	a0,0x5
     c98:	41450513          	addi	a0,a0,1044 # 60a8 <malloc+0x8fe>
     c9c:	00005097          	auipc	ra,0x5
     ca0:	a50080e7          	jalr	-1456(ra) # 56ec <printf>
    exit(1);
     ca4:	4505                	li	a0,1
     ca6:	00004097          	auipc	ra,0x4
     caa:	6ce080e7          	jalr	1742(ra) # 5374 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     cae:	85ce                	mv	a1,s3
     cb0:	00005517          	auipc	a0,0x5
     cb4:	41850513          	addi	a0,a0,1048 # 60c8 <malloc+0x91e>
     cb8:	00005097          	auipc	ra,0x5
     cbc:	a34080e7          	jalr	-1484(ra) # 56ec <printf>
    exit(1);
     cc0:	4505                	li	a0,1
     cc2:	00004097          	auipc	ra,0x4
     cc6:	6b2080e7          	jalr	1714(ra) # 5374 <exit>
    printf("%s: unlinkread read failed", s);
     cca:	85ce                	mv	a1,s3
     ccc:	00005517          	auipc	a0,0x5
     cd0:	42450513          	addi	a0,a0,1060 # 60f0 <malloc+0x946>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	a18080e7          	jalr	-1512(ra) # 56ec <printf>
    exit(1);
     cdc:	4505                	li	a0,1
     cde:	00004097          	auipc	ra,0x4
     ce2:	696080e7          	jalr	1686(ra) # 5374 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ce6:	85ce                	mv	a1,s3
     ce8:	00005517          	auipc	a0,0x5
     cec:	42850513          	addi	a0,a0,1064 # 6110 <malloc+0x966>
     cf0:	00005097          	auipc	ra,0x5
     cf4:	9fc080e7          	jalr	-1540(ra) # 56ec <printf>
    exit(1);
     cf8:	4505                	li	a0,1
     cfa:	00004097          	auipc	ra,0x4
     cfe:	67a080e7          	jalr	1658(ra) # 5374 <exit>
    printf("%s: unlinkread write failed\n", s);
     d02:	85ce                	mv	a1,s3
     d04:	00005517          	auipc	a0,0x5
     d08:	42c50513          	addi	a0,a0,1068 # 6130 <malloc+0x986>
     d0c:	00005097          	auipc	ra,0x5
     d10:	9e0080e7          	jalr	-1568(ra) # 56ec <printf>
    exit(1);
     d14:	4505                	li	a0,1
     d16:	00004097          	auipc	ra,0x4
     d1a:	65e080e7          	jalr	1630(ra) # 5374 <exit>

0000000000000d1e <linktest>:
{
     d1e:	1101                	addi	sp,sp,-32
     d20:	ec06                	sd	ra,24(sp)
     d22:	e822                	sd	s0,16(sp)
     d24:	e426                	sd	s1,8(sp)
     d26:	e04a                	sd	s2,0(sp)
     d28:	1000                	addi	s0,sp,32
     d2a:	892a                	mv	s2,a0
  unlink("lf1");
     d2c:	00005517          	auipc	a0,0x5
     d30:	42450513          	addi	a0,a0,1060 # 6150 <malloc+0x9a6>
     d34:	00004097          	auipc	ra,0x4
     d38:	690080e7          	jalr	1680(ra) # 53c4 <unlink>
  unlink("lf2");
     d3c:	00005517          	auipc	a0,0x5
     d40:	41c50513          	addi	a0,a0,1052 # 6158 <malloc+0x9ae>
     d44:	00004097          	auipc	ra,0x4
     d48:	680080e7          	jalr	1664(ra) # 53c4 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     d4c:	20200593          	li	a1,514
     d50:	00005517          	auipc	a0,0x5
     d54:	40050513          	addi	a0,a0,1024 # 6150 <malloc+0x9a6>
     d58:	00004097          	auipc	ra,0x4
     d5c:	65c080e7          	jalr	1628(ra) # 53b4 <open>
  if(fd < 0){
     d60:	10054763          	bltz	a0,e6e <linktest+0x150>
     d64:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d66:	4615                	li	a2,5
     d68:	00005597          	auipc	a1,0x5
     d6c:	33858593          	addi	a1,a1,824 # 60a0 <malloc+0x8f6>
     d70:	00004097          	auipc	ra,0x4
     d74:	624080e7          	jalr	1572(ra) # 5394 <write>
     d78:	4795                	li	a5,5
     d7a:	10f51863          	bne	a0,a5,e8a <linktest+0x16c>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	00004097          	auipc	ra,0x4
     d84:	61c080e7          	jalr	1564(ra) # 539c <close>
  if(link("lf1", "lf2") < 0){
     d88:	00005597          	auipc	a1,0x5
     d8c:	3d058593          	addi	a1,a1,976 # 6158 <malloc+0x9ae>
     d90:	00005517          	auipc	a0,0x5
     d94:	3c050513          	addi	a0,a0,960 # 6150 <malloc+0x9a6>
     d98:	00004097          	auipc	ra,0x4
     d9c:	63c080e7          	jalr	1596(ra) # 53d4 <link>
     da0:	10054363          	bltz	a0,ea6 <linktest+0x188>
  unlink("lf1");
     da4:	00005517          	auipc	a0,0x5
     da8:	3ac50513          	addi	a0,a0,940 # 6150 <malloc+0x9a6>
     dac:	00004097          	auipc	ra,0x4
     db0:	618080e7          	jalr	1560(ra) # 53c4 <unlink>
  if(open("lf1", 0) >= 0){
     db4:	4581                	li	a1,0
     db6:	00005517          	auipc	a0,0x5
     dba:	39a50513          	addi	a0,a0,922 # 6150 <malloc+0x9a6>
     dbe:	00004097          	auipc	ra,0x4
     dc2:	5f6080e7          	jalr	1526(ra) # 53b4 <open>
     dc6:	0e055e63          	bgez	a0,ec2 <linktest+0x1a4>
  fd = open("lf2", 0);
     dca:	4581                	li	a1,0
     dcc:	00005517          	auipc	a0,0x5
     dd0:	38c50513          	addi	a0,a0,908 # 6158 <malloc+0x9ae>
     dd4:	00004097          	auipc	ra,0x4
     dd8:	5e0080e7          	jalr	1504(ra) # 53b4 <open>
     ddc:	84aa                	mv	s1,a0
  if(fd < 0){
     dde:	10054063          	bltz	a0,ede <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de2:	660d                	lui	a2,0x3
     de4:	0000b597          	auipc	a1,0xb
     de8:	94c58593          	addi	a1,a1,-1716 # b730 <buf>
     dec:	00004097          	auipc	ra,0x4
     df0:	5a0080e7          	jalr	1440(ra) # 538c <read>
     df4:	4795                	li	a5,5
     df6:	10f51263          	bne	a0,a5,efa <linktest+0x1dc>
  close(fd);
     dfa:	8526                	mv	a0,s1
     dfc:	00004097          	auipc	ra,0x4
     e00:	5a0080e7          	jalr	1440(ra) # 539c <close>
  if(link("lf2", "lf2") >= 0){
     e04:	00005597          	auipc	a1,0x5
     e08:	35458593          	addi	a1,a1,852 # 6158 <malloc+0x9ae>
     e0c:	852e                	mv	a0,a1
     e0e:	00004097          	auipc	ra,0x4
     e12:	5c6080e7          	jalr	1478(ra) # 53d4 <link>
     e16:	10055063          	bgez	a0,f16 <linktest+0x1f8>
  unlink("lf2");
     e1a:	00005517          	auipc	a0,0x5
     e1e:	33e50513          	addi	a0,a0,830 # 6158 <malloc+0x9ae>
     e22:	00004097          	auipc	ra,0x4
     e26:	5a2080e7          	jalr	1442(ra) # 53c4 <unlink>
  if(link("lf2", "lf1") >= 0){
     e2a:	00005597          	auipc	a1,0x5
     e2e:	32658593          	addi	a1,a1,806 # 6150 <malloc+0x9a6>
     e32:	00005517          	auipc	a0,0x5
     e36:	32650513          	addi	a0,a0,806 # 6158 <malloc+0x9ae>
     e3a:	00004097          	auipc	ra,0x4
     e3e:	59a080e7          	jalr	1434(ra) # 53d4 <link>
     e42:	0e055863          	bgez	a0,f32 <linktest+0x214>
  if(link(".", "lf1") >= 0){
     e46:	00005597          	auipc	a1,0x5
     e4a:	30a58593          	addi	a1,a1,778 # 6150 <malloc+0x9a6>
     e4e:	00005517          	auipc	a0,0x5
     e52:	41250513          	addi	a0,a0,1042 # 6260 <malloc+0xab6>
     e56:	00004097          	auipc	ra,0x4
     e5a:	57e080e7          	jalr	1406(ra) # 53d4 <link>
     e5e:	0e055863          	bgez	a0,f4e <linktest+0x230>
}
     e62:	60e2                	ld	ra,24(sp)
     e64:	6442                	ld	s0,16(sp)
     e66:	64a2                	ld	s1,8(sp)
     e68:	6902                	ld	s2,0(sp)
     e6a:	6105                	addi	sp,sp,32
     e6c:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     e6e:	85ca                	mv	a1,s2
     e70:	00005517          	auipc	a0,0x5
     e74:	2f050513          	addi	a0,a0,752 # 6160 <malloc+0x9b6>
     e78:	00005097          	auipc	ra,0x5
     e7c:	874080e7          	jalr	-1932(ra) # 56ec <printf>
    exit(1);
     e80:	4505                	li	a0,1
     e82:	00004097          	auipc	ra,0x4
     e86:	4f2080e7          	jalr	1266(ra) # 5374 <exit>
    printf("%s: write lf1 failed\n", s);
     e8a:	85ca                	mv	a1,s2
     e8c:	00005517          	auipc	a0,0x5
     e90:	2ec50513          	addi	a0,a0,748 # 6178 <malloc+0x9ce>
     e94:	00005097          	auipc	ra,0x5
     e98:	858080e7          	jalr	-1960(ra) # 56ec <printf>
    exit(1);
     e9c:	4505                	li	a0,1
     e9e:	00004097          	auipc	ra,0x4
     ea2:	4d6080e7          	jalr	1238(ra) # 5374 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     ea6:	85ca                	mv	a1,s2
     ea8:	00005517          	auipc	a0,0x5
     eac:	2e850513          	addi	a0,a0,744 # 6190 <malloc+0x9e6>
     eb0:	00005097          	auipc	ra,0x5
     eb4:	83c080e7          	jalr	-1988(ra) # 56ec <printf>
    exit(1);
     eb8:	4505                	li	a0,1
     eba:	00004097          	auipc	ra,0x4
     ebe:	4ba080e7          	jalr	1210(ra) # 5374 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     ec2:	85ca                	mv	a1,s2
     ec4:	00005517          	auipc	a0,0x5
     ec8:	2ec50513          	addi	a0,a0,748 # 61b0 <malloc+0xa06>
     ecc:	00005097          	auipc	ra,0x5
     ed0:	820080e7          	jalr	-2016(ra) # 56ec <printf>
    exit(1);
     ed4:	4505                	li	a0,1
     ed6:	00004097          	auipc	ra,0x4
     eda:	49e080e7          	jalr	1182(ra) # 5374 <exit>
    printf("%s: open lf2 failed\n", s);
     ede:	85ca                	mv	a1,s2
     ee0:	00005517          	auipc	a0,0x5
     ee4:	30050513          	addi	a0,a0,768 # 61e0 <malloc+0xa36>
     ee8:	00005097          	auipc	ra,0x5
     eec:	804080e7          	jalr	-2044(ra) # 56ec <printf>
    exit(1);
     ef0:	4505                	li	a0,1
     ef2:	00004097          	auipc	ra,0x4
     ef6:	482080e7          	jalr	1154(ra) # 5374 <exit>
    printf("%s: read lf2 failed\n", s);
     efa:	85ca                	mv	a1,s2
     efc:	00005517          	auipc	a0,0x5
     f00:	2fc50513          	addi	a0,a0,764 # 61f8 <malloc+0xa4e>
     f04:	00004097          	auipc	ra,0x4
     f08:	7e8080e7          	jalr	2024(ra) # 56ec <printf>
    exit(1);
     f0c:	4505                	li	a0,1
     f0e:	00004097          	auipc	ra,0x4
     f12:	466080e7          	jalr	1126(ra) # 5374 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     f16:	85ca                	mv	a1,s2
     f18:	00005517          	auipc	a0,0x5
     f1c:	2f850513          	addi	a0,a0,760 # 6210 <malloc+0xa66>
     f20:	00004097          	auipc	ra,0x4
     f24:	7cc080e7          	jalr	1996(ra) # 56ec <printf>
    exit(1);
     f28:	4505                	li	a0,1
     f2a:	00004097          	auipc	ra,0x4
     f2e:	44a080e7          	jalr	1098(ra) # 5374 <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
     f32:	85ca                	mv	a1,s2
     f34:	00005517          	auipc	a0,0x5
     f38:	30450513          	addi	a0,a0,772 # 6238 <malloc+0xa8e>
     f3c:	00004097          	auipc	ra,0x4
     f40:	7b0080e7          	jalr	1968(ra) # 56ec <printf>
    exit(1);
     f44:	4505                	li	a0,1
     f46:	00004097          	auipc	ra,0x4
     f4a:	42e080e7          	jalr	1070(ra) # 5374 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     f4e:	85ca                	mv	a1,s2
     f50:	00005517          	auipc	a0,0x5
     f54:	31850513          	addi	a0,a0,792 # 6268 <malloc+0xabe>
     f58:	00004097          	auipc	ra,0x4
     f5c:	794080e7          	jalr	1940(ra) # 56ec <printf>
    exit(1);
     f60:	4505                	li	a0,1
     f62:	00004097          	auipc	ra,0x4
     f66:	412080e7          	jalr	1042(ra) # 5374 <exit>

0000000000000f6a <bigdir>:
{
     f6a:	715d                	addi	sp,sp,-80
     f6c:	e486                	sd	ra,72(sp)
     f6e:	e0a2                	sd	s0,64(sp)
     f70:	fc26                	sd	s1,56(sp)
     f72:	f84a                	sd	s2,48(sp)
     f74:	f44e                	sd	s3,40(sp)
     f76:	f052                	sd	s4,32(sp)
     f78:	ec56                	sd	s5,24(sp)
     f7a:	e85a                	sd	s6,16(sp)
     f7c:	0880                	addi	s0,sp,80
     f7e:	89aa                	mv	s3,a0
  unlink("bd");
     f80:	00005517          	auipc	a0,0x5
     f84:	30850513          	addi	a0,a0,776 # 6288 <malloc+0xade>
     f88:	00004097          	auipc	ra,0x4
     f8c:	43c080e7          	jalr	1084(ra) # 53c4 <unlink>
  fd = open("bd", O_CREATE);
     f90:	20000593          	li	a1,512
     f94:	00005517          	auipc	a0,0x5
     f98:	2f450513          	addi	a0,a0,756 # 6288 <malloc+0xade>
     f9c:	00004097          	auipc	ra,0x4
     fa0:	418080e7          	jalr	1048(ra) # 53b4 <open>
  if(fd < 0){
     fa4:	0c054963          	bltz	a0,1076 <bigdir+0x10c>
  close(fd);
     fa8:	00004097          	auipc	ra,0x4
     fac:	3f4080e7          	jalr	1012(ra) # 539c <close>
  for(i = 0; i < N; i++){
     fb0:	4901                	li	s2,0
    name[0] = 'x';
     fb2:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     fb6:	00005a17          	auipc	s4,0x5
     fba:	2d2a0a13          	addi	s4,s4,722 # 6288 <malloc+0xade>
  for(i = 0; i < N; i++){
     fbe:	1f400b13          	li	s6,500
    name[0] = 'x';
     fc2:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     fc6:	41f9579b          	sraiw	a5,s2,0x1f
     fca:	01a7d71b          	srliw	a4,a5,0x1a
     fce:	012707bb          	addw	a5,a4,s2
     fd2:	4067d69b          	sraiw	a3,a5,0x6
     fd6:	0306869b          	addiw	a3,a3,48
     fda:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     fde:	03f7f793          	andi	a5,a5,63
     fe2:	9f99                	subw	a5,a5,a4
     fe4:	0307879b          	addiw	a5,a5,48
     fe8:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     fec:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     ff0:	fb040593          	addi	a1,s0,-80
     ff4:	8552                	mv	a0,s4
     ff6:	00004097          	auipc	ra,0x4
     ffa:	3de080e7          	jalr	990(ra) # 53d4 <link>
     ffe:	84aa                	mv	s1,a0
    1000:	e949                	bnez	a0,1092 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1002:	2905                	addiw	s2,s2,1
    1004:	fb691fe3          	bne	s2,s6,fc2 <bigdir+0x58>
  unlink("bd");
    1008:	00005517          	auipc	a0,0x5
    100c:	28050513          	addi	a0,a0,640 # 6288 <malloc+0xade>
    1010:	00004097          	auipc	ra,0x4
    1014:	3b4080e7          	jalr	948(ra) # 53c4 <unlink>
    name[0] = 'x';
    1018:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    101c:	1f400a13          	li	s4,500
    name[0] = 'x';
    1020:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1024:	41f4d79b          	sraiw	a5,s1,0x1f
    1028:	01a7d71b          	srliw	a4,a5,0x1a
    102c:	009707bb          	addw	a5,a4,s1
    1030:	4067d69b          	sraiw	a3,a5,0x6
    1034:	0306869b          	addiw	a3,a3,48
    1038:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    103c:	03f7f793          	andi	a5,a5,63
    1040:	9f99                	subw	a5,a5,a4
    1042:	0307879b          	addiw	a5,a5,48
    1046:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    104a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    104e:	fb040513          	addi	a0,s0,-80
    1052:	00004097          	auipc	ra,0x4
    1056:	372080e7          	jalr	882(ra) # 53c4 <unlink>
    105a:	ed21                	bnez	a0,10b2 <bigdir+0x148>
  for(i = 0; i < N; i++){
    105c:	2485                	addiw	s1,s1,1
    105e:	fd4491e3          	bne	s1,s4,1020 <bigdir+0xb6>
}
    1062:	60a6                	ld	ra,72(sp)
    1064:	6406                	ld	s0,64(sp)
    1066:	74e2                	ld	s1,56(sp)
    1068:	7942                	ld	s2,48(sp)
    106a:	79a2                	ld	s3,40(sp)
    106c:	7a02                	ld	s4,32(sp)
    106e:	6ae2                	ld	s5,24(sp)
    1070:	6b42                	ld	s6,16(sp)
    1072:	6161                	addi	sp,sp,80
    1074:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1076:	85ce                	mv	a1,s3
    1078:	00005517          	auipc	a0,0x5
    107c:	21850513          	addi	a0,a0,536 # 6290 <malloc+0xae6>
    1080:	00004097          	auipc	ra,0x4
    1084:	66c080e7          	jalr	1644(ra) # 56ec <printf>
    exit(1);
    1088:	4505                	li	a0,1
    108a:	00004097          	auipc	ra,0x4
    108e:	2ea080e7          	jalr	746(ra) # 5374 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    1092:	fb040613          	addi	a2,s0,-80
    1096:	85ce                	mv	a1,s3
    1098:	00005517          	auipc	a0,0x5
    109c:	21850513          	addi	a0,a0,536 # 62b0 <malloc+0xb06>
    10a0:	00004097          	auipc	ra,0x4
    10a4:	64c080e7          	jalr	1612(ra) # 56ec <printf>
      exit(1);
    10a8:	4505                	li	a0,1
    10aa:	00004097          	auipc	ra,0x4
    10ae:	2ca080e7          	jalr	714(ra) # 5374 <exit>
      printf("%s: bigdir unlink failed", s);
    10b2:	85ce                	mv	a1,s3
    10b4:	00005517          	auipc	a0,0x5
    10b8:	21c50513          	addi	a0,a0,540 # 62d0 <malloc+0xb26>
    10bc:	00004097          	auipc	ra,0x4
    10c0:	630080e7          	jalr	1584(ra) # 56ec <printf>
      exit(1);
    10c4:	4505                	li	a0,1
    10c6:	00004097          	auipc	ra,0x4
    10ca:	2ae080e7          	jalr	686(ra) # 5374 <exit>

00000000000010ce <validatetest>:
{
    10ce:	7139                	addi	sp,sp,-64
    10d0:	fc06                	sd	ra,56(sp)
    10d2:	f822                	sd	s0,48(sp)
    10d4:	f426                	sd	s1,40(sp)
    10d6:	f04a                	sd	s2,32(sp)
    10d8:	ec4e                	sd	s3,24(sp)
    10da:	e852                	sd	s4,16(sp)
    10dc:	e456                	sd	s5,8(sp)
    10de:	e05a                	sd	s6,0(sp)
    10e0:	0080                	addi	s0,sp,64
    10e2:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10e4:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    10e6:	00005997          	auipc	s3,0x5
    10ea:	20a98993          	addi	s3,s3,522 # 62f0 <malloc+0xb46>
    10ee:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    10f0:	6a85                	lui	s5,0x1
    10f2:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    10f6:	85a6                	mv	a1,s1
    10f8:	854e                	mv	a0,s3
    10fa:	00004097          	auipc	ra,0x4
    10fe:	2da080e7          	jalr	730(ra) # 53d4 <link>
    1102:	01251f63          	bne	a0,s2,1120 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1106:	94d6                	add	s1,s1,s5
    1108:	ff4497e3          	bne	s1,s4,10f6 <validatetest+0x28>
}
    110c:	70e2                	ld	ra,56(sp)
    110e:	7442                	ld	s0,48(sp)
    1110:	74a2                	ld	s1,40(sp)
    1112:	7902                	ld	s2,32(sp)
    1114:	69e2                	ld	s3,24(sp)
    1116:	6a42                	ld	s4,16(sp)
    1118:	6aa2                	ld	s5,8(sp)
    111a:	6b02                	ld	s6,0(sp)
    111c:	6121                	addi	sp,sp,64
    111e:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1120:	85da                	mv	a1,s6
    1122:	00005517          	auipc	a0,0x5
    1126:	1de50513          	addi	a0,a0,478 # 6300 <malloc+0xb56>
    112a:	00004097          	auipc	ra,0x4
    112e:	5c2080e7          	jalr	1474(ra) # 56ec <printf>
      exit(1);
    1132:	4505                	li	a0,1
    1134:	00004097          	auipc	ra,0x4
    1138:	240080e7          	jalr	576(ra) # 5374 <exit>

000000000000113c <pgbug>:
// regression test. copyin(), copyout(), and copyinstr() used to cast
// the virtual page address to uint, which (with certain wild system
// call arguments) resulted in a kernel page faults.
void
pgbug(char *s)
{
    113c:	7179                	addi	sp,sp,-48
    113e:	f406                	sd	ra,40(sp)
    1140:	f022                	sd	s0,32(sp)
    1142:	ec26                	sd	s1,24(sp)
    1144:	1800                	addi	s0,sp,48
  char *argv[1];
  argv[0] = 0;
    1146:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    114a:	00007497          	auipc	s1,0x7
    114e:	dae4b483          	ld	s1,-594(s1) # 7ef8 <__SDATA_BEGIN__>
    1152:	fd840593          	addi	a1,s0,-40
    1156:	8526                	mv	a0,s1
    1158:	00004097          	auipc	ra,0x4
    115c:	254080e7          	jalr	596(ra) # 53ac <exec>

  pipe((int*)0xeaeb0b5b00002f5e);
    1160:	8526                	mv	a0,s1
    1162:	00004097          	auipc	ra,0x4
    1166:	222080e7          	jalr	546(ra) # 5384 <pipe>

  exit(0);
    116a:	4501                	li	a0,0
    116c:	00004097          	auipc	ra,0x4
    1170:	208080e7          	jalr	520(ra) # 5374 <exit>

0000000000001174 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1174:	7139                	addi	sp,sp,-64
    1176:	fc06                	sd	ra,56(sp)
    1178:	f822                	sd	s0,48(sp)
    117a:	f426                	sd	s1,40(sp)
    117c:	f04a                	sd	s2,32(sp)
    117e:	ec4e                	sd	s3,24(sp)
    1180:	0080                	addi	s0,sp,64
    1182:	64b1                	lui	s1,0xc
    1184:	35048493          	addi	s1,s1,848 # c350 <buf+0xc20>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1188:	597d                	li	s2,-1
    118a:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    118e:	00005997          	auipc	s3,0x5
    1192:	a3a98993          	addi	s3,s3,-1478 # 5bc8 <malloc+0x41e>
    argv[0] = (char*)0xffffffff;
    1196:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    119a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    119e:	fc040593          	addi	a1,s0,-64
    11a2:	854e                	mv	a0,s3
    11a4:	00004097          	auipc	ra,0x4
    11a8:	208080e7          	jalr	520(ra) # 53ac <exec>
  for(int i = 0; i < 50000; i++){
    11ac:	34fd                	addiw	s1,s1,-1
    11ae:	f4e5                	bnez	s1,1196 <badarg+0x22>
  }
  
  exit(0);
    11b0:	4501                	li	a0,0
    11b2:	00004097          	auipc	ra,0x4
    11b6:	1c2080e7          	jalr	450(ra) # 5374 <exit>

00000000000011ba <copyinstr2>:
{
    11ba:	7155                	addi	sp,sp,-208
    11bc:	e586                	sd	ra,200(sp)
    11be:	e1a2                	sd	s0,192(sp)
    11c0:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    11c2:	f6840793          	addi	a5,s0,-152
    11c6:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    11ca:	07800713          	li	a4,120
    11ce:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    11d2:	0785                	addi	a5,a5,1
    11d4:	fed79de3          	bne	a5,a3,11ce <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    11d8:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    11dc:	f6840513          	addi	a0,s0,-152
    11e0:	00004097          	auipc	ra,0x4
    11e4:	1e4080e7          	jalr	484(ra) # 53c4 <unlink>
  if(ret != -1){
    11e8:	57fd                	li	a5,-1
    11ea:	0ef51063          	bne	a0,a5,12ca <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    11ee:	20100593          	li	a1,513
    11f2:	f6840513          	addi	a0,s0,-152
    11f6:	00004097          	auipc	ra,0x4
    11fa:	1be080e7          	jalr	446(ra) # 53b4 <open>
  if(fd != -1){
    11fe:	57fd                	li	a5,-1
    1200:	0ef51563          	bne	a0,a5,12ea <copyinstr2+0x130>
  ret = link(b, b);
    1204:	f6840593          	addi	a1,s0,-152
    1208:	852e                	mv	a0,a1
    120a:	00004097          	auipc	ra,0x4
    120e:	1ca080e7          	jalr	458(ra) # 53d4 <link>
  if(ret != -1){
    1212:	57fd                	li	a5,-1
    1214:	0ef51b63          	bne	a0,a5,130a <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    1218:	00006797          	auipc	a5,0x6
    121c:	1a878793          	addi	a5,a5,424 # 73c0 <malloc+0x1c16>
    1220:	f4f43c23          	sd	a5,-168(s0)
    1224:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1228:	f5840593          	addi	a1,s0,-168
    122c:	f6840513          	addi	a0,s0,-152
    1230:	00004097          	auipc	ra,0x4
    1234:	17c080e7          	jalr	380(ra) # 53ac <exec>
  if(ret != -1){
    1238:	57fd                	li	a5,-1
    123a:	0ef51963          	bne	a0,a5,132c <copyinstr2+0x172>
  int pid = fork();
    123e:	00004097          	auipc	ra,0x4
    1242:	12e080e7          	jalr	302(ra) # 536c <fork>
  if(pid < 0){
    1246:	10054363          	bltz	a0,134c <copyinstr2+0x192>
  if(pid == 0){
    124a:	12051463          	bnez	a0,1372 <copyinstr2+0x1b8>
    124e:	00007797          	auipc	a5,0x7
    1252:	dca78793          	addi	a5,a5,-566 # 8018 <big.1265>
    1256:	00008697          	auipc	a3,0x8
    125a:	dc268693          	addi	a3,a3,-574 # 9018 <__global_pointer$+0x920>
      big[i] = 'x';
    125e:	07800713          	li	a4,120
    1262:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    1266:	0785                	addi	a5,a5,1
    1268:	fed79de3          	bne	a5,a3,1262 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    126c:	00008797          	auipc	a5,0x8
    1270:	da078623          	sb	zero,-596(a5) # 9018 <__global_pointer$+0x920>
    char *args2[] = { big, big, big, 0 };
    1274:	00007797          	auipc	a5,0x7
    1278:	8c478793          	addi	a5,a5,-1852 # 7b38 <malloc+0x238e>
    127c:	6390                	ld	a2,0(a5)
    127e:	6794                	ld	a3,8(a5)
    1280:	6b98                	ld	a4,16(a5)
    1282:	6f9c                	ld	a5,24(a5)
    1284:	f2c43823          	sd	a2,-208(s0)
    1288:	f2d43c23          	sd	a3,-200(s0)
    128c:	f4e43023          	sd	a4,-192(s0)
    1290:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1294:	f3040593          	addi	a1,s0,-208
    1298:	00005517          	auipc	a0,0x5
    129c:	93050513          	addi	a0,a0,-1744 # 5bc8 <malloc+0x41e>
    12a0:	00004097          	auipc	ra,0x4
    12a4:	10c080e7          	jalr	268(ra) # 53ac <exec>
    if(ret != -1){
    12a8:	57fd                	li	a5,-1
    12aa:	0af50e63          	beq	a0,a5,1366 <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    12ae:	55fd                	li	a1,-1
    12b0:	00005517          	auipc	a0,0x5
    12b4:	0f850513          	addi	a0,a0,248 # 63a8 <malloc+0xbfe>
    12b8:	00004097          	auipc	ra,0x4
    12bc:	434080e7          	jalr	1076(ra) # 56ec <printf>
      exit(1);
    12c0:	4505                	li	a0,1
    12c2:	00004097          	auipc	ra,0x4
    12c6:	0b2080e7          	jalr	178(ra) # 5374 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    12ca:	862a                	mv	a2,a0
    12cc:	f6840593          	addi	a1,s0,-152
    12d0:	00005517          	auipc	a0,0x5
    12d4:	05050513          	addi	a0,a0,80 # 6320 <malloc+0xb76>
    12d8:	00004097          	auipc	ra,0x4
    12dc:	414080e7          	jalr	1044(ra) # 56ec <printf>
    exit(1);
    12e0:	4505                	li	a0,1
    12e2:	00004097          	auipc	ra,0x4
    12e6:	092080e7          	jalr	146(ra) # 5374 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    12ea:	862a                	mv	a2,a0
    12ec:	f6840593          	addi	a1,s0,-152
    12f0:	00005517          	auipc	a0,0x5
    12f4:	05050513          	addi	a0,a0,80 # 6340 <malloc+0xb96>
    12f8:	00004097          	auipc	ra,0x4
    12fc:	3f4080e7          	jalr	1012(ra) # 56ec <printf>
    exit(1);
    1300:	4505                	li	a0,1
    1302:	00004097          	auipc	ra,0x4
    1306:	072080e7          	jalr	114(ra) # 5374 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    130a:	86aa                	mv	a3,a0
    130c:	f6840613          	addi	a2,s0,-152
    1310:	85b2                	mv	a1,a2
    1312:	00005517          	auipc	a0,0x5
    1316:	04e50513          	addi	a0,a0,78 # 6360 <malloc+0xbb6>
    131a:	00004097          	auipc	ra,0x4
    131e:	3d2080e7          	jalr	978(ra) # 56ec <printf>
    exit(1);
    1322:	4505                	li	a0,1
    1324:	00004097          	auipc	ra,0x4
    1328:	050080e7          	jalr	80(ra) # 5374 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    132c:	567d                	li	a2,-1
    132e:	f6840593          	addi	a1,s0,-152
    1332:	00005517          	auipc	a0,0x5
    1336:	05650513          	addi	a0,a0,86 # 6388 <malloc+0xbde>
    133a:	00004097          	auipc	ra,0x4
    133e:	3b2080e7          	jalr	946(ra) # 56ec <printf>
    exit(1);
    1342:	4505                	li	a0,1
    1344:	00004097          	auipc	ra,0x4
    1348:	030080e7          	jalr	48(ra) # 5374 <exit>
    printf("fork failed\n");
    134c:	00005517          	auipc	a0,0x5
    1350:	4a450513          	addi	a0,a0,1188 # 67f0 <malloc+0x1046>
    1354:	00004097          	auipc	ra,0x4
    1358:	398080e7          	jalr	920(ra) # 56ec <printf>
    exit(1);
    135c:	4505                	li	a0,1
    135e:	00004097          	auipc	ra,0x4
    1362:	016080e7          	jalr	22(ra) # 5374 <exit>
    exit(747); // OK
    1366:	2eb00513          	li	a0,747
    136a:	00004097          	auipc	ra,0x4
    136e:	00a080e7          	jalr	10(ra) # 5374 <exit>
  int st = 0;
    1372:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1376:	f5440513          	addi	a0,s0,-172
    137a:	00004097          	auipc	ra,0x4
    137e:	002080e7          	jalr	2(ra) # 537c <wait>
  if(st != 747){
    1382:	f5442703          	lw	a4,-172(s0)
    1386:	2eb00793          	li	a5,747
    138a:	00f71663          	bne	a4,a5,1396 <copyinstr2+0x1dc>
}
    138e:	60ae                	ld	ra,200(sp)
    1390:	640e                	ld	s0,192(sp)
    1392:	6169                	addi	sp,sp,208
    1394:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1396:	00005517          	auipc	a0,0x5
    139a:	03a50513          	addi	a0,a0,58 # 63d0 <malloc+0xc26>
    139e:	00004097          	auipc	ra,0x4
    13a2:	34e080e7          	jalr	846(ra) # 56ec <printf>
    exit(1);
    13a6:	4505                	li	a0,1
    13a8:	00004097          	auipc	ra,0x4
    13ac:	fcc080e7          	jalr	-52(ra) # 5374 <exit>

00000000000013b0 <truncate3>:
{
    13b0:	7159                	addi	sp,sp,-112
    13b2:	f486                	sd	ra,104(sp)
    13b4:	f0a2                	sd	s0,96(sp)
    13b6:	eca6                	sd	s1,88(sp)
    13b8:	e8ca                	sd	s2,80(sp)
    13ba:	e4ce                	sd	s3,72(sp)
    13bc:	e0d2                	sd	s4,64(sp)
    13be:	fc56                	sd	s5,56(sp)
    13c0:	1880                	addi	s0,sp,112
    13c2:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    13c4:	60100593          	li	a1,1537
    13c8:	00005517          	auipc	a0,0x5
    13cc:	85850513          	addi	a0,a0,-1960 # 5c20 <malloc+0x476>
    13d0:	00004097          	auipc	ra,0x4
    13d4:	fe4080e7          	jalr	-28(ra) # 53b4 <open>
    13d8:	00004097          	auipc	ra,0x4
    13dc:	fc4080e7          	jalr	-60(ra) # 539c <close>
  pid = fork();
    13e0:	00004097          	auipc	ra,0x4
    13e4:	f8c080e7          	jalr	-116(ra) # 536c <fork>
  if(pid < 0){
    13e8:	08054063          	bltz	a0,1468 <truncate3+0xb8>
  if(pid == 0){
    13ec:	e969                	bnez	a0,14be <truncate3+0x10e>
    13ee:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    13f2:	00005a17          	auipc	s4,0x5
    13f6:	82ea0a13          	addi	s4,s4,-2002 # 5c20 <malloc+0x476>
      int n = write(fd, "1234567890", 10);
    13fa:	00005a97          	auipc	s5,0x5
    13fe:	036a8a93          	addi	s5,s5,54 # 6430 <malloc+0xc86>
      int fd = open("truncfile", O_WRONLY);
    1402:	4585                	li	a1,1
    1404:	8552                	mv	a0,s4
    1406:	00004097          	auipc	ra,0x4
    140a:	fae080e7          	jalr	-82(ra) # 53b4 <open>
    140e:	84aa                	mv	s1,a0
      if(fd < 0){
    1410:	06054a63          	bltz	a0,1484 <truncate3+0xd4>
      int n = write(fd, "1234567890", 10);
    1414:	4629                	li	a2,10
    1416:	85d6                	mv	a1,s5
    1418:	00004097          	auipc	ra,0x4
    141c:	f7c080e7          	jalr	-132(ra) # 5394 <write>
      if(n != 10){
    1420:	47a9                	li	a5,10
    1422:	06f51f63          	bne	a0,a5,14a0 <truncate3+0xf0>
      close(fd);
    1426:	8526                	mv	a0,s1
    1428:	00004097          	auipc	ra,0x4
    142c:	f74080e7          	jalr	-140(ra) # 539c <close>
      fd = open("truncfile", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	8552                	mv	a0,s4
    1434:	00004097          	auipc	ra,0x4
    1438:	f80080e7          	jalr	-128(ra) # 53b4 <open>
    143c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    143e:	02000613          	li	a2,32
    1442:	f9840593          	addi	a1,s0,-104
    1446:	00004097          	auipc	ra,0x4
    144a:	f46080e7          	jalr	-186(ra) # 538c <read>
      close(fd);
    144e:	8526                	mv	a0,s1
    1450:	00004097          	auipc	ra,0x4
    1454:	f4c080e7          	jalr	-180(ra) # 539c <close>
    for(int i = 0; i < 100; i++){
    1458:	39fd                	addiw	s3,s3,-1
    145a:	fa0994e3          	bnez	s3,1402 <truncate3+0x52>
    exit(0);
    145e:	4501                	li	a0,0
    1460:	00004097          	auipc	ra,0x4
    1464:	f14080e7          	jalr	-236(ra) # 5374 <exit>
    printf("%s: fork failed\n", s);
    1468:	85ca                	mv	a1,s2
    146a:	00005517          	auipc	a0,0x5
    146e:	f9650513          	addi	a0,a0,-106 # 6400 <malloc+0xc56>
    1472:	00004097          	auipc	ra,0x4
    1476:	27a080e7          	jalr	634(ra) # 56ec <printf>
    exit(1);
    147a:	4505                	li	a0,1
    147c:	00004097          	auipc	ra,0x4
    1480:	ef8080e7          	jalr	-264(ra) # 5374 <exit>
        printf("%s: open failed\n", s);
    1484:	85ca                	mv	a1,s2
    1486:	00005517          	auipc	a0,0x5
    148a:	f9250513          	addi	a0,a0,-110 # 6418 <malloc+0xc6e>
    148e:	00004097          	auipc	ra,0x4
    1492:	25e080e7          	jalr	606(ra) # 56ec <printf>
        exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	edc080e7          	jalr	-292(ra) # 5374 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    14a0:	862a                	mv	a2,a0
    14a2:	85ca                	mv	a1,s2
    14a4:	00005517          	auipc	a0,0x5
    14a8:	f9c50513          	addi	a0,a0,-100 # 6440 <malloc+0xc96>
    14ac:	00004097          	auipc	ra,0x4
    14b0:	240080e7          	jalr	576(ra) # 56ec <printf>
        exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00004097          	auipc	ra,0x4
    14ba:	ebe080e7          	jalr	-322(ra) # 5374 <exit>
    14be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14c2:	00004a17          	auipc	s4,0x4
    14c6:	75ea0a13          	addi	s4,s4,1886 # 5c20 <malloc+0x476>
    int n = write(fd, "xxx", 3);
    14ca:	00005a97          	auipc	s5,0x5
    14ce:	f96a8a93          	addi	s5,s5,-106 # 6460 <malloc+0xcb6>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    14d2:	60100593          	li	a1,1537
    14d6:	8552                	mv	a0,s4
    14d8:	00004097          	auipc	ra,0x4
    14dc:	edc080e7          	jalr	-292(ra) # 53b4 <open>
    14e0:	84aa                	mv	s1,a0
    if(fd < 0){
    14e2:	04054763          	bltz	a0,1530 <truncate3+0x180>
    int n = write(fd, "xxx", 3);
    14e6:	460d                	li	a2,3
    14e8:	85d6                	mv	a1,s5
    14ea:	00004097          	auipc	ra,0x4
    14ee:	eaa080e7          	jalr	-342(ra) # 5394 <write>
    if(n != 3){
    14f2:	478d                	li	a5,3
    14f4:	04f51c63          	bne	a0,a5,154c <truncate3+0x19c>
    close(fd);
    14f8:	8526                	mv	a0,s1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	ea2080e7          	jalr	-350(ra) # 539c <close>
  for(int i = 0; i < 150; i++){
    1502:	39fd                	addiw	s3,s3,-1
    1504:	fc0997e3          	bnez	s3,14d2 <truncate3+0x122>
  wait(&xstatus);
    1508:	fbc40513          	addi	a0,s0,-68
    150c:	00004097          	auipc	ra,0x4
    1510:	e70080e7          	jalr	-400(ra) # 537c <wait>
  unlink("truncfile");
    1514:	00004517          	auipc	a0,0x4
    1518:	70c50513          	addi	a0,a0,1804 # 5c20 <malloc+0x476>
    151c:	00004097          	auipc	ra,0x4
    1520:	ea8080e7          	jalr	-344(ra) # 53c4 <unlink>
  exit(xstatus);
    1524:	fbc42503          	lw	a0,-68(s0)
    1528:	00004097          	auipc	ra,0x4
    152c:	e4c080e7          	jalr	-436(ra) # 5374 <exit>
      printf("%s: open failed\n", s);
    1530:	85ca                	mv	a1,s2
    1532:	00005517          	auipc	a0,0x5
    1536:	ee650513          	addi	a0,a0,-282 # 6418 <malloc+0xc6e>
    153a:	00004097          	auipc	ra,0x4
    153e:	1b2080e7          	jalr	434(ra) # 56ec <printf>
      exit(1);
    1542:	4505                	li	a0,1
    1544:	00004097          	auipc	ra,0x4
    1548:	e30080e7          	jalr	-464(ra) # 5374 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    154c:	862a                	mv	a2,a0
    154e:	85ca                	mv	a1,s2
    1550:	00005517          	auipc	a0,0x5
    1554:	f1850513          	addi	a0,a0,-232 # 6468 <malloc+0xcbe>
    1558:	00004097          	auipc	ra,0x4
    155c:	194080e7          	jalr	404(ra) # 56ec <printf>
      exit(1);
    1560:	4505                	li	a0,1
    1562:	00004097          	auipc	ra,0x4
    1566:	e12080e7          	jalr	-494(ra) # 5374 <exit>

000000000000156a <exectest>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	0880                	addi	s0,sp,80
    1576:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    1578:	00004797          	auipc	a5,0x4
    157c:	65078793          	addi	a5,a5,1616 # 5bc8 <malloc+0x41e>
    1580:	fcf43023          	sd	a5,-64(s0)
    1584:	00005797          	auipc	a5,0x5
    1588:	f0478793          	addi	a5,a5,-252 # 6488 <malloc+0xcde>
    158c:	fcf43423          	sd	a5,-56(s0)
    1590:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1594:	00005517          	auipc	a0,0x5
    1598:	efc50513          	addi	a0,a0,-260 # 6490 <malloc+0xce6>
    159c:	00004097          	auipc	ra,0x4
    15a0:	e28080e7          	jalr	-472(ra) # 53c4 <unlink>
  pid = fork();
    15a4:	00004097          	auipc	ra,0x4
    15a8:	dc8080e7          	jalr	-568(ra) # 536c <fork>
  if(pid < 0) {
    15ac:	04054663          	bltz	a0,15f8 <exectest+0x8e>
    15b0:	84aa                	mv	s1,a0
  if(pid == 0) {
    15b2:	e959                	bnez	a0,1648 <exectest+0xde>
    close(1);
    15b4:	4505                	li	a0,1
    15b6:	00004097          	auipc	ra,0x4
    15ba:	de6080e7          	jalr	-538(ra) # 539c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    15be:	20100593          	li	a1,513
    15c2:	00005517          	auipc	a0,0x5
    15c6:	ece50513          	addi	a0,a0,-306 # 6490 <malloc+0xce6>
    15ca:	00004097          	auipc	ra,0x4
    15ce:	dea080e7          	jalr	-534(ra) # 53b4 <open>
    if(fd < 0) {
    15d2:	04054163          	bltz	a0,1614 <exectest+0xaa>
    if(fd != 1) {
    15d6:	4785                	li	a5,1
    15d8:	04f50c63          	beq	a0,a5,1630 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    15dc:	85ca                	mv	a1,s2
    15de:	00005517          	auipc	a0,0x5
    15e2:	ed250513          	addi	a0,a0,-302 # 64b0 <malloc+0xd06>
    15e6:	00004097          	auipc	ra,0x4
    15ea:	106080e7          	jalr	262(ra) # 56ec <printf>
      exit(1);
    15ee:	4505                	li	a0,1
    15f0:	00004097          	auipc	ra,0x4
    15f4:	d84080e7          	jalr	-636(ra) # 5374 <exit>
     printf("%s: fork failed\n", s);
    15f8:	85ca                	mv	a1,s2
    15fa:	00005517          	auipc	a0,0x5
    15fe:	e0650513          	addi	a0,a0,-506 # 6400 <malloc+0xc56>
    1602:	00004097          	auipc	ra,0x4
    1606:	0ea080e7          	jalr	234(ra) # 56ec <printf>
     exit(1);
    160a:	4505                	li	a0,1
    160c:	00004097          	auipc	ra,0x4
    1610:	d68080e7          	jalr	-664(ra) # 5374 <exit>
      printf("%s: create failed\n", s);
    1614:	85ca                	mv	a1,s2
    1616:	00005517          	auipc	a0,0x5
    161a:	e8250513          	addi	a0,a0,-382 # 6498 <malloc+0xcee>
    161e:	00004097          	auipc	ra,0x4
    1622:	0ce080e7          	jalr	206(ra) # 56ec <printf>
      exit(1);
    1626:	4505                	li	a0,1
    1628:	00004097          	auipc	ra,0x4
    162c:	d4c080e7          	jalr	-692(ra) # 5374 <exit>
    if(exec("echo", echoargv) < 0){
    1630:	fc040593          	addi	a1,s0,-64
    1634:	00004517          	auipc	a0,0x4
    1638:	59450513          	addi	a0,a0,1428 # 5bc8 <malloc+0x41e>
    163c:	00004097          	auipc	ra,0x4
    1640:	d70080e7          	jalr	-656(ra) # 53ac <exec>
    1644:	02054163          	bltz	a0,1666 <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    1648:	fdc40513          	addi	a0,s0,-36
    164c:	00004097          	auipc	ra,0x4
    1650:	d30080e7          	jalr	-720(ra) # 537c <wait>
    1654:	02951763          	bne	a0,s1,1682 <exectest+0x118>
  if(xstatus != 0)
    1658:	fdc42503          	lw	a0,-36(s0)
    165c:	cd0d                	beqz	a0,1696 <exectest+0x12c>
    exit(xstatus);
    165e:	00004097          	auipc	ra,0x4
    1662:	d16080e7          	jalr	-746(ra) # 5374 <exit>
      printf("%s: exec echo failed\n", s);
    1666:	85ca                	mv	a1,s2
    1668:	00005517          	auipc	a0,0x5
    166c:	e5850513          	addi	a0,a0,-424 # 64c0 <malloc+0xd16>
    1670:	00004097          	auipc	ra,0x4
    1674:	07c080e7          	jalr	124(ra) # 56ec <printf>
      exit(1);
    1678:	4505                	li	a0,1
    167a:	00004097          	auipc	ra,0x4
    167e:	cfa080e7          	jalr	-774(ra) # 5374 <exit>
    printf("%s: wait failed!\n", s);
    1682:	85ca                	mv	a1,s2
    1684:	00005517          	auipc	a0,0x5
    1688:	e5450513          	addi	a0,a0,-428 # 64d8 <malloc+0xd2e>
    168c:	00004097          	auipc	ra,0x4
    1690:	060080e7          	jalr	96(ra) # 56ec <printf>
    1694:	b7d1                	j	1658 <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    1696:	4581                	li	a1,0
    1698:	00005517          	auipc	a0,0x5
    169c:	df850513          	addi	a0,a0,-520 # 6490 <malloc+0xce6>
    16a0:	00004097          	auipc	ra,0x4
    16a4:	d14080e7          	jalr	-748(ra) # 53b4 <open>
  if(fd < 0) {
    16a8:	02054a63          	bltz	a0,16dc <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    16ac:	4609                	li	a2,2
    16ae:	fb840593          	addi	a1,s0,-72
    16b2:	00004097          	auipc	ra,0x4
    16b6:	cda080e7          	jalr	-806(ra) # 538c <read>
    16ba:	4789                	li	a5,2
    16bc:	02f50e63          	beq	a0,a5,16f8 <exectest+0x18e>
    printf("%s: read failed\n", s);
    16c0:	85ca                	mv	a1,s2
    16c2:	00005517          	auipc	a0,0x5
    16c6:	89650513          	addi	a0,a0,-1898 # 5f58 <malloc+0x7ae>
    16ca:	00004097          	auipc	ra,0x4
    16ce:	022080e7          	jalr	34(ra) # 56ec <printf>
    exit(1);
    16d2:	4505                	li	a0,1
    16d4:	00004097          	auipc	ra,0x4
    16d8:	ca0080e7          	jalr	-864(ra) # 5374 <exit>
    printf("%s: open failed\n", s);
    16dc:	85ca                	mv	a1,s2
    16de:	00005517          	auipc	a0,0x5
    16e2:	d3a50513          	addi	a0,a0,-710 # 6418 <malloc+0xc6e>
    16e6:	00004097          	auipc	ra,0x4
    16ea:	006080e7          	jalr	6(ra) # 56ec <printf>
    exit(1);
    16ee:	4505                	li	a0,1
    16f0:	00004097          	auipc	ra,0x4
    16f4:	c84080e7          	jalr	-892(ra) # 5374 <exit>
  unlink("echo-ok");
    16f8:	00005517          	auipc	a0,0x5
    16fc:	d9850513          	addi	a0,a0,-616 # 6490 <malloc+0xce6>
    1700:	00004097          	auipc	ra,0x4
    1704:	cc4080e7          	jalr	-828(ra) # 53c4 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1708:	fb844703          	lbu	a4,-72(s0)
    170c:	04f00793          	li	a5,79
    1710:	00f71863          	bne	a4,a5,1720 <exectest+0x1b6>
    1714:	fb944703          	lbu	a4,-71(s0)
    1718:	04b00793          	li	a5,75
    171c:	02f70063          	beq	a4,a5,173c <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    1720:	85ca                	mv	a1,s2
    1722:	00005517          	auipc	a0,0x5
    1726:	dce50513          	addi	a0,a0,-562 # 64f0 <malloc+0xd46>
    172a:	00004097          	auipc	ra,0x4
    172e:	fc2080e7          	jalr	-62(ra) # 56ec <printf>
    exit(1);
    1732:	4505                	li	a0,1
    1734:	00004097          	auipc	ra,0x4
    1738:	c40080e7          	jalr	-960(ra) # 5374 <exit>
    exit(0);
    173c:	4501                	li	a0,0
    173e:	00004097          	auipc	ra,0x4
    1742:	c36080e7          	jalr	-970(ra) # 5374 <exit>

0000000000001746 <pipe1>:
{
    1746:	711d                	addi	sp,sp,-96
    1748:	ec86                	sd	ra,88(sp)
    174a:	e8a2                	sd	s0,80(sp)
    174c:	e4a6                	sd	s1,72(sp)
    174e:	e0ca                	sd	s2,64(sp)
    1750:	fc4e                	sd	s3,56(sp)
    1752:	f852                	sd	s4,48(sp)
    1754:	f456                	sd	s5,40(sp)
    1756:	f05a                	sd	s6,32(sp)
    1758:	ec5e                	sd	s7,24(sp)
    175a:	1080                	addi	s0,sp,96
    175c:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    175e:	fa840513          	addi	a0,s0,-88
    1762:	00004097          	auipc	ra,0x4
    1766:	c22080e7          	jalr	-990(ra) # 5384 <pipe>
    176a:	ed25                	bnez	a0,17e2 <pipe1+0x9c>
    176c:	84aa                	mv	s1,a0
  pid = fork();
    176e:	00004097          	auipc	ra,0x4
    1772:	bfe080e7          	jalr	-1026(ra) # 536c <fork>
    1776:	8a2a                	mv	s4,a0
  if(pid == 0){
    1778:	c159                	beqz	a0,17fe <pipe1+0xb8>
  } else if(pid > 0){
    177a:	16a05e63          	blez	a0,18f6 <pipe1+0x1b0>
    close(fds[1]);
    177e:	fac42503          	lw	a0,-84(s0)
    1782:	00004097          	auipc	ra,0x4
    1786:	c1a080e7          	jalr	-998(ra) # 539c <close>
    total = 0;
    178a:	8a26                	mv	s4,s1
    cc = 1;
    178c:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    178e:	0000aa97          	auipc	s5,0xa
    1792:	fa2a8a93          	addi	s5,s5,-94 # b730 <buf>
      if(cc > sizeof(buf))
    1796:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    1798:	864e                	mv	a2,s3
    179a:	85d6                	mv	a1,s5
    179c:	fa842503          	lw	a0,-88(s0)
    17a0:	00004097          	auipc	ra,0x4
    17a4:	bec080e7          	jalr	-1044(ra) # 538c <read>
    17a8:	10a05263          	blez	a0,18ac <pipe1+0x166>
      for(i = 0; i < n; i++){
    17ac:	0000a717          	auipc	a4,0xa
    17b0:	f8470713          	addi	a4,a4,-124 # b730 <buf>
    17b4:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17b8:	00074683          	lbu	a3,0(a4)
    17bc:	0ff4f793          	andi	a5,s1,255
    17c0:	2485                	addiw	s1,s1,1
    17c2:	0cf69163          	bne	a3,a5,1884 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17c6:	0705                	addi	a4,a4,1
    17c8:	fec498e3          	bne	s1,a2,17b8 <pipe1+0x72>
      total += n;
    17cc:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17d0:	0019979b          	slliw	a5,s3,0x1
    17d4:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17d8:	013b7363          	bgeu	s6,s3,17de <pipe1+0x98>
        cc = sizeof(buf);
    17dc:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17de:	84b2                	mv	s1,a2
    17e0:	bf65                	j	1798 <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17e2:	85ca                	mv	a1,s2
    17e4:	00005517          	auipc	a0,0x5
    17e8:	d2450513          	addi	a0,a0,-732 # 6508 <malloc+0xd5e>
    17ec:	00004097          	auipc	ra,0x4
    17f0:	f00080e7          	jalr	-256(ra) # 56ec <printf>
    exit(1);
    17f4:	4505                	li	a0,1
    17f6:	00004097          	auipc	ra,0x4
    17fa:	b7e080e7          	jalr	-1154(ra) # 5374 <exit>
    close(fds[0]);
    17fe:	fa842503          	lw	a0,-88(s0)
    1802:	00004097          	auipc	ra,0x4
    1806:	b9a080e7          	jalr	-1126(ra) # 539c <close>
    for(n = 0; n < N; n++){
    180a:	0000ab17          	auipc	s6,0xa
    180e:	f26b0b13          	addi	s6,s6,-218 # b730 <buf>
    1812:	416004bb          	negw	s1,s6
    1816:	0ff4f493          	andi	s1,s1,255
    181a:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    181e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1820:	6a85                	lui	s5,0x1
    1822:	42da8a93          	addi	s5,s5,1069 # 142d <truncate3+0x7d>
{
    1826:	87da                	mv	a5,s6
        buf[i] = seq++;
    1828:	0097873b          	addw	a4,a5,s1
    182c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1830:	0785                	addi	a5,a5,1
    1832:	fef99be3          	bne	s3,a5,1828 <pipe1+0xe2>
    1836:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    183a:	40900613          	li	a2,1033
    183e:	85de                	mv	a1,s7
    1840:	fac42503          	lw	a0,-84(s0)
    1844:	00004097          	auipc	ra,0x4
    1848:	b50080e7          	jalr	-1200(ra) # 5394 <write>
    184c:	40900793          	li	a5,1033
    1850:	00f51c63          	bne	a0,a5,1868 <pipe1+0x122>
    for(n = 0; n < N; n++){
    1854:	24a5                	addiw	s1,s1,9
    1856:	0ff4f493          	andi	s1,s1,255
    185a:	fd5a16e3          	bne	s4,s5,1826 <pipe1+0xe0>
    exit(0);
    185e:	4501                	li	a0,0
    1860:	00004097          	auipc	ra,0x4
    1864:	b14080e7          	jalr	-1260(ra) # 5374 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1868:	85ca                	mv	a1,s2
    186a:	00005517          	auipc	a0,0x5
    186e:	cb650513          	addi	a0,a0,-842 # 6520 <malloc+0xd76>
    1872:	00004097          	auipc	ra,0x4
    1876:	e7a080e7          	jalr	-390(ra) # 56ec <printf>
        exit(1);
    187a:	4505                	li	a0,1
    187c:	00004097          	auipc	ra,0x4
    1880:	af8080e7          	jalr	-1288(ra) # 5374 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1884:	85ca                	mv	a1,s2
    1886:	00005517          	auipc	a0,0x5
    188a:	cb250513          	addi	a0,a0,-846 # 6538 <malloc+0xd8e>
    188e:	00004097          	auipc	ra,0x4
    1892:	e5e080e7          	jalr	-418(ra) # 56ec <printf>
}
    1896:	60e6                	ld	ra,88(sp)
    1898:	6446                	ld	s0,80(sp)
    189a:	64a6                	ld	s1,72(sp)
    189c:	6906                	ld	s2,64(sp)
    189e:	79e2                	ld	s3,56(sp)
    18a0:	7a42                	ld	s4,48(sp)
    18a2:	7aa2                	ld	s5,40(sp)
    18a4:	7b02                	ld	s6,32(sp)
    18a6:	6be2                	ld	s7,24(sp)
    18a8:	6125                	addi	sp,sp,96
    18aa:	8082                	ret
    if(total != N * SZ){
    18ac:	6785                	lui	a5,0x1
    18ae:	42d78793          	addi	a5,a5,1069 # 142d <truncate3+0x7d>
    18b2:	02fa0063          	beq	s4,a5,18d2 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18b6:	85d2                	mv	a1,s4
    18b8:	00005517          	auipc	a0,0x5
    18bc:	c9850513          	addi	a0,a0,-872 # 6550 <malloc+0xda6>
    18c0:	00004097          	auipc	ra,0x4
    18c4:	e2c080e7          	jalr	-468(ra) # 56ec <printf>
      exit(1);
    18c8:	4505                	li	a0,1
    18ca:	00004097          	auipc	ra,0x4
    18ce:	aaa080e7          	jalr	-1366(ra) # 5374 <exit>
    close(fds[0]);
    18d2:	fa842503          	lw	a0,-88(s0)
    18d6:	00004097          	auipc	ra,0x4
    18da:	ac6080e7          	jalr	-1338(ra) # 539c <close>
    wait(&xstatus);
    18de:	fa440513          	addi	a0,s0,-92
    18e2:	00004097          	auipc	ra,0x4
    18e6:	a9a080e7          	jalr	-1382(ra) # 537c <wait>
    exit(xstatus);
    18ea:	fa442503          	lw	a0,-92(s0)
    18ee:	00004097          	auipc	ra,0x4
    18f2:	a86080e7          	jalr	-1402(ra) # 5374 <exit>
    printf("%s: fork() failed\n", s);
    18f6:	85ca                	mv	a1,s2
    18f8:	00005517          	auipc	a0,0x5
    18fc:	c7850513          	addi	a0,a0,-904 # 6570 <malloc+0xdc6>
    1900:	00004097          	auipc	ra,0x4
    1904:	dec080e7          	jalr	-532(ra) # 56ec <printf>
    exit(1);
    1908:	4505                	li	a0,1
    190a:	00004097          	auipc	ra,0x4
    190e:	a6a080e7          	jalr	-1430(ra) # 5374 <exit>

0000000000001912 <exitwait>:
{
    1912:	7139                	addi	sp,sp,-64
    1914:	fc06                	sd	ra,56(sp)
    1916:	f822                	sd	s0,48(sp)
    1918:	f426                	sd	s1,40(sp)
    191a:	f04a                	sd	s2,32(sp)
    191c:	ec4e                	sd	s3,24(sp)
    191e:	e852                	sd	s4,16(sp)
    1920:	0080                	addi	s0,sp,64
    1922:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1924:	4901                	li	s2,0
    1926:	06400993          	li	s3,100
    pid = fork();
    192a:	00004097          	auipc	ra,0x4
    192e:	a42080e7          	jalr	-1470(ra) # 536c <fork>
    1932:	84aa                	mv	s1,a0
    if(pid < 0){
    1934:	02054a63          	bltz	a0,1968 <exitwait+0x56>
    if(pid){
    1938:	c151                	beqz	a0,19bc <exitwait+0xaa>
      if(wait(&xstate) != pid){
    193a:	fcc40513          	addi	a0,s0,-52
    193e:	00004097          	auipc	ra,0x4
    1942:	a3e080e7          	jalr	-1474(ra) # 537c <wait>
    1946:	02951f63          	bne	a0,s1,1984 <exitwait+0x72>
      if(i != xstate) {
    194a:	fcc42783          	lw	a5,-52(s0)
    194e:	05279963          	bne	a5,s2,19a0 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1952:	2905                	addiw	s2,s2,1
    1954:	fd391be3          	bne	s2,s3,192a <exitwait+0x18>
}
    1958:	70e2                	ld	ra,56(sp)
    195a:	7442                	ld	s0,48(sp)
    195c:	74a2                	ld	s1,40(sp)
    195e:	7902                	ld	s2,32(sp)
    1960:	69e2                	ld	s3,24(sp)
    1962:	6a42                	ld	s4,16(sp)
    1964:	6121                	addi	sp,sp,64
    1966:	8082                	ret
      printf("%s: fork failed\n", s);
    1968:	85d2                	mv	a1,s4
    196a:	00005517          	auipc	a0,0x5
    196e:	a9650513          	addi	a0,a0,-1386 # 6400 <malloc+0xc56>
    1972:	00004097          	auipc	ra,0x4
    1976:	d7a080e7          	jalr	-646(ra) # 56ec <printf>
      exit(1);
    197a:	4505                	li	a0,1
    197c:	00004097          	auipc	ra,0x4
    1980:	9f8080e7          	jalr	-1544(ra) # 5374 <exit>
        printf("%s: wait wrong pid\n", s);
    1984:	85d2                	mv	a1,s4
    1986:	00005517          	auipc	a0,0x5
    198a:	c0250513          	addi	a0,a0,-1022 # 6588 <malloc+0xdde>
    198e:	00004097          	auipc	ra,0x4
    1992:	d5e080e7          	jalr	-674(ra) # 56ec <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	00004097          	auipc	ra,0x4
    199c:	9dc080e7          	jalr	-1572(ra) # 5374 <exit>
        printf("%s: wait wrong exit status\n", s);
    19a0:	85d2                	mv	a1,s4
    19a2:	00005517          	auipc	a0,0x5
    19a6:	bfe50513          	addi	a0,a0,-1026 # 65a0 <malloc+0xdf6>
    19aa:	00004097          	auipc	ra,0x4
    19ae:	d42080e7          	jalr	-702(ra) # 56ec <printf>
        exit(1);
    19b2:	4505                	li	a0,1
    19b4:	00004097          	auipc	ra,0x4
    19b8:	9c0080e7          	jalr	-1600(ra) # 5374 <exit>
      exit(i);
    19bc:	854a                	mv	a0,s2
    19be:	00004097          	auipc	ra,0x4
    19c2:	9b6080e7          	jalr	-1610(ra) # 5374 <exit>

00000000000019c6 <twochildren>:
{
    19c6:	1101                	addi	sp,sp,-32
    19c8:	ec06                	sd	ra,24(sp)
    19ca:	e822                	sd	s0,16(sp)
    19cc:	e426                	sd	s1,8(sp)
    19ce:	e04a                	sd	s2,0(sp)
    19d0:	1000                	addi	s0,sp,32
    19d2:	892a                	mv	s2,a0
    19d4:	3e800493          	li	s1,1000
    int pid1 = fork();
    19d8:	00004097          	auipc	ra,0x4
    19dc:	994080e7          	jalr	-1644(ra) # 536c <fork>
    if(pid1 < 0){
    19e0:	02054c63          	bltz	a0,1a18 <twochildren+0x52>
    if(pid1 == 0){
    19e4:	c921                	beqz	a0,1a34 <twochildren+0x6e>
      int pid2 = fork();
    19e6:	00004097          	auipc	ra,0x4
    19ea:	986080e7          	jalr	-1658(ra) # 536c <fork>
      if(pid2 < 0){
    19ee:	04054763          	bltz	a0,1a3c <twochildren+0x76>
      if(pid2 == 0){
    19f2:	c13d                	beqz	a0,1a58 <twochildren+0x92>
        wait(0);
    19f4:	4501                	li	a0,0
    19f6:	00004097          	auipc	ra,0x4
    19fa:	986080e7          	jalr	-1658(ra) # 537c <wait>
        wait(0);
    19fe:	4501                	li	a0,0
    1a00:	00004097          	auipc	ra,0x4
    1a04:	97c080e7          	jalr	-1668(ra) # 537c <wait>
  for(int i = 0; i < 1000; i++){
    1a08:	34fd                	addiw	s1,s1,-1
    1a0a:	f4f9                	bnez	s1,19d8 <twochildren+0x12>
}
    1a0c:	60e2                	ld	ra,24(sp)
    1a0e:	6442                	ld	s0,16(sp)
    1a10:	64a2                	ld	s1,8(sp)
    1a12:	6902                	ld	s2,0(sp)
    1a14:	6105                	addi	sp,sp,32
    1a16:	8082                	ret
      printf("%s: fork failed\n", s);
    1a18:	85ca                	mv	a1,s2
    1a1a:	00005517          	auipc	a0,0x5
    1a1e:	9e650513          	addi	a0,a0,-1562 # 6400 <malloc+0xc56>
    1a22:	00004097          	auipc	ra,0x4
    1a26:	cca080e7          	jalr	-822(ra) # 56ec <printf>
      exit(1);
    1a2a:	4505                	li	a0,1
    1a2c:	00004097          	auipc	ra,0x4
    1a30:	948080e7          	jalr	-1720(ra) # 5374 <exit>
      exit(0);
    1a34:	00004097          	auipc	ra,0x4
    1a38:	940080e7          	jalr	-1728(ra) # 5374 <exit>
        printf("%s: fork failed\n", s);
    1a3c:	85ca                	mv	a1,s2
    1a3e:	00005517          	auipc	a0,0x5
    1a42:	9c250513          	addi	a0,a0,-1598 # 6400 <malloc+0xc56>
    1a46:	00004097          	auipc	ra,0x4
    1a4a:	ca6080e7          	jalr	-858(ra) # 56ec <printf>
        exit(1);
    1a4e:	4505                	li	a0,1
    1a50:	00004097          	auipc	ra,0x4
    1a54:	924080e7          	jalr	-1756(ra) # 5374 <exit>
        exit(0);
    1a58:	00004097          	auipc	ra,0x4
    1a5c:	91c080e7          	jalr	-1764(ra) # 5374 <exit>

0000000000001a60 <forkfork>:
{
    1a60:	7179                	addi	sp,sp,-48
    1a62:	f406                	sd	ra,40(sp)
    1a64:	f022                	sd	s0,32(sp)
    1a66:	ec26                	sd	s1,24(sp)
    1a68:	1800                	addi	s0,sp,48
    1a6a:	84aa                	mv	s1,a0
    int pid = fork();
    1a6c:	00004097          	auipc	ra,0x4
    1a70:	900080e7          	jalr	-1792(ra) # 536c <fork>
    if(pid < 0){
    1a74:	04054163          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a78:	cd29                	beqz	a0,1ad2 <forkfork+0x72>
    int pid = fork();
    1a7a:	00004097          	auipc	ra,0x4
    1a7e:	8f2080e7          	jalr	-1806(ra) # 536c <fork>
    if(pid < 0){
    1a82:	02054a63          	bltz	a0,1ab6 <forkfork+0x56>
    if(pid == 0){
    1a86:	c531                	beqz	a0,1ad2 <forkfork+0x72>
    wait(&xstatus);
    1a88:	fdc40513          	addi	a0,s0,-36
    1a8c:	00004097          	auipc	ra,0x4
    1a90:	8f0080e7          	jalr	-1808(ra) # 537c <wait>
    if(xstatus != 0) {
    1a94:	fdc42783          	lw	a5,-36(s0)
    1a98:	ebbd                	bnez	a5,1b0e <forkfork+0xae>
    wait(&xstatus);
    1a9a:	fdc40513          	addi	a0,s0,-36
    1a9e:	00004097          	auipc	ra,0x4
    1aa2:	8de080e7          	jalr	-1826(ra) # 537c <wait>
    if(xstatus != 0) {
    1aa6:	fdc42783          	lw	a5,-36(s0)
    1aaa:	e3b5                	bnez	a5,1b0e <forkfork+0xae>
}
    1aac:	70a2                	ld	ra,40(sp)
    1aae:	7402                	ld	s0,32(sp)
    1ab0:	64e2                	ld	s1,24(sp)
    1ab2:	6145                	addi	sp,sp,48
    1ab4:	8082                	ret
      printf("%s: fork failed", s);
    1ab6:	85a6                	mv	a1,s1
    1ab8:	00005517          	auipc	a0,0x5
    1abc:	b0850513          	addi	a0,a0,-1272 # 65c0 <malloc+0xe16>
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	c2c080e7          	jalr	-980(ra) # 56ec <printf>
      exit(1);
    1ac8:	4505                	li	a0,1
    1aca:	00004097          	auipc	ra,0x4
    1ace:	8aa080e7          	jalr	-1878(ra) # 5374 <exit>
{
    1ad2:	0c800493          	li	s1,200
        int pid1 = fork();
    1ad6:	00004097          	auipc	ra,0x4
    1ada:	896080e7          	jalr	-1898(ra) # 536c <fork>
        if(pid1 < 0){
    1ade:	00054f63          	bltz	a0,1afc <forkfork+0x9c>
        if(pid1 == 0){
    1ae2:	c115                	beqz	a0,1b06 <forkfork+0xa6>
        wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00004097          	auipc	ra,0x4
    1aea:	896080e7          	jalr	-1898(ra) # 537c <wait>
      for(int j = 0; j < 200; j++){
    1aee:	34fd                	addiw	s1,s1,-1
    1af0:	f0fd                	bnez	s1,1ad6 <forkfork+0x76>
      exit(0);
    1af2:	4501                	li	a0,0
    1af4:	00004097          	auipc	ra,0x4
    1af8:	880080e7          	jalr	-1920(ra) # 5374 <exit>
          exit(1);
    1afc:	4505                	li	a0,1
    1afe:	00004097          	auipc	ra,0x4
    1b02:	876080e7          	jalr	-1930(ra) # 5374 <exit>
          exit(0);
    1b06:	00004097          	auipc	ra,0x4
    1b0a:	86e080e7          	jalr	-1938(ra) # 5374 <exit>
      printf("%s: fork in child failed", s);
    1b0e:	85a6                	mv	a1,s1
    1b10:	00005517          	auipc	a0,0x5
    1b14:	ac050513          	addi	a0,a0,-1344 # 65d0 <malloc+0xe26>
    1b18:	00004097          	auipc	ra,0x4
    1b1c:	bd4080e7          	jalr	-1068(ra) # 56ec <printf>
      exit(1);
    1b20:	4505                	li	a0,1
    1b22:	00004097          	auipc	ra,0x4
    1b26:	852080e7          	jalr	-1966(ra) # 5374 <exit>

0000000000001b2a <reparent2>:
{
    1b2a:	1101                	addi	sp,sp,-32
    1b2c:	ec06                	sd	ra,24(sp)
    1b2e:	e822                	sd	s0,16(sp)
    1b30:	e426                	sd	s1,8(sp)
    1b32:	1000                	addi	s0,sp,32
    1b34:	32000493          	li	s1,800
    int pid1 = fork();
    1b38:	00004097          	auipc	ra,0x4
    1b3c:	834080e7          	jalr	-1996(ra) # 536c <fork>
    if(pid1 < 0){
    1b40:	00054f63          	bltz	a0,1b5e <reparent2+0x34>
    if(pid1 == 0){
    1b44:	c915                	beqz	a0,1b78 <reparent2+0x4e>
    wait(0);
    1b46:	4501                	li	a0,0
    1b48:	00004097          	auipc	ra,0x4
    1b4c:	834080e7          	jalr	-1996(ra) # 537c <wait>
  for(int i = 0; i < 800; i++){
    1b50:	34fd                	addiw	s1,s1,-1
    1b52:	f0fd                	bnez	s1,1b38 <reparent2+0xe>
  exit(0);
    1b54:	4501                	li	a0,0
    1b56:	00004097          	auipc	ra,0x4
    1b5a:	81e080e7          	jalr	-2018(ra) # 5374 <exit>
      printf("fork failed\n");
    1b5e:	00005517          	auipc	a0,0x5
    1b62:	c9250513          	addi	a0,a0,-878 # 67f0 <malloc+0x1046>
    1b66:	00004097          	auipc	ra,0x4
    1b6a:	b86080e7          	jalr	-1146(ra) # 56ec <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	00004097          	auipc	ra,0x4
    1b74:	804080e7          	jalr	-2044(ra) # 5374 <exit>
      fork();
    1b78:	00003097          	auipc	ra,0x3
    1b7c:	7f4080e7          	jalr	2036(ra) # 536c <fork>
      fork();
    1b80:	00003097          	auipc	ra,0x3
    1b84:	7ec080e7          	jalr	2028(ra) # 536c <fork>
      exit(0);
    1b88:	4501                	li	a0,0
    1b8a:	00003097          	auipc	ra,0x3
    1b8e:	7ea080e7          	jalr	2026(ra) # 5374 <exit>

0000000000001b92 <createdelete>:
{
    1b92:	7175                	addi	sp,sp,-144
    1b94:	e506                	sd	ra,136(sp)
    1b96:	e122                	sd	s0,128(sp)
    1b98:	fca6                	sd	s1,120(sp)
    1b9a:	f8ca                	sd	s2,112(sp)
    1b9c:	f4ce                	sd	s3,104(sp)
    1b9e:	f0d2                	sd	s4,96(sp)
    1ba0:	ecd6                	sd	s5,88(sp)
    1ba2:	e8da                	sd	s6,80(sp)
    1ba4:	e4de                	sd	s7,72(sp)
    1ba6:	e0e2                	sd	s8,64(sp)
    1ba8:	fc66                	sd	s9,56(sp)
    1baa:	0900                	addi	s0,sp,144
    1bac:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1bae:	4901                	li	s2,0
    1bb0:	4991                	li	s3,4
    pid = fork();
    1bb2:	00003097          	auipc	ra,0x3
    1bb6:	7ba080e7          	jalr	1978(ra) # 536c <fork>
    1bba:	84aa                	mv	s1,a0
    if(pid < 0){
    1bbc:	02054f63          	bltz	a0,1bfa <createdelete+0x68>
    if(pid == 0){
    1bc0:	c939                	beqz	a0,1c16 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1bc2:	2905                	addiw	s2,s2,1
    1bc4:	ff3917e3          	bne	s2,s3,1bb2 <createdelete+0x20>
    1bc8:	4491                	li	s1,4
    wait(&xstatus);
    1bca:	f7c40513          	addi	a0,s0,-132
    1bce:	00003097          	auipc	ra,0x3
    1bd2:	7ae080e7          	jalr	1966(ra) # 537c <wait>
    if(xstatus != 0)
    1bd6:	f7c42903          	lw	s2,-132(s0)
    1bda:	0e091263          	bnez	s2,1cbe <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1bde:	34fd                	addiw	s1,s1,-1
    1be0:	f4ed                	bnez	s1,1bca <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1be2:	f8040123          	sb	zero,-126(s0)
    1be6:	03000993          	li	s3,48
    1bea:	5a7d                	li	s4,-1
    1bec:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1bf0:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
    1bf2:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
    1bf4:	07400a93          	li	s5,116
    1bf8:	a29d                	j	1d5e <createdelete+0x1cc>
      printf("fork failed\n", s);
    1bfa:	85e6                	mv	a1,s9
    1bfc:	00005517          	auipc	a0,0x5
    1c00:	bf450513          	addi	a0,a0,-1036 # 67f0 <malloc+0x1046>
    1c04:	00004097          	auipc	ra,0x4
    1c08:	ae8080e7          	jalr	-1304(ra) # 56ec <printf>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	00003097          	auipc	ra,0x3
    1c12:	766080e7          	jalr	1894(ra) # 5374 <exit>
      name[0] = 'p' + pi;
    1c16:	0709091b          	addiw	s2,s2,112
    1c1a:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1c1e:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1c22:	4951                	li	s2,20
    1c24:	a015                	j	1c48 <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1c26:	85e6                	mv	a1,s9
    1c28:	00005517          	auipc	a0,0x5
    1c2c:	87050513          	addi	a0,a0,-1936 # 6498 <malloc+0xcee>
    1c30:	00004097          	auipc	ra,0x4
    1c34:	abc080e7          	jalr	-1348(ra) # 56ec <printf>
          exit(1);
    1c38:	4505                	li	a0,1
    1c3a:	00003097          	auipc	ra,0x3
    1c3e:	73a080e7          	jalr	1850(ra) # 5374 <exit>
      for(i = 0; i < N; i++){
    1c42:	2485                	addiw	s1,s1,1
    1c44:	07248863          	beq	s1,s2,1cb4 <createdelete+0x122>
        name[1] = '0' + i;
    1c48:	0304879b          	addiw	a5,s1,48
    1c4c:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1c50:	20200593          	li	a1,514
    1c54:	f8040513          	addi	a0,s0,-128
    1c58:	00003097          	auipc	ra,0x3
    1c5c:	75c080e7          	jalr	1884(ra) # 53b4 <open>
        if(fd < 0){
    1c60:	fc0543e3          	bltz	a0,1c26 <createdelete+0x94>
        close(fd);
    1c64:	00003097          	auipc	ra,0x3
    1c68:	738080e7          	jalr	1848(ra) # 539c <close>
        if(i > 0 && (i % 2 ) == 0){
    1c6c:	fc905be3          	blez	s1,1c42 <createdelete+0xb0>
    1c70:	0014f793          	andi	a5,s1,1
    1c74:	f7f9                	bnez	a5,1c42 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1c76:	01f4d79b          	srliw	a5,s1,0x1f
    1c7a:	9fa5                	addw	a5,a5,s1
    1c7c:	4017d79b          	sraiw	a5,a5,0x1
    1c80:	0307879b          	addiw	a5,a5,48
    1c84:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1c88:	f8040513          	addi	a0,s0,-128
    1c8c:	00003097          	auipc	ra,0x3
    1c90:	738080e7          	jalr	1848(ra) # 53c4 <unlink>
    1c94:	fa0557e3          	bgez	a0,1c42 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1c98:	85e6                	mv	a1,s9
    1c9a:	00005517          	auipc	a0,0x5
    1c9e:	95650513          	addi	a0,a0,-1706 # 65f0 <malloc+0xe46>
    1ca2:	00004097          	auipc	ra,0x4
    1ca6:	a4a080e7          	jalr	-1462(ra) # 56ec <printf>
            exit(1);
    1caa:	4505                	li	a0,1
    1cac:	00003097          	auipc	ra,0x3
    1cb0:	6c8080e7          	jalr	1736(ra) # 5374 <exit>
      exit(0);
    1cb4:	4501                	li	a0,0
    1cb6:	00003097          	auipc	ra,0x3
    1cba:	6be080e7          	jalr	1726(ra) # 5374 <exit>
      exit(1);
    1cbe:	4505                	li	a0,1
    1cc0:	00003097          	auipc	ra,0x3
    1cc4:	6b4080e7          	jalr	1716(ra) # 5374 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1cc8:	f8040613          	addi	a2,s0,-128
    1ccc:	85e6                	mv	a1,s9
    1cce:	00005517          	auipc	a0,0x5
    1cd2:	93a50513          	addi	a0,a0,-1734 # 6608 <malloc+0xe5e>
    1cd6:	00004097          	auipc	ra,0x4
    1cda:	a16080e7          	jalr	-1514(ra) # 56ec <printf>
        exit(1);
    1cde:	4505                	li	a0,1
    1ce0:	00003097          	auipc	ra,0x3
    1ce4:	694080e7          	jalr	1684(ra) # 5374 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1ce8:	054b7163          	bgeu	s6,s4,1d2a <createdelete+0x198>
      if(fd >= 0)
    1cec:	02055a63          	bgez	a0,1d20 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
    1cf0:	2485                	addiw	s1,s1,1
    1cf2:	0ff4f493          	andi	s1,s1,255
    1cf6:	05548c63          	beq	s1,s5,1d4e <createdelete+0x1bc>
      name[0] = 'p' + pi;
    1cfa:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1cfe:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1d02:	4581                	li	a1,0
    1d04:	f8040513          	addi	a0,s0,-128
    1d08:	00003097          	auipc	ra,0x3
    1d0c:	6ac080e7          	jalr	1708(ra) # 53b4 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1d10:	00090463          	beqz	s2,1d18 <createdelete+0x186>
    1d14:	fd2bdae3          	bge	s7,s2,1ce8 <createdelete+0x156>
    1d18:	fa0548e3          	bltz	a0,1cc8 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d1c:	014b7963          	bgeu	s6,s4,1d2e <createdelete+0x19c>
        close(fd);
    1d20:	00003097          	auipc	ra,0x3
    1d24:	67c080e7          	jalr	1660(ra) # 539c <close>
    1d28:	b7e1                	j	1cf0 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1d2a:	fc0543e3          	bltz	a0,1cf0 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1d2e:	f8040613          	addi	a2,s0,-128
    1d32:	85e6                	mv	a1,s9
    1d34:	00005517          	auipc	a0,0x5
    1d38:	8fc50513          	addi	a0,a0,-1796 # 6630 <malloc+0xe86>
    1d3c:	00004097          	auipc	ra,0x4
    1d40:	9b0080e7          	jalr	-1616(ra) # 56ec <printf>
        exit(1);
    1d44:	4505                	li	a0,1
    1d46:	00003097          	auipc	ra,0x3
    1d4a:	62e080e7          	jalr	1582(ra) # 5374 <exit>
  for(i = 0; i < N; i++){
    1d4e:	2905                	addiw	s2,s2,1
    1d50:	2a05                	addiw	s4,s4,1
    1d52:	2985                	addiw	s3,s3,1
    1d54:	0ff9f993          	andi	s3,s3,255
    1d58:	47d1                	li	a5,20
    1d5a:	02f90a63          	beq	s2,a5,1d8e <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
    1d5e:	84e2                	mv	s1,s8
    1d60:	bf69                	j	1cfa <createdelete+0x168>
  for(i = 0; i < N; i++){
    1d62:	2905                	addiw	s2,s2,1
    1d64:	0ff97913          	andi	s2,s2,255
    1d68:	2985                	addiw	s3,s3,1
    1d6a:	0ff9f993          	andi	s3,s3,255
    1d6e:	03490863          	beq	s2,s4,1d9e <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1d72:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1d74:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1d78:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1d7c:	f8040513          	addi	a0,s0,-128
    1d80:	00003097          	auipc	ra,0x3
    1d84:	644080e7          	jalr	1604(ra) # 53c4 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1d88:	34fd                	addiw	s1,s1,-1
    1d8a:	f4ed                	bnez	s1,1d74 <createdelete+0x1e2>
    1d8c:	bfd9                	j	1d62 <createdelete+0x1d0>
    1d8e:	03000993          	li	s3,48
    1d92:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1d96:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1d98:	08400a13          	li	s4,132
    1d9c:	bfd9                	j	1d72 <createdelete+0x1e0>
}
    1d9e:	60aa                	ld	ra,136(sp)
    1da0:	640a                	ld	s0,128(sp)
    1da2:	74e6                	ld	s1,120(sp)
    1da4:	7946                	ld	s2,112(sp)
    1da6:	79a6                	ld	s3,104(sp)
    1da8:	7a06                	ld	s4,96(sp)
    1daa:	6ae6                	ld	s5,88(sp)
    1dac:	6b46                	ld	s6,80(sp)
    1dae:	6ba6                	ld	s7,72(sp)
    1db0:	6c06                	ld	s8,64(sp)
    1db2:	7ce2                	ld	s9,56(sp)
    1db4:	6149                	addi	sp,sp,144
    1db6:	8082                	ret

0000000000001db8 <linkunlink>:
{
    1db8:	711d                	addi	sp,sp,-96
    1dba:	ec86                	sd	ra,88(sp)
    1dbc:	e8a2                	sd	s0,80(sp)
    1dbe:	e4a6                	sd	s1,72(sp)
    1dc0:	e0ca                	sd	s2,64(sp)
    1dc2:	fc4e                	sd	s3,56(sp)
    1dc4:	f852                	sd	s4,48(sp)
    1dc6:	f456                	sd	s5,40(sp)
    1dc8:	f05a                	sd	s6,32(sp)
    1dca:	ec5e                	sd	s7,24(sp)
    1dcc:	e862                	sd	s8,16(sp)
    1dce:	e466                	sd	s9,8(sp)
    1dd0:	1080                	addi	s0,sp,96
    1dd2:	84aa                	mv	s1,a0
  unlink("x");
    1dd4:	00004517          	auipc	a0,0x4
    1dd8:	e6450513          	addi	a0,a0,-412 # 5c38 <malloc+0x48e>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	5e8080e7          	jalr	1512(ra) # 53c4 <unlink>
  pid = fork();
    1de4:	00003097          	auipc	ra,0x3
    1de8:	588080e7          	jalr	1416(ra) # 536c <fork>
  if(pid < 0){
    1dec:	02054b63          	bltz	a0,1e22 <linkunlink+0x6a>
    1df0:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    1df2:	4c85                	li	s9,1
    1df4:	e119                	bnez	a0,1dfa <linkunlink+0x42>
    1df6:	06100c93          	li	s9,97
    1dfa:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1dfe:	41c659b7          	lui	s3,0x41c65
    1e02:	e6d9899b          	addiw	s3,s3,-403
    1e06:	690d                	lui	s2,0x3
    1e08:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    1e0c:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    1e0e:	4b05                	li	s6,1
      unlink("x");
    1e10:	00004a97          	auipc	s5,0x4
    1e14:	e28a8a93          	addi	s5,s5,-472 # 5c38 <malloc+0x48e>
      link("cat", "x");
    1e18:	00005b97          	auipc	s7,0x5
    1e1c:	840b8b93          	addi	s7,s7,-1984 # 6658 <malloc+0xeae>
    1e20:	a091                	j	1e64 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    1e22:	85a6                	mv	a1,s1
    1e24:	00004517          	auipc	a0,0x4
    1e28:	5dc50513          	addi	a0,a0,1500 # 6400 <malloc+0xc56>
    1e2c:	00004097          	auipc	ra,0x4
    1e30:	8c0080e7          	jalr	-1856(ra) # 56ec <printf>
    exit(1);
    1e34:	4505                	li	a0,1
    1e36:	00003097          	auipc	ra,0x3
    1e3a:	53e080e7          	jalr	1342(ra) # 5374 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1e3e:	20200593          	li	a1,514
    1e42:	8556                	mv	a0,s5
    1e44:	00003097          	auipc	ra,0x3
    1e48:	570080e7          	jalr	1392(ra) # 53b4 <open>
    1e4c:	00003097          	auipc	ra,0x3
    1e50:	550080e7          	jalr	1360(ra) # 539c <close>
    1e54:	a031                	j	1e60 <linkunlink+0xa8>
      unlink("x");
    1e56:	8556                	mv	a0,s5
    1e58:	00003097          	auipc	ra,0x3
    1e5c:	56c080e7          	jalr	1388(ra) # 53c4 <unlink>
  for(i = 0; i < 100; i++){
    1e60:	34fd                	addiw	s1,s1,-1
    1e62:	c09d                	beqz	s1,1e88 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    1e64:	033c87bb          	mulw	a5,s9,s3
    1e68:	012787bb          	addw	a5,a5,s2
    1e6c:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    1e70:	0347f7bb          	remuw	a5,a5,s4
    1e74:	d7e9                	beqz	a5,1e3e <linkunlink+0x86>
    } else if((x % 3) == 1){
    1e76:	ff6790e3          	bne	a5,s6,1e56 <linkunlink+0x9e>
      link("cat", "x");
    1e7a:	85d6                	mv	a1,s5
    1e7c:	855e                	mv	a0,s7
    1e7e:	00003097          	auipc	ra,0x3
    1e82:	556080e7          	jalr	1366(ra) # 53d4 <link>
    1e86:	bfe9                	j	1e60 <linkunlink+0xa8>
  if(pid)
    1e88:	020c0463          	beqz	s8,1eb0 <linkunlink+0xf8>
    wait(0);
    1e8c:	4501                	li	a0,0
    1e8e:	00003097          	auipc	ra,0x3
    1e92:	4ee080e7          	jalr	1262(ra) # 537c <wait>
}
    1e96:	60e6                	ld	ra,88(sp)
    1e98:	6446                	ld	s0,80(sp)
    1e9a:	64a6                	ld	s1,72(sp)
    1e9c:	6906                	ld	s2,64(sp)
    1e9e:	79e2                	ld	s3,56(sp)
    1ea0:	7a42                	ld	s4,48(sp)
    1ea2:	7aa2                	ld	s5,40(sp)
    1ea4:	7b02                	ld	s6,32(sp)
    1ea6:	6be2                	ld	s7,24(sp)
    1ea8:	6c42                	ld	s8,16(sp)
    1eaa:	6ca2                	ld	s9,8(sp)
    1eac:	6125                	addi	sp,sp,96
    1eae:	8082                	ret
    exit(0);
    1eb0:	4501                	li	a0,0
    1eb2:	00003097          	auipc	ra,0x3
    1eb6:	4c2080e7          	jalr	1218(ra) # 5374 <exit>

0000000000001eba <forktest>:
{
    1eba:	7179                	addi	sp,sp,-48
    1ebc:	f406                	sd	ra,40(sp)
    1ebe:	f022                	sd	s0,32(sp)
    1ec0:	ec26                	sd	s1,24(sp)
    1ec2:	e84a                	sd	s2,16(sp)
    1ec4:	e44e                	sd	s3,8(sp)
    1ec6:	1800                	addi	s0,sp,48
    1ec8:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1eca:	4481                	li	s1,0
    1ecc:	3e800913          	li	s2,1000
    pid = fork();
    1ed0:	00003097          	auipc	ra,0x3
    1ed4:	49c080e7          	jalr	1180(ra) # 536c <fork>
    if(pid < 0)
    1ed8:	02054863          	bltz	a0,1f08 <forktest+0x4e>
    if(pid == 0)
    1edc:	c115                	beqz	a0,1f00 <forktest+0x46>
  for(n=0; n<N; n++){
    1ede:	2485                	addiw	s1,s1,1
    1ee0:	ff2498e3          	bne	s1,s2,1ed0 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1ee4:	85ce                	mv	a1,s3
    1ee6:	00004517          	auipc	a0,0x4
    1eea:	79250513          	addi	a0,a0,1938 # 6678 <malloc+0xece>
    1eee:	00003097          	auipc	ra,0x3
    1ef2:	7fe080e7          	jalr	2046(ra) # 56ec <printf>
    exit(1);
    1ef6:	4505                	li	a0,1
    1ef8:	00003097          	auipc	ra,0x3
    1efc:	47c080e7          	jalr	1148(ra) # 5374 <exit>
      exit(0);
    1f00:	00003097          	auipc	ra,0x3
    1f04:	474080e7          	jalr	1140(ra) # 5374 <exit>
  if (n == 0) {
    1f08:	cc9d                	beqz	s1,1f46 <forktest+0x8c>
  if(n == N){
    1f0a:	3e800793          	li	a5,1000
    1f0e:	fcf48be3          	beq	s1,a5,1ee4 <forktest+0x2a>
  for(; n > 0; n--){
    1f12:	00905b63          	blez	s1,1f28 <forktest+0x6e>
    if(wait(0) < 0){
    1f16:	4501                	li	a0,0
    1f18:	00003097          	auipc	ra,0x3
    1f1c:	464080e7          	jalr	1124(ra) # 537c <wait>
    1f20:	04054163          	bltz	a0,1f62 <forktest+0xa8>
  for(; n > 0; n--){
    1f24:	34fd                	addiw	s1,s1,-1
    1f26:	f8e5                	bnez	s1,1f16 <forktest+0x5c>
  if(wait(0) != -1){
    1f28:	4501                	li	a0,0
    1f2a:	00003097          	auipc	ra,0x3
    1f2e:	452080e7          	jalr	1106(ra) # 537c <wait>
    1f32:	57fd                	li	a5,-1
    1f34:	04f51563          	bne	a0,a5,1f7e <forktest+0xc4>
}
    1f38:	70a2                	ld	ra,40(sp)
    1f3a:	7402                	ld	s0,32(sp)
    1f3c:	64e2                	ld	s1,24(sp)
    1f3e:	6942                	ld	s2,16(sp)
    1f40:	69a2                	ld	s3,8(sp)
    1f42:	6145                	addi	sp,sp,48
    1f44:	8082                	ret
    printf("%s: no fork at all!\n", s);
    1f46:	85ce                	mv	a1,s3
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	71850513          	addi	a0,a0,1816 # 6660 <malloc+0xeb6>
    1f50:	00003097          	auipc	ra,0x3
    1f54:	79c080e7          	jalr	1948(ra) # 56ec <printf>
    exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00003097          	auipc	ra,0x3
    1f5e:	41a080e7          	jalr	1050(ra) # 5374 <exit>
      printf("%s: wait stopped early\n", s);
    1f62:	85ce                	mv	a1,s3
    1f64:	00004517          	auipc	a0,0x4
    1f68:	73c50513          	addi	a0,a0,1852 # 66a0 <malloc+0xef6>
    1f6c:	00003097          	auipc	ra,0x3
    1f70:	780080e7          	jalr	1920(ra) # 56ec <printf>
      exit(1);
    1f74:	4505                	li	a0,1
    1f76:	00003097          	auipc	ra,0x3
    1f7a:	3fe080e7          	jalr	1022(ra) # 5374 <exit>
    printf("%s: wait got too many\n", s);
    1f7e:	85ce                	mv	a1,s3
    1f80:	00004517          	auipc	a0,0x4
    1f84:	73850513          	addi	a0,a0,1848 # 66b8 <malloc+0xf0e>
    1f88:	00003097          	auipc	ra,0x3
    1f8c:	764080e7          	jalr	1892(ra) # 56ec <printf>
    exit(1);
    1f90:	4505                	li	a0,1
    1f92:	00003097          	auipc	ra,0x3
    1f96:	3e2080e7          	jalr	994(ra) # 5374 <exit>

0000000000001f9a <kernmem>:
{
    1f9a:	715d                	addi	sp,sp,-80
    1f9c:	e486                	sd	ra,72(sp)
    1f9e:	e0a2                	sd	s0,64(sp)
    1fa0:	fc26                	sd	s1,56(sp)
    1fa2:	f84a                	sd	s2,48(sp)
    1fa4:	f44e                	sd	s3,40(sp)
    1fa6:	f052                	sd	s4,32(sp)
    1fa8:	ec56                	sd	s5,24(sp)
    1faa:	0880                	addi	s0,sp,80
    1fac:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fae:	4485                	li	s1,1
    1fb0:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1fb2:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fb4:	69b1                	lui	s3,0xc
    1fb6:	35098993          	addi	s3,s3,848 # c350 <buf+0xc20>
    1fba:	1003d937          	lui	s2,0x1003d
    1fbe:	090e                	slli	s2,s2,0x3
    1fc0:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x1002ed40>
    pid = fork();
    1fc4:	00003097          	auipc	ra,0x3
    1fc8:	3a8080e7          	jalr	936(ra) # 536c <fork>
    if(pid < 0){
    1fcc:	02054963          	bltz	a0,1ffe <kernmem+0x64>
    if(pid == 0){
    1fd0:	c529                	beqz	a0,201a <kernmem+0x80>
    wait(&xstatus);
    1fd2:	fbc40513          	addi	a0,s0,-68
    1fd6:	00003097          	auipc	ra,0x3
    1fda:	3a6080e7          	jalr	934(ra) # 537c <wait>
    if(xstatus != -1)  // did kernel kill child?
    1fde:	fbc42783          	lw	a5,-68(s0)
    1fe2:	05579c63          	bne	a5,s5,203a <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1fe6:	94ce                	add	s1,s1,s3
    1fe8:	fd249ee3          	bne	s1,s2,1fc4 <kernmem+0x2a>
}
    1fec:	60a6                	ld	ra,72(sp)
    1fee:	6406                	ld	s0,64(sp)
    1ff0:	74e2                	ld	s1,56(sp)
    1ff2:	7942                	ld	s2,48(sp)
    1ff4:	79a2                	ld	s3,40(sp)
    1ff6:	7a02                	ld	s4,32(sp)
    1ff8:	6ae2                	ld	s5,24(sp)
    1ffa:	6161                	addi	sp,sp,80
    1ffc:	8082                	ret
      printf("%s: fork failed\n", s);
    1ffe:	85d2                	mv	a1,s4
    2000:	00004517          	auipc	a0,0x4
    2004:	40050513          	addi	a0,a0,1024 # 6400 <malloc+0xc56>
    2008:	00003097          	auipc	ra,0x3
    200c:	6e4080e7          	jalr	1764(ra) # 56ec <printf>
      exit(1);
    2010:	4505                	li	a0,1
    2012:	00003097          	auipc	ra,0x3
    2016:	362080e7          	jalr	866(ra) # 5374 <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
    201a:	0004c603          	lbu	a2,0(s1)
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	6b050513          	addi	a0,a0,1712 # 66d0 <malloc+0xf26>
    2028:	00003097          	auipc	ra,0x3
    202c:	6c4080e7          	jalr	1732(ra) # 56ec <printf>
      exit(1);
    2030:	4505                	li	a0,1
    2032:	00003097          	auipc	ra,0x3
    2036:	342080e7          	jalr	834(ra) # 5374 <exit>
      exit(1);
    203a:	4505                	li	a0,1
    203c:	00003097          	auipc	ra,0x3
    2040:	338080e7          	jalr	824(ra) # 5374 <exit>

0000000000002044 <bigargtest>:
{
    2044:	7179                	addi	sp,sp,-48
    2046:	f406                	sd	ra,40(sp)
    2048:	f022                	sd	s0,32(sp)
    204a:	ec26                	sd	s1,24(sp)
    204c:	1800                	addi	s0,sp,48
    204e:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    2050:	00004517          	auipc	a0,0x4
    2054:	6a050513          	addi	a0,a0,1696 # 66f0 <malloc+0xf46>
    2058:	00003097          	auipc	ra,0x3
    205c:	36c080e7          	jalr	876(ra) # 53c4 <unlink>
  pid = fork();
    2060:	00003097          	auipc	ra,0x3
    2064:	30c080e7          	jalr	780(ra) # 536c <fork>
  if(pid == 0){
    2068:	c121                	beqz	a0,20a8 <bigargtest+0x64>
  } else if(pid < 0){
    206a:	0a054063          	bltz	a0,210a <bigargtest+0xc6>
  wait(&xstatus);
    206e:	fdc40513          	addi	a0,s0,-36
    2072:	00003097          	auipc	ra,0x3
    2076:	30a080e7          	jalr	778(ra) # 537c <wait>
  if(xstatus != 0)
    207a:	fdc42503          	lw	a0,-36(s0)
    207e:	e545                	bnez	a0,2126 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    2080:	4581                	li	a1,0
    2082:	00004517          	auipc	a0,0x4
    2086:	66e50513          	addi	a0,a0,1646 # 66f0 <malloc+0xf46>
    208a:	00003097          	auipc	ra,0x3
    208e:	32a080e7          	jalr	810(ra) # 53b4 <open>
  if(fd < 0){
    2092:	08054e63          	bltz	a0,212e <bigargtest+0xea>
  close(fd);
    2096:	00003097          	auipc	ra,0x3
    209a:	306080e7          	jalr	774(ra) # 539c <close>
}
    209e:	70a2                	ld	ra,40(sp)
    20a0:	7402                	ld	s0,32(sp)
    20a2:	64e2                	ld	s1,24(sp)
    20a4:	6145                	addi	sp,sp,48
    20a6:	8082                	ret
    20a8:	00006797          	auipc	a5,0x6
    20ac:	e7078793          	addi	a5,a5,-400 # 7f18 <args.1802>
    20b0:	00006697          	auipc	a3,0x6
    20b4:	f6068693          	addi	a3,a3,-160 # 8010 <args.1802+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    20b8:	00004717          	auipc	a4,0x4
    20bc:	64870713          	addi	a4,a4,1608 # 6700 <malloc+0xf56>
    20c0:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    20c2:	07a1                	addi	a5,a5,8
    20c4:	fed79ee3          	bne	a5,a3,20c0 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    20c8:	00006597          	auipc	a1,0x6
    20cc:	e5058593          	addi	a1,a1,-432 # 7f18 <args.1802>
    20d0:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    20d4:	00004517          	auipc	a0,0x4
    20d8:	af450513          	addi	a0,a0,-1292 # 5bc8 <malloc+0x41e>
    20dc:	00003097          	auipc	ra,0x3
    20e0:	2d0080e7          	jalr	720(ra) # 53ac <exec>
    fd = open("bigarg-ok", O_CREATE);
    20e4:	20000593          	li	a1,512
    20e8:	00004517          	auipc	a0,0x4
    20ec:	60850513          	addi	a0,a0,1544 # 66f0 <malloc+0xf46>
    20f0:	00003097          	auipc	ra,0x3
    20f4:	2c4080e7          	jalr	708(ra) # 53b4 <open>
    close(fd);
    20f8:	00003097          	auipc	ra,0x3
    20fc:	2a4080e7          	jalr	676(ra) # 539c <close>
    exit(0);
    2100:	4501                	li	a0,0
    2102:	00003097          	auipc	ra,0x3
    2106:	272080e7          	jalr	626(ra) # 5374 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    210a:	85a6                	mv	a1,s1
    210c:	00004517          	auipc	a0,0x4
    2110:	6d450513          	addi	a0,a0,1748 # 67e0 <malloc+0x1036>
    2114:	00003097          	auipc	ra,0x3
    2118:	5d8080e7          	jalr	1496(ra) # 56ec <printf>
    exit(1);
    211c:	4505                	li	a0,1
    211e:	00003097          	auipc	ra,0x3
    2122:	256080e7          	jalr	598(ra) # 5374 <exit>
    exit(xstatus);
    2126:	00003097          	auipc	ra,0x3
    212a:	24e080e7          	jalr	590(ra) # 5374 <exit>
    printf("%s: bigarg test failed!\n", s);
    212e:	85a6                	mv	a1,s1
    2130:	00004517          	auipc	a0,0x4
    2134:	6d050513          	addi	a0,a0,1744 # 6800 <malloc+0x1056>
    2138:	00003097          	auipc	ra,0x3
    213c:	5b4080e7          	jalr	1460(ra) # 56ec <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	00003097          	auipc	ra,0x3
    2146:	232080e7          	jalr	562(ra) # 5374 <exit>

000000000000214a <stacktest>:
{
    214a:	7179                	addi	sp,sp,-48
    214c:	f406                	sd	ra,40(sp)
    214e:	f022                	sd	s0,32(sp)
    2150:	ec26                	sd	s1,24(sp)
    2152:	1800                	addi	s0,sp,48
    2154:	84aa                	mv	s1,a0
  pid = fork();
    2156:	00003097          	auipc	ra,0x3
    215a:	216080e7          	jalr	534(ra) # 536c <fork>
  if(pid == 0) {
    215e:	c115                	beqz	a0,2182 <stacktest+0x38>
  } else if(pid < 0){
    2160:	04054363          	bltz	a0,21a6 <stacktest+0x5c>
  wait(&xstatus);
    2164:	fdc40513          	addi	a0,s0,-36
    2168:	00003097          	auipc	ra,0x3
    216c:	214080e7          	jalr	532(ra) # 537c <wait>
  if(xstatus == -1)  // kernel killed child?
    2170:	fdc42503          	lw	a0,-36(s0)
    2174:	57fd                	li	a5,-1
    2176:	04f50663          	beq	a0,a5,21c2 <stacktest+0x78>
    exit(xstatus);
    217a:	00003097          	auipc	ra,0x3
    217e:	1fa080e7          	jalr	506(ra) # 5374 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2182:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
    2184:	77fd                	lui	a5,0xfffff
    2186:	97ba                	add	a5,a5,a4
    2188:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff08c0>
    218c:	00004517          	auipc	a0,0x4
    2190:	69450513          	addi	a0,a0,1684 # 6820 <malloc+0x1076>
    2194:	00003097          	auipc	ra,0x3
    2198:	558080e7          	jalr	1368(ra) # 56ec <printf>
    exit(1);
    219c:	4505                	li	a0,1
    219e:	00003097          	auipc	ra,0x3
    21a2:	1d6080e7          	jalr	470(ra) # 5374 <exit>
    printf("%s: fork failed\n", s);
    21a6:	85a6                	mv	a1,s1
    21a8:	00004517          	auipc	a0,0x4
    21ac:	25850513          	addi	a0,a0,600 # 6400 <malloc+0xc56>
    21b0:	00003097          	auipc	ra,0x3
    21b4:	53c080e7          	jalr	1340(ra) # 56ec <printf>
    exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00003097          	auipc	ra,0x3
    21be:	1ba080e7          	jalr	442(ra) # 5374 <exit>
    exit(0);
    21c2:	4501                	li	a0,0
    21c4:	00003097          	auipc	ra,0x3
    21c8:	1b0080e7          	jalr	432(ra) # 5374 <exit>

00000000000021cc <copyinstr3>:
{
    21cc:	7179                	addi	sp,sp,-48
    21ce:	f406                	sd	ra,40(sp)
    21d0:	f022                	sd	s0,32(sp)
    21d2:	ec26                	sd	s1,24(sp)
    21d4:	1800                	addi	s0,sp,48
  sbrk(8192);
    21d6:	6509                	lui	a0,0x2
    21d8:	00003097          	auipc	ra,0x3
    21dc:	224080e7          	jalr	548(ra) # 53fc <sbrk>
  uint64 top = (uint64) sbrk(0);
    21e0:	4501                	li	a0,0
    21e2:	00003097          	auipc	ra,0x3
    21e6:	21a080e7          	jalr	538(ra) # 53fc <sbrk>
  if((top % PGSIZE) != 0){
    21ea:	03451793          	slli	a5,a0,0x34
    21ee:	e3c9                	bnez	a5,2270 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    21f0:	4501                	li	a0,0
    21f2:	00003097          	auipc	ra,0x3
    21f6:	20a080e7          	jalr	522(ra) # 53fc <sbrk>
  if(top % PGSIZE){
    21fa:	03451793          	slli	a5,a0,0x34
    21fe:	e3d9                	bnez	a5,2284 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2200:	fff50493          	addi	s1,a0,-1 # 1fff <kernmem+0x65>
  *b = 'x';
    2204:	07800793          	li	a5,120
    2208:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    220c:	8526                	mv	a0,s1
    220e:	00003097          	auipc	ra,0x3
    2212:	1b6080e7          	jalr	438(ra) # 53c4 <unlink>
  if(ret != -1){
    2216:	57fd                	li	a5,-1
    2218:	08f51363          	bne	a0,a5,229e <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    221c:	20100593          	li	a1,513
    2220:	8526                	mv	a0,s1
    2222:	00003097          	auipc	ra,0x3
    2226:	192080e7          	jalr	402(ra) # 53b4 <open>
  if(fd != -1){
    222a:	57fd                	li	a5,-1
    222c:	08f51863          	bne	a0,a5,22bc <copyinstr3+0xf0>
  ret = link(b, b);
    2230:	85a6                	mv	a1,s1
    2232:	8526                	mv	a0,s1
    2234:	00003097          	auipc	ra,0x3
    2238:	1a0080e7          	jalr	416(ra) # 53d4 <link>
  if(ret != -1){
    223c:	57fd                	li	a5,-1
    223e:	08f51e63          	bne	a0,a5,22da <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    2242:	00005797          	auipc	a5,0x5
    2246:	17e78793          	addi	a5,a5,382 # 73c0 <malloc+0x1c16>
    224a:	fcf43823          	sd	a5,-48(s0)
    224e:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2252:	fd040593          	addi	a1,s0,-48
    2256:	8526                	mv	a0,s1
    2258:	00003097          	auipc	ra,0x3
    225c:	154080e7          	jalr	340(ra) # 53ac <exec>
  if(ret != -1){
    2260:	57fd                	li	a5,-1
    2262:	08f51c63          	bne	a0,a5,22fa <copyinstr3+0x12e>
}
    2266:	70a2                	ld	ra,40(sp)
    2268:	7402                	ld	s0,32(sp)
    226a:	64e2                	ld	s1,24(sp)
    226c:	6145                	addi	sp,sp,48
    226e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2270:	0347d513          	srli	a0,a5,0x34
    2274:	6785                	lui	a5,0x1
    2276:	40a7853b          	subw	a0,a5,a0
    227a:	00003097          	auipc	ra,0x3
    227e:	182080e7          	jalr	386(ra) # 53fc <sbrk>
    2282:	b7bd                	j	21f0 <copyinstr3+0x24>
    printf("oops\n");
    2284:	00004517          	auipc	a0,0x4
    2288:	5c450513          	addi	a0,a0,1476 # 6848 <malloc+0x109e>
    228c:	00003097          	auipc	ra,0x3
    2290:	460080e7          	jalr	1120(ra) # 56ec <printf>
    exit(1);
    2294:	4505                	li	a0,1
    2296:	00003097          	auipc	ra,0x3
    229a:	0de080e7          	jalr	222(ra) # 5374 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    229e:	862a                	mv	a2,a0
    22a0:	85a6                	mv	a1,s1
    22a2:	00004517          	auipc	a0,0x4
    22a6:	07e50513          	addi	a0,a0,126 # 6320 <malloc+0xb76>
    22aa:	00003097          	auipc	ra,0x3
    22ae:	442080e7          	jalr	1090(ra) # 56ec <printf>
    exit(1);
    22b2:	4505                	li	a0,1
    22b4:	00003097          	auipc	ra,0x3
    22b8:	0c0080e7          	jalr	192(ra) # 5374 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    22bc:	862a                	mv	a2,a0
    22be:	85a6                	mv	a1,s1
    22c0:	00004517          	auipc	a0,0x4
    22c4:	08050513          	addi	a0,a0,128 # 6340 <malloc+0xb96>
    22c8:	00003097          	auipc	ra,0x3
    22cc:	424080e7          	jalr	1060(ra) # 56ec <printf>
    exit(1);
    22d0:	4505                	li	a0,1
    22d2:	00003097          	auipc	ra,0x3
    22d6:	0a2080e7          	jalr	162(ra) # 5374 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    22da:	86aa                	mv	a3,a0
    22dc:	8626                	mv	a2,s1
    22de:	85a6                	mv	a1,s1
    22e0:	00004517          	auipc	a0,0x4
    22e4:	08050513          	addi	a0,a0,128 # 6360 <malloc+0xbb6>
    22e8:	00003097          	auipc	ra,0x3
    22ec:	404080e7          	jalr	1028(ra) # 56ec <printf>
    exit(1);
    22f0:	4505                	li	a0,1
    22f2:	00003097          	auipc	ra,0x3
    22f6:	082080e7          	jalr	130(ra) # 5374 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    22fa:	567d                	li	a2,-1
    22fc:	85a6                	mv	a1,s1
    22fe:	00004517          	auipc	a0,0x4
    2302:	08a50513          	addi	a0,a0,138 # 6388 <malloc+0xbde>
    2306:	00003097          	auipc	ra,0x3
    230a:	3e6080e7          	jalr	998(ra) # 56ec <printf>
    exit(1);
    230e:	4505                	li	a0,1
    2310:	00003097          	auipc	ra,0x3
    2314:	064080e7          	jalr	100(ra) # 5374 <exit>

0000000000002318 <sbrkbasic>:
{
    2318:	7139                	addi	sp,sp,-64
    231a:	fc06                	sd	ra,56(sp)
    231c:	f822                	sd	s0,48(sp)
    231e:	f426                	sd	s1,40(sp)
    2320:	f04a                	sd	s2,32(sp)
    2322:	ec4e                	sd	s3,24(sp)
    2324:	e852                	sd	s4,16(sp)
    2326:	0080                	addi	s0,sp,64
    2328:	8a2a                	mv	s4,a0
  pid = fork();
    232a:	00003097          	auipc	ra,0x3
    232e:	042080e7          	jalr	66(ra) # 536c <fork>
  if(pid < 0){
    2332:	02054c63          	bltz	a0,236a <sbrkbasic+0x52>
  if(pid == 0){
    2336:	ed21                	bnez	a0,238e <sbrkbasic+0x76>
    a = sbrk(TOOMUCH);
    2338:	40000537          	lui	a0,0x40000
    233c:	00003097          	auipc	ra,0x3
    2340:	0c0080e7          	jalr	192(ra) # 53fc <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2344:	57fd                	li	a5,-1
    2346:	02f50f63          	beq	a0,a5,2384 <sbrkbasic+0x6c>
    for(b = a; b < a+TOOMUCH; b += 4096){
    234a:	400007b7          	lui	a5,0x40000
    234e:	97aa                	add	a5,a5,a0
      *b = 99;
    2350:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2354:	6705                	lui	a4,0x1
      *b = 99;
    2356:	00d50023          	sb	a3,0(a0) # 40000000 <__BSS_END__+0x3fff18c0>
    for(b = a; b < a+TOOMUCH; b += 4096){
    235a:	953a                	add	a0,a0,a4
    235c:	fef51de3          	bne	a0,a5,2356 <sbrkbasic+0x3e>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	00003097          	auipc	ra,0x3
    2366:	012080e7          	jalr	18(ra) # 5374 <exit>
    printf("fork failed in sbrkbasic\n");
    236a:	00004517          	auipc	a0,0x4
    236e:	4e650513          	addi	a0,a0,1254 # 6850 <malloc+0x10a6>
    2372:	00003097          	auipc	ra,0x3
    2376:	37a080e7          	jalr	890(ra) # 56ec <printf>
    exit(1);
    237a:	4505                	li	a0,1
    237c:	00003097          	auipc	ra,0x3
    2380:	ff8080e7          	jalr	-8(ra) # 5374 <exit>
      exit(0);
    2384:	4501                	li	a0,0
    2386:	00003097          	auipc	ra,0x3
    238a:	fee080e7          	jalr	-18(ra) # 5374 <exit>
  wait(&xstatus);
    238e:	fcc40513          	addi	a0,s0,-52
    2392:	00003097          	auipc	ra,0x3
    2396:	fea080e7          	jalr	-22(ra) # 537c <wait>
  if(xstatus == 1){
    239a:	fcc42703          	lw	a4,-52(s0)
    239e:	4785                	li	a5,1
    23a0:	00f70d63          	beq	a4,a5,23ba <sbrkbasic+0xa2>
  a = sbrk(0);
    23a4:	4501                	li	a0,0
    23a6:	00003097          	auipc	ra,0x3
    23aa:	056080e7          	jalr	86(ra) # 53fc <sbrk>
    23ae:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    23b0:	4901                	li	s2,0
    23b2:	6985                	lui	s3,0x1
    23b4:	38898993          	addi	s3,s3,904 # 1388 <copyinstr2+0x1ce>
    23b8:	a005                	j	23d8 <sbrkbasic+0xc0>
    printf("%s: too much memory allocated!\n", s);
    23ba:	85d2                	mv	a1,s4
    23bc:	00004517          	auipc	a0,0x4
    23c0:	4b450513          	addi	a0,a0,1204 # 6870 <malloc+0x10c6>
    23c4:	00003097          	auipc	ra,0x3
    23c8:	328080e7          	jalr	808(ra) # 56ec <printf>
    exit(1);
    23cc:	4505                	li	a0,1
    23ce:	00003097          	auipc	ra,0x3
    23d2:	fa6080e7          	jalr	-90(ra) # 5374 <exit>
    a = b + 1;
    23d6:	84be                	mv	s1,a5
    b = sbrk(1);
    23d8:	4505                	li	a0,1
    23da:	00003097          	auipc	ra,0x3
    23de:	022080e7          	jalr	34(ra) # 53fc <sbrk>
    if(b != a){
    23e2:	04951c63          	bne	a0,s1,243a <sbrkbasic+0x122>
    *b = 1;
    23e6:	4785                	li	a5,1
    23e8:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    23ec:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    23f0:	2905                	addiw	s2,s2,1
    23f2:	ff3912e3          	bne	s2,s3,23d6 <sbrkbasic+0xbe>
  pid = fork();
    23f6:	00003097          	auipc	ra,0x3
    23fa:	f76080e7          	jalr	-138(ra) # 536c <fork>
    23fe:	892a                	mv	s2,a0
  if(pid < 0){
    2400:	04054d63          	bltz	a0,245a <sbrkbasic+0x142>
  c = sbrk(1);
    2404:	4505                	li	a0,1
    2406:	00003097          	auipc	ra,0x3
    240a:	ff6080e7          	jalr	-10(ra) # 53fc <sbrk>
  c = sbrk(1);
    240e:	4505                	li	a0,1
    2410:	00003097          	auipc	ra,0x3
    2414:	fec080e7          	jalr	-20(ra) # 53fc <sbrk>
  if(c != a + 1){
    2418:	0489                	addi	s1,s1,2
    241a:	04a48e63          	beq	s1,a0,2476 <sbrkbasic+0x15e>
    printf("%s: sbrk test failed post-fork\n", s);
    241e:	85d2                	mv	a1,s4
    2420:	00004517          	auipc	a0,0x4
    2424:	4b050513          	addi	a0,a0,1200 # 68d0 <malloc+0x1126>
    2428:	00003097          	auipc	ra,0x3
    242c:	2c4080e7          	jalr	708(ra) # 56ec <printf>
    exit(1);
    2430:	4505                	li	a0,1
    2432:	00003097          	auipc	ra,0x3
    2436:	f42080e7          	jalr	-190(ra) # 5374 <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    243a:	86aa                	mv	a3,a0
    243c:	8626                	mv	a2,s1
    243e:	85ca                	mv	a1,s2
    2440:	00004517          	auipc	a0,0x4
    2444:	45050513          	addi	a0,a0,1104 # 6890 <malloc+0x10e6>
    2448:	00003097          	auipc	ra,0x3
    244c:	2a4080e7          	jalr	676(ra) # 56ec <printf>
      exit(1);
    2450:	4505                	li	a0,1
    2452:	00003097          	auipc	ra,0x3
    2456:	f22080e7          	jalr	-222(ra) # 5374 <exit>
    printf("%s: sbrk test fork failed\n", s);
    245a:	85d2                	mv	a1,s4
    245c:	00004517          	auipc	a0,0x4
    2460:	45450513          	addi	a0,a0,1108 # 68b0 <malloc+0x1106>
    2464:	00003097          	auipc	ra,0x3
    2468:	288080e7          	jalr	648(ra) # 56ec <printf>
    exit(1);
    246c:	4505                	li	a0,1
    246e:	00003097          	auipc	ra,0x3
    2472:	f06080e7          	jalr	-250(ra) # 5374 <exit>
  if(pid == 0)
    2476:	00091763          	bnez	s2,2484 <sbrkbasic+0x16c>
    exit(0);
    247a:	4501                	li	a0,0
    247c:	00003097          	auipc	ra,0x3
    2480:	ef8080e7          	jalr	-264(ra) # 5374 <exit>
  wait(&xstatus);
    2484:	fcc40513          	addi	a0,s0,-52
    2488:	00003097          	auipc	ra,0x3
    248c:	ef4080e7          	jalr	-268(ra) # 537c <wait>
  exit(xstatus);
    2490:	fcc42503          	lw	a0,-52(s0)
    2494:	00003097          	auipc	ra,0x3
    2498:	ee0080e7          	jalr	-288(ra) # 5374 <exit>

000000000000249c <sbrkmuch>:
{
    249c:	7179                	addi	sp,sp,-48
    249e:	f406                	sd	ra,40(sp)
    24a0:	f022                	sd	s0,32(sp)
    24a2:	ec26                	sd	s1,24(sp)
    24a4:	e84a                	sd	s2,16(sp)
    24a6:	e44e                	sd	s3,8(sp)
    24a8:	e052                	sd	s4,0(sp)
    24aa:	1800                	addi	s0,sp,48
    24ac:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    24ae:	4501                	li	a0,0
    24b0:	00003097          	auipc	ra,0x3
    24b4:	f4c080e7          	jalr	-180(ra) # 53fc <sbrk>
    24b8:	892a                	mv	s2,a0
  a = sbrk(0);
    24ba:	4501                	li	a0,0
    24bc:	00003097          	auipc	ra,0x3
    24c0:	f40080e7          	jalr	-192(ra) # 53fc <sbrk>
    24c4:	84aa                	mv	s1,a0
  p = sbrk(amt);
    24c6:	06400537          	lui	a0,0x6400
    24ca:	9d05                	subw	a0,a0,s1
    24cc:	00003097          	auipc	ra,0x3
    24d0:	f30080e7          	jalr	-208(ra) # 53fc <sbrk>
  if (p != a) {
    24d4:	0ca49863          	bne	s1,a0,25a4 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    24d8:	4501                	li	a0,0
    24da:	00003097          	auipc	ra,0x3
    24de:	f22080e7          	jalr	-222(ra) # 53fc <sbrk>
    24e2:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    24e4:	00a4f963          	bgeu	s1,a0,24f6 <sbrkmuch+0x5a>
    *pp = 1;
    24e8:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    24ea:	6705                	lui	a4,0x1
    *pp = 1;
    24ec:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    24f0:	94ba                	add	s1,s1,a4
    24f2:	fef4ede3          	bltu	s1,a5,24ec <sbrkmuch+0x50>
  *lastaddr = 99;
    24f6:	064007b7          	lui	a5,0x6400
    24fa:	06300713          	li	a4,99
    24fe:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f18bf>
  a = sbrk(0);
    2502:	4501                	li	a0,0
    2504:	00003097          	auipc	ra,0x3
    2508:	ef8080e7          	jalr	-264(ra) # 53fc <sbrk>
    250c:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    250e:	757d                	lui	a0,0xfffff
    2510:	00003097          	auipc	ra,0x3
    2514:	eec080e7          	jalr	-276(ra) # 53fc <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2518:	57fd                	li	a5,-1
    251a:	0af50363          	beq	a0,a5,25c0 <sbrkmuch+0x124>
  c = sbrk(0);
    251e:	4501                	li	a0,0
    2520:	00003097          	auipc	ra,0x3
    2524:	edc080e7          	jalr	-292(ra) # 53fc <sbrk>
  if(c != a - PGSIZE){
    2528:	77fd                	lui	a5,0xfffff
    252a:	97a6                	add	a5,a5,s1
    252c:	0af51863          	bne	a0,a5,25dc <sbrkmuch+0x140>
  a = sbrk(0);
    2530:	4501                	li	a0,0
    2532:	00003097          	auipc	ra,0x3
    2536:	eca080e7          	jalr	-310(ra) # 53fc <sbrk>
    253a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    253c:	6505                	lui	a0,0x1
    253e:	00003097          	auipc	ra,0x3
    2542:	ebe080e7          	jalr	-322(ra) # 53fc <sbrk>
    2546:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2548:	0aa49963          	bne	s1,a0,25fa <sbrkmuch+0x15e>
    254c:	4501                	li	a0,0
    254e:	00003097          	auipc	ra,0x3
    2552:	eae080e7          	jalr	-338(ra) # 53fc <sbrk>
    2556:	6785                	lui	a5,0x1
    2558:	97a6                	add	a5,a5,s1
    255a:	0af51063          	bne	a0,a5,25fa <sbrkmuch+0x15e>
  if(*lastaddr == 99){
    255e:	064007b7          	lui	a5,0x6400
    2562:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f18bf>
    2566:	06300793          	li	a5,99
    256a:	0af70763          	beq	a4,a5,2618 <sbrkmuch+0x17c>
  a = sbrk(0);
    256e:	4501                	li	a0,0
    2570:	00003097          	auipc	ra,0x3
    2574:	e8c080e7          	jalr	-372(ra) # 53fc <sbrk>
    2578:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    257a:	4501                	li	a0,0
    257c:	00003097          	auipc	ra,0x3
    2580:	e80080e7          	jalr	-384(ra) # 53fc <sbrk>
    2584:	40a9053b          	subw	a0,s2,a0
    2588:	00003097          	auipc	ra,0x3
    258c:	e74080e7          	jalr	-396(ra) # 53fc <sbrk>
  if(c != a){
    2590:	0aa49263          	bne	s1,a0,2634 <sbrkmuch+0x198>
}
    2594:	70a2                	ld	ra,40(sp)
    2596:	7402                	ld	s0,32(sp)
    2598:	64e2                	ld	s1,24(sp)
    259a:	6942                	ld	s2,16(sp)
    259c:	69a2                	ld	s3,8(sp)
    259e:	6a02                	ld	s4,0(sp)
    25a0:	6145                	addi	sp,sp,48
    25a2:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    25a4:	85ce                	mv	a1,s3
    25a6:	00004517          	auipc	a0,0x4
    25aa:	34a50513          	addi	a0,a0,842 # 68f0 <malloc+0x1146>
    25ae:	00003097          	auipc	ra,0x3
    25b2:	13e080e7          	jalr	318(ra) # 56ec <printf>
    exit(1);
    25b6:	4505                	li	a0,1
    25b8:	00003097          	auipc	ra,0x3
    25bc:	dbc080e7          	jalr	-580(ra) # 5374 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    25c0:	85ce                	mv	a1,s3
    25c2:	00004517          	auipc	a0,0x4
    25c6:	37650513          	addi	a0,a0,886 # 6938 <malloc+0x118e>
    25ca:	00003097          	auipc	ra,0x3
    25ce:	122080e7          	jalr	290(ra) # 56ec <printf>
    exit(1);
    25d2:	4505                	li	a0,1
    25d4:	00003097          	auipc	ra,0x3
    25d8:	da0080e7          	jalr	-608(ra) # 5374 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    25dc:	862a                	mv	a2,a0
    25de:	85a6                	mv	a1,s1
    25e0:	00004517          	auipc	a0,0x4
    25e4:	37850513          	addi	a0,a0,888 # 6958 <malloc+0x11ae>
    25e8:	00003097          	auipc	ra,0x3
    25ec:	104080e7          	jalr	260(ra) # 56ec <printf>
    exit(1);
    25f0:	4505                	li	a0,1
    25f2:	00003097          	auipc	ra,0x3
    25f6:	d82080e7          	jalr	-638(ra) # 5374 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    25fa:	8652                	mv	a2,s4
    25fc:	85a6                	mv	a1,s1
    25fe:	00004517          	auipc	a0,0x4
    2602:	39a50513          	addi	a0,a0,922 # 6998 <malloc+0x11ee>
    2606:	00003097          	auipc	ra,0x3
    260a:	0e6080e7          	jalr	230(ra) # 56ec <printf>
    exit(1);
    260e:	4505                	li	a0,1
    2610:	00003097          	auipc	ra,0x3
    2614:	d64080e7          	jalr	-668(ra) # 5374 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2618:	85ce                	mv	a1,s3
    261a:	00004517          	auipc	a0,0x4
    261e:	3ae50513          	addi	a0,a0,942 # 69c8 <malloc+0x121e>
    2622:	00003097          	auipc	ra,0x3
    2626:	0ca080e7          	jalr	202(ra) # 56ec <printf>
    exit(1);
    262a:	4505                	li	a0,1
    262c:	00003097          	auipc	ra,0x3
    2630:	d48080e7          	jalr	-696(ra) # 5374 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    2634:	862a                	mv	a2,a0
    2636:	85a6                	mv	a1,s1
    2638:	00004517          	auipc	a0,0x4
    263c:	3c850513          	addi	a0,a0,968 # 6a00 <malloc+0x1256>
    2640:	00003097          	auipc	ra,0x3
    2644:	0ac080e7          	jalr	172(ra) # 56ec <printf>
    exit(1);
    2648:	4505                	li	a0,1
    264a:	00003097          	auipc	ra,0x3
    264e:	d2a080e7          	jalr	-726(ra) # 5374 <exit>

0000000000002652 <sbrkarg>:
{
    2652:	7179                	addi	sp,sp,-48
    2654:	f406                	sd	ra,40(sp)
    2656:	f022                	sd	s0,32(sp)
    2658:	ec26                	sd	s1,24(sp)
    265a:	e84a                	sd	s2,16(sp)
    265c:	e44e                	sd	s3,8(sp)
    265e:	1800                	addi	s0,sp,48
    2660:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2662:	6505                	lui	a0,0x1
    2664:	00003097          	auipc	ra,0x3
    2668:	d98080e7          	jalr	-616(ra) # 53fc <sbrk>
    266c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    266e:	20100593          	li	a1,513
    2672:	00004517          	auipc	a0,0x4
    2676:	3b650513          	addi	a0,a0,950 # 6a28 <malloc+0x127e>
    267a:	00003097          	auipc	ra,0x3
    267e:	d3a080e7          	jalr	-710(ra) # 53b4 <open>
    2682:	84aa                	mv	s1,a0
  unlink("sbrk");
    2684:	00004517          	auipc	a0,0x4
    2688:	3a450513          	addi	a0,a0,932 # 6a28 <malloc+0x127e>
    268c:	00003097          	auipc	ra,0x3
    2690:	d38080e7          	jalr	-712(ra) # 53c4 <unlink>
  if(fd < 0)  {
    2694:	0404c163          	bltz	s1,26d6 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2698:	6605                	lui	a2,0x1
    269a:	85ca                	mv	a1,s2
    269c:	8526                	mv	a0,s1
    269e:	00003097          	auipc	ra,0x3
    26a2:	cf6080e7          	jalr	-778(ra) # 5394 <write>
    26a6:	04054663          	bltz	a0,26f2 <sbrkarg+0xa0>
  close(fd);
    26aa:	8526                	mv	a0,s1
    26ac:	00003097          	auipc	ra,0x3
    26b0:	cf0080e7          	jalr	-784(ra) # 539c <close>
  a = sbrk(PGSIZE);
    26b4:	6505                	lui	a0,0x1
    26b6:	00003097          	auipc	ra,0x3
    26ba:	d46080e7          	jalr	-698(ra) # 53fc <sbrk>
  if(pipe((int *) a) != 0){
    26be:	00003097          	auipc	ra,0x3
    26c2:	cc6080e7          	jalr	-826(ra) # 5384 <pipe>
    26c6:	e521                	bnez	a0,270e <sbrkarg+0xbc>
}
    26c8:	70a2                	ld	ra,40(sp)
    26ca:	7402                	ld	s0,32(sp)
    26cc:	64e2                	ld	s1,24(sp)
    26ce:	6942                	ld	s2,16(sp)
    26d0:	69a2                	ld	s3,8(sp)
    26d2:	6145                	addi	sp,sp,48
    26d4:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    26d6:	85ce                	mv	a1,s3
    26d8:	00004517          	auipc	a0,0x4
    26dc:	35850513          	addi	a0,a0,856 # 6a30 <malloc+0x1286>
    26e0:	00003097          	auipc	ra,0x3
    26e4:	00c080e7          	jalr	12(ra) # 56ec <printf>
    exit(1);
    26e8:	4505                	li	a0,1
    26ea:	00003097          	auipc	ra,0x3
    26ee:	c8a080e7          	jalr	-886(ra) # 5374 <exit>
    printf("%s: write sbrk failed\n", s);
    26f2:	85ce                	mv	a1,s3
    26f4:	00004517          	auipc	a0,0x4
    26f8:	35450513          	addi	a0,a0,852 # 6a48 <malloc+0x129e>
    26fc:	00003097          	auipc	ra,0x3
    2700:	ff0080e7          	jalr	-16(ra) # 56ec <printf>
    exit(1);
    2704:	4505                	li	a0,1
    2706:	00003097          	auipc	ra,0x3
    270a:	c6e080e7          	jalr	-914(ra) # 5374 <exit>
    printf("%s: pipe() failed\n", s);
    270e:	85ce                	mv	a1,s3
    2710:	00004517          	auipc	a0,0x4
    2714:	df850513          	addi	a0,a0,-520 # 6508 <malloc+0xd5e>
    2718:	00003097          	auipc	ra,0x3
    271c:	fd4080e7          	jalr	-44(ra) # 56ec <printf>
    exit(1);
    2720:	4505                	li	a0,1
    2722:	00003097          	auipc	ra,0x3
    2726:	c52080e7          	jalr	-942(ra) # 5374 <exit>

000000000000272a <argptest>:
{
    272a:	1101                	addi	sp,sp,-32
    272c:	ec06                	sd	ra,24(sp)
    272e:	e822                	sd	s0,16(sp)
    2730:	e426                	sd	s1,8(sp)
    2732:	e04a                	sd	s2,0(sp)
    2734:	1000                	addi	s0,sp,32
    2736:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2738:	4581                	li	a1,0
    273a:	00004517          	auipc	a0,0x4
    273e:	32650513          	addi	a0,a0,806 # 6a60 <malloc+0x12b6>
    2742:	00003097          	auipc	ra,0x3
    2746:	c72080e7          	jalr	-910(ra) # 53b4 <open>
  if (fd < 0) {
    274a:	02054b63          	bltz	a0,2780 <argptest+0x56>
    274e:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2750:	4501                	li	a0,0
    2752:	00003097          	auipc	ra,0x3
    2756:	caa080e7          	jalr	-854(ra) # 53fc <sbrk>
    275a:	567d                	li	a2,-1
    275c:	fff50593          	addi	a1,a0,-1
    2760:	8526                	mv	a0,s1
    2762:	00003097          	auipc	ra,0x3
    2766:	c2a080e7          	jalr	-982(ra) # 538c <read>
  close(fd);
    276a:	8526                	mv	a0,s1
    276c:	00003097          	auipc	ra,0x3
    2770:	c30080e7          	jalr	-976(ra) # 539c <close>
}
    2774:	60e2                	ld	ra,24(sp)
    2776:	6442                	ld	s0,16(sp)
    2778:	64a2                	ld	s1,8(sp)
    277a:	6902                	ld	s2,0(sp)
    277c:	6105                	addi	sp,sp,32
    277e:	8082                	ret
    printf("%s: open failed\n", s);
    2780:	85ca                	mv	a1,s2
    2782:	00004517          	auipc	a0,0x4
    2786:	c9650513          	addi	a0,a0,-874 # 6418 <malloc+0xc6e>
    278a:	00003097          	auipc	ra,0x3
    278e:	f62080e7          	jalr	-158(ra) # 56ec <printf>
    exit(1);
    2792:	4505                	li	a0,1
    2794:	00003097          	auipc	ra,0x3
    2798:	be0080e7          	jalr	-1056(ra) # 5374 <exit>

000000000000279c <sbrkbugs>:
{
    279c:	1141                	addi	sp,sp,-16
    279e:	e406                	sd	ra,8(sp)
    27a0:	e022                	sd	s0,0(sp)
    27a2:	0800                	addi	s0,sp,16
  int pid = fork();
    27a4:	00003097          	auipc	ra,0x3
    27a8:	bc8080e7          	jalr	-1080(ra) # 536c <fork>
  if(pid < 0){
    27ac:	02054263          	bltz	a0,27d0 <sbrkbugs+0x34>
  if(pid == 0){
    27b0:	ed0d                	bnez	a0,27ea <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    27b2:	00003097          	auipc	ra,0x3
    27b6:	c4a080e7          	jalr	-950(ra) # 53fc <sbrk>
    sbrk(-sz);
    27ba:	40a0053b          	negw	a0,a0
    27be:	00003097          	auipc	ra,0x3
    27c2:	c3e080e7          	jalr	-962(ra) # 53fc <sbrk>
    exit(0);
    27c6:	4501                	li	a0,0
    27c8:	00003097          	auipc	ra,0x3
    27cc:	bac080e7          	jalr	-1108(ra) # 5374 <exit>
    printf("fork failed\n");
    27d0:	00004517          	auipc	a0,0x4
    27d4:	02050513          	addi	a0,a0,32 # 67f0 <malloc+0x1046>
    27d8:	00003097          	auipc	ra,0x3
    27dc:	f14080e7          	jalr	-236(ra) # 56ec <printf>
    exit(1);
    27e0:	4505                	li	a0,1
    27e2:	00003097          	auipc	ra,0x3
    27e6:	b92080e7          	jalr	-1134(ra) # 5374 <exit>
  wait(0);
    27ea:	4501                	li	a0,0
    27ec:	00003097          	auipc	ra,0x3
    27f0:	b90080e7          	jalr	-1136(ra) # 537c <wait>
  pid = fork();
    27f4:	00003097          	auipc	ra,0x3
    27f8:	b78080e7          	jalr	-1160(ra) # 536c <fork>
  if(pid < 0){
    27fc:	02054563          	bltz	a0,2826 <sbrkbugs+0x8a>
  if(pid == 0){
    2800:	e121                	bnez	a0,2840 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2802:	00003097          	auipc	ra,0x3
    2806:	bfa080e7          	jalr	-1030(ra) # 53fc <sbrk>
    sbrk(-(sz - 3500));
    280a:	6785                	lui	a5,0x1
    280c:	dac7879b          	addiw	a5,a5,-596
    2810:	40a7853b          	subw	a0,a5,a0
    2814:	00003097          	auipc	ra,0x3
    2818:	be8080e7          	jalr	-1048(ra) # 53fc <sbrk>
    exit(0);
    281c:	4501                	li	a0,0
    281e:	00003097          	auipc	ra,0x3
    2822:	b56080e7          	jalr	-1194(ra) # 5374 <exit>
    printf("fork failed\n");
    2826:	00004517          	auipc	a0,0x4
    282a:	fca50513          	addi	a0,a0,-54 # 67f0 <malloc+0x1046>
    282e:	00003097          	auipc	ra,0x3
    2832:	ebe080e7          	jalr	-322(ra) # 56ec <printf>
    exit(1);
    2836:	4505                	li	a0,1
    2838:	00003097          	auipc	ra,0x3
    283c:	b3c080e7          	jalr	-1220(ra) # 5374 <exit>
  wait(0);
    2840:	4501                	li	a0,0
    2842:	00003097          	auipc	ra,0x3
    2846:	b3a080e7          	jalr	-1222(ra) # 537c <wait>
  pid = fork();
    284a:	00003097          	auipc	ra,0x3
    284e:	b22080e7          	jalr	-1246(ra) # 536c <fork>
  if(pid < 0){
    2852:	02054a63          	bltz	a0,2886 <sbrkbugs+0xea>
  if(pid == 0){
    2856:	e529                	bnez	a0,28a0 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2858:	00003097          	auipc	ra,0x3
    285c:	ba4080e7          	jalr	-1116(ra) # 53fc <sbrk>
    2860:	67ad                	lui	a5,0xb
    2862:	8007879b          	addiw	a5,a5,-2048
    2866:	40a7853b          	subw	a0,a5,a0
    286a:	00003097          	auipc	ra,0x3
    286e:	b92080e7          	jalr	-1134(ra) # 53fc <sbrk>
    sbrk(-10);
    2872:	5559                	li	a0,-10
    2874:	00003097          	auipc	ra,0x3
    2878:	b88080e7          	jalr	-1144(ra) # 53fc <sbrk>
    exit(0);
    287c:	4501                	li	a0,0
    287e:	00003097          	auipc	ra,0x3
    2882:	af6080e7          	jalr	-1290(ra) # 5374 <exit>
    printf("fork failed\n");
    2886:	00004517          	auipc	a0,0x4
    288a:	f6a50513          	addi	a0,a0,-150 # 67f0 <malloc+0x1046>
    288e:	00003097          	auipc	ra,0x3
    2892:	e5e080e7          	jalr	-418(ra) # 56ec <printf>
    exit(1);
    2896:	4505                	li	a0,1
    2898:	00003097          	auipc	ra,0x3
    289c:	adc080e7          	jalr	-1316(ra) # 5374 <exit>
  wait(0);
    28a0:	4501                	li	a0,0
    28a2:	00003097          	auipc	ra,0x3
    28a6:	ada080e7          	jalr	-1318(ra) # 537c <wait>
  exit(0);
    28aa:	4501                	li	a0,0
    28ac:	00003097          	auipc	ra,0x3
    28b0:	ac8080e7          	jalr	-1336(ra) # 5374 <exit>

00000000000028b4 <execout>:
// test the exec() code that cleans up if it runs out
// of memory. it's really a test that such a condition
// doesn't cause a panic.
void
execout(char *s)
{
    28b4:	715d                	addi	sp,sp,-80
    28b6:	e486                	sd	ra,72(sp)
    28b8:	e0a2                	sd	s0,64(sp)
    28ba:	fc26                	sd	s1,56(sp)
    28bc:	f84a                	sd	s2,48(sp)
    28be:	f44e                	sd	s3,40(sp)
    28c0:	f052                	sd	s4,32(sp)
    28c2:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    28c4:	4901                	li	s2,0
    28c6:	49bd                	li	s3,15
    int pid = fork();
    28c8:	00003097          	auipc	ra,0x3
    28cc:	aa4080e7          	jalr	-1372(ra) # 536c <fork>
    28d0:	84aa                	mv	s1,a0
    if(pid < 0){
    28d2:	02054063          	bltz	a0,28f2 <execout+0x3e>
      printf("fork failed\n");
      exit(1);
    } else if(pid == 0){
    28d6:	c91d                	beqz	a0,290c <execout+0x58>
      close(1);
      char *args[] = { "echo", "x", 0 };
      exec("echo", args);
      exit(0);
    } else {
      wait((int*)0);
    28d8:	4501                	li	a0,0
    28da:	00003097          	auipc	ra,0x3
    28de:	aa2080e7          	jalr	-1374(ra) # 537c <wait>
  for(int avail = 0; avail < 15; avail++){
    28e2:	2905                	addiw	s2,s2,1
    28e4:	ff3912e3          	bne	s2,s3,28c8 <execout+0x14>
    }
  }

  exit(0);
    28e8:	4501                	li	a0,0
    28ea:	00003097          	auipc	ra,0x3
    28ee:	a8a080e7          	jalr	-1398(ra) # 5374 <exit>
      printf("fork failed\n");
    28f2:	00004517          	auipc	a0,0x4
    28f6:	efe50513          	addi	a0,a0,-258 # 67f0 <malloc+0x1046>
    28fa:	00003097          	auipc	ra,0x3
    28fe:	df2080e7          	jalr	-526(ra) # 56ec <printf>
      exit(1);
    2902:	4505                	li	a0,1
    2904:	00003097          	auipc	ra,0x3
    2908:	a70080e7          	jalr	-1424(ra) # 5374 <exit>
        if(a == 0xffffffffffffffffLL)
    290c:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    290e:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2910:	6505                	lui	a0,0x1
    2912:	00003097          	auipc	ra,0x3
    2916:	aea080e7          	jalr	-1302(ra) # 53fc <sbrk>
        if(a == 0xffffffffffffffffLL)
    291a:	01350763          	beq	a0,s3,2928 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    291e:	6785                	lui	a5,0x1
    2920:	953e                	add	a0,a0,a5
    2922:	ff450fa3          	sb	s4,-1(a0) # fff <bigdir+0x95>
      while(1){
    2926:	b7ed                	j	2910 <execout+0x5c>
      for(int i = 0; i < avail; i++)
    2928:	01205a63          	blez	s2,293c <execout+0x88>
        sbrk(-4096);
    292c:	757d                	lui	a0,0xfffff
    292e:	00003097          	auipc	ra,0x3
    2932:	ace080e7          	jalr	-1330(ra) # 53fc <sbrk>
      for(int i = 0; i < avail; i++)
    2936:	2485                	addiw	s1,s1,1
    2938:	ff249ae3          	bne	s1,s2,292c <execout+0x78>
      close(1);
    293c:	4505                	li	a0,1
    293e:	00003097          	auipc	ra,0x3
    2942:	a5e080e7          	jalr	-1442(ra) # 539c <close>
      char *args[] = { "echo", "x", 0 };
    2946:	00003517          	auipc	a0,0x3
    294a:	28250513          	addi	a0,a0,642 # 5bc8 <malloc+0x41e>
    294e:	faa43c23          	sd	a0,-72(s0)
    2952:	00003797          	auipc	a5,0x3
    2956:	2e678793          	addi	a5,a5,742 # 5c38 <malloc+0x48e>
    295a:	fcf43023          	sd	a5,-64(s0)
    295e:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2962:	fb840593          	addi	a1,s0,-72
    2966:	00003097          	auipc	ra,0x3
    296a:	a46080e7          	jalr	-1466(ra) # 53ac <exec>
      exit(0);
    296e:	4501                	li	a0,0
    2970:	00003097          	auipc	ra,0x3
    2974:	a04080e7          	jalr	-1532(ra) # 5374 <exit>

0000000000002978 <fourteen>:
{
    2978:	1101                	addi	sp,sp,-32
    297a:	ec06                	sd	ra,24(sp)
    297c:	e822                	sd	s0,16(sp)
    297e:	e426                	sd	s1,8(sp)
    2980:	1000                	addi	s0,sp,32
    2982:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    2984:	00004517          	auipc	a0,0x4
    2988:	2b450513          	addi	a0,a0,692 # 6c38 <malloc+0x148e>
    298c:	00003097          	auipc	ra,0x3
    2990:	a50080e7          	jalr	-1456(ra) # 53dc <mkdir>
    2994:	e165                	bnez	a0,2a74 <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    2996:	00004517          	auipc	a0,0x4
    299a:	0fa50513          	addi	a0,a0,250 # 6a90 <malloc+0x12e6>
    299e:	00003097          	auipc	ra,0x3
    29a2:	a3e080e7          	jalr	-1474(ra) # 53dc <mkdir>
    29a6:	e56d                	bnez	a0,2a90 <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    29a8:	20000593          	li	a1,512
    29ac:	00004517          	auipc	a0,0x4
    29b0:	13c50513          	addi	a0,a0,316 # 6ae8 <malloc+0x133e>
    29b4:	00003097          	auipc	ra,0x3
    29b8:	a00080e7          	jalr	-1536(ra) # 53b4 <open>
  if(fd < 0){
    29bc:	0e054863          	bltz	a0,2aac <fourteen+0x134>
  close(fd);
    29c0:	00003097          	auipc	ra,0x3
    29c4:	9dc080e7          	jalr	-1572(ra) # 539c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    29c8:	4581                	li	a1,0
    29ca:	00004517          	auipc	a0,0x4
    29ce:	19650513          	addi	a0,a0,406 # 6b60 <malloc+0x13b6>
    29d2:	00003097          	auipc	ra,0x3
    29d6:	9e2080e7          	jalr	-1566(ra) # 53b4 <open>
  if(fd < 0){
    29da:	0e054763          	bltz	a0,2ac8 <fourteen+0x150>
  close(fd);
    29de:	00003097          	auipc	ra,0x3
    29e2:	9be080e7          	jalr	-1602(ra) # 539c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    29e6:	00004517          	auipc	a0,0x4
    29ea:	1ea50513          	addi	a0,a0,490 # 6bd0 <malloc+0x1426>
    29ee:	00003097          	auipc	ra,0x3
    29f2:	9ee080e7          	jalr	-1554(ra) # 53dc <mkdir>
    29f6:	c57d                	beqz	a0,2ae4 <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    29f8:	00004517          	auipc	a0,0x4
    29fc:	23050513          	addi	a0,a0,560 # 6c28 <malloc+0x147e>
    2a00:	00003097          	auipc	ra,0x3
    2a04:	9dc080e7          	jalr	-1572(ra) # 53dc <mkdir>
    2a08:	cd65                	beqz	a0,2b00 <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    2a0a:	00004517          	auipc	a0,0x4
    2a0e:	21e50513          	addi	a0,a0,542 # 6c28 <malloc+0x147e>
    2a12:	00003097          	auipc	ra,0x3
    2a16:	9b2080e7          	jalr	-1614(ra) # 53c4 <unlink>
  unlink("12345678901234/12345678901234");
    2a1a:	00004517          	auipc	a0,0x4
    2a1e:	1b650513          	addi	a0,a0,438 # 6bd0 <malloc+0x1426>
    2a22:	00003097          	auipc	ra,0x3
    2a26:	9a2080e7          	jalr	-1630(ra) # 53c4 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2a2a:	00004517          	auipc	a0,0x4
    2a2e:	13650513          	addi	a0,a0,310 # 6b60 <malloc+0x13b6>
    2a32:	00003097          	auipc	ra,0x3
    2a36:	992080e7          	jalr	-1646(ra) # 53c4 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2a3a:	00004517          	auipc	a0,0x4
    2a3e:	0ae50513          	addi	a0,a0,174 # 6ae8 <malloc+0x133e>
    2a42:	00003097          	auipc	ra,0x3
    2a46:	982080e7          	jalr	-1662(ra) # 53c4 <unlink>
  unlink("12345678901234/123456789012345");
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	04650513          	addi	a0,a0,70 # 6a90 <malloc+0x12e6>
    2a52:	00003097          	auipc	ra,0x3
    2a56:	972080e7          	jalr	-1678(ra) # 53c4 <unlink>
  unlink("12345678901234");
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	1de50513          	addi	a0,a0,478 # 6c38 <malloc+0x148e>
    2a62:	00003097          	auipc	ra,0x3
    2a66:	962080e7          	jalr	-1694(ra) # 53c4 <unlink>
}
    2a6a:	60e2                	ld	ra,24(sp)
    2a6c:	6442                	ld	s0,16(sp)
    2a6e:	64a2                	ld	s1,8(sp)
    2a70:	6105                	addi	sp,sp,32
    2a72:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2a74:	85a6                	mv	a1,s1
    2a76:	00004517          	auipc	a0,0x4
    2a7a:	ff250513          	addi	a0,a0,-14 # 6a68 <malloc+0x12be>
    2a7e:	00003097          	auipc	ra,0x3
    2a82:	c6e080e7          	jalr	-914(ra) # 56ec <printf>
    exit(1);
    2a86:	4505                	li	a0,1
    2a88:	00003097          	auipc	ra,0x3
    2a8c:	8ec080e7          	jalr	-1812(ra) # 5374 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2a90:	85a6                	mv	a1,s1
    2a92:	00004517          	auipc	a0,0x4
    2a96:	01e50513          	addi	a0,a0,30 # 6ab0 <malloc+0x1306>
    2a9a:	00003097          	auipc	ra,0x3
    2a9e:	c52080e7          	jalr	-942(ra) # 56ec <printf>
    exit(1);
    2aa2:	4505                	li	a0,1
    2aa4:	00003097          	auipc	ra,0x3
    2aa8:	8d0080e7          	jalr	-1840(ra) # 5374 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2aac:	85a6                	mv	a1,s1
    2aae:	00004517          	auipc	a0,0x4
    2ab2:	06a50513          	addi	a0,a0,106 # 6b18 <malloc+0x136e>
    2ab6:	00003097          	auipc	ra,0x3
    2aba:	c36080e7          	jalr	-970(ra) # 56ec <printf>
    exit(1);
    2abe:	4505                	li	a0,1
    2ac0:	00003097          	auipc	ra,0x3
    2ac4:	8b4080e7          	jalr	-1868(ra) # 5374 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2ac8:	85a6                	mv	a1,s1
    2aca:	00004517          	auipc	a0,0x4
    2ace:	0c650513          	addi	a0,a0,198 # 6b90 <malloc+0x13e6>
    2ad2:	00003097          	auipc	ra,0x3
    2ad6:	c1a080e7          	jalr	-998(ra) # 56ec <printf>
    exit(1);
    2ada:	4505                	li	a0,1
    2adc:	00003097          	auipc	ra,0x3
    2ae0:	898080e7          	jalr	-1896(ra) # 5374 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2ae4:	85a6                	mv	a1,s1
    2ae6:	00004517          	auipc	a0,0x4
    2aea:	10a50513          	addi	a0,a0,266 # 6bf0 <malloc+0x1446>
    2aee:	00003097          	auipc	ra,0x3
    2af2:	bfe080e7          	jalr	-1026(ra) # 56ec <printf>
    exit(1);
    2af6:	4505                	li	a0,1
    2af8:	00003097          	auipc	ra,0x3
    2afc:	87c080e7          	jalr	-1924(ra) # 5374 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2b00:	85a6                	mv	a1,s1
    2b02:	00004517          	auipc	a0,0x4
    2b06:	14650513          	addi	a0,a0,326 # 6c48 <malloc+0x149e>
    2b0a:	00003097          	auipc	ra,0x3
    2b0e:	be2080e7          	jalr	-1054(ra) # 56ec <printf>
    exit(1);
    2b12:	4505                	li	a0,1
    2b14:	00003097          	auipc	ra,0x3
    2b18:	860080e7          	jalr	-1952(ra) # 5374 <exit>

0000000000002b1c <iputtest>:
{
    2b1c:	1101                	addi	sp,sp,-32
    2b1e:	ec06                	sd	ra,24(sp)
    2b20:	e822                	sd	s0,16(sp)
    2b22:	e426                	sd	s1,8(sp)
    2b24:	1000                	addi	s0,sp,32
    2b26:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b28:	00004517          	auipc	a0,0x4
    2b2c:	15850513          	addi	a0,a0,344 # 6c80 <malloc+0x14d6>
    2b30:	00003097          	auipc	ra,0x3
    2b34:	8ac080e7          	jalr	-1876(ra) # 53dc <mkdir>
    2b38:	04054563          	bltz	a0,2b82 <iputtest+0x66>
  if(chdir("iputdir") < 0){
    2b3c:	00004517          	auipc	a0,0x4
    2b40:	14450513          	addi	a0,a0,324 # 6c80 <malloc+0x14d6>
    2b44:	00003097          	auipc	ra,0x3
    2b48:	8a0080e7          	jalr	-1888(ra) # 53e4 <chdir>
    2b4c:	04054963          	bltz	a0,2b9e <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    2b50:	00004517          	auipc	a0,0x4
    2b54:	17050513          	addi	a0,a0,368 # 6cc0 <malloc+0x1516>
    2b58:	00003097          	auipc	ra,0x3
    2b5c:	86c080e7          	jalr	-1940(ra) # 53c4 <unlink>
    2b60:	04054d63          	bltz	a0,2bba <iputtest+0x9e>
  if(chdir("/") < 0){
    2b64:	00004517          	auipc	a0,0x4
    2b68:	18c50513          	addi	a0,a0,396 # 6cf0 <malloc+0x1546>
    2b6c:	00003097          	auipc	ra,0x3
    2b70:	878080e7          	jalr	-1928(ra) # 53e4 <chdir>
    2b74:	06054163          	bltz	a0,2bd6 <iputtest+0xba>
}
    2b78:	60e2                	ld	ra,24(sp)
    2b7a:	6442                	ld	s0,16(sp)
    2b7c:	64a2                	ld	s1,8(sp)
    2b7e:	6105                	addi	sp,sp,32
    2b80:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b82:	85a6                	mv	a1,s1
    2b84:	00004517          	auipc	a0,0x4
    2b88:	10450513          	addi	a0,a0,260 # 6c88 <malloc+0x14de>
    2b8c:	00003097          	auipc	ra,0x3
    2b90:	b60080e7          	jalr	-1184(ra) # 56ec <printf>
    exit(1);
    2b94:	4505                	li	a0,1
    2b96:	00002097          	auipc	ra,0x2
    2b9a:	7de080e7          	jalr	2014(ra) # 5374 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b9e:	85a6                	mv	a1,s1
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	10050513          	addi	a0,a0,256 # 6ca0 <malloc+0x14f6>
    2ba8:	00003097          	auipc	ra,0x3
    2bac:	b44080e7          	jalr	-1212(ra) # 56ec <printf>
    exit(1);
    2bb0:	4505                	li	a0,1
    2bb2:	00002097          	auipc	ra,0x2
    2bb6:	7c2080e7          	jalr	1986(ra) # 5374 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2bba:	85a6                	mv	a1,s1
    2bbc:	00004517          	auipc	a0,0x4
    2bc0:	11450513          	addi	a0,a0,276 # 6cd0 <malloc+0x1526>
    2bc4:	00003097          	auipc	ra,0x3
    2bc8:	b28080e7          	jalr	-1240(ra) # 56ec <printf>
    exit(1);
    2bcc:	4505                	li	a0,1
    2bce:	00002097          	auipc	ra,0x2
    2bd2:	7a6080e7          	jalr	1958(ra) # 5374 <exit>
    printf("%s: chdir / failed\n", s);
    2bd6:	85a6                	mv	a1,s1
    2bd8:	00004517          	auipc	a0,0x4
    2bdc:	12050513          	addi	a0,a0,288 # 6cf8 <malloc+0x154e>
    2be0:	00003097          	auipc	ra,0x3
    2be4:	b0c080e7          	jalr	-1268(ra) # 56ec <printf>
    exit(1);
    2be8:	4505                	li	a0,1
    2bea:	00002097          	auipc	ra,0x2
    2bee:	78a080e7          	jalr	1930(ra) # 5374 <exit>

0000000000002bf2 <exitiputtest>:
{
    2bf2:	7179                	addi	sp,sp,-48
    2bf4:	f406                	sd	ra,40(sp)
    2bf6:	f022                	sd	s0,32(sp)
    2bf8:	ec26                	sd	s1,24(sp)
    2bfa:	1800                	addi	s0,sp,48
    2bfc:	84aa                	mv	s1,a0
  pid = fork();
    2bfe:	00002097          	auipc	ra,0x2
    2c02:	76e080e7          	jalr	1902(ra) # 536c <fork>
  if(pid < 0){
    2c06:	04054663          	bltz	a0,2c52 <exitiputtest+0x60>
  if(pid == 0){
    2c0a:	ed45                	bnez	a0,2cc2 <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    2c0c:	00004517          	auipc	a0,0x4
    2c10:	07450513          	addi	a0,a0,116 # 6c80 <malloc+0x14d6>
    2c14:	00002097          	auipc	ra,0x2
    2c18:	7c8080e7          	jalr	1992(ra) # 53dc <mkdir>
    2c1c:	04054963          	bltz	a0,2c6e <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    2c20:	00004517          	auipc	a0,0x4
    2c24:	06050513          	addi	a0,a0,96 # 6c80 <malloc+0x14d6>
    2c28:	00002097          	auipc	ra,0x2
    2c2c:	7bc080e7          	jalr	1980(ra) # 53e4 <chdir>
    2c30:	04054d63          	bltz	a0,2c8a <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    2c34:	00004517          	auipc	a0,0x4
    2c38:	08c50513          	addi	a0,a0,140 # 6cc0 <malloc+0x1516>
    2c3c:	00002097          	auipc	ra,0x2
    2c40:	788080e7          	jalr	1928(ra) # 53c4 <unlink>
    2c44:	06054163          	bltz	a0,2ca6 <exitiputtest+0xb4>
    exit(0);
    2c48:	4501                	li	a0,0
    2c4a:	00002097          	auipc	ra,0x2
    2c4e:	72a080e7          	jalr	1834(ra) # 5374 <exit>
    printf("%s: fork failed\n", s);
    2c52:	85a6                	mv	a1,s1
    2c54:	00003517          	auipc	a0,0x3
    2c58:	7ac50513          	addi	a0,a0,1964 # 6400 <malloc+0xc56>
    2c5c:	00003097          	auipc	ra,0x3
    2c60:	a90080e7          	jalr	-1392(ra) # 56ec <printf>
    exit(1);
    2c64:	4505                	li	a0,1
    2c66:	00002097          	auipc	ra,0x2
    2c6a:	70e080e7          	jalr	1806(ra) # 5374 <exit>
      printf("%s: mkdir failed\n", s);
    2c6e:	85a6                	mv	a1,s1
    2c70:	00004517          	auipc	a0,0x4
    2c74:	01850513          	addi	a0,a0,24 # 6c88 <malloc+0x14de>
    2c78:	00003097          	auipc	ra,0x3
    2c7c:	a74080e7          	jalr	-1420(ra) # 56ec <printf>
      exit(1);
    2c80:	4505                	li	a0,1
    2c82:	00002097          	auipc	ra,0x2
    2c86:	6f2080e7          	jalr	1778(ra) # 5374 <exit>
      printf("%s: child chdir failed\n", s);
    2c8a:	85a6                	mv	a1,s1
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	08450513          	addi	a0,a0,132 # 6d10 <malloc+0x1566>
    2c94:	00003097          	auipc	ra,0x3
    2c98:	a58080e7          	jalr	-1448(ra) # 56ec <printf>
      exit(1);
    2c9c:	4505                	li	a0,1
    2c9e:	00002097          	auipc	ra,0x2
    2ca2:	6d6080e7          	jalr	1750(ra) # 5374 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2ca6:	85a6                	mv	a1,s1
    2ca8:	00004517          	auipc	a0,0x4
    2cac:	02850513          	addi	a0,a0,40 # 6cd0 <malloc+0x1526>
    2cb0:	00003097          	auipc	ra,0x3
    2cb4:	a3c080e7          	jalr	-1476(ra) # 56ec <printf>
      exit(1);
    2cb8:	4505                	li	a0,1
    2cba:	00002097          	auipc	ra,0x2
    2cbe:	6ba080e7          	jalr	1722(ra) # 5374 <exit>
  wait(&xstatus);
    2cc2:	fdc40513          	addi	a0,s0,-36
    2cc6:	00002097          	auipc	ra,0x2
    2cca:	6b6080e7          	jalr	1718(ra) # 537c <wait>
  exit(xstatus);
    2cce:	fdc42503          	lw	a0,-36(s0)
    2cd2:	00002097          	auipc	ra,0x2
    2cd6:	6a2080e7          	jalr	1698(ra) # 5374 <exit>

0000000000002cda <subdir>:
{
    2cda:	1101                	addi	sp,sp,-32
    2cdc:	ec06                	sd	ra,24(sp)
    2cde:	e822                	sd	s0,16(sp)
    2ce0:	e426                	sd	s1,8(sp)
    2ce2:	e04a                	sd	s2,0(sp)
    2ce4:	1000                	addi	s0,sp,32
    2ce6:	892a                	mv	s2,a0
  unlink("ff");
    2ce8:	00004517          	auipc	a0,0x4
    2cec:	17050513          	addi	a0,a0,368 # 6e58 <malloc+0x16ae>
    2cf0:	00002097          	auipc	ra,0x2
    2cf4:	6d4080e7          	jalr	1748(ra) # 53c4 <unlink>
  if(mkdir("dd") != 0){
    2cf8:	00004517          	auipc	a0,0x4
    2cfc:	03050513          	addi	a0,a0,48 # 6d28 <malloc+0x157e>
    2d00:	00002097          	auipc	ra,0x2
    2d04:	6dc080e7          	jalr	1756(ra) # 53dc <mkdir>
    2d08:	38051663          	bnez	a0,3094 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d0c:	20200593          	li	a1,514
    2d10:	00004517          	auipc	a0,0x4
    2d14:	03850513          	addi	a0,a0,56 # 6d48 <malloc+0x159e>
    2d18:	00002097          	auipc	ra,0x2
    2d1c:	69c080e7          	jalr	1692(ra) # 53b4 <open>
    2d20:	84aa                	mv	s1,a0
  if(fd < 0){
    2d22:	38054763          	bltz	a0,30b0 <subdir+0x3d6>
  write(fd, "ff", 2);
    2d26:	4609                	li	a2,2
    2d28:	00004597          	auipc	a1,0x4
    2d2c:	13058593          	addi	a1,a1,304 # 6e58 <malloc+0x16ae>
    2d30:	00002097          	auipc	ra,0x2
    2d34:	664080e7          	jalr	1636(ra) # 5394 <write>
  close(fd);
    2d38:	8526                	mv	a0,s1
    2d3a:	00002097          	auipc	ra,0x2
    2d3e:	662080e7          	jalr	1634(ra) # 539c <close>
  if(unlink("dd") >= 0){
    2d42:	00004517          	auipc	a0,0x4
    2d46:	fe650513          	addi	a0,a0,-26 # 6d28 <malloc+0x157e>
    2d4a:	00002097          	auipc	ra,0x2
    2d4e:	67a080e7          	jalr	1658(ra) # 53c4 <unlink>
    2d52:	36055d63          	bgez	a0,30cc <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2d56:	00004517          	auipc	a0,0x4
    2d5a:	04a50513          	addi	a0,a0,74 # 6da0 <malloc+0x15f6>
    2d5e:	00002097          	auipc	ra,0x2
    2d62:	67e080e7          	jalr	1662(ra) # 53dc <mkdir>
    2d66:	38051163          	bnez	a0,30e8 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d6a:	20200593          	li	a1,514
    2d6e:	00004517          	auipc	a0,0x4
    2d72:	05a50513          	addi	a0,a0,90 # 6dc8 <malloc+0x161e>
    2d76:	00002097          	auipc	ra,0x2
    2d7a:	63e080e7          	jalr	1598(ra) # 53b4 <open>
    2d7e:	84aa                	mv	s1,a0
  if(fd < 0){
    2d80:	38054263          	bltz	a0,3104 <subdir+0x42a>
  write(fd, "FF", 2);
    2d84:	4609                	li	a2,2
    2d86:	00004597          	auipc	a1,0x4
    2d8a:	07258593          	addi	a1,a1,114 # 6df8 <malloc+0x164e>
    2d8e:	00002097          	auipc	ra,0x2
    2d92:	606080e7          	jalr	1542(ra) # 5394 <write>
  close(fd);
    2d96:	8526                	mv	a0,s1
    2d98:	00002097          	auipc	ra,0x2
    2d9c:	604080e7          	jalr	1540(ra) # 539c <close>
  fd = open("dd/dd/../ff", 0);
    2da0:	4581                	li	a1,0
    2da2:	00004517          	auipc	a0,0x4
    2da6:	05e50513          	addi	a0,a0,94 # 6e00 <malloc+0x1656>
    2daa:	00002097          	auipc	ra,0x2
    2dae:	60a080e7          	jalr	1546(ra) # 53b4 <open>
    2db2:	84aa                	mv	s1,a0
  if(fd < 0){
    2db4:	36054663          	bltz	a0,3120 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2db8:	660d                	lui	a2,0x3
    2dba:	00009597          	auipc	a1,0x9
    2dbe:	97658593          	addi	a1,a1,-1674 # b730 <buf>
    2dc2:	00002097          	auipc	ra,0x2
    2dc6:	5ca080e7          	jalr	1482(ra) # 538c <read>
  if(cc != 2 || buf[0] != 'f'){
    2dca:	4789                	li	a5,2
    2dcc:	36f51863          	bne	a0,a5,313c <subdir+0x462>
    2dd0:	00009717          	auipc	a4,0x9
    2dd4:	96074703          	lbu	a4,-1696(a4) # b730 <buf>
    2dd8:	06600793          	li	a5,102
    2ddc:	36f71063          	bne	a4,a5,313c <subdir+0x462>
  close(fd);
    2de0:	8526                	mv	a0,s1
    2de2:	00002097          	auipc	ra,0x2
    2de6:	5ba080e7          	jalr	1466(ra) # 539c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2dea:	00004597          	auipc	a1,0x4
    2dee:	06658593          	addi	a1,a1,102 # 6e50 <malloc+0x16a6>
    2df2:	00004517          	auipc	a0,0x4
    2df6:	fd650513          	addi	a0,a0,-42 # 6dc8 <malloc+0x161e>
    2dfa:	00002097          	auipc	ra,0x2
    2dfe:	5da080e7          	jalr	1498(ra) # 53d4 <link>
    2e02:	34051b63          	bnez	a0,3158 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2e06:	00004517          	auipc	a0,0x4
    2e0a:	fc250513          	addi	a0,a0,-62 # 6dc8 <malloc+0x161e>
    2e0e:	00002097          	auipc	ra,0x2
    2e12:	5b6080e7          	jalr	1462(ra) # 53c4 <unlink>
    2e16:	34051f63          	bnez	a0,3174 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e1a:	4581                	li	a1,0
    2e1c:	00004517          	auipc	a0,0x4
    2e20:	fac50513          	addi	a0,a0,-84 # 6dc8 <malloc+0x161e>
    2e24:	00002097          	auipc	ra,0x2
    2e28:	590080e7          	jalr	1424(ra) # 53b4 <open>
    2e2c:	36055263          	bgez	a0,3190 <subdir+0x4b6>
  if(chdir("dd") != 0){
    2e30:	00004517          	auipc	a0,0x4
    2e34:	ef850513          	addi	a0,a0,-264 # 6d28 <malloc+0x157e>
    2e38:	00002097          	auipc	ra,0x2
    2e3c:	5ac080e7          	jalr	1452(ra) # 53e4 <chdir>
    2e40:	36051663          	bnez	a0,31ac <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2e44:	00004517          	auipc	a0,0x4
    2e48:	0a450513          	addi	a0,a0,164 # 6ee8 <malloc+0x173e>
    2e4c:	00002097          	auipc	ra,0x2
    2e50:	598080e7          	jalr	1432(ra) # 53e4 <chdir>
    2e54:	36051a63          	bnez	a0,31c8 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2e58:	00004517          	auipc	a0,0x4
    2e5c:	0c050513          	addi	a0,a0,192 # 6f18 <malloc+0x176e>
    2e60:	00002097          	auipc	ra,0x2
    2e64:	584080e7          	jalr	1412(ra) # 53e4 <chdir>
    2e68:	36051e63          	bnez	a0,31e4 <subdir+0x50a>
  if(chdir("./..") != 0){
    2e6c:	00004517          	auipc	a0,0x4
    2e70:	0dc50513          	addi	a0,a0,220 # 6f48 <malloc+0x179e>
    2e74:	00002097          	auipc	ra,0x2
    2e78:	570080e7          	jalr	1392(ra) # 53e4 <chdir>
    2e7c:	38051263          	bnez	a0,3200 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2e80:	4581                	li	a1,0
    2e82:	00004517          	auipc	a0,0x4
    2e86:	fce50513          	addi	a0,a0,-50 # 6e50 <malloc+0x16a6>
    2e8a:	00002097          	auipc	ra,0x2
    2e8e:	52a080e7          	jalr	1322(ra) # 53b4 <open>
    2e92:	84aa                	mv	s1,a0
  if(fd < 0){
    2e94:	38054463          	bltz	a0,321c <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e98:	660d                	lui	a2,0x3
    2e9a:	00009597          	auipc	a1,0x9
    2e9e:	89658593          	addi	a1,a1,-1898 # b730 <buf>
    2ea2:	00002097          	auipc	ra,0x2
    2ea6:	4ea080e7          	jalr	1258(ra) # 538c <read>
    2eaa:	4789                	li	a5,2
    2eac:	38f51663          	bne	a0,a5,3238 <subdir+0x55e>
  close(fd);
    2eb0:	8526                	mv	a0,s1
    2eb2:	00002097          	auipc	ra,0x2
    2eb6:	4ea080e7          	jalr	1258(ra) # 539c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2eba:	4581                	li	a1,0
    2ebc:	00004517          	auipc	a0,0x4
    2ec0:	f0c50513          	addi	a0,a0,-244 # 6dc8 <malloc+0x161e>
    2ec4:	00002097          	auipc	ra,0x2
    2ec8:	4f0080e7          	jalr	1264(ra) # 53b4 <open>
    2ecc:	38055463          	bgez	a0,3254 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2ed0:	20200593          	li	a1,514
    2ed4:	00004517          	auipc	a0,0x4
    2ed8:	10450513          	addi	a0,a0,260 # 6fd8 <malloc+0x182e>
    2edc:	00002097          	auipc	ra,0x2
    2ee0:	4d8080e7          	jalr	1240(ra) # 53b4 <open>
    2ee4:	38055663          	bgez	a0,3270 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2ee8:	20200593          	li	a1,514
    2eec:	00004517          	auipc	a0,0x4
    2ef0:	11c50513          	addi	a0,a0,284 # 7008 <malloc+0x185e>
    2ef4:	00002097          	auipc	ra,0x2
    2ef8:	4c0080e7          	jalr	1216(ra) # 53b4 <open>
    2efc:	38055863          	bgez	a0,328c <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2f00:	20000593          	li	a1,512
    2f04:	00004517          	auipc	a0,0x4
    2f08:	e2450513          	addi	a0,a0,-476 # 6d28 <malloc+0x157e>
    2f0c:	00002097          	auipc	ra,0x2
    2f10:	4a8080e7          	jalr	1192(ra) # 53b4 <open>
    2f14:	38055a63          	bgez	a0,32a8 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2f18:	4589                	li	a1,2
    2f1a:	00004517          	auipc	a0,0x4
    2f1e:	e0e50513          	addi	a0,a0,-498 # 6d28 <malloc+0x157e>
    2f22:	00002097          	auipc	ra,0x2
    2f26:	492080e7          	jalr	1170(ra) # 53b4 <open>
    2f2a:	38055d63          	bgez	a0,32c4 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2f2e:	4585                	li	a1,1
    2f30:	00004517          	auipc	a0,0x4
    2f34:	df850513          	addi	a0,a0,-520 # 6d28 <malloc+0x157e>
    2f38:	00002097          	auipc	ra,0x2
    2f3c:	47c080e7          	jalr	1148(ra) # 53b4 <open>
    2f40:	3a055063          	bgez	a0,32e0 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2f44:	00004597          	auipc	a1,0x4
    2f48:	15458593          	addi	a1,a1,340 # 7098 <malloc+0x18ee>
    2f4c:	00004517          	auipc	a0,0x4
    2f50:	08c50513          	addi	a0,a0,140 # 6fd8 <malloc+0x182e>
    2f54:	00002097          	auipc	ra,0x2
    2f58:	480080e7          	jalr	1152(ra) # 53d4 <link>
    2f5c:	3a050063          	beqz	a0,32fc <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f60:	00004597          	auipc	a1,0x4
    2f64:	13858593          	addi	a1,a1,312 # 7098 <malloc+0x18ee>
    2f68:	00004517          	auipc	a0,0x4
    2f6c:	0a050513          	addi	a0,a0,160 # 7008 <malloc+0x185e>
    2f70:	00002097          	auipc	ra,0x2
    2f74:	464080e7          	jalr	1124(ra) # 53d4 <link>
    2f78:	3a050063          	beqz	a0,3318 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f7c:	00004597          	auipc	a1,0x4
    2f80:	ed458593          	addi	a1,a1,-300 # 6e50 <malloc+0x16a6>
    2f84:	00004517          	auipc	a0,0x4
    2f88:	dc450513          	addi	a0,a0,-572 # 6d48 <malloc+0x159e>
    2f8c:	00002097          	auipc	ra,0x2
    2f90:	448080e7          	jalr	1096(ra) # 53d4 <link>
    2f94:	3a050063          	beqz	a0,3334 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2f98:	00004517          	auipc	a0,0x4
    2f9c:	04050513          	addi	a0,a0,64 # 6fd8 <malloc+0x182e>
    2fa0:	00002097          	auipc	ra,0x2
    2fa4:	43c080e7          	jalr	1084(ra) # 53dc <mkdir>
    2fa8:	3a050463          	beqz	a0,3350 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2fac:	00004517          	auipc	a0,0x4
    2fb0:	05c50513          	addi	a0,a0,92 # 7008 <malloc+0x185e>
    2fb4:	00002097          	auipc	ra,0x2
    2fb8:	428080e7          	jalr	1064(ra) # 53dc <mkdir>
    2fbc:	3a050863          	beqz	a0,336c <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2fc0:	00004517          	auipc	a0,0x4
    2fc4:	e9050513          	addi	a0,a0,-368 # 6e50 <malloc+0x16a6>
    2fc8:	00002097          	auipc	ra,0x2
    2fcc:	414080e7          	jalr	1044(ra) # 53dc <mkdir>
    2fd0:	3a050c63          	beqz	a0,3388 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2fd4:	00004517          	auipc	a0,0x4
    2fd8:	03450513          	addi	a0,a0,52 # 7008 <malloc+0x185e>
    2fdc:	00002097          	auipc	ra,0x2
    2fe0:	3e8080e7          	jalr	1000(ra) # 53c4 <unlink>
    2fe4:	3c050063          	beqz	a0,33a4 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2fe8:	00004517          	auipc	a0,0x4
    2fec:	ff050513          	addi	a0,a0,-16 # 6fd8 <malloc+0x182e>
    2ff0:	00002097          	auipc	ra,0x2
    2ff4:	3d4080e7          	jalr	980(ra) # 53c4 <unlink>
    2ff8:	3c050463          	beqz	a0,33c0 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2ffc:	00004517          	auipc	a0,0x4
    3000:	d4c50513          	addi	a0,a0,-692 # 6d48 <malloc+0x159e>
    3004:	00002097          	auipc	ra,0x2
    3008:	3e0080e7          	jalr	992(ra) # 53e4 <chdir>
    300c:	3c050863          	beqz	a0,33dc <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3010:	00004517          	auipc	a0,0x4
    3014:	1d850513          	addi	a0,a0,472 # 71e8 <malloc+0x1a3e>
    3018:	00002097          	auipc	ra,0x2
    301c:	3cc080e7          	jalr	972(ra) # 53e4 <chdir>
    3020:	3c050c63          	beqz	a0,33f8 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3024:	00004517          	auipc	a0,0x4
    3028:	e2c50513          	addi	a0,a0,-468 # 6e50 <malloc+0x16a6>
    302c:	00002097          	auipc	ra,0x2
    3030:	398080e7          	jalr	920(ra) # 53c4 <unlink>
    3034:	3e051063          	bnez	a0,3414 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3038:	00004517          	auipc	a0,0x4
    303c:	d1050513          	addi	a0,a0,-752 # 6d48 <malloc+0x159e>
    3040:	00002097          	auipc	ra,0x2
    3044:	384080e7          	jalr	900(ra) # 53c4 <unlink>
    3048:	3e051463          	bnez	a0,3430 <subdir+0x756>
  if(unlink("dd") == 0){
    304c:	00004517          	auipc	a0,0x4
    3050:	cdc50513          	addi	a0,a0,-804 # 6d28 <malloc+0x157e>
    3054:	00002097          	auipc	ra,0x2
    3058:	370080e7          	jalr	880(ra) # 53c4 <unlink>
    305c:	3e050863          	beqz	a0,344c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3060:	00004517          	auipc	a0,0x4
    3064:	1f850513          	addi	a0,a0,504 # 7258 <malloc+0x1aae>
    3068:	00002097          	auipc	ra,0x2
    306c:	35c080e7          	jalr	860(ra) # 53c4 <unlink>
    3070:	3e054c63          	bltz	a0,3468 <subdir+0x78e>
  if(unlink("dd") < 0){
    3074:	00004517          	auipc	a0,0x4
    3078:	cb450513          	addi	a0,a0,-844 # 6d28 <malloc+0x157e>
    307c:	00002097          	auipc	ra,0x2
    3080:	348080e7          	jalr	840(ra) # 53c4 <unlink>
    3084:	40054063          	bltz	a0,3484 <subdir+0x7aa>
}
    3088:	60e2                	ld	ra,24(sp)
    308a:	6442                	ld	s0,16(sp)
    308c:	64a2                	ld	s1,8(sp)
    308e:	6902                	ld	s2,0(sp)
    3090:	6105                	addi	sp,sp,32
    3092:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3094:	85ca                	mv	a1,s2
    3096:	00004517          	auipc	a0,0x4
    309a:	c9a50513          	addi	a0,a0,-870 # 6d30 <malloc+0x1586>
    309e:	00002097          	auipc	ra,0x2
    30a2:	64e080e7          	jalr	1614(ra) # 56ec <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	00002097          	auipc	ra,0x2
    30ac:	2cc080e7          	jalr	716(ra) # 5374 <exit>
    printf("%s: create dd/ff failed\n", s);
    30b0:	85ca                	mv	a1,s2
    30b2:	00004517          	auipc	a0,0x4
    30b6:	c9e50513          	addi	a0,a0,-866 # 6d50 <malloc+0x15a6>
    30ba:	00002097          	auipc	ra,0x2
    30be:	632080e7          	jalr	1586(ra) # 56ec <printf>
    exit(1);
    30c2:	4505                	li	a0,1
    30c4:	00002097          	auipc	ra,0x2
    30c8:	2b0080e7          	jalr	688(ra) # 5374 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    30cc:	85ca                	mv	a1,s2
    30ce:	00004517          	auipc	a0,0x4
    30d2:	ca250513          	addi	a0,a0,-862 # 6d70 <malloc+0x15c6>
    30d6:	00002097          	auipc	ra,0x2
    30da:	616080e7          	jalr	1558(ra) # 56ec <printf>
    exit(1);
    30de:	4505                	li	a0,1
    30e0:	00002097          	auipc	ra,0x2
    30e4:	294080e7          	jalr	660(ra) # 5374 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	cbe50513          	addi	a0,a0,-834 # 6da8 <malloc+0x15fe>
    30f2:	00002097          	auipc	ra,0x2
    30f6:	5fa080e7          	jalr	1530(ra) # 56ec <printf>
    exit(1);
    30fa:	4505                	li	a0,1
    30fc:	00002097          	auipc	ra,0x2
    3100:	278080e7          	jalr	632(ra) # 5374 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3104:	85ca                	mv	a1,s2
    3106:	00004517          	auipc	a0,0x4
    310a:	cd250513          	addi	a0,a0,-814 # 6dd8 <malloc+0x162e>
    310e:	00002097          	auipc	ra,0x2
    3112:	5de080e7          	jalr	1502(ra) # 56ec <printf>
    exit(1);
    3116:	4505                	li	a0,1
    3118:	00002097          	auipc	ra,0x2
    311c:	25c080e7          	jalr	604(ra) # 5374 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3120:	85ca                	mv	a1,s2
    3122:	00004517          	auipc	a0,0x4
    3126:	cee50513          	addi	a0,a0,-786 # 6e10 <malloc+0x1666>
    312a:	00002097          	auipc	ra,0x2
    312e:	5c2080e7          	jalr	1474(ra) # 56ec <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	00002097          	auipc	ra,0x2
    3138:	240080e7          	jalr	576(ra) # 5374 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    313c:	85ca                	mv	a1,s2
    313e:	00004517          	auipc	a0,0x4
    3142:	cf250513          	addi	a0,a0,-782 # 6e30 <malloc+0x1686>
    3146:	00002097          	auipc	ra,0x2
    314a:	5a6080e7          	jalr	1446(ra) # 56ec <printf>
    exit(1);
    314e:	4505                	li	a0,1
    3150:	00002097          	auipc	ra,0x2
    3154:	224080e7          	jalr	548(ra) # 5374 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3158:	85ca                	mv	a1,s2
    315a:	00004517          	auipc	a0,0x4
    315e:	d0650513          	addi	a0,a0,-762 # 6e60 <malloc+0x16b6>
    3162:	00002097          	auipc	ra,0x2
    3166:	58a080e7          	jalr	1418(ra) # 56ec <printf>
    exit(1);
    316a:	4505                	li	a0,1
    316c:	00002097          	auipc	ra,0x2
    3170:	208080e7          	jalr	520(ra) # 5374 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3174:	85ca                	mv	a1,s2
    3176:	00004517          	auipc	a0,0x4
    317a:	d1250513          	addi	a0,a0,-750 # 6e88 <malloc+0x16de>
    317e:	00002097          	auipc	ra,0x2
    3182:	56e080e7          	jalr	1390(ra) # 56ec <printf>
    exit(1);
    3186:	4505                	li	a0,1
    3188:	00002097          	auipc	ra,0x2
    318c:	1ec080e7          	jalr	492(ra) # 5374 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3190:	85ca                	mv	a1,s2
    3192:	00004517          	auipc	a0,0x4
    3196:	d1650513          	addi	a0,a0,-746 # 6ea8 <malloc+0x16fe>
    319a:	00002097          	auipc	ra,0x2
    319e:	552080e7          	jalr	1362(ra) # 56ec <printf>
    exit(1);
    31a2:	4505                	li	a0,1
    31a4:	00002097          	auipc	ra,0x2
    31a8:	1d0080e7          	jalr	464(ra) # 5374 <exit>
    printf("%s: chdir dd failed\n", s);
    31ac:	85ca                	mv	a1,s2
    31ae:	00004517          	auipc	a0,0x4
    31b2:	d2250513          	addi	a0,a0,-734 # 6ed0 <malloc+0x1726>
    31b6:	00002097          	auipc	ra,0x2
    31ba:	536080e7          	jalr	1334(ra) # 56ec <printf>
    exit(1);
    31be:	4505                	li	a0,1
    31c0:	00002097          	auipc	ra,0x2
    31c4:	1b4080e7          	jalr	436(ra) # 5374 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    31c8:	85ca                	mv	a1,s2
    31ca:	00004517          	auipc	a0,0x4
    31ce:	d2e50513          	addi	a0,a0,-722 # 6ef8 <malloc+0x174e>
    31d2:	00002097          	auipc	ra,0x2
    31d6:	51a080e7          	jalr	1306(ra) # 56ec <printf>
    exit(1);
    31da:	4505                	li	a0,1
    31dc:	00002097          	auipc	ra,0x2
    31e0:	198080e7          	jalr	408(ra) # 5374 <exit>
    printf("chdir dd/../../dd failed\n", s);
    31e4:	85ca                	mv	a1,s2
    31e6:	00004517          	auipc	a0,0x4
    31ea:	d4250513          	addi	a0,a0,-702 # 6f28 <malloc+0x177e>
    31ee:	00002097          	auipc	ra,0x2
    31f2:	4fe080e7          	jalr	1278(ra) # 56ec <printf>
    exit(1);
    31f6:	4505                	li	a0,1
    31f8:	00002097          	auipc	ra,0x2
    31fc:	17c080e7          	jalr	380(ra) # 5374 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3200:	85ca                	mv	a1,s2
    3202:	00004517          	auipc	a0,0x4
    3206:	d4e50513          	addi	a0,a0,-690 # 6f50 <malloc+0x17a6>
    320a:	00002097          	auipc	ra,0x2
    320e:	4e2080e7          	jalr	1250(ra) # 56ec <printf>
    exit(1);
    3212:	4505                	li	a0,1
    3214:	00002097          	auipc	ra,0x2
    3218:	160080e7          	jalr	352(ra) # 5374 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    321c:	85ca                	mv	a1,s2
    321e:	00004517          	auipc	a0,0x4
    3222:	d4a50513          	addi	a0,a0,-694 # 6f68 <malloc+0x17be>
    3226:	00002097          	auipc	ra,0x2
    322a:	4c6080e7          	jalr	1222(ra) # 56ec <printf>
    exit(1);
    322e:	4505                	li	a0,1
    3230:	00002097          	auipc	ra,0x2
    3234:	144080e7          	jalr	324(ra) # 5374 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3238:	85ca                	mv	a1,s2
    323a:	00004517          	auipc	a0,0x4
    323e:	d4e50513          	addi	a0,a0,-690 # 6f88 <malloc+0x17de>
    3242:	00002097          	auipc	ra,0x2
    3246:	4aa080e7          	jalr	1194(ra) # 56ec <printf>
    exit(1);
    324a:	4505                	li	a0,1
    324c:	00002097          	auipc	ra,0x2
    3250:	128080e7          	jalr	296(ra) # 5374 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3254:	85ca                	mv	a1,s2
    3256:	00004517          	auipc	a0,0x4
    325a:	d5250513          	addi	a0,a0,-686 # 6fa8 <malloc+0x17fe>
    325e:	00002097          	auipc	ra,0x2
    3262:	48e080e7          	jalr	1166(ra) # 56ec <printf>
    exit(1);
    3266:	4505                	li	a0,1
    3268:	00002097          	auipc	ra,0x2
    326c:	10c080e7          	jalr	268(ra) # 5374 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3270:	85ca                	mv	a1,s2
    3272:	00004517          	auipc	a0,0x4
    3276:	d7650513          	addi	a0,a0,-650 # 6fe8 <malloc+0x183e>
    327a:	00002097          	auipc	ra,0x2
    327e:	472080e7          	jalr	1138(ra) # 56ec <printf>
    exit(1);
    3282:	4505                	li	a0,1
    3284:	00002097          	auipc	ra,0x2
    3288:	0f0080e7          	jalr	240(ra) # 5374 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    328c:	85ca                	mv	a1,s2
    328e:	00004517          	auipc	a0,0x4
    3292:	d8a50513          	addi	a0,a0,-630 # 7018 <malloc+0x186e>
    3296:	00002097          	auipc	ra,0x2
    329a:	456080e7          	jalr	1110(ra) # 56ec <printf>
    exit(1);
    329e:	4505                	li	a0,1
    32a0:	00002097          	auipc	ra,0x2
    32a4:	0d4080e7          	jalr	212(ra) # 5374 <exit>
    printf("%s: create dd succeeded!\n", s);
    32a8:	85ca                	mv	a1,s2
    32aa:	00004517          	auipc	a0,0x4
    32ae:	d8e50513          	addi	a0,a0,-626 # 7038 <malloc+0x188e>
    32b2:	00002097          	auipc	ra,0x2
    32b6:	43a080e7          	jalr	1082(ra) # 56ec <printf>
    exit(1);
    32ba:	4505                	li	a0,1
    32bc:	00002097          	auipc	ra,0x2
    32c0:	0b8080e7          	jalr	184(ra) # 5374 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    32c4:	85ca                	mv	a1,s2
    32c6:	00004517          	auipc	a0,0x4
    32ca:	d9250513          	addi	a0,a0,-622 # 7058 <malloc+0x18ae>
    32ce:	00002097          	auipc	ra,0x2
    32d2:	41e080e7          	jalr	1054(ra) # 56ec <printf>
    exit(1);
    32d6:	4505                	li	a0,1
    32d8:	00002097          	auipc	ra,0x2
    32dc:	09c080e7          	jalr	156(ra) # 5374 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    32e0:	85ca                	mv	a1,s2
    32e2:	00004517          	auipc	a0,0x4
    32e6:	d9650513          	addi	a0,a0,-618 # 7078 <malloc+0x18ce>
    32ea:	00002097          	auipc	ra,0x2
    32ee:	402080e7          	jalr	1026(ra) # 56ec <printf>
    exit(1);
    32f2:	4505                	li	a0,1
    32f4:	00002097          	auipc	ra,0x2
    32f8:	080080e7          	jalr	128(ra) # 5374 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    32fc:	85ca                	mv	a1,s2
    32fe:	00004517          	auipc	a0,0x4
    3302:	daa50513          	addi	a0,a0,-598 # 70a8 <malloc+0x18fe>
    3306:	00002097          	auipc	ra,0x2
    330a:	3e6080e7          	jalr	998(ra) # 56ec <printf>
    exit(1);
    330e:	4505                	li	a0,1
    3310:	00002097          	auipc	ra,0x2
    3314:	064080e7          	jalr	100(ra) # 5374 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3318:	85ca                	mv	a1,s2
    331a:	00004517          	auipc	a0,0x4
    331e:	db650513          	addi	a0,a0,-586 # 70d0 <malloc+0x1926>
    3322:	00002097          	auipc	ra,0x2
    3326:	3ca080e7          	jalr	970(ra) # 56ec <printf>
    exit(1);
    332a:	4505                	li	a0,1
    332c:	00002097          	auipc	ra,0x2
    3330:	048080e7          	jalr	72(ra) # 5374 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3334:	85ca                	mv	a1,s2
    3336:	00004517          	auipc	a0,0x4
    333a:	dc250513          	addi	a0,a0,-574 # 70f8 <malloc+0x194e>
    333e:	00002097          	auipc	ra,0x2
    3342:	3ae080e7          	jalr	942(ra) # 56ec <printf>
    exit(1);
    3346:	4505                	li	a0,1
    3348:	00002097          	auipc	ra,0x2
    334c:	02c080e7          	jalr	44(ra) # 5374 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3350:	85ca                	mv	a1,s2
    3352:	00004517          	auipc	a0,0x4
    3356:	dce50513          	addi	a0,a0,-562 # 7120 <malloc+0x1976>
    335a:	00002097          	auipc	ra,0x2
    335e:	392080e7          	jalr	914(ra) # 56ec <printf>
    exit(1);
    3362:	4505                	li	a0,1
    3364:	00002097          	auipc	ra,0x2
    3368:	010080e7          	jalr	16(ra) # 5374 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    336c:	85ca                	mv	a1,s2
    336e:	00004517          	auipc	a0,0x4
    3372:	dd250513          	addi	a0,a0,-558 # 7140 <malloc+0x1996>
    3376:	00002097          	auipc	ra,0x2
    337a:	376080e7          	jalr	886(ra) # 56ec <printf>
    exit(1);
    337e:	4505                	li	a0,1
    3380:	00002097          	auipc	ra,0x2
    3384:	ff4080e7          	jalr	-12(ra) # 5374 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3388:	85ca                	mv	a1,s2
    338a:	00004517          	auipc	a0,0x4
    338e:	dd650513          	addi	a0,a0,-554 # 7160 <malloc+0x19b6>
    3392:	00002097          	auipc	ra,0x2
    3396:	35a080e7          	jalr	858(ra) # 56ec <printf>
    exit(1);
    339a:	4505                	li	a0,1
    339c:	00002097          	auipc	ra,0x2
    33a0:	fd8080e7          	jalr	-40(ra) # 5374 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    33a4:	85ca                	mv	a1,s2
    33a6:	00004517          	auipc	a0,0x4
    33aa:	de250513          	addi	a0,a0,-542 # 7188 <malloc+0x19de>
    33ae:	00002097          	auipc	ra,0x2
    33b2:	33e080e7          	jalr	830(ra) # 56ec <printf>
    exit(1);
    33b6:	4505                	li	a0,1
    33b8:	00002097          	auipc	ra,0x2
    33bc:	fbc080e7          	jalr	-68(ra) # 5374 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    33c0:	85ca                	mv	a1,s2
    33c2:	00004517          	auipc	a0,0x4
    33c6:	de650513          	addi	a0,a0,-538 # 71a8 <malloc+0x19fe>
    33ca:	00002097          	auipc	ra,0x2
    33ce:	322080e7          	jalr	802(ra) # 56ec <printf>
    exit(1);
    33d2:	4505                	li	a0,1
    33d4:	00002097          	auipc	ra,0x2
    33d8:	fa0080e7          	jalr	-96(ra) # 5374 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    33dc:	85ca                	mv	a1,s2
    33de:	00004517          	auipc	a0,0x4
    33e2:	dea50513          	addi	a0,a0,-534 # 71c8 <malloc+0x1a1e>
    33e6:	00002097          	auipc	ra,0x2
    33ea:	306080e7          	jalr	774(ra) # 56ec <printf>
    exit(1);
    33ee:	4505                	li	a0,1
    33f0:	00002097          	auipc	ra,0x2
    33f4:	f84080e7          	jalr	-124(ra) # 5374 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    33f8:	85ca                	mv	a1,s2
    33fa:	00004517          	auipc	a0,0x4
    33fe:	df650513          	addi	a0,a0,-522 # 71f0 <malloc+0x1a46>
    3402:	00002097          	auipc	ra,0x2
    3406:	2ea080e7          	jalr	746(ra) # 56ec <printf>
    exit(1);
    340a:	4505                	li	a0,1
    340c:	00002097          	auipc	ra,0x2
    3410:	f68080e7          	jalr	-152(ra) # 5374 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3414:	85ca                	mv	a1,s2
    3416:	00004517          	auipc	a0,0x4
    341a:	a7250513          	addi	a0,a0,-1422 # 6e88 <malloc+0x16de>
    341e:	00002097          	auipc	ra,0x2
    3422:	2ce080e7          	jalr	718(ra) # 56ec <printf>
    exit(1);
    3426:	4505                	li	a0,1
    3428:	00002097          	auipc	ra,0x2
    342c:	f4c080e7          	jalr	-180(ra) # 5374 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3430:	85ca                	mv	a1,s2
    3432:	00004517          	auipc	a0,0x4
    3436:	dde50513          	addi	a0,a0,-546 # 7210 <malloc+0x1a66>
    343a:	00002097          	auipc	ra,0x2
    343e:	2b2080e7          	jalr	690(ra) # 56ec <printf>
    exit(1);
    3442:	4505                	li	a0,1
    3444:	00002097          	auipc	ra,0x2
    3448:	f30080e7          	jalr	-208(ra) # 5374 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    344c:	85ca                	mv	a1,s2
    344e:	00004517          	auipc	a0,0x4
    3452:	de250513          	addi	a0,a0,-542 # 7230 <malloc+0x1a86>
    3456:	00002097          	auipc	ra,0x2
    345a:	296080e7          	jalr	662(ra) # 56ec <printf>
    exit(1);
    345e:	4505                	li	a0,1
    3460:	00002097          	auipc	ra,0x2
    3464:	f14080e7          	jalr	-236(ra) # 5374 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3468:	85ca                	mv	a1,s2
    346a:	00004517          	auipc	a0,0x4
    346e:	df650513          	addi	a0,a0,-522 # 7260 <malloc+0x1ab6>
    3472:	00002097          	auipc	ra,0x2
    3476:	27a080e7          	jalr	634(ra) # 56ec <printf>
    exit(1);
    347a:	4505                	li	a0,1
    347c:	00002097          	auipc	ra,0x2
    3480:	ef8080e7          	jalr	-264(ra) # 5374 <exit>
    printf("%s: unlink dd failed\n", s);
    3484:	85ca                	mv	a1,s2
    3486:	00004517          	auipc	a0,0x4
    348a:	dfa50513          	addi	a0,a0,-518 # 7280 <malloc+0x1ad6>
    348e:	00002097          	auipc	ra,0x2
    3492:	25e080e7          	jalr	606(ra) # 56ec <printf>
    exit(1);
    3496:	4505                	li	a0,1
    3498:	00002097          	auipc	ra,0x2
    349c:	edc080e7          	jalr	-292(ra) # 5374 <exit>

00000000000034a0 <rmdot>:
{
    34a0:	1101                	addi	sp,sp,-32
    34a2:	ec06                	sd	ra,24(sp)
    34a4:	e822                	sd	s0,16(sp)
    34a6:	e426                	sd	s1,8(sp)
    34a8:	1000                	addi	s0,sp,32
    34aa:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    34ac:	00004517          	auipc	a0,0x4
    34b0:	dec50513          	addi	a0,a0,-532 # 7298 <malloc+0x1aee>
    34b4:	00002097          	auipc	ra,0x2
    34b8:	f28080e7          	jalr	-216(ra) # 53dc <mkdir>
    34bc:	e549                	bnez	a0,3546 <rmdot+0xa6>
  if(chdir("dots") != 0){
    34be:	00004517          	auipc	a0,0x4
    34c2:	dda50513          	addi	a0,a0,-550 # 7298 <malloc+0x1aee>
    34c6:	00002097          	auipc	ra,0x2
    34ca:	f1e080e7          	jalr	-226(ra) # 53e4 <chdir>
    34ce:	e951                	bnez	a0,3562 <rmdot+0xc2>
  if(unlink(".") == 0){
    34d0:	00003517          	auipc	a0,0x3
    34d4:	d9050513          	addi	a0,a0,-624 # 6260 <malloc+0xab6>
    34d8:	00002097          	auipc	ra,0x2
    34dc:	eec080e7          	jalr	-276(ra) # 53c4 <unlink>
    34e0:	cd59                	beqz	a0,357e <rmdot+0xde>
  if(unlink("..") == 0){
    34e2:	00004517          	auipc	a0,0x4
    34e6:	e0650513          	addi	a0,a0,-506 # 72e8 <malloc+0x1b3e>
    34ea:	00002097          	auipc	ra,0x2
    34ee:	eda080e7          	jalr	-294(ra) # 53c4 <unlink>
    34f2:	c545                	beqz	a0,359a <rmdot+0xfa>
  if(chdir("/") != 0){
    34f4:	00003517          	auipc	a0,0x3
    34f8:	7fc50513          	addi	a0,a0,2044 # 6cf0 <malloc+0x1546>
    34fc:	00002097          	auipc	ra,0x2
    3500:	ee8080e7          	jalr	-280(ra) # 53e4 <chdir>
    3504:	e94d                	bnez	a0,35b6 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3506:	00004517          	auipc	a0,0x4
    350a:	e0250513          	addi	a0,a0,-510 # 7308 <malloc+0x1b5e>
    350e:	00002097          	auipc	ra,0x2
    3512:	eb6080e7          	jalr	-330(ra) # 53c4 <unlink>
    3516:	cd55                	beqz	a0,35d2 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3518:	00004517          	auipc	a0,0x4
    351c:	e1850513          	addi	a0,a0,-488 # 7330 <malloc+0x1b86>
    3520:	00002097          	auipc	ra,0x2
    3524:	ea4080e7          	jalr	-348(ra) # 53c4 <unlink>
    3528:	c179                	beqz	a0,35ee <rmdot+0x14e>
  if(unlink("dots") != 0){
    352a:	00004517          	auipc	a0,0x4
    352e:	d6e50513          	addi	a0,a0,-658 # 7298 <malloc+0x1aee>
    3532:	00002097          	auipc	ra,0x2
    3536:	e92080e7          	jalr	-366(ra) # 53c4 <unlink>
    353a:	e961                	bnez	a0,360a <rmdot+0x16a>
}
    353c:	60e2                	ld	ra,24(sp)
    353e:	6442                	ld	s0,16(sp)
    3540:	64a2                	ld	s1,8(sp)
    3542:	6105                	addi	sp,sp,32
    3544:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3546:	85a6                	mv	a1,s1
    3548:	00004517          	auipc	a0,0x4
    354c:	d5850513          	addi	a0,a0,-680 # 72a0 <malloc+0x1af6>
    3550:	00002097          	auipc	ra,0x2
    3554:	19c080e7          	jalr	412(ra) # 56ec <printf>
    exit(1);
    3558:	4505                	li	a0,1
    355a:	00002097          	auipc	ra,0x2
    355e:	e1a080e7          	jalr	-486(ra) # 5374 <exit>
    printf("%s: chdir dots failed\n", s);
    3562:	85a6                	mv	a1,s1
    3564:	00004517          	auipc	a0,0x4
    3568:	d5450513          	addi	a0,a0,-684 # 72b8 <malloc+0x1b0e>
    356c:	00002097          	auipc	ra,0x2
    3570:	180080e7          	jalr	384(ra) # 56ec <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	00002097          	auipc	ra,0x2
    357a:	dfe080e7          	jalr	-514(ra) # 5374 <exit>
    printf("%s: rm . worked!\n", s);
    357e:	85a6                	mv	a1,s1
    3580:	00004517          	auipc	a0,0x4
    3584:	d5050513          	addi	a0,a0,-688 # 72d0 <malloc+0x1b26>
    3588:	00002097          	auipc	ra,0x2
    358c:	164080e7          	jalr	356(ra) # 56ec <printf>
    exit(1);
    3590:	4505                	li	a0,1
    3592:	00002097          	auipc	ra,0x2
    3596:	de2080e7          	jalr	-542(ra) # 5374 <exit>
    printf("%s: rm .. worked!\n", s);
    359a:	85a6                	mv	a1,s1
    359c:	00004517          	auipc	a0,0x4
    35a0:	d5450513          	addi	a0,a0,-684 # 72f0 <malloc+0x1b46>
    35a4:	00002097          	auipc	ra,0x2
    35a8:	148080e7          	jalr	328(ra) # 56ec <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	00002097          	auipc	ra,0x2
    35b2:	dc6080e7          	jalr	-570(ra) # 5374 <exit>
    printf("%s: chdir / failed\n", s);
    35b6:	85a6                	mv	a1,s1
    35b8:	00003517          	auipc	a0,0x3
    35bc:	74050513          	addi	a0,a0,1856 # 6cf8 <malloc+0x154e>
    35c0:	00002097          	auipc	ra,0x2
    35c4:	12c080e7          	jalr	300(ra) # 56ec <printf>
    exit(1);
    35c8:	4505                	li	a0,1
    35ca:	00002097          	auipc	ra,0x2
    35ce:	daa080e7          	jalr	-598(ra) # 5374 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    35d2:	85a6                	mv	a1,s1
    35d4:	00004517          	auipc	a0,0x4
    35d8:	d3c50513          	addi	a0,a0,-708 # 7310 <malloc+0x1b66>
    35dc:	00002097          	auipc	ra,0x2
    35e0:	110080e7          	jalr	272(ra) # 56ec <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	00002097          	auipc	ra,0x2
    35ea:	d8e080e7          	jalr	-626(ra) # 5374 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    35ee:	85a6                	mv	a1,s1
    35f0:	00004517          	auipc	a0,0x4
    35f4:	d4850513          	addi	a0,a0,-696 # 7338 <malloc+0x1b8e>
    35f8:	00002097          	auipc	ra,0x2
    35fc:	0f4080e7          	jalr	244(ra) # 56ec <printf>
    exit(1);
    3600:	4505                	li	a0,1
    3602:	00002097          	auipc	ra,0x2
    3606:	d72080e7          	jalr	-654(ra) # 5374 <exit>
    printf("%s: unlink dots failed!\n", s);
    360a:	85a6                	mv	a1,s1
    360c:	00004517          	auipc	a0,0x4
    3610:	d4c50513          	addi	a0,a0,-692 # 7358 <malloc+0x1bae>
    3614:	00002097          	auipc	ra,0x2
    3618:	0d8080e7          	jalr	216(ra) # 56ec <printf>
    exit(1);
    361c:	4505                	li	a0,1
    361e:	00002097          	auipc	ra,0x2
    3622:	d56080e7          	jalr	-682(ra) # 5374 <exit>

0000000000003626 <dirfile>:
{
    3626:	1101                	addi	sp,sp,-32
    3628:	ec06                	sd	ra,24(sp)
    362a:	e822                	sd	s0,16(sp)
    362c:	e426                	sd	s1,8(sp)
    362e:	e04a                	sd	s2,0(sp)
    3630:	1000                	addi	s0,sp,32
    3632:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3634:	20000593          	li	a1,512
    3638:	00002517          	auipc	a0,0x2
    363c:	53050513          	addi	a0,a0,1328 # 5b68 <malloc+0x3be>
    3640:	00002097          	auipc	ra,0x2
    3644:	d74080e7          	jalr	-652(ra) # 53b4 <open>
  if(fd < 0){
    3648:	0e054d63          	bltz	a0,3742 <dirfile+0x11c>
  close(fd);
    364c:	00002097          	auipc	ra,0x2
    3650:	d50080e7          	jalr	-688(ra) # 539c <close>
  if(chdir("dirfile") == 0){
    3654:	00002517          	auipc	a0,0x2
    3658:	51450513          	addi	a0,a0,1300 # 5b68 <malloc+0x3be>
    365c:	00002097          	auipc	ra,0x2
    3660:	d88080e7          	jalr	-632(ra) # 53e4 <chdir>
    3664:	cd6d                	beqz	a0,375e <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    3666:	4581                	li	a1,0
    3668:	00004517          	auipc	a0,0x4
    366c:	d5050513          	addi	a0,a0,-688 # 73b8 <malloc+0x1c0e>
    3670:	00002097          	auipc	ra,0x2
    3674:	d44080e7          	jalr	-700(ra) # 53b4 <open>
  if(fd >= 0){
    3678:	10055163          	bgez	a0,377a <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    367c:	20000593          	li	a1,512
    3680:	00004517          	auipc	a0,0x4
    3684:	d3850513          	addi	a0,a0,-712 # 73b8 <malloc+0x1c0e>
    3688:	00002097          	auipc	ra,0x2
    368c:	d2c080e7          	jalr	-724(ra) # 53b4 <open>
  if(fd >= 0){
    3690:	10055363          	bgez	a0,3796 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    3694:	00004517          	auipc	a0,0x4
    3698:	d2450513          	addi	a0,a0,-732 # 73b8 <malloc+0x1c0e>
    369c:	00002097          	auipc	ra,0x2
    36a0:	d40080e7          	jalr	-704(ra) # 53dc <mkdir>
    36a4:	10050763          	beqz	a0,37b2 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    36a8:	00004517          	auipc	a0,0x4
    36ac:	d1050513          	addi	a0,a0,-752 # 73b8 <malloc+0x1c0e>
    36b0:	00002097          	auipc	ra,0x2
    36b4:	d14080e7          	jalr	-748(ra) # 53c4 <unlink>
    36b8:	10050b63          	beqz	a0,37ce <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    36bc:	00004597          	auipc	a1,0x4
    36c0:	cfc58593          	addi	a1,a1,-772 # 73b8 <malloc+0x1c0e>
    36c4:	00002517          	auipc	a0,0x2
    36c8:	69c50513          	addi	a0,a0,1692 # 5d60 <malloc+0x5b6>
    36cc:	00002097          	auipc	ra,0x2
    36d0:	d08080e7          	jalr	-760(ra) # 53d4 <link>
    36d4:	10050b63          	beqz	a0,37ea <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    36d8:	00002517          	auipc	a0,0x2
    36dc:	49050513          	addi	a0,a0,1168 # 5b68 <malloc+0x3be>
    36e0:	00002097          	auipc	ra,0x2
    36e4:	ce4080e7          	jalr	-796(ra) # 53c4 <unlink>
    36e8:	10051f63          	bnez	a0,3806 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    36ec:	4589                	li	a1,2
    36ee:	00003517          	auipc	a0,0x3
    36f2:	b7250513          	addi	a0,a0,-1166 # 6260 <malloc+0xab6>
    36f6:	00002097          	auipc	ra,0x2
    36fa:	cbe080e7          	jalr	-834(ra) # 53b4 <open>
  if(fd >= 0){
    36fe:	12055263          	bgez	a0,3822 <dirfile+0x1fc>
  fd = open(".", 0);
    3702:	4581                	li	a1,0
    3704:	00003517          	auipc	a0,0x3
    3708:	b5c50513          	addi	a0,a0,-1188 # 6260 <malloc+0xab6>
    370c:	00002097          	auipc	ra,0x2
    3710:	ca8080e7          	jalr	-856(ra) # 53b4 <open>
    3714:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    3716:	4605                	li	a2,1
    3718:	00002597          	auipc	a1,0x2
    371c:	52058593          	addi	a1,a1,1312 # 5c38 <malloc+0x48e>
    3720:	00002097          	auipc	ra,0x2
    3724:	c74080e7          	jalr	-908(ra) # 5394 <write>
    3728:	10a04b63          	bgtz	a0,383e <dirfile+0x218>
  close(fd);
    372c:	8526                	mv	a0,s1
    372e:	00002097          	auipc	ra,0x2
    3732:	c6e080e7          	jalr	-914(ra) # 539c <close>
}
    3736:	60e2                	ld	ra,24(sp)
    3738:	6442                	ld	s0,16(sp)
    373a:	64a2                	ld	s1,8(sp)
    373c:	6902                	ld	s2,0(sp)
    373e:	6105                	addi	sp,sp,32
    3740:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3742:	85ca                	mv	a1,s2
    3744:	00004517          	auipc	a0,0x4
    3748:	c3450513          	addi	a0,a0,-972 # 7378 <malloc+0x1bce>
    374c:	00002097          	auipc	ra,0x2
    3750:	fa0080e7          	jalr	-96(ra) # 56ec <printf>
    exit(1);
    3754:	4505                	li	a0,1
    3756:	00002097          	auipc	ra,0x2
    375a:	c1e080e7          	jalr	-994(ra) # 5374 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    375e:	85ca                	mv	a1,s2
    3760:	00004517          	auipc	a0,0x4
    3764:	c3850513          	addi	a0,a0,-968 # 7398 <malloc+0x1bee>
    3768:	00002097          	auipc	ra,0x2
    376c:	f84080e7          	jalr	-124(ra) # 56ec <printf>
    exit(1);
    3770:	4505                	li	a0,1
    3772:	00002097          	auipc	ra,0x2
    3776:	c02080e7          	jalr	-1022(ra) # 5374 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    377a:	85ca                	mv	a1,s2
    377c:	00004517          	auipc	a0,0x4
    3780:	c4c50513          	addi	a0,a0,-948 # 73c8 <malloc+0x1c1e>
    3784:	00002097          	auipc	ra,0x2
    3788:	f68080e7          	jalr	-152(ra) # 56ec <printf>
    exit(1);
    378c:	4505                	li	a0,1
    378e:	00002097          	auipc	ra,0x2
    3792:	be6080e7          	jalr	-1050(ra) # 5374 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3796:	85ca                	mv	a1,s2
    3798:	00004517          	auipc	a0,0x4
    379c:	c3050513          	addi	a0,a0,-976 # 73c8 <malloc+0x1c1e>
    37a0:	00002097          	auipc	ra,0x2
    37a4:	f4c080e7          	jalr	-180(ra) # 56ec <printf>
    exit(1);
    37a8:	4505                	li	a0,1
    37aa:	00002097          	auipc	ra,0x2
    37ae:	bca080e7          	jalr	-1078(ra) # 5374 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    37b2:	85ca                	mv	a1,s2
    37b4:	00004517          	auipc	a0,0x4
    37b8:	c3c50513          	addi	a0,a0,-964 # 73f0 <malloc+0x1c46>
    37bc:	00002097          	auipc	ra,0x2
    37c0:	f30080e7          	jalr	-208(ra) # 56ec <printf>
    exit(1);
    37c4:	4505                	li	a0,1
    37c6:	00002097          	auipc	ra,0x2
    37ca:	bae080e7          	jalr	-1106(ra) # 5374 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    37ce:	85ca                	mv	a1,s2
    37d0:	00004517          	auipc	a0,0x4
    37d4:	c4850513          	addi	a0,a0,-952 # 7418 <malloc+0x1c6e>
    37d8:	00002097          	auipc	ra,0x2
    37dc:	f14080e7          	jalr	-236(ra) # 56ec <printf>
    exit(1);
    37e0:	4505                	li	a0,1
    37e2:	00002097          	auipc	ra,0x2
    37e6:	b92080e7          	jalr	-1134(ra) # 5374 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    37ea:	85ca                	mv	a1,s2
    37ec:	00004517          	auipc	a0,0x4
    37f0:	c5450513          	addi	a0,a0,-940 # 7440 <malloc+0x1c96>
    37f4:	00002097          	auipc	ra,0x2
    37f8:	ef8080e7          	jalr	-264(ra) # 56ec <printf>
    exit(1);
    37fc:	4505                	li	a0,1
    37fe:	00002097          	auipc	ra,0x2
    3802:	b76080e7          	jalr	-1162(ra) # 5374 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3806:	85ca                	mv	a1,s2
    3808:	00004517          	auipc	a0,0x4
    380c:	c6050513          	addi	a0,a0,-928 # 7468 <malloc+0x1cbe>
    3810:	00002097          	auipc	ra,0x2
    3814:	edc080e7          	jalr	-292(ra) # 56ec <printf>
    exit(1);
    3818:	4505                	li	a0,1
    381a:	00002097          	auipc	ra,0x2
    381e:	b5a080e7          	jalr	-1190(ra) # 5374 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3822:	85ca                	mv	a1,s2
    3824:	00004517          	auipc	a0,0x4
    3828:	c6450513          	addi	a0,a0,-924 # 7488 <malloc+0x1cde>
    382c:	00002097          	auipc	ra,0x2
    3830:	ec0080e7          	jalr	-320(ra) # 56ec <printf>
    exit(1);
    3834:	4505                	li	a0,1
    3836:	00002097          	auipc	ra,0x2
    383a:	b3e080e7          	jalr	-1218(ra) # 5374 <exit>
    printf("%s: write . succeeded!\n", s);
    383e:	85ca                	mv	a1,s2
    3840:	00004517          	auipc	a0,0x4
    3844:	c7050513          	addi	a0,a0,-912 # 74b0 <malloc+0x1d06>
    3848:	00002097          	auipc	ra,0x2
    384c:	ea4080e7          	jalr	-348(ra) # 56ec <printf>
    exit(1);
    3850:	4505                	li	a0,1
    3852:	00002097          	auipc	ra,0x2
    3856:	b22080e7          	jalr	-1246(ra) # 5374 <exit>

000000000000385a <iref>:
{
    385a:	7139                	addi	sp,sp,-64
    385c:	fc06                	sd	ra,56(sp)
    385e:	f822                	sd	s0,48(sp)
    3860:	f426                	sd	s1,40(sp)
    3862:	f04a                	sd	s2,32(sp)
    3864:	ec4e                	sd	s3,24(sp)
    3866:	e852                	sd	s4,16(sp)
    3868:	e456                	sd	s5,8(sp)
    386a:	e05a                	sd	s6,0(sp)
    386c:	0080                	addi	s0,sp,64
    386e:	8b2a                	mv	s6,a0
    3870:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    3874:	00004a17          	auipc	s4,0x4
    3878:	c54a0a13          	addi	s4,s4,-940 # 74c8 <malloc+0x1d1e>
    mkdir("");
    387c:	00003497          	auipc	s1,0x3
    3880:	75448493          	addi	s1,s1,1876 # 6fd0 <malloc+0x1826>
    link("README", "");
    3884:	00002a97          	auipc	s5,0x2
    3888:	4dca8a93          	addi	s5,s5,1244 # 5d60 <malloc+0x5b6>
    fd = open("xx", O_CREATE);
    388c:	00004997          	auipc	s3,0x4
    3890:	b3498993          	addi	s3,s3,-1228 # 73c0 <malloc+0x1c16>
    3894:	a891                	j	38e8 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    3896:	85da                	mv	a1,s6
    3898:	00004517          	auipc	a0,0x4
    389c:	c3850513          	addi	a0,a0,-968 # 74d0 <malloc+0x1d26>
    38a0:	00002097          	auipc	ra,0x2
    38a4:	e4c080e7          	jalr	-436(ra) # 56ec <printf>
      exit(1);
    38a8:	4505                	li	a0,1
    38aa:	00002097          	auipc	ra,0x2
    38ae:	aca080e7          	jalr	-1334(ra) # 5374 <exit>
      printf("%s: chdir irefd failed\n", s);
    38b2:	85da                	mv	a1,s6
    38b4:	00004517          	auipc	a0,0x4
    38b8:	c3450513          	addi	a0,a0,-972 # 74e8 <malloc+0x1d3e>
    38bc:	00002097          	auipc	ra,0x2
    38c0:	e30080e7          	jalr	-464(ra) # 56ec <printf>
      exit(1);
    38c4:	4505                	li	a0,1
    38c6:	00002097          	auipc	ra,0x2
    38ca:	aae080e7          	jalr	-1362(ra) # 5374 <exit>
      close(fd);
    38ce:	00002097          	auipc	ra,0x2
    38d2:	ace080e7          	jalr	-1330(ra) # 539c <close>
    38d6:	a889                	j	3928 <iref+0xce>
    unlink("xx");
    38d8:	854e                	mv	a0,s3
    38da:	00002097          	auipc	ra,0x2
    38de:	aea080e7          	jalr	-1302(ra) # 53c4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    38e2:	397d                	addiw	s2,s2,-1
    38e4:	06090063          	beqz	s2,3944 <iref+0xea>
    if(mkdir("irefd") != 0){
    38e8:	8552                	mv	a0,s4
    38ea:	00002097          	auipc	ra,0x2
    38ee:	af2080e7          	jalr	-1294(ra) # 53dc <mkdir>
    38f2:	f155                	bnez	a0,3896 <iref+0x3c>
    if(chdir("irefd") != 0){
    38f4:	8552                	mv	a0,s4
    38f6:	00002097          	auipc	ra,0x2
    38fa:	aee080e7          	jalr	-1298(ra) # 53e4 <chdir>
    38fe:	f955                	bnez	a0,38b2 <iref+0x58>
    mkdir("");
    3900:	8526                	mv	a0,s1
    3902:	00002097          	auipc	ra,0x2
    3906:	ada080e7          	jalr	-1318(ra) # 53dc <mkdir>
    link("README", "");
    390a:	85a6                	mv	a1,s1
    390c:	8556                	mv	a0,s5
    390e:	00002097          	auipc	ra,0x2
    3912:	ac6080e7          	jalr	-1338(ra) # 53d4 <link>
    fd = open("", O_CREATE);
    3916:	20000593          	li	a1,512
    391a:	8526                	mv	a0,s1
    391c:	00002097          	auipc	ra,0x2
    3920:	a98080e7          	jalr	-1384(ra) # 53b4 <open>
    if(fd >= 0)
    3924:	fa0555e3          	bgez	a0,38ce <iref+0x74>
    fd = open("xx", O_CREATE);
    3928:	20000593          	li	a1,512
    392c:	854e                	mv	a0,s3
    392e:	00002097          	auipc	ra,0x2
    3932:	a86080e7          	jalr	-1402(ra) # 53b4 <open>
    if(fd >= 0)
    3936:	fa0541e3          	bltz	a0,38d8 <iref+0x7e>
      close(fd);
    393a:	00002097          	auipc	ra,0x2
    393e:	a62080e7          	jalr	-1438(ra) # 539c <close>
    3942:	bf59                	j	38d8 <iref+0x7e>
    3944:	03300493          	li	s1,51
    chdir("..");
    3948:	00004997          	auipc	s3,0x4
    394c:	9a098993          	addi	s3,s3,-1632 # 72e8 <malloc+0x1b3e>
    unlink("irefd");
    3950:	00004917          	auipc	s2,0x4
    3954:	b7890913          	addi	s2,s2,-1160 # 74c8 <malloc+0x1d1e>
    chdir("..");
    3958:	854e                	mv	a0,s3
    395a:	00002097          	auipc	ra,0x2
    395e:	a8a080e7          	jalr	-1398(ra) # 53e4 <chdir>
    unlink("irefd");
    3962:	854a                	mv	a0,s2
    3964:	00002097          	auipc	ra,0x2
    3968:	a60080e7          	jalr	-1440(ra) # 53c4 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    396c:	34fd                	addiw	s1,s1,-1
    396e:	f4ed                	bnez	s1,3958 <iref+0xfe>
  chdir("/");
    3970:	00003517          	auipc	a0,0x3
    3974:	38050513          	addi	a0,a0,896 # 6cf0 <malloc+0x1546>
    3978:	00002097          	auipc	ra,0x2
    397c:	a6c080e7          	jalr	-1428(ra) # 53e4 <chdir>
}
    3980:	70e2                	ld	ra,56(sp)
    3982:	7442                	ld	s0,48(sp)
    3984:	74a2                	ld	s1,40(sp)
    3986:	7902                	ld	s2,32(sp)
    3988:	69e2                	ld	s3,24(sp)
    398a:	6a42                	ld	s4,16(sp)
    398c:	6aa2                	ld	s5,8(sp)
    398e:	6b02                	ld	s6,0(sp)
    3990:	6121                	addi	sp,sp,64
    3992:	8082                	ret

0000000000003994 <openiputtest>:
{
    3994:	7179                	addi	sp,sp,-48
    3996:	f406                	sd	ra,40(sp)
    3998:	f022                	sd	s0,32(sp)
    399a:	ec26                	sd	s1,24(sp)
    399c:	1800                	addi	s0,sp,48
    399e:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    39a0:	00004517          	auipc	a0,0x4
    39a4:	b6050513          	addi	a0,a0,-1184 # 7500 <malloc+0x1d56>
    39a8:	00002097          	auipc	ra,0x2
    39ac:	a34080e7          	jalr	-1484(ra) # 53dc <mkdir>
    39b0:	04054263          	bltz	a0,39f4 <openiputtest+0x60>
  pid = fork();
    39b4:	00002097          	auipc	ra,0x2
    39b8:	9b8080e7          	jalr	-1608(ra) # 536c <fork>
  if(pid < 0){
    39bc:	04054a63          	bltz	a0,3a10 <openiputtest+0x7c>
  if(pid == 0){
    39c0:	e93d                	bnez	a0,3a36 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    39c2:	4589                	li	a1,2
    39c4:	00004517          	auipc	a0,0x4
    39c8:	b3c50513          	addi	a0,a0,-1220 # 7500 <malloc+0x1d56>
    39cc:	00002097          	auipc	ra,0x2
    39d0:	9e8080e7          	jalr	-1560(ra) # 53b4 <open>
    if(fd >= 0){
    39d4:	04054c63          	bltz	a0,3a2c <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    39d8:	85a6                	mv	a1,s1
    39da:	00004517          	auipc	a0,0x4
    39de:	b4650513          	addi	a0,a0,-1210 # 7520 <malloc+0x1d76>
    39e2:	00002097          	auipc	ra,0x2
    39e6:	d0a080e7          	jalr	-758(ra) # 56ec <printf>
      exit(1);
    39ea:	4505                	li	a0,1
    39ec:	00002097          	auipc	ra,0x2
    39f0:	988080e7          	jalr	-1656(ra) # 5374 <exit>
    printf("%s: mkdir oidir failed\n", s);
    39f4:	85a6                	mv	a1,s1
    39f6:	00004517          	auipc	a0,0x4
    39fa:	b1250513          	addi	a0,a0,-1262 # 7508 <malloc+0x1d5e>
    39fe:	00002097          	auipc	ra,0x2
    3a02:	cee080e7          	jalr	-786(ra) # 56ec <printf>
    exit(1);
    3a06:	4505                	li	a0,1
    3a08:	00002097          	auipc	ra,0x2
    3a0c:	96c080e7          	jalr	-1684(ra) # 5374 <exit>
    printf("%s: fork failed\n", s);
    3a10:	85a6                	mv	a1,s1
    3a12:	00003517          	auipc	a0,0x3
    3a16:	9ee50513          	addi	a0,a0,-1554 # 6400 <malloc+0xc56>
    3a1a:	00002097          	auipc	ra,0x2
    3a1e:	cd2080e7          	jalr	-814(ra) # 56ec <printf>
    exit(1);
    3a22:	4505                	li	a0,1
    3a24:	00002097          	auipc	ra,0x2
    3a28:	950080e7          	jalr	-1712(ra) # 5374 <exit>
    exit(0);
    3a2c:	4501                	li	a0,0
    3a2e:	00002097          	auipc	ra,0x2
    3a32:	946080e7          	jalr	-1722(ra) # 5374 <exit>
  sleep(1);
    3a36:	4505                	li	a0,1
    3a38:	00002097          	auipc	ra,0x2
    3a3c:	9cc080e7          	jalr	-1588(ra) # 5404 <sleep>
  if(unlink("oidir") != 0){
    3a40:	00004517          	auipc	a0,0x4
    3a44:	ac050513          	addi	a0,a0,-1344 # 7500 <malloc+0x1d56>
    3a48:	00002097          	auipc	ra,0x2
    3a4c:	97c080e7          	jalr	-1668(ra) # 53c4 <unlink>
    3a50:	cd19                	beqz	a0,3a6e <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    3a52:	85a6                	mv	a1,s1
    3a54:	00003517          	auipc	a0,0x3
    3a58:	b9c50513          	addi	a0,a0,-1124 # 65f0 <malloc+0xe46>
    3a5c:	00002097          	auipc	ra,0x2
    3a60:	c90080e7          	jalr	-880(ra) # 56ec <printf>
    exit(1);
    3a64:	4505                	li	a0,1
    3a66:	00002097          	auipc	ra,0x2
    3a6a:	90e080e7          	jalr	-1778(ra) # 5374 <exit>
  wait(&xstatus);
    3a6e:	fdc40513          	addi	a0,s0,-36
    3a72:	00002097          	auipc	ra,0x2
    3a76:	90a080e7          	jalr	-1782(ra) # 537c <wait>
  exit(xstatus);
    3a7a:	fdc42503          	lw	a0,-36(s0)
    3a7e:	00002097          	auipc	ra,0x2
    3a82:	8f6080e7          	jalr	-1802(ra) # 5374 <exit>

0000000000003a86 <forkforkfork>:
{
    3a86:	1101                	addi	sp,sp,-32
    3a88:	ec06                	sd	ra,24(sp)
    3a8a:	e822                	sd	s0,16(sp)
    3a8c:	e426                	sd	s1,8(sp)
    3a8e:	1000                	addi	s0,sp,32
    3a90:	84aa                	mv	s1,a0
  unlink("stopforking");
    3a92:	00004517          	auipc	a0,0x4
    3a96:	ab650513          	addi	a0,a0,-1354 # 7548 <malloc+0x1d9e>
    3a9a:	00002097          	auipc	ra,0x2
    3a9e:	92a080e7          	jalr	-1750(ra) # 53c4 <unlink>
  int pid = fork();
    3aa2:	00002097          	auipc	ra,0x2
    3aa6:	8ca080e7          	jalr	-1846(ra) # 536c <fork>
  if(pid < 0){
    3aaa:	04054563          	bltz	a0,3af4 <forkforkfork+0x6e>
  if(pid == 0){
    3aae:	c12d                	beqz	a0,3b10 <forkforkfork+0x8a>
  sleep(20); // two seconds
    3ab0:	4551                	li	a0,20
    3ab2:	00002097          	auipc	ra,0x2
    3ab6:	952080e7          	jalr	-1710(ra) # 5404 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3aba:	20200593          	li	a1,514
    3abe:	00004517          	auipc	a0,0x4
    3ac2:	a8a50513          	addi	a0,a0,-1398 # 7548 <malloc+0x1d9e>
    3ac6:	00002097          	auipc	ra,0x2
    3aca:	8ee080e7          	jalr	-1810(ra) # 53b4 <open>
    3ace:	00002097          	auipc	ra,0x2
    3ad2:	8ce080e7          	jalr	-1842(ra) # 539c <close>
  wait(0);
    3ad6:	4501                	li	a0,0
    3ad8:	00002097          	auipc	ra,0x2
    3adc:	8a4080e7          	jalr	-1884(ra) # 537c <wait>
  sleep(10); // one second
    3ae0:	4529                	li	a0,10
    3ae2:	00002097          	auipc	ra,0x2
    3ae6:	922080e7          	jalr	-1758(ra) # 5404 <sleep>
}
    3aea:	60e2                	ld	ra,24(sp)
    3aec:	6442                	ld	s0,16(sp)
    3aee:	64a2                	ld	s1,8(sp)
    3af0:	6105                	addi	sp,sp,32
    3af2:	8082                	ret
    printf("%s: fork failed", s);
    3af4:	85a6                	mv	a1,s1
    3af6:	00003517          	auipc	a0,0x3
    3afa:	aca50513          	addi	a0,a0,-1334 # 65c0 <malloc+0xe16>
    3afe:	00002097          	auipc	ra,0x2
    3b02:	bee080e7          	jalr	-1042(ra) # 56ec <printf>
    exit(1);
    3b06:	4505                	li	a0,1
    3b08:	00002097          	auipc	ra,0x2
    3b0c:	86c080e7          	jalr	-1940(ra) # 5374 <exit>
      int fd = open("stopforking", 0);
    3b10:	00004497          	auipc	s1,0x4
    3b14:	a3848493          	addi	s1,s1,-1480 # 7548 <malloc+0x1d9e>
    3b18:	4581                	li	a1,0
    3b1a:	8526                	mv	a0,s1
    3b1c:	00002097          	auipc	ra,0x2
    3b20:	898080e7          	jalr	-1896(ra) # 53b4 <open>
      if(fd >= 0){
    3b24:	02055463          	bgez	a0,3b4c <forkforkfork+0xc6>
      if(fork() < 0){
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	844080e7          	jalr	-1980(ra) # 536c <fork>
    3b30:	fe0554e3          	bgez	a0,3b18 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    3b34:	20200593          	li	a1,514
    3b38:	8526                	mv	a0,s1
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	87a080e7          	jalr	-1926(ra) # 53b4 <open>
    3b42:	00002097          	auipc	ra,0x2
    3b46:	85a080e7          	jalr	-1958(ra) # 539c <close>
    3b4a:	b7f9                	j	3b18 <forkforkfork+0x92>
        exit(0);
    3b4c:	4501                	li	a0,0
    3b4e:	00002097          	auipc	ra,0x2
    3b52:	826080e7          	jalr	-2010(ra) # 5374 <exit>

0000000000003b56 <preempt>:
{
    3b56:	7139                	addi	sp,sp,-64
    3b58:	fc06                	sd	ra,56(sp)
    3b5a:	f822                	sd	s0,48(sp)
    3b5c:	f426                	sd	s1,40(sp)
    3b5e:	f04a                	sd	s2,32(sp)
    3b60:	ec4e                	sd	s3,24(sp)
    3b62:	e852                	sd	s4,16(sp)
    3b64:	0080                	addi	s0,sp,64
    3b66:	8a2a                	mv	s4,a0
  pid1 = fork();
    3b68:	00002097          	auipc	ra,0x2
    3b6c:	804080e7          	jalr	-2044(ra) # 536c <fork>
  if(pid1 < 0) {
    3b70:	00054563          	bltz	a0,3b7a <preempt+0x24>
    3b74:	89aa                	mv	s3,a0
  if(pid1 == 0)
    3b76:	ed19                	bnez	a0,3b94 <preempt+0x3e>
    for(;;)
    3b78:	a001                	j	3b78 <preempt+0x22>
    printf("%s: fork failed");
    3b7a:	00003517          	auipc	a0,0x3
    3b7e:	a4650513          	addi	a0,a0,-1466 # 65c0 <malloc+0xe16>
    3b82:	00002097          	auipc	ra,0x2
    3b86:	b6a080e7          	jalr	-1174(ra) # 56ec <printf>
    exit(1);
    3b8a:	4505                	li	a0,1
    3b8c:	00001097          	auipc	ra,0x1
    3b90:	7e8080e7          	jalr	2024(ra) # 5374 <exit>
  pid2 = fork();
    3b94:	00001097          	auipc	ra,0x1
    3b98:	7d8080e7          	jalr	2008(ra) # 536c <fork>
    3b9c:	892a                	mv	s2,a0
  if(pid2 < 0) {
    3b9e:	00054463          	bltz	a0,3ba6 <preempt+0x50>
  if(pid2 == 0)
    3ba2:	e105                	bnez	a0,3bc2 <preempt+0x6c>
    for(;;)
    3ba4:	a001                	j	3ba4 <preempt+0x4e>
    printf("%s: fork failed\n", s);
    3ba6:	85d2                	mv	a1,s4
    3ba8:	00003517          	auipc	a0,0x3
    3bac:	85850513          	addi	a0,a0,-1960 # 6400 <malloc+0xc56>
    3bb0:	00002097          	auipc	ra,0x2
    3bb4:	b3c080e7          	jalr	-1220(ra) # 56ec <printf>
    exit(1);
    3bb8:	4505                	li	a0,1
    3bba:	00001097          	auipc	ra,0x1
    3bbe:	7ba080e7          	jalr	1978(ra) # 5374 <exit>
  pipe(pfds);
    3bc2:	fc840513          	addi	a0,s0,-56
    3bc6:	00001097          	auipc	ra,0x1
    3bca:	7be080e7          	jalr	1982(ra) # 5384 <pipe>
  pid3 = fork();
    3bce:	00001097          	auipc	ra,0x1
    3bd2:	79e080e7          	jalr	1950(ra) # 536c <fork>
    3bd6:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    3bd8:	02054e63          	bltz	a0,3c14 <preempt+0xbe>
  if(pid3 == 0){
    3bdc:	e13d                	bnez	a0,3c42 <preempt+0xec>
    close(pfds[0]);
    3bde:	fc842503          	lw	a0,-56(s0)
    3be2:	00001097          	auipc	ra,0x1
    3be6:	7ba080e7          	jalr	1978(ra) # 539c <close>
    if(write(pfds[1], "x", 1) != 1)
    3bea:	4605                	li	a2,1
    3bec:	00002597          	auipc	a1,0x2
    3bf0:	04c58593          	addi	a1,a1,76 # 5c38 <malloc+0x48e>
    3bf4:	fcc42503          	lw	a0,-52(s0)
    3bf8:	00001097          	auipc	ra,0x1
    3bfc:	79c080e7          	jalr	1948(ra) # 5394 <write>
    3c00:	4785                	li	a5,1
    3c02:	02f51763          	bne	a0,a5,3c30 <preempt+0xda>
    close(pfds[1]);
    3c06:	fcc42503          	lw	a0,-52(s0)
    3c0a:	00001097          	auipc	ra,0x1
    3c0e:	792080e7          	jalr	1938(ra) # 539c <close>
    for(;;)
    3c12:	a001                	j	3c12 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    3c14:	85d2                	mv	a1,s4
    3c16:	00002517          	auipc	a0,0x2
    3c1a:	7ea50513          	addi	a0,a0,2026 # 6400 <malloc+0xc56>
    3c1e:	00002097          	auipc	ra,0x2
    3c22:	ace080e7          	jalr	-1330(ra) # 56ec <printf>
     exit(1);
    3c26:	4505                	li	a0,1
    3c28:	00001097          	auipc	ra,0x1
    3c2c:	74c080e7          	jalr	1868(ra) # 5374 <exit>
      printf("%s: preempt write error");
    3c30:	00004517          	auipc	a0,0x4
    3c34:	92850513          	addi	a0,a0,-1752 # 7558 <malloc+0x1dae>
    3c38:	00002097          	auipc	ra,0x2
    3c3c:	ab4080e7          	jalr	-1356(ra) # 56ec <printf>
    3c40:	b7d9                	j	3c06 <preempt+0xb0>
  close(pfds[1]);
    3c42:	fcc42503          	lw	a0,-52(s0)
    3c46:	00001097          	auipc	ra,0x1
    3c4a:	756080e7          	jalr	1878(ra) # 539c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3c4e:	660d                	lui	a2,0x3
    3c50:	00008597          	auipc	a1,0x8
    3c54:	ae058593          	addi	a1,a1,-1312 # b730 <buf>
    3c58:	fc842503          	lw	a0,-56(s0)
    3c5c:	00001097          	auipc	ra,0x1
    3c60:	730080e7          	jalr	1840(ra) # 538c <read>
    3c64:	4785                	li	a5,1
    3c66:	02f50263          	beq	a0,a5,3c8a <preempt+0x134>
    printf("%s: preempt read error");
    3c6a:	00004517          	auipc	a0,0x4
    3c6e:	90650513          	addi	a0,a0,-1786 # 7570 <malloc+0x1dc6>
    3c72:	00002097          	auipc	ra,0x2
    3c76:	a7a080e7          	jalr	-1414(ra) # 56ec <printf>
}
    3c7a:	70e2                	ld	ra,56(sp)
    3c7c:	7442                	ld	s0,48(sp)
    3c7e:	74a2                	ld	s1,40(sp)
    3c80:	7902                	ld	s2,32(sp)
    3c82:	69e2                	ld	s3,24(sp)
    3c84:	6a42                	ld	s4,16(sp)
    3c86:	6121                	addi	sp,sp,64
    3c88:	8082                	ret
  close(pfds[0]);
    3c8a:	fc842503          	lw	a0,-56(s0)
    3c8e:	00001097          	auipc	ra,0x1
    3c92:	70e080e7          	jalr	1806(ra) # 539c <close>
  printf("kill... ");
    3c96:	00004517          	auipc	a0,0x4
    3c9a:	8f250513          	addi	a0,a0,-1806 # 7588 <malloc+0x1dde>
    3c9e:	00002097          	auipc	ra,0x2
    3ca2:	a4e080e7          	jalr	-1458(ra) # 56ec <printf>
  kill(pid1);
    3ca6:	854e                	mv	a0,s3
    3ca8:	00001097          	auipc	ra,0x1
    3cac:	6fc080e7          	jalr	1788(ra) # 53a4 <kill>
  kill(pid2);
    3cb0:	854a                	mv	a0,s2
    3cb2:	00001097          	auipc	ra,0x1
    3cb6:	6f2080e7          	jalr	1778(ra) # 53a4 <kill>
  kill(pid3);
    3cba:	8526                	mv	a0,s1
    3cbc:	00001097          	auipc	ra,0x1
    3cc0:	6e8080e7          	jalr	1768(ra) # 53a4 <kill>
  printf("wait... ");
    3cc4:	00004517          	auipc	a0,0x4
    3cc8:	8d450513          	addi	a0,a0,-1836 # 7598 <malloc+0x1dee>
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	a20080e7          	jalr	-1504(ra) # 56ec <printf>
  wait(0);
    3cd4:	4501                	li	a0,0
    3cd6:	00001097          	auipc	ra,0x1
    3cda:	6a6080e7          	jalr	1702(ra) # 537c <wait>
  wait(0);
    3cde:	4501                	li	a0,0
    3ce0:	00001097          	auipc	ra,0x1
    3ce4:	69c080e7          	jalr	1692(ra) # 537c <wait>
  wait(0);
    3ce8:	4501                	li	a0,0
    3cea:	00001097          	auipc	ra,0x1
    3cee:	692080e7          	jalr	1682(ra) # 537c <wait>
    3cf2:	b761                	j	3c7a <preempt+0x124>

0000000000003cf4 <sbrkfail>:
{
    3cf4:	7119                	addi	sp,sp,-128
    3cf6:	fc86                	sd	ra,120(sp)
    3cf8:	f8a2                	sd	s0,112(sp)
    3cfa:	f4a6                	sd	s1,104(sp)
    3cfc:	f0ca                	sd	s2,96(sp)
    3cfe:	ecce                	sd	s3,88(sp)
    3d00:	e8d2                	sd	s4,80(sp)
    3d02:	e4d6                	sd	s5,72(sp)
    3d04:	0100                	addi	s0,sp,128
    3d06:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    3d08:	fb040513          	addi	a0,s0,-80
    3d0c:	00001097          	auipc	ra,0x1
    3d10:	678080e7          	jalr	1656(ra) # 5384 <pipe>
    3d14:	e901                	bnez	a0,3d24 <sbrkfail+0x30>
    3d16:	f8040493          	addi	s1,s0,-128
    3d1a:	fa840a13          	addi	s4,s0,-88
    3d1e:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    3d20:	5afd                	li	s5,-1
    3d22:	a08d                	j	3d84 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    3d24:	85ca                	mv	a1,s2
    3d26:	00002517          	auipc	a0,0x2
    3d2a:	7e250513          	addi	a0,a0,2018 # 6508 <malloc+0xd5e>
    3d2e:	00002097          	auipc	ra,0x2
    3d32:	9be080e7          	jalr	-1602(ra) # 56ec <printf>
    exit(1);
    3d36:	4505                	li	a0,1
    3d38:	00001097          	auipc	ra,0x1
    3d3c:	63c080e7          	jalr	1596(ra) # 5374 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3d40:	4501                	li	a0,0
    3d42:	00001097          	auipc	ra,0x1
    3d46:	6ba080e7          	jalr	1722(ra) # 53fc <sbrk>
    3d4a:	064007b7          	lui	a5,0x6400
    3d4e:	40a7853b          	subw	a0,a5,a0
    3d52:	00001097          	auipc	ra,0x1
    3d56:	6aa080e7          	jalr	1706(ra) # 53fc <sbrk>
      write(fds[1], "x", 1);
    3d5a:	4605                	li	a2,1
    3d5c:	00002597          	auipc	a1,0x2
    3d60:	edc58593          	addi	a1,a1,-292 # 5c38 <malloc+0x48e>
    3d64:	fb442503          	lw	a0,-76(s0)
    3d68:	00001097          	auipc	ra,0x1
    3d6c:	62c080e7          	jalr	1580(ra) # 5394 <write>
      for(;;) sleep(1000);
    3d70:	3e800513          	li	a0,1000
    3d74:	00001097          	auipc	ra,0x1
    3d78:	690080e7          	jalr	1680(ra) # 5404 <sleep>
    3d7c:	bfd5                	j	3d70 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3d7e:	0991                	addi	s3,s3,4
    3d80:	03498563          	beq	s3,s4,3daa <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    3d84:	00001097          	auipc	ra,0x1
    3d88:	5e8080e7          	jalr	1512(ra) # 536c <fork>
    3d8c:	00a9a023          	sw	a0,0(s3)
    3d90:	d945                	beqz	a0,3d40 <sbrkfail+0x4c>
    if(pids[i] != -1)
    3d92:	ff5506e3          	beq	a0,s5,3d7e <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    3d96:	4605                	li	a2,1
    3d98:	faf40593          	addi	a1,s0,-81
    3d9c:	fb042503          	lw	a0,-80(s0)
    3da0:	00001097          	auipc	ra,0x1
    3da4:	5ec080e7          	jalr	1516(ra) # 538c <read>
    3da8:	bfd9                	j	3d7e <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    3daa:	6505                	lui	a0,0x1
    3dac:	00001097          	auipc	ra,0x1
    3db0:	650080e7          	jalr	1616(ra) # 53fc <sbrk>
    3db4:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    3db6:	5afd                	li	s5,-1
    3db8:	a021                	j	3dc0 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3dba:	0491                	addi	s1,s1,4
    3dbc:	01448f63          	beq	s1,s4,3dda <sbrkfail+0xe6>
    if(pids[i] == -1)
    3dc0:	4088                	lw	a0,0(s1)
    3dc2:	ff550ce3          	beq	a0,s5,3dba <sbrkfail+0xc6>
    kill(pids[i]);
    3dc6:	00001097          	auipc	ra,0x1
    3dca:	5de080e7          	jalr	1502(ra) # 53a4 <kill>
    wait(0);
    3dce:	4501                	li	a0,0
    3dd0:	00001097          	auipc	ra,0x1
    3dd4:	5ac080e7          	jalr	1452(ra) # 537c <wait>
    3dd8:	b7cd                	j	3dba <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    3dda:	57fd                	li	a5,-1
    3ddc:	04f98163          	beq	s3,a5,3e1e <sbrkfail+0x12a>
  pid = fork();
    3de0:	00001097          	auipc	ra,0x1
    3de4:	58c080e7          	jalr	1420(ra) # 536c <fork>
    3de8:	84aa                	mv	s1,a0
  if(pid < 0){
    3dea:	04054863          	bltz	a0,3e3a <sbrkfail+0x146>
  if(pid == 0){
    3dee:	c525                	beqz	a0,3e56 <sbrkfail+0x162>
  wait(&xstatus);
    3df0:	fbc40513          	addi	a0,s0,-68
    3df4:	00001097          	auipc	ra,0x1
    3df8:	588080e7          	jalr	1416(ra) # 537c <wait>
  if(xstatus != -1 && xstatus != 2)
    3dfc:	fbc42783          	lw	a5,-68(s0)
    3e00:	577d                	li	a4,-1
    3e02:	00e78563          	beq	a5,a4,3e0c <sbrkfail+0x118>
    3e06:	4709                	li	a4,2
    3e08:	08e79c63          	bne	a5,a4,3ea0 <sbrkfail+0x1ac>
}
    3e0c:	70e6                	ld	ra,120(sp)
    3e0e:	7446                	ld	s0,112(sp)
    3e10:	74a6                	ld	s1,104(sp)
    3e12:	7906                	ld	s2,96(sp)
    3e14:	69e6                	ld	s3,88(sp)
    3e16:	6a46                	ld	s4,80(sp)
    3e18:	6aa6                	ld	s5,72(sp)
    3e1a:	6109                	addi	sp,sp,128
    3e1c:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3e1e:	85ca                	mv	a1,s2
    3e20:	00003517          	auipc	a0,0x3
    3e24:	78850513          	addi	a0,a0,1928 # 75a8 <malloc+0x1dfe>
    3e28:	00002097          	auipc	ra,0x2
    3e2c:	8c4080e7          	jalr	-1852(ra) # 56ec <printf>
    exit(1);
    3e30:	4505                	li	a0,1
    3e32:	00001097          	auipc	ra,0x1
    3e36:	542080e7          	jalr	1346(ra) # 5374 <exit>
    printf("%s: fork failed\n", s);
    3e3a:	85ca                	mv	a1,s2
    3e3c:	00002517          	auipc	a0,0x2
    3e40:	5c450513          	addi	a0,a0,1476 # 6400 <malloc+0xc56>
    3e44:	00002097          	auipc	ra,0x2
    3e48:	8a8080e7          	jalr	-1880(ra) # 56ec <printf>
    exit(1);
    3e4c:	4505                	li	a0,1
    3e4e:	00001097          	auipc	ra,0x1
    3e52:	526080e7          	jalr	1318(ra) # 5374 <exit>
    a = sbrk(0);
    3e56:	4501                	li	a0,0
    3e58:	00001097          	auipc	ra,0x1
    3e5c:	5a4080e7          	jalr	1444(ra) # 53fc <sbrk>
    3e60:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3e62:	3e800537          	lui	a0,0x3e800
    3e66:	00001097          	auipc	ra,0x1
    3e6a:	596080e7          	jalr	1430(ra) # 53fc <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e6e:	874a                	mv	a4,s2
    3e70:	3e8007b7          	lui	a5,0x3e800
    3e74:	97ca                	add	a5,a5,s2
    3e76:	6685                	lui	a3,0x1
      n += *(a+i);
    3e78:	00074603          	lbu	a2,0(a4)
    3e7c:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3e7e:	9736                	add	a4,a4,a3
    3e80:	fef71ce3          	bne	a4,a5,3e78 <sbrkfail+0x184>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    3e84:	85a6                	mv	a1,s1
    3e86:	00003517          	auipc	a0,0x3
    3e8a:	74250513          	addi	a0,a0,1858 # 75c8 <malloc+0x1e1e>
    3e8e:	00002097          	auipc	ra,0x2
    3e92:	85e080e7          	jalr	-1954(ra) # 56ec <printf>
    exit(1);
    3e96:	4505                	li	a0,1
    3e98:	00001097          	auipc	ra,0x1
    3e9c:	4dc080e7          	jalr	1244(ra) # 5374 <exit>
    exit(1);
    3ea0:	4505                	li	a0,1
    3ea2:	00001097          	auipc	ra,0x1
    3ea6:	4d2080e7          	jalr	1234(ra) # 5374 <exit>

0000000000003eaa <reparent>:
{
    3eaa:	7179                	addi	sp,sp,-48
    3eac:	f406                	sd	ra,40(sp)
    3eae:	f022                	sd	s0,32(sp)
    3eb0:	ec26                	sd	s1,24(sp)
    3eb2:	e84a                	sd	s2,16(sp)
    3eb4:	e44e                	sd	s3,8(sp)
    3eb6:	e052                	sd	s4,0(sp)
    3eb8:	1800                	addi	s0,sp,48
    3eba:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3ebc:	00001097          	auipc	ra,0x1
    3ec0:	538080e7          	jalr	1336(ra) # 53f4 <getpid>
    3ec4:	8a2a                	mv	s4,a0
    3ec6:	0c800913          	li	s2,200
    int pid = fork();
    3eca:	00001097          	auipc	ra,0x1
    3ece:	4a2080e7          	jalr	1186(ra) # 536c <fork>
    3ed2:	84aa                	mv	s1,a0
    if(pid < 0){
    3ed4:	02054263          	bltz	a0,3ef8 <reparent+0x4e>
    if(pid){
    3ed8:	cd21                	beqz	a0,3f30 <reparent+0x86>
      if(wait(0) != pid){
    3eda:	4501                	li	a0,0
    3edc:	00001097          	auipc	ra,0x1
    3ee0:	4a0080e7          	jalr	1184(ra) # 537c <wait>
    3ee4:	02951863          	bne	a0,s1,3f14 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    3ee8:	397d                	addiw	s2,s2,-1
    3eea:	fe0910e3          	bnez	s2,3eca <reparent+0x20>
  exit(0);
    3eee:	4501                	li	a0,0
    3ef0:	00001097          	auipc	ra,0x1
    3ef4:	484080e7          	jalr	1156(ra) # 5374 <exit>
      printf("%s: fork failed\n", s);
    3ef8:	85ce                	mv	a1,s3
    3efa:	00002517          	auipc	a0,0x2
    3efe:	50650513          	addi	a0,a0,1286 # 6400 <malloc+0xc56>
    3f02:	00001097          	auipc	ra,0x1
    3f06:	7ea080e7          	jalr	2026(ra) # 56ec <printf>
      exit(1);
    3f0a:	4505                	li	a0,1
    3f0c:	00001097          	auipc	ra,0x1
    3f10:	468080e7          	jalr	1128(ra) # 5374 <exit>
        printf("%s: wait wrong pid\n", s);
    3f14:	85ce                	mv	a1,s3
    3f16:	00002517          	auipc	a0,0x2
    3f1a:	67250513          	addi	a0,a0,1650 # 6588 <malloc+0xdde>
    3f1e:	00001097          	auipc	ra,0x1
    3f22:	7ce080e7          	jalr	1998(ra) # 56ec <printf>
        exit(1);
    3f26:	4505                	li	a0,1
    3f28:	00001097          	auipc	ra,0x1
    3f2c:	44c080e7          	jalr	1100(ra) # 5374 <exit>
      int pid2 = fork();
    3f30:	00001097          	auipc	ra,0x1
    3f34:	43c080e7          	jalr	1084(ra) # 536c <fork>
      if(pid2 < 0){
    3f38:	00054763          	bltz	a0,3f46 <reparent+0x9c>
      exit(0);
    3f3c:	4501                	li	a0,0
    3f3e:	00001097          	auipc	ra,0x1
    3f42:	436080e7          	jalr	1078(ra) # 5374 <exit>
        kill(master_pid);
    3f46:	8552                	mv	a0,s4
    3f48:	00001097          	auipc	ra,0x1
    3f4c:	45c080e7          	jalr	1116(ra) # 53a4 <kill>
        exit(1);
    3f50:	4505                	li	a0,1
    3f52:	00001097          	auipc	ra,0x1
    3f56:	422080e7          	jalr	1058(ra) # 5374 <exit>

0000000000003f5a <mem>:
{
    3f5a:	7139                	addi	sp,sp,-64
    3f5c:	fc06                	sd	ra,56(sp)
    3f5e:	f822                	sd	s0,48(sp)
    3f60:	f426                	sd	s1,40(sp)
    3f62:	f04a                	sd	s2,32(sp)
    3f64:	ec4e                	sd	s3,24(sp)
    3f66:	0080                	addi	s0,sp,64
    3f68:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3f6a:	00001097          	auipc	ra,0x1
    3f6e:	402080e7          	jalr	1026(ra) # 536c <fork>
    m1 = 0;
    3f72:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3f74:	6909                	lui	s2,0x2
    3f76:	71190913          	addi	s2,s2,1809 # 2711 <sbrkarg+0xbf>
  if((pid = fork()) == 0){
    3f7a:	ed39                	bnez	a0,3fd8 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    3f7c:	854a                	mv	a0,s2
    3f7e:	00002097          	auipc	ra,0x2
    3f82:	82c080e7          	jalr	-2004(ra) # 57aa <malloc>
    3f86:	c501                	beqz	a0,3f8e <mem+0x34>
      *(char**)m2 = m1;
    3f88:	e104                	sd	s1,0(a0)
      m1 = m2;
    3f8a:	84aa                	mv	s1,a0
    3f8c:	bfc5                	j	3f7c <mem+0x22>
    while(m1){
    3f8e:	c881                	beqz	s1,3f9e <mem+0x44>
      m2 = *(char**)m1;
    3f90:	8526                	mv	a0,s1
    3f92:	6084                	ld	s1,0(s1)
      free(m1);
    3f94:	00001097          	auipc	ra,0x1
    3f98:	78e080e7          	jalr	1934(ra) # 5722 <free>
    while(m1){
    3f9c:	f8f5                	bnez	s1,3f90 <mem+0x36>
    m1 = malloc(1024*20);
    3f9e:	6515                	lui	a0,0x5
    3fa0:	00002097          	auipc	ra,0x2
    3fa4:	80a080e7          	jalr	-2038(ra) # 57aa <malloc>
    if(m1 == 0){
    3fa8:	c911                	beqz	a0,3fbc <mem+0x62>
    free(m1);
    3faa:	00001097          	auipc	ra,0x1
    3fae:	778080e7          	jalr	1912(ra) # 5722 <free>
    exit(0);
    3fb2:	4501                	li	a0,0
    3fb4:	00001097          	auipc	ra,0x1
    3fb8:	3c0080e7          	jalr	960(ra) # 5374 <exit>
      printf("couldn't allocate mem?!!\n", s);
    3fbc:	85ce                	mv	a1,s3
    3fbe:	00003517          	auipc	a0,0x3
    3fc2:	63a50513          	addi	a0,a0,1594 # 75f8 <malloc+0x1e4e>
    3fc6:	00001097          	auipc	ra,0x1
    3fca:	726080e7          	jalr	1830(ra) # 56ec <printf>
      exit(1);
    3fce:	4505                	li	a0,1
    3fd0:	00001097          	auipc	ra,0x1
    3fd4:	3a4080e7          	jalr	932(ra) # 5374 <exit>
    wait(&xstatus);
    3fd8:	fcc40513          	addi	a0,s0,-52
    3fdc:	00001097          	auipc	ra,0x1
    3fe0:	3a0080e7          	jalr	928(ra) # 537c <wait>
    if(xstatus == -1){
    3fe4:	fcc42503          	lw	a0,-52(s0)
    3fe8:	57fd                	li	a5,-1
    3fea:	00f50663          	beq	a0,a5,3ff6 <mem+0x9c>
    exit(xstatus);
    3fee:	00001097          	auipc	ra,0x1
    3ff2:	386080e7          	jalr	902(ra) # 5374 <exit>
      exit(0);
    3ff6:	4501                	li	a0,0
    3ff8:	00001097          	auipc	ra,0x1
    3ffc:	37c080e7          	jalr	892(ra) # 5374 <exit>

0000000000004000 <sharedfd>:
{
    4000:	7159                	addi	sp,sp,-112
    4002:	f486                	sd	ra,104(sp)
    4004:	f0a2                	sd	s0,96(sp)
    4006:	eca6                	sd	s1,88(sp)
    4008:	e8ca                	sd	s2,80(sp)
    400a:	e4ce                	sd	s3,72(sp)
    400c:	e0d2                	sd	s4,64(sp)
    400e:	fc56                	sd	s5,56(sp)
    4010:	f85a                	sd	s6,48(sp)
    4012:	f45e                	sd	s7,40(sp)
    4014:	1880                	addi	s0,sp,112
    4016:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4018:	00002517          	auipc	a0,0x2
    401c:	9f850513          	addi	a0,a0,-1544 # 5a10 <malloc+0x266>
    4020:	00001097          	auipc	ra,0x1
    4024:	3a4080e7          	jalr	932(ra) # 53c4 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4028:	20200593          	li	a1,514
    402c:	00002517          	auipc	a0,0x2
    4030:	9e450513          	addi	a0,a0,-1564 # 5a10 <malloc+0x266>
    4034:	00001097          	auipc	ra,0x1
    4038:	380080e7          	jalr	896(ra) # 53b4 <open>
  if(fd < 0){
    403c:	04054a63          	bltz	a0,4090 <sharedfd+0x90>
    4040:	892a                	mv	s2,a0
  pid = fork();
    4042:	00001097          	auipc	ra,0x1
    4046:	32a080e7          	jalr	810(ra) # 536c <fork>
    404a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    404c:	06300593          	li	a1,99
    4050:	c119                	beqz	a0,4056 <sharedfd+0x56>
    4052:	07000593          	li	a1,112
    4056:	4629                	li	a2,10
    4058:	fa040513          	addi	a0,s0,-96
    405c:	00001097          	auipc	ra,0x1
    4060:	114080e7          	jalr	276(ra) # 5170 <memset>
    4064:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4068:	4629                	li	a2,10
    406a:	fa040593          	addi	a1,s0,-96
    406e:	854a                	mv	a0,s2
    4070:	00001097          	auipc	ra,0x1
    4074:	324080e7          	jalr	804(ra) # 5394 <write>
    4078:	47a9                	li	a5,10
    407a:	02f51963          	bne	a0,a5,40ac <sharedfd+0xac>
  for(i = 0; i < N; i++){
    407e:	34fd                	addiw	s1,s1,-1
    4080:	f4e5                	bnez	s1,4068 <sharedfd+0x68>
  if(pid == 0) {
    4082:	04099363          	bnez	s3,40c8 <sharedfd+0xc8>
    exit(0);
    4086:	4501                	li	a0,0
    4088:	00001097          	auipc	ra,0x1
    408c:	2ec080e7          	jalr	748(ra) # 5374 <exit>
    printf("%s: cannot open sharedfd for writing", s);
    4090:	85d2                	mv	a1,s4
    4092:	00003517          	auipc	a0,0x3
    4096:	58650513          	addi	a0,a0,1414 # 7618 <malloc+0x1e6e>
    409a:	00001097          	auipc	ra,0x1
    409e:	652080e7          	jalr	1618(ra) # 56ec <printf>
    exit(1);
    40a2:	4505                	li	a0,1
    40a4:	00001097          	auipc	ra,0x1
    40a8:	2d0080e7          	jalr	720(ra) # 5374 <exit>
      printf("%s: write sharedfd failed\n", s);
    40ac:	85d2                	mv	a1,s4
    40ae:	00003517          	auipc	a0,0x3
    40b2:	59250513          	addi	a0,a0,1426 # 7640 <malloc+0x1e96>
    40b6:	00001097          	auipc	ra,0x1
    40ba:	636080e7          	jalr	1590(ra) # 56ec <printf>
      exit(1);
    40be:	4505                	li	a0,1
    40c0:	00001097          	auipc	ra,0x1
    40c4:	2b4080e7          	jalr	692(ra) # 5374 <exit>
    wait(&xstatus);
    40c8:	f9c40513          	addi	a0,s0,-100
    40cc:	00001097          	auipc	ra,0x1
    40d0:	2b0080e7          	jalr	688(ra) # 537c <wait>
    if(xstatus != 0)
    40d4:	f9c42983          	lw	s3,-100(s0)
    40d8:	00098763          	beqz	s3,40e6 <sharedfd+0xe6>
      exit(xstatus);
    40dc:	854e                	mv	a0,s3
    40de:	00001097          	auipc	ra,0x1
    40e2:	296080e7          	jalr	662(ra) # 5374 <exit>
  close(fd);
    40e6:	854a                	mv	a0,s2
    40e8:	00001097          	auipc	ra,0x1
    40ec:	2b4080e7          	jalr	692(ra) # 539c <close>
  fd = open("sharedfd", 0);
    40f0:	4581                	li	a1,0
    40f2:	00002517          	auipc	a0,0x2
    40f6:	91e50513          	addi	a0,a0,-1762 # 5a10 <malloc+0x266>
    40fa:	00001097          	auipc	ra,0x1
    40fe:	2ba080e7          	jalr	698(ra) # 53b4 <open>
    4102:	8baa                	mv	s7,a0
  nc = np = 0;
    4104:	8ace                	mv	s5,s3
  if(fd < 0){
    4106:	02054563          	bltz	a0,4130 <sharedfd+0x130>
    410a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    410e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4112:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4116:	4629                	li	a2,10
    4118:	fa040593          	addi	a1,s0,-96
    411c:	855e                	mv	a0,s7
    411e:	00001097          	auipc	ra,0x1
    4122:	26e080e7          	jalr	622(ra) # 538c <read>
    4126:	02a05f63          	blez	a0,4164 <sharedfd+0x164>
    412a:	fa040793          	addi	a5,s0,-96
    412e:	a01d                	j	4154 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    4130:	85d2                	mv	a1,s4
    4132:	00003517          	auipc	a0,0x3
    4136:	52e50513          	addi	a0,a0,1326 # 7660 <malloc+0x1eb6>
    413a:	00001097          	auipc	ra,0x1
    413e:	5b2080e7          	jalr	1458(ra) # 56ec <printf>
    exit(1);
    4142:	4505                	li	a0,1
    4144:	00001097          	auipc	ra,0x1
    4148:	230080e7          	jalr	560(ra) # 5374 <exit>
        nc++;
    414c:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    414e:	0785                	addi	a5,a5,1
    4150:	fd2783e3          	beq	a5,s2,4116 <sharedfd+0x116>
      if(buf[i] == 'c')
    4154:	0007c703          	lbu	a4,0(a5) # 3e800000 <__BSS_END__+0x3e7f18c0>
    4158:	fe970ae3          	beq	a4,s1,414c <sharedfd+0x14c>
      if(buf[i] == 'p')
    415c:	ff6719e3          	bne	a4,s6,414e <sharedfd+0x14e>
        np++;
    4160:	2a85                	addiw	s5,s5,1
    4162:	b7f5                	j	414e <sharedfd+0x14e>
  close(fd);
    4164:	855e                	mv	a0,s7
    4166:	00001097          	auipc	ra,0x1
    416a:	236080e7          	jalr	566(ra) # 539c <close>
  unlink("sharedfd");
    416e:	00002517          	auipc	a0,0x2
    4172:	8a250513          	addi	a0,a0,-1886 # 5a10 <malloc+0x266>
    4176:	00001097          	auipc	ra,0x1
    417a:	24e080e7          	jalr	590(ra) # 53c4 <unlink>
  if(nc == N*SZ && np == N*SZ){
    417e:	6789                	lui	a5,0x2
    4180:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xbe>
    4184:	00f99763          	bne	s3,a5,4192 <sharedfd+0x192>
    4188:	6789                	lui	a5,0x2
    418a:	71078793          	addi	a5,a5,1808 # 2710 <sbrkarg+0xbe>
    418e:	02fa8063          	beq	s5,a5,41ae <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    4192:	85d2                	mv	a1,s4
    4194:	00003517          	auipc	a0,0x3
    4198:	4f450513          	addi	a0,a0,1268 # 7688 <malloc+0x1ede>
    419c:	00001097          	auipc	ra,0x1
    41a0:	550080e7          	jalr	1360(ra) # 56ec <printf>
    exit(1);
    41a4:	4505                	li	a0,1
    41a6:	00001097          	auipc	ra,0x1
    41aa:	1ce080e7          	jalr	462(ra) # 5374 <exit>
    exit(0);
    41ae:	4501                	li	a0,0
    41b0:	00001097          	auipc	ra,0x1
    41b4:	1c4080e7          	jalr	452(ra) # 5374 <exit>

00000000000041b8 <fourfiles>:
{
    41b8:	7171                	addi	sp,sp,-176
    41ba:	f506                	sd	ra,168(sp)
    41bc:	f122                	sd	s0,160(sp)
    41be:	ed26                	sd	s1,152(sp)
    41c0:	e94a                	sd	s2,144(sp)
    41c2:	e54e                	sd	s3,136(sp)
    41c4:	e152                	sd	s4,128(sp)
    41c6:	fcd6                	sd	s5,120(sp)
    41c8:	f8da                	sd	s6,112(sp)
    41ca:	f4de                	sd	s7,104(sp)
    41cc:	f0e2                	sd	s8,96(sp)
    41ce:	ece6                	sd	s9,88(sp)
    41d0:	e8ea                	sd	s10,80(sp)
    41d2:	e4ee                	sd	s11,72(sp)
    41d4:	1900                	addi	s0,sp,176
    41d6:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    41d8:	00001797          	auipc	a5,0x1
    41dc:	6b878793          	addi	a5,a5,1720 # 5890 <malloc+0xe6>
    41e0:	f6f43823          	sd	a5,-144(s0)
    41e4:	00001797          	auipc	a5,0x1
    41e8:	6b478793          	addi	a5,a5,1716 # 5898 <malloc+0xee>
    41ec:	f6f43c23          	sd	a5,-136(s0)
    41f0:	00001797          	auipc	a5,0x1
    41f4:	6b078793          	addi	a5,a5,1712 # 58a0 <malloc+0xf6>
    41f8:	f8f43023          	sd	a5,-128(s0)
    41fc:	00001797          	auipc	a5,0x1
    4200:	6ac78793          	addi	a5,a5,1708 # 58a8 <malloc+0xfe>
    4204:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4208:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    420c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    420e:	4481                	li	s1,0
    4210:	4a11                	li	s4,4
    fname = names[pi];
    4212:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4216:	854e                	mv	a0,s3
    4218:	00001097          	auipc	ra,0x1
    421c:	1ac080e7          	jalr	428(ra) # 53c4 <unlink>
    pid = fork();
    4220:	00001097          	auipc	ra,0x1
    4224:	14c080e7          	jalr	332(ra) # 536c <fork>
    if(pid < 0){
    4228:	04054563          	bltz	a0,4272 <fourfiles+0xba>
    if(pid == 0){
    422c:	c12d                	beqz	a0,428e <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    422e:	2485                	addiw	s1,s1,1
    4230:	0921                	addi	s2,s2,8
    4232:	ff4490e3          	bne	s1,s4,4212 <fourfiles+0x5a>
    4236:	4491                	li	s1,4
    wait(&xstatus);
    4238:	f6c40513          	addi	a0,s0,-148
    423c:	00001097          	auipc	ra,0x1
    4240:	140080e7          	jalr	320(ra) # 537c <wait>
    if(xstatus != 0)
    4244:	f6c42503          	lw	a0,-148(s0)
    4248:	ed69                	bnez	a0,4322 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    424a:	34fd                	addiw	s1,s1,-1
    424c:	f4f5                	bnez	s1,4238 <fourfiles+0x80>
    424e:	03000b13          	li	s6,48
    total = 0;
    4252:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4256:	00007a17          	auipc	s4,0x7
    425a:	4daa0a13          	addi	s4,s4,1242 # b730 <buf>
    425e:	00007a97          	auipc	s5,0x7
    4262:	4d3a8a93          	addi	s5,s5,1235 # b731 <buf+0x1>
    if(total != N*SZ){
    4266:	6d05                	lui	s10,0x1
    4268:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x2a>
  for(i = 0; i < NCHILD; i++){
    426c:	03400d93          	li	s11,52
    4270:	a23d                	j	439e <fourfiles+0x1e6>
      printf("fork failed\n", s);
    4272:	85e6                	mv	a1,s9
    4274:	00002517          	auipc	a0,0x2
    4278:	57c50513          	addi	a0,a0,1404 # 67f0 <malloc+0x1046>
    427c:	00001097          	auipc	ra,0x1
    4280:	470080e7          	jalr	1136(ra) # 56ec <printf>
      exit(1);
    4284:	4505                	li	a0,1
    4286:	00001097          	auipc	ra,0x1
    428a:	0ee080e7          	jalr	238(ra) # 5374 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    428e:	20200593          	li	a1,514
    4292:	854e                	mv	a0,s3
    4294:	00001097          	auipc	ra,0x1
    4298:	120080e7          	jalr	288(ra) # 53b4 <open>
    429c:	892a                	mv	s2,a0
      if(fd < 0){
    429e:	04054763          	bltz	a0,42ec <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    42a2:	1f400613          	li	a2,500
    42a6:	0304859b          	addiw	a1,s1,48
    42aa:	00007517          	auipc	a0,0x7
    42ae:	48650513          	addi	a0,a0,1158 # b730 <buf>
    42b2:	00001097          	auipc	ra,0x1
    42b6:	ebe080e7          	jalr	-322(ra) # 5170 <memset>
    42ba:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    42bc:	00007997          	auipc	s3,0x7
    42c0:	47498993          	addi	s3,s3,1140 # b730 <buf>
    42c4:	1f400613          	li	a2,500
    42c8:	85ce                	mv	a1,s3
    42ca:	854a                	mv	a0,s2
    42cc:	00001097          	auipc	ra,0x1
    42d0:	0c8080e7          	jalr	200(ra) # 5394 <write>
    42d4:	85aa                	mv	a1,a0
    42d6:	1f400793          	li	a5,500
    42da:	02f51763          	bne	a0,a5,4308 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    42de:	34fd                	addiw	s1,s1,-1
    42e0:	f0f5                	bnez	s1,42c4 <fourfiles+0x10c>
      exit(0);
    42e2:	4501                	li	a0,0
    42e4:	00001097          	auipc	ra,0x1
    42e8:	090080e7          	jalr	144(ra) # 5374 <exit>
        printf("create failed\n", s);
    42ec:	85e6                	mv	a1,s9
    42ee:	00003517          	auipc	a0,0x3
    42f2:	3b250513          	addi	a0,a0,946 # 76a0 <malloc+0x1ef6>
    42f6:	00001097          	auipc	ra,0x1
    42fa:	3f6080e7          	jalr	1014(ra) # 56ec <printf>
        exit(1);
    42fe:	4505                	li	a0,1
    4300:	00001097          	auipc	ra,0x1
    4304:	074080e7          	jalr	116(ra) # 5374 <exit>
          printf("write failed %d\n", n);
    4308:	00003517          	auipc	a0,0x3
    430c:	3a850513          	addi	a0,a0,936 # 76b0 <malloc+0x1f06>
    4310:	00001097          	auipc	ra,0x1
    4314:	3dc080e7          	jalr	988(ra) # 56ec <printf>
          exit(1);
    4318:	4505                	li	a0,1
    431a:	00001097          	auipc	ra,0x1
    431e:	05a080e7          	jalr	90(ra) # 5374 <exit>
      exit(xstatus);
    4322:	00001097          	auipc	ra,0x1
    4326:	052080e7          	jalr	82(ra) # 5374 <exit>
          printf("wrong char\n", s);
    432a:	85e6                	mv	a1,s9
    432c:	00003517          	auipc	a0,0x3
    4330:	39c50513          	addi	a0,a0,924 # 76c8 <malloc+0x1f1e>
    4334:	00001097          	auipc	ra,0x1
    4338:	3b8080e7          	jalr	952(ra) # 56ec <printf>
          exit(1);
    433c:	4505                	li	a0,1
    433e:	00001097          	auipc	ra,0x1
    4342:	036080e7          	jalr	54(ra) # 5374 <exit>
      total += n;
    4346:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    434a:	660d                	lui	a2,0x3
    434c:	85d2                	mv	a1,s4
    434e:	854e                	mv	a0,s3
    4350:	00001097          	auipc	ra,0x1
    4354:	03c080e7          	jalr	60(ra) # 538c <read>
    4358:	02a05363          	blez	a0,437e <fourfiles+0x1c6>
    435c:	00007797          	auipc	a5,0x7
    4360:	3d478793          	addi	a5,a5,980 # b730 <buf>
    4364:	fff5069b          	addiw	a3,a0,-1
    4368:	1682                	slli	a3,a3,0x20
    436a:	9281                	srli	a3,a3,0x20
    436c:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    436e:	0007c703          	lbu	a4,0(a5)
    4372:	fa971ce3          	bne	a4,s1,432a <fourfiles+0x172>
      for(j = 0; j < n; j++){
    4376:	0785                	addi	a5,a5,1
    4378:	fed79be3          	bne	a5,a3,436e <fourfiles+0x1b6>
    437c:	b7e9                	j	4346 <fourfiles+0x18e>
    close(fd);
    437e:	854e                	mv	a0,s3
    4380:	00001097          	auipc	ra,0x1
    4384:	01c080e7          	jalr	28(ra) # 539c <close>
    if(total != N*SZ){
    4388:	03a91963          	bne	s2,s10,43ba <fourfiles+0x202>
    unlink(fname);
    438c:	8562                	mv	a0,s8
    438e:	00001097          	auipc	ra,0x1
    4392:	036080e7          	jalr	54(ra) # 53c4 <unlink>
  for(i = 0; i < NCHILD; i++){
    4396:	0ba1                	addi	s7,s7,8
    4398:	2b05                	addiw	s6,s6,1
    439a:	03bb0e63          	beq	s6,s11,43d6 <fourfiles+0x21e>
    fname = names[i];
    439e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    43a2:	4581                	li	a1,0
    43a4:	8562                	mv	a0,s8
    43a6:	00001097          	auipc	ra,0x1
    43aa:	00e080e7          	jalr	14(ra) # 53b4 <open>
    43ae:	89aa                	mv	s3,a0
    total = 0;
    43b0:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    43b4:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    43b8:	bf49                	j	434a <fourfiles+0x192>
      printf("wrong length %d\n", total);
    43ba:	85ca                	mv	a1,s2
    43bc:	00003517          	auipc	a0,0x3
    43c0:	31c50513          	addi	a0,a0,796 # 76d8 <malloc+0x1f2e>
    43c4:	00001097          	auipc	ra,0x1
    43c8:	328080e7          	jalr	808(ra) # 56ec <printf>
      exit(1);
    43cc:	4505                	li	a0,1
    43ce:	00001097          	auipc	ra,0x1
    43d2:	fa6080e7          	jalr	-90(ra) # 5374 <exit>
}
    43d6:	70aa                	ld	ra,168(sp)
    43d8:	740a                	ld	s0,160(sp)
    43da:	64ea                	ld	s1,152(sp)
    43dc:	694a                	ld	s2,144(sp)
    43de:	69aa                	ld	s3,136(sp)
    43e0:	6a0a                	ld	s4,128(sp)
    43e2:	7ae6                	ld	s5,120(sp)
    43e4:	7b46                	ld	s6,112(sp)
    43e6:	7ba6                	ld	s7,104(sp)
    43e8:	7c06                	ld	s8,96(sp)
    43ea:	6ce6                	ld	s9,88(sp)
    43ec:	6d46                	ld	s10,80(sp)
    43ee:	6da6                	ld	s11,72(sp)
    43f0:	614d                	addi	sp,sp,176
    43f2:	8082                	ret

00000000000043f4 <concreate>:
{
    43f4:	7135                	addi	sp,sp,-160
    43f6:	ed06                	sd	ra,152(sp)
    43f8:	e922                	sd	s0,144(sp)
    43fa:	e526                	sd	s1,136(sp)
    43fc:	e14a                	sd	s2,128(sp)
    43fe:	fcce                	sd	s3,120(sp)
    4400:	f8d2                	sd	s4,112(sp)
    4402:	f4d6                	sd	s5,104(sp)
    4404:	f0da                	sd	s6,96(sp)
    4406:	ecde                	sd	s7,88(sp)
    4408:	1100                	addi	s0,sp,160
    440a:	89aa                	mv	s3,a0
  file[0] = 'C';
    440c:	04300793          	li	a5,67
    4410:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4414:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4418:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    441a:	4b0d                	li	s6,3
    441c:	4a85                	li	s5,1
      link("C0", file);
    441e:	00003b97          	auipc	s7,0x3
    4422:	2d2b8b93          	addi	s7,s7,722 # 76f0 <malloc+0x1f46>
  for(i = 0; i < N; i++){
    4426:	02800a13          	li	s4,40
    442a:	acc1                	j	46fa <concreate+0x306>
      link("C0", file);
    442c:	fa840593          	addi	a1,s0,-88
    4430:	855e                	mv	a0,s7
    4432:	00001097          	auipc	ra,0x1
    4436:	fa2080e7          	jalr	-94(ra) # 53d4 <link>
    if(pid == 0) {
    443a:	a45d                	j	46e0 <concreate+0x2ec>
    } else if(pid == 0 && (i % 5) == 1){
    443c:	4795                	li	a5,5
    443e:	02f9693b          	remw	s2,s2,a5
    4442:	4785                	li	a5,1
    4444:	02f90b63          	beq	s2,a5,447a <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4448:	20200593          	li	a1,514
    444c:	fa840513          	addi	a0,s0,-88
    4450:	00001097          	auipc	ra,0x1
    4454:	f64080e7          	jalr	-156(ra) # 53b4 <open>
      if(fd < 0){
    4458:	26055b63          	bgez	a0,46ce <concreate+0x2da>
        printf("concreate create %s failed\n", file);
    445c:	fa840593          	addi	a1,s0,-88
    4460:	00003517          	auipc	a0,0x3
    4464:	29850513          	addi	a0,a0,664 # 76f8 <malloc+0x1f4e>
    4468:	00001097          	auipc	ra,0x1
    446c:	284080e7          	jalr	644(ra) # 56ec <printf>
        exit(1);
    4470:	4505                	li	a0,1
    4472:	00001097          	auipc	ra,0x1
    4476:	f02080e7          	jalr	-254(ra) # 5374 <exit>
      link("C0", file);
    447a:	fa840593          	addi	a1,s0,-88
    447e:	00003517          	auipc	a0,0x3
    4482:	27250513          	addi	a0,a0,626 # 76f0 <malloc+0x1f46>
    4486:	00001097          	auipc	ra,0x1
    448a:	f4e080e7          	jalr	-178(ra) # 53d4 <link>
      exit(0);
    448e:	4501                	li	a0,0
    4490:	00001097          	auipc	ra,0x1
    4494:	ee4080e7          	jalr	-284(ra) # 5374 <exit>
        exit(1);
    4498:	4505                	li	a0,1
    449a:	00001097          	auipc	ra,0x1
    449e:	eda080e7          	jalr	-294(ra) # 5374 <exit>
  memset(fa, 0, sizeof(fa));
    44a2:	02800613          	li	a2,40
    44a6:	4581                	li	a1,0
    44a8:	f8040513          	addi	a0,s0,-128
    44ac:	00001097          	auipc	ra,0x1
    44b0:	cc4080e7          	jalr	-828(ra) # 5170 <memset>
  fd = open(".", 0);
    44b4:	4581                	li	a1,0
    44b6:	00002517          	auipc	a0,0x2
    44ba:	daa50513          	addi	a0,a0,-598 # 6260 <malloc+0xab6>
    44be:	00001097          	auipc	ra,0x1
    44c2:	ef6080e7          	jalr	-266(ra) # 53b4 <open>
    44c6:	892a                	mv	s2,a0
  n = 0;
    44c8:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    44ca:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    44ce:	02700b13          	li	s6,39
      fa[i] = 1;
    44d2:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    44d4:	a03d                	j	4502 <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    44d6:	f7240613          	addi	a2,s0,-142
    44da:	85ce                	mv	a1,s3
    44dc:	00003517          	auipc	a0,0x3
    44e0:	23c50513          	addi	a0,a0,572 # 7718 <malloc+0x1f6e>
    44e4:	00001097          	auipc	ra,0x1
    44e8:	208080e7          	jalr	520(ra) # 56ec <printf>
        exit(1);
    44ec:	4505                	li	a0,1
    44ee:	00001097          	auipc	ra,0x1
    44f2:	e86080e7          	jalr	-378(ra) # 5374 <exit>
      fa[i] = 1;
    44f6:	fb040793          	addi	a5,s0,-80
    44fa:	973e                	add	a4,a4,a5
    44fc:	fd770823          	sb	s7,-48(a4)
      n++;
    4500:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    4502:	4641                	li	a2,16
    4504:	f7040593          	addi	a1,s0,-144
    4508:	854a                	mv	a0,s2
    450a:	00001097          	auipc	ra,0x1
    450e:	e82080e7          	jalr	-382(ra) # 538c <read>
    4512:	04a05a63          	blez	a0,4566 <concreate+0x172>
    if(de.inum == 0)
    4516:	f7045783          	lhu	a5,-144(s0)
    451a:	d7e5                	beqz	a5,4502 <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    451c:	f7244783          	lbu	a5,-142(s0)
    4520:	ff4791e3          	bne	a5,s4,4502 <concreate+0x10e>
    4524:	f7444783          	lbu	a5,-140(s0)
    4528:	ffe9                	bnez	a5,4502 <concreate+0x10e>
      i = de.name[1] - '0';
    452a:	f7344783          	lbu	a5,-141(s0)
    452e:	fd07879b          	addiw	a5,a5,-48
    4532:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4536:	faeb60e3          	bltu	s6,a4,44d6 <concreate+0xe2>
      if(fa[i]){
    453a:	fb040793          	addi	a5,s0,-80
    453e:	97ba                	add	a5,a5,a4
    4540:	fd07c783          	lbu	a5,-48(a5)
    4544:	dbcd                	beqz	a5,44f6 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4546:	f7240613          	addi	a2,s0,-142
    454a:	85ce                	mv	a1,s3
    454c:	00003517          	auipc	a0,0x3
    4550:	1ec50513          	addi	a0,a0,492 # 7738 <malloc+0x1f8e>
    4554:	00001097          	auipc	ra,0x1
    4558:	198080e7          	jalr	408(ra) # 56ec <printf>
        exit(1);
    455c:	4505                	li	a0,1
    455e:	00001097          	auipc	ra,0x1
    4562:	e16080e7          	jalr	-490(ra) # 5374 <exit>
  close(fd);
    4566:	854a                	mv	a0,s2
    4568:	00001097          	auipc	ra,0x1
    456c:	e34080e7          	jalr	-460(ra) # 539c <close>
  if(n != N){
    4570:	02800793          	li	a5,40
    4574:	00fa9763          	bne	s5,a5,4582 <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    4578:	4a8d                	li	s5,3
    457a:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    457c:	02800a13          	li	s4,40
    4580:	a8c9                	j	4652 <concreate+0x25e>
    printf("%s: concreate not enough files in directory listing\n", s);
    4582:	85ce                	mv	a1,s3
    4584:	00003517          	auipc	a0,0x3
    4588:	1dc50513          	addi	a0,a0,476 # 7760 <malloc+0x1fb6>
    458c:	00001097          	auipc	ra,0x1
    4590:	160080e7          	jalr	352(ra) # 56ec <printf>
    exit(1);
    4594:	4505                	li	a0,1
    4596:	00001097          	auipc	ra,0x1
    459a:	dde080e7          	jalr	-546(ra) # 5374 <exit>
      printf("%s: fork failed\n", s);
    459e:	85ce                	mv	a1,s3
    45a0:	00002517          	auipc	a0,0x2
    45a4:	e6050513          	addi	a0,a0,-416 # 6400 <malloc+0xc56>
    45a8:	00001097          	auipc	ra,0x1
    45ac:	144080e7          	jalr	324(ra) # 56ec <printf>
      exit(1);
    45b0:	4505                	li	a0,1
    45b2:	00001097          	auipc	ra,0x1
    45b6:	dc2080e7          	jalr	-574(ra) # 5374 <exit>
      close(open(file, 0));
    45ba:	4581                	li	a1,0
    45bc:	fa840513          	addi	a0,s0,-88
    45c0:	00001097          	auipc	ra,0x1
    45c4:	df4080e7          	jalr	-524(ra) # 53b4 <open>
    45c8:	00001097          	auipc	ra,0x1
    45cc:	dd4080e7          	jalr	-556(ra) # 539c <close>
      close(open(file, 0));
    45d0:	4581                	li	a1,0
    45d2:	fa840513          	addi	a0,s0,-88
    45d6:	00001097          	auipc	ra,0x1
    45da:	dde080e7          	jalr	-546(ra) # 53b4 <open>
    45de:	00001097          	auipc	ra,0x1
    45e2:	dbe080e7          	jalr	-578(ra) # 539c <close>
      close(open(file, 0));
    45e6:	4581                	li	a1,0
    45e8:	fa840513          	addi	a0,s0,-88
    45ec:	00001097          	auipc	ra,0x1
    45f0:	dc8080e7          	jalr	-568(ra) # 53b4 <open>
    45f4:	00001097          	auipc	ra,0x1
    45f8:	da8080e7          	jalr	-600(ra) # 539c <close>
      close(open(file, 0));
    45fc:	4581                	li	a1,0
    45fe:	fa840513          	addi	a0,s0,-88
    4602:	00001097          	auipc	ra,0x1
    4606:	db2080e7          	jalr	-590(ra) # 53b4 <open>
    460a:	00001097          	auipc	ra,0x1
    460e:	d92080e7          	jalr	-622(ra) # 539c <close>
      close(open(file, 0));
    4612:	4581                	li	a1,0
    4614:	fa840513          	addi	a0,s0,-88
    4618:	00001097          	auipc	ra,0x1
    461c:	d9c080e7          	jalr	-612(ra) # 53b4 <open>
    4620:	00001097          	auipc	ra,0x1
    4624:	d7c080e7          	jalr	-644(ra) # 539c <close>
      close(open(file, 0));
    4628:	4581                	li	a1,0
    462a:	fa840513          	addi	a0,s0,-88
    462e:	00001097          	auipc	ra,0x1
    4632:	d86080e7          	jalr	-634(ra) # 53b4 <open>
    4636:	00001097          	auipc	ra,0x1
    463a:	d66080e7          	jalr	-666(ra) # 539c <close>
    if(pid == 0)
    463e:	08090363          	beqz	s2,46c4 <concreate+0x2d0>
      wait(0);
    4642:	4501                	li	a0,0
    4644:	00001097          	auipc	ra,0x1
    4648:	d38080e7          	jalr	-712(ra) # 537c <wait>
  for(i = 0; i < N; i++){
    464c:	2485                	addiw	s1,s1,1
    464e:	0f448563          	beq	s1,s4,4738 <concreate+0x344>
    file[1] = '0' + i;
    4652:	0304879b          	addiw	a5,s1,48
    4656:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    465a:	00001097          	auipc	ra,0x1
    465e:	d12080e7          	jalr	-750(ra) # 536c <fork>
    4662:	892a                	mv	s2,a0
    if(pid < 0){
    4664:	f2054de3          	bltz	a0,459e <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    4668:	0354e73b          	remw	a4,s1,s5
    466c:	00a767b3          	or	a5,a4,a0
    4670:	2781                	sext.w	a5,a5
    4672:	d7a1                	beqz	a5,45ba <concreate+0x1c6>
    4674:	01671363          	bne	a4,s6,467a <concreate+0x286>
       ((i % 3) == 1 && pid != 0)){
    4678:	f129                	bnez	a0,45ba <concreate+0x1c6>
      unlink(file);
    467a:	fa840513          	addi	a0,s0,-88
    467e:	00001097          	auipc	ra,0x1
    4682:	d46080e7          	jalr	-698(ra) # 53c4 <unlink>
      unlink(file);
    4686:	fa840513          	addi	a0,s0,-88
    468a:	00001097          	auipc	ra,0x1
    468e:	d3a080e7          	jalr	-710(ra) # 53c4 <unlink>
      unlink(file);
    4692:	fa840513          	addi	a0,s0,-88
    4696:	00001097          	auipc	ra,0x1
    469a:	d2e080e7          	jalr	-722(ra) # 53c4 <unlink>
      unlink(file);
    469e:	fa840513          	addi	a0,s0,-88
    46a2:	00001097          	auipc	ra,0x1
    46a6:	d22080e7          	jalr	-734(ra) # 53c4 <unlink>
      unlink(file);
    46aa:	fa840513          	addi	a0,s0,-88
    46ae:	00001097          	auipc	ra,0x1
    46b2:	d16080e7          	jalr	-746(ra) # 53c4 <unlink>
      unlink(file);
    46b6:	fa840513          	addi	a0,s0,-88
    46ba:	00001097          	auipc	ra,0x1
    46be:	d0a080e7          	jalr	-758(ra) # 53c4 <unlink>
    46c2:	bfb5                	j	463e <concreate+0x24a>
      exit(0);
    46c4:	4501                	li	a0,0
    46c6:	00001097          	auipc	ra,0x1
    46ca:	cae080e7          	jalr	-850(ra) # 5374 <exit>
      close(fd);
    46ce:	00001097          	auipc	ra,0x1
    46d2:	cce080e7          	jalr	-818(ra) # 539c <close>
    if(pid == 0) {
    46d6:	bb65                	j	448e <concreate+0x9a>
      close(fd);
    46d8:	00001097          	auipc	ra,0x1
    46dc:	cc4080e7          	jalr	-828(ra) # 539c <close>
      wait(&xstatus);
    46e0:	f6c40513          	addi	a0,s0,-148
    46e4:	00001097          	auipc	ra,0x1
    46e8:	c98080e7          	jalr	-872(ra) # 537c <wait>
      if(xstatus != 0)
    46ec:	f6c42483          	lw	s1,-148(s0)
    46f0:	da0494e3          	bnez	s1,4498 <concreate+0xa4>
  for(i = 0; i < N; i++){
    46f4:	2905                	addiw	s2,s2,1
    46f6:	db4906e3          	beq	s2,s4,44a2 <concreate+0xae>
    file[1] = '0' + i;
    46fa:	0309079b          	addiw	a5,s2,48
    46fe:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4702:	fa840513          	addi	a0,s0,-88
    4706:	00001097          	auipc	ra,0x1
    470a:	cbe080e7          	jalr	-834(ra) # 53c4 <unlink>
    pid = fork();
    470e:	00001097          	auipc	ra,0x1
    4712:	c5e080e7          	jalr	-930(ra) # 536c <fork>
    if(pid && (i % 3) == 1){
    4716:	d20503e3          	beqz	a0,443c <concreate+0x48>
    471a:	036967bb          	remw	a5,s2,s6
    471e:	d15787e3          	beq	a5,s5,442c <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    4722:	20200593          	li	a1,514
    4726:	fa840513          	addi	a0,s0,-88
    472a:	00001097          	auipc	ra,0x1
    472e:	c8a080e7          	jalr	-886(ra) # 53b4 <open>
      if(fd < 0){
    4732:	fa0553e3          	bgez	a0,46d8 <concreate+0x2e4>
    4736:	b31d                	j	445c <concreate+0x68>
}
    4738:	60ea                	ld	ra,152(sp)
    473a:	644a                	ld	s0,144(sp)
    473c:	64aa                	ld	s1,136(sp)
    473e:	690a                	ld	s2,128(sp)
    4740:	79e6                	ld	s3,120(sp)
    4742:	7a46                	ld	s4,112(sp)
    4744:	7aa6                	ld	s5,104(sp)
    4746:	7b06                	ld	s6,96(sp)
    4748:	6be6                	ld	s7,88(sp)
    474a:	610d                	addi	sp,sp,160
    474c:	8082                	ret

000000000000474e <bigfile>:
{
    474e:	7139                	addi	sp,sp,-64
    4750:	fc06                	sd	ra,56(sp)
    4752:	f822                	sd	s0,48(sp)
    4754:	f426                	sd	s1,40(sp)
    4756:	f04a                	sd	s2,32(sp)
    4758:	ec4e                	sd	s3,24(sp)
    475a:	e852                	sd	s4,16(sp)
    475c:	e456                	sd	s5,8(sp)
    475e:	0080                	addi	s0,sp,64
    4760:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    4762:	00003517          	auipc	a0,0x3
    4766:	03650513          	addi	a0,a0,54 # 7798 <malloc+0x1fee>
    476a:	00001097          	auipc	ra,0x1
    476e:	c5a080e7          	jalr	-934(ra) # 53c4 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4772:	20200593          	li	a1,514
    4776:	00003517          	auipc	a0,0x3
    477a:	02250513          	addi	a0,a0,34 # 7798 <malloc+0x1fee>
    477e:	00001097          	auipc	ra,0x1
    4782:	c36080e7          	jalr	-970(ra) # 53b4 <open>
    4786:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4788:	4481                	li	s1,0
    memset(buf, i, SZ);
    478a:	00007917          	auipc	s2,0x7
    478e:	fa690913          	addi	s2,s2,-90 # b730 <buf>
  for(i = 0; i < N; i++){
    4792:	4a51                	li	s4,20
  if(fd < 0){
    4794:	0a054063          	bltz	a0,4834 <bigfile+0xe6>
    memset(buf, i, SZ);
    4798:	25800613          	li	a2,600
    479c:	85a6                	mv	a1,s1
    479e:	854a                	mv	a0,s2
    47a0:	00001097          	auipc	ra,0x1
    47a4:	9d0080e7          	jalr	-1584(ra) # 5170 <memset>
    if(write(fd, buf, SZ) != SZ){
    47a8:	25800613          	li	a2,600
    47ac:	85ca                	mv	a1,s2
    47ae:	854e                	mv	a0,s3
    47b0:	00001097          	auipc	ra,0x1
    47b4:	be4080e7          	jalr	-1052(ra) # 5394 <write>
    47b8:	25800793          	li	a5,600
    47bc:	08f51a63          	bne	a0,a5,4850 <bigfile+0x102>
  for(i = 0; i < N; i++){
    47c0:	2485                	addiw	s1,s1,1
    47c2:	fd449be3          	bne	s1,s4,4798 <bigfile+0x4a>
  close(fd);
    47c6:	854e                	mv	a0,s3
    47c8:	00001097          	auipc	ra,0x1
    47cc:	bd4080e7          	jalr	-1068(ra) # 539c <close>
  fd = open("bigfile.dat", 0);
    47d0:	4581                	li	a1,0
    47d2:	00003517          	auipc	a0,0x3
    47d6:	fc650513          	addi	a0,a0,-58 # 7798 <malloc+0x1fee>
    47da:	00001097          	auipc	ra,0x1
    47de:	bda080e7          	jalr	-1062(ra) # 53b4 <open>
    47e2:	8a2a                	mv	s4,a0
  total = 0;
    47e4:	4981                	li	s3,0
  for(i = 0; ; i++){
    47e6:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    47e8:	00007917          	auipc	s2,0x7
    47ec:	f4890913          	addi	s2,s2,-184 # b730 <buf>
  if(fd < 0){
    47f0:	06054e63          	bltz	a0,486c <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    47f4:	12c00613          	li	a2,300
    47f8:	85ca                	mv	a1,s2
    47fa:	8552                	mv	a0,s4
    47fc:	00001097          	auipc	ra,0x1
    4800:	b90080e7          	jalr	-1136(ra) # 538c <read>
    if(cc < 0){
    4804:	08054263          	bltz	a0,4888 <bigfile+0x13a>
    if(cc == 0)
    4808:	c971                	beqz	a0,48dc <bigfile+0x18e>
    if(cc != SZ/2){
    480a:	12c00793          	li	a5,300
    480e:	08f51b63          	bne	a0,a5,48a4 <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4812:	01f4d79b          	srliw	a5,s1,0x1f
    4816:	9fa5                	addw	a5,a5,s1
    4818:	4017d79b          	sraiw	a5,a5,0x1
    481c:	00094703          	lbu	a4,0(s2)
    4820:	0af71063          	bne	a4,a5,48c0 <bigfile+0x172>
    4824:	12b94703          	lbu	a4,299(s2)
    4828:	08f71c63          	bne	a4,a5,48c0 <bigfile+0x172>
    total += cc;
    482c:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    4830:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4832:	b7c9                	j	47f4 <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    4834:	85d6                	mv	a1,s5
    4836:	00003517          	auipc	a0,0x3
    483a:	f7250513          	addi	a0,a0,-142 # 77a8 <malloc+0x1ffe>
    483e:	00001097          	auipc	ra,0x1
    4842:	eae080e7          	jalr	-338(ra) # 56ec <printf>
    exit(1);
    4846:	4505                	li	a0,1
    4848:	00001097          	auipc	ra,0x1
    484c:	b2c080e7          	jalr	-1236(ra) # 5374 <exit>
      printf("%s: write bigfile failed\n", s);
    4850:	85d6                	mv	a1,s5
    4852:	00003517          	auipc	a0,0x3
    4856:	f7650513          	addi	a0,a0,-138 # 77c8 <malloc+0x201e>
    485a:	00001097          	auipc	ra,0x1
    485e:	e92080e7          	jalr	-366(ra) # 56ec <printf>
      exit(1);
    4862:	4505                	li	a0,1
    4864:	00001097          	auipc	ra,0x1
    4868:	b10080e7          	jalr	-1264(ra) # 5374 <exit>
    printf("%s: cannot open bigfile\n", s);
    486c:	85d6                	mv	a1,s5
    486e:	00003517          	auipc	a0,0x3
    4872:	f7a50513          	addi	a0,a0,-134 # 77e8 <malloc+0x203e>
    4876:	00001097          	auipc	ra,0x1
    487a:	e76080e7          	jalr	-394(ra) # 56ec <printf>
    exit(1);
    487e:	4505                	li	a0,1
    4880:	00001097          	auipc	ra,0x1
    4884:	af4080e7          	jalr	-1292(ra) # 5374 <exit>
      printf("%s: read bigfile failed\n", s);
    4888:	85d6                	mv	a1,s5
    488a:	00003517          	auipc	a0,0x3
    488e:	f7e50513          	addi	a0,a0,-130 # 7808 <malloc+0x205e>
    4892:	00001097          	auipc	ra,0x1
    4896:	e5a080e7          	jalr	-422(ra) # 56ec <printf>
      exit(1);
    489a:	4505                	li	a0,1
    489c:	00001097          	auipc	ra,0x1
    48a0:	ad8080e7          	jalr	-1320(ra) # 5374 <exit>
      printf("%s: short read bigfile\n", s);
    48a4:	85d6                	mv	a1,s5
    48a6:	00003517          	auipc	a0,0x3
    48aa:	f8250513          	addi	a0,a0,-126 # 7828 <malloc+0x207e>
    48ae:	00001097          	auipc	ra,0x1
    48b2:	e3e080e7          	jalr	-450(ra) # 56ec <printf>
      exit(1);
    48b6:	4505                	li	a0,1
    48b8:	00001097          	auipc	ra,0x1
    48bc:	abc080e7          	jalr	-1348(ra) # 5374 <exit>
      printf("%s: read bigfile wrong data\n", s);
    48c0:	85d6                	mv	a1,s5
    48c2:	00003517          	auipc	a0,0x3
    48c6:	f7e50513          	addi	a0,a0,-130 # 7840 <malloc+0x2096>
    48ca:	00001097          	auipc	ra,0x1
    48ce:	e22080e7          	jalr	-478(ra) # 56ec <printf>
      exit(1);
    48d2:	4505                	li	a0,1
    48d4:	00001097          	auipc	ra,0x1
    48d8:	aa0080e7          	jalr	-1376(ra) # 5374 <exit>
  close(fd);
    48dc:	8552                	mv	a0,s4
    48de:	00001097          	auipc	ra,0x1
    48e2:	abe080e7          	jalr	-1346(ra) # 539c <close>
  if(total != N*SZ){
    48e6:	678d                	lui	a5,0x3
    48e8:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x206>
    48ec:	02f99363          	bne	s3,a5,4912 <bigfile+0x1c4>
  unlink("bigfile.dat");
    48f0:	00003517          	auipc	a0,0x3
    48f4:	ea850513          	addi	a0,a0,-344 # 7798 <malloc+0x1fee>
    48f8:	00001097          	auipc	ra,0x1
    48fc:	acc080e7          	jalr	-1332(ra) # 53c4 <unlink>
}
    4900:	70e2                	ld	ra,56(sp)
    4902:	7442                	ld	s0,48(sp)
    4904:	74a2                	ld	s1,40(sp)
    4906:	7902                	ld	s2,32(sp)
    4908:	69e2                	ld	s3,24(sp)
    490a:	6a42                	ld	s4,16(sp)
    490c:	6aa2                	ld	s5,8(sp)
    490e:	6121                	addi	sp,sp,64
    4910:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4912:	85d6                	mv	a1,s5
    4914:	00003517          	auipc	a0,0x3
    4918:	f4c50513          	addi	a0,a0,-180 # 7860 <malloc+0x20b6>
    491c:	00001097          	auipc	ra,0x1
    4920:	dd0080e7          	jalr	-560(ra) # 56ec <printf>
    exit(1);
    4924:	4505                	li	a0,1
    4926:	00001097          	auipc	ra,0x1
    492a:	a4e080e7          	jalr	-1458(ra) # 5374 <exit>

000000000000492e <dirtest>:
{
    492e:	1101                	addi	sp,sp,-32
    4930:	ec06                	sd	ra,24(sp)
    4932:	e822                	sd	s0,16(sp)
    4934:	e426                	sd	s1,8(sp)
    4936:	1000                	addi	s0,sp,32
    4938:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    493a:	00003517          	auipc	a0,0x3
    493e:	f4650513          	addi	a0,a0,-186 # 7880 <malloc+0x20d6>
    4942:	00001097          	auipc	ra,0x1
    4946:	daa080e7          	jalr	-598(ra) # 56ec <printf>
  if(mkdir("dir0") < 0){
    494a:	00003517          	auipc	a0,0x3
    494e:	f4650513          	addi	a0,a0,-186 # 7890 <malloc+0x20e6>
    4952:	00001097          	auipc	ra,0x1
    4956:	a8a080e7          	jalr	-1398(ra) # 53dc <mkdir>
    495a:	04054d63          	bltz	a0,49b4 <dirtest+0x86>
  if(chdir("dir0") < 0){
    495e:	00003517          	auipc	a0,0x3
    4962:	f3250513          	addi	a0,a0,-206 # 7890 <malloc+0x20e6>
    4966:	00001097          	auipc	ra,0x1
    496a:	a7e080e7          	jalr	-1410(ra) # 53e4 <chdir>
    496e:	06054163          	bltz	a0,49d0 <dirtest+0xa2>
  if(chdir("..") < 0){
    4972:	00003517          	auipc	a0,0x3
    4976:	97650513          	addi	a0,a0,-1674 # 72e8 <malloc+0x1b3e>
    497a:	00001097          	auipc	ra,0x1
    497e:	a6a080e7          	jalr	-1430(ra) # 53e4 <chdir>
    4982:	06054563          	bltz	a0,49ec <dirtest+0xbe>
  if(unlink("dir0") < 0){
    4986:	00003517          	auipc	a0,0x3
    498a:	f0a50513          	addi	a0,a0,-246 # 7890 <malloc+0x20e6>
    498e:	00001097          	auipc	ra,0x1
    4992:	a36080e7          	jalr	-1482(ra) # 53c4 <unlink>
    4996:	06054963          	bltz	a0,4a08 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    499a:	00003517          	auipc	a0,0x3
    499e:	f4650513          	addi	a0,a0,-186 # 78e0 <malloc+0x2136>
    49a2:	00001097          	auipc	ra,0x1
    49a6:	d4a080e7          	jalr	-694(ra) # 56ec <printf>
}
    49aa:	60e2                	ld	ra,24(sp)
    49ac:	6442                	ld	s0,16(sp)
    49ae:	64a2                	ld	s1,8(sp)
    49b0:	6105                	addi	sp,sp,32
    49b2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    49b4:	85a6                	mv	a1,s1
    49b6:	00002517          	auipc	a0,0x2
    49ba:	2d250513          	addi	a0,a0,722 # 6c88 <malloc+0x14de>
    49be:	00001097          	auipc	ra,0x1
    49c2:	d2e080e7          	jalr	-722(ra) # 56ec <printf>
    exit(1);
    49c6:	4505                	li	a0,1
    49c8:	00001097          	auipc	ra,0x1
    49cc:	9ac080e7          	jalr	-1620(ra) # 5374 <exit>
    printf("%s: chdir dir0 failed\n", s);
    49d0:	85a6                	mv	a1,s1
    49d2:	00003517          	auipc	a0,0x3
    49d6:	ec650513          	addi	a0,a0,-314 # 7898 <malloc+0x20ee>
    49da:	00001097          	auipc	ra,0x1
    49de:	d12080e7          	jalr	-750(ra) # 56ec <printf>
    exit(1);
    49e2:	4505                	li	a0,1
    49e4:	00001097          	auipc	ra,0x1
    49e8:	990080e7          	jalr	-1648(ra) # 5374 <exit>
    printf("%s: chdir .. failed\n", s);
    49ec:	85a6                	mv	a1,s1
    49ee:	00003517          	auipc	a0,0x3
    49f2:	ec250513          	addi	a0,a0,-318 # 78b0 <malloc+0x2106>
    49f6:	00001097          	auipc	ra,0x1
    49fa:	cf6080e7          	jalr	-778(ra) # 56ec <printf>
    exit(1);
    49fe:	4505                	li	a0,1
    4a00:	00001097          	auipc	ra,0x1
    4a04:	974080e7          	jalr	-1676(ra) # 5374 <exit>
    printf("%s: unlink dir0 failed\n", s);
    4a08:	85a6                	mv	a1,s1
    4a0a:	00003517          	auipc	a0,0x3
    4a0e:	ebe50513          	addi	a0,a0,-322 # 78c8 <malloc+0x211e>
    4a12:	00001097          	auipc	ra,0x1
    4a16:	cda080e7          	jalr	-806(ra) # 56ec <printf>
    exit(1);
    4a1a:	4505                	li	a0,1
    4a1c:	00001097          	auipc	ra,0x1
    4a20:	958080e7          	jalr	-1704(ra) # 5374 <exit>

0000000000004a24 <fsfull>:
{
    4a24:	7171                	addi	sp,sp,-176
    4a26:	f506                	sd	ra,168(sp)
    4a28:	f122                	sd	s0,160(sp)
    4a2a:	ed26                	sd	s1,152(sp)
    4a2c:	e94a                	sd	s2,144(sp)
    4a2e:	e54e                	sd	s3,136(sp)
    4a30:	e152                	sd	s4,128(sp)
    4a32:	fcd6                	sd	s5,120(sp)
    4a34:	f8da                	sd	s6,112(sp)
    4a36:	f4de                	sd	s7,104(sp)
    4a38:	f0e2                	sd	s8,96(sp)
    4a3a:	ece6                	sd	s9,88(sp)
    4a3c:	e8ea                	sd	s10,80(sp)
    4a3e:	e4ee                	sd	s11,72(sp)
    4a40:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4a42:	00003517          	auipc	a0,0x3
    4a46:	eb650513          	addi	a0,a0,-330 # 78f8 <malloc+0x214e>
    4a4a:	00001097          	auipc	ra,0x1
    4a4e:	ca2080e7          	jalr	-862(ra) # 56ec <printf>
  for(nfiles = 0; ; nfiles++){
    4a52:	4481                	li	s1,0
    name[0] = 'f';
    4a54:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4a58:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4a5c:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4a60:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    4a62:	00003c97          	auipc	s9,0x3
    4a66:	ea6c8c93          	addi	s9,s9,-346 # 7908 <malloc+0x215e>
    int total = 0;
    4a6a:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    4a6c:	00007a17          	auipc	s4,0x7
    4a70:	cc4a0a13          	addi	s4,s4,-828 # b730 <buf>
    name[0] = 'f';
    4a74:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4a78:	0384c7bb          	divw	a5,s1,s8
    4a7c:	0307879b          	addiw	a5,a5,48
    4a80:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4a84:	0384e7bb          	remw	a5,s1,s8
    4a88:	0377c7bb          	divw	a5,a5,s7
    4a8c:	0307879b          	addiw	a5,a5,48
    4a90:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4a94:	0374e7bb          	remw	a5,s1,s7
    4a98:	0367c7bb          	divw	a5,a5,s6
    4a9c:	0307879b          	addiw	a5,a5,48
    4aa0:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4aa4:	0364e7bb          	remw	a5,s1,s6
    4aa8:	0307879b          	addiw	a5,a5,48
    4aac:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4ab0:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    4ab4:	f5040593          	addi	a1,s0,-176
    4ab8:	8566                	mv	a0,s9
    4aba:	00001097          	auipc	ra,0x1
    4abe:	c32080e7          	jalr	-974(ra) # 56ec <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    4ac2:	20200593          	li	a1,514
    4ac6:	f5040513          	addi	a0,s0,-176
    4aca:	00001097          	auipc	ra,0x1
    4ace:	8ea080e7          	jalr	-1814(ra) # 53b4 <open>
    4ad2:	892a                	mv	s2,a0
    if(fd < 0){
    4ad4:	0a055663          	bgez	a0,4b80 <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    4ad8:	f5040593          	addi	a1,s0,-176
    4adc:	00003517          	auipc	a0,0x3
    4ae0:	e3c50513          	addi	a0,a0,-452 # 7918 <malloc+0x216e>
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	c08080e7          	jalr	-1016(ra) # 56ec <printf>
  while(nfiles >= 0){
    4aec:	0604c363          	bltz	s1,4b52 <fsfull+0x12e>
    name[0] = 'f';
    4af0:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    4af4:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4af8:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    4afc:	4929                	li	s2,10
  while(nfiles >= 0){
    4afe:	5afd                	li	s5,-1
    name[0] = 'f';
    4b00:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4b04:	0344c7bb          	divw	a5,s1,s4
    4b08:	0307879b          	addiw	a5,a5,48
    4b0c:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4b10:	0344e7bb          	remw	a5,s1,s4
    4b14:	0337c7bb          	divw	a5,a5,s3
    4b18:	0307879b          	addiw	a5,a5,48
    4b1c:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4b20:	0334e7bb          	remw	a5,s1,s3
    4b24:	0327c7bb          	divw	a5,a5,s2
    4b28:	0307879b          	addiw	a5,a5,48
    4b2c:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4b30:	0324e7bb          	remw	a5,s1,s2
    4b34:	0307879b          	addiw	a5,a5,48
    4b38:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4b3c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4b40:	f5040513          	addi	a0,s0,-176
    4b44:	00001097          	auipc	ra,0x1
    4b48:	880080e7          	jalr	-1920(ra) # 53c4 <unlink>
    nfiles--;
    4b4c:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4b4e:	fb5499e3          	bne	s1,s5,4b00 <fsfull+0xdc>
  printf("fsfull test finished\n");
    4b52:	00003517          	auipc	a0,0x3
    4b56:	df650513          	addi	a0,a0,-522 # 7948 <malloc+0x219e>
    4b5a:	00001097          	auipc	ra,0x1
    4b5e:	b92080e7          	jalr	-1134(ra) # 56ec <printf>
}
    4b62:	70aa                	ld	ra,168(sp)
    4b64:	740a                	ld	s0,160(sp)
    4b66:	64ea                	ld	s1,152(sp)
    4b68:	694a                	ld	s2,144(sp)
    4b6a:	69aa                	ld	s3,136(sp)
    4b6c:	6a0a                	ld	s4,128(sp)
    4b6e:	7ae6                	ld	s5,120(sp)
    4b70:	7b46                	ld	s6,112(sp)
    4b72:	7ba6                	ld	s7,104(sp)
    4b74:	7c06                	ld	s8,96(sp)
    4b76:	6ce6                	ld	s9,88(sp)
    4b78:	6d46                	ld	s10,80(sp)
    4b7a:	6da6                	ld	s11,72(sp)
    4b7c:	614d                	addi	sp,sp,176
    4b7e:	8082                	ret
    int total = 0;
    4b80:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    4b82:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    4b86:	40000613          	li	a2,1024
    4b8a:	85d2                	mv	a1,s4
    4b8c:	854a                	mv	a0,s2
    4b8e:	00001097          	auipc	ra,0x1
    4b92:	806080e7          	jalr	-2042(ra) # 5394 <write>
      if(cc < BSIZE)
    4b96:	00aad563          	bge	s5,a0,4ba0 <fsfull+0x17c>
      total += cc;
    4b9a:	00a989bb          	addw	s3,s3,a0
    while(1){
    4b9e:	b7e5                	j	4b86 <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    4ba0:	85ce                	mv	a1,s3
    4ba2:	00003517          	auipc	a0,0x3
    4ba6:	d8e50513          	addi	a0,a0,-626 # 7930 <malloc+0x2186>
    4baa:	00001097          	auipc	ra,0x1
    4bae:	b42080e7          	jalr	-1214(ra) # 56ec <printf>
    close(fd);
    4bb2:	854a                	mv	a0,s2
    4bb4:	00000097          	auipc	ra,0x0
    4bb8:	7e8080e7          	jalr	2024(ra) # 539c <close>
    if(total == 0)
    4bbc:	f20988e3          	beqz	s3,4aec <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    4bc0:	2485                	addiw	s1,s1,1
    4bc2:	bd4d                	j	4a74 <fsfull+0x50>

0000000000004bc4 <rand>:
{
    4bc4:	1141                	addi	sp,sp,-16
    4bc6:	e422                	sd	s0,8(sp)
    4bc8:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    4bca:	00003717          	auipc	a4,0x3
    4bce:	33670713          	addi	a4,a4,822 # 7f00 <randstate>
    4bd2:	6308                	ld	a0,0(a4)
    4bd4:	001967b7          	lui	a5,0x196
    4bd8:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x187ecd>
    4bdc:	02f50533          	mul	a0,a0,a5
    4be0:	3c6ef7b7          	lui	a5,0x3c6ef
    4be4:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e0c1f>
    4be8:	953e                	add	a0,a0,a5
    4bea:	e308                	sd	a0,0(a4)
}
    4bec:	2501                	sext.w	a0,a0
    4bee:	6422                	ld	s0,8(sp)
    4bf0:	0141                	addi	sp,sp,16
    4bf2:	8082                	ret

0000000000004bf4 <badwrite>:
{
    4bf4:	7179                	addi	sp,sp,-48
    4bf6:	f406                	sd	ra,40(sp)
    4bf8:	f022                	sd	s0,32(sp)
    4bfa:	ec26                	sd	s1,24(sp)
    4bfc:	e84a                	sd	s2,16(sp)
    4bfe:	e44e                	sd	s3,8(sp)
    4c00:	e052                	sd	s4,0(sp)
    4c02:	1800                	addi	s0,sp,48
  unlink("junk");
    4c04:	00003517          	auipc	a0,0x3
    4c08:	d5c50513          	addi	a0,a0,-676 # 7960 <malloc+0x21b6>
    4c0c:	00000097          	auipc	ra,0x0
    4c10:	7b8080e7          	jalr	1976(ra) # 53c4 <unlink>
    4c14:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c18:	00003997          	auipc	s3,0x3
    4c1c:	d4898993          	addi	s3,s3,-696 # 7960 <malloc+0x21b6>
    write(fd, (char*)0xffffffffffL, 1);
    4c20:	5a7d                	li	s4,-1
    4c22:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    4c26:	20100593          	li	a1,513
    4c2a:	854e                	mv	a0,s3
    4c2c:	00000097          	auipc	ra,0x0
    4c30:	788080e7          	jalr	1928(ra) # 53b4 <open>
    4c34:	84aa                	mv	s1,a0
    if(fd < 0){
    4c36:	06054b63          	bltz	a0,4cac <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    4c3a:	4605                	li	a2,1
    4c3c:	85d2                	mv	a1,s4
    4c3e:	00000097          	auipc	ra,0x0
    4c42:	756080e7          	jalr	1878(ra) # 5394 <write>
    close(fd);
    4c46:	8526                	mv	a0,s1
    4c48:	00000097          	auipc	ra,0x0
    4c4c:	754080e7          	jalr	1876(ra) # 539c <close>
    unlink("junk");
    4c50:	854e                	mv	a0,s3
    4c52:	00000097          	auipc	ra,0x0
    4c56:	772080e7          	jalr	1906(ra) # 53c4 <unlink>
  for(int i = 0; i < assumed_free; i++){
    4c5a:	397d                	addiw	s2,s2,-1
    4c5c:	fc0915e3          	bnez	s2,4c26 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    4c60:	20100593          	li	a1,513
    4c64:	00003517          	auipc	a0,0x3
    4c68:	cfc50513          	addi	a0,a0,-772 # 7960 <malloc+0x21b6>
    4c6c:	00000097          	auipc	ra,0x0
    4c70:	748080e7          	jalr	1864(ra) # 53b4 <open>
    4c74:	84aa                	mv	s1,a0
  if(fd < 0){
    4c76:	04054863          	bltz	a0,4cc6 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    4c7a:	4605                	li	a2,1
    4c7c:	00001597          	auipc	a1,0x1
    4c80:	fbc58593          	addi	a1,a1,-68 # 5c38 <malloc+0x48e>
    4c84:	00000097          	auipc	ra,0x0
    4c88:	710080e7          	jalr	1808(ra) # 5394 <write>
    4c8c:	4785                	li	a5,1
    4c8e:	04f50963          	beq	a0,a5,4ce0 <badwrite+0xec>
    printf("write failed\n");
    4c92:	00003517          	auipc	a0,0x3
    4c96:	cee50513          	addi	a0,a0,-786 # 7980 <malloc+0x21d6>
    4c9a:	00001097          	auipc	ra,0x1
    4c9e:	a52080e7          	jalr	-1454(ra) # 56ec <printf>
    exit(1);
    4ca2:	4505                	li	a0,1
    4ca4:	00000097          	auipc	ra,0x0
    4ca8:	6d0080e7          	jalr	1744(ra) # 5374 <exit>
      printf("open junk failed\n");
    4cac:	00003517          	auipc	a0,0x3
    4cb0:	cbc50513          	addi	a0,a0,-836 # 7968 <malloc+0x21be>
    4cb4:	00001097          	auipc	ra,0x1
    4cb8:	a38080e7          	jalr	-1480(ra) # 56ec <printf>
      exit(1);
    4cbc:	4505                	li	a0,1
    4cbe:	00000097          	auipc	ra,0x0
    4cc2:	6b6080e7          	jalr	1718(ra) # 5374 <exit>
    printf("open junk failed\n");
    4cc6:	00003517          	auipc	a0,0x3
    4cca:	ca250513          	addi	a0,a0,-862 # 7968 <malloc+0x21be>
    4cce:	00001097          	auipc	ra,0x1
    4cd2:	a1e080e7          	jalr	-1506(ra) # 56ec <printf>
    exit(1);
    4cd6:	4505                	li	a0,1
    4cd8:	00000097          	auipc	ra,0x0
    4cdc:	69c080e7          	jalr	1692(ra) # 5374 <exit>
  close(fd);
    4ce0:	8526                	mv	a0,s1
    4ce2:	00000097          	auipc	ra,0x0
    4ce6:	6ba080e7          	jalr	1722(ra) # 539c <close>
  unlink("junk");
    4cea:	00003517          	auipc	a0,0x3
    4cee:	c7650513          	addi	a0,a0,-906 # 7960 <malloc+0x21b6>
    4cf2:	00000097          	auipc	ra,0x0
    4cf6:	6d2080e7          	jalr	1746(ra) # 53c4 <unlink>
  exit(0);
    4cfa:	4501                	li	a0,0
    4cfc:	00000097          	auipc	ra,0x0
    4d00:	678080e7          	jalr	1656(ra) # 5374 <exit>

0000000000004d04 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    4d04:	7139                	addi	sp,sp,-64
    4d06:	fc06                	sd	ra,56(sp)
    4d08:	f822                	sd	s0,48(sp)
    4d0a:	f426                	sd	s1,40(sp)
    4d0c:	f04a                	sd	s2,32(sp)
    4d0e:	ec4e                	sd	s3,24(sp)
    4d10:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    4d12:	fc840513          	addi	a0,s0,-56
    4d16:	00000097          	auipc	ra,0x0
    4d1a:	66e080e7          	jalr	1646(ra) # 5384 <pipe>
    4d1e:	06054763          	bltz	a0,4d8c <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    4d22:	00000097          	auipc	ra,0x0
    4d26:	64a080e7          	jalr	1610(ra) # 536c <fork>

  if(pid < 0){
    4d2a:	06054e63          	bltz	a0,4da6 <countfree+0xa2>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4d2e:	ed51                	bnez	a0,4dca <countfree+0xc6>
    close(fds[0]);
    4d30:	fc842503          	lw	a0,-56(s0)
    4d34:	00000097          	auipc	ra,0x0
    4d38:	668080e7          	jalr	1640(ra) # 539c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    4d3c:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    4d3e:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    4d40:	00001997          	auipc	s3,0x1
    4d44:	ef898993          	addi	s3,s3,-264 # 5c38 <malloc+0x48e>
      uint64 a = (uint64) sbrk(4096);
    4d48:	6505                	lui	a0,0x1
    4d4a:	00000097          	auipc	ra,0x0
    4d4e:	6b2080e7          	jalr	1714(ra) # 53fc <sbrk>
      if(a == 0xffffffffffffffff){
    4d52:	07250763          	beq	a0,s2,4dc0 <countfree+0xbc>
      *(char *)(a + 4096 - 1) = 1;
    4d56:	6785                	lui	a5,0x1
    4d58:	953e                	add	a0,a0,a5
    4d5a:	fe950fa3          	sb	s1,-1(a0) # fff <bigdir+0x95>
      if(write(fds[1], "x", 1) != 1){
    4d5e:	8626                	mv	a2,s1
    4d60:	85ce                	mv	a1,s3
    4d62:	fcc42503          	lw	a0,-52(s0)
    4d66:	00000097          	auipc	ra,0x0
    4d6a:	62e080e7          	jalr	1582(ra) # 5394 <write>
    4d6e:	fc950de3          	beq	a0,s1,4d48 <countfree+0x44>
        printf("write() failed in countfree()\n");
    4d72:	00003517          	auipc	a0,0x3
    4d76:	c5e50513          	addi	a0,a0,-930 # 79d0 <malloc+0x2226>
    4d7a:	00001097          	auipc	ra,0x1
    4d7e:	972080e7          	jalr	-1678(ra) # 56ec <printf>
        exit(1);
    4d82:	4505                	li	a0,1
    4d84:	00000097          	auipc	ra,0x0
    4d88:	5f0080e7          	jalr	1520(ra) # 5374 <exit>
    printf("pipe() failed in countfree()\n");
    4d8c:	00003517          	auipc	a0,0x3
    4d90:	c0450513          	addi	a0,a0,-1020 # 7990 <malloc+0x21e6>
    4d94:	00001097          	auipc	ra,0x1
    4d98:	958080e7          	jalr	-1704(ra) # 56ec <printf>
    exit(1);
    4d9c:	4505                	li	a0,1
    4d9e:	00000097          	auipc	ra,0x0
    4da2:	5d6080e7          	jalr	1494(ra) # 5374 <exit>
    printf("fork failed in countfree()\n");
    4da6:	00003517          	auipc	a0,0x3
    4daa:	c0a50513          	addi	a0,a0,-1014 # 79b0 <malloc+0x2206>
    4dae:	00001097          	auipc	ra,0x1
    4db2:	93e080e7          	jalr	-1730(ra) # 56ec <printf>
    exit(1);
    4db6:	4505                	li	a0,1
    4db8:	00000097          	auipc	ra,0x0
    4dbc:	5bc080e7          	jalr	1468(ra) # 5374 <exit>
      }
    }

    exit(0);
    4dc0:	4501                	li	a0,0
    4dc2:	00000097          	auipc	ra,0x0
    4dc6:	5b2080e7          	jalr	1458(ra) # 5374 <exit>
  }

  close(fds[1]);
    4dca:	fcc42503          	lw	a0,-52(s0)
    4dce:	00000097          	auipc	ra,0x0
    4dd2:	5ce080e7          	jalr	1486(ra) # 539c <close>

  int n = 0;
    4dd6:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4dd8:	4605                	li	a2,1
    4dda:	fc740593          	addi	a1,s0,-57
    4dde:	fc842503          	lw	a0,-56(s0)
    4de2:	00000097          	auipc	ra,0x0
    4de6:	5aa080e7          	jalr	1450(ra) # 538c <read>
    if(cc < 0){
    4dea:	00054563          	bltz	a0,4df4 <countfree+0xf0>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4dee:	c105                	beqz	a0,4e0e <countfree+0x10a>
      break;
    n += 1;
    4df0:	2485                	addiw	s1,s1,1
  while(1){
    4df2:	b7dd                	j	4dd8 <countfree+0xd4>
      printf("read() failed in countfree()\n");
    4df4:	00003517          	auipc	a0,0x3
    4df8:	bfc50513          	addi	a0,a0,-1028 # 79f0 <malloc+0x2246>
    4dfc:	00001097          	auipc	ra,0x1
    4e00:	8f0080e7          	jalr	-1808(ra) # 56ec <printf>
      exit(1);
    4e04:	4505                	li	a0,1
    4e06:	00000097          	auipc	ra,0x0
    4e0a:	56e080e7          	jalr	1390(ra) # 5374 <exit>
  }

  close(fds[0]);
    4e0e:	fc842503          	lw	a0,-56(s0)
    4e12:	00000097          	auipc	ra,0x0
    4e16:	58a080e7          	jalr	1418(ra) # 539c <close>
  wait((int*)0);
    4e1a:	4501                	li	a0,0
    4e1c:	00000097          	auipc	ra,0x0
    4e20:	560080e7          	jalr	1376(ra) # 537c <wait>
  
  return n;
}
    4e24:	8526                	mv	a0,s1
    4e26:	70e2                	ld	ra,56(sp)
    4e28:	7442                	ld	s0,48(sp)
    4e2a:	74a2                	ld	s1,40(sp)
    4e2c:	7902                	ld	s2,32(sp)
    4e2e:	69e2                	ld	s3,24(sp)
    4e30:	6121                	addi	sp,sp,64
    4e32:	8082                	ret

0000000000004e34 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    4e34:	7179                	addi	sp,sp,-48
    4e36:	f406                	sd	ra,40(sp)
    4e38:	f022                	sd	s0,32(sp)
    4e3a:	ec26                	sd	s1,24(sp)
    4e3c:	e84a                	sd	s2,16(sp)
    4e3e:	1800                	addi	s0,sp,48
    4e40:	84aa                	mv	s1,a0
    4e42:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4e44:	00003517          	auipc	a0,0x3
    4e48:	bcc50513          	addi	a0,a0,-1076 # 7a10 <malloc+0x2266>
    4e4c:	00001097          	auipc	ra,0x1
    4e50:	8a0080e7          	jalr	-1888(ra) # 56ec <printf>
  if((pid = fork()) < 0) {
    4e54:	00000097          	auipc	ra,0x0
    4e58:	518080e7          	jalr	1304(ra) # 536c <fork>
    4e5c:	02054e63          	bltz	a0,4e98 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4e60:	c929                	beqz	a0,4eb2 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4e62:	fdc40513          	addi	a0,s0,-36
    4e66:	00000097          	auipc	ra,0x0
    4e6a:	516080e7          	jalr	1302(ra) # 537c <wait>
    if(xstatus != 0) 
    4e6e:	fdc42783          	lw	a5,-36(s0)
    4e72:	c7b9                	beqz	a5,4ec0 <run+0x8c>
      printf("FAILED\n");
    4e74:	00003517          	auipc	a0,0x3
    4e78:	bc450513          	addi	a0,a0,-1084 # 7a38 <malloc+0x228e>
    4e7c:	00001097          	auipc	ra,0x1
    4e80:	870080e7          	jalr	-1936(ra) # 56ec <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4e84:	fdc42503          	lw	a0,-36(s0)
  }
}
    4e88:	00153513          	seqz	a0,a0
    4e8c:	70a2                	ld	ra,40(sp)
    4e8e:	7402                	ld	s0,32(sp)
    4e90:	64e2                	ld	s1,24(sp)
    4e92:	6942                	ld	s2,16(sp)
    4e94:	6145                	addi	sp,sp,48
    4e96:	8082                	ret
    printf("runtest: fork error\n");
    4e98:	00003517          	auipc	a0,0x3
    4e9c:	b8850513          	addi	a0,a0,-1144 # 7a20 <malloc+0x2276>
    4ea0:	00001097          	auipc	ra,0x1
    4ea4:	84c080e7          	jalr	-1972(ra) # 56ec <printf>
    exit(1);
    4ea8:	4505                	li	a0,1
    4eaa:	00000097          	auipc	ra,0x0
    4eae:	4ca080e7          	jalr	1226(ra) # 5374 <exit>
    f(s);
    4eb2:	854a                	mv	a0,s2
    4eb4:	9482                	jalr	s1
    exit(0);
    4eb6:	4501                	li	a0,0
    4eb8:	00000097          	auipc	ra,0x0
    4ebc:	4bc080e7          	jalr	1212(ra) # 5374 <exit>
      printf("OK\n");
    4ec0:	00003517          	auipc	a0,0x3
    4ec4:	b8050513          	addi	a0,a0,-1152 # 7a40 <malloc+0x2296>
    4ec8:	00001097          	auipc	ra,0x1
    4ecc:	824080e7          	jalr	-2012(ra) # 56ec <printf>
    4ed0:	bf55                	j	4e84 <run+0x50>

0000000000004ed2 <main>:

int
main(int argc, char *argv[])
{
    4ed2:	c4010113          	addi	sp,sp,-960
    4ed6:	3a113c23          	sd	ra,952(sp)
    4eda:	3a813823          	sd	s0,944(sp)
    4ede:	3a913423          	sd	s1,936(sp)
    4ee2:	3b213023          	sd	s2,928(sp)
    4ee6:	39313c23          	sd	s3,920(sp)
    4eea:	39413823          	sd	s4,912(sp)
    4eee:	39513423          	sd	s5,904(sp)
    4ef2:	39613023          	sd	s6,896(sp)
    4ef6:	0780                	addi	s0,sp,960
    4ef8:	89aa                	mv	s3,a0
  int continuous = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4efa:	4789                	li	a5,2
    4efc:	08f50763          	beq	a0,a5,4f8a <main+0xb8>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4f00:	4785                	li	a5,1
  char *justone = 0;
    4f02:	4901                	li	s2,0
  } else if(argc > 1){
    4f04:	0ca7c163          	blt	a5,a0,4fc6 <main+0xf4>
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    4f08:	00003797          	auipc	a5,0x3
    4f0c:	c5078793          	addi	a5,a5,-944 # 7b58 <malloc+0x23ae>
    4f10:	c4040713          	addi	a4,s0,-960
    4f14:	00003817          	auipc	a6,0x3
    4f18:	fc480813          	addi	a6,a6,-60 # 7ed8 <malloc+0x272e>
    4f1c:	6388                	ld	a0,0(a5)
    4f1e:	678c                	ld	a1,8(a5)
    4f20:	6b90                	ld	a2,16(a5)
    4f22:	6f94                	ld	a3,24(a5)
    4f24:	e308                	sd	a0,0(a4)
    4f26:	e70c                	sd	a1,8(a4)
    4f28:	eb10                	sd	a2,16(a4)
    4f2a:	ef14                	sd	a3,24(a4)
    4f2c:	02078793          	addi	a5,a5,32
    4f30:	02070713          	addi	a4,a4,32
    4f34:	ff0794e3          	bne	a5,a6,4f1c <main+0x4a>
          exit(1);
      }
    }
  }

  printf("usertests starting\n");
    4f38:	00003517          	auipc	a0,0x3
    4f3c:	bc050513          	addi	a0,a0,-1088 # 7af8 <malloc+0x234e>
    4f40:	00000097          	auipc	ra,0x0
    4f44:	7ac080e7          	jalr	1964(ra) # 56ec <printf>
  int free0 = countfree();
    4f48:	00000097          	auipc	ra,0x0
    4f4c:	dbc080e7          	jalr	-580(ra) # 4d04 <countfree>
    4f50:	8a2a                	mv	s4,a0
  int free1 = 0;
  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4f52:	c4843503          	ld	a0,-952(s0)
    4f56:	c4040493          	addi	s1,s0,-960
  int fail = 0;
    4f5a:	4981                	li	s3,0
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    4f5c:	4a85                	li	s5,1
  for (struct test *t = tests; t->s != 0; t++) {
    4f5e:	e55d                	bnez	a0,500c <main+0x13a>
  }

  if(fail){
    printf("SOME TESTS FAILED\n");
    exit(1);
  } else if((free1 = countfree()) < free0){
    4f60:	00000097          	auipc	ra,0x0
    4f64:	da4080e7          	jalr	-604(ra) # 4d04 <countfree>
    4f68:	85aa                	mv	a1,a0
    4f6a:	0f455163          	bge	a0,s4,504c <main+0x17a>
    printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4f6e:	8652                	mv	a2,s4
    4f70:	00003517          	auipc	a0,0x3
    4f74:	b4050513          	addi	a0,a0,-1216 # 7ab0 <malloc+0x2306>
    4f78:	00000097          	auipc	ra,0x0
    4f7c:	774080e7          	jalr	1908(ra) # 56ec <printf>
    exit(1);
    4f80:	4505                	li	a0,1
    4f82:	00000097          	auipc	ra,0x0
    4f86:	3f2080e7          	jalr	1010(ra) # 5374 <exit>
    4f8a:	84ae                	mv	s1,a1
  if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4f8c:	00003597          	auipc	a1,0x3
    4f90:	abc58593          	addi	a1,a1,-1348 # 7a48 <malloc+0x229e>
    4f94:	6488                	ld	a0,8(s1)
    4f96:	00000097          	auipc	ra,0x0
    4f9a:	184080e7          	jalr	388(ra) # 511a <strcmp>
    4f9e:	10050563          	beqz	a0,50a8 <main+0x1d6>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4fa2:	00003597          	auipc	a1,0x3
    4fa6:	b8e58593          	addi	a1,a1,-1138 # 7b30 <malloc+0x2386>
    4faa:	6488                	ld	a0,8(s1)
    4fac:	00000097          	auipc	ra,0x0
    4fb0:	16e080e7          	jalr	366(ra) # 511a <strcmp>
    4fb4:	c97d                	beqz	a0,50aa <main+0x1d8>
  } else if(argc == 2 && argv[1][0] != '-'){
    4fb6:	0084b903          	ld	s2,8(s1)
    4fba:	00094703          	lbu	a4,0(s2)
    4fbe:	02d00793          	li	a5,45
    4fc2:	f4f713e3          	bne	a4,a5,4f08 <main+0x36>
    printf("Usage: usertests [-c] [testname]\n");
    4fc6:	00003517          	auipc	a0,0x3
    4fca:	a8a50513          	addi	a0,a0,-1398 # 7a50 <malloc+0x22a6>
    4fce:	00000097          	auipc	ra,0x0
    4fd2:	71e080e7          	jalr	1822(ra) # 56ec <printf>
    exit(1);
    4fd6:	4505                	li	a0,1
    4fd8:	00000097          	auipc	ra,0x0
    4fdc:	39c080e7          	jalr	924(ra) # 5374 <exit>
          exit(1);
    4fe0:	4505                	li	a0,1
    4fe2:	00000097          	auipc	ra,0x0
    4fe6:	392080e7          	jalr	914(ra) # 5374 <exit>
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    4fea:	40a905bb          	subw	a1,s2,a0
    4fee:	855a                	mv	a0,s6
    4ff0:	00000097          	auipc	ra,0x0
    4ff4:	6fc080e7          	jalr	1788(ra) # 56ec <printf>
        if(continuous != 2)
    4ff8:	09498463          	beq	s3,s4,5080 <main+0x1ae>
          exit(1);
    4ffc:	4505                	li	a0,1
    4ffe:	00000097          	auipc	ra,0x0
    5002:	376080e7          	jalr	886(ra) # 5374 <exit>
  for (struct test *t = tests; t->s != 0; t++) {
    5006:	04c1                	addi	s1,s1,16
    5008:	6488                	ld	a0,8(s1)
    500a:	c115                	beqz	a0,502e <main+0x15c>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    500c:	00090863          	beqz	s2,501c <main+0x14a>
    5010:	85ca                	mv	a1,s2
    5012:	00000097          	auipc	ra,0x0
    5016:	108080e7          	jalr	264(ra) # 511a <strcmp>
    501a:	f575                	bnez	a0,5006 <main+0x134>
      if(!run(t->f, t->s))
    501c:	648c                	ld	a1,8(s1)
    501e:	6088                	ld	a0,0(s1)
    5020:	00000097          	auipc	ra,0x0
    5024:	e14080e7          	jalr	-492(ra) # 4e34 <run>
    5028:	fd79                	bnez	a0,5006 <main+0x134>
        fail = 1;
    502a:	89d6                	mv	s3,s5
    502c:	bfe9                	j	5006 <main+0x134>
  if(fail){
    502e:	f20989e3          	beqz	s3,4f60 <main+0x8e>
    printf("SOME TESTS FAILED\n");
    5032:	00003517          	auipc	a0,0x3
    5036:	a6650513          	addi	a0,a0,-1434 # 7a98 <malloc+0x22ee>
    503a:	00000097          	auipc	ra,0x0
    503e:	6b2080e7          	jalr	1714(ra) # 56ec <printf>
    exit(1);
    5042:	4505                	li	a0,1
    5044:	00000097          	auipc	ra,0x0
    5048:	330080e7          	jalr	816(ra) # 5374 <exit>
  } else {
    printf("ALL TESTS PASSED\n");
    504c:	00003517          	auipc	a0,0x3
    5050:	a9450513          	addi	a0,a0,-1388 # 7ae0 <malloc+0x2336>
    5054:	00000097          	auipc	ra,0x0
    5058:	698080e7          	jalr	1688(ra) # 56ec <printf>
    exit(0);
    505c:	4501                	li	a0,0
    505e:	00000097          	auipc	ra,0x0
    5062:	316080e7          	jalr	790(ra) # 5374 <exit>
        printf("SOME TESTS FAILED\n");
    5066:	8556                	mv	a0,s5
    5068:	00000097          	auipc	ra,0x0
    506c:	684080e7          	jalr	1668(ra) # 56ec <printf>
        if(continuous != 2)
    5070:	f74998e3          	bne	s3,s4,4fe0 <main+0x10e>
      int free1 = countfree();
    5074:	00000097          	auipc	ra,0x0
    5078:	c90080e7          	jalr	-880(ra) # 4d04 <countfree>
      if(free1 < free0){
    507c:	f72547e3          	blt	a0,s2,4fea <main+0x118>
      int free0 = countfree();
    5080:	00000097          	auipc	ra,0x0
    5084:	c84080e7          	jalr	-892(ra) # 4d04 <countfree>
    5088:	892a                	mv	s2,a0
      for (struct test *t = tests; t->s != 0; t++) {
    508a:	c4843583          	ld	a1,-952(s0)
    508e:	d1fd                	beqz	a1,5074 <main+0x1a2>
    5090:	c4040493          	addi	s1,s0,-960
        if(!run(t->f, t->s)){
    5094:	6088                	ld	a0,0(s1)
    5096:	00000097          	auipc	ra,0x0
    509a:	d9e080e7          	jalr	-610(ra) # 4e34 <run>
    509e:	d561                	beqz	a0,5066 <main+0x194>
      for (struct test *t = tests; t->s != 0; t++) {
    50a0:	04c1                	addi	s1,s1,16
    50a2:	648c                	ld	a1,8(s1)
    50a4:	f9e5                	bnez	a1,5094 <main+0x1c2>
    50a6:	b7f9                	j	5074 <main+0x1a2>
    continuous = 1;
    50a8:	4985                	li	s3,1
  } tests[] = {
    50aa:	00003797          	auipc	a5,0x3
    50ae:	aae78793          	addi	a5,a5,-1362 # 7b58 <malloc+0x23ae>
    50b2:	c4040713          	addi	a4,s0,-960
    50b6:	00003817          	auipc	a6,0x3
    50ba:	e2280813          	addi	a6,a6,-478 # 7ed8 <malloc+0x272e>
    50be:	6388                	ld	a0,0(a5)
    50c0:	678c                	ld	a1,8(a5)
    50c2:	6b90                	ld	a2,16(a5)
    50c4:	6f94                	ld	a3,24(a5)
    50c6:	e308                	sd	a0,0(a4)
    50c8:	e70c                	sd	a1,8(a4)
    50ca:	eb10                	sd	a2,16(a4)
    50cc:	ef14                	sd	a3,24(a4)
    50ce:	02078793          	addi	a5,a5,32
    50d2:	02070713          	addi	a4,a4,32
    50d6:	ff0794e3          	bne	a5,a6,50be <main+0x1ec>
    printf("continuous usertests starting\n");
    50da:	00003517          	auipc	a0,0x3
    50de:	a3650513          	addi	a0,a0,-1482 # 7b10 <malloc+0x2366>
    50e2:	00000097          	auipc	ra,0x0
    50e6:	60a080e7          	jalr	1546(ra) # 56ec <printf>
        printf("SOME TESTS FAILED\n");
    50ea:	00003a97          	auipc	s5,0x3
    50ee:	9aea8a93          	addi	s5,s5,-1618 # 7a98 <malloc+0x22ee>
        if(continuous != 2)
    50f2:	4a09                	li	s4,2
        printf("FAILED -- lost %d free pages\n", free0 - free1);
    50f4:	00003b17          	auipc	s6,0x3
    50f8:	984b0b13          	addi	s6,s6,-1660 # 7a78 <malloc+0x22ce>
    50fc:	b751                	j	5080 <main+0x1ae>

00000000000050fe <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    50fe:	1141                	addi	sp,sp,-16
    5100:	e422                	sd	s0,8(sp)
    5102:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5104:	87aa                	mv	a5,a0
    5106:	0585                	addi	a1,a1,1
    5108:	0785                	addi	a5,a5,1
    510a:	fff5c703          	lbu	a4,-1(a1)
    510e:	fee78fa3          	sb	a4,-1(a5)
    5112:	fb75                	bnez	a4,5106 <strcpy+0x8>
    ;
  return os;
}
    5114:	6422                	ld	s0,8(sp)
    5116:	0141                	addi	sp,sp,16
    5118:	8082                	ret

000000000000511a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    511a:	1141                	addi	sp,sp,-16
    511c:	e422                	sd	s0,8(sp)
    511e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    5120:	00054783          	lbu	a5,0(a0)
    5124:	cb91                	beqz	a5,5138 <strcmp+0x1e>
    5126:	0005c703          	lbu	a4,0(a1)
    512a:	00f71763          	bne	a4,a5,5138 <strcmp+0x1e>
    p++, q++;
    512e:	0505                	addi	a0,a0,1
    5130:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    5132:	00054783          	lbu	a5,0(a0)
    5136:	fbe5                	bnez	a5,5126 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5138:	0005c503          	lbu	a0,0(a1)
}
    513c:	40a7853b          	subw	a0,a5,a0
    5140:	6422                	ld	s0,8(sp)
    5142:	0141                	addi	sp,sp,16
    5144:	8082                	ret

0000000000005146 <strlen>:

uint
strlen(const char *s)
{
    5146:	1141                	addi	sp,sp,-16
    5148:	e422                	sd	s0,8(sp)
    514a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    514c:	00054783          	lbu	a5,0(a0)
    5150:	cf91                	beqz	a5,516c <strlen+0x26>
    5152:	0505                	addi	a0,a0,1
    5154:	87aa                	mv	a5,a0
    5156:	4685                	li	a3,1
    5158:	9e89                	subw	a3,a3,a0
    515a:	00f6853b          	addw	a0,a3,a5
    515e:	0785                	addi	a5,a5,1
    5160:	fff7c703          	lbu	a4,-1(a5)
    5164:	fb7d                	bnez	a4,515a <strlen+0x14>
    ;
  return n;
}
    5166:	6422                	ld	s0,8(sp)
    5168:	0141                	addi	sp,sp,16
    516a:	8082                	ret
  for(n = 0; s[n]; n++)
    516c:	4501                	li	a0,0
    516e:	bfe5                	j	5166 <strlen+0x20>

0000000000005170 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5170:	1141                	addi	sp,sp,-16
    5172:	e422                	sd	s0,8(sp)
    5174:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5176:	ce09                	beqz	a2,5190 <memset+0x20>
    5178:	87aa                	mv	a5,a0
    517a:	fff6071b          	addiw	a4,a2,-1
    517e:	1702                	slli	a4,a4,0x20
    5180:	9301                	srli	a4,a4,0x20
    5182:	0705                	addi	a4,a4,1
    5184:	972a                	add	a4,a4,a0
    cdst[i] = c;
    5186:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    518a:	0785                	addi	a5,a5,1
    518c:	fee79de3          	bne	a5,a4,5186 <memset+0x16>
  }
  return dst;
}
    5190:	6422                	ld	s0,8(sp)
    5192:	0141                	addi	sp,sp,16
    5194:	8082                	ret

0000000000005196 <strchr>:

char*
strchr(const char *s, char c)
{
    5196:	1141                	addi	sp,sp,-16
    5198:	e422                	sd	s0,8(sp)
    519a:	0800                	addi	s0,sp,16
  for(; *s; s++)
    519c:	00054783          	lbu	a5,0(a0)
    51a0:	cb99                	beqz	a5,51b6 <strchr+0x20>
    if(*s == c)
    51a2:	00f58763          	beq	a1,a5,51b0 <strchr+0x1a>
  for(; *s; s++)
    51a6:	0505                	addi	a0,a0,1
    51a8:	00054783          	lbu	a5,0(a0)
    51ac:	fbfd                	bnez	a5,51a2 <strchr+0xc>
      return (char*)s;
  return 0;
    51ae:	4501                	li	a0,0
}
    51b0:	6422                	ld	s0,8(sp)
    51b2:	0141                	addi	sp,sp,16
    51b4:	8082                	ret
  return 0;
    51b6:	4501                	li	a0,0
    51b8:	bfe5                	j	51b0 <strchr+0x1a>

00000000000051ba <gets>:

char*
gets(char *buf, int max)
{
    51ba:	711d                	addi	sp,sp,-96
    51bc:	ec86                	sd	ra,88(sp)
    51be:	e8a2                	sd	s0,80(sp)
    51c0:	e4a6                	sd	s1,72(sp)
    51c2:	e0ca                	sd	s2,64(sp)
    51c4:	fc4e                	sd	s3,56(sp)
    51c6:	f852                	sd	s4,48(sp)
    51c8:	f456                	sd	s5,40(sp)
    51ca:	f05a                	sd	s6,32(sp)
    51cc:	ec5e                	sd	s7,24(sp)
    51ce:	1080                	addi	s0,sp,96
    51d0:	8baa                	mv	s7,a0
    51d2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    51d4:	892a                	mv	s2,a0
    51d6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    51d8:	4aa9                	li	s5,10
    51da:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    51dc:	89a6                	mv	s3,s1
    51de:	2485                	addiw	s1,s1,1
    51e0:	0344d863          	bge	s1,s4,5210 <gets+0x56>
    cc = read(0, &c, 1);
    51e4:	4605                	li	a2,1
    51e6:	faf40593          	addi	a1,s0,-81
    51ea:	4501                	li	a0,0
    51ec:	00000097          	auipc	ra,0x0
    51f0:	1a0080e7          	jalr	416(ra) # 538c <read>
    if(cc < 1)
    51f4:	00a05e63          	blez	a0,5210 <gets+0x56>
    buf[i++] = c;
    51f8:	faf44783          	lbu	a5,-81(s0)
    51fc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5200:	01578763          	beq	a5,s5,520e <gets+0x54>
    5204:	0905                	addi	s2,s2,1
    5206:	fd679be3          	bne	a5,s6,51dc <gets+0x22>
  for(i=0; i+1 < max; ){
    520a:	89a6                	mv	s3,s1
    520c:	a011                	j	5210 <gets+0x56>
    520e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5210:	99de                	add	s3,s3,s7
    5212:	00098023          	sb	zero,0(s3)
  return buf;
}
    5216:	855e                	mv	a0,s7
    5218:	60e6                	ld	ra,88(sp)
    521a:	6446                	ld	s0,80(sp)
    521c:	64a6                	ld	s1,72(sp)
    521e:	6906                	ld	s2,64(sp)
    5220:	79e2                	ld	s3,56(sp)
    5222:	7a42                	ld	s4,48(sp)
    5224:	7aa2                	ld	s5,40(sp)
    5226:	7b02                	ld	s6,32(sp)
    5228:	6be2                	ld	s7,24(sp)
    522a:	6125                	addi	sp,sp,96
    522c:	8082                	ret

000000000000522e <stat>:

int
stat(const char *n, struct stat *st)
{
    522e:	1101                	addi	sp,sp,-32
    5230:	ec06                	sd	ra,24(sp)
    5232:	e822                	sd	s0,16(sp)
    5234:	e426                	sd	s1,8(sp)
    5236:	e04a                	sd	s2,0(sp)
    5238:	1000                	addi	s0,sp,32
    523a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    523c:	4581                	li	a1,0
    523e:	00000097          	auipc	ra,0x0
    5242:	176080e7          	jalr	374(ra) # 53b4 <open>
  if(fd < 0)
    5246:	02054563          	bltz	a0,5270 <stat+0x42>
    524a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    524c:	85ca                	mv	a1,s2
    524e:	00000097          	auipc	ra,0x0
    5252:	17e080e7          	jalr	382(ra) # 53cc <fstat>
    5256:	892a                	mv	s2,a0
  close(fd);
    5258:	8526                	mv	a0,s1
    525a:	00000097          	auipc	ra,0x0
    525e:	142080e7          	jalr	322(ra) # 539c <close>
  return r;
}
    5262:	854a                	mv	a0,s2
    5264:	60e2                	ld	ra,24(sp)
    5266:	6442                	ld	s0,16(sp)
    5268:	64a2                	ld	s1,8(sp)
    526a:	6902                	ld	s2,0(sp)
    526c:	6105                	addi	sp,sp,32
    526e:	8082                	ret
    return -1;
    5270:	597d                	li	s2,-1
    5272:	bfc5                	j	5262 <stat+0x34>

0000000000005274 <atoi>:

int
atoi(const char *s)
{
    5274:	1141                	addi	sp,sp,-16
    5276:	e422                	sd	s0,8(sp)
    5278:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    527a:	00054603          	lbu	a2,0(a0)
    527e:	fd06079b          	addiw	a5,a2,-48
    5282:	0ff7f793          	andi	a5,a5,255
    5286:	4725                	li	a4,9
    5288:	02f76963          	bltu	a4,a5,52ba <atoi+0x46>
    528c:	86aa                	mv	a3,a0
  n = 0;
    528e:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    5290:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    5292:	0685                	addi	a3,a3,1
    5294:	0025179b          	slliw	a5,a0,0x2
    5298:	9fa9                	addw	a5,a5,a0
    529a:	0017979b          	slliw	a5,a5,0x1
    529e:	9fb1                	addw	a5,a5,a2
    52a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    52a4:	0006c603          	lbu	a2,0(a3) # 1000 <bigdir+0x96>
    52a8:	fd06071b          	addiw	a4,a2,-48
    52ac:	0ff77713          	andi	a4,a4,255
    52b0:	fee5f1e3          	bgeu	a1,a4,5292 <atoi+0x1e>
  return n;
}
    52b4:	6422                	ld	s0,8(sp)
    52b6:	0141                	addi	sp,sp,16
    52b8:	8082                	ret
  n = 0;
    52ba:	4501                	li	a0,0
    52bc:	bfe5                	j	52b4 <atoi+0x40>

00000000000052be <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    52be:	1141                	addi	sp,sp,-16
    52c0:	e422                	sd	s0,8(sp)
    52c2:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    52c4:	02b57663          	bgeu	a0,a1,52f0 <memmove+0x32>
    while(n-- > 0)
    52c8:	02c05163          	blez	a2,52ea <memmove+0x2c>
    52cc:	fff6079b          	addiw	a5,a2,-1
    52d0:	1782                	slli	a5,a5,0x20
    52d2:	9381                	srli	a5,a5,0x20
    52d4:	0785                	addi	a5,a5,1
    52d6:	97aa                	add	a5,a5,a0
  dst = vdst;
    52d8:	872a                	mv	a4,a0
      *dst++ = *src++;
    52da:	0585                	addi	a1,a1,1
    52dc:	0705                	addi	a4,a4,1
    52de:	fff5c683          	lbu	a3,-1(a1)
    52e2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    52e6:	fee79ae3          	bne	a5,a4,52da <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    52ea:	6422                	ld	s0,8(sp)
    52ec:	0141                	addi	sp,sp,16
    52ee:	8082                	ret
    dst += n;
    52f0:	00c50733          	add	a4,a0,a2
    src += n;
    52f4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    52f6:	fec05ae3          	blez	a2,52ea <memmove+0x2c>
    52fa:	fff6079b          	addiw	a5,a2,-1
    52fe:	1782                	slli	a5,a5,0x20
    5300:	9381                	srli	a5,a5,0x20
    5302:	fff7c793          	not	a5,a5
    5306:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5308:	15fd                	addi	a1,a1,-1
    530a:	177d                	addi	a4,a4,-1
    530c:	0005c683          	lbu	a3,0(a1)
    5310:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5314:	fee79ae3          	bne	a5,a4,5308 <memmove+0x4a>
    5318:	bfc9                	j	52ea <memmove+0x2c>

000000000000531a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    531a:	1141                	addi	sp,sp,-16
    531c:	e422                	sd	s0,8(sp)
    531e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5320:	ca05                	beqz	a2,5350 <memcmp+0x36>
    5322:	fff6069b          	addiw	a3,a2,-1
    5326:	1682                	slli	a3,a3,0x20
    5328:	9281                	srli	a3,a3,0x20
    532a:	0685                	addi	a3,a3,1
    532c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    532e:	00054783          	lbu	a5,0(a0)
    5332:	0005c703          	lbu	a4,0(a1)
    5336:	00e79863          	bne	a5,a4,5346 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    533a:	0505                	addi	a0,a0,1
    p2++;
    533c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    533e:	fed518e3          	bne	a0,a3,532e <memcmp+0x14>
  }
  return 0;
    5342:	4501                	li	a0,0
    5344:	a019                	j	534a <memcmp+0x30>
      return *p1 - *p2;
    5346:	40e7853b          	subw	a0,a5,a4
}
    534a:	6422                	ld	s0,8(sp)
    534c:	0141                	addi	sp,sp,16
    534e:	8082                	ret
  return 0;
    5350:	4501                	li	a0,0
    5352:	bfe5                	j	534a <memcmp+0x30>

0000000000005354 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5354:	1141                	addi	sp,sp,-16
    5356:	e406                	sd	ra,8(sp)
    5358:	e022                	sd	s0,0(sp)
    535a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    535c:	00000097          	auipc	ra,0x0
    5360:	f62080e7          	jalr	-158(ra) # 52be <memmove>
}
    5364:	60a2                	ld	ra,8(sp)
    5366:	6402                	ld	s0,0(sp)
    5368:	0141                	addi	sp,sp,16
    536a:	8082                	ret

000000000000536c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    536c:	4885                	li	a7,1
 ecall
    536e:	00000073          	ecall
 ret
    5372:	8082                	ret

0000000000005374 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5374:	4889                	li	a7,2
 ecall
    5376:	00000073          	ecall
 ret
    537a:	8082                	ret

000000000000537c <wait>:
.global wait
wait:
 li a7, SYS_wait
    537c:	488d                	li	a7,3
 ecall
    537e:	00000073          	ecall
 ret
    5382:	8082                	ret

0000000000005384 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5384:	4891                	li	a7,4
 ecall
    5386:	00000073          	ecall
 ret
    538a:	8082                	ret

000000000000538c <read>:
.global read
read:
 li a7, SYS_read
    538c:	4895                	li	a7,5
 ecall
    538e:	00000073          	ecall
 ret
    5392:	8082                	ret

0000000000005394 <write>:
.global write
write:
 li a7, SYS_write
    5394:	48c1                	li	a7,16
 ecall
    5396:	00000073          	ecall
 ret
    539a:	8082                	ret

000000000000539c <close>:
.global close
close:
 li a7, SYS_close
    539c:	48d5                	li	a7,21
 ecall
    539e:	00000073          	ecall
 ret
    53a2:	8082                	ret

00000000000053a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
    53a4:	4899                	li	a7,6
 ecall
    53a6:	00000073          	ecall
 ret
    53aa:	8082                	ret

00000000000053ac <exec>:
.global exec
exec:
 li a7, SYS_exec
    53ac:	489d                	li	a7,7
 ecall
    53ae:	00000073          	ecall
 ret
    53b2:	8082                	ret

00000000000053b4 <open>:
.global open
open:
 li a7, SYS_open
    53b4:	48bd                	li	a7,15
 ecall
    53b6:	00000073          	ecall
 ret
    53ba:	8082                	ret

00000000000053bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    53bc:	48c5                	li	a7,17
 ecall
    53be:	00000073          	ecall
 ret
    53c2:	8082                	ret

00000000000053c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    53c4:	48c9                	li	a7,18
 ecall
    53c6:	00000073          	ecall
 ret
    53ca:	8082                	ret

00000000000053cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    53cc:	48a1                	li	a7,8
 ecall
    53ce:	00000073          	ecall
 ret
    53d2:	8082                	ret

00000000000053d4 <link>:
.global link
link:
 li a7, SYS_link
    53d4:	48cd                	li	a7,19
 ecall
    53d6:	00000073          	ecall
 ret
    53da:	8082                	ret

00000000000053dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    53dc:	48d1                	li	a7,20
 ecall
    53de:	00000073          	ecall
 ret
    53e2:	8082                	ret

00000000000053e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    53e4:	48a5                	li	a7,9
 ecall
    53e6:	00000073          	ecall
 ret
    53ea:	8082                	ret

00000000000053ec <dup>:
.global dup
dup:
 li a7, SYS_dup
    53ec:	48a9                	li	a7,10
 ecall
    53ee:	00000073          	ecall
 ret
    53f2:	8082                	ret

00000000000053f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    53f4:	48ad                	li	a7,11
 ecall
    53f6:	00000073          	ecall
 ret
    53fa:	8082                	ret

00000000000053fc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    53fc:	48b1                	li	a7,12
 ecall
    53fe:	00000073          	ecall
 ret
    5402:	8082                	ret

0000000000005404 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5404:	48b5                	li	a7,13
 ecall
    5406:	00000073          	ecall
 ret
    540a:	8082                	ret

000000000000540c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    540c:	48b9                	li	a7,14
 ecall
    540e:	00000073          	ecall
 ret
    5412:	8082                	ret

0000000000005414 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5414:	1101                	addi	sp,sp,-32
    5416:	ec06                	sd	ra,24(sp)
    5418:	e822                	sd	s0,16(sp)
    541a:	1000                	addi	s0,sp,32
    541c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5420:	4605                	li	a2,1
    5422:	fef40593          	addi	a1,s0,-17
    5426:	00000097          	auipc	ra,0x0
    542a:	f6e080e7          	jalr	-146(ra) # 5394 <write>
}
    542e:	60e2                	ld	ra,24(sp)
    5430:	6442                	ld	s0,16(sp)
    5432:	6105                	addi	sp,sp,32
    5434:	8082                	ret

0000000000005436 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5436:	7139                	addi	sp,sp,-64
    5438:	fc06                	sd	ra,56(sp)
    543a:	f822                	sd	s0,48(sp)
    543c:	f426                	sd	s1,40(sp)
    543e:	f04a                	sd	s2,32(sp)
    5440:	ec4e                	sd	s3,24(sp)
    5442:	0080                	addi	s0,sp,64
    5444:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5446:	c299                	beqz	a3,544c <printint+0x16>
    5448:	0805c863          	bltz	a1,54d8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    544c:	2581                	sext.w	a1,a1
  neg = 0;
    544e:	4881                	li	a7,0
    5450:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5454:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5456:	2601                	sext.w	a2,a2
    5458:	00003517          	auipc	a0,0x3
    545c:	a8850513          	addi	a0,a0,-1400 # 7ee0 <digits>
    5460:	883a                	mv	a6,a4
    5462:	2705                	addiw	a4,a4,1
    5464:	02c5f7bb          	remuw	a5,a1,a2
    5468:	1782                	slli	a5,a5,0x20
    546a:	9381                	srli	a5,a5,0x20
    546c:	97aa                	add	a5,a5,a0
    546e:	0007c783          	lbu	a5,0(a5)
    5472:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5476:	0005879b          	sext.w	a5,a1
    547a:	02c5d5bb          	divuw	a1,a1,a2
    547e:	0685                	addi	a3,a3,1
    5480:	fec7f0e3          	bgeu	a5,a2,5460 <printint+0x2a>
  if(neg)
    5484:	00088b63          	beqz	a7,549a <printint+0x64>
    buf[i++] = '-';
    5488:	fd040793          	addi	a5,s0,-48
    548c:	973e                	add	a4,a4,a5
    548e:	02d00793          	li	a5,45
    5492:	fef70823          	sb	a5,-16(a4)
    5496:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    549a:	02e05863          	blez	a4,54ca <printint+0x94>
    549e:	fc040793          	addi	a5,s0,-64
    54a2:	00e78933          	add	s2,a5,a4
    54a6:	fff78993          	addi	s3,a5,-1
    54aa:	99ba                	add	s3,s3,a4
    54ac:	377d                	addiw	a4,a4,-1
    54ae:	1702                	slli	a4,a4,0x20
    54b0:	9301                	srli	a4,a4,0x20
    54b2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    54b6:	fff94583          	lbu	a1,-1(s2)
    54ba:	8526                	mv	a0,s1
    54bc:	00000097          	auipc	ra,0x0
    54c0:	f58080e7          	jalr	-168(ra) # 5414 <putc>
  while(--i >= 0)
    54c4:	197d                	addi	s2,s2,-1
    54c6:	ff3918e3          	bne	s2,s3,54b6 <printint+0x80>
}
    54ca:	70e2                	ld	ra,56(sp)
    54cc:	7442                	ld	s0,48(sp)
    54ce:	74a2                	ld	s1,40(sp)
    54d0:	7902                	ld	s2,32(sp)
    54d2:	69e2                	ld	s3,24(sp)
    54d4:	6121                	addi	sp,sp,64
    54d6:	8082                	ret
    x = -xx;
    54d8:	40b005bb          	negw	a1,a1
    neg = 1;
    54dc:	4885                	li	a7,1
    x = -xx;
    54de:	bf8d                	j	5450 <printint+0x1a>

00000000000054e0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    54e0:	7119                	addi	sp,sp,-128
    54e2:	fc86                	sd	ra,120(sp)
    54e4:	f8a2                	sd	s0,112(sp)
    54e6:	f4a6                	sd	s1,104(sp)
    54e8:	f0ca                	sd	s2,96(sp)
    54ea:	ecce                	sd	s3,88(sp)
    54ec:	e8d2                	sd	s4,80(sp)
    54ee:	e4d6                	sd	s5,72(sp)
    54f0:	e0da                	sd	s6,64(sp)
    54f2:	fc5e                	sd	s7,56(sp)
    54f4:	f862                	sd	s8,48(sp)
    54f6:	f466                	sd	s9,40(sp)
    54f8:	f06a                	sd	s10,32(sp)
    54fa:	ec6e                	sd	s11,24(sp)
    54fc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    54fe:	0005c903          	lbu	s2,0(a1)
    5502:	18090f63          	beqz	s2,56a0 <vprintf+0x1c0>
    5506:	8aaa                	mv	s5,a0
    5508:	8b32                	mv	s6,a2
    550a:	00158493          	addi	s1,a1,1
  state = 0;
    550e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5510:	02500a13          	li	s4,37
      if(c == 'd'){
    5514:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    5518:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    551c:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    5520:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5524:	00003b97          	auipc	s7,0x3
    5528:	9bcb8b93          	addi	s7,s7,-1604 # 7ee0 <digits>
    552c:	a839                	j	554a <vprintf+0x6a>
        putc(fd, c);
    552e:	85ca                	mv	a1,s2
    5530:	8556                	mv	a0,s5
    5532:	00000097          	auipc	ra,0x0
    5536:	ee2080e7          	jalr	-286(ra) # 5414 <putc>
    553a:	a019                	j	5540 <vprintf+0x60>
    } else if(state == '%'){
    553c:	01498f63          	beq	s3,s4,555a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    5540:	0485                	addi	s1,s1,1
    5542:	fff4c903          	lbu	s2,-1(s1)
    5546:	14090d63          	beqz	s2,56a0 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    554a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    554e:	fe0997e3          	bnez	s3,553c <vprintf+0x5c>
      if(c == '%'){
    5552:	fd479ee3          	bne	a5,s4,552e <vprintf+0x4e>
        state = '%';
    5556:	89be                	mv	s3,a5
    5558:	b7e5                	j	5540 <vprintf+0x60>
      if(c == 'd'){
    555a:	05878063          	beq	a5,s8,559a <vprintf+0xba>
      } else if(c == 'l') {
    555e:	05978c63          	beq	a5,s9,55b6 <vprintf+0xd6>
      } else if(c == 'x') {
    5562:	07a78863          	beq	a5,s10,55d2 <vprintf+0xf2>
      } else if(c == 'p') {
    5566:	09b78463          	beq	a5,s11,55ee <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    556a:	07300713          	li	a4,115
    556e:	0ce78663          	beq	a5,a4,563a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    5572:	06300713          	li	a4,99
    5576:	0ee78e63          	beq	a5,a4,5672 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    557a:	11478863          	beq	a5,s4,568a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    557e:	85d2                	mv	a1,s4
    5580:	8556                	mv	a0,s5
    5582:	00000097          	auipc	ra,0x0
    5586:	e92080e7          	jalr	-366(ra) # 5414 <putc>
        putc(fd, c);
    558a:	85ca                	mv	a1,s2
    558c:	8556                	mv	a0,s5
    558e:	00000097          	auipc	ra,0x0
    5592:	e86080e7          	jalr	-378(ra) # 5414 <putc>
      }
      state = 0;
    5596:	4981                	li	s3,0
    5598:	b765                	j	5540 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    559a:	008b0913          	addi	s2,s6,8
    559e:	4685                	li	a3,1
    55a0:	4629                	li	a2,10
    55a2:	000b2583          	lw	a1,0(s6)
    55a6:	8556                	mv	a0,s5
    55a8:	00000097          	auipc	ra,0x0
    55ac:	e8e080e7          	jalr	-370(ra) # 5436 <printint>
    55b0:	8b4a                	mv	s6,s2
      state = 0;
    55b2:	4981                	li	s3,0
    55b4:	b771                	j	5540 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    55b6:	008b0913          	addi	s2,s6,8
    55ba:	4681                	li	a3,0
    55bc:	4629                	li	a2,10
    55be:	000b2583          	lw	a1,0(s6)
    55c2:	8556                	mv	a0,s5
    55c4:	00000097          	auipc	ra,0x0
    55c8:	e72080e7          	jalr	-398(ra) # 5436 <printint>
    55cc:	8b4a                	mv	s6,s2
      state = 0;
    55ce:	4981                	li	s3,0
    55d0:	bf85                	j	5540 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    55d2:	008b0913          	addi	s2,s6,8
    55d6:	4681                	li	a3,0
    55d8:	4641                	li	a2,16
    55da:	000b2583          	lw	a1,0(s6)
    55de:	8556                	mv	a0,s5
    55e0:	00000097          	auipc	ra,0x0
    55e4:	e56080e7          	jalr	-426(ra) # 5436 <printint>
    55e8:	8b4a                	mv	s6,s2
      state = 0;
    55ea:	4981                	li	s3,0
    55ec:	bf91                	j	5540 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    55ee:	008b0793          	addi	a5,s6,8
    55f2:	f8f43423          	sd	a5,-120(s0)
    55f6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    55fa:	03000593          	li	a1,48
    55fe:	8556                	mv	a0,s5
    5600:	00000097          	auipc	ra,0x0
    5604:	e14080e7          	jalr	-492(ra) # 5414 <putc>
  putc(fd, 'x');
    5608:	85ea                	mv	a1,s10
    560a:	8556                	mv	a0,s5
    560c:	00000097          	auipc	ra,0x0
    5610:	e08080e7          	jalr	-504(ra) # 5414 <putc>
    5614:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5616:	03c9d793          	srli	a5,s3,0x3c
    561a:	97de                	add	a5,a5,s7
    561c:	0007c583          	lbu	a1,0(a5)
    5620:	8556                	mv	a0,s5
    5622:	00000097          	auipc	ra,0x0
    5626:	df2080e7          	jalr	-526(ra) # 5414 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    562a:	0992                	slli	s3,s3,0x4
    562c:	397d                	addiw	s2,s2,-1
    562e:	fe0914e3          	bnez	s2,5616 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    5632:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    5636:	4981                	li	s3,0
    5638:	b721                	j	5540 <vprintf+0x60>
        s = va_arg(ap, char*);
    563a:	008b0993          	addi	s3,s6,8
    563e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    5642:	02090163          	beqz	s2,5664 <vprintf+0x184>
        while(*s != 0){
    5646:	00094583          	lbu	a1,0(s2)
    564a:	c9a1                	beqz	a1,569a <vprintf+0x1ba>
          putc(fd, *s);
    564c:	8556                	mv	a0,s5
    564e:	00000097          	auipc	ra,0x0
    5652:	dc6080e7          	jalr	-570(ra) # 5414 <putc>
          s++;
    5656:	0905                	addi	s2,s2,1
        while(*s != 0){
    5658:	00094583          	lbu	a1,0(s2)
    565c:	f9e5                	bnez	a1,564c <vprintf+0x16c>
        s = va_arg(ap, char*);
    565e:	8b4e                	mv	s6,s3
      state = 0;
    5660:	4981                	li	s3,0
    5662:	bdf9                	j	5540 <vprintf+0x60>
          s = "(null)";
    5664:	00003917          	auipc	s2,0x3
    5668:	87490913          	addi	s2,s2,-1932 # 7ed8 <malloc+0x272e>
        while(*s != 0){
    566c:	02800593          	li	a1,40
    5670:	bff1                	j	564c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    5672:	008b0913          	addi	s2,s6,8
    5676:	000b4583          	lbu	a1,0(s6)
    567a:	8556                	mv	a0,s5
    567c:	00000097          	auipc	ra,0x0
    5680:	d98080e7          	jalr	-616(ra) # 5414 <putc>
    5684:	8b4a                	mv	s6,s2
      state = 0;
    5686:	4981                	li	s3,0
    5688:	bd65                	j	5540 <vprintf+0x60>
        putc(fd, c);
    568a:	85d2                	mv	a1,s4
    568c:	8556                	mv	a0,s5
    568e:	00000097          	auipc	ra,0x0
    5692:	d86080e7          	jalr	-634(ra) # 5414 <putc>
      state = 0;
    5696:	4981                	li	s3,0
    5698:	b565                	j	5540 <vprintf+0x60>
        s = va_arg(ap, char*);
    569a:	8b4e                	mv	s6,s3
      state = 0;
    569c:	4981                	li	s3,0
    569e:	b54d                	j	5540 <vprintf+0x60>
    }
  }
}
    56a0:	70e6                	ld	ra,120(sp)
    56a2:	7446                	ld	s0,112(sp)
    56a4:	74a6                	ld	s1,104(sp)
    56a6:	7906                	ld	s2,96(sp)
    56a8:	69e6                	ld	s3,88(sp)
    56aa:	6a46                	ld	s4,80(sp)
    56ac:	6aa6                	ld	s5,72(sp)
    56ae:	6b06                	ld	s6,64(sp)
    56b0:	7be2                	ld	s7,56(sp)
    56b2:	7c42                	ld	s8,48(sp)
    56b4:	7ca2                	ld	s9,40(sp)
    56b6:	7d02                	ld	s10,32(sp)
    56b8:	6de2                	ld	s11,24(sp)
    56ba:	6109                	addi	sp,sp,128
    56bc:	8082                	ret

00000000000056be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    56be:	715d                	addi	sp,sp,-80
    56c0:	ec06                	sd	ra,24(sp)
    56c2:	e822                	sd	s0,16(sp)
    56c4:	1000                	addi	s0,sp,32
    56c6:	e010                	sd	a2,0(s0)
    56c8:	e414                	sd	a3,8(s0)
    56ca:	e818                	sd	a4,16(s0)
    56cc:	ec1c                	sd	a5,24(s0)
    56ce:	03043023          	sd	a6,32(s0)
    56d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    56d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    56da:	8622                	mv	a2,s0
    56dc:	00000097          	auipc	ra,0x0
    56e0:	e04080e7          	jalr	-508(ra) # 54e0 <vprintf>
}
    56e4:	60e2                	ld	ra,24(sp)
    56e6:	6442                	ld	s0,16(sp)
    56e8:	6161                	addi	sp,sp,80
    56ea:	8082                	ret

00000000000056ec <printf>:

void
printf(const char *fmt, ...)
{
    56ec:	711d                	addi	sp,sp,-96
    56ee:	ec06                	sd	ra,24(sp)
    56f0:	e822                	sd	s0,16(sp)
    56f2:	1000                	addi	s0,sp,32
    56f4:	e40c                	sd	a1,8(s0)
    56f6:	e810                	sd	a2,16(s0)
    56f8:	ec14                	sd	a3,24(s0)
    56fa:	f018                	sd	a4,32(s0)
    56fc:	f41c                	sd	a5,40(s0)
    56fe:	03043823          	sd	a6,48(s0)
    5702:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5706:	00840613          	addi	a2,s0,8
    570a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    570e:	85aa                	mv	a1,a0
    5710:	4505                	li	a0,1
    5712:	00000097          	auipc	ra,0x0
    5716:	dce080e7          	jalr	-562(ra) # 54e0 <vprintf>
}
    571a:	60e2                	ld	ra,24(sp)
    571c:	6442                	ld	s0,16(sp)
    571e:	6125                	addi	sp,sp,96
    5720:	8082                	ret

0000000000005722 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5722:	1141                	addi	sp,sp,-16
    5724:	e422                	sd	s0,8(sp)
    5726:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5728:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    572c:	00002797          	auipc	a5,0x2
    5730:	7e47b783          	ld	a5,2020(a5) # 7f10 <freep>
    5734:	a805                	j	5764 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5736:	4618                	lw	a4,8(a2)
    5738:	9db9                	addw	a1,a1,a4
    573a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    573e:	6398                	ld	a4,0(a5)
    5740:	6318                	ld	a4,0(a4)
    5742:	fee53823          	sd	a4,-16(a0)
    5746:	a091                	j	578a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5748:	ff852703          	lw	a4,-8(a0)
    574c:	9e39                	addw	a2,a2,a4
    574e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    5750:	ff053703          	ld	a4,-16(a0)
    5754:	e398                	sd	a4,0(a5)
    5756:	a099                	j	579c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5758:	6398                	ld	a4,0(a5)
    575a:	00e7e463          	bltu	a5,a4,5762 <free+0x40>
    575e:	00e6ea63          	bltu	a3,a4,5772 <free+0x50>
{
    5762:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5764:	fed7fae3          	bgeu	a5,a3,5758 <free+0x36>
    5768:	6398                	ld	a4,0(a5)
    576a:	00e6e463          	bltu	a3,a4,5772 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    576e:	fee7eae3          	bltu	a5,a4,5762 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    5772:	ff852583          	lw	a1,-8(a0)
    5776:	6390                	ld	a2,0(a5)
    5778:	02059713          	slli	a4,a1,0x20
    577c:	9301                	srli	a4,a4,0x20
    577e:	0712                	slli	a4,a4,0x4
    5780:	9736                	add	a4,a4,a3
    5782:	fae60ae3          	beq	a2,a4,5736 <free+0x14>
    bp->s.ptr = p->s.ptr;
    5786:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    578a:	4790                	lw	a2,8(a5)
    578c:	02061713          	slli	a4,a2,0x20
    5790:	9301                	srli	a4,a4,0x20
    5792:	0712                	slli	a4,a4,0x4
    5794:	973e                	add	a4,a4,a5
    5796:	fae689e3          	beq	a3,a4,5748 <free+0x26>
  } else
    p->s.ptr = bp;
    579a:	e394                	sd	a3,0(a5)
  freep = p;
    579c:	00002717          	auipc	a4,0x2
    57a0:	76f73a23          	sd	a5,1908(a4) # 7f10 <freep>
}
    57a4:	6422                	ld	s0,8(sp)
    57a6:	0141                	addi	sp,sp,16
    57a8:	8082                	ret

00000000000057aa <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    57aa:	7139                	addi	sp,sp,-64
    57ac:	fc06                	sd	ra,56(sp)
    57ae:	f822                	sd	s0,48(sp)
    57b0:	f426                	sd	s1,40(sp)
    57b2:	f04a                	sd	s2,32(sp)
    57b4:	ec4e                	sd	s3,24(sp)
    57b6:	e852                	sd	s4,16(sp)
    57b8:	e456                	sd	s5,8(sp)
    57ba:	e05a                	sd	s6,0(sp)
    57bc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    57be:	02051493          	slli	s1,a0,0x20
    57c2:	9081                	srli	s1,s1,0x20
    57c4:	04bd                	addi	s1,s1,15
    57c6:	8091                	srli	s1,s1,0x4
    57c8:	0014899b          	addiw	s3,s1,1
    57cc:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    57ce:	00002517          	auipc	a0,0x2
    57d2:	74253503          	ld	a0,1858(a0) # 7f10 <freep>
    57d6:	c515                	beqz	a0,5802 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    57d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    57da:	4798                	lw	a4,8(a5)
    57dc:	02977f63          	bgeu	a4,s1,581a <malloc+0x70>
    57e0:	8a4e                	mv	s4,s3
    57e2:	0009871b          	sext.w	a4,s3
    57e6:	6685                	lui	a3,0x1
    57e8:	00d77363          	bgeu	a4,a3,57ee <malloc+0x44>
    57ec:	6a05                	lui	s4,0x1
    57ee:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    57f2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    57f6:	00002917          	auipc	s2,0x2
    57fa:	71a90913          	addi	s2,s2,1818 # 7f10 <freep>
  if(p == (char*)-1)
    57fe:	5afd                	li	s5,-1
    5800:	a88d                	j	5872 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    5802:	00009797          	auipc	a5,0x9
    5806:	f2e78793          	addi	a5,a5,-210 # e730 <base>
    580a:	00002717          	auipc	a4,0x2
    580e:	70f73323          	sd	a5,1798(a4) # 7f10 <freep>
    5812:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5814:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5818:	b7e1                	j	57e0 <malloc+0x36>
      if(p->s.size == nunits)
    581a:	02e48b63          	beq	s1,a4,5850 <malloc+0xa6>
        p->s.size -= nunits;
    581e:	4137073b          	subw	a4,a4,s3
    5822:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5824:	1702                	slli	a4,a4,0x20
    5826:	9301                	srli	a4,a4,0x20
    5828:	0712                	slli	a4,a4,0x4
    582a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    582c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5830:	00002717          	auipc	a4,0x2
    5834:	6ea73023          	sd	a0,1760(a4) # 7f10 <freep>
      return (void*)(p + 1);
    5838:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    583c:	70e2                	ld	ra,56(sp)
    583e:	7442                	ld	s0,48(sp)
    5840:	74a2                	ld	s1,40(sp)
    5842:	7902                	ld	s2,32(sp)
    5844:	69e2                	ld	s3,24(sp)
    5846:	6a42                	ld	s4,16(sp)
    5848:	6aa2                	ld	s5,8(sp)
    584a:	6b02                	ld	s6,0(sp)
    584c:	6121                	addi	sp,sp,64
    584e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    5850:	6398                	ld	a4,0(a5)
    5852:	e118                	sd	a4,0(a0)
    5854:	bff1                	j	5830 <malloc+0x86>
  hp->s.size = nu;
    5856:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    585a:	0541                	addi	a0,a0,16
    585c:	00000097          	auipc	ra,0x0
    5860:	ec6080e7          	jalr	-314(ra) # 5722 <free>
  return freep;
    5864:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    5868:	d971                	beqz	a0,583c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    586a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    586c:	4798                	lw	a4,8(a5)
    586e:	fa9776e3          	bgeu	a4,s1,581a <malloc+0x70>
    if(p == freep)
    5872:	00093703          	ld	a4,0(s2)
    5876:	853e                	mv	a0,a5
    5878:	fef719e3          	bne	a4,a5,586a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    587c:	8552                	mv	a0,s4
    587e:	00000097          	auipc	ra,0x0
    5882:	b7e080e7          	jalr	-1154(ra) # 53fc <sbrk>
  if(p == (char*)-1)
    5886:	fd5518e3          	bne	a0,s5,5856 <malloc+0xac>
        return 0;
    588a:	4501                	li	a0,0
    588c:	bf45                	j	583c <malloc+0x92>
