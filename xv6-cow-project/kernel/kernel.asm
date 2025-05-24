
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	12013103          	ld	sp,288(sp) # 8000b120 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1f9050ef          	jal	80005a0e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7179                	addi	sp,sp,-48
    8000001e:	f406                	sd	ra,40(sp)
    80000020:	f022                	sd	s0,32(sp)
    80000022:	ec26                	sd	s1,24(sp)
    80000024:	e84a                	sd	s2,16(sp)
    80000026:	1800                	addi	s0,sp,48
    80000028:	892a                	mv	s2,a0
  acquire(&ref_c.lock);
    8000002a:	0000c517          	auipc	a0,0xc
    8000002e:	02650513          	addi	a0,a0,38 # 8000c050 <ref_c>
    80000032:	00006097          	auipc	ra,0x6
    80000036:	424080e7          	jalr	1060(ra) # 80006456 <acquire>
  // decrease reference_count by 1
  ref_c.reference_count[(uint64)pa/PGSIZE]--;
    8000003a:	00c95493          	srli	s1,s2,0xc
    8000003e:	0000c517          	auipc	a0,0xc
    80000042:	01250513          	addi	a0,a0,18 # 8000c050 <ref_c>
    80000046:	0491                	addi	s1,s1,4
    80000048:	048a                	slli	s1,s1,0x2
    8000004a:	94aa                	add	s1,s1,a0
    8000004c:	449c                	lw	a5,8(s1)
    8000004e:	37fd                	addiw	a5,a5,-1
    80000050:	c49c                	sw	a5,8(s1)
  release(&ref_c.lock);
    80000052:	00006097          	auipc	ra,0x6
    80000056:	4b8080e7          	jalr	1208(ra) # 8000650a <release>

  // if no-one uses it
  if(ref_c.reference_count[(uint64)pa/PGSIZE] == 0)
    8000005a:	449c                	lw	a5,8(s1)
    8000005c:	ebb1                	bnez	a5,800000b0 <kfree+0x94>
    8000005e:	e44e                	sd	s3,8(sp)
  {
    struct run *r;

    if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000060:	03491793          	slli	a5,s2,0x34
    80000064:	efa1                	bnez	a5,800000bc <kfree+0xa0>
    80000066:	00249797          	auipc	a5,0x249
    8000006a:	1da78793          	addi	a5,a5,474 # 80249240 <end>
    8000006e:	04f96763          	bltu	s2,a5,800000bc <kfree+0xa0>
    80000072:	47c5                	li	a5,17
    80000074:	07ee                	slli	a5,a5,0x1b
    80000076:	04f97363          	bgeu	s2,a5,800000bc <kfree+0xa0>
        panic("kfree");

    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);
    8000007a:	6605                	lui	a2,0x1
    8000007c:	4585                	li	a1,1
    8000007e:	854a                	mv	a0,s2
    80000080:	00000097          	auipc	ra,0x0
    80000084:	1b0080e7          	jalr	432(ra) # 80000230 <memset>

    r = (struct run*)pa;

    acquire(&kmem.lock);
    80000088:	0000c497          	auipc	s1,0xc
    8000008c:	fa848493          	addi	s1,s1,-88 # 8000c030 <kmem>
    80000090:	8526                	mv	a0,s1
    80000092:	00006097          	auipc	ra,0x6
    80000096:	3c4080e7          	jalr	964(ra) # 80006456 <acquire>
    r->next = kmem.freelist;
    8000009a:	6c9c                	ld	a5,24(s1)
    8000009c:	00f93023          	sd	a5,0(s2)
    kmem.freelist = r;
    800000a0:	0124bc23          	sd	s2,24(s1)
    release(&kmem.lock);
    800000a4:	8526                	mv	a0,s1
    800000a6:	00006097          	auipc	ra,0x6
    800000aa:	464080e7          	jalr	1124(ra) # 8000650a <release>
    800000ae:	69a2                	ld	s3,8(sp)
  }
}
    800000b0:	70a2                	ld	ra,40(sp)
    800000b2:	7402                	ld	s0,32(sp)
    800000b4:	64e2                	ld	s1,24(sp)
    800000b6:	6942                	ld	s2,16(sp)
    800000b8:	6145                	addi	sp,sp,48
    800000ba:	8082                	ret
        panic("kfree");
    800000bc:	00008517          	auipc	a0,0x8
    800000c0:	f4450513          	addi	a0,a0,-188 # 80008000 <etext>
    800000c4:	00006097          	auipc	ra,0x6
    800000c8:	e18080e7          	jalr	-488(ra) # 80005edc <panic>

00000000800000cc <freerange>:
{
    800000cc:	7139                	addi	sp,sp,-64
    800000ce:	fc06                	sd	ra,56(sp)
    800000d0:	f822                	sd	s0,48(sp)
    800000d2:	f426                	sd	s1,40(sp)
    800000d4:	0080                	addi	s0,sp,64
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000d6:	6785                	lui	a5,0x1
    800000d8:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000dc:	953a                	add	a0,a0,a4
    800000de:	777d                	lui	a4,0xfffff
    800000e0:	00e574b3          	and	s1,a0,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000e4:	97a6                	add	a5,a5,s1
    800000e6:	04f5ef63          	bltu	a1,a5,80000144 <freerange+0x78>
    800000ea:	f04a                	sd	s2,32(sp)
    800000ec:	ec4e                	sd	s3,24(sp)
    800000ee:	e852                	sd	s4,16(sp)
    800000f0:	e456                	sd	s5,8(sp)
    800000f2:	e05a                	sd	s6,0(sp)
    800000f4:	89ae                	mv	s3,a1
    acquire(&ref_c.lock);
    800000f6:	0000c917          	auipc	s2,0xc
    800000fa:	f5a90913          	addi	s2,s2,-166 # 8000c050 <ref_c>
    ref_c.reference_count[(uint64)p/PGSIZE] = 1;
    800000fe:	4b05                	li	s6,1
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000100:	6a85                	lui	s5,0x1
    80000102:	6a09                	lui	s4,0x2
    acquire(&ref_c.lock);
    80000104:	854a                	mv	a0,s2
    80000106:	00006097          	auipc	ra,0x6
    8000010a:	350080e7          	jalr	848(ra) # 80006456 <acquire>
    ref_c.reference_count[(uint64)p/PGSIZE] = 1;
    8000010e:	00c4d793          	srli	a5,s1,0xc
    80000112:	0791                	addi	a5,a5,4
    80000114:	078a                	slli	a5,a5,0x2
    80000116:	97ca                	add	a5,a5,s2
    80000118:	0167a423          	sw	s6,8(a5)
    release(&ref_c.lock);
    8000011c:	854a                	mv	a0,s2
    8000011e:	00006097          	auipc	ra,0x6
    80000122:	3ec080e7          	jalr	1004(ra) # 8000650a <release>
    kfree(p);
    80000126:	8526                	mv	a0,s1
    80000128:	00000097          	auipc	ra,0x0
    8000012c:	ef4080e7          	jalr	-268(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000130:	87a6                	mv	a5,s1
    80000132:	94d6                	add	s1,s1,s5
    80000134:	97d2                	add	a5,a5,s4
    80000136:	fcf9f7e3          	bgeu	s3,a5,80000104 <freerange+0x38>
    8000013a:	7902                	ld	s2,32(sp)
    8000013c:	69e2                	ld	s3,24(sp)
    8000013e:	6a42                	ld	s4,16(sp)
    80000140:	6aa2                	ld	s5,8(sp)
    80000142:	6b02                	ld	s6,0(sp)
}
    80000144:	70e2                	ld	ra,56(sp)
    80000146:	7442                	ld	s0,48(sp)
    80000148:	74a2                	ld	s1,40(sp)
    8000014a:	6121                	addi	sp,sp,64
    8000014c:	8082                	ret

000000008000014e <kinit>:
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000156:	00008597          	auipc	a1,0x8
    8000015a:	eba58593          	addi	a1,a1,-326 # 80008010 <etext+0x10>
    8000015e:	0000c517          	auipc	a0,0xc
    80000162:	ed250513          	addi	a0,a0,-302 # 8000c030 <kmem>
    80000166:	00006097          	auipc	ra,0x6
    8000016a:	260080e7          	jalr	608(ra) # 800063c6 <initlock>
  initlock(&ref_c.lock, "ref_c");
    8000016e:	00008597          	auipc	a1,0x8
    80000172:	eaa58593          	addi	a1,a1,-342 # 80008018 <etext+0x18>
    80000176:	0000c517          	auipc	a0,0xc
    8000017a:	eda50513          	addi	a0,a0,-294 # 8000c050 <ref_c>
    8000017e:	00006097          	auipc	ra,0x6
    80000182:	248080e7          	jalr	584(ra) # 800063c6 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000186:	45c5                	li	a1,17
    80000188:	05ee                	slli	a1,a1,0x1b
    8000018a:	00249517          	auipc	a0,0x249
    8000018e:	0b650513          	addi	a0,a0,182 # 80249240 <end>
    80000192:	00000097          	auipc	ra,0x0
    80000196:	f3a080e7          	jalr	-198(ra) # 800000cc <freerange>
}
    8000019a:	60a2                	ld	ra,8(sp)
    8000019c:	6402                	ld	s0,0(sp)
    8000019e:	0141                	addi	sp,sp,16
    800001a0:	8082                	ret

00000000800001a2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800001a2:	1101                	addi	sp,sp,-32
    800001a4:	ec06                	sd	ra,24(sp)
    800001a6:	e822                	sd	s0,16(sp)
    800001a8:	e426                	sd	s1,8(sp)
    800001aa:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001ac:	0000c497          	auipc	s1,0xc
    800001b0:	e8448493          	addi	s1,s1,-380 # 8000c030 <kmem>
    800001b4:	8526                	mv	a0,s1
    800001b6:	00006097          	auipc	ra,0x6
    800001ba:	2a0080e7          	jalr	672(ra) # 80006456 <acquire>
  r = kmem.freelist;
    800001be:	6c84                	ld	s1,24(s1)
  if(r)
    800001c0:	ccb9                	beqz	s1,8000021e <kalloc+0x7c>
    kmem.freelist = r->next;
    800001c2:	609c                	ld	a5,0(s1)
    800001c4:	0000c517          	auipc	a0,0xc
    800001c8:	e6c50513          	addi	a0,a0,-404 # 8000c030 <kmem>
    800001cc:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    800001ce:	00006097          	auipc	ra,0x6
    800001d2:	33c080e7          	jalr	828(ra) # 8000650a <release>

  if(r)
  {
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001d6:	6605                	lui	a2,0x1
    800001d8:	4595                	li	a1,5
    800001da:	8526                	mv	a0,s1
    800001dc:	00000097          	auipc	ra,0x0
    800001e0:	054080e7          	jalr	84(ra) # 80000230 <memset>
    acquire(&ref_c.lock);
    800001e4:	0000c517          	auipc	a0,0xc
    800001e8:	e6c50513          	addi	a0,a0,-404 # 8000c050 <ref_c>
    800001ec:	00006097          	auipc	ra,0x6
    800001f0:	26a080e7          	jalr	618(ra) # 80006456 <acquire>
    // set reference_count to 1
    ref_c.reference_count[(uint64)r/PGSIZE] = 1;
    800001f4:	0000c517          	auipc	a0,0xc
    800001f8:	e5c50513          	addi	a0,a0,-420 # 8000c050 <ref_c>
    800001fc:	00c4d793          	srli	a5,s1,0xc
    80000200:	0791                	addi	a5,a5,4
    80000202:	078a                	slli	a5,a5,0x2
    80000204:	97aa                	add	a5,a5,a0
    80000206:	4705                	li	a4,1
    80000208:	c798                	sw	a4,8(a5)
    release(&ref_c.lock);
    8000020a:	00006097          	auipc	ra,0x6
    8000020e:	300080e7          	jalr	768(ra) # 8000650a <release>
  }

  return (void*)r;
}
    80000212:	8526                	mv	a0,s1
    80000214:	60e2                	ld	ra,24(sp)
    80000216:	6442                	ld	s0,16(sp)
    80000218:	64a2                	ld	s1,8(sp)
    8000021a:	6105                	addi	sp,sp,32
    8000021c:	8082                	ret
  release(&kmem.lock);
    8000021e:	0000c517          	auipc	a0,0xc
    80000222:	e1250513          	addi	a0,a0,-494 # 8000c030 <kmem>
    80000226:	00006097          	auipc	ra,0x6
    8000022a:	2e4080e7          	jalr	740(ra) # 8000650a <release>
  if(r)
    8000022e:	b7d5                	j	80000212 <kalloc+0x70>

0000000080000230 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000230:	1141                	addi	sp,sp,-16
    80000232:	e422                	sd	s0,8(sp)
    80000234:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000236:	ca19                	beqz	a2,8000024c <memset+0x1c>
    80000238:	87aa                	mv	a5,a0
    8000023a:	1602                	slli	a2,a2,0x20
    8000023c:	9201                	srli	a2,a2,0x20
    8000023e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000242:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000246:	0785                	addi	a5,a5,1
    80000248:	fee79de3          	bne	a5,a4,80000242 <memset+0x12>
  }
  return dst;
}
    8000024c:	6422                	ld	s0,8(sp)
    8000024e:	0141                	addi	sp,sp,16
    80000250:	8082                	ret

0000000080000252 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000252:	1141                	addi	sp,sp,-16
    80000254:	e422                	sd	s0,8(sp)
    80000256:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000258:	ca05                	beqz	a2,80000288 <memcmp+0x36>
    8000025a:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    8000025e:	1682                	slli	a3,a3,0x20
    80000260:	9281                	srli	a3,a3,0x20
    80000262:	0685                	addi	a3,a3,1
    80000264:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000266:	00054783          	lbu	a5,0(a0)
    8000026a:	0005c703          	lbu	a4,0(a1)
    8000026e:	00e79863          	bne	a5,a4,8000027e <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000272:	0505                	addi	a0,a0,1
    80000274:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000276:	fed518e3          	bne	a0,a3,80000266 <memcmp+0x14>
  }

  return 0;
    8000027a:	4501                	li	a0,0
    8000027c:	a019                	j	80000282 <memcmp+0x30>
      return *s1 - *s2;
    8000027e:	40e7853b          	subw	a0,a5,a4
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
  return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <memcmp+0x30>

000000008000028c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000292:	c205                	beqz	a2,800002b2 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000294:	02a5e263          	bltu	a1,a0,800002b8 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000298:	1602                	slli	a2,a2,0x20
    8000029a:	9201                	srli	a2,a2,0x20
    8000029c:	00c587b3          	add	a5,a1,a2
{
    800002a0:	872a                	mv	a4,a0
      *d++ = *s++;
    800002a2:	0585                	addi	a1,a1,1
    800002a4:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fdb5dc1>
    800002a6:	fff5c683          	lbu	a3,-1(a1)
    800002aa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002ae:	feb79ae3          	bne	a5,a1,800002a2 <memmove+0x16>

  return dst;
}
    800002b2:	6422                	ld	s0,8(sp)
    800002b4:	0141                	addi	sp,sp,16
    800002b6:	8082                	ret
  if(s < d && s + n > d){
    800002b8:	02061693          	slli	a3,a2,0x20
    800002bc:	9281                	srli	a3,a3,0x20
    800002be:	00d58733          	add	a4,a1,a3
    800002c2:	fce57be3          	bgeu	a0,a4,80000298 <memmove+0xc>
    d += n;
    800002c6:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002c8:	fff6079b          	addiw	a5,a2,-1
    800002cc:	1782                	slli	a5,a5,0x20
    800002ce:	9381                	srli	a5,a5,0x20
    800002d0:	fff7c793          	not	a5,a5
    800002d4:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002d6:	177d                	addi	a4,a4,-1
    800002d8:	16fd                	addi	a3,a3,-1
    800002da:	00074603          	lbu	a2,0(a4)
    800002de:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002e2:	fef71ae3          	bne	a4,a5,800002d6 <memmove+0x4a>
    800002e6:	b7f1                	j	800002b2 <memmove+0x26>

00000000800002e8 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002f0:	00000097          	auipc	ra,0x0
    800002f4:	f9c080e7          	jalr	-100(ra) # 8000028c <memmove>
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret

0000000080000300 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000300:	1141                	addi	sp,sp,-16
    80000302:	e422                	sd	s0,8(sp)
    80000304:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000306:	ce11                	beqz	a2,80000322 <strncmp+0x22>
    80000308:	00054783          	lbu	a5,0(a0)
    8000030c:	cf89                	beqz	a5,80000326 <strncmp+0x26>
    8000030e:	0005c703          	lbu	a4,0(a1)
    80000312:	00f71a63          	bne	a4,a5,80000326 <strncmp+0x26>
    n--, p++, q++;
    80000316:	367d                	addiw	a2,a2,-1
    80000318:	0505                	addi	a0,a0,1
    8000031a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000031c:	f675                	bnez	a2,80000308 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000031e:	4501                	li	a0,0
    80000320:	a801                	j	80000330 <strncmp+0x30>
    80000322:	4501                	li	a0,0
    80000324:	a031                	j	80000330 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000326:	00054503          	lbu	a0,0(a0)
    8000032a:	0005c783          	lbu	a5,0(a1)
    8000032e:	9d1d                	subw	a0,a0,a5
}
    80000330:	6422                	ld	s0,8(sp)
    80000332:	0141                	addi	sp,sp,16
    80000334:	8082                	ret

0000000080000336 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000336:	1141                	addi	sp,sp,-16
    80000338:	e422                	sd	s0,8(sp)
    8000033a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    8000033c:	87aa                	mv	a5,a0
    8000033e:	86b2                	mv	a3,a2
    80000340:	367d                	addiw	a2,a2,-1
    80000342:	02d05563          	blez	a3,8000036c <strncpy+0x36>
    80000346:	0785                	addi	a5,a5,1
    80000348:	0005c703          	lbu	a4,0(a1)
    8000034c:	fee78fa3          	sb	a4,-1(a5)
    80000350:	0585                	addi	a1,a1,1
    80000352:	f775                	bnez	a4,8000033e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000354:	873e                	mv	a4,a5
    80000356:	9fb5                	addw	a5,a5,a3
    80000358:	37fd                	addiw	a5,a5,-1
    8000035a:	00c05963          	blez	a2,8000036c <strncpy+0x36>
    *s++ = 0;
    8000035e:	0705                	addi	a4,a4,1
    80000360:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000364:	40e786bb          	subw	a3,a5,a4
    80000368:	fed04be3          	bgtz	a3,8000035e <strncpy+0x28>
  return os;
}
    8000036c:	6422                	ld	s0,8(sp)
    8000036e:	0141                	addi	sp,sp,16
    80000370:	8082                	ret

0000000080000372 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000372:	1141                	addi	sp,sp,-16
    80000374:	e422                	sd	s0,8(sp)
    80000376:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000378:	02c05363          	blez	a2,8000039e <safestrcpy+0x2c>
    8000037c:	fff6069b          	addiw	a3,a2,-1
    80000380:	1682                	slli	a3,a3,0x20
    80000382:	9281                	srli	a3,a3,0x20
    80000384:	96ae                	add	a3,a3,a1
    80000386:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000388:	00d58963          	beq	a1,a3,8000039a <safestrcpy+0x28>
    8000038c:	0585                	addi	a1,a1,1
    8000038e:	0785                	addi	a5,a5,1
    80000390:	fff5c703          	lbu	a4,-1(a1)
    80000394:	fee78fa3          	sb	a4,-1(a5)
    80000398:	fb65                	bnez	a4,80000388 <safestrcpy+0x16>
    ;
  *s = 0;
    8000039a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000039e:	6422                	ld	s0,8(sp)
    800003a0:	0141                	addi	sp,sp,16
    800003a2:	8082                	ret

00000000800003a4 <strlen>:

int
strlen(const char *s)
{
    800003a4:	1141                	addi	sp,sp,-16
    800003a6:	e422                	sd	s0,8(sp)
    800003a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003aa:	00054783          	lbu	a5,0(a0)
    800003ae:	cf91                	beqz	a5,800003ca <strlen+0x26>
    800003b0:	0505                	addi	a0,a0,1
    800003b2:	87aa                	mv	a5,a0
    800003b4:	86be                	mv	a3,a5
    800003b6:	0785                	addi	a5,a5,1
    800003b8:	fff7c703          	lbu	a4,-1(a5)
    800003bc:	ff65                	bnez	a4,800003b4 <strlen+0x10>
    800003be:	40a6853b          	subw	a0,a3,a0
    800003c2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800003c4:	6422                	ld	s0,8(sp)
    800003c6:	0141                	addi	sp,sp,16
    800003c8:	8082                	ret
  for(n = 0; s[n]; n++)
    800003ca:	4501                	li	a0,0
    800003cc:	bfe5                	j	800003c4 <strlen+0x20>

00000000800003ce <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003ce:	1141                	addi	sp,sp,-16
    800003d0:	e406                	sd	ra,8(sp)
    800003d2:	e022                	sd	s0,0(sp)
    800003d4:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800003d6:	00001097          	auipc	ra,0x1
    800003da:	c66080e7          	jalr	-922(ra) # 8000103c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800003de:	0000c717          	auipc	a4,0xc
    800003e2:	c2270713          	addi	a4,a4,-990 # 8000c000 <started>
  if(cpuid() == 0){
    800003e6:	c139                	beqz	a0,8000042c <main+0x5e>
    while(started == 0)
    800003e8:	431c                	lw	a5,0(a4)
    800003ea:	2781                	sext.w	a5,a5
    800003ec:	dff5                	beqz	a5,800003e8 <main+0x1a>
      ;
    __sync_synchronize();
    800003ee:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800003f2:	00001097          	auipc	ra,0x1
    800003f6:	c4a080e7          	jalr	-950(ra) # 8000103c <cpuid>
    800003fa:	85aa                	mv	a1,a0
    800003fc:	00008517          	auipc	a0,0x8
    80000400:	c4450513          	addi	a0,a0,-956 # 80008040 <etext+0x40>
    80000404:	00006097          	auipc	ra,0x6
    80000408:	b22080e7          	jalr	-1246(ra) # 80005f26 <printf>
    kvminithart();    // turn on paging
    8000040c:	00000097          	auipc	ra,0x0
    80000410:	0d8080e7          	jalr	216(ra) # 800004e4 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000414:	00002097          	auipc	ra,0x2
    80000418:	8ac080e7          	jalr	-1876(ra) # 80001cc0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	fa8080e7          	jalr	-88(ra) # 800053c4 <plicinithart>
  }

  scheduler();        
    80000424:	00001097          	auipc	ra,0x1
    80000428:	158080e7          	jalr	344(ra) # 8000157c <scheduler>
    consoleinit();
    8000042c:	00006097          	auipc	ra,0x6
    80000430:	9c0080e7          	jalr	-1600(ra) # 80005dec <consoleinit>
    printfinit();
    80000434:	00006097          	auipc	ra,0x6
    80000438:	cfa080e7          	jalr	-774(ra) # 8000612e <printfinit>
    printf("\n");
    8000043c:	00008517          	auipc	a0,0x8
    80000440:	be450513          	addi	a0,a0,-1052 # 80008020 <etext+0x20>
    80000444:	00006097          	auipc	ra,0x6
    80000448:	ae2080e7          	jalr	-1310(ra) # 80005f26 <printf>
    printf("xv6 kernel is booting\n");
    8000044c:	00008517          	auipc	a0,0x8
    80000450:	bdc50513          	addi	a0,a0,-1060 # 80008028 <etext+0x28>
    80000454:	00006097          	auipc	ra,0x6
    80000458:	ad2080e7          	jalr	-1326(ra) # 80005f26 <printf>
    printf("\n");
    8000045c:	00008517          	auipc	a0,0x8
    80000460:	bc450513          	addi	a0,a0,-1084 # 80008020 <etext+0x20>
    80000464:	00006097          	auipc	ra,0x6
    80000468:	ac2080e7          	jalr	-1342(ra) # 80005f26 <printf>
    kinit();         // physical page allocator
    8000046c:	00000097          	auipc	ra,0x0
    80000470:	ce2080e7          	jalr	-798(ra) # 8000014e <kinit>
    kvminit();       // create kernel page table
    80000474:	00000097          	auipc	ra,0x0
    80000478:	322080e7          	jalr	802(ra) # 80000796 <kvminit>
    kvminithart();   // turn on paging
    8000047c:	00000097          	auipc	ra,0x0
    80000480:	068080e7          	jalr	104(ra) # 800004e4 <kvminithart>
    procinit();      // process table
    80000484:	00001097          	auipc	ra,0x1
    80000488:	afa080e7          	jalr	-1286(ra) # 80000f7e <procinit>
    trapinit();      // trap vectors
    8000048c:	00002097          	auipc	ra,0x2
    80000490:	80c080e7          	jalr	-2036(ra) # 80001c98 <trapinit>
    trapinithart();  // install kernel trap vector
    80000494:	00002097          	auipc	ra,0x2
    80000498:	82c080e7          	jalr	-2004(ra) # 80001cc0 <trapinithart>
    plicinit();      // set up interrupt controller
    8000049c:	00005097          	auipc	ra,0x5
    800004a0:	f0e080e7          	jalr	-242(ra) # 800053aa <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004a4:	00005097          	auipc	ra,0x5
    800004a8:	f20080e7          	jalr	-224(ra) # 800053c4 <plicinithart>
    binit();         // buffer cache
    800004ac:	00002097          	auipc	ra,0x2
    800004b0:	034080e7          	jalr	52(ra) # 800024e0 <binit>
    iinit();         // inode table
    800004b4:	00002097          	auipc	ra,0x2
    800004b8:	6c0080e7          	jalr	1728(ra) # 80002b74 <iinit>
    fileinit();      // file table
    800004bc:	00003097          	auipc	ra,0x3
    800004c0:	664080e7          	jalr	1636(ra) # 80003b20 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004c4:	00005097          	auipc	ra,0x5
    800004c8:	020080e7          	jalr	32(ra) # 800054e4 <virtio_disk_init>
    userinit();      // first user process
    800004cc:	00001097          	auipc	ra,0x1
    800004d0:	e74080e7          	jalr	-396(ra) # 80001340 <userinit>
    __sync_synchronize();
    800004d4:	0330000f          	fence	rw,rw
    started = 1;
    800004d8:	4785                	li	a5,1
    800004da:	0000c717          	auipc	a4,0xc
    800004de:	b2f72323          	sw	a5,-1242(a4) # 8000c000 <started>
    800004e2:	b789                	j	80000424 <main+0x56>

00000000800004e4 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800004e4:	1141                	addi	sp,sp,-16
    800004e6:	e422                	sd	s0,8(sp)
    800004e8:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    800004ea:	0000c797          	auipc	a5,0xc
    800004ee:	b1e7b783          	ld	a5,-1250(a5) # 8000c008 <kernel_pagetable>
    800004f2:	83b1                	srli	a5,a5,0xc
    800004f4:	577d                	li	a4,-1
    800004f6:	177e                	slli	a4,a4,0x3f
    800004f8:	8fd9                	or	a5,a5,a4
// supervisor address translation and protection;
// holds the address of the page table.
static inline void 
w_satp(uint64 x)
{
  asm volatile("csrw satp, %0" : : "r" (x));
    800004fa:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800004fe:	12000073          	sfence.vma
  sfence_vma();
}
    80000502:	6422                	ld	s0,8(sp)
    80000504:	0141                	addi	sp,sp,16
    80000506:	8082                	ret

0000000080000508 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000508:	7139                	addi	sp,sp,-64
    8000050a:	fc06                	sd	ra,56(sp)
    8000050c:	f822                	sd	s0,48(sp)
    8000050e:	f426                	sd	s1,40(sp)
    80000510:	f04a                	sd	s2,32(sp)
    80000512:	ec4e                	sd	s3,24(sp)
    80000514:	e852                	sd	s4,16(sp)
    80000516:	e456                	sd	s5,8(sp)
    80000518:	e05a                	sd	s6,0(sp)
    8000051a:	0080                	addi	s0,sp,64
    8000051c:	84aa                	mv	s1,a0
    8000051e:	89ae                	mv	s3,a1
    80000520:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000522:	57fd                	li	a5,-1
    80000524:	83e9                	srli	a5,a5,0x1a
    80000526:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000528:	4b31                	li	s6,12
  if(va >= MAXVA)
    8000052a:	04b7f263          	bgeu	a5,a1,8000056e <walk+0x66>
    panic("walk");
    8000052e:	00008517          	auipc	a0,0x8
    80000532:	b2a50513          	addi	a0,a0,-1238 # 80008058 <etext+0x58>
    80000536:	00006097          	auipc	ra,0x6
    8000053a:	9a6080e7          	jalr	-1626(ra) # 80005edc <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000053e:	060a8663          	beqz	s5,800005aa <walk+0xa2>
    80000542:	00000097          	auipc	ra,0x0
    80000546:	c60080e7          	jalr	-928(ra) # 800001a2 <kalloc>
    8000054a:	84aa                	mv	s1,a0
    8000054c:	c529                	beqz	a0,80000596 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000054e:	6605                	lui	a2,0x1
    80000550:	4581                	li	a1,0
    80000552:	00000097          	auipc	ra,0x0
    80000556:	cde080e7          	jalr	-802(ra) # 80000230 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000055a:	00c4d793          	srli	a5,s1,0xc
    8000055e:	07aa                	slli	a5,a5,0xa
    80000560:	0017e793          	ori	a5,a5,1
    80000564:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000568:	3a5d                	addiw	s4,s4,-9 # 1ff7 <_entry-0x7fffe009>
    8000056a:	036a0063          	beq	s4,s6,8000058a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    8000056e:	0149d933          	srl	s2,s3,s4
    80000572:	1ff97913          	andi	s2,s2,511
    80000576:	090e                	slli	s2,s2,0x3
    80000578:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000057a:	00093483          	ld	s1,0(s2)
    8000057e:	0014f793          	andi	a5,s1,1
    80000582:	dfd5                	beqz	a5,8000053e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000584:	80a9                	srli	s1,s1,0xa
    80000586:	04b2                	slli	s1,s1,0xc
    80000588:	b7c5                	j	80000568 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    8000058a:	00c9d513          	srli	a0,s3,0xc
    8000058e:	1ff57513          	andi	a0,a0,511
    80000592:	050e                	slli	a0,a0,0x3
    80000594:	9526                	add	a0,a0,s1
}
    80000596:	70e2                	ld	ra,56(sp)
    80000598:	7442                	ld	s0,48(sp)
    8000059a:	74a2                	ld	s1,40(sp)
    8000059c:	7902                	ld	s2,32(sp)
    8000059e:	69e2                	ld	s3,24(sp)
    800005a0:	6a42                	ld	s4,16(sp)
    800005a2:	6aa2                	ld	s5,8(sp)
    800005a4:	6b02                	ld	s6,0(sp)
    800005a6:	6121                	addi	sp,sp,64
    800005a8:	8082                	ret
        return 0;
    800005aa:	4501                	li	a0,0
    800005ac:	b7ed                	j	80000596 <walk+0x8e>

00000000800005ae <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005ae:	57fd                	li	a5,-1
    800005b0:	83e9                	srli	a5,a5,0x1a
    800005b2:	00b7f463          	bgeu	a5,a1,800005ba <walkaddr+0xc>
    return 0;
    800005b6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005b8:	8082                	ret
{
    800005ba:	1141                	addi	sp,sp,-16
    800005bc:	e406                	sd	ra,8(sp)
    800005be:	e022                	sd	s0,0(sp)
    800005c0:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005c2:	4601                	li	a2,0
    800005c4:	00000097          	auipc	ra,0x0
    800005c8:	f44080e7          	jalr	-188(ra) # 80000508 <walk>
  if(pte == 0)
    800005cc:	c105                	beqz	a0,800005ec <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    800005ce:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800005d0:	0117f693          	andi	a3,a5,17
    800005d4:	4745                	li	a4,17
    return 0;
    800005d6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800005d8:	00e68663          	beq	a3,a4,800005e4 <walkaddr+0x36>
}
    800005dc:	60a2                	ld	ra,8(sp)
    800005de:	6402                	ld	s0,0(sp)
    800005e0:	0141                	addi	sp,sp,16
    800005e2:	8082                	ret
  pa = PTE2PA(*pte);
    800005e4:	83a9                	srli	a5,a5,0xa
    800005e6:	00c79513          	slli	a0,a5,0xc
  return pa;
    800005ea:	bfcd                	j	800005dc <walkaddr+0x2e>
    return 0;
    800005ec:	4501                	li	a0,0
    800005ee:	b7fd                	j	800005dc <walkaddr+0x2e>

00000000800005f0 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800005f0:	715d                	addi	sp,sp,-80
    800005f2:	e486                	sd	ra,72(sp)
    800005f4:	e0a2                	sd	s0,64(sp)
    800005f6:	fc26                	sd	s1,56(sp)
    800005f8:	f84a                	sd	s2,48(sp)
    800005fa:	f44e                	sd	s3,40(sp)
    800005fc:	f052                	sd	s4,32(sp)
    800005fe:	ec56                	sd	s5,24(sp)
    80000600:	e85a                	sd	s6,16(sp)
    80000602:	e45e                	sd	s7,8(sp)
    80000604:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80000606:	c639                	beqz	a2,80000654 <mappages+0x64>
    80000608:	8aaa                	mv	s5,a0
    8000060a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000060c:	777d                	lui	a4,0xfffff
    8000060e:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80000612:	fff58993          	addi	s3,a1,-1
    80000616:	99b2                	add	s3,s3,a2
    80000618:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000061c:	893e                	mv	s2,a5
    8000061e:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000622:	6b85                	lui	s7,0x1
    80000624:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80000628:	4605                	li	a2,1
    8000062a:	85ca                	mv	a1,s2
    8000062c:	8556                	mv	a0,s5
    8000062e:	00000097          	auipc	ra,0x0
    80000632:	eda080e7          	jalr	-294(ra) # 80000508 <walk>
    80000636:	cd1d                	beqz	a0,80000674 <mappages+0x84>
    if(*pte & PTE_V)
    80000638:	611c                	ld	a5,0(a0)
    8000063a:	8b85                	andi	a5,a5,1
    8000063c:	e785                	bnez	a5,80000664 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000063e:	80b1                	srli	s1,s1,0xc
    80000640:	04aa                	slli	s1,s1,0xa
    80000642:	0164e4b3          	or	s1,s1,s6
    80000646:	0014e493          	ori	s1,s1,1
    8000064a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000064c:	05390063          	beq	s2,s3,8000068c <mappages+0x9c>
    a += PGSIZE;
    80000650:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000652:	bfc9                	j	80000624 <mappages+0x34>
    panic("mappages: size");
    80000654:	00008517          	auipc	a0,0x8
    80000658:	a0c50513          	addi	a0,a0,-1524 # 80008060 <etext+0x60>
    8000065c:	00006097          	auipc	ra,0x6
    80000660:	880080e7          	jalr	-1920(ra) # 80005edc <panic>
      panic("mappages: remap");
    80000664:	00008517          	auipc	a0,0x8
    80000668:	a0c50513          	addi	a0,a0,-1524 # 80008070 <etext+0x70>
    8000066c:	00006097          	auipc	ra,0x6
    80000670:	870080e7          	jalr	-1936(ra) # 80005edc <panic>
      return -1;
    80000674:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000676:	60a6                	ld	ra,72(sp)
    80000678:	6406                	ld	s0,64(sp)
    8000067a:	74e2                	ld	s1,56(sp)
    8000067c:	7942                	ld	s2,48(sp)
    8000067e:	79a2                	ld	s3,40(sp)
    80000680:	7a02                	ld	s4,32(sp)
    80000682:	6ae2                	ld	s5,24(sp)
    80000684:	6b42                	ld	s6,16(sp)
    80000686:	6ba2                	ld	s7,8(sp)
    80000688:	6161                	addi	sp,sp,80
    8000068a:	8082                	ret
  return 0;
    8000068c:	4501                	li	a0,0
    8000068e:	b7e5                	j	80000676 <mappages+0x86>

0000000080000690 <kvmmap>:
{
    80000690:	1141                	addi	sp,sp,-16
    80000692:	e406                	sd	ra,8(sp)
    80000694:	e022                	sd	s0,0(sp)
    80000696:	0800                	addi	s0,sp,16
    80000698:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000069a:	86b2                	mv	a3,a2
    8000069c:	863e                	mv	a2,a5
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f52080e7          	jalr	-174(ra) # 800005f0 <mappages>
    800006a6:	e509                	bnez	a0,800006b0 <kvmmap+0x20>
}
    800006a8:	60a2                	ld	ra,8(sp)
    800006aa:	6402                	ld	s0,0(sp)
    800006ac:	0141                	addi	sp,sp,16
    800006ae:	8082                	ret
    panic("kvmmap");
    800006b0:	00008517          	auipc	a0,0x8
    800006b4:	9d050513          	addi	a0,a0,-1584 # 80008080 <etext+0x80>
    800006b8:	00006097          	auipc	ra,0x6
    800006bc:	824080e7          	jalr	-2012(ra) # 80005edc <panic>

00000000800006c0 <kvmmake>:
{
    800006c0:	1101                	addi	sp,sp,-32
    800006c2:	ec06                	sd	ra,24(sp)
    800006c4:	e822                	sd	s0,16(sp)
    800006c6:	e426                	sd	s1,8(sp)
    800006c8:	e04a                	sd	s2,0(sp)
    800006ca:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800006cc:	00000097          	auipc	ra,0x0
    800006d0:	ad6080e7          	jalr	-1322(ra) # 800001a2 <kalloc>
    800006d4:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006d6:	6605                	lui	a2,0x1
    800006d8:	4581                	li	a1,0
    800006da:	00000097          	auipc	ra,0x0
    800006de:	b56080e7          	jalr	-1194(ra) # 80000230 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800006e2:	4719                	li	a4,6
    800006e4:	6685                	lui	a3,0x1
    800006e6:	10000637          	lui	a2,0x10000
    800006ea:	100005b7          	lui	a1,0x10000
    800006ee:	8526                	mv	a0,s1
    800006f0:	00000097          	auipc	ra,0x0
    800006f4:	fa0080e7          	jalr	-96(ra) # 80000690 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800006f8:	4719                	li	a4,6
    800006fa:	6685                	lui	a3,0x1
    800006fc:	10001637          	lui	a2,0x10001
    80000700:	100015b7          	lui	a1,0x10001
    80000704:	8526                	mv	a0,s1
    80000706:	00000097          	auipc	ra,0x0
    8000070a:	f8a080e7          	jalr	-118(ra) # 80000690 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000070e:	4719                	li	a4,6
    80000710:	004006b7          	lui	a3,0x400
    80000714:	0c000637          	lui	a2,0xc000
    80000718:	0c0005b7          	lui	a1,0xc000
    8000071c:	8526                	mv	a0,s1
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f72080e7          	jalr	-142(ra) # 80000690 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000726:	00008917          	auipc	s2,0x8
    8000072a:	8da90913          	addi	s2,s2,-1830 # 80008000 <etext>
    8000072e:	4729                	li	a4,10
    80000730:	80008697          	auipc	a3,0x80008
    80000734:	8d068693          	addi	a3,a3,-1840 # 8000 <_entry-0x7fff8000>
    80000738:	4605                	li	a2,1
    8000073a:	067e                	slli	a2,a2,0x1f
    8000073c:	85b2                	mv	a1,a2
    8000073e:	8526                	mv	a0,s1
    80000740:	00000097          	auipc	ra,0x0
    80000744:	f50080e7          	jalr	-176(ra) # 80000690 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000748:	46c5                	li	a3,17
    8000074a:	06ee                	slli	a3,a3,0x1b
    8000074c:	4719                	li	a4,6
    8000074e:	412686b3          	sub	a3,a3,s2
    80000752:	864a                	mv	a2,s2
    80000754:	85ca                	mv	a1,s2
    80000756:	8526                	mv	a0,s1
    80000758:	00000097          	auipc	ra,0x0
    8000075c:	f38080e7          	jalr	-200(ra) # 80000690 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000760:	4729                	li	a4,10
    80000762:	6685                	lui	a3,0x1
    80000764:	00007617          	auipc	a2,0x7
    80000768:	89c60613          	addi	a2,a2,-1892 # 80007000 <_trampoline>
    8000076c:	040005b7          	lui	a1,0x4000
    80000770:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000772:	05b2                	slli	a1,a1,0xc
    80000774:	8526                	mv	a0,s1
    80000776:	00000097          	auipc	ra,0x0
    8000077a:	f1a080e7          	jalr	-230(ra) # 80000690 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000077e:	8526                	mv	a0,s1
    80000780:	00000097          	auipc	ra,0x0
    80000784:	75a080e7          	jalr	1882(ra) # 80000eda <proc_mapstacks>
}
    80000788:	8526                	mv	a0,s1
    8000078a:	60e2                	ld	ra,24(sp)
    8000078c:	6442                	ld	s0,16(sp)
    8000078e:	64a2                	ld	s1,8(sp)
    80000790:	6902                	ld	s2,0(sp)
    80000792:	6105                	addi	sp,sp,32
    80000794:	8082                	ret

0000000080000796 <kvminit>:
{
    80000796:	1141                	addi	sp,sp,-16
    80000798:	e406                	sd	ra,8(sp)
    8000079a:	e022                	sd	s0,0(sp)
    8000079c:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000079e:	00000097          	auipc	ra,0x0
    800007a2:	f22080e7          	jalr	-222(ra) # 800006c0 <kvmmake>
    800007a6:	0000c797          	auipc	a5,0xc
    800007aa:	86a7b123          	sd	a0,-1950(a5) # 8000c008 <kernel_pagetable>
}
    800007ae:	60a2                	ld	ra,8(sp)
    800007b0:	6402                	ld	s0,0(sp)
    800007b2:	0141                	addi	sp,sp,16
    800007b4:	8082                	ret

00000000800007b6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007b6:	715d                	addi	sp,sp,-80
    800007b8:	e486                	sd	ra,72(sp)
    800007ba:	e0a2                	sd	s0,64(sp)
    800007bc:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800007be:	03459793          	slli	a5,a1,0x34
    800007c2:	e39d                	bnez	a5,800007e8 <uvmunmap+0x32>
    800007c4:	f84a                	sd	s2,48(sp)
    800007c6:	f44e                	sd	s3,40(sp)
    800007c8:	f052                	sd	s4,32(sp)
    800007ca:	ec56                	sd	s5,24(sp)
    800007cc:	e85a                	sd	s6,16(sp)
    800007ce:	e45e                	sd	s7,8(sp)
    800007d0:	8a2a                	mv	s4,a0
    800007d2:	892e                	mv	s2,a1
    800007d4:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007d6:	0632                	slli	a2,a2,0xc
    800007d8:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800007dc:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007de:	6b05                	lui	s6,0x1
    800007e0:	0935fb63          	bgeu	a1,s3,80000876 <uvmunmap+0xc0>
    800007e4:	fc26                	sd	s1,56(sp)
    800007e6:	a8a9                	j	80000840 <uvmunmap+0x8a>
    800007e8:	fc26                	sd	s1,56(sp)
    800007ea:	f84a                	sd	s2,48(sp)
    800007ec:	f44e                	sd	s3,40(sp)
    800007ee:	f052                	sd	s4,32(sp)
    800007f0:	ec56                	sd	s5,24(sp)
    800007f2:	e85a                	sd	s6,16(sp)
    800007f4:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800007f6:	00008517          	auipc	a0,0x8
    800007fa:	89250513          	addi	a0,a0,-1902 # 80008088 <etext+0x88>
    800007fe:	00005097          	auipc	ra,0x5
    80000802:	6de080e7          	jalr	1758(ra) # 80005edc <panic>
      panic("uvmunmap: walk");
    80000806:	00008517          	auipc	a0,0x8
    8000080a:	89a50513          	addi	a0,a0,-1894 # 800080a0 <etext+0xa0>
    8000080e:	00005097          	auipc	ra,0x5
    80000812:	6ce080e7          	jalr	1742(ra) # 80005edc <panic>
      panic("uvmunmap: not mapped");
    80000816:	00008517          	auipc	a0,0x8
    8000081a:	89a50513          	addi	a0,a0,-1894 # 800080b0 <etext+0xb0>
    8000081e:	00005097          	auipc	ra,0x5
    80000822:	6be080e7          	jalr	1726(ra) # 80005edc <panic>
      panic("uvmunmap: not a leaf");
    80000826:	00008517          	auipc	a0,0x8
    8000082a:	8a250513          	addi	a0,a0,-1886 # 800080c8 <etext+0xc8>
    8000082e:	00005097          	auipc	ra,0x5
    80000832:	6ae080e7          	jalr	1710(ra) # 80005edc <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000836:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000083a:	995a                	add	s2,s2,s6
    8000083c:	03397c63          	bgeu	s2,s3,80000874 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80000840:	4601                	li	a2,0
    80000842:	85ca                	mv	a1,s2
    80000844:	8552                	mv	a0,s4
    80000846:	00000097          	auipc	ra,0x0
    8000084a:	cc2080e7          	jalr	-830(ra) # 80000508 <walk>
    8000084e:	84aa                	mv	s1,a0
    80000850:	d95d                	beqz	a0,80000806 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80000852:	6108                	ld	a0,0(a0)
    80000854:	00157793          	andi	a5,a0,1
    80000858:	dfdd                	beqz	a5,80000816 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000085a:	3ff57793          	andi	a5,a0,1023
    8000085e:	fd7784e3          	beq	a5,s7,80000826 <uvmunmap+0x70>
    if(do_free){
    80000862:	fc0a8ae3          	beqz	s5,80000836 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80000866:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80000868:	0532                	slli	a0,a0,0xc
    8000086a:	fffff097          	auipc	ra,0xfffff
    8000086e:	7b2080e7          	jalr	1970(ra) # 8000001c <kfree>
    80000872:	b7d1                	j	80000836 <uvmunmap+0x80>
    80000874:	74e2                	ld	s1,56(sp)
    80000876:	7942                	ld	s2,48(sp)
    80000878:	79a2                	ld	s3,40(sp)
    8000087a:	7a02                	ld	s4,32(sp)
    8000087c:	6ae2                	ld	s5,24(sp)
    8000087e:	6b42                	ld	s6,16(sp)
    80000880:	6ba2                	ld	s7,8(sp)
  }
}
    80000882:	60a6                	ld	ra,72(sp)
    80000884:	6406                	ld	s0,64(sp)
    80000886:	6161                	addi	sp,sp,80
    80000888:	8082                	ret

000000008000088a <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000088a:	1101                	addi	sp,sp,-32
    8000088c:	ec06                	sd	ra,24(sp)
    8000088e:	e822                	sd	s0,16(sp)
    80000890:	e426                	sd	s1,8(sp)
    80000892:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000894:	00000097          	auipc	ra,0x0
    80000898:	90e080e7          	jalr	-1778(ra) # 800001a2 <kalloc>
    8000089c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000089e:	c519                	beqz	a0,800008ac <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800008a0:	6605                	lui	a2,0x1
    800008a2:	4581                	li	a1,0
    800008a4:	00000097          	auipc	ra,0x0
    800008a8:	98c080e7          	jalr	-1652(ra) # 80000230 <memset>
  return pagetable;
}
    800008ac:	8526                	mv	a0,s1
    800008ae:	60e2                	ld	ra,24(sp)
    800008b0:	6442                	ld	s0,16(sp)
    800008b2:	64a2                	ld	s1,8(sp)
    800008b4:	6105                	addi	sp,sp,32
    800008b6:	8082                	ret

00000000800008b8 <uvminit>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvminit(pagetable_t pagetable, uchar *src, uint sz)
{
    800008b8:	7179                	addi	sp,sp,-48
    800008ba:	f406                	sd	ra,40(sp)
    800008bc:	f022                	sd	s0,32(sp)
    800008be:	ec26                	sd	s1,24(sp)
    800008c0:	e84a                	sd	s2,16(sp)
    800008c2:	e44e                	sd	s3,8(sp)
    800008c4:	e052                	sd	s4,0(sp)
    800008c6:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800008c8:	6785                	lui	a5,0x1
    800008ca:	04f67863          	bgeu	a2,a5,8000091a <uvminit+0x62>
    800008ce:	8a2a                	mv	s4,a0
    800008d0:	89ae                	mv	s3,a1
    800008d2:	84b2                	mv	s1,a2
    panic("inituvm: more than a page");
  mem = kalloc();
    800008d4:	00000097          	auipc	ra,0x0
    800008d8:	8ce080e7          	jalr	-1842(ra) # 800001a2 <kalloc>
    800008dc:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800008de:	6605                	lui	a2,0x1
    800008e0:	4581                	li	a1,0
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	94e080e7          	jalr	-1714(ra) # 80000230 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800008ea:	4779                	li	a4,30
    800008ec:	86ca                	mv	a3,s2
    800008ee:	6605                	lui	a2,0x1
    800008f0:	4581                	li	a1,0
    800008f2:	8552                	mv	a0,s4
    800008f4:	00000097          	auipc	ra,0x0
    800008f8:	cfc080e7          	jalr	-772(ra) # 800005f0 <mappages>
  memmove(mem, src, sz);
    800008fc:	8626                	mv	a2,s1
    800008fe:	85ce                	mv	a1,s3
    80000900:	854a                	mv	a0,s2
    80000902:	00000097          	auipc	ra,0x0
    80000906:	98a080e7          	jalr	-1654(ra) # 8000028c <memmove>
}
    8000090a:	70a2                	ld	ra,40(sp)
    8000090c:	7402                	ld	s0,32(sp)
    8000090e:	64e2                	ld	s1,24(sp)
    80000910:	6942                	ld	s2,16(sp)
    80000912:	69a2                	ld	s3,8(sp)
    80000914:	6a02                	ld	s4,0(sp)
    80000916:	6145                	addi	sp,sp,48
    80000918:	8082                	ret
    panic("inituvm: more than a page");
    8000091a:	00007517          	auipc	a0,0x7
    8000091e:	7c650513          	addi	a0,a0,1990 # 800080e0 <etext+0xe0>
    80000922:	00005097          	auipc	ra,0x5
    80000926:	5ba080e7          	jalr	1466(ra) # 80005edc <panic>

000000008000092a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000092a:	1101                	addi	sp,sp,-32
    8000092c:	ec06                	sd	ra,24(sp)
    8000092e:	e822                	sd	s0,16(sp)
    80000930:	e426                	sd	s1,8(sp)
    80000932:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000934:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000936:	00b67d63          	bgeu	a2,a1,80000950 <uvmdealloc+0x26>
    8000093a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000093c:	6785                	lui	a5,0x1
    8000093e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000940:	00f60733          	add	a4,a2,a5
    80000944:	76fd                	lui	a3,0xfffff
    80000946:	8f75                	and	a4,a4,a3
    80000948:	97ae                	add	a5,a5,a1
    8000094a:	8ff5                	and	a5,a5,a3
    8000094c:	00f76863          	bltu	a4,a5,8000095c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000950:	8526                	mv	a0,s1
    80000952:	60e2                	ld	ra,24(sp)
    80000954:	6442                	ld	s0,16(sp)
    80000956:	64a2                	ld	s1,8(sp)
    80000958:	6105                	addi	sp,sp,32
    8000095a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000095c:	8f99                	sub	a5,a5,a4
    8000095e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000960:	4685                	li	a3,1
    80000962:	0007861b          	sext.w	a2,a5
    80000966:	85ba                	mv	a1,a4
    80000968:	00000097          	auipc	ra,0x0
    8000096c:	e4e080e7          	jalr	-434(ra) # 800007b6 <uvmunmap>
    80000970:	b7c5                	j	80000950 <uvmdealloc+0x26>

0000000080000972 <uvmalloc>:
  if(newsz < oldsz)
    80000972:	0ab66563          	bltu	a2,a1,80000a1c <uvmalloc+0xaa>
{
    80000976:	7139                	addi	sp,sp,-64
    80000978:	fc06                	sd	ra,56(sp)
    8000097a:	f822                	sd	s0,48(sp)
    8000097c:	ec4e                	sd	s3,24(sp)
    8000097e:	e852                	sd	s4,16(sp)
    80000980:	e456                	sd	s5,8(sp)
    80000982:	0080                	addi	s0,sp,64
    80000984:	8aaa                	mv	s5,a0
    80000986:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000988:	6785                	lui	a5,0x1
    8000098a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000098c:	95be                	add	a1,a1,a5
    8000098e:	77fd                	lui	a5,0xfffff
    80000990:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000994:	08c9f663          	bgeu	s3,a2,80000a20 <uvmalloc+0xae>
    80000998:	f426                	sd	s1,40(sp)
    8000099a:	f04a                	sd	s2,32(sp)
    8000099c:	894e                	mv	s2,s3
    mem = kalloc();
    8000099e:	00000097          	auipc	ra,0x0
    800009a2:	804080e7          	jalr	-2044(ra) # 800001a2 <kalloc>
    800009a6:	84aa                	mv	s1,a0
    if(mem == 0){
    800009a8:	c90d                	beqz	a0,800009da <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800009aa:	6605                	lui	a2,0x1
    800009ac:	4581                	li	a1,0
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	882080e7          	jalr	-1918(ra) # 80000230 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_W|PTE_X|PTE_R|PTE_U) != 0){
    800009b6:	4779                	li	a4,30
    800009b8:	86a6                	mv	a3,s1
    800009ba:	6605                	lui	a2,0x1
    800009bc:	85ca                	mv	a1,s2
    800009be:	8556                	mv	a0,s5
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	c30080e7          	jalr	-976(ra) # 800005f0 <mappages>
    800009c8:	e915                	bnez	a0,800009fc <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800009ca:	6785                	lui	a5,0x1
    800009cc:	993e                	add	s2,s2,a5
    800009ce:	fd4968e3          	bltu	s2,s4,8000099e <uvmalloc+0x2c>
  return newsz;
    800009d2:	8552                	mv	a0,s4
    800009d4:	74a2                	ld	s1,40(sp)
    800009d6:	7902                	ld	s2,32(sp)
    800009d8:	a819                	j	800009ee <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    800009da:	864e                	mv	a2,s3
    800009dc:	85ca                	mv	a1,s2
    800009de:	8556                	mv	a0,s5
    800009e0:	00000097          	auipc	ra,0x0
    800009e4:	f4a080e7          	jalr	-182(ra) # 8000092a <uvmdealloc>
      return 0;
    800009e8:	4501                	li	a0,0
    800009ea:	74a2                	ld	s1,40(sp)
    800009ec:	7902                	ld	s2,32(sp)
}
    800009ee:	70e2                	ld	ra,56(sp)
    800009f0:	7442                	ld	s0,48(sp)
    800009f2:	69e2                	ld	s3,24(sp)
    800009f4:	6a42                	ld	s4,16(sp)
    800009f6:	6aa2                	ld	s5,8(sp)
    800009f8:	6121                	addi	sp,sp,64
    800009fa:	8082                	ret
      kfree(mem);
    800009fc:	8526                	mv	a0,s1
    800009fe:	fffff097          	auipc	ra,0xfffff
    80000a02:	61e080e7          	jalr	1566(ra) # 8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000a06:	864e                	mv	a2,s3
    80000a08:	85ca                	mv	a1,s2
    80000a0a:	8556                	mv	a0,s5
    80000a0c:	00000097          	auipc	ra,0x0
    80000a10:	f1e080e7          	jalr	-226(ra) # 8000092a <uvmdealloc>
      return 0;
    80000a14:	4501                	li	a0,0
    80000a16:	74a2                	ld	s1,40(sp)
    80000a18:	7902                	ld	s2,32(sp)
    80000a1a:	bfd1                	j	800009ee <uvmalloc+0x7c>
    return oldsz;
    80000a1c:	852e                	mv	a0,a1
}
    80000a1e:	8082                	ret
  return newsz;
    80000a20:	8532                	mv	a0,a2
    80000a22:	b7f1                	j	800009ee <uvmalloc+0x7c>

0000000080000a24 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000a24:	7179                	addi	sp,sp,-48
    80000a26:	f406                	sd	ra,40(sp)
    80000a28:	f022                	sd	s0,32(sp)
    80000a2a:	ec26                	sd	s1,24(sp)
    80000a2c:	e84a                	sd	s2,16(sp)
    80000a2e:	e44e                	sd	s3,8(sp)
    80000a30:	e052                	sd	s4,0(sp)
    80000a32:	1800                	addi	s0,sp,48
    80000a34:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000a36:	84aa                	mv	s1,a0
    80000a38:	6905                	lui	s2,0x1
    80000a3a:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a3c:	4985                	li	s3,1
    80000a3e:	a829                	j	80000a58 <freewalk+0x34>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80000a40:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000a42:	00c79513          	slli	a0,a5,0xc
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	fde080e7          	jalr	-34(ra) # 80000a24 <freewalk>
      pagetable[i] = 0;
    80000a4e:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80000a52:	04a1                	addi	s1,s1,8
    80000a54:	03248163          	beq	s1,s2,80000a76 <freewalk+0x52>
    pte_t pte = pagetable[i];
    80000a58:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000a5a:	00f7f713          	andi	a4,a5,15
    80000a5e:	ff3701e3          	beq	a4,s3,80000a40 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80000a62:	8b85                	andi	a5,a5,1
    80000a64:	d7fd                	beqz	a5,80000a52 <freewalk+0x2e>
      panic("freewalk: leaf");
    80000a66:	00007517          	auipc	a0,0x7
    80000a6a:	69a50513          	addi	a0,a0,1690 # 80008100 <etext+0x100>
    80000a6e:	00005097          	auipc	ra,0x5
    80000a72:	46e080e7          	jalr	1134(ra) # 80005edc <panic>
    }
  }
  kfree((void*)pagetable);
    80000a76:	8552                	mv	a0,s4
    80000a78:	fffff097          	auipc	ra,0xfffff
    80000a7c:	5a4080e7          	jalr	1444(ra) # 8000001c <kfree>
}
    80000a80:	70a2                	ld	ra,40(sp)
    80000a82:	7402                	ld	s0,32(sp)
    80000a84:	64e2                	ld	s1,24(sp)
    80000a86:	6942                	ld	s2,16(sp)
    80000a88:	69a2                	ld	s3,8(sp)
    80000a8a:	6a02                	ld	s4,0(sp)
    80000a8c:	6145                	addi	sp,sp,48
    80000a8e:	8082                	ret

0000000080000a90 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000a90:	1101                	addi	sp,sp,-32
    80000a92:	ec06                	sd	ra,24(sp)
    80000a94:	e822                	sd	s0,16(sp)
    80000a96:	e426                	sd	s1,8(sp)
    80000a98:	1000                	addi	s0,sp,32
    80000a9a:	84aa                	mv	s1,a0
  if(sz > 0)
    80000a9c:	e999                	bnez	a1,80000ab2 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000a9e:	8526                	mv	a0,s1
    80000aa0:	00000097          	auipc	ra,0x0
    80000aa4:	f84080e7          	jalr	-124(ra) # 80000a24 <freewalk>
}
    80000aa8:	60e2                	ld	ra,24(sp)
    80000aaa:	6442                	ld	s0,16(sp)
    80000aac:	64a2                	ld	s1,8(sp)
    80000aae:	6105                	addi	sp,sp,32
    80000ab0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000ab6:	95be                	add	a1,a1,a5
    80000ab8:	4685                	li	a3,1
    80000aba:	00c5d613          	srli	a2,a1,0xc
    80000abe:	4581                	li	a1,0
    80000ac0:	00000097          	auipc	ra,0x0
    80000ac4:	cf6080e7          	jalr	-778(ra) # 800007b6 <uvmunmap>
    80000ac8:	bfd9                	j	80000a9e <uvmfree+0xe>

0000000080000aca <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    80000aca:	715d                	addi	sp,sp,-80
    80000acc:	e486                	sd	ra,72(sp)
    80000ace:	e0a2                	sd	s0,64(sp)
    80000ad0:	f052                	sd	s4,32(sp)
    80000ad2:	0880                	addi	s0,sp,80
  pte_t *pte;
  uint64 pa, i;
  uint flags;  

  for(i = 0; i < sz; i += PGSIZE){
    80000ad4:	c665                	beqz	a2,80000bbc <uvmcopy+0xf2>
    80000ad6:	fc26                	sd	s1,56(sp)
    80000ad8:	f84a                	sd	s2,48(sp)
    80000ada:	f44e                	sd	s3,40(sp)
    80000adc:	ec56                	sd	s5,24(sp)
    80000ade:	e85a                	sd	s6,16(sp)
    80000ae0:	e45e                	sd	s7,8(sp)
    80000ae2:	e062                	sd	s8,0(sp)
    80000ae4:	8c2a                	mv	s8,a0
    80000ae6:	8bae                	mv	s7,a1
    80000ae8:	8b32                	mv	s6,a2
    80000aea:	4981                	li	s3,0
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
      goto err;
    // Mark the parent page table entry read-only
    *pte &= ~PTE_W;

    acquire(&ref_c.lock);
    80000aec:	0000ba97          	auipc	s5,0xb
    80000af0:	564a8a93          	addi	s5,s5,1380 # 8000c050 <ref_c>
    if((pte = walk(old, i, 0)) == 0)
    80000af4:	4601                	li	a2,0
    80000af6:	85ce                	mv	a1,s3
    80000af8:	8562                	mv	a0,s8
    80000afa:	00000097          	auipc	ra,0x0
    80000afe:	a0e080e7          	jalr	-1522(ra) # 80000508 <walk>
    80000b02:	892a                	mv	s2,a0
    80000b04:	c52d                	beqz	a0,80000b6e <uvmcopy+0xa4>
    if((*pte & PTE_V) == 0)
    80000b06:	6118                	ld	a4,0(a0)
    80000b08:	00177793          	andi	a5,a4,1
    80000b0c:	cbad                	beqz	a5,80000b7e <uvmcopy+0xb4>
    pa = PTE2PA(*pte);
    80000b0e:	00a75493          	srli	s1,a4,0xa
    80000b12:	04b2                	slli	s1,s1,0xc
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0)
    80000b14:	3fb77713          	andi	a4,a4,1019
    80000b18:	86a6                	mv	a3,s1
    80000b1a:	6605                	lui	a2,0x1
    80000b1c:	85ce                	mv	a1,s3
    80000b1e:	855e                	mv	a0,s7
    80000b20:	00000097          	auipc	ra,0x0
    80000b24:	ad0080e7          	jalr	-1328(ra) # 800005f0 <mappages>
    80000b28:	8a2a                	mv	s4,a0
    80000b2a:	e135                	bnez	a0,80000b8e <uvmcopy+0xc4>
    *pte &= ~PTE_W;
    80000b2c:	00093783          	ld	a5,0(s2) # 1000 <_entry-0x7ffff000>
    80000b30:	9bed                	andi	a5,a5,-5
    80000b32:	00f93023          	sd	a5,0(s2)
    acquire(&ref_c.lock);
    80000b36:	8556                	mv	a0,s5
    80000b38:	00006097          	auipc	ra,0x6
    80000b3c:	91e080e7          	jalr	-1762(ra) # 80006456 <acquire>
    // increase reference_count by 1
    ref_c.reference_count[pa/PGSIZE]++;
    80000b40:	80a9                	srli	s1,s1,0xa
    80000b42:	04c1                	addi	s1,s1,16
    80000b44:	94d6                	add	s1,s1,s5
    80000b46:	449c                	lw	a5,8(s1)
    80000b48:	2785                	addiw	a5,a5,1
    80000b4a:	c49c                	sw	a5,8(s1)
    release(&ref_c.lock);
    80000b4c:	8556                	mv	a0,s5
    80000b4e:	00006097          	auipc	ra,0x6
    80000b52:	9bc080e7          	jalr	-1604(ra) # 8000650a <release>
  for(i = 0; i < sz; i += PGSIZE){
    80000b56:	6785                	lui	a5,0x1
    80000b58:	99be                	add	s3,s3,a5
    80000b5a:	f969ede3          	bltu	s3,s6,80000af4 <uvmcopy+0x2a>
    80000b5e:	74e2                	ld	s1,56(sp)
    80000b60:	7942                	ld	s2,48(sp)
    80000b62:	79a2                	ld	s3,40(sp)
    80000b64:	6ae2                	ld	s5,24(sp)
    80000b66:	6b42                	ld	s6,16(sp)
    80000b68:	6ba2                	ld	s7,8(sp)
    80000b6a:	6c02                	ld	s8,0(sp)
    80000b6c:	a091                	j	80000bb0 <uvmcopy+0xe6>
      panic("uvmcopy: pte should exist");
    80000b6e:	00007517          	auipc	a0,0x7
    80000b72:	5a250513          	addi	a0,a0,1442 # 80008110 <etext+0x110>
    80000b76:	00005097          	auipc	ra,0x5
    80000b7a:	366080e7          	jalr	870(ra) # 80005edc <panic>
      panic("uvmcopy: page not present");
    80000b7e:	00007517          	auipc	a0,0x7
    80000b82:	5b250513          	addi	a0,a0,1458 # 80008130 <etext+0x130>
    80000b86:	00005097          	auipc	ra,0x5
    80000b8a:	356080e7          	jalr	854(ra) # 80005edc <panic>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000b8e:	4685                	li	a3,1
    80000b90:	00c9d613          	srli	a2,s3,0xc
    80000b94:	4581                	li	a1,0
    80000b96:	855e                	mv	a0,s7
    80000b98:	00000097          	auipc	ra,0x0
    80000b9c:	c1e080e7          	jalr	-994(ra) # 800007b6 <uvmunmap>
  return -1;
    80000ba0:	5a7d                	li	s4,-1
    80000ba2:	74e2                	ld	s1,56(sp)
    80000ba4:	7942                	ld	s2,48(sp)
    80000ba6:	79a2                	ld	s3,40(sp)
    80000ba8:	6ae2                	ld	s5,24(sp)
    80000baa:	6b42                	ld	s6,16(sp)
    80000bac:	6ba2                	ld	s7,8(sp)
    80000bae:	6c02                	ld	s8,0(sp)
}
    80000bb0:	8552                	mv	a0,s4
    80000bb2:	60a6                	ld	ra,72(sp)
    80000bb4:	6406                	ld	s0,64(sp)
    80000bb6:	7a02                	ld	s4,32(sp)
    80000bb8:	6161                	addi	sp,sp,80
    80000bba:	8082                	ret
  return 0;
    80000bbc:	4a01                	li	s4,0
    80000bbe:	bfcd                	j	80000bb0 <uvmcopy+0xe6>

0000000080000bc0 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000bc0:	1141                	addi	sp,sp,-16
    80000bc2:	e406                	sd	ra,8(sp)
    80000bc4:	e022                	sd	s0,0(sp)
    80000bc6:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000bc8:	4601                	li	a2,0
    80000bca:	00000097          	auipc	ra,0x0
    80000bce:	93e080e7          	jalr	-1730(ra) # 80000508 <walk>
  if(pte == 0)
    80000bd2:	c901                	beqz	a0,80000be2 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000bd4:	611c                	ld	a5,0(a0)
    80000bd6:	9bbd                	andi	a5,a5,-17
    80000bd8:	e11c                	sd	a5,0(a0)
}
    80000bda:	60a2                	ld	ra,8(sp)
    80000bdc:	6402                	ld	s0,0(sp)
    80000bde:	0141                	addi	sp,sp,16
    80000be0:	8082                	ret
    panic("uvmclear");
    80000be2:	00007517          	auipc	a0,0x7
    80000be6:	56e50513          	addi	a0,a0,1390 # 80008150 <etext+0x150>
    80000bea:	00005097          	auipc	ra,0x5
    80000bee:	2f2080e7          	jalr	754(ra) # 80005edc <panic>

0000000080000bf2 <copyout>:
// Copy from kernel to user.
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    80000bf2:	7119                	addi	sp,sp,-128
    80000bf4:	fc86                	sd	ra,120(sp)
    80000bf6:	f8a2                	sd	s0,112(sp)
    80000bf8:	0100                	addi	s0,sp,128
    80000bfa:	f8a43423          	sd	a0,-120(s0)
  pte_t *pte;
  char *new_pa;
  uint64 flags;
  uint64 n, va0, pa0;

  while(len > 0){
    80000bfe:	10068a63          	beqz	a3,80000d12 <copyout+0x120>
    80000c02:	f0ca                	sd	s2,96(sp)
    80000c04:	ecce                	sd	s3,88(sp)
    80000c06:	e8d2                	sd	s4,80(sp)
    80000c08:	f862                	sd	s8,48(sp)
    80000c0a:	89ae                	mv	s3,a1
    80000c0c:	8c32                	mv	s8,a2
    80000c0e:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000c10:	797d                	lui	s2,0xfffff
    80000c12:	0125f933          	and	s2,a1,s2

    // epitrepto virtual address?
    // efoson einai unsigned o arithmos autos, tha prepei na
    // einai < MAXVA
    if(va0 >= MAXVA)
    80000c16:	57fd                	li	a5,-1
    80000c18:	83e9                	srli	a5,a5,0x1a
    80000c1a:	0f27ee63          	bltu	a5,s2,80000d16 <copyout+0x124>
    80000c1e:	f4a6                	sd	s1,104(sp)
    80000c20:	e4d6                	sd	s5,72(sp)
    80000c22:	e0da                	sd	s6,64(sp)
    80000c24:	fc5e                	sd	s7,56(sp)
    80000c26:	f466                	sd	s9,40(sp)
    80000c28:	f06a                	sd	s10,32(sp)
    80000c2a:	ec6e                	sd	s11,24(sp)
    80000c2c:	6785                	lui	a5,0x1
    80000c2e:	993e                	add	s2,s2,a5
    80000c30:	7d7d                	lui	s10,0xfffff
    // auto to pte prepei na einai valid (allocated apo to sistima)
    if((*pte & PTE_V) == 0)
      return -1;
    
    // na einai user level
    if((*pte & PTE_U) == 0)
    80000c32:	4dc5                	li	s11,17
    if(va0 >= MAXVA)
    80000c34:	5cfd                	li	s9,-1
    80000c36:	01acdc93          	srli	s9,s9,0x1a
    80000c3a:	a81d                	j	80000c70 <copyout+0x7e>
      dstva = va0 + PGSIZE;
    }
    // einai writable
    else
    {
      n = PGSIZE - (dstva - va0);
    80000c3c:	413904b3          	sub	s1,s2,s3
      if(n > len)
    80000c40:	009a7363          	bgeu	s4,s1,80000c46 <copyout+0x54>
    80000c44:	84d2                	mv	s1,s4
        n = len;
      memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c46:	41698533          	sub	a0,s3,s6
    80000c4a:	0004861b          	sext.w	a2,s1
    80000c4e:	85e2                	mv	a1,s8
    80000c50:	9556                	add	a0,a0,s5
    80000c52:	fffff097          	auipc	ra,0xfffff
    80000c56:	63a080e7          	jalr	1594(ra) # 8000028c <memmove>

      len -= n;
    80000c5a:	409a0a33          	sub	s4,s4,s1
      src += n;
    80000c5e:	9c26                	add	s8,s8,s1
  while(len > 0){
    80000c60:	080a0c63          	beqz	s4,80000cf8 <copyout+0x106>
    if(va0 >= MAXVA)
    80000c64:	6785                	lui	a5,0x1
    80000c66:	97ca                	add	a5,a5,s2
    80000c68:	89ca                	mv	s3,s2
    80000c6a:	0b2cec63          	bltu	s9,s2,80000d22 <copyout+0x130>
    80000c6e:	893e                	mv	s2,a5
    80000c70:	01a90b33          	add	s6,s2,s10
    if((pte = walk(pagetable, va0, 0)) == 0)
    80000c74:	4601                	li	a2,0
    80000c76:	85da                	mv	a1,s6
    80000c78:	f8843503          	ld	a0,-120(s0)
    80000c7c:	00000097          	auipc	ra,0x0
    80000c80:	88c080e7          	jalr	-1908(ra) # 80000508 <walk>
    80000c84:	84aa                	mv	s1,a0
    80000c86:	c95d                	beqz	a0,80000d3c <copyout+0x14a>
    if((*pte & PTE_V) == 0)
    80000c88:	611c                	ld	a5,0(a0)
    if((*pte & PTE_U) == 0)
    80000c8a:	0117f713          	andi	a4,a5,17
    80000c8e:	0db71463          	bne	a4,s11,80000d56 <copyout+0x164>
    pa0 = PTE2PA(*pte);
    80000c92:	00a7da93          	srli	s5,a5,0xa
    80000c96:	0ab2                	slli	s5,s5,0xc
    if(((*pte) & PTE_W) == 0)
    80000c98:	8b91                	andi	a5,a5,4
    80000c9a:	f3cd                	bnez	a5,80000c3c <copyout+0x4a>
      if((new_pa = kalloc()) == 0)
    80000c9c:	fffff097          	auipc	ra,0xfffff
    80000ca0:	506080e7          	jalr	1286(ra) # 800001a2 <kalloc>
    80000ca4:	8baa                	mv	s7,a0
    80000ca6:	c961                	beqz	a0,80000d76 <copyout+0x184>
      memmove(new_pa, (char*)pa0, PGSIZE);
    80000ca8:	6605                	lui	a2,0x1
    80000caa:	85d6                	mv	a1,s5
    80000cac:	fffff097          	auipc	ra,0xfffff
    80000cb0:	5e0080e7          	jalr	1504(ra) # 8000028c <memmove>
      *pte = PA2PTE(new_pa);
    80000cb4:	00cbd793          	srli	a5,s7,0xc
    80000cb8:	07aa                	slli	a5,a5,0xa
      flags = PTE_FLAGS(*pte);
    80000cba:	6098                	ld	a4,0(s1)
    80000cbc:	3ff77713          	andi	a4,a4,1023
      *pte |= flags;
    80000cc0:	8fd9                	or	a5,a5,a4
      *pte |= PTE_W;
    80000cc2:	0047e793          	ori	a5,a5,4
    80000cc6:	e09c                	sd	a5,0(s1)
      kfree((void*)pa0);
    80000cc8:	8556                	mv	a0,s5
    80000cca:	fffff097          	auipc	ra,0xfffff
    80000cce:	352080e7          	jalr	850(ra) # 8000001c <kfree>
      n = PGSIZE - (dstva - va0);
    80000cd2:	413904b3          	sub	s1,s2,s3
      if(n > len)
    80000cd6:	009a7363          	bgeu	s4,s1,80000cdc <copyout+0xea>
    80000cda:	84d2                	mv	s1,s4
      memmove((void *)(new_pa + (dstva - va0)), src, n);
    80000cdc:	41698533          	sub	a0,s3,s6
    80000ce0:	0004861b          	sext.w	a2,s1
    80000ce4:	85e2                	mv	a1,s8
    80000ce6:	955e                	add	a0,a0,s7
    80000ce8:	fffff097          	auipc	ra,0xfffff
    80000cec:	5a4080e7          	jalr	1444(ra) # 8000028c <memmove>
      len -= n;
    80000cf0:	409a0a33          	sub	s4,s4,s1
      src += n;
    80000cf4:	9c26                	add	s8,s8,s1
      dstva = va0 + PGSIZE;
    80000cf6:	b7ad                	j	80000c60 <copyout+0x6e>
      dstva = va0 + PGSIZE;
    }
  }
  return 0;
    80000cf8:	4501                	li	a0,0
    80000cfa:	74a6                	ld	s1,104(sp)
    80000cfc:	7906                	ld	s2,96(sp)
    80000cfe:	69e6                	ld	s3,88(sp)
    80000d00:	6a46                	ld	s4,80(sp)
    80000d02:	6aa6                	ld	s5,72(sp)
    80000d04:	6b06                	ld	s6,64(sp)
    80000d06:	7be2                	ld	s7,56(sp)
    80000d08:	7c42                	ld	s8,48(sp)
    80000d0a:	7ca2                	ld	s9,40(sp)
    80000d0c:	7d02                	ld	s10,32(sp)
    80000d0e:	6de2                	ld	s11,24(sp)
    80000d10:	a8b9                	j	80000d6e <copyout+0x17c>
    80000d12:	4501                	li	a0,0
    80000d14:	a8a9                	j	80000d6e <copyout+0x17c>
      return -1;
    80000d16:	557d                	li	a0,-1
    80000d18:	7906                	ld	s2,96(sp)
    80000d1a:	69e6                	ld	s3,88(sp)
    80000d1c:	6a46                	ld	s4,80(sp)
    80000d1e:	7c42                	ld	s8,48(sp)
    80000d20:	a0b9                	j	80000d6e <copyout+0x17c>
    80000d22:	557d                	li	a0,-1
    80000d24:	74a6                	ld	s1,104(sp)
    80000d26:	7906                	ld	s2,96(sp)
    80000d28:	69e6                	ld	s3,88(sp)
    80000d2a:	6a46                	ld	s4,80(sp)
    80000d2c:	6aa6                	ld	s5,72(sp)
    80000d2e:	6b06                	ld	s6,64(sp)
    80000d30:	7be2                	ld	s7,56(sp)
    80000d32:	7c42                	ld	s8,48(sp)
    80000d34:	7ca2                	ld	s9,40(sp)
    80000d36:	7d02                	ld	s10,32(sp)
    80000d38:	6de2                	ld	s11,24(sp)
    80000d3a:	a815                	j	80000d6e <copyout+0x17c>
      return -1;
    80000d3c:	557d                	li	a0,-1
    80000d3e:	74a6                	ld	s1,104(sp)
    80000d40:	7906                	ld	s2,96(sp)
    80000d42:	69e6                	ld	s3,88(sp)
    80000d44:	6a46                	ld	s4,80(sp)
    80000d46:	6aa6                	ld	s5,72(sp)
    80000d48:	6b06                	ld	s6,64(sp)
    80000d4a:	7be2                	ld	s7,56(sp)
    80000d4c:	7c42                	ld	s8,48(sp)
    80000d4e:	7ca2                	ld	s9,40(sp)
    80000d50:	7d02                	ld	s10,32(sp)
    80000d52:	6de2                	ld	s11,24(sp)
    80000d54:	a829                	j	80000d6e <copyout+0x17c>
      return -1;
    80000d56:	557d                	li	a0,-1
    80000d58:	74a6                	ld	s1,104(sp)
    80000d5a:	7906                	ld	s2,96(sp)
    80000d5c:	69e6                	ld	s3,88(sp)
    80000d5e:	6a46                	ld	s4,80(sp)
    80000d60:	6aa6                	ld	s5,72(sp)
    80000d62:	6b06                	ld	s6,64(sp)
    80000d64:	7be2                	ld	s7,56(sp)
    80000d66:	7c42                	ld	s8,48(sp)
    80000d68:	7ca2                	ld	s9,40(sp)
    80000d6a:	7d02                	ld	s10,32(sp)
    80000d6c:	6de2                	ld	s11,24(sp)
}
    80000d6e:	70e6                	ld	ra,120(sp)
    80000d70:	7446                	ld	s0,112(sp)
    80000d72:	6109                	addi	sp,sp,128
    80000d74:	8082                	ret
        return -1;
    80000d76:	557d                	li	a0,-1
    80000d78:	74a6                	ld	s1,104(sp)
    80000d7a:	7906                	ld	s2,96(sp)
    80000d7c:	69e6                	ld	s3,88(sp)
    80000d7e:	6a46                	ld	s4,80(sp)
    80000d80:	6aa6                	ld	s5,72(sp)
    80000d82:	6b06                	ld	s6,64(sp)
    80000d84:	7be2                	ld	s7,56(sp)
    80000d86:	7c42                	ld	s8,48(sp)
    80000d88:	7ca2                	ld	s9,40(sp)
    80000d8a:	7d02                	ld	s10,32(sp)
    80000d8c:	6de2                	ld	s11,24(sp)
    80000d8e:	b7c5                	j	80000d6e <copyout+0x17c>

0000000080000d90 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000d90:	caa5                	beqz	a3,80000e00 <copyin+0x70>
{
    80000d92:	715d                	addi	sp,sp,-80
    80000d94:	e486                	sd	ra,72(sp)
    80000d96:	e0a2                	sd	s0,64(sp)
    80000d98:	fc26                	sd	s1,56(sp)
    80000d9a:	f84a                	sd	s2,48(sp)
    80000d9c:	f44e                	sd	s3,40(sp)
    80000d9e:	f052                	sd	s4,32(sp)
    80000da0:	ec56                	sd	s5,24(sp)
    80000da2:	e85a                	sd	s6,16(sp)
    80000da4:	e45e                	sd	s7,8(sp)
    80000da6:	e062                	sd	s8,0(sp)
    80000da8:	0880                	addi	s0,sp,80
    80000daa:	8b2a                	mv	s6,a0
    80000dac:	8a2e                	mv	s4,a1
    80000dae:	8c32                	mv	s8,a2
    80000db0:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000db2:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000db4:	6a85                	lui	s5,0x1
    80000db6:	a01d                	j	80000ddc <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000db8:	018505b3          	add	a1,a0,s8
    80000dbc:	0004861b          	sext.w	a2,s1
    80000dc0:	412585b3          	sub	a1,a1,s2
    80000dc4:	8552                	mv	a0,s4
    80000dc6:	fffff097          	auipc	ra,0xfffff
    80000dca:	4c6080e7          	jalr	1222(ra) # 8000028c <memmove>

    len -= n;
    80000dce:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000dd2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000dd4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000dd8:	02098263          	beqz	s3,80000dfc <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80000ddc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000de0:	85ca                	mv	a1,s2
    80000de2:	855a                	mv	a0,s6
    80000de4:	fffff097          	auipc	ra,0xfffff
    80000de8:	7ca080e7          	jalr	1994(ra) # 800005ae <walkaddr>
    if(pa0 == 0)
    80000dec:	cd01                	beqz	a0,80000e04 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80000dee:	418904b3          	sub	s1,s2,s8
    80000df2:	94d6                	add	s1,s1,s5
    if(n > len)
    80000df4:	fc99f2e3          	bgeu	s3,s1,80000db8 <copyin+0x28>
    80000df8:	84ce                	mv	s1,s3
    80000dfa:	bf7d                	j	80000db8 <copyin+0x28>
  }
  return 0;
    80000dfc:	4501                	li	a0,0
    80000dfe:	a021                	j	80000e06 <copyin+0x76>
    80000e00:	4501                	li	a0,0
}
    80000e02:	8082                	ret
      return -1;
    80000e04:	557d                	li	a0,-1
}
    80000e06:	60a6                	ld	ra,72(sp)
    80000e08:	6406                	ld	s0,64(sp)
    80000e0a:	74e2                	ld	s1,56(sp)
    80000e0c:	7942                	ld	s2,48(sp)
    80000e0e:	79a2                	ld	s3,40(sp)
    80000e10:	7a02                	ld	s4,32(sp)
    80000e12:	6ae2                	ld	s5,24(sp)
    80000e14:	6b42                	ld	s6,16(sp)
    80000e16:	6ba2                	ld	s7,8(sp)
    80000e18:	6c02                	ld	s8,0(sp)
    80000e1a:	6161                	addi	sp,sp,80
    80000e1c:	8082                	ret

0000000080000e1e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000e1e:	cacd                	beqz	a3,80000ed0 <copyinstr+0xb2>
{
    80000e20:	715d                	addi	sp,sp,-80
    80000e22:	e486                	sd	ra,72(sp)
    80000e24:	e0a2                	sd	s0,64(sp)
    80000e26:	fc26                	sd	s1,56(sp)
    80000e28:	f84a                	sd	s2,48(sp)
    80000e2a:	f44e                	sd	s3,40(sp)
    80000e2c:	f052                	sd	s4,32(sp)
    80000e2e:	ec56                	sd	s5,24(sp)
    80000e30:	e85a                	sd	s6,16(sp)
    80000e32:	e45e                	sd	s7,8(sp)
    80000e34:	0880                	addi	s0,sp,80
    80000e36:	8a2a                	mv	s4,a0
    80000e38:	8b2e                	mv	s6,a1
    80000e3a:	8bb2                	mv	s7,a2
    80000e3c:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80000e3e:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000e40:	6985                	lui	s3,0x1
    80000e42:	a825                	j	80000e7a <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000e44:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000e48:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000e4a:	37fd                	addiw	a5,a5,-1
    80000e4c:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000e50:	60a6                	ld	ra,72(sp)
    80000e52:	6406                	ld	s0,64(sp)
    80000e54:	74e2                	ld	s1,56(sp)
    80000e56:	7942                	ld	s2,48(sp)
    80000e58:	79a2                	ld	s3,40(sp)
    80000e5a:	7a02                	ld	s4,32(sp)
    80000e5c:	6ae2                	ld	s5,24(sp)
    80000e5e:	6b42                	ld	s6,16(sp)
    80000e60:	6ba2                	ld	s7,8(sp)
    80000e62:	6161                	addi	sp,sp,80
    80000e64:	8082                	ret
    80000e66:	fff90713          	addi	a4,s2,-1 # ffffffffffffefff <end+0xffffffff7fdb5dbf>
    80000e6a:	9742                	add	a4,a4,a6
      --max;
    80000e6c:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80000e70:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80000e74:	04e58663          	beq	a1,a4,80000ec0 <copyinstr+0xa2>
{
    80000e78:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80000e7a:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80000e7e:	85a6                	mv	a1,s1
    80000e80:	8552                	mv	a0,s4
    80000e82:	fffff097          	auipc	ra,0xfffff
    80000e86:	72c080e7          	jalr	1836(ra) # 800005ae <walkaddr>
    if(pa0 == 0)
    80000e8a:	cd0d                	beqz	a0,80000ec4 <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    80000e8c:	417486b3          	sub	a3,s1,s7
    80000e90:	96ce                	add	a3,a3,s3
    if(n > max)
    80000e92:	00d97363          	bgeu	s2,a3,80000e98 <copyinstr+0x7a>
    80000e96:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80000e98:	955e                	add	a0,a0,s7
    80000e9a:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80000e9c:	c695                	beqz	a3,80000ec8 <copyinstr+0xaa>
    80000e9e:	87da                	mv	a5,s6
    80000ea0:	885a                	mv	a6,s6
      if(*p == '\0'){
    80000ea2:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80000ea6:	96da                	add	a3,a3,s6
    80000ea8:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000eaa:	00f60733          	add	a4,a2,a5
    80000eae:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7fdb5dc0>
    80000eb2:	db49                	beqz	a4,80000e44 <copyinstr+0x26>
        *dst = *p;
    80000eb4:	00e78023          	sb	a4,0(a5)
      dst++;
    80000eb8:	0785                	addi	a5,a5,1
    while(n > 0){
    80000eba:	fed797e3          	bne	a5,a3,80000ea8 <copyinstr+0x8a>
    80000ebe:	b765                	j	80000e66 <copyinstr+0x48>
    80000ec0:	4781                	li	a5,0
    80000ec2:	b761                	j	80000e4a <copyinstr+0x2c>
      return -1;
    80000ec4:	557d                	li	a0,-1
    80000ec6:	b769                	j	80000e50 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80000ec8:	6b85                	lui	s7,0x1
    80000eca:	9ba6                	add	s7,s7,s1
    80000ecc:	87da                	mv	a5,s6
    80000ece:	b76d                	j	80000e78 <copyinstr+0x5a>
  int got_null = 0;
    80000ed0:	4781                	li	a5,0
  if(got_null){
    80000ed2:	37fd                	addiw	a5,a5,-1
    80000ed4:	0007851b          	sext.w	a0,a5
}
    80000ed8:	8082                	ret

0000000080000eda <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl) {
    80000eda:	7139                	addi	sp,sp,-64
    80000edc:	fc06                	sd	ra,56(sp)
    80000ede:	f822                	sd	s0,48(sp)
    80000ee0:	f426                	sd	s1,40(sp)
    80000ee2:	f04a                	sd	s2,32(sp)
    80000ee4:	ec4e                	sd	s3,24(sp)
    80000ee6:	e852                	sd	s4,16(sp)
    80000ee8:	e456                	sd	s5,8(sp)
    80000eea:	e05a                	sd	s6,0(sp)
    80000eec:	0080                	addi	s0,sp,64
    80000eee:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ef0:	0022b497          	auipc	s1,0x22b
    80000ef4:	5a848493          	addi	s1,s1,1448 # 8022c498 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ef8:	8b26                	mv	s6,s1
    80000efa:	04fa5937          	lui	s2,0x4fa5
    80000efe:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000f02:	0932                	slli	s2,s2,0xc
    80000f04:	fa590913          	addi	s2,s2,-91
    80000f08:	0932                	slli	s2,s2,0xc
    80000f0a:	fa590913          	addi	s2,s2,-91
    80000f0e:	0932                	slli	s2,s2,0xc
    80000f10:	fa590913          	addi	s2,s2,-91
    80000f14:	040009b7          	lui	s3,0x4000
    80000f18:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000f1a:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f1c:	00231a97          	auipc	s5,0x231
    80000f20:	f7ca8a93          	addi	s5,s5,-132 # 80231e98 <tickslock>
    char *pa = kalloc();
    80000f24:	fffff097          	auipc	ra,0xfffff
    80000f28:	27e080e7          	jalr	638(ra) # 800001a2 <kalloc>
    80000f2c:	862a                	mv	a2,a0
    if(pa == 0)
    80000f2e:	c121                	beqz	a0,80000f6e <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80000f30:	416485b3          	sub	a1,s1,s6
    80000f34:	858d                	srai	a1,a1,0x3
    80000f36:	032585b3          	mul	a1,a1,s2
    80000f3a:	2585                	addiw	a1,a1,1
    80000f3c:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f40:	4719                	li	a4,6
    80000f42:	6685                	lui	a3,0x1
    80000f44:	40b985b3          	sub	a1,s3,a1
    80000f48:	8552                	mv	a0,s4
    80000f4a:	fffff097          	auipc	ra,0xfffff
    80000f4e:	746080e7          	jalr	1862(ra) # 80000690 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f52:	16848493          	addi	s1,s1,360
    80000f56:	fd5497e3          	bne	s1,s5,80000f24 <proc_mapstacks+0x4a>
  }
}
    80000f5a:	70e2                	ld	ra,56(sp)
    80000f5c:	7442                	ld	s0,48(sp)
    80000f5e:	74a2                	ld	s1,40(sp)
    80000f60:	7902                	ld	s2,32(sp)
    80000f62:	69e2                	ld	s3,24(sp)
    80000f64:	6a42                	ld	s4,16(sp)
    80000f66:	6aa2                	ld	s5,8(sp)
    80000f68:	6b02                	ld	s6,0(sp)
    80000f6a:	6121                	addi	sp,sp,64
    80000f6c:	8082                	ret
      panic("kalloc");
    80000f6e:	00007517          	auipc	a0,0x7
    80000f72:	1f250513          	addi	a0,a0,498 # 80008160 <etext+0x160>
    80000f76:	00005097          	auipc	ra,0x5
    80000f7a:	f66080e7          	jalr	-154(ra) # 80005edc <panic>

0000000080000f7e <procinit>:

// initialize the proc table at boot time.
void
procinit(void)
{
    80000f7e:	7139                	addi	sp,sp,-64
    80000f80:	fc06                	sd	ra,56(sp)
    80000f82:	f822                	sd	s0,48(sp)
    80000f84:	f426                	sd	s1,40(sp)
    80000f86:	f04a                	sd	s2,32(sp)
    80000f88:	ec4e                	sd	s3,24(sp)
    80000f8a:	e852                	sd	s4,16(sp)
    80000f8c:	e456                	sd	s5,8(sp)
    80000f8e:	e05a                	sd	s6,0(sp)
    80000f90:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f92:	00007597          	auipc	a1,0x7
    80000f96:	1d658593          	addi	a1,a1,470 # 80008168 <etext+0x168>
    80000f9a:	0022b517          	auipc	a0,0x22b
    80000f9e:	0ce50513          	addi	a0,a0,206 # 8022c068 <pid_lock>
    80000fa2:	00005097          	auipc	ra,0x5
    80000fa6:	424080e7          	jalr	1060(ra) # 800063c6 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000faa:	00007597          	auipc	a1,0x7
    80000fae:	1c658593          	addi	a1,a1,454 # 80008170 <etext+0x170>
    80000fb2:	0022b517          	auipc	a0,0x22b
    80000fb6:	0ce50513          	addi	a0,a0,206 # 8022c080 <wait_lock>
    80000fba:	00005097          	auipc	ra,0x5
    80000fbe:	40c080e7          	jalr	1036(ra) # 800063c6 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc2:	0022b497          	auipc	s1,0x22b
    80000fc6:	4d648493          	addi	s1,s1,1238 # 8022c498 <proc>
      initlock(&p->lock, "proc");
    80000fca:	00007b17          	auipc	s6,0x7
    80000fce:	1b6b0b13          	addi	s6,s6,438 # 80008180 <etext+0x180>
      p->kstack = KSTACK((int) (p - proc));
    80000fd2:	8aa6                	mv	s5,s1
    80000fd4:	04fa5937          	lui	s2,0x4fa5
    80000fd8:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80000fdc:	0932                	slli	s2,s2,0xc
    80000fde:	fa590913          	addi	s2,s2,-91
    80000fe2:	0932                	slli	s2,s2,0xc
    80000fe4:	fa590913          	addi	s2,s2,-91
    80000fe8:	0932                	slli	s2,s2,0xc
    80000fea:	fa590913          	addi	s2,s2,-91
    80000fee:	040009b7          	lui	s3,0x4000
    80000ff2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ff4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ff6:	00231a17          	auipc	s4,0x231
    80000ffa:	ea2a0a13          	addi	s4,s4,-350 # 80231e98 <tickslock>
      initlock(&p->lock, "proc");
    80000ffe:	85da                	mv	a1,s6
    80001000:	8526                	mv	a0,s1
    80001002:	00005097          	auipc	ra,0x5
    80001006:	3c4080e7          	jalr	964(ra) # 800063c6 <initlock>
      p->kstack = KSTACK((int) (p - proc));
    8000100a:	415487b3          	sub	a5,s1,s5
    8000100e:	878d                	srai	a5,a5,0x3
    80001010:	032787b3          	mul	a5,a5,s2
    80001014:	2785                	addiw	a5,a5,1
    80001016:	00d7979b          	slliw	a5,a5,0xd
    8000101a:	40f987b3          	sub	a5,s3,a5
    8000101e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001020:	16848493          	addi	s1,s1,360
    80001024:	fd449de3          	bne	s1,s4,80000ffe <procinit+0x80>
  }
}
    80001028:	70e2                	ld	ra,56(sp)
    8000102a:	7442                	ld	s0,48(sp)
    8000102c:	74a2                	ld	s1,40(sp)
    8000102e:	7902                	ld	s2,32(sp)
    80001030:	69e2                	ld	s3,24(sp)
    80001032:	6a42                	ld	s4,16(sp)
    80001034:	6aa2                	ld	s5,8(sp)
    80001036:	6b02                	ld	s6,0(sp)
    80001038:	6121                	addi	sp,sp,64
    8000103a:	8082                	ret

000000008000103c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000103c:	1141                	addi	sp,sp,-16
    8000103e:	e422                	sd	s0,8(sp)
    80001040:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001042:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001044:	2501                	sext.w	a0,a0
    80001046:	6422                	ld	s0,8(sp)
    80001048:	0141                	addi	sp,sp,16
    8000104a:	8082                	ret

000000008000104c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void) {
    8000104c:	1141                	addi	sp,sp,-16
    8000104e:	e422                	sd	s0,8(sp)
    80001050:	0800                	addi	s0,sp,16
    80001052:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001054:	2781                	sext.w	a5,a5
    80001056:	079e                	slli	a5,a5,0x7
  return c;
}
    80001058:	0022b517          	auipc	a0,0x22b
    8000105c:	04050513          	addi	a0,a0,64 # 8022c098 <cpus>
    80001060:	953e                	add	a0,a0,a5
    80001062:	6422                	ld	s0,8(sp)
    80001064:	0141                	addi	sp,sp,16
    80001066:	8082                	ret

0000000080001068 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void) {
    80001068:	1101                	addi	sp,sp,-32
    8000106a:	ec06                	sd	ra,24(sp)
    8000106c:	e822                	sd	s0,16(sp)
    8000106e:	e426                	sd	s1,8(sp)
    80001070:	1000                	addi	s0,sp,32
  push_off();
    80001072:	00005097          	auipc	ra,0x5
    80001076:	398080e7          	jalr	920(ra) # 8000640a <push_off>
    8000107a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000107c:	2781                	sext.w	a5,a5
    8000107e:	079e                	slli	a5,a5,0x7
    80001080:	0022b717          	auipc	a4,0x22b
    80001084:	fe870713          	addi	a4,a4,-24 # 8022c068 <pid_lock>
    80001088:	97ba                	add	a5,a5,a4
    8000108a:	7b84                	ld	s1,48(a5)
  pop_off();
    8000108c:	00005097          	auipc	ra,0x5
    80001090:	41e080e7          	jalr	1054(ra) # 800064aa <pop_off>
  return p;
}
    80001094:	8526                	mv	a0,s1
    80001096:	60e2                	ld	ra,24(sp)
    80001098:	6442                	ld	s0,16(sp)
    8000109a:	64a2                	ld	s1,8(sp)
    8000109c:	6105                	addi	sp,sp,32
    8000109e:	8082                	ret

00000000800010a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800010a0:	1141                	addi	sp,sp,-16
    800010a2:	e406                	sd	ra,8(sp)
    800010a4:	e022                	sd	s0,0(sp)
    800010a6:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800010a8:	00000097          	auipc	ra,0x0
    800010ac:	fc0080e7          	jalr	-64(ra) # 80001068 <myproc>
    800010b0:	00005097          	auipc	ra,0x5
    800010b4:	45a080e7          	jalr	1114(ra) # 8000650a <release>

  if (first) {
    800010b8:	0000a797          	auipc	a5,0xa
    800010bc:	0187a783          	lw	a5,24(a5) # 8000b0d0 <first.1>
    800010c0:	eb89                	bnez	a5,800010d2 <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800010c2:	00001097          	auipc	ra,0x1
    800010c6:	c16080e7          	jalr	-1002(ra) # 80001cd8 <usertrapret>
}
    800010ca:	60a2                	ld	ra,8(sp)
    800010cc:	6402                	ld	s0,0(sp)
    800010ce:	0141                	addi	sp,sp,16
    800010d0:	8082                	ret
    first = 0;
    800010d2:	0000a797          	auipc	a5,0xa
    800010d6:	fe07af23          	sw	zero,-2(a5) # 8000b0d0 <first.1>
    fsinit(ROOTDEV);
    800010da:	4505                	li	a0,1
    800010dc:	00002097          	auipc	ra,0x2
    800010e0:	a18080e7          	jalr	-1512(ra) # 80002af4 <fsinit>
    800010e4:	bff9                	j	800010c2 <forkret+0x22>

00000000800010e6 <allocpid>:
allocpid() {
    800010e6:	1101                	addi	sp,sp,-32
    800010e8:	ec06                	sd	ra,24(sp)
    800010ea:	e822                	sd	s0,16(sp)
    800010ec:	e426                	sd	s1,8(sp)
    800010ee:	e04a                	sd	s2,0(sp)
    800010f0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800010f2:	0022b917          	auipc	s2,0x22b
    800010f6:	f7690913          	addi	s2,s2,-138 # 8022c068 <pid_lock>
    800010fa:	854a                	mv	a0,s2
    800010fc:	00005097          	auipc	ra,0x5
    80001100:	35a080e7          	jalr	858(ra) # 80006456 <acquire>
  pid = nextpid;
    80001104:	0000a797          	auipc	a5,0xa
    80001108:	fd078793          	addi	a5,a5,-48 # 8000b0d4 <nextpid>
    8000110c:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000110e:	0014871b          	addiw	a4,s1,1
    80001112:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001114:	854a                	mv	a0,s2
    80001116:	00005097          	auipc	ra,0x5
    8000111a:	3f4080e7          	jalr	1012(ra) # 8000650a <release>
}
    8000111e:	8526                	mv	a0,s1
    80001120:	60e2                	ld	ra,24(sp)
    80001122:	6442                	ld	s0,16(sp)
    80001124:	64a2                	ld	s1,8(sp)
    80001126:	6902                	ld	s2,0(sp)
    80001128:	6105                	addi	sp,sp,32
    8000112a:	8082                	ret

000000008000112c <proc_pagetable>:
{
    8000112c:	1101                	addi	sp,sp,-32
    8000112e:	ec06                	sd	ra,24(sp)
    80001130:	e822                	sd	s0,16(sp)
    80001132:	e426                	sd	s1,8(sp)
    80001134:	e04a                	sd	s2,0(sp)
    80001136:	1000                	addi	s0,sp,32
    80001138:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    8000113a:	fffff097          	auipc	ra,0xfffff
    8000113e:	750080e7          	jalr	1872(ra) # 8000088a <uvmcreate>
    80001142:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001144:	c121                	beqz	a0,80001184 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001146:	4729                	li	a4,10
    80001148:	00006697          	auipc	a3,0x6
    8000114c:	eb868693          	addi	a3,a3,-328 # 80007000 <_trampoline>
    80001150:	6605                	lui	a2,0x1
    80001152:	040005b7          	lui	a1,0x4000
    80001156:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001158:	05b2                	slli	a1,a1,0xc
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	496080e7          	jalr	1174(ra) # 800005f0 <mappages>
    80001162:	02054863          	bltz	a0,80001192 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001166:	4719                	li	a4,6
    80001168:	05893683          	ld	a3,88(s2)
    8000116c:	6605                	lui	a2,0x1
    8000116e:	020005b7          	lui	a1,0x2000
    80001172:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001174:	05b6                	slli	a1,a1,0xd
    80001176:	8526                	mv	a0,s1
    80001178:	fffff097          	auipc	ra,0xfffff
    8000117c:	478080e7          	jalr	1144(ra) # 800005f0 <mappages>
    80001180:	02054163          	bltz	a0,800011a2 <proc_pagetable+0x76>
}
    80001184:	8526                	mv	a0,s1
    80001186:	60e2                	ld	ra,24(sp)
    80001188:	6442                	ld	s0,16(sp)
    8000118a:	64a2                	ld	s1,8(sp)
    8000118c:	6902                	ld	s2,0(sp)
    8000118e:	6105                	addi	sp,sp,32
    80001190:	8082                	ret
    uvmfree(pagetable, 0);
    80001192:	4581                	li	a1,0
    80001194:	8526                	mv	a0,s1
    80001196:	00000097          	auipc	ra,0x0
    8000119a:	8fa080e7          	jalr	-1798(ra) # 80000a90 <uvmfree>
    return 0;
    8000119e:	4481                	li	s1,0
    800011a0:	b7d5                	j	80001184 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011a2:	4681                	li	a3,0
    800011a4:	4605                	li	a2,1
    800011a6:	040005b7          	lui	a1,0x4000
    800011aa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011ac:	05b2                	slli	a1,a1,0xc
    800011ae:	8526                	mv	a0,s1
    800011b0:	fffff097          	auipc	ra,0xfffff
    800011b4:	606080e7          	jalr	1542(ra) # 800007b6 <uvmunmap>
    uvmfree(pagetable, 0);
    800011b8:	4581                	li	a1,0
    800011ba:	8526                	mv	a0,s1
    800011bc:	00000097          	auipc	ra,0x0
    800011c0:	8d4080e7          	jalr	-1836(ra) # 80000a90 <uvmfree>
    return 0;
    800011c4:	4481                	li	s1,0
    800011c6:	bf7d                	j	80001184 <proc_pagetable+0x58>

00000000800011c8 <proc_freepagetable>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	e04a                	sd	s2,0(sp)
    800011d2:	1000                	addi	s0,sp,32
    800011d4:	84aa                	mv	s1,a0
    800011d6:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011d8:	4681                	li	a3,0
    800011da:	4605                	li	a2,1
    800011dc:	040005b7          	lui	a1,0x4000
    800011e0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011e2:	05b2                	slli	a1,a1,0xc
    800011e4:	fffff097          	auipc	ra,0xfffff
    800011e8:	5d2080e7          	jalr	1490(ra) # 800007b6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011ec:	4681                	li	a3,0
    800011ee:	4605                	li	a2,1
    800011f0:	020005b7          	lui	a1,0x2000
    800011f4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011f6:	05b6                	slli	a1,a1,0xd
    800011f8:	8526                	mv	a0,s1
    800011fa:	fffff097          	auipc	ra,0xfffff
    800011fe:	5bc080e7          	jalr	1468(ra) # 800007b6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001202:	85ca                	mv	a1,s2
    80001204:	8526                	mv	a0,s1
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	88a080e7          	jalr	-1910(ra) # 80000a90 <uvmfree>
}
    8000120e:	60e2                	ld	ra,24(sp)
    80001210:	6442                	ld	s0,16(sp)
    80001212:	64a2                	ld	s1,8(sp)
    80001214:	6902                	ld	s2,0(sp)
    80001216:	6105                	addi	sp,sp,32
    80001218:	8082                	ret

000000008000121a <freeproc>:
{
    8000121a:	1101                	addi	sp,sp,-32
    8000121c:	ec06                	sd	ra,24(sp)
    8000121e:	e822                	sd	s0,16(sp)
    80001220:	e426                	sd	s1,8(sp)
    80001222:	1000                	addi	s0,sp,32
    80001224:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001226:	6d28                	ld	a0,88(a0)
    80001228:	c509                	beqz	a0,80001232 <freeproc+0x18>
    kfree((void*)p->trapframe);
    8000122a:	fffff097          	auipc	ra,0xfffff
    8000122e:	df2080e7          	jalr	-526(ra) # 8000001c <kfree>
  p->trapframe = 0;
    80001232:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001236:	68a8                	ld	a0,80(s1)
    80001238:	c511                	beqz	a0,80001244 <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    8000123a:	64ac                	ld	a1,72(s1)
    8000123c:	00000097          	auipc	ra,0x0
    80001240:	f8c080e7          	jalr	-116(ra) # 800011c8 <proc_freepagetable>
  p->pagetable = 0;
    80001244:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001248:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000124c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001250:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001254:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001258:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000125c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001260:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001264:	0004ac23          	sw	zero,24(s1)
}
    80001268:	60e2                	ld	ra,24(sp)
    8000126a:	6442                	ld	s0,16(sp)
    8000126c:	64a2                	ld	s1,8(sp)
    8000126e:	6105                	addi	sp,sp,32
    80001270:	8082                	ret

0000000080001272 <allocproc>:
{
    80001272:	1101                	addi	sp,sp,-32
    80001274:	ec06                	sd	ra,24(sp)
    80001276:	e822                	sd	s0,16(sp)
    80001278:	e426                	sd	s1,8(sp)
    8000127a:	e04a                	sd	s2,0(sp)
    8000127c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000127e:	0022b497          	auipc	s1,0x22b
    80001282:	21a48493          	addi	s1,s1,538 # 8022c498 <proc>
    80001286:	00231917          	auipc	s2,0x231
    8000128a:	c1290913          	addi	s2,s2,-1006 # 80231e98 <tickslock>
    acquire(&p->lock);
    8000128e:	8526                	mv	a0,s1
    80001290:	00005097          	auipc	ra,0x5
    80001294:	1c6080e7          	jalr	454(ra) # 80006456 <acquire>
    if(p->state == UNUSED) {
    80001298:	4c9c                	lw	a5,24(s1)
    8000129a:	cf81                	beqz	a5,800012b2 <allocproc+0x40>
      release(&p->lock);
    8000129c:	8526                	mv	a0,s1
    8000129e:	00005097          	auipc	ra,0x5
    800012a2:	26c080e7          	jalr	620(ra) # 8000650a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800012a6:	16848493          	addi	s1,s1,360
    800012aa:	ff2492e3          	bne	s1,s2,8000128e <allocproc+0x1c>
  return 0;
    800012ae:	4481                	li	s1,0
    800012b0:	a889                	j	80001302 <allocproc+0x90>
  p->pid = allocpid();
    800012b2:	00000097          	auipc	ra,0x0
    800012b6:	e34080e7          	jalr	-460(ra) # 800010e6 <allocpid>
    800012ba:	d888                	sw	a0,48(s1)
  p->state = USED;
    800012bc:	4785                	li	a5,1
    800012be:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800012c0:	fffff097          	auipc	ra,0xfffff
    800012c4:	ee2080e7          	jalr	-286(ra) # 800001a2 <kalloc>
    800012c8:	892a                	mv	s2,a0
    800012ca:	eca8                	sd	a0,88(s1)
    800012cc:	c131                	beqz	a0,80001310 <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800012ce:	8526                	mv	a0,s1
    800012d0:	00000097          	auipc	ra,0x0
    800012d4:	e5c080e7          	jalr	-420(ra) # 8000112c <proc_pagetable>
    800012d8:	892a                	mv	s2,a0
    800012da:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012dc:	c531                	beqz	a0,80001328 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800012de:	07000613          	li	a2,112
    800012e2:	4581                	li	a1,0
    800012e4:	06048513          	addi	a0,s1,96
    800012e8:	fffff097          	auipc	ra,0xfffff
    800012ec:	f48080e7          	jalr	-184(ra) # 80000230 <memset>
  p->context.ra = (uint64)forkret;
    800012f0:	00000797          	auipc	a5,0x0
    800012f4:	db078793          	addi	a5,a5,-592 # 800010a0 <forkret>
    800012f8:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012fa:	60bc                	ld	a5,64(s1)
    800012fc:	6705                	lui	a4,0x1
    800012fe:	97ba                	add	a5,a5,a4
    80001300:	f4bc                	sd	a5,104(s1)
}
    80001302:	8526                	mv	a0,s1
    80001304:	60e2                	ld	ra,24(sp)
    80001306:	6442                	ld	s0,16(sp)
    80001308:	64a2                	ld	s1,8(sp)
    8000130a:	6902                	ld	s2,0(sp)
    8000130c:	6105                	addi	sp,sp,32
    8000130e:	8082                	ret
    freeproc(p);
    80001310:	8526                	mv	a0,s1
    80001312:	00000097          	auipc	ra,0x0
    80001316:	f08080e7          	jalr	-248(ra) # 8000121a <freeproc>
    release(&p->lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	1ee080e7          	jalr	494(ra) # 8000650a <release>
    return 0;
    80001324:	84ca                	mv	s1,s2
    80001326:	bff1                	j	80001302 <allocproc+0x90>
    freeproc(p);
    80001328:	8526                	mv	a0,s1
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	ef0080e7          	jalr	-272(ra) # 8000121a <freeproc>
    release(&p->lock);
    80001332:	8526                	mv	a0,s1
    80001334:	00005097          	auipc	ra,0x5
    80001338:	1d6080e7          	jalr	470(ra) # 8000650a <release>
    return 0;
    8000133c:	84ca                	mv	s1,s2
    8000133e:	b7d1                	j	80001302 <allocproc+0x90>

0000000080001340 <userinit>:
{
    80001340:	1101                	addi	sp,sp,-32
    80001342:	ec06                	sd	ra,24(sp)
    80001344:	e822                	sd	s0,16(sp)
    80001346:	e426                	sd	s1,8(sp)
    80001348:	1000                	addi	s0,sp,32
  p = allocproc();
    8000134a:	00000097          	auipc	ra,0x0
    8000134e:	f28080e7          	jalr	-216(ra) # 80001272 <allocproc>
    80001352:	84aa                	mv	s1,a0
  initproc = p;
    80001354:	0000b797          	auipc	a5,0xb
    80001358:	caa7be23          	sd	a0,-836(a5) # 8000c010 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    8000135c:	03400613          	li	a2,52
    80001360:	0000a597          	auipc	a1,0xa
    80001364:	d8058593          	addi	a1,a1,-640 # 8000b0e0 <initcode>
    80001368:	6928                	ld	a0,80(a0)
    8000136a:	fffff097          	auipc	ra,0xfffff
    8000136e:	54e080e7          	jalr	1358(ra) # 800008b8 <uvminit>
  p->sz = PGSIZE;
    80001372:	6785                	lui	a5,0x1
    80001374:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001376:	6cb8                	ld	a4,88(s1)
    80001378:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    8000137c:	6cb8                	ld	a4,88(s1)
    8000137e:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001380:	4641                	li	a2,16
    80001382:	00007597          	auipc	a1,0x7
    80001386:	e0658593          	addi	a1,a1,-506 # 80008188 <etext+0x188>
    8000138a:	15848513          	addi	a0,s1,344
    8000138e:	fffff097          	auipc	ra,0xfffff
    80001392:	fe4080e7          	jalr	-28(ra) # 80000372 <safestrcpy>
  p->cwd = namei("/");
    80001396:	00007517          	auipc	a0,0x7
    8000139a:	e0250513          	addi	a0,a0,-510 # 80008198 <etext+0x198>
    8000139e:	00002097          	auipc	ra,0x2
    800013a2:	19c080e7          	jalr	412(ra) # 8000353a <namei>
    800013a6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013aa:	478d                	li	a5,3
    800013ac:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013ae:	8526                	mv	a0,s1
    800013b0:	00005097          	auipc	ra,0x5
    800013b4:	15a080e7          	jalr	346(ra) # 8000650a <release>
}
    800013b8:	60e2                	ld	ra,24(sp)
    800013ba:	6442                	ld	s0,16(sp)
    800013bc:	64a2                	ld	s1,8(sp)
    800013be:	6105                	addi	sp,sp,32
    800013c0:	8082                	ret

00000000800013c2 <growproc>:
{
    800013c2:	1101                	addi	sp,sp,-32
    800013c4:	ec06                	sd	ra,24(sp)
    800013c6:	e822                	sd	s0,16(sp)
    800013c8:	e426                	sd	s1,8(sp)
    800013ca:	e04a                	sd	s2,0(sp)
    800013cc:	1000                	addi	s0,sp,32
    800013ce:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800013d0:	00000097          	auipc	ra,0x0
    800013d4:	c98080e7          	jalr	-872(ra) # 80001068 <myproc>
    800013d8:	892a                	mv	s2,a0
  sz = p->sz;
    800013da:	652c                	ld	a1,72(a0)
    800013dc:	0005879b          	sext.w	a5,a1
  if(n > 0){
    800013e0:	00904f63          	bgtz	s1,800013fe <growproc+0x3c>
  } else if(n < 0){
    800013e4:	0204cd63          	bltz	s1,8000141e <growproc+0x5c>
  p->sz = sz;
    800013e8:	1782                	slli	a5,a5,0x20
    800013ea:	9381                	srli	a5,a5,0x20
    800013ec:	04f93423          	sd	a5,72(s2)
  return 0;
    800013f0:	4501                	li	a0,0
}
    800013f2:	60e2                	ld	ra,24(sp)
    800013f4:	6442                	ld	s0,16(sp)
    800013f6:	64a2                	ld	s1,8(sp)
    800013f8:	6902                	ld	s2,0(sp)
    800013fa:	6105                	addi	sp,sp,32
    800013fc:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    800013fe:	00f4863b          	addw	a2,s1,a5
    80001402:	1602                	slli	a2,a2,0x20
    80001404:	9201                	srli	a2,a2,0x20
    80001406:	1582                	slli	a1,a1,0x20
    80001408:	9181                	srli	a1,a1,0x20
    8000140a:	6928                	ld	a0,80(a0)
    8000140c:	fffff097          	auipc	ra,0xfffff
    80001410:	566080e7          	jalr	1382(ra) # 80000972 <uvmalloc>
    80001414:	0005079b          	sext.w	a5,a0
    80001418:	fbe1                	bnez	a5,800013e8 <growproc+0x26>
      return -1;
    8000141a:	557d                	li	a0,-1
    8000141c:	bfd9                	j	800013f2 <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000141e:	00f4863b          	addw	a2,s1,a5
    80001422:	1602                	slli	a2,a2,0x20
    80001424:	9201                	srli	a2,a2,0x20
    80001426:	1582                	slli	a1,a1,0x20
    80001428:	9181                	srli	a1,a1,0x20
    8000142a:	6928                	ld	a0,80(a0)
    8000142c:	fffff097          	auipc	ra,0xfffff
    80001430:	4fe080e7          	jalr	1278(ra) # 8000092a <uvmdealloc>
    80001434:	0005079b          	sext.w	a5,a0
    80001438:	bf45                	j	800013e8 <growproc+0x26>

000000008000143a <fork>:
{
    8000143a:	7139                	addi	sp,sp,-64
    8000143c:	fc06                	sd	ra,56(sp)
    8000143e:	f822                	sd	s0,48(sp)
    80001440:	f04a                	sd	s2,32(sp)
    80001442:	e456                	sd	s5,8(sp)
    80001444:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	c22080e7          	jalr	-990(ra) # 80001068 <myproc>
    8000144e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001450:	00000097          	auipc	ra,0x0
    80001454:	e22080e7          	jalr	-478(ra) # 80001272 <allocproc>
    80001458:	12050063          	beqz	a0,80001578 <fork+0x13e>
    8000145c:	e852                	sd	s4,16(sp)
    8000145e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001460:	048ab603          	ld	a2,72(s5)
    80001464:	692c                	ld	a1,80(a0)
    80001466:	050ab503          	ld	a0,80(s5)
    8000146a:	fffff097          	auipc	ra,0xfffff
    8000146e:	660080e7          	jalr	1632(ra) # 80000aca <uvmcopy>
    80001472:	04054a63          	bltz	a0,800014c6 <fork+0x8c>
    80001476:	f426                	sd	s1,40(sp)
    80001478:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000147a:	048ab783          	ld	a5,72(s5)
    8000147e:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001482:	058ab683          	ld	a3,88(s5)
    80001486:	87b6                	mv	a5,a3
    80001488:	058a3703          	ld	a4,88(s4)
    8000148c:	12068693          	addi	a3,a3,288
    80001490:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001494:	6788                	ld	a0,8(a5)
    80001496:	6b8c                	ld	a1,16(a5)
    80001498:	6f90                	ld	a2,24(a5)
    8000149a:	01073023          	sd	a6,0(a4)
    8000149e:	e708                	sd	a0,8(a4)
    800014a0:	eb0c                	sd	a1,16(a4)
    800014a2:	ef10                	sd	a2,24(a4)
    800014a4:	02078793          	addi	a5,a5,32
    800014a8:	02070713          	addi	a4,a4,32
    800014ac:	fed792e3          	bne	a5,a3,80001490 <fork+0x56>
  np->trapframe->a0 = 0;
    800014b0:	058a3783          	ld	a5,88(s4)
    800014b4:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800014b8:	0d0a8493          	addi	s1,s5,208
    800014bc:	0d0a0913          	addi	s2,s4,208
    800014c0:	150a8993          	addi	s3,s5,336
    800014c4:	a015                	j	800014e8 <fork+0xae>
    freeproc(np);
    800014c6:	8552                	mv	a0,s4
    800014c8:	00000097          	auipc	ra,0x0
    800014cc:	d52080e7          	jalr	-686(ra) # 8000121a <freeproc>
    release(&np->lock);
    800014d0:	8552                	mv	a0,s4
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	038080e7          	jalr	56(ra) # 8000650a <release>
    return -1;
    800014da:	597d                	li	s2,-1
    800014dc:	6a42                	ld	s4,16(sp)
    800014de:	a071                	j	8000156a <fork+0x130>
  for(i = 0; i < NOFILE; i++)
    800014e0:	04a1                	addi	s1,s1,8
    800014e2:	0921                	addi	s2,s2,8
    800014e4:	01348b63          	beq	s1,s3,800014fa <fork+0xc0>
    if(p->ofile[i])
    800014e8:	6088                	ld	a0,0(s1)
    800014ea:	d97d                	beqz	a0,800014e0 <fork+0xa6>
      np->ofile[i] = filedup(p->ofile[i]);
    800014ec:	00002097          	auipc	ra,0x2
    800014f0:	6c6080e7          	jalr	1734(ra) # 80003bb2 <filedup>
    800014f4:	00a93023          	sd	a0,0(s2)
    800014f8:	b7e5                	j	800014e0 <fork+0xa6>
  np->cwd = idup(p->cwd);
    800014fa:	150ab503          	ld	a0,336(s5)
    800014fe:	00002097          	auipc	ra,0x2
    80001502:	82c080e7          	jalr	-2004(ra) # 80002d2a <idup>
    80001506:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000150a:	4641                	li	a2,16
    8000150c:	158a8593          	addi	a1,s5,344
    80001510:	158a0513          	addi	a0,s4,344
    80001514:	fffff097          	auipc	ra,0xfffff
    80001518:	e5e080e7          	jalr	-418(ra) # 80000372 <safestrcpy>
  pid = np->pid;
    8000151c:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001520:	8552                	mv	a0,s4
    80001522:	00005097          	auipc	ra,0x5
    80001526:	fe8080e7          	jalr	-24(ra) # 8000650a <release>
  acquire(&wait_lock);
    8000152a:	0022b497          	auipc	s1,0x22b
    8000152e:	b5648493          	addi	s1,s1,-1194 # 8022c080 <wait_lock>
    80001532:	8526                	mv	a0,s1
    80001534:	00005097          	auipc	ra,0x5
    80001538:	f22080e7          	jalr	-222(ra) # 80006456 <acquire>
  np->parent = p;
    8000153c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001540:	8526                	mv	a0,s1
    80001542:	00005097          	auipc	ra,0x5
    80001546:	fc8080e7          	jalr	-56(ra) # 8000650a <release>
  acquire(&np->lock);
    8000154a:	8552                	mv	a0,s4
    8000154c:	00005097          	auipc	ra,0x5
    80001550:	f0a080e7          	jalr	-246(ra) # 80006456 <acquire>
  np->state = RUNNABLE;
    80001554:	478d                	li	a5,3
    80001556:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000155a:	8552                	mv	a0,s4
    8000155c:	00005097          	auipc	ra,0x5
    80001560:	fae080e7          	jalr	-82(ra) # 8000650a <release>
  return pid;
    80001564:	74a2                	ld	s1,40(sp)
    80001566:	69e2                	ld	s3,24(sp)
    80001568:	6a42                	ld	s4,16(sp)
}
    8000156a:	854a                	mv	a0,s2
    8000156c:	70e2                	ld	ra,56(sp)
    8000156e:	7442                	ld	s0,48(sp)
    80001570:	7902                	ld	s2,32(sp)
    80001572:	6aa2                	ld	s5,8(sp)
    80001574:	6121                	addi	sp,sp,64
    80001576:	8082                	ret
    return -1;
    80001578:	597d                	li	s2,-1
    8000157a:	bfc5                	j	8000156a <fork+0x130>

000000008000157c <scheduler>:
{
    8000157c:	7139                	addi	sp,sp,-64
    8000157e:	fc06                	sd	ra,56(sp)
    80001580:	f822                	sd	s0,48(sp)
    80001582:	f426                	sd	s1,40(sp)
    80001584:	f04a                	sd	s2,32(sp)
    80001586:	ec4e                	sd	s3,24(sp)
    80001588:	e852                	sd	s4,16(sp)
    8000158a:	e456                	sd	s5,8(sp)
    8000158c:	e05a                	sd	s6,0(sp)
    8000158e:	0080                	addi	s0,sp,64
    80001590:	8792                	mv	a5,tp
  int id = r_tp();
    80001592:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001594:	00779a93          	slli	s5,a5,0x7
    80001598:	0022b717          	auipc	a4,0x22b
    8000159c:	ad070713          	addi	a4,a4,-1328 # 8022c068 <pid_lock>
    800015a0:	9756                	add	a4,a4,s5
    800015a2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015a6:	0022b717          	auipc	a4,0x22b
    800015aa:	afa70713          	addi	a4,a4,-1286 # 8022c0a0 <cpus+0x8>
    800015ae:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    800015b0:	498d                	li	s3,3
        p->state = RUNNING;
    800015b2:	4b11                	li	s6,4
        c->proc = p;
    800015b4:	079e                	slli	a5,a5,0x7
    800015b6:	0022ba17          	auipc	s4,0x22b
    800015ba:	ab2a0a13          	addi	s4,s4,-1358 # 8022c068 <pid_lock>
    800015be:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    800015c0:	00231917          	auipc	s2,0x231
    800015c4:	8d890913          	addi	s2,s2,-1832 # 80231e98 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800015c8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800015cc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800015d0:	10079073          	csrw	sstatus,a5
    800015d4:	0022b497          	auipc	s1,0x22b
    800015d8:	ec448493          	addi	s1,s1,-316 # 8022c498 <proc>
    800015dc:	a811                	j	800015f0 <scheduler+0x74>
      release(&p->lock);
    800015de:	8526                	mv	a0,s1
    800015e0:	00005097          	auipc	ra,0x5
    800015e4:	f2a080e7          	jalr	-214(ra) # 8000650a <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015e8:	16848493          	addi	s1,s1,360
    800015ec:	fd248ee3          	beq	s1,s2,800015c8 <scheduler+0x4c>
      acquire(&p->lock);
    800015f0:	8526                	mv	a0,s1
    800015f2:	00005097          	auipc	ra,0x5
    800015f6:	e64080e7          	jalr	-412(ra) # 80006456 <acquire>
      if(p->state == RUNNABLE) {
    800015fa:	4c9c                	lw	a5,24(s1)
    800015fc:	ff3791e3          	bne	a5,s3,800015de <scheduler+0x62>
        p->state = RUNNING;
    80001600:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80001604:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001608:	06048593          	addi	a1,s1,96
    8000160c:	8556                	mv	a0,s5
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	620080e7          	jalr	1568(ra) # 80001c2e <swtch>
        c->proc = 0;
    80001616:	020a3823          	sd	zero,48(s4)
    8000161a:	b7d1                	j	800015de <scheduler+0x62>

000000008000161c <sched>:
{
    8000161c:	7179                	addi	sp,sp,-48
    8000161e:	f406                	sd	ra,40(sp)
    80001620:	f022                	sd	s0,32(sp)
    80001622:	ec26                	sd	s1,24(sp)
    80001624:	e84a                	sd	s2,16(sp)
    80001626:	e44e                	sd	s3,8(sp)
    80001628:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000162a:	00000097          	auipc	ra,0x0
    8000162e:	a3e080e7          	jalr	-1474(ra) # 80001068 <myproc>
    80001632:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001634:	00005097          	auipc	ra,0x5
    80001638:	da8080e7          	jalr	-600(ra) # 800063dc <holding>
    8000163c:	c93d                	beqz	a0,800016b2 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000163e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001640:	2781                	sext.w	a5,a5
    80001642:	079e                	slli	a5,a5,0x7
    80001644:	0022b717          	auipc	a4,0x22b
    80001648:	a2470713          	addi	a4,a4,-1500 # 8022c068 <pid_lock>
    8000164c:	97ba                	add	a5,a5,a4
    8000164e:	0a87a703          	lw	a4,168(a5)
    80001652:	4785                	li	a5,1
    80001654:	06f71763          	bne	a4,a5,800016c2 <sched+0xa6>
  if(p->state == RUNNING)
    80001658:	4c98                	lw	a4,24(s1)
    8000165a:	4791                	li	a5,4
    8000165c:	06f70b63          	beq	a4,a5,800016d2 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001660:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001664:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001666:	efb5                	bnez	a5,800016e2 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001668:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000166a:	0022b917          	auipc	s2,0x22b
    8000166e:	9fe90913          	addi	s2,s2,-1538 # 8022c068 <pid_lock>
    80001672:	2781                	sext.w	a5,a5
    80001674:	079e                	slli	a5,a5,0x7
    80001676:	97ca                	add	a5,a5,s2
    80001678:	0ac7a983          	lw	s3,172(a5)
    8000167c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000167e:	2781                	sext.w	a5,a5
    80001680:	079e                	slli	a5,a5,0x7
    80001682:	0022b597          	auipc	a1,0x22b
    80001686:	a1e58593          	addi	a1,a1,-1506 # 8022c0a0 <cpus+0x8>
    8000168a:	95be                	add	a1,a1,a5
    8000168c:	06048513          	addi	a0,s1,96
    80001690:	00000097          	auipc	ra,0x0
    80001694:	59e080e7          	jalr	1438(ra) # 80001c2e <swtch>
    80001698:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000169a:	2781                	sext.w	a5,a5
    8000169c:	079e                	slli	a5,a5,0x7
    8000169e:	993e                	add	s2,s2,a5
    800016a0:	0b392623          	sw	s3,172(s2)
}
    800016a4:	70a2                	ld	ra,40(sp)
    800016a6:	7402                	ld	s0,32(sp)
    800016a8:	64e2                	ld	s1,24(sp)
    800016aa:	6942                	ld	s2,16(sp)
    800016ac:	69a2                	ld	s3,8(sp)
    800016ae:	6145                	addi	sp,sp,48
    800016b0:	8082                	ret
    panic("sched p->lock");
    800016b2:	00007517          	auipc	a0,0x7
    800016b6:	aee50513          	addi	a0,a0,-1298 # 800081a0 <etext+0x1a0>
    800016ba:	00005097          	auipc	ra,0x5
    800016be:	822080e7          	jalr	-2014(ra) # 80005edc <panic>
    panic("sched locks");
    800016c2:	00007517          	auipc	a0,0x7
    800016c6:	aee50513          	addi	a0,a0,-1298 # 800081b0 <etext+0x1b0>
    800016ca:	00005097          	auipc	ra,0x5
    800016ce:	812080e7          	jalr	-2030(ra) # 80005edc <panic>
    panic("sched running");
    800016d2:	00007517          	auipc	a0,0x7
    800016d6:	aee50513          	addi	a0,a0,-1298 # 800081c0 <etext+0x1c0>
    800016da:	00005097          	auipc	ra,0x5
    800016de:	802080e7          	jalr	-2046(ra) # 80005edc <panic>
    panic("sched interruptible");
    800016e2:	00007517          	auipc	a0,0x7
    800016e6:	aee50513          	addi	a0,a0,-1298 # 800081d0 <etext+0x1d0>
    800016ea:	00004097          	auipc	ra,0x4
    800016ee:	7f2080e7          	jalr	2034(ra) # 80005edc <panic>

00000000800016f2 <yield>:
{
    800016f2:	1101                	addi	sp,sp,-32
    800016f4:	ec06                	sd	ra,24(sp)
    800016f6:	e822                	sd	s0,16(sp)
    800016f8:	e426                	sd	s1,8(sp)
    800016fa:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	96c080e7          	jalr	-1684(ra) # 80001068 <myproc>
    80001704:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001706:	00005097          	auipc	ra,0x5
    8000170a:	d50080e7          	jalr	-688(ra) # 80006456 <acquire>
  p->state = RUNNABLE;
    8000170e:	478d                	li	a5,3
    80001710:	cc9c                	sw	a5,24(s1)
  sched();
    80001712:	00000097          	auipc	ra,0x0
    80001716:	f0a080e7          	jalr	-246(ra) # 8000161c <sched>
  release(&p->lock);
    8000171a:	8526                	mv	a0,s1
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	dee080e7          	jalr	-530(ra) # 8000650a <release>
}
    80001724:	60e2                	ld	ra,24(sp)
    80001726:	6442                	ld	s0,16(sp)
    80001728:	64a2                	ld	s1,8(sp)
    8000172a:	6105                	addi	sp,sp,32
    8000172c:	8082                	ret

000000008000172e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000172e:	7179                	addi	sp,sp,-48
    80001730:	f406                	sd	ra,40(sp)
    80001732:	f022                	sd	s0,32(sp)
    80001734:	ec26                	sd	s1,24(sp)
    80001736:	e84a                	sd	s2,16(sp)
    80001738:	e44e                	sd	s3,8(sp)
    8000173a:	1800                	addi	s0,sp,48
    8000173c:	89aa                	mv	s3,a0
    8000173e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001740:	00000097          	auipc	ra,0x0
    80001744:	928080e7          	jalr	-1752(ra) # 80001068 <myproc>
    80001748:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000174a:	00005097          	auipc	ra,0x5
    8000174e:	d0c080e7          	jalr	-756(ra) # 80006456 <acquire>
  release(lk);
    80001752:	854a                	mv	a0,s2
    80001754:	00005097          	auipc	ra,0x5
    80001758:	db6080e7          	jalr	-586(ra) # 8000650a <release>

  // Go to sleep.
  p->chan = chan;
    8000175c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001760:	4789                	li	a5,2
    80001762:	cc9c                	sw	a5,24(s1)

  sched();
    80001764:	00000097          	auipc	ra,0x0
    80001768:	eb8080e7          	jalr	-328(ra) # 8000161c <sched>

  // Tidy up.
  p->chan = 0;
    8000176c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001770:	8526                	mv	a0,s1
    80001772:	00005097          	auipc	ra,0x5
    80001776:	d98080e7          	jalr	-616(ra) # 8000650a <release>
  acquire(lk);
    8000177a:	854a                	mv	a0,s2
    8000177c:	00005097          	auipc	ra,0x5
    80001780:	cda080e7          	jalr	-806(ra) # 80006456 <acquire>
}
    80001784:	70a2                	ld	ra,40(sp)
    80001786:	7402                	ld	s0,32(sp)
    80001788:	64e2                	ld	s1,24(sp)
    8000178a:	6942                	ld	s2,16(sp)
    8000178c:	69a2                	ld	s3,8(sp)
    8000178e:	6145                	addi	sp,sp,48
    80001790:	8082                	ret

0000000080001792 <wait>:
{
    80001792:	715d                	addi	sp,sp,-80
    80001794:	e486                	sd	ra,72(sp)
    80001796:	e0a2                	sd	s0,64(sp)
    80001798:	fc26                	sd	s1,56(sp)
    8000179a:	f84a                	sd	s2,48(sp)
    8000179c:	f44e                	sd	s3,40(sp)
    8000179e:	f052                	sd	s4,32(sp)
    800017a0:	ec56                	sd	s5,24(sp)
    800017a2:	e85a                	sd	s6,16(sp)
    800017a4:	e45e                	sd	s7,8(sp)
    800017a6:	e062                	sd	s8,0(sp)
    800017a8:	0880                	addi	s0,sp,80
    800017aa:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800017ac:	00000097          	auipc	ra,0x0
    800017b0:	8bc080e7          	jalr	-1860(ra) # 80001068 <myproc>
    800017b4:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800017b6:	0022b517          	auipc	a0,0x22b
    800017ba:	8ca50513          	addi	a0,a0,-1846 # 8022c080 <wait_lock>
    800017be:	00005097          	auipc	ra,0x5
    800017c2:	c98080e7          	jalr	-872(ra) # 80006456 <acquire>
    havekids = 0;
    800017c6:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800017c8:	4a15                	li	s4,5
        havekids = 1;
    800017ca:	4a85                	li	s5,1
    for(np = proc; np < &proc[NPROC]; np++){
    800017cc:	00230997          	auipc	s3,0x230
    800017d0:	6cc98993          	addi	s3,s3,1740 # 80231e98 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017d4:	0022bc17          	auipc	s8,0x22b
    800017d8:	8acc0c13          	addi	s8,s8,-1876 # 8022c080 <wait_lock>
    800017dc:	a87d                	j	8000189a <wait+0x108>
          pid = np->pid;
    800017de:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800017e2:	000b0e63          	beqz	s6,800017fe <wait+0x6c>
    800017e6:	4691                	li	a3,4
    800017e8:	02c48613          	addi	a2,s1,44
    800017ec:	85da                	mv	a1,s6
    800017ee:	05093503          	ld	a0,80(s2)
    800017f2:	fffff097          	auipc	ra,0xfffff
    800017f6:	400080e7          	jalr	1024(ra) # 80000bf2 <copyout>
    800017fa:	04054163          	bltz	a0,8000183c <wait+0xaa>
          freeproc(np);
    800017fe:	8526                	mv	a0,s1
    80001800:	00000097          	auipc	ra,0x0
    80001804:	a1a080e7          	jalr	-1510(ra) # 8000121a <freeproc>
          release(&np->lock);
    80001808:	8526                	mv	a0,s1
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	d00080e7          	jalr	-768(ra) # 8000650a <release>
          release(&wait_lock);
    80001812:	0022b517          	auipc	a0,0x22b
    80001816:	86e50513          	addi	a0,a0,-1938 # 8022c080 <wait_lock>
    8000181a:	00005097          	auipc	ra,0x5
    8000181e:	cf0080e7          	jalr	-784(ra) # 8000650a <release>
}
    80001822:	854e                	mv	a0,s3
    80001824:	60a6                	ld	ra,72(sp)
    80001826:	6406                	ld	s0,64(sp)
    80001828:	74e2                	ld	s1,56(sp)
    8000182a:	7942                	ld	s2,48(sp)
    8000182c:	79a2                	ld	s3,40(sp)
    8000182e:	7a02                	ld	s4,32(sp)
    80001830:	6ae2                	ld	s5,24(sp)
    80001832:	6b42                	ld	s6,16(sp)
    80001834:	6ba2                	ld	s7,8(sp)
    80001836:	6c02                	ld	s8,0(sp)
    80001838:	6161                	addi	sp,sp,80
    8000183a:	8082                	ret
            release(&np->lock);
    8000183c:	8526                	mv	a0,s1
    8000183e:	00005097          	auipc	ra,0x5
    80001842:	ccc080e7          	jalr	-820(ra) # 8000650a <release>
            release(&wait_lock);
    80001846:	0022b517          	auipc	a0,0x22b
    8000184a:	83a50513          	addi	a0,a0,-1990 # 8022c080 <wait_lock>
    8000184e:	00005097          	auipc	ra,0x5
    80001852:	cbc080e7          	jalr	-836(ra) # 8000650a <release>
            return -1;
    80001856:	59fd                	li	s3,-1
    80001858:	b7e9                	j	80001822 <wait+0x90>
    for(np = proc; np < &proc[NPROC]; np++){
    8000185a:	16848493          	addi	s1,s1,360
    8000185e:	03348463          	beq	s1,s3,80001886 <wait+0xf4>
      if(np->parent == p){
    80001862:	7c9c                	ld	a5,56(s1)
    80001864:	ff279be3          	bne	a5,s2,8000185a <wait+0xc8>
        acquire(&np->lock);
    80001868:	8526                	mv	a0,s1
    8000186a:	00005097          	auipc	ra,0x5
    8000186e:	bec080e7          	jalr	-1044(ra) # 80006456 <acquire>
        if(np->state == ZOMBIE){
    80001872:	4c9c                	lw	a5,24(s1)
    80001874:	f74785e3          	beq	a5,s4,800017de <wait+0x4c>
        release(&np->lock);
    80001878:	8526                	mv	a0,s1
    8000187a:	00005097          	auipc	ra,0x5
    8000187e:	c90080e7          	jalr	-880(ra) # 8000650a <release>
        havekids = 1;
    80001882:	8756                	mv	a4,s5
    80001884:	bfd9                	j	8000185a <wait+0xc8>
    if(!havekids || p->killed){
    80001886:	c305                	beqz	a4,800018a6 <wait+0x114>
    80001888:	02892783          	lw	a5,40(s2)
    8000188c:	ef89                	bnez	a5,800018a6 <wait+0x114>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000188e:	85e2                	mv	a1,s8
    80001890:	854a                	mv	a0,s2
    80001892:	00000097          	auipc	ra,0x0
    80001896:	e9c080e7          	jalr	-356(ra) # 8000172e <sleep>
    havekids = 0;
    8000189a:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    8000189c:	0022b497          	auipc	s1,0x22b
    800018a0:	bfc48493          	addi	s1,s1,-1028 # 8022c498 <proc>
    800018a4:	bf7d                	j	80001862 <wait+0xd0>
      release(&wait_lock);
    800018a6:	0022a517          	auipc	a0,0x22a
    800018aa:	7da50513          	addi	a0,a0,2010 # 8022c080 <wait_lock>
    800018ae:	00005097          	auipc	ra,0x5
    800018b2:	c5c080e7          	jalr	-932(ra) # 8000650a <release>
      return -1;
    800018b6:	59fd                	li	s3,-1
    800018b8:	b7ad                	j	80001822 <wait+0x90>

00000000800018ba <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800018ba:	7139                	addi	sp,sp,-64
    800018bc:	fc06                	sd	ra,56(sp)
    800018be:	f822                	sd	s0,48(sp)
    800018c0:	f426                	sd	s1,40(sp)
    800018c2:	f04a                	sd	s2,32(sp)
    800018c4:	ec4e                	sd	s3,24(sp)
    800018c6:	e852                	sd	s4,16(sp)
    800018c8:	e456                	sd	s5,8(sp)
    800018ca:	0080                	addi	s0,sp,64
    800018cc:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800018ce:	0022b497          	auipc	s1,0x22b
    800018d2:	bca48493          	addi	s1,s1,-1078 # 8022c498 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800018d6:	4989                	li	s3,2
        p->state = RUNNABLE;
    800018d8:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800018da:	00230917          	auipc	s2,0x230
    800018de:	5be90913          	addi	s2,s2,1470 # 80231e98 <tickslock>
    800018e2:	a811                	j	800018f6 <wakeup+0x3c>
      }
      release(&p->lock);
    800018e4:	8526                	mv	a0,s1
    800018e6:	00005097          	auipc	ra,0x5
    800018ea:	c24080e7          	jalr	-988(ra) # 8000650a <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ee:	16848493          	addi	s1,s1,360
    800018f2:	03248663          	beq	s1,s2,8000191e <wakeup+0x64>
    if(p != myproc()){
    800018f6:	fffff097          	auipc	ra,0xfffff
    800018fa:	772080e7          	jalr	1906(ra) # 80001068 <myproc>
    800018fe:	fea488e3          	beq	s1,a0,800018ee <wakeup+0x34>
      acquire(&p->lock);
    80001902:	8526                	mv	a0,s1
    80001904:	00005097          	auipc	ra,0x5
    80001908:	b52080e7          	jalr	-1198(ra) # 80006456 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000190c:	4c9c                	lw	a5,24(s1)
    8000190e:	fd379be3          	bne	a5,s3,800018e4 <wakeup+0x2a>
    80001912:	709c                	ld	a5,32(s1)
    80001914:	fd4798e3          	bne	a5,s4,800018e4 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001918:	0154ac23          	sw	s5,24(s1)
    8000191c:	b7e1                	j	800018e4 <wakeup+0x2a>
    }
  }
}
    8000191e:	70e2                	ld	ra,56(sp)
    80001920:	7442                	ld	s0,48(sp)
    80001922:	74a2                	ld	s1,40(sp)
    80001924:	7902                	ld	s2,32(sp)
    80001926:	69e2                	ld	s3,24(sp)
    80001928:	6a42                	ld	s4,16(sp)
    8000192a:	6aa2                	ld	s5,8(sp)
    8000192c:	6121                	addi	sp,sp,64
    8000192e:	8082                	ret

0000000080001930 <reparent>:
{
    80001930:	7179                	addi	sp,sp,-48
    80001932:	f406                	sd	ra,40(sp)
    80001934:	f022                	sd	s0,32(sp)
    80001936:	ec26                	sd	s1,24(sp)
    80001938:	e84a                	sd	s2,16(sp)
    8000193a:	e44e                	sd	s3,8(sp)
    8000193c:	e052                	sd	s4,0(sp)
    8000193e:	1800                	addi	s0,sp,48
    80001940:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001942:	0022b497          	auipc	s1,0x22b
    80001946:	b5648493          	addi	s1,s1,-1194 # 8022c498 <proc>
      pp->parent = initproc;
    8000194a:	0000aa17          	auipc	s4,0xa
    8000194e:	6c6a0a13          	addi	s4,s4,1734 # 8000c010 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001952:	00230997          	auipc	s3,0x230
    80001956:	54698993          	addi	s3,s3,1350 # 80231e98 <tickslock>
    8000195a:	a029                	j	80001964 <reparent+0x34>
    8000195c:	16848493          	addi	s1,s1,360
    80001960:	01348d63          	beq	s1,s3,8000197a <reparent+0x4a>
    if(pp->parent == p){
    80001964:	7c9c                	ld	a5,56(s1)
    80001966:	ff279be3          	bne	a5,s2,8000195c <reparent+0x2c>
      pp->parent = initproc;
    8000196a:	000a3503          	ld	a0,0(s4)
    8000196e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001970:	00000097          	auipc	ra,0x0
    80001974:	f4a080e7          	jalr	-182(ra) # 800018ba <wakeup>
    80001978:	b7d5                	j	8000195c <reparent+0x2c>
}
    8000197a:	70a2                	ld	ra,40(sp)
    8000197c:	7402                	ld	s0,32(sp)
    8000197e:	64e2                	ld	s1,24(sp)
    80001980:	6942                	ld	s2,16(sp)
    80001982:	69a2                	ld	s3,8(sp)
    80001984:	6a02                	ld	s4,0(sp)
    80001986:	6145                	addi	sp,sp,48
    80001988:	8082                	ret

000000008000198a <exit>:
{
    8000198a:	7179                	addi	sp,sp,-48
    8000198c:	f406                	sd	ra,40(sp)
    8000198e:	f022                	sd	s0,32(sp)
    80001990:	ec26                	sd	s1,24(sp)
    80001992:	e84a                	sd	s2,16(sp)
    80001994:	e44e                	sd	s3,8(sp)
    80001996:	e052                	sd	s4,0(sp)
    80001998:	1800                	addi	s0,sp,48
    8000199a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	6cc080e7          	jalr	1740(ra) # 80001068 <myproc>
    800019a4:	89aa                	mv	s3,a0
  if(p == initproc)
    800019a6:	0000a797          	auipc	a5,0xa
    800019aa:	66a7b783          	ld	a5,1642(a5) # 8000c010 <initproc>
    800019ae:	0d050493          	addi	s1,a0,208
    800019b2:	15050913          	addi	s2,a0,336
    800019b6:	02a79363          	bne	a5,a0,800019dc <exit+0x52>
    panic("init exiting");
    800019ba:	00007517          	auipc	a0,0x7
    800019be:	82e50513          	addi	a0,a0,-2002 # 800081e8 <etext+0x1e8>
    800019c2:	00004097          	auipc	ra,0x4
    800019c6:	51a080e7          	jalr	1306(ra) # 80005edc <panic>
      fileclose(f);
    800019ca:	00002097          	auipc	ra,0x2
    800019ce:	23a080e7          	jalr	570(ra) # 80003c04 <fileclose>
      p->ofile[fd] = 0;
    800019d2:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800019d6:	04a1                	addi	s1,s1,8
    800019d8:	01248563          	beq	s1,s2,800019e2 <exit+0x58>
    if(p->ofile[fd]){
    800019dc:	6088                	ld	a0,0(s1)
    800019de:	f575                	bnez	a0,800019ca <exit+0x40>
    800019e0:	bfdd                	j	800019d6 <exit+0x4c>
  begin_op();
    800019e2:	00002097          	auipc	ra,0x2
    800019e6:	d58080e7          	jalr	-680(ra) # 8000373a <begin_op>
  iput(p->cwd);
    800019ea:	1509b503          	ld	a0,336(s3)
    800019ee:	00001097          	auipc	ra,0x1
    800019f2:	538080e7          	jalr	1336(ra) # 80002f26 <iput>
  end_op();
    800019f6:	00002097          	auipc	ra,0x2
    800019fa:	dbe080e7          	jalr	-578(ra) # 800037b4 <end_op>
  p->cwd = 0;
    800019fe:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001a02:	0022a497          	auipc	s1,0x22a
    80001a06:	67e48493          	addi	s1,s1,1662 # 8022c080 <wait_lock>
    80001a0a:	8526                	mv	a0,s1
    80001a0c:	00005097          	auipc	ra,0x5
    80001a10:	a4a080e7          	jalr	-1462(ra) # 80006456 <acquire>
  reparent(p);
    80001a14:	854e                	mv	a0,s3
    80001a16:	00000097          	auipc	ra,0x0
    80001a1a:	f1a080e7          	jalr	-230(ra) # 80001930 <reparent>
  wakeup(p->parent);
    80001a1e:	0389b503          	ld	a0,56(s3)
    80001a22:	00000097          	auipc	ra,0x0
    80001a26:	e98080e7          	jalr	-360(ra) # 800018ba <wakeup>
  acquire(&p->lock);
    80001a2a:	854e                	mv	a0,s3
    80001a2c:	00005097          	auipc	ra,0x5
    80001a30:	a2a080e7          	jalr	-1494(ra) # 80006456 <acquire>
  p->xstate = status;
    80001a34:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001a38:	4795                	li	a5,5
    80001a3a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001a3e:	8526                	mv	a0,s1
    80001a40:	00005097          	auipc	ra,0x5
    80001a44:	aca080e7          	jalr	-1334(ra) # 8000650a <release>
  sched();
    80001a48:	00000097          	auipc	ra,0x0
    80001a4c:	bd4080e7          	jalr	-1068(ra) # 8000161c <sched>
  panic("zombie exit");
    80001a50:	00006517          	auipc	a0,0x6
    80001a54:	7a850513          	addi	a0,a0,1960 # 800081f8 <etext+0x1f8>
    80001a58:	00004097          	auipc	ra,0x4
    80001a5c:	484080e7          	jalr	1156(ra) # 80005edc <panic>

0000000080001a60 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80001a60:	7179                	addi	sp,sp,-48
    80001a62:	f406                	sd	ra,40(sp)
    80001a64:	f022                	sd	s0,32(sp)
    80001a66:	ec26                	sd	s1,24(sp)
    80001a68:	e84a                	sd	s2,16(sp)
    80001a6a:	e44e                	sd	s3,8(sp)
    80001a6c:	1800                	addi	s0,sp,48
    80001a6e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001a70:	0022b497          	auipc	s1,0x22b
    80001a74:	a2848493          	addi	s1,s1,-1496 # 8022c498 <proc>
    80001a78:	00230997          	auipc	s3,0x230
    80001a7c:	42098993          	addi	s3,s3,1056 # 80231e98 <tickslock>
    acquire(&p->lock);
    80001a80:	8526                	mv	a0,s1
    80001a82:	00005097          	auipc	ra,0x5
    80001a86:	9d4080e7          	jalr	-1580(ra) # 80006456 <acquire>
    if(p->pid == pid){
    80001a8a:	589c                	lw	a5,48(s1)
    80001a8c:	01278d63          	beq	a5,s2,80001aa6 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001a90:	8526                	mv	a0,s1
    80001a92:	00005097          	auipc	ra,0x5
    80001a96:	a78080e7          	jalr	-1416(ra) # 8000650a <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a9a:	16848493          	addi	s1,s1,360
    80001a9e:	ff3491e3          	bne	s1,s3,80001a80 <kill+0x20>
  }
  return -1;
    80001aa2:	557d                	li	a0,-1
    80001aa4:	a829                	j	80001abe <kill+0x5e>
      p->killed = 1;
    80001aa6:	4785                	li	a5,1
    80001aa8:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001aaa:	4c98                	lw	a4,24(s1)
    80001aac:	4789                	li	a5,2
    80001aae:	00f70f63          	beq	a4,a5,80001acc <kill+0x6c>
      release(&p->lock);
    80001ab2:	8526                	mv	a0,s1
    80001ab4:	00005097          	auipc	ra,0x5
    80001ab8:	a56080e7          	jalr	-1450(ra) # 8000650a <release>
      return 0;
    80001abc:	4501                	li	a0,0
}
    80001abe:	70a2                	ld	ra,40(sp)
    80001ac0:	7402                	ld	s0,32(sp)
    80001ac2:	64e2                	ld	s1,24(sp)
    80001ac4:	6942                	ld	s2,16(sp)
    80001ac6:	69a2                	ld	s3,8(sp)
    80001ac8:	6145                	addi	sp,sp,48
    80001aca:	8082                	ret
        p->state = RUNNABLE;
    80001acc:	478d                	li	a5,3
    80001ace:	cc9c                	sw	a5,24(s1)
    80001ad0:	b7cd                	j	80001ab2 <kill+0x52>

0000000080001ad2 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ad2:	7179                	addi	sp,sp,-48
    80001ad4:	f406                	sd	ra,40(sp)
    80001ad6:	f022                	sd	s0,32(sp)
    80001ad8:	ec26                	sd	s1,24(sp)
    80001ada:	e84a                	sd	s2,16(sp)
    80001adc:	e44e                	sd	s3,8(sp)
    80001ade:	e052                	sd	s4,0(sp)
    80001ae0:	1800                	addi	s0,sp,48
    80001ae2:	84aa                	mv	s1,a0
    80001ae4:	892e                	mv	s2,a1
    80001ae6:	89b2                	mv	s3,a2
    80001ae8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001aea:	fffff097          	auipc	ra,0xfffff
    80001aee:	57e080e7          	jalr	1406(ra) # 80001068 <myproc>
  if(user_dst){
    80001af2:	c08d                	beqz	s1,80001b14 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80001af4:	86d2                	mv	a3,s4
    80001af6:	864e                	mv	a2,s3
    80001af8:	85ca                	mv	a1,s2
    80001afa:	6928                	ld	a0,80(a0)
    80001afc:	fffff097          	auipc	ra,0xfffff
    80001b00:	0f6080e7          	jalr	246(ra) # 80000bf2 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b04:	70a2                	ld	ra,40(sp)
    80001b06:	7402                	ld	s0,32(sp)
    80001b08:	64e2                	ld	s1,24(sp)
    80001b0a:	6942                	ld	s2,16(sp)
    80001b0c:	69a2                	ld	s3,8(sp)
    80001b0e:	6a02                	ld	s4,0(sp)
    80001b10:	6145                	addi	sp,sp,48
    80001b12:	8082                	ret
    memmove((char *)dst, src, len);
    80001b14:	000a061b          	sext.w	a2,s4
    80001b18:	85ce                	mv	a1,s3
    80001b1a:	854a                	mv	a0,s2
    80001b1c:	ffffe097          	auipc	ra,0xffffe
    80001b20:	770080e7          	jalr	1904(ra) # 8000028c <memmove>
    return 0;
    80001b24:	8526                	mv	a0,s1
    80001b26:	bff9                	j	80001b04 <either_copyout+0x32>

0000000080001b28 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b28:	7179                	addi	sp,sp,-48
    80001b2a:	f406                	sd	ra,40(sp)
    80001b2c:	f022                	sd	s0,32(sp)
    80001b2e:	ec26                	sd	s1,24(sp)
    80001b30:	e84a                	sd	s2,16(sp)
    80001b32:	e44e                	sd	s3,8(sp)
    80001b34:	e052                	sd	s4,0(sp)
    80001b36:	1800                	addi	s0,sp,48
    80001b38:	892a                	mv	s2,a0
    80001b3a:	84ae                	mv	s1,a1
    80001b3c:	89b2                	mv	s3,a2
    80001b3e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	528080e7          	jalr	1320(ra) # 80001068 <myproc>
  if(user_src){
    80001b48:	c08d                	beqz	s1,80001b6a <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80001b4a:	86d2                	mv	a3,s4
    80001b4c:	864e                	mv	a2,s3
    80001b4e:	85ca                	mv	a1,s2
    80001b50:	6928                	ld	a0,80(a0)
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	23e080e7          	jalr	574(ra) # 80000d90 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b5a:	70a2                	ld	ra,40(sp)
    80001b5c:	7402                	ld	s0,32(sp)
    80001b5e:	64e2                	ld	s1,24(sp)
    80001b60:	6942                	ld	s2,16(sp)
    80001b62:	69a2                	ld	s3,8(sp)
    80001b64:	6a02                	ld	s4,0(sp)
    80001b66:	6145                	addi	sp,sp,48
    80001b68:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b6a:	000a061b          	sext.w	a2,s4
    80001b6e:	85ce                	mv	a1,s3
    80001b70:	854a                	mv	a0,s2
    80001b72:	ffffe097          	auipc	ra,0xffffe
    80001b76:	71a080e7          	jalr	1818(ra) # 8000028c <memmove>
    return 0;
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	bff9                	j	80001b5a <either_copyin+0x32>

0000000080001b7e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b7e:	715d                	addi	sp,sp,-80
    80001b80:	e486                	sd	ra,72(sp)
    80001b82:	e0a2                	sd	s0,64(sp)
    80001b84:	fc26                	sd	s1,56(sp)
    80001b86:	f84a                	sd	s2,48(sp)
    80001b88:	f44e                	sd	s3,40(sp)
    80001b8a:	f052                	sd	s4,32(sp)
    80001b8c:	ec56                	sd	s5,24(sp)
    80001b8e:	e85a                	sd	s6,16(sp)
    80001b90:	e45e                	sd	s7,8(sp)
    80001b92:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b94:	00006517          	auipc	a0,0x6
    80001b98:	48c50513          	addi	a0,a0,1164 # 80008020 <etext+0x20>
    80001b9c:	00004097          	auipc	ra,0x4
    80001ba0:	38a080e7          	jalr	906(ra) # 80005f26 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba4:	0022b497          	auipc	s1,0x22b
    80001ba8:	a4c48493          	addi	s1,s1,-1460 # 8022c5f0 <proc+0x158>
    80001bac:	00230917          	auipc	s2,0x230
    80001bb0:	44490913          	addi	s2,s2,1092 # 80231ff0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bb6:	00006997          	auipc	s3,0x6
    80001bba:	65298993          	addi	s3,s3,1618 # 80008208 <etext+0x208>
    printf("%d %s %s", p->pid, state, p->name);
    80001bbe:	00006a97          	auipc	s5,0x6
    80001bc2:	652a8a93          	addi	s5,s5,1618 # 80008210 <etext+0x210>
    printf("\n");
    80001bc6:	00006a17          	auipc	s4,0x6
    80001bca:	45aa0a13          	addi	s4,s4,1114 # 80008020 <etext+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bce:	00007b97          	auipc	s7,0x7
    80001bd2:	b3ab8b93          	addi	s7,s7,-1222 # 80008708 <states.0>
    80001bd6:	a00d                	j	80001bf8 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80001bd8:	ed86a583          	lw	a1,-296(a3)
    80001bdc:	8556                	mv	a0,s5
    80001bde:	00004097          	auipc	ra,0x4
    80001be2:	348080e7          	jalr	840(ra) # 80005f26 <printf>
    printf("\n");
    80001be6:	8552                	mv	a0,s4
    80001be8:	00004097          	auipc	ra,0x4
    80001bec:	33e080e7          	jalr	830(ra) # 80005f26 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bf0:	16848493          	addi	s1,s1,360
    80001bf4:	03248263          	beq	s1,s2,80001c18 <procdump+0x9a>
    if(p->state == UNUSED)
    80001bf8:	86a6                	mv	a3,s1
    80001bfa:	ec04a783          	lw	a5,-320(s1)
    80001bfe:	dbed                	beqz	a5,80001bf0 <procdump+0x72>
      state = "???";
    80001c00:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001c02:	fcfb6be3          	bltu	s6,a5,80001bd8 <procdump+0x5a>
    80001c06:	02079713          	slli	a4,a5,0x20
    80001c0a:	01d75793          	srli	a5,a4,0x1d
    80001c0e:	97de                	add	a5,a5,s7
    80001c10:	6390                	ld	a2,0(a5)
    80001c12:	f279                	bnez	a2,80001bd8 <procdump+0x5a>
      state = "???";
    80001c14:	864e                	mv	a2,s3
    80001c16:	b7c9                	j	80001bd8 <procdump+0x5a>
  }
}
    80001c18:	60a6                	ld	ra,72(sp)
    80001c1a:	6406                	ld	s0,64(sp)
    80001c1c:	74e2                	ld	s1,56(sp)
    80001c1e:	7942                	ld	s2,48(sp)
    80001c20:	79a2                	ld	s3,40(sp)
    80001c22:	7a02                	ld	s4,32(sp)
    80001c24:	6ae2                	ld	s5,24(sp)
    80001c26:	6b42                	ld	s6,16(sp)
    80001c28:	6ba2                	ld	s7,8(sp)
    80001c2a:	6161                	addi	sp,sp,80
    80001c2c:	8082                	ret

0000000080001c2e <swtch>:
    80001c2e:	00153023          	sd	ra,0(a0)
    80001c32:	00253423          	sd	sp,8(a0)
    80001c36:	e900                	sd	s0,16(a0)
    80001c38:	ed04                	sd	s1,24(a0)
    80001c3a:	03253023          	sd	s2,32(a0)
    80001c3e:	03353423          	sd	s3,40(a0)
    80001c42:	03453823          	sd	s4,48(a0)
    80001c46:	03553c23          	sd	s5,56(a0)
    80001c4a:	05653023          	sd	s6,64(a0)
    80001c4e:	05753423          	sd	s7,72(a0)
    80001c52:	05853823          	sd	s8,80(a0)
    80001c56:	05953c23          	sd	s9,88(a0)
    80001c5a:	07a53023          	sd	s10,96(a0)
    80001c5e:	07b53423          	sd	s11,104(a0)
    80001c62:	0005b083          	ld	ra,0(a1)
    80001c66:	0085b103          	ld	sp,8(a1)
    80001c6a:	6980                	ld	s0,16(a1)
    80001c6c:	6d84                	ld	s1,24(a1)
    80001c6e:	0205b903          	ld	s2,32(a1)
    80001c72:	0285b983          	ld	s3,40(a1)
    80001c76:	0305ba03          	ld	s4,48(a1)
    80001c7a:	0385ba83          	ld	s5,56(a1)
    80001c7e:	0405bb03          	ld	s6,64(a1)
    80001c82:	0485bb83          	ld	s7,72(a1)
    80001c86:	0505bc03          	ld	s8,80(a1)
    80001c8a:	0585bc83          	ld	s9,88(a1)
    80001c8e:	0605bd03          	ld	s10,96(a1)
    80001c92:	0685bd83          	ld	s11,104(a1)
    80001c96:	8082                	ret

0000000080001c98 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c98:	1141                	addi	sp,sp,-16
    80001c9a:	e406                	sd	ra,8(sp)
    80001c9c:	e022                	sd	s0,0(sp)
    80001c9e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001ca0:	00006597          	auipc	a1,0x6
    80001ca4:	5a858593          	addi	a1,a1,1448 # 80008248 <etext+0x248>
    80001ca8:	00230517          	auipc	a0,0x230
    80001cac:	1f050513          	addi	a0,a0,496 # 80231e98 <tickslock>
    80001cb0:	00004097          	auipc	ra,0x4
    80001cb4:	716080e7          	jalr	1814(ra) # 800063c6 <initlock>
}
    80001cb8:	60a2                	ld	ra,8(sp)
    80001cba:	6402                	ld	s0,0(sp)
    80001cbc:	0141                	addi	sp,sp,16
    80001cbe:	8082                	ret

0000000080001cc0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cc0:	1141                	addi	sp,sp,-16
    80001cc2:	e422                	sd	s0,8(sp)
    80001cc4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc6:	00003797          	auipc	a5,0x3
    80001cca:	62a78793          	addi	a5,a5,1578 # 800052f0 <kernelvec>
    80001cce:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cd2:	6422                	ld	s0,8(sp)
    80001cd4:	0141                	addi	sp,sp,16
    80001cd6:	8082                	ret

0000000080001cd8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001cd8:	1141                	addi	sp,sp,-16
    80001cda:	e406                	sd	ra,8(sp)
    80001cdc:	e022                	sd	s0,0(sp)
    80001cde:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ce0:	fffff097          	auipc	ra,0xfffff
    80001ce4:	388080e7          	jalr	904(ra) # 80001068 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cec:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cee:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to trampoline.S
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    80001cf2:	00005697          	auipc	a3,0x5
    80001cf6:	30e68693          	addi	a3,a3,782 # 80007000 <_trampoline>
    80001cfa:	00005717          	auipc	a4,0x5
    80001cfe:	30670713          	addi	a4,a4,774 # 80007000 <_trampoline>
    80001d02:	8f15                	sub	a4,a4,a3
    80001d04:	040007b7          	lui	a5,0x4000
    80001d08:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001d0a:	07b2                	slli	a5,a5,0xc
    80001d0c:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d0e:	10571073          	csrw	stvec,a4

  // set up trapframe values that uservec will need when
  // the process next re-enters the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d12:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d14:	18002673          	csrr	a2,satp
    80001d18:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d1a:	6d30                	ld	a2,88(a0)
    80001d1c:	6138                	ld	a4,64(a0)
    80001d1e:	6585                	lui	a1,0x1
    80001d20:	972e                	add	a4,a4,a1
    80001d22:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d24:	6d38                	ld	a4,88(a0)
    80001d26:	00000617          	auipc	a2,0x0
    80001d2a:	14060613          	addi	a2,a2,320 # 80001e66 <usertrap>
    80001d2e:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d30:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d32:	8612                	mv	a2,tp
    80001d34:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d36:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d3a:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d3e:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d42:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d46:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d48:	6f18                	ld	a4,24(a4)
    80001d4a:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d4e:	692c                	ld	a1,80(a0)
    80001d50:	81b1                	srli	a1,a1,0xc

  // jump to trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    80001d52:	00005717          	auipc	a4,0x5
    80001d56:	33e70713          	addi	a4,a4,830 # 80007090 <userret>
    80001d5a:	8f15                	sub	a4,a4,a3
    80001d5c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64,uint64))fn)(TRAPFRAME, satp);
    80001d5e:	577d                	li	a4,-1
    80001d60:	177e                	slli	a4,a4,0x3f
    80001d62:	8dd9                	or	a1,a1,a4
    80001d64:	02000537          	lui	a0,0x2000
    80001d68:	157d                	addi	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    80001d6a:	0536                	slli	a0,a0,0xd
    80001d6c:	9782                	jalr	a5
}
    80001d6e:	60a2                	ld	ra,8(sp)
    80001d70:	6402                	ld	s0,0(sp)
    80001d72:	0141                	addi	sp,sp,16
    80001d74:	8082                	ret

0000000080001d76 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d76:	1101                	addi	sp,sp,-32
    80001d78:	ec06                	sd	ra,24(sp)
    80001d7a:	e822                	sd	s0,16(sp)
    80001d7c:	e426                	sd	s1,8(sp)
    80001d7e:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80001d80:	00230497          	auipc	s1,0x230
    80001d84:	11848493          	addi	s1,s1,280 # 80231e98 <tickslock>
    80001d88:	8526                	mv	a0,s1
    80001d8a:	00004097          	auipc	ra,0x4
    80001d8e:	6cc080e7          	jalr	1740(ra) # 80006456 <acquire>
  ticks++;
    80001d92:	0000a517          	auipc	a0,0xa
    80001d96:	28650513          	addi	a0,a0,646 # 8000c018 <ticks>
    80001d9a:	411c                	lw	a5,0(a0)
    80001d9c:	2785                	addiw	a5,a5,1
    80001d9e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80001da0:	00000097          	auipc	ra,0x0
    80001da4:	b1a080e7          	jalr	-1254(ra) # 800018ba <wakeup>
  release(&tickslock);
    80001da8:	8526                	mv	a0,s1
    80001daa:	00004097          	auipc	ra,0x4
    80001dae:	760080e7          	jalr	1888(ra) # 8000650a <release>
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret

0000000080001dbc <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001dbc:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80001dc0:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80001dc2:	0a07d163          	bgez	a5,80001e64 <devintr+0xa8>
{
    80001dc6:	1101                	addi	sp,sp,-32
    80001dc8:	ec06                	sd	ra,24(sp)
    80001dca:	e822                	sd	s0,16(sp)
    80001dcc:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80001dce:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80001dd2:	46a5                	li	a3,9
    80001dd4:	00d70c63          	beq	a4,a3,80001dec <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80001dd8:	577d                	li	a4,-1
    80001dda:	177e                	slli	a4,a4,0x3f
    80001ddc:	0705                	addi	a4,a4,1
    return 0;
    80001dde:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80001de0:	06e78163          	beq	a5,a4,80001e42 <devintr+0x86>
  }
}
    80001de4:	60e2                	ld	ra,24(sp)
    80001de6:	6442                	ld	s0,16(sp)
    80001de8:	6105                	addi	sp,sp,32
    80001dea:	8082                	ret
    80001dec:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001dee:	00003097          	auipc	ra,0x3
    80001df2:	60e080e7          	jalr	1550(ra) # 800053fc <plic_claim>
    80001df6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001df8:	47a9                	li	a5,10
    80001dfa:	00f50963          	beq	a0,a5,80001e0c <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001dfe:	4785                	li	a5,1
    80001e00:	00f50b63          	beq	a0,a5,80001e16 <devintr+0x5a>
    return 1;
    80001e04:	4505                	li	a0,1
    } else if(irq){
    80001e06:	ec89                	bnez	s1,80001e20 <devintr+0x64>
    80001e08:	64a2                	ld	s1,8(sp)
    80001e0a:	bfe9                	j	80001de4 <devintr+0x28>
      uartintr();
    80001e0c:	00004097          	auipc	ra,0x4
    80001e10:	56a080e7          	jalr	1386(ra) # 80006376 <uartintr>
    if(irq)
    80001e14:	a839                	j	80001e32 <devintr+0x76>
      virtio_disk_intr();
    80001e16:	00004097          	auipc	ra,0x4
    80001e1a:	aba080e7          	jalr	-1350(ra) # 800058d0 <virtio_disk_intr>
    if(irq)
    80001e1e:	a811                	j	80001e32 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80001e20:	85a6                	mv	a1,s1
    80001e22:	00006517          	auipc	a0,0x6
    80001e26:	42e50513          	addi	a0,a0,1070 # 80008250 <etext+0x250>
    80001e2a:	00004097          	auipc	ra,0x4
    80001e2e:	0fc080e7          	jalr	252(ra) # 80005f26 <printf>
      plic_complete(irq);
    80001e32:	8526                	mv	a0,s1
    80001e34:	00003097          	auipc	ra,0x3
    80001e38:	5ec080e7          	jalr	1516(ra) # 80005420 <plic_complete>
    return 1;
    80001e3c:	4505                	li	a0,1
    80001e3e:	64a2                	ld	s1,8(sp)
    80001e40:	b755                	j	80001de4 <devintr+0x28>
    if(cpuid() == 0){
    80001e42:	fffff097          	auipc	ra,0xfffff
    80001e46:	1fa080e7          	jalr	506(ra) # 8000103c <cpuid>
    80001e4a:	c901                	beqz	a0,80001e5a <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001e4c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80001e50:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001e52:	14479073          	csrw	sip,a5
    return 2;
    80001e56:	4509                	li	a0,2
    80001e58:	b771                	j	80001de4 <devintr+0x28>
      clockintr();
    80001e5a:	00000097          	auipc	ra,0x0
    80001e5e:	f1c080e7          	jalr	-228(ra) # 80001d76 <clockintr>
    80001e62:	b7ed                	j	80001e4c <devintr+0x90>
}
    80001e64:	8082                	ret

0000000080001e66 <usertrap>:
{
    80001e66:	7179                	addi	sp,sp,-48
    80001e68:	f406                	sd	ra,40(sp)
    80001e6a:	f022                	sd	s0,32(sp)
    80001e6c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e72:	1007f793          	andi	a5,a5,256
    80001e76:	efc5                	bnez	a5,80001f2e <usertrap+0xc8>
    80001e78:	ec26                	sd	s1,24(sp)
    80001e7a:	e84a                	sd	s2,16(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e7c:	00003797          	auipc	a5,0x3
    80001e80:	47478793          	addi	a5,a5,1140 # 800052f0 <kernelvec>
    80001e84:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e88:	fffff097          	auipc	ra,0xfffff
    80001e8c:	1e0080e7          	jalr	480(ra) # 80001068 <myproc>
    80001e90:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e92:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e94:	14102773          	csrr	a4,sepc
    80001e98:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e9a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e9e:	47a1                	li	a5,8
    80001ea0:	0af70363          	beq	a4,a5,80001f46 <usertrap+0xe0>
    80001ea4:	14202773          	csrr	a4,scause
  } else if(r_scause() == 15)
    80001ea8:	47bd                	li	a5,15
    80001eaa:	10f71e63          	bne	a4,a5,80001fc6 <usertrap+0x160>
    80001eae:	e44e                	sd	s3,8(sp)
    80001eb0:	e052                	sd	s4,0(sp)
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001eb2:	14302973          	csrr	s2,stval
    if(va >= MAXVA)
    80001eb6:	57fd                	li	a5,-1
    80001eb8:	83e9                	srli	a5,a5,0x1a
    80001eba:	0d27e863          	bltu	a5,s2,80001f8a <usertrap+0x124>
    if((pte = walk(p->pagetable, va, 0)) == 0)
    80001ebe:	4601                	li	a2,0
    80001ec0:	85ca                	mv	a1,s2
    80001ec2:	68a8                	ld	a0,80(s1)
    80001ec4:	ffffe097          	auipc	ra,0xffffe
    80001ec8:	644080e7          	jalr	1604(ra) # 80000508 <walk>
    80001ecc:	89aa                	mv	s3,a0
    80001ece:	c561                	beqz	a0,80001f96 <usertrap+0x130>
    if((*pte & PTE_V) == 0)
    80001ed0:	0009b783          	ld	a5,0(s3)
    80001ed4:	8b85                	andi	a5,a5,1
    80001ed6:	c7f1                	beqz	a5,80001fa2 <usertrap+0x13c>
    if((*pte & PTE_U) == 0)
    80001ed8:	0009b783          	ld	a5,0(s3)
    80001edc:	8bc1                	andi	a5,a5,16
    80001ede:	cbe1                	beqz	a5,80001fae <usertrap+0x148>
    pa0 = PTE2PA(*pte);
    80001ee0:	0009ba03          	ld	s4,0(s3)
    80001ee4:	00aa5a13          	srli	s4,s4,0xa
    80001ee8:	0a32                	slli	s4,s4,0xc
    if((new_pa = kalloc()) == 0)
    80001eea:	ffffe097          	auipc	ra,0xffffe
    80001eee:	2b8080e7          	jalr	696(ra) # 800001a2 <kalloc>
    80001ef2:	892a                	mv	s2,a0
    80001ef4:	c179                	beqz	a0,80001fba <usertrap+0x154>
    memmove(new_pa, (char*)pa0, PGSIZE);
    80001ef6:	6605                	lui	a2,0x1
    80001ef8:	85d2                	mv	a1,s4
    80001efa:	854a                	mv	a0,s2
    80001efc:	ffffe097          	auipc	ra,0xffffe
    80001f00:	390080e7          	jalr	912(ra) # 8000028c <memmove>
    *pte = PA2PTE((uint64)new_pa);
    80001f04:	00c95913          	srli	s2,s2,0xc
    80001f08:	092a                	slli	s2,s2,0xa
    flags = PTE_FLAGS(*pte);
    80001f0a:	0009b783          	ld	a5,0(s3)
    80001f0e:	3ff7f793          	andi	a5,a5,1023
    *pte |= flags;
    80001f12:	00f96933          	or	s2,s2,a5
    *pte |= PTE_W;
    80001f16:	00496913          	ori	s2,s2,4
    80001f1a:	0129b023          	sd	s2,0(s3)
    kfree((void*)pa0);
    80001f1e:	8552                	mv	a0,s4
    80001f20:	ffffe097          	auipc	ra,0xffffe
    80001f24:	0fc080e7          	jalr	252(ra) # 8000001c <kfree>
    80001f28:	69a2                	ld	s3,8(sp)
    80001f2a:	6a02                	ld	s4,0(sp)
    80001f2c:	a82d                	j	80001f66 <usertrap+0x100>
    80001f2e:	ec26                	sd	s1,24(sp)
    80001f30:	e84a                	sd	s2,16(sp)
    80001f32:	e44e                	sd	s3,8(sp)
    80001f34:	e052                	sd	s4,0(sp)
    panic("usertrap: not from user mode");
    80001f36:	00006517          	auipc	a0,0x6
    80001f3a:	33a50513          	addi	a0,a0,826 # 80008270 <etext+0x270>
    80001f3e:	00004097          	auipc	ra,0x4
    80001f42:	f9e080e7          	jalr	-98(ra) # 80005edc <panic>
    if(p->killed)
    80001f46:	551c                	lw	a5,40(a0)
    80001f48:	eb9d                	bnez	a5,80001f7e <usertrap+0x118>
    p->trapframe->epc += 4;
    80001f4a:	6cb8                	ld	a4,88(s1)
    80001f4c:	6f1c                	ld	a5,24(a4)
    80001f4e:	0791                	addi	a5,a5,4
    80001f50:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f52:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f56:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f5a:	10079073          	csrw	sstatus,a5
    syscall();
    80001f5e:	00000097          	auipc	ra,0x0
    80001f62:	30c080e7          	jalr	780(ra) # 8000226a <syscall>
  if(p->killed)
    80001f66:	549c                	lw	a5,40(s1)
    80001f68:	e3d5                	bnez	a5,8000200c <usertrap+0x1a6>
  usertrapret();
    80001f6a:	00000097          	auipc	ra,0x0
    80001f6e:	d6e080e7          	jalr	-658(ra) # 80001cd8 <usertrapret>
    80001f72:	64e2                	ld	s1,24(sp)
    80001f74:	6942                	ld	s2,16(sp)
}
    80001f76:	70a2                	ld	ra,40(sp)
    80001f78:	7402                	ld	s0,32(sp)
    80001f7a:	6145                	addi	sp,sp,48
    80001f7c:	8082                	ret
      exit(-1);
    80001f7e:	557d                	li	a0,-1
    80001f80:	00000097          	auipc	ra,0x0
    80001f84:	a0a080e7          	jalr	-1526(ra) # 8000198a <exit>
    80001f88:	b7c9                	j	80001f4a <usertrap+0xe4>
      exit(-1);
    80001f8a:	557d                	li	a0,-1
    80001f8c:	00000097          	auipc	ra,0x0
    80001f90:	9fe080e7          	jalr	-1538(ra) # 8000198a <exit>
    80001f94:	b72d                	j	80001ebe <usertrap+0x58>
      exit(-1);
    80001f96:	557d                	li	a0,-1
    80001f98:	00000097          	auipc	ra,0x0
    80001f9c:	9f2080e7          	jalr	-1550(ra) # 8000198a <exit>
    80001fa0:	bf05                	j	80001ed0 <usertrap+0x6a>
      exit(-1);
    80001fa2:	557d                	li	a0,-1
    80001fa4:	00000097          	auipc	ra,0x0
    80001fa8:	9e6080e7          	jalr	-1562(ra) # 8000198a <exit>
    80001fac:	b735                	j	80001ed8 <usertrap+0x72>
      exit(-1);
    80001fae:	557d                	li	a0,-1
    80001fb0:	00000097          	auipc	ra,0x0
    80001fb4:	9da080e7          	jalr	-1574(ra) # 8000198a <exit>
    80001fb8:	b725                	j	80001ee0 <usertrap+0x7a>
      exit(-1);
    80001fba:	557d                	li	a0,-1
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	9ce080e7          	jalr	-1586(ra) # 8000198a <exit>
    80001fc4:	bf0d                	j	80001ef6 <usertrap+0x90>
  else if((which_dev = devintr()) != 0){
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	df6080e7          	jalr	-522(ra) # 80001dbc <devintr>
    80001fce:	892a                	mv	s2,a0
    80001fd0:	c501                	beqz	a0,80001fd8 <usertrap+0x172>
  if(p->killed)
    80001fd2:	549c                	lw	a5,40(s1)
    80001fd4:	c3b1                	beqz	a5,80002018 <usertrap+0x1b2>
    80001fd6:	a825                	j	8000200e <usertrap+0x1a8>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fd8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001fdc:	5890                	lw	a2,48(s1)
    80001fde:	00006517          	auipc	a0,0x6
    80001fe2:	2b250513          	addi	a0,a0,690 # 80008290 <etext+0x290>
    80001fe6:	00004097          	auipc	ra,0x4
    80001fea:	f40080e7          	jalr	-192(ra) # 80005f26 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fee:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ff2:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001ff6:	00006517          	auipc	a0,0x6
    80001ffa:	2ca50513          	addi	a0,a0,714 # 800082c0 <etext+0x2c0>
    80001ffe:	00004097          	auipc	ra,0x4
    80002002:	f28080e7          	jalr	-216(ra) # 80005f26 <printf>
    p->killed = 1;
    80002006:	4785                	li	a5,1
    80002008:	d49c                	sw	a5,40(s1)
  if(p->killed)
    8000200a:	a011                	j	8000200e <usertrap+0x1a8>
    8000200c:	4901                	li	s2,0
    exit(-1);
    8000200e:	557d                	li	a0,-1
    80002010:	00000097          	auipc	ra,0x0
    80002014:	97a080e7          	jalr	-1670(ra) # 8000198a <exit>
  if(which_dev == 2)
    80002018:	4789                	li	a5,2
    8000201a:	f4f918e3          	bne	s2,a5,80001f6a <usertrap+0x104>
    yield();
    8000201e:	fffff097          	auipc	ra,0xfffff
    80002022:	6d4080e7          	jalr	1748(ra) # 800016f2 <yield>
    80002026:	b791                	j	80001f6a <usertrap+0x104>

0000000080002028 <kerneltrap>:
{
    80002028:	7179                	addi	sp,sp,-48
    8000202a:	f406                	sd	ra,40(sp)
    8000202c:	f022                	sd	s0,32(sp)
    8000202e:	ec26                	sd	s1,24(sp)
    80002030:	e84a                	sd	s2,16(sp)
    80002032:	e44e                	sd	s3,8(sp)
    80002034:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002036:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000203a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000203e:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80002042:	1004f793          	andi	a5,s1,256
    80002046:	cb85                	beqz	a5,80002076 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002048:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000204c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000204e:	ef85                	bnez	a5,80002086 <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80002050:	00000097          	auipc	ra,0x0
    80002054:	d6c080e7          	jalr	-660(ra) # 80001dbc <devintr>
    80002058:	cd1d                	beqz	a0,80002096 <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000205a:	4789                	li	a5,2
    8000205c:	06f50a63          	beq	a0,a5,800020d0 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002060:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002064:	10049073          	csrw	sstatus,s1
}
    80002068:	70a2                	ld	ra,40(sp)
    8000206a:	7402                	ld	s0,32(sp)
    8000206c:	64e2                	ld	s1,24(sp)
    8000206e:	6942                	ld	s2,16(sp)
    80002070:	69a2                	ld	s3,8(sp)
    80002072:	6145                	addi	sp,sp,48
    80002074:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002076:	00006517          	auipc	a0,0x6
    8000207a:	26a50513          	addi	a0,a0,618 # 800082e0 <etext+0x2e0>
    8000207e:	00004097          	auipc	ra,0x4
    80002082:	e5e080e7          	jalr	-418(ra) # 80005edc <panic>
    panic("kerneltrap: interrupts enabled");
    80002086:	00006517          	auipc	a0,0x6
    8000208a:	28250513          	addi	a0,a0,642 # 80008308 <etext+0x308>
    8000208e:	00004097          	auipc	ra,0x4
    80002092:	e4e080e7          	jalr	-434(ra) # 80005edc <panic>
    printf("scause %p\n", scause);
    80002096:	85ce                	mv	a1,s3
    80002098:	00006517          	auipc	a0,0x6
    8000209c:	29050513          	addi	a0,a0,656 # 80008328 <etext+0x328>
    800020a0:	00004097          	auipc	ra,0x4
    800020a4:	e86080e7          	jalr	-378(ra) # 80005f26 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800020a8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020ac:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800020b0:	00006517          	auipc	a0,0x6
    800020b4:	28850513          	addi	a0,a0,648 # 80008338 <etext+0x338>
    800020b8:	00004097          	auipc	ra,0x4
    800020bc:	e6e080e7          	jalr	-402(ra) # 80005f26 <printf>
    panic("kerneltrap");
    800020c0:	00006517          	auipc	a0,0x6
    800020c4:	29050513          	addi	a0,a0,656 # 80008350 <etext+0x350>
    800020c8:	00004097          	auipc	ra,0x4
    800020cc:	e14080e7          	jalr	-492(ra) # 80005edc <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	f98080e7          	jalr	-104(ra) # 80001068 <myproc>
    800020d8:	d541                	beqz	a0,80002060 <kerneltrap+0x38>
    800020da:	fffff097          	auipc	ra,0xfffff
    800020de:	f8e080e7          	jalr	-114(ra) # 80001068 <myproc>
    800020e2:	4d18                	lw	a4,24(a0)
    800020e4:	4791                	li	a5,4
    800020e6:	f6f71de3          	bne	a4,a5,80002060 <kerneltrap+0x38>
    yield();
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	608080e7          	jalr	1544(ra) # 800016f2 <yield>
    800020f2:	b7bd                	j	80002060 <kerneltrap+0x38>

00000000800020f4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800020f4:	1101                	addi	sp,sp,-32
    800020f6:	ec06                	sd	ra,24(sp)
    800020f8:	e822                	sd	s0,16(sp)
    800020fa:	e426                	sd	s1,8(sp)
    800020fc:	1000                	addi	s0,sp,32
    800020fe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002100:	fffff097          	auipc	ra,0xfffff
    80002104:	f68080e7          	jalr	-152(ra) # 80001068 <myproc>
  switch (n) {
    80002108:	4795                	li	a5,5
    8000210a:	0497e163          	bltu	a5,s1,8000214c <argraw+0x58>
    8000210e:	048a                	slli	s1,s1,0x2
    80002110:	00006717          	auipc	a4,0x6
    80002114:	62870713          	addi	a4,a4,1576 # 80008738 <states.0+0x30>
    80002118:	94ba                	add	s1,s1,a4
    8000211a:	409c                	lw	a5,0(s1)
    8000211c:	97ba                	add	a5,a5,a4
    8000211e:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002120:	6d3c                	ld	a5,88(a0)
    80002122:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002124:	60e2                	ld	ra,24(sp)
    80002126:	6442                	ld	s0,16(sp)
    80002128:	64a2                	ld	s1,8(sp)
    8000212a:	6105                	addi	sp,sp,32
    8000212c:	8082                	ret
    return p->trapframe->a1;
    8000212e:	6d3c                	ld	a5,88(a0)
    80002130:	7fa8                	ld	a0,120(a5)
    80002132:	bfcd                	j	80002124 <argraw+0x30>
    return p->trapframe->a2;
    80002134:	6d3c                	ld	a5,88(a0)
    80002136:	63c8                	ld	a0,128(a5)
    80002138:	b7f5                	j	80002124 <argraw+0x30>
    return p->trapframe->a3;
    8000213a:	6d3c                	ld	a5,88(a0)
    8000213c:	67c8                	ld	a0,136(a5)
    8000213e:	b7dd                	j	80002124 <argraw+0x30>
    return p->trapframe->a4;
    80002140:	6d3c                	ld	a5,88(a0)
    80002142:	6bc8                	ld	a0,144(a5)
    80002144:	b7c5                	j	80002124 <argraw+0x30>
    return p->trapframe->a5;
    80002146:	6d3c                	ld	a5,88(a0)
    80002148:	6fc8                	ld	a0,152(a5)
    8000214a:	bfe9                	j	80002124 <argraw+0x30>
  panic("argraw");
    8000214c:	00006517          	auipc	a0,0x6
    80002150:	21450513          	addi	a0,a0,532 # 80008360 <etext+0x360>
    80002154:	00004097          	auipc	ra,0x4
    80002158:	d88080e7          	jalr	-632(ra) # 80005edc <panic>

000000008000215c <fetchaddr>:
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	e426                	sd	s1,8(sp)
    80002164:	e04a                	sd	s2,0(sp)
    80002166:	1000                	addi	s0,sp,32
    80002168:	84aa                	mv	s1,a0
    8000216a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	efc080e7          	jalr	-260(ra) # 80001068 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002174:	653c                	ld	a5,72(a0)
    80002176:	02f4f863          	bgeu	s1,a5,800021a6 <fetchaddr+0x4a>
    8000217a:	00848713          	addi	a4,s1,8
    8000217e:	02e7e663          	bltu	a5,a4,800021aa <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002182:	46a1                	li	a3,8
    80002184:	8626                	mv	a2,s1
    80002186:	85ca                	mv	a1,s2
    80002188:	6928                	ld	a0,80(a0)
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	c06080e7          	jalr	-1018(ra) # 80000d90 <copyin>
    80002192:	00a03533          	snez	a0,a0
    80002196:	40a00533          	neg	a0,a0
}
    8000219a:	60e2                	ld	ra,24(sp)
    8000219c:	6442                	ld	s0,16(sp)
    8000219e:	64a2                	ld	s1,8(sp)
    800021a0:	6902                	ld	s2,0(sp)
    800021a2:	6105                	addi	sp,sp,32
    800021a4:	8082                	ret
    return -1;
    800021a6:	557d                	li	a0,-1
    800021a8:	bfcd                	j	8000219a <fetchaddr+0x3e>
    800021aa:	557d                	li	a0,-1
    800021ac:	b7fd                	j	8000219a <fetchaddr+0x3e>

00000000800021ae <fetchstr>:
{
    800021ae:	7179                	addi	sp,sp,-48
    800021b0:	f406                	sd	ra,40(sp)
    800021b2:	f022                	sd	s0,32(sp)
    800021b4:	ec26                	sd	s1,24(sp)
    800021b6:	e84a                	sd	s2,16(sp)
    800021b8:	e44e                	sd	s3,8(sp)
    800021ba:	1800                	addi	s0,sp,48
    800021bc:	892a                	mv	s2,a0
    800021be:	84ae                	mv	s1,a1
    800021c0:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800021c2:	fffff097          	auipc	ra,0xfffff
    800021c6:	ea6080e7          	jalr	-346(ra) # 80001068 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    800021ca:	86ce                	mv	a3,s3
    800021cc:	864a                	mv	a2,s2
    800021ce:	85a6                	mv	a1,s1
    800021d0:	6928                	ld	a0,80(a0)
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	c4c080e7          	jalr	-948(ra) # 80000e1e <copyinstr>
  if(err < 0)
    800021da:	00054763          	bltz	a0,800021e8 <fetchstr+0x3a>
  return strlen(buf);
    800021de:	8526                	mv	a0,s1
    800021e0:	ffffe097          	auipc	ra,0xffffe
    800021e4:	1c4080e7          	jalr	452(ra) # 800003a4 <strlen>
}
    800021e8:	70a2                	ld	ra,40(sp)
    800021ea:	7402                	ld	s0,32(sp)
    800021ec:	64e2                	ld	s1,24(sp)
    800021ee:	6942                	ld	s2,16(sp)
    800021f0:	69a2                	ld	s3,8(sp)
    800021f2:	6145                	addi	sp,sp,48
    800021f4:	8082                	ret

00000000800021f6 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	e426                	sd	s1,8(sp)
    800021fe:	1000                	addi	s0,sp,32
    80002200:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002202:	00000097          	auipc	ra,0x0
    80002206:	ef2080e7          	jalr	-270(ra) # 800020f4 <argraw>
    8000220a:	c088                	sw	a0,0(s1)
  return 0;
}
    8000220c:	4501                	li	a0,0
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret

0000000080002218 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002218:	1101                	addi	sp,sp,-32
    8000221a:	ec06                	sd	ra,24(sp)
    8000221c:	e822                	sd	s0,16(sp)
    8000221e:	e426                	sd	s1,8(sp)
    80002220:	1000                	addi	s0,sp,32
    80002222:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002224:	00000097          	auipc	ra,0x0
    80002228:	ed0080e7          	jalr	-304(ra) # 800020f4 <argraw>
    8000222c:	e088                	sd	a0,0(s1)
  return 0;
}
    8000222e:	4501                	li	a0,0
    80002230:	60e2                	ld	ra,24(sp)
    80002232:	6442                	ld	s0,16(sp)
    80002234:	64a2                	ld	s1,8(sp)
    80002236:	6105                	addi	sp,sp,32
    80002238:	8082                	ret

000000008000223a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    8000223a:	1101                	addi	sp,sp,-32
    8000223c:	ec06                	sd	ra,24(sp)
    8000223e:	e822                	sd	s0,16(sp)
    80002240:	e426                	sd	s1,8(sp)
    80002242:	e04a                	sd	s2,0(sp)
    80002244:	1000                	addi	s0,sp,32
    80002246:	84ae                	mv	s1,a1
    80002248:	8932                	mv	s2,a2
  *ip = argraw(n);
    8000224a:	00000097          	auipc	ra,0x0
    8000224e:	eaa080e7          	jalr	-342(ra) # 800020f4 <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002252:	864a                	mv	a2,s2
    80002254:	85a6                	mv	a1,s1
    80002256:	00000097          	auipc	ra,0x0
    8000225a:	f58080e7          	jalr	-168(ra) # 800021ae <fetchstr>
}
    8000225e:	60e2                	ld	ra,24(sp)
    80002260:	6442                	ld	s0,16(sp)
    80002262:	64a2                	ld	s1,8(sp)
    80002264:	6902                	ld	s2,0(sp)
    80002266:	6105                	addi	sp,sp,32
    80002268:	8082                	ret

000000008000226a <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    8000226a:	1101                	addi	sp,sp,-32
    8000226c:	ec06                	sd	ra,24(sp)
    8000226e:	e822                	sd	s0,16(sp)
    80002270:	e426                	sd	s1,8(sp)
    80002272:	e04a                	sd	s2,0(sp)
    80002274:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002276:	fffff097          	auipc	ra,0xfffff
    8000227a:	df2080e7          	jalr	-526(ra) # 80001068 <myproc>
    8000227e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002280:	05853903          	ld	s2,88(a0)
    80002284:	0a893783          	ld	a5,168(s2)
    80002288:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000228c:	37fd                	addiw	a5,a5,-1
    8000228e:	4751                	li	a4,20
    80002290:	00f76f63          	bltu	a4,a5,800022ae <syscall+0x44>
    80002294:	00369713          	slli	a4,a3,0x3
    80002298:	00006797          	auipc	a5,0x6
    8000229c:	4b878793          	addi	a5,a5,1208 # 80008750 <syscalls>
    800022a0:	97ba                	add	a5,a5,a4
    800022a2:	639c                	ld	a5,0(a5)
    800022a4:	c789                	beqz	a5,800022ae <syscall+0x44>
    p->trapframe->a0 = syscalls[num]();
    800022a6:	9782                	jalr	a5
    800022a8:	06a93823          	sd	a0,112(s2)
    800022ac:	a839                	j	800022ca <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    800022ae:	15848613          	addi	a2,s1,344
    800022b2:	588c                	lw	a1,48(s1)
    800022b4:	00006517          	auipc	a0,0x6
    800022b8:	0b450513          	addi	a0,a0,180 # 80008368 <etext+0x368>
    800022bc:	00004097          	auipc	ra,0x4
    800022c0:	c6a080e7          	jalr	-918(ra) # 80005f26 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    800022c4:	6cbc                	ld	a5,88(s1)
    800022c6:	577d                	li	a4,-1
    800022c8:	fbb8                	sd	a4,112(a5)
  }
}
    800022ca:	60e2                	ld	ra,24(sp)
    800022cc:	6442                	ld	s0,16(sp)
    800022ce:	64a2                	ld	s1,8(sp)
    800022d0:	6902                	ld	s2,0(sp)
    800022d2:	6105                	addi	sp,sp,32
    800022d4:	8082                	ret

00000000800022d6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800022d6:	1101                	addi	sp,sp,-32
    800022d8:	ec06                	sd	ra,24(sp)
    800022da:	e822                	sd	s0,16(sp)
    800022dc:	1000                	addi	s0,sp,32
  int n;
  if(argint(0, &n) < 0)
    800022de:	fec40593          	addi	a1,s0,-20
    800022e2:	4501                	li	a0,0
    800022e4:	00000097          	auipc	ra,0x0
    800022e8:	f12080e7          	jalr	-238(ra) # 800021f6 <argint>
    return -1;
    800022ec:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800022ee:	00054963          	bltz	a0,80002300 <sys_exit+0x2a>
  exit(n);
    800022f2:	fec42503          	lw	a0,-20(s0)
    800022f6:	fffff097          	auipc	ra,0xfffff
    800022fa:	694080e7          	jalr	1684(ra) # 8000198a <exit>
  return 0;  // not reached
    800022fe:	4781                	li	a5,0
}
    80002300:	853e                	mv	a0,a5
    80002302:	60e2                	ld	ra,24(sp)
    80002304:	6442                	ld	s0,16(sp)
    80002306:	6105                	addi	sp,sp,32
    80002308:	8082                	ret

000000008000230a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000230a:	1141                	addi	sp,sp,-16
    8000230c:	e406                	sd	ra,8(sp)
    8000230e:	e022                	sd	s0,0(sp)
    80002310:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	d56080e7          	jalr	-682(ra) # 80001068 <myproc>
}
    8000231a:	5908                	lw	a0,48(a0)
    8000231c:	60a2                	ld	ra,8(sp)
    8000231e:	6402                	ld	s0,0(sp)
    80002320:	0141                	addi	sp,sp,16
    80002322:	8082                	ret

0000000080002324 <sys_fork>:

uint64
sys_fork(void)
{
    80002324:	1141                	addi	sp,sp,-16
    80002326:	e406                	sd	ra,8(sp)
    80002328:	e022                	sd	s0,0(sp)
    8000232a:	0800                	addi	s0,sp,16
  return fork();
    8000232c:	fffff097          	auipc	ra,0xfffff
    80002330:	10e080e7          	jalr	270(ra) # 8000143a <fork>
}
    80002334:	60a2                	ld	ra,8(sp)
    80002336:	6402                	ld	s0,0(sp)
    80002338:	0141                	addi	sp,sp,16
    8000233a:	8082                	ret

000000008000233c <sys_wait>:

uint64
sys_wait(void)
{
    8000233c:	1101                	addi	sp,sp,-32
    8000233e:	ec06                	sd	ra,24(sp)
    80002340:	e822                	sd	s0,16(sp)
    80002342:	1000                	addi	s0,sp,32
  uint64 p;
  if(argaddr(0, &p) < 0)
    80002344:	fe840593          	addi	a1,s0,-24
    80002348:	4501                	li	a0,0
    8000234a:	00000097          	auipc	ra,0x0
    8000234e:	ece080e7          	jalr	-306(ra) # 80002218 <argaddr>
    80002352:	87aa                	mv	a5,a0
    return -1;
    80002354:	557d                	li	a0,-1
  if(argaddr(0, &p) < 0)
    80002356:	0007c863          	bltz	a5,80002366 <sys_wait+0x2a>
  return wait(p);
    8000235a:	fe843503          	ld	a0,-24(s0)
    8000235e:	fffff097          	auipc	ra,0xfffff
    80002362:	434080e7          	jalr	1076(ra) # 80001792 <wait>
}
    80002366:	60e2                	ld	ra,24(sp)
    80002368:	6442                	ld	s0,16(sp)
    8000236a:	6105                	addi	sp,sp,32
    8000236c:	8082                	ret

000000008000236e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000236e:	7179                	addi	sp,sp,-48
    80002370:	f406                	sd	ra,40(sp)
    80002372:	f022                	sd	s0,32(sp)
    80002374:	1800                	addi	s0,sp,48
  int addr;
  int n;

  if(argint(0, &n) < 0)
    80002376:	fdc40593          	addi	a1,s0,-36
    8000237a:	4501                	li	a0,0
    8000237c:	00000097          	auipc	ra,0x0
    80002380:	e7a080e7          	jalr	-390(ra) # 800021f6 <argint>
    80002384:	87aa                	mv	a5,a0
    return -1;
    80002386:	557d                	li	a0,-1
  if(argint(0, &n) < 0)
    80002388:	0207c263          	bltz	a5,800023ac <sys_sbrk+0x3e>
    8000238c:	ec26                	sd	s1,24(sp)
  addr = myproc()->sz;
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	cda080e7          	jalr	-806(ra) # 80001068 <myproc>
    80002396:	4524                	lw	s1,72(a0)
  if(growproc(n) < 0)
    80002398:	fdc42503          	lw	a0,-36(s0)
    8000239c:	fffff097          	auipc	ra,0xfffff
    800023a0:	026080e7          	jalr	38(ra) # 800013c2 <growproc>
    800023a4:	00054863          	bltz	a0,800023b4 <sys_sbrk+0x46>
    return -1;
  return addr;
    800023a8:	8526                	mv	a0,s1
    800023aa:	64e2                	ld	s1,24(sp)
}
    800023ac:	70a2                	ld	ra,40(sp)
    800023ae:	7402                	ld	s0,32(sp)
    800023b0:	6145                	addi	sp,sp,48
    800023b2:	8082                	ret
    return -1;
    800023b4:	557d                	li	a0,-1
    800023b6:	64e2                	ld	s1,24(sp)
    800023b8:	bfd5                	j	800023ac <sys_sbrk+0x3e>

00000000800023ba <sys_sleep>:

uint64
sys_sleep(void)
{
    800023ba:	7139                	addi	sp,sp,-64
    800023bc:	fc06                	sd	ra,56(sp)
    800023be:	f822                	sd	s0,48(sp)
    800023c0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    800023c2:	fcc40593          	addi	a1,s0,-52
    800023c6:	4501                	li	a0,0
    800023c8:	00000097          	auipc	ra,0x0
    800023cc:	e2e080e7          	jalr	-466(ra) # 800021f6 <argint>
    return -1;
    800023d0:	57fd                	li	a5,-1
  if(argint(0, &n) < 0)
    800023d2:	06054b63          	bltz	a0,80002448 <sys_sleep+0x8e>
    800023d6:	f04a                	sd	s2,32(sp)
  acquire(&tickslock);
    800023d8:	00230517          	auipc	a0,0x230
    800023dc:	ac050513          	addi	a0,a0,-1344 # 80231e98 <tickslock>
    800023e0:	00004097          	auipc	ra,0x4
    800023e4:	076080e7          	jalr	118(ra) # 80006456 <acquire>
  ticks0 = ticks;
    800023e8:	0000a917          	auipc	s2,0xa
    800023ec:	c3092903          	lw	s2,-976(s2) # 8000c018 <ticks>
  while(ticks - ticks0 < n){
    800023f0:	fcc42783          	lw	a5,-52(s0)
    800023f4:	c3a1                	beqz	a5,80002434 <sys_sleep+0x7a>
    800023f6:	f426                	sd	s1,40(sp)
    800023f8:	ec4e                	sd	s3,24(sp)
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800023fa:	00230997          	auipc	s3,0x230
    800023fe:	a9e98993          	addi	s3,s3,-1378 # 80231e98 <tickslock>
    80002402:	0000a497          	auipc	s1,0xa
    80002406:	c1648493          	addi	s1,s1,-1002 # 8000c018 <ticks>
    if(myproc()->killed){
    8000240a:	fffff097          	auipc	ra,0xfffff
    8000240e:	c5e080e7          	jalr	-930(ra) # 80001068 <myproc>
    80002412:	551c                	lw	a5,40(a0)
    80002414:	ef9d                	bnez	a5,80002452 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002416:	85ce                	mv	a1,s3
    80002418:	8526                	mv	a0,s1
    8000241a:	fffff097          	auipc	ra,0xfffff
    8000241e:	314080e7          	jalr	788(ra) # 8000172e <sleep>
  while(ticks - ticks0 < n){
    80002422:	409c                	lw	a5,0(s1)
    80002424:	412787bb          	subw	a5,a5,s2
    80002428:	fcc42703          	lw	a4,-52(s0)
    8000242c:	fce7efe3          	bltu	a5,a4,8000240a <sys_sleep+0x50>
    80002430:	74a2                	ld	s1,40(sp)
    80002432:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002434:	00230517          	auipc	a0,0x230
    80002438:	a6450513          	addi	a0,a0,-1436 # 80231e98 <tickslock>
    8000243c:	00004097          	auipc	ra,0x4
    80002440:	0ce080e7          	jalr	206(ra) # 8000650a <release>
  return 0;
    80002444:	4781                	li	a5,0
    80002446:	7902                	ld	s2,32(sp)
}
    80002448:	853e                	mv	a0,a5
    8000244a:	70e2                	ld	ra,56(sp)
    8000244c:	7442                	ld	s0,48(sp)
    8000244e:	6121                	addi	sp,sp,64
    80002450:	8082                	ret
      release(&tickslock);
    80002452:	00230517          	auipc	a0,0x230
    80002456:	a4650513          	addi	a0,a0,-1466 # 80231e98 <tickslock>
    8000245a:	00004097          	auipc	ra,0x4
    8000245e:	0b0080e7          	jalr	176(ra) # 8000650a <release>
      return -1;
    80002462:	57fd                	li	a5,-1
    80002464:	74a2                	ld	s1,40(sp)
    80002466:	7902                	ld	s2,32(sp)
    80002468:	69e2                	ld	s3,24(sp)
    8000246a:	bff9                	j	80002448 <sys_sleep+0x8e>

000000008000246c <sys_kill>:

uint64
sys_kill(void)
{
    8000246c:	1101                	addi	sp,sp,-32
    8000246e:	ec06                	sd	ra,24(sp)
    80002470:	e822                	sd	s0,16(sp)
    80002472:	1000                	addi	s0,sp,32
  int pid;

  if(argint(0, &pid) < 0)
    80002474:	fec40593          	addi	a1,s0,-20
    80002478:	4501                	li	a0,0
    8000247a:	00000097          	auipc	ra,0x0
    8000247e:	d7c080e7          	jalr	-644(ra) # 800021f6 <argint>
    80002482:	87aa                	mv	a5,a0
    return -1;
    80002484:	557d                	li	a0,-1
  if(argint(0, &pid) < 0)
    80002486:	0007c863          	bltz	a5,80002496 <sys_kill+0x2a>
  return kill(pid);
    8000248a:	fec42503          	lw	a0,-20(s0)
    8000248e:	fffff097          	auipc	ra,0xfffff
    80002492:	5d2080e7          	jalr	1490(ra) # 80001a60 <kill>
}
    80002496:	60e2                	ld	ra,24(sp)
    80002498:	6442                	ld	s0,16(sp)
    8000249a:	6105                	addi	sp,sp,32
    8000249c:	8082                	ret

000000008000249e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000249e:	1101                	addi	sp,sp,-32
    800024a0:	ec06                	sd	ra,24(sp)
    800024a2:	e822                	sd	s0,16(sp)
    800024a4:	e426                	sd	s1,8(sp)
    800024a6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800024a8:	00230517          	auipc	a0,0x230
    800024ac:	9f050513          	addi	a0,a0,-1552 # 80231e98 <tickslock>
    800024b0:	00004097          	auipc	ra,0x4
    800024b4:	fa6080e7          	jalr	-90(ra) # 80006456 <acquire>
  xticks = ticks;
    800024b8:	0000a497          	auipc	s1,0xa
    800024bc:	b604a483          	lw	s1,-1184(s1) # 8000c018 <ticks>
  release(&tickslock);
    800024c0:	00230517          	auipc	a0,0x230
    800024c4:	9d850513          	addi	a0,a0,-1576 # 80231e98 <tickslock>
    800024c8:	00004097          	auipc	ra,0x4
    800024cc:	042080e7          	jalr	66(ra) # 8000650a <release>
  return xticks;
}
    800024d0:	02049513          	slli	a0,s1,0x20
    800024d4:	9101                	srli	a0,a0,0x20
    800024d6:	60e2                	ld	ra,24(sp)
    800024d8:	6442                	ld	s0,16(sp)
    800024da:	64a2                	ld	s1,8(sp)
    800024dc:	6105                	addi	sp,sp,32
    800024de:	8082                	ret

00000000800024e0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800024e0:	7179                	addi	sp,sp,-48
    800024e2:	f406                	sd	ra,40(sp)
    800024e4:	f022                	sd	s0,32(sp)
    800024e6:	ec26                	sd	s1,24(sp)
    800024e8:	e84a                	sd	s2,16(sp)
    800024ea:	e44e                	sd	s3,8(sp)
    800024ec:	e052                	sd	s4,0(sp)
    800024ee:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800024f0:	00006597          	auipc	a1,0x6
    800024f4:	e9858593          	addi	a1,a1,-360 # 80008388 <etext+0x388>
    800024f8:	00230517          	auipc	a0,0x230
    800024fc:	9b850513          	addi	a0,a0,-1608 # 80231eb0 <bcache>
    80002500:	00004097          	auipc	ra,0x4
    80002504:	ec6080e7          	jalr	-314(ra) # 800063c6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002508:	00238797          	auipc	a5,0x238
    8000250c:	9a878793          	addi	a5,a5,-1624 # 80239eb0 <bcache+0x8000>
    80002510:	00238717          	auipc	a4,0x238
    80002514:	c0870713          	addi	a4,a4,-1016 # 8023a118 <bcache+0x8268>
    80002518:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000251c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002520:	00230497          	auipc	s1,0x230
    80002524:	9a848493          	addi	s1,s1,-1624 # 80231ec8 <bcache+0x18>
    b->next = bcache.head.next;
    80002528:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000252a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000252c:	00006a17          	auipc	s4,0x6
    80002530:	e64a0a13          	addi	s4,s4,-412 # 80008390 <etext+0x390>
    b->next = bcache.head.next;
    80002534:	2b893783          	ld	a5,696(s2)
    80002538:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000253a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000253e:	85d2                	mv	a1,s4
    80002540:	01048513          	addi	a0,s1,16
    80002544:	00001097          	auipc	ra,0x1
    80002548:	4b2080e7          	jalr	1202(ra) # 800039f6 <initsleeplock>
    bcache.head.next->prev = b;
    8000254c:	2b893783          	ld	a5,696(s2)
    80002550:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002552:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002556:	45848493          	addi	s1,s1,1112
    8000255a:	fd349de3          	bne	s1,s3,80002534 <binit+0x54>
  }
}
    8000255e:	70a2                	ld	ra,40(sp)
    80002560:	7402                	ld	s0,32(sp)
    80002562:	64e2                	ld	s1,24(sp)
    80002564:	6942                	ld	s2,16(sp)
    80002566:	69a2                	ld	s3,8(sp)
    80002568:	6a02                	ld	s4,0(sp)
    8000256a:	6145                	addi	sp,sp,48
    8000256c:	8082                	ret

000000008000256e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000256e:	7179                	addi	sp,sp,-48
    80002570:	f406                	sd	ra,40(sp)
    80002572:	f022                	sd	s0,32(sp)
    80002574:	ec26                	sd	s1,24(sp)
    80002576:	e84a                	sd	s2,16(sp)
    80002578:	e44e                	sd	s3,8(sp)
    8000257a:	1800                	addi	s0,sp,48
    8000257c:	892a                	mv	s2,a0
    8000257e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002580:	00230517          	auipc	a0,0x230
    80002584:	93050513          	addi	a0,a0,-1744 # 80231eb0 <bcache>
    80002588:	00004097          	auipc	ra,0x4
    8000258c:	ece080e7          	jalr	-306(ra) # 80006456 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002590:	00238497          	auipc	s1,0x238
    80002594:	bd84b483          	ld	s1,-1064(s1) # 8023a168 <bcache+0x82b8>
    80002598:	00238797          	auipc	a5,0x238
    8000259c:	b8078793          	addi	a5,a5,-1152 # 8023a118 <bcache+0x8268>
    800025a0:	02f48f63          	beq	s1,a5,800025de <bread+0x70>
    800025a4:	873e                	mv	a4,a5
    800025a6:	a021                	j	800025ae <bread+0x40>
    800025a8:	68a4                	ld	s1,80(s1)
    800025aa:	02e48a63          	beq	s1,a4,800025de <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800025ae:	449c                	lw	a5,8(s1)
    800025b0:	ff279ce3          	bne	a5,s2,800025a8 <bread+0x3a>
    800025b4:	44dc                	lw	a5,12(s1)
    800025b6:	ff3799e3          	bne	a5,s3,800025a8 <bread+0x3a>
      b->refcnt++;
    800025ba:	40bc                	lw	a5,64(s1)
    800025bc:	2785                	addiw	a5,a5,1
    800025be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800025c0:	00230517          	auipc	a0,0x230
    800025c4:	8f050513          	addi	a0,a0,-1808 # 80231eb0 <bcache>
    800025c8:	00004097          	auipc	ra,0x4
    800025cc:	f42080e7          	jalr	-190(ra) # 8000650a <release>
      acquiresleep(&b->lock);
    800025d0:	01048513          	addi	a0,s1,16
    800025d4:	00001097          	auipc	ra,0x1
    800025d8:	45c080e7          	jalr	1116(ra) # 80003a30 <acquiresleep>
      return b;
    800025dc:	a8b9                	j	8000263a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025de:	00238497          	auipc	s1,0x238
    800025e2:	b824b483          	ld	s1,-1150(s1) # 8023a160 <bcache+0x82b0>
    800025e6:	00238797          	auipc	a5,0x238
    800025ea:	b3278793          	addi	a5,a5,-1230 # 8023a118 <bcache+0x8268>
    800025ee:	00f48863          	beq	s1,a5,800025fe <bread+0x90>
    800025f2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800025f4:	40bc                	lw	a5,64(s1)
    800025f6:	cf81                	beqz	a5,8000260e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800025f8:	64a4                	ld	s1,72(s1)
    800025fa:	fee49de3          	bne	s1,a4,800025f4 <bread+0x86>
  panic("bget: no buffers");
    800025fe:	00006517          	auipc	a0,0x6
    80002602:	d9a50513          	addi	a0,a0,-614 # 80008398 <etext+0x398>
    80002606:	00004097          	auipc	ra,0x4
    8000260a:	8d6080e7          	jalr	-1834(ra) # 80005edc <panic>
      b->dev = dev;
    8000260e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002612:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002616:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000261a:	4785                	li	a5,1
    8000261c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000261e:	00230517          	auipc	a0,0x230
    80002622:	89250513          	addi	a0,a0,-1902 # 80231eb0 <bcache>
    80002626:	00004097          	auipc	ra,0x4
    8000262a:	ee4080e7          	jalr	-284(ra) # 8000650a <release>
      acquiresleep(&b->lock);
    8000262e:	01048513          	addi	a0,s1,16
    80002632:	00001097          	auipc	ra,0x1
    80002636:	3fe080e7          	jalr	1022(ra) # 80003a30 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000263a:	409c                	lw	a5,0(s1)
    8000263c:	cb89                	beqz	a5,8000264e <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000263e:	8526                	mv	a0,s1
    80002640:	70a2                	ld	ra,40(sp)
    80002642:	7402                	ld	s0,32(sp)
    80002644:	64e2                	ld	s1,24(sp)
    80002646:	6942                	ld	s2,16(sp)
    80002648:	69a2                	ld	s3,8(sp)
    8000264a:	6145                	addi	sp,sp,48
    8000264c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000264e:	4581                	li	a1,0
    80002650:	8526                	mv	a0,s1
    80002652:	00003097          	auipc	ra,0x3
    80002656:	ff0080e7          	jalr	-16(ra) # 80005642 <virtio_disk_rw>
    b->valid = 1;
    8000265a:	4785                	li	a5,1
    8000265c:	c09c                	sw	a5,0(s1)
  return b;
    8000265e:	b7c5                	j	8000263e <bread+0xd0>

0000000080002660 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002660:	1101                	addi	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	e426                	sd	s1,8(sp)
    80002668:	1000                	addi	s0,sp,32
    8000266a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000266c:	0541                	addi	a0,a0,16
    8000266e:	00001097          	auipc	ra,0x1
    80002672:	45c080e7          	jalr	1116(ra) # 80003aca <holdingsleep>
    80002676:	cd01                	beqz	a0,8000268e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002678:	4585                	li	a1,1
    8000267a:	8526                	mv	a0,s1
    8000267c:	00003097          	auipc	ra,0x3
    80002680:	fc6080e7          	jalr	-58(ra) # 80005642 <virtio_disk_rw>
}
    80002684:	60e2                	ld	ra,24(sp)
    80002686:	6442                	ld	s0,16(sp)
    80002688:	64a2                	ld	s1,8(sp)
    8000268a:	6105                	addi	sp,sp,32
    8000268c:	8082                	ret
    panic("bwrite");
    8000268e:	00006517          	auipc	a0,0x6
    80002692:	d2250513          	addi	a0,a0,-734 # 800083b0 <etext+0x3b0>
    80002696:	00004097          	auipc	ra,0x4
    8000269a:	846080e7          	jalr	-1978(ra) # 80005edc <panic>

000000008000269e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000269e:	1101                	addi	sp,sp,-32
    800026a0:	ec06                	sd	ra,24(sp)
    800026a2:	e822                	sd	s0,16(sp)
    800026a4:	e426                	sd	s1,8(sp)
    800026a6:	e04a                	sd	s2,0(sp)
    800026a8:	1000                	addi	s0,sp,32
    800026aa:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026ac:	01050913          	addi	s2,a0,16
    800026b0:	854a                	mv	a0,s2
    800026b2:	00001097          	auipc	ra,0x1
    800026b6:	418080e7          	jalr	1048(ra) # 80003aca <holdingsleep>
    800026ba:	c925                	beqz	a0,8000272a <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    800026bc:	854a                	mv	a0,s2
    800026be:	00001097          	auipc	ra,0x1
    800026c2:	3c8080e7          	jalr	968(ra) # 80003a86 <releasesleep>

  acquire(&bcache.lock);
    800026c6:	0022f517          	auipc	a0,0x22f
    800026ca:	7ea50513          	addi	a0,a0,2026 # 80231eb0 <bcache>
    800026ce:	00004097          	auipc	ra,0x4
    800026d2:	d88080e7          	jalr	-632(ra) # 80006456 <acquire>
  b->refcnt--;
    800026d6:	40bc                	lw	a5,64(s1)
    800026d8:	37fd                	addiw	a5,a5,-1
    800026da:	0007871b          	sext.w	a4,a5
    800026de:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026e0:	e71d                	bnez	a4,8000270e <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026e2:	68b8                	ld	a4,80(s1)
    800026e4:	64bc                	ld	a5,72(s1)
    800026e6:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800026e8:	68b8                	ld	a4,80(s1)
    800026ea:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800026ec:	00237797          	auipc	a5,0x237
    800026f0:	7c478793          	addi	a5,a5,1988 # 80239eb0 <bcache+0x8000>
    800026f4:	2b87b703          	ld	a4,696(a5)
    800026f8:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800026fa:	00238717          	auipc	a4,0x238
    800026fe:	a1e70713          	addi	a4,a4,-1506 # 8023a118 <bcache+0x8268>
    80002702:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002704:	2b87b703          	ld	a4,696(a5)
    80002708:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000270a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000270e:	0022f517          	auipc	a0,0x22f
    80002712:	7a250513          	addi	a0,a0,1954 # 80231eb0 <bcache>
    80002716:	00004097          	auipc	ra,0x4
    8000271a:	df4080e7          	jalr	-524(ra) # 8000650a <release>
}
    8000271e:	60e2                	ld	ra,24(sp)
    80002720:	6442                	ld	s0,16(sp)
    80002722:	64a2                	ld	s1,8(sp)
    80002724:	6902                	ld	s2,0(sp)
    80002726:	6105                	addi	sp,sp,32
    80002728:	8082                	ret
    panic("brelse");
    8000272a:	00006517          	auipc	a0,0x6
    8000272e:	c8e50513          	addi	a0,a0,-882 # 800083b8 <etext+0x3b8>
    80002732:	00003097          	auipc	ra,0x3
    80002736:	7aa080e7          	jalr	1962(ra) # 80005edc <panic>

000000008000273a <bpin>:

void
bpin(struct buf *b) {
    8000273a:	1101                	addi	sp,sp,-32
    8000273c:	ec06                	sd	ra,24(sp)
    8000273e:	e822                	sd	s0,16(sp)
    80002740:	e426                	sd	s1,8(sp)
    80002742:	1000                	addi	s0,sp,32
    80002744:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002746:	0022f517          	auipc	a0,0x22f
    8000274a:	76a50513          	addi	a0,a0,1898 # 80231eb0 <bcache>
    8000274e:	00004097          	auipc	ra,0x4
    80002752:	d08080e7          	jalr	-760(ra) # 80006456 <acquire>
  b->refcnt++;
    80002756:	40bc                	lw	a5,64(s1)
    80002758:	2785                	addiw	a5,a5,1
    8000275a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000275c:	0022f517          	auipc	a0,0x22f
    80002760:	75450513          	addi	a0,a0,1876 # 80231eb0 <bcache>
    80002764:	00004097          	auipc	ra,0x4
    80002768:	da6080e7          	jalr	-602(ra) # 8000650a <release>
}
    8000276c:	60e2                	ld	ra,24(sp)
    8000276e:	6442                	ld	s0,16(sp)
    80002770:	64a2                	ld	s1,8(sp)
    80002772:	6105                	addi	sp,sp,32
    80002774:	8082                	ret

0000000080002776 <bunpin>:

void
bunpin(struct buf *b) {
    80002776:	1101                	addi	sp,sp,-32
    80002778:	ec06                	sd	ra,24(sp)
    8000277a:	e822                	sd	s0,16(sp)
    8000277c:	e426                	sd	s1,8(sp)
    8000277e:	1000                	addi	s0,sp,32
    80002780:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002782:	0022f517          	auipc	a0,0x22f
    80002786:	72e50513          	addi	a0,a0,1838 # 80231eb0 <bcache>
    8000278a:	00004097          	auipc	ra,0x4
    8000278e:	ccc080e7          	jalr	-820(ra) # 80006456 <acquire>
  b->refcnt--;
    80002792:	40bc                	lw	a5,64(s1)
    80002794:	37fd                	addiw	a5,a5,-1
    80002796:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002798:	0022f517          	auipc	a0,0x22f
    8000279c:	71850513          	addi	a0,a0,1816 # 80231eb0 <bcache>
    800027a0:	00004097          	auipc	ra,0x4
    800027a4:	d6a080e7          	jalr	-662(ra) # 8000650a <release>
}
    800027a8:	60e2                	ld	ra,24(sp)
    800027aa:	6442                	ld	s0,16(sp)
    800027ac:	64a2                	ld	s1,8(sp)
    800027ae:	6105                	addi	sp,sp,32
    800027b0:	8082                	ret

00000000800027b2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027b2:	1101                	addi	sp,sp,-32
    800027b4:	ec06                	sd	ra,24(sp)
    800027b6:	e822                	sd	s0,16(sp)
    800027b8:	e426                	sd	s1,8(sp)
    800027ba:	e04a                	sd	s2,0(sp)
    800027bc:	1000                	addi	s0,sp,32
    800027be:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027c0:	00d5d59b          	srliw	a1,a1,0xd
    800027c4:	00238797          	auipc	a5,0x238
    800027c8:	dc87a783          	lw	a5,-568(a5) # 8023a58c <sb+0x1c>
    800027cc:	9dbd                	addw	a1,a1,a5
    800027ce:	00000097          	auipc	ra,0x0
    800027d2:	da0080e7          	jalr	-608(ra) # 8000256e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027d6:	0074f713          	andi	a4,s1,7
    800027da:	4785                	li	a5,1
    800027dc:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800027e0:	14ce                	slli	s1,s1,0x33
    800027e2:	90d9                	srli	s1,s1,0x36
    800027e4:	00950733          	add	a4,a0,s1
    800027e8:	05874703          	lbu	a4,88(a4)
    800027ec:	00e7f6b3          	and	a3,a5,a4
    800027f0:	c69d                	beqz	a3,8000281e <bfree+0x6c>
    800027f2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027f4:	94aa                	add	s1,s1,a0
    800027f6:	fff7c793          	not	a5,a5
    800027fa:	8f7d                	and	a4,a4,a5
    800027fc:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002800:	00001097          	auipc	ra,0x1
    80002804:	112080e7          	jalr	274(ra) # 80003912 <log_write>
  brelse(bp);
    80002808:	854a                	mv	a0,s2
    8000280a:	00000097          	auipc	ra,0x0
    8000280e:	e94080e7          	jalr	-364(ra) # 8000269e <brelse>
}
    80002812:	60e2                	ld	ra,24(sp)
    80002814:	6442                	ld	s0,16(sp)
    80002816:	64a2                	ld	s1,8(sp)
    80002818:	6902                	ld	s2,0(sp)
    8000281a:	6105                	addi	sp,sp,32
    8000281c:	8082                	ret
    panic("freeing free block");
    8000281e:	00006517          	auipc	a0,0x6
    80002822:	ba250513          	addi	a0,a0,-1118 # 800083c0 <etext+0x3c0>
    80002826:	00003097          	auipc	ra,0x3
    8000282a:	6b6080e7          	jalr	1718(ra) # 80005edc <panic>

000000008000282e <balloc>:
{
    8000282e:	711d                	addi	sp,sp,-96
    80002830:	ec86                	sd	ra,88(sp)
    80002832:	e8a2                	sd	s0,80(sp)
    80002834:	e4a6                	sd	s1,72(sp)
    80002836:	e0ca                	sd	s2,64(sp)
    80002838:	fc4e                	sd	s3,56(sp)
    8000283a:	f852                	sd	s4,48(sp)
    8000283c:	f456                	sd	s5,40(sp)
    8000283e:	f05a                	sd	s6,32(sp)
    80002840:	ec5e                	sd	s7,24(sp)
    80002842:	e862                	sd	s8,16(sp)
    80002844:	e466                	sd	s9,8(sp)
    80002846:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002848:	00238797          	auipc	a5,0x238
    8000284c:	d2c7a783          	lw	a5,-724(a5) # 8023a574 <sb+0x4>
    80002850:	cbc1                	beqz	a5,800028e0 <balloc+0xb2>
    80002852:	8baa                	mv	s7,a0
    80002854:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002856:	00238b17          	auipc	s6,0x238
    8000285a:	d1ab0b13          	addi	s6,s6,-742 # 8023a570 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000285e:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002860:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002862:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002864:	6c89                	lui	s9,0x2
    80002866:	a831                	j	80002882 <balloc+0x54>
    brelse(bp);
    80002868:	854a                	mv	a0,s2
    8000286a:	00000097          	auipc	ra,0x0
    8000286e:	e34080e7          	jalr	-460(ra) # 8000269e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002872:	015c87bb          	addw	a5,s9,s5
    80002876:	00078a9b          	sext.w	s5,a5
    8000287a:	004b2703          	lw	a4,4(s6)
    8000287e:	06eaf163          	bgeu	s5,a4,800028e0 <balloc+0xb2>
    bp = bread(dev, BBLOCK(b, sb));
    80002882:	41fad79b          	sraiw	a5,s5,0x1f
    80002886:	0137d79b          	srliw	a5,a5,0x13
    8000288a:	015787bb          	addw	a5,a5,s5
    8000288e:	40d7d79b          	sraiw	a5,a5,0xd
    80002892:	01cb2583          	lw	a1,28(s6)
    80002896:	9dbd                	addw	a1,a1,a5
    80002898:	855e                	mv	a0,s7
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	cd4080e7          	jalr	-812(ra) # 8000256e <bread>
    800028a2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028a4:	004b2503          	lw	a0,4(s6)
    800028a8:	000a849b          	sext.w	s1,s5
    800028ac:	8762                	mv	a4,s8
    800028ae:	faa4fde3          	bgeu	s1,a0,80002868 <balloc+0x3a>
      m = 1 << (bi % 8);
    800028b2:	00777693          	andi	a3,a4,7
    800028b6:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028ba:	41f7579b          	sraiw	a5,a4,0x1f
    800028be:	01d7d79b          	srliw	a5,a5,0x1d
    800028c2:	9fb9                	addw	a5,a5,a4
    800028c4:	4037d79b          	sraiw	a5,a5,0x3
    800028c8:	00f90633          	add	a2,s2,a5
    800028cc:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    800028d0:	00c6f5b3          	and	a1,a3,a2
    800028d4:	cd91                	beqz	a1,800028f0 <balloc+0xc2>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d6:	2705                	addiw	a4,a4,1
    800028d8:	2485                	addiw	s1,s1,1
    800028da:	fd471ae3          	bne	a4,s4,800028ae <balloc+0x80>
    800028de:	b769                	j	80002868 <balloc+0x3a>
  panic("balloc: out of blocks");
    800028e0:	00006517          	auipc	a0,0x6
    800028e4:	af850513          	addi	a0,a0,-1288 # 800083d8 <etext+0x3d8>
    800028e8:	00003097          	auipc	ra,0x3
    800028ec:	5f4080e7          	jalr	1524(ra) # 80005edc <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028f0:	97ca                	add	a5,a5,s2
    800028f2:	8e55                	or	a2,a2,a3
    800028f4:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028f8:	854a                	mv	a0,s2
    800028fa:	00001097          	auipc	ra,0x1
    800028fe:	018080e7          	jalr	24(ra) # 80003912 <log_write>
        brelse(bp);
    80002902:	854a                	mv	a0,s2
    80002904:	00000097          	auipc	ra,0x0
    80002908:	d9a080e7          	jalr	-614(ra) # 8000269e <brelse>
  bp = bread(dev, bno);
    8000290c:	85a6                	mv	a1,s1
    8000290e:	855e                	mv	a0,s7
    80002910:	00000097          	auipc	ra,0x0
    80002914:	c5e080e7          	jalr	-930(ra) # 8000256e <bread>
    80002918:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000291a:	40000613          	li	a2,1024
    8000291e:	4581                	li	a1,0
    80002920:	05850513          	addi	a0,a0,88
    80002924:	ffffe097          	auipc	ra,0xffffe
    80002928:	90c080e7          	jalr	-1780(ra) # 80000230 <memset>
  log_write(bp);
    8000292c:	854a                	mv	a0,s2
    8000292e:	00001097          	auipc	ra,0x1
    80002932:	fe4080e7          	jalr	-28(ra) # 80003912 <log_write>
  brelse(bp);
    80002936:	854a                	mv	a0,s2
    80002938:	00000097          	auipc	ra,0x0
    8000293c:	d66080e7          	jalr	-666(ra) # 8000269e <brelse>
}
    80002940:	8526                	mv	a0,s1
    80002942:	60e6                	ld	ra,88(sp)
    80002944:	6446                	ld	s0,80(sp)
    80002946:	64a6                	ld	s1,72(sp)
    80002948:	6906                	ld	s2,64(sp)
    8000294a:	79e2                	ld	s3,56(sp)
    8000294c:	7a42                	ld	s4,48(sp)
    8000294e:	7aa2                	ld	s5,40(sp)
    80002950:	7b02                	ld	s6,32(sp)
    80002952:	6be2                	ld	s7,24(sp)
    80002954:	6c42                	ld	s8,16(sp)
    80002956:	6ca2                	ld	s9,8(sp)
    80002958:	6125                	addi	sp,sp,96
    8000295a:	8082                	ret

000000008000295c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    8000295c:	7179                	addi	sp,sp,-48
    8000295e:	f406                	sd	ra,40(sp)
    80002960:	f022                	sd	s0,32(sp)
    80002962:	ec26                	sd	s1,24(sp)
    80002964:	e84a                	sd	s2,16(sp)
    80002966:	e44e                	sd	s3,8(sp)
    80002968:	1800                	addi	s0,sp,48
    8000296a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000296c:	47ad                	li	a5,11
    8000296e:	04b7ff63          	bgeu	a5,a1,800029cc <bmap+0x70>
    80002972:	e052                	sd	s4,0(sp)
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    80002974:	ff45849b          	addiw	s1,a1,-12
    80002978:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    8000297c:	0ff00793          	li	a5,255
    80002980:	0ae7e463          	bltu	a5,a4,80002a28 <bmap+0xcc>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    80002984:	08052583          	lw	a1,128(a0)
    80002988:	c5b5                	beqz	a1,800029f4 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    8000298a:	00092503          	lw	a0,0(s2)
    8000298e:	00000097          	auipc	ra,0x0
    80002992:	be0080e7          	jalr	-1056(ra) # 8000256e <bread>
    80002996:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002998:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000299c:	02049713          	slli	a4,s1,0x20
    800029a0:	01e75593          	srli	a1,a4,0x1e
    800029a4:	00b784b3          	add	s1,a5,a1
    800029a8:	0004a983          	lw	s3,0(s1)
    800029ac:	04098e63          	beqz	s3,80002a08 <bmap+0xac>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800029b0:	8552                	mv	a0,s4
    800029b2:	00000097          	auipc	ra,0x0
    800029b6:	cec080e7          	jalr	-788(ra) # 8000269e <brelse>
    return addr;
    800029ba:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029bc:	854e                	mv	a0,s3
    800029be:	70a2                	ld	ra,40(sp)
    800029c0:	7402                	ld	s0,32(sp)
    800029c2:	64e2                	ld	s1,24(sp)
    800029c4:	6942                	ld	s2,16(sp)
    800029c6:	69a2                	ld	s3,8(sp)
    800029c8:	6145                	addi	sp,sp,48
    800029ca:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800029cc:	02059793          	slli	a5,a1,0x20
    800029d0:	01e7d593          	srli	a1,a5,0x1e
    800029d4:	00b504b3          	add	s1,a0,a1
    800029d8:	0504a983          	lw	s3,80(s1)
    800029dc:	fe0990e3          	bnez	s3,800029bc <bmap+0x60>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800029e0:	4108                	lw	a0,0(a0)
    800029e2:	00000097          	auipc	ra,0x0
    800029e6:	e4c080e7          	jalr	-436(ra) # 8000282e <balloc>
    800029ea:	0005099b          	sext.w	s3,a0
    800029ee:	0534a823          	sw	s3,80(s1)
    800029f2:	b7e9                	j	800029bc <bmap+0x60>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    800029f4:	4108                	lw	a0,0(a0)
    800029f6:	00000097          	auipc	ra,0x0
    800029fa:	e38080e7          	jalr	-456(ra) # 8000282e <balloc>
    800029fe:	0005059b          	sext.w	a1,a0
    80002a02:	08b92023          	sw	a1,128(s2)
    80002a06:	b751                	j	8000298a <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80002a08:	00092503          	lw	a0,0(s2)
    80002a0c:	00000097          	auipc	ra,0x0
    80002a10:	e22080e7          	jalr	-478(ra) # 8000282e <balloc>
    80002a14:	0005099b          	sext.w	s3,a0
    80002a18:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80002a1c:	8552                	mv	a0,s4
    80002a1e:	00001097          	auipc	ra,0x1
    80002a22:	ef4080e7          	jalr	-268(ra) # 80003912 <log_write>
    80002a26:	b769                	j	800029b0 <bmap+0x54>
  panic("bmap: out of range");
    80002a28:	00006517          	auipc	a0,0x6
    80002a2c:	9c850513          	addi	a0,a0,-1592 # 800083f0 <etext+0x3f0>
    80002a30:	00003097          	auipc	ra,0x3
    80002a34:	4ac080e7          	jalr	1196(ra) # 80005edc <panic>

0000000080002a38 <iget>:
{
    80002a38:	7179                	addi	sp,sp,-48
    80002a3a:	f406                	sd	ra,40(sp)
    80002a3c:	f022                	sd	s0,32(sp)
    80002a3e:	ec26                	sd	s1,24(sp)
    80002a40:	e84a                	sd	s2,16(sp)
    80002a42:	e44e                	sd	s3,8(sp)
    80002a44:	e052                	sd	s4,0(sp)
    80002a46:	1800                	addi	s0,sp,48
    80002a48:	89aa                	mv	s3,a0
    80002a4a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a4c:	00238517          	auipc	a0,0x238
    80002a50:	b4450513          	addi	a0,a0,-1212 # 8023a590 <itable>
    80002a54:	00004097          	auipc	ra,0x4
    80002a58:	a02080e7          	jalr	-1534(ra) # 80006456 <acquire>
  empty = 0;
    80002a5c:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a5e:	00238497          	auipc	s1,0x238
    80002a62:	b4a48493          	addi	s1,s1,-1206 # 8023a5a8 <itable+0x18>
    80002a66:	00239697          	auipc	a3,0x239
    80002a6a:	5d268693          	addi	a3,a3,1490 # 8023c038 <log>
    80002a6e:	a039                	j	80002a7c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a70:	02090b63          	beqz	s2,80002aa6 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a74:	08848493          	addi	s1,s1,136
    80002a78:	02d48a63          	beq	s1,a3,80002aac <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a7c:	449c                	lw	a5,8(s1)
    80002a7e:	fef059e3          	blez	a5,80002a70 <iget+0x38>
    80002a82:	4098                	lw	a4,0(s1)
    80002a84:	ff3716e3          	bne	a4,s3,80002a70 <iget+0x38>
    80002a88:	40d8                	lw	a4,4(s1)
    80002a8a:	ff4713e3          	bne	a4,s4,80002a70 <iget+0x38>
      ip->ref++;
    80002a8e:	2785                	addiw	a5,a5,1
    80002a90:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a92:	00238517          	auipc	a0,0x238
    80002a96:	afe50513          	addi	a0,a0,-1282 # 8023a590 <itable>
    80002a9a:	00004097          	auipc	ra,0x4
    80002a9e:	a70080e7          	jalr	-1424(ra) # 8000650a <release>
      return ip;
    80002aa2:	8926                	mv	s2,s1
    80002aa4:	a03d                	j	80002ad2 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002aa6:	f7f9                	bnez	a5,80002a74 <iget+0x3c>
      empty = ip;
    80002aa8:	8926                	mv	s2,s1
    80002aaa:	b7e9                	j	80002a74 <iget+0x3c>
  if(empty == 0)
    80002aac:	02090c63          	beqz	s2,80002ae4 <iget+0xac>
  ip->dev = dev;
    80002ab0:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002ab4:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002ab8:	4785                	li	a5,1
    80002aba:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80002abe:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002ac2:	00238517          	auipc	a0,0x238
    80002ac6:	ace50513          	addi	a0,a0,-1330 # 8023a590 <itable>
    80002aca:	00004097          	auipc	ra,0x4
    80002ace:	a40080e7          	jalr	-1472(ra) # 8000650a <release>
}
    80002ad2:	854a                	mv	a0,s2
    80002ad4:	70a2                	ld	ra,40(sp)
    80002ad6:	7402                	ld	s0,32(sp)
    80002ad8:	64e2                	ld	s1,24(sp)
    80002ada:	6942                	ld	s2,16(sp)
    80002adc:	69a2                	ld	s3,8(sp)
    80002ade:	6a02                	ld	s4,0(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret
    panic("iget: no inodes");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	92450513          	addi	a0,a0,-1756 # 80008408 <etext+0x408>
    80002aec:	00003097          	auipc	ra,0x3
    80002af0:	3f0080e7          	jalr	1008(ra) # 80005edc <panic>

0000000080002af4 <fsinit>:
fsinit(int dev) {
    80002af4:	7179                	addi	sp,sp,-48
    80002af6:	f406                	sd	ra,40(sp)
    80002af8:	f022                	sd	s0,32(sp)
    80002afa:	ec26                	sd	s1,24(sp)
    80002afc:	e84a                	sd	s2,16(sp)
    80002afe:	e44e                	sd	s3,8(sp)
    80002b00:	1800                	addi	s0,sp,48
    80002b02:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002b04:	4585                	li	a1,1
    80002b06:	00000097          	auipc	ra,0x0
    80002b0a:	a68080e7          	jalr	-1432(ra) # 8000256e <bread>
    80002b0e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002b10:	00238997          	auipc	s3,0x238
    80002b14:	a6098993          	addi	s3,s3,-1440 # 8023a570 <sb>
    80002b18:	02000613          	li	a2,32
    80002b1c:	05850593          	addi	a1,a0,88
    80002b20:	854e                	mv	a0,s3
    80002b22:	ffffd097          	auipc	ra,0xffffd
    80002b26:	76a080e7          	jalr	1898(ra) # 8000028c <memmove>
  brelse(bp);
    80002b2a:	8526                	mv	a0,s1
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	b72080e7          	jalr	-1166(ra) # 8000269e <brelse>
  if(sb.magic != FSMAGIC)
    80002b34:	0009a703          	lw	a4,0(s3)
    80002b38:	102037b7          	lui	a5,0x10203
    80002b3c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002b40:	02f71263          	bne	a4,a5,80002b64 <fsinit+0x70>
  initlog(dev, &sb);
    80002b44:	00238597          	auipc	a1,0x238
    80002b48:	a2c58593          	addi	a1,a1,-1492 # 8023a570 <sb>
    80002b4c:	854a                	mv	a0,s2
    80002b4e:	00001097          	auipc	ra,0x1
    80002b52:	b54080e7          	jalr	-1196(ra) # 800036a2 <initlog>
}
    80002b56:	70a2                	ld	ra,40(sp)
    80002b58:	7402                	ld	s0,32(sp)
    80002b5a:	64e2                	ld	s1,24(sp)
    80002b5c:	6942                	ld	s2,16(sp)
    80002b5e:	69a2                	ld	s3,8(sp)
    80002b60:	6145                	addi	sp,sp,48
    80002b62:	8082                	ret
    panic("invalid file system");
    80002b64:	00006517          	auipc	a0,0x6
    80002b68:	8b450513          	addi	a0,a0,-1868 # 80008418 <etext+0x418>
    80002b6c:	00003097          	auipc	ra,0x3
    80002b70:	370080e7          	jalr	880(ra) # 80005edc <panic>

0000000080002b74 <iinit>:
{
    80002b74:	7179                	addi	sp,sp,-48
    80002b76:	f406                	sd	ra,40(sp)
    80002b78:	f022                	sd	s0,32(sp)
    80002b7a:	ec26                	sd	s1,24(sp)
    80002b7c:	e84a                	sd	s2,16(sp)
    80002b7e:	e44e                	sd	s3,8(sp)
    80002b80:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b82:	00006597          	auipc	a1,0x6
    80002b86:	8ae58593          	addi	a1,a1,-1874 # 80008430 <etext+0x430>
    80002b8a:	00238517          	auipc	a0,0x238
    80002b8e:	a0650513          	addi	a0,a0,-1530 # 8023a590 <itable>
    80002b92:	00004097          	auipc	ra,0x4
    80002b96:	834080e7          	jalr	-1996(ra) # 800063c6 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b9a:	00238497          	auipc	s1,0x238
    80002b9e:	a1e48493          	addi	s1,s1,-1506 # 8023a5b8 <itable+0x28>
    80002ba2:	00239997          	auipc	s3,0x239
    80002ba6:	4a698993          	addi	s3,s3,1190 # 8023c048 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002baa:	00006917          	auipc	s2,0x6
    80002bae:	88e90913          	addi	s2,s2,-1906 # 80008438 <etext+0x438>
    80002bb2:	85ca                	mv	a1,s2
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	00001097          	auipc	ra,0x1
    80002bba:	e40080e7          	jalr	-448(ra) # 800039f6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002bbe:	08848493          	addi	s1,s1,136
    80002bc2:	ff3498e3          	bne	s1,s3,80002bb2 <iinit+0x3e>
}
    80002bc6:	70a2                	ld	ra,40(sp)
    80002bc8:	7402                	ld	s0,32(sp)
    80002bca:	64e2                	ld	s1,24(sp)
    80002bcc:	6942                	ld	s2,16(sp)
    80002bce:	69a2                	ld	s3,8(sp)
    80002bd0:	6145                	addi	sp,sp,48
    80002bd2:	8082                	ret

0000000080002bd4 <ialloc>:
{
    80002bd4:	7139                	addi	sp,sp,-64
    80002bd6:	fc06                	sd	ra,56(sp)
    80002bd8:	f822                	sd	s0,48(sp)
    80002bda:	f426                	sd	s1,40(sp)
    80002bdc:	f04a                	sd	s2,32(sp)
    80002bde:	ec4e                	sd	s3,24(sp)
    80002be0:	e852                	sd	s4,16(sp)
    80002be2:	e456                	sd	s5,8(sp)
    80002be4:	e05a                	sd	s6,0(sp)
    80002be6:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002be8:	00238717          	auipc	a4,0x238
    80002bec:	99472703          	lw	a4,-1644(a4) # 8023a57c <sb+0xc>
    80002bf0:	4785                	li	a5,1
    80002bf2:	04e7f863          	bgeu	a5,a4,80002c42 <ialloc+0x6e>
    80002bf6:	8aaa                	mv	s5,a0
    80002bf8:	8b2e                	mv	s6,a1
    80002bfa:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002bfc:	00238a17          	auipc	s4,0x238
    80002c00:	974a0a13          	addi	s4,s4,-1676 # 8023a570 <sb>
    80002c04:	00495593          	srli	a1,s2,0x4
    80002c08:	018a2783          	lw	a5,24(s4)
    80002c0c:	9dbd                	addw	a1,a1,a5
    80002c0e:	8556                	mv	a0,s5
    80002c10:	00000097          	auipc	ra,0x0
    80002c14:	95e080e7          	jalr	-1698(ra) # 8000256e <bread>
    80002c18:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002c1a:	05850993          	addi	s3,a0,88
    80002c1e:	00f97793          	andi	a5,s2,15
    80002c22:	079a                	slli	a5,a5,0x6
    80002c24:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002c26:	00099783          	lh	a5,0(s3)
    80002c2a:	c785                	beqz	a5,80002c52 <ialloc+0x7e>
    brelse(bp);
    80002c2c:	00000097          	auipc	ra,0x0
    80002c30:	a72080e7          	jalr	-1422(ra) # 8000269e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002c34:	0905                	addi	s2,s2,1
    80002c36:	00ca2703          	lw	a4,12(s4)
    80002c3a:	0009079b          	sext.w	a5,s2
    80002c3e:	fce7e3e3          	bltu	a5,a4,80002c04 <ialloc+0x30>
  panic("ialloc: no inodes");
    80002c42:	00005517          	auipc	a0,0x5
    80002c46:	7fe50513          	addi	a0,a0,2046 # 80008440 <etext+0x440>
    80002c4a:	00003097          	auipc	ra,0x3
    80002c4e:	292080e7          	jalr	658(ra) # 80005edc <panic>
      memset(dip, 0, sizeof(*dip));
    80002c52:	04000613          	li	a2,64
    80002c56:	4581                	li	a1,0
    80002c58:	854e                	mv	a0,s3
    80002c5a:	ffffd097          	auipc	ra,0xffffd
    80002c5e:	5d6080e7          	jalr	1494(ra) # 80000230 <memset>
      dip->type = type;
    80002c62:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002c66:	8526                	mv	a0,s1
    80002c68:	00001097          	auipc	ra,0x1
    80002c6c:	caa080e7          	jalr	-854(ra) # 80003912 <log_write>
      brelse(bp);
    80002c70:	8526                	mv	a0,s1
    80002c72:	00000097          	auipc	ra,0x0
    80002c76:	a2c080e7          	jalr	-1492(ra) # 8000269e <brelse>
      return iget(dev, inum);
    80002c7a:	0009059b          	sext.w	a1,s2
    80002c7e:	8556                	mv	a0,s5
    80002c80:	00000097          	auipc	ra,0x0
    80002c84:	db8080e7          	jalr	-584(ra) # 80002a38 <iget>
}
    80002c88:	70e2                	ld	ra,56(sp)
    80002c8a:	7442                	ld	s0,48(sp)
    80002c8c:	74a2                	ld	s1,40(sp)
    80002c8e:	7902                	ld	s2,32(sp)
    80002c90:	69e2                	ld	s3,24(sp)
    80002c92:	6a42                	ld	s4,16(sp)
    80002c94:	6aa2                	ld	s5,8(sp)
    80002c96:	6b02                	ld	s6,0(sp)
    80002c98:	6121                	addi	sp,sp,64
    80002c9a:	8082                	ret

0000000080002c9c <iupdate>:
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	e04a                	sd	s2,0(sp)
    80002ca6:	1000                	addi	s0,sp,32
    80002ca8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002caa:	415c                	lw	a5,4(a0)
    80002cac:	0047d79b          	srliw	a5,a5,0x4
    80002cb0:	00238597          	auipc	a1,0x238
    80002cb4:	8d85a583          	lw	a1,-1832(a1) # 8023a588 <sb+0x18>
    80002cb8:	9dbd                	addw	a1,a1,a5
    80002cba:	4108                	lw	a0,0(a0)
    80002cbc:	00000097          	auipc	ra,0x0
    80002cc0:	8b2080e7          	jalr	-1870(ra) # 8000256e <bread>
    80002cc4:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cc6:	05850793          	addi	a5,a0,88
    80002cca:	40d8                	lw	a4,4(s1)
    80002ccc:	8b3d                	andi	a4,a4,15
    80002cce:	071a                	slli	a4,a4,0x6
    80002cd0:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002cd2:	04449703          	lh	a4,68(s1)
    80002cd6:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002cda:	04649703          	lh	a4,70(s1)
    80002cde:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002ce2:	04849703          	lh	a4,72(s1)
    80002ce6:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002cea:	04a49703          	lh	a4,74(s1)
    80002cee:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002cf2:	44f8                	lw	a4,76(s1)
    80002cf4:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002cf6:	03400613          	li	a2,52
    80002cfa:	05048593          	addi	a1,s1,80
    80002cfe:	00c78513          	addi	a0,a5,12
    80002d02:	ffffd097          	auipc	ra,0xffffd
    80002d06:	58a080e7          	jalr	1418(ra) # 8000028c <memmove>
  log_write(bp);
    80002d0a:	854a                	mv	a0,s2
    80002d0c:	00001097          	auipc	ra,0x1
    80002d10:	c06080e7          	jalr	-1018(ra) # 80003912 <log_write>
  brelse(bp);
    80002d14:	854a                	mv	a0,s2
    80002d16:	00000097          	auipc	ra,0x0
    80002d1a:	988080e7          	jalr	-1656(ra) # 8000269e <brelse>
}
    80002d1e:	60e2                	ld	ra,24(sp)
    80002d20:	6442                	ld	s0,16(sp)
    80002d22:	64a2                	ld	s1,8(sp)
    80002d24:	6902                	ld	s2,0(sp)
    80002d26:	6105                	addi	sp,sp,32
    80002d28:	8082                	ret

0000000080002d2a <idup>:
{
    80002d2a:	1101                	addi	sp,sp,-32
    80002d2c:	ec06                	sd	ra,24(sp)
    80002d2e:	e822                	sd	s0,16(sp)
    80002d30:	e426                	sd	s1,8(sp)
    80002d32:	1000                	addi	s0,sp,32
    80002d34:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002d36:	00238517          	auipc	a0,0x238
    80002d3a:	85a50513          	addi	a0,a0,-1958 # 8023a590 <itable>
    80002d3e:	00003097          	auipc	ra,0x3
    80002d42:	718080e7          	jalr	1816(ra) # 80006456 <acquire>
  ip->ref++;
    80002d46:	449c                	lw	a5,8(s1)
    80002d48:	2785                	addiw	a5,a5,1
    80002d4a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002d4c:	00238517          	auipc	a0,0x238
    80002d50:	84450513          	addi	a0,a0,-1980 # 8023a590 <itable>
    80002d54:	00003097          	auipc	ra,0x3
    80002d58:	7b6080e7          	jalr	1974(ra) # 8000650a <release>
}
    80002d5c:	8526                	mv	a0,s1
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6105                	addi	sp,sp,32
    80002d66:	8082                	ret

0000000080002d68 <ilock>:
{
    80002d68:	1101                	addi	sp,sp,-32
    80002d6a:	ec06                	sd	ra,24(sp)
    80002d6c:	e822                	sd	s0,16(sp)
    80002d6e:	e426                	sd	s1,8(sp)
    80002d70:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002d72:	c10d                	beqz	a0,80002d94 <ilock+0x2c>
    80002d74:	84aa                	mv	s1,a0
    80002d76:	451c                	lw	a5,8(a0)
    80002d78:	00f05e63          	blez	a5,80002d94 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80002d7c:	0541                	addi	a0,a0,16
    80002d7e:	00001097          	auipc	ra,0x1
    80002d82:	cb2080e7          	jalr	-846(ra) # 80003a30 <acquiresleep>
  if(ip->valid == 0){
    80002d86:	40bc                	lw	a5,64(s1)
    80002d88:	cf99                	beqz	a5,80002da6 <ilock+0x3e>
}
    80002d8a:	60e2                	ld	ra,24(sp)
    80002d8c:	6442                	ld	s0,16(sp)
    80002d8e:	64a2                	ld	s1,8(sp)
    80002d90:	6105                	addi	sp,sp,32
    80002d92:	8082                	ret
    80002d94:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002d96:	00005517          	auipc	a0,0x5
    80002d9a:	6c250513          	addi	a0,a0,1730 # 80008458 <etext+0x458>
    80002d9e:	00003097          	auipc	ra,0x3
    80002da2:	13e080e7          	jalr	318(ra) # 80005edc <panic>
    80002da6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002da8:	40dc                	lw	a5,4(s1)
    80002daa:	0047d79b          	srliw	a5,a5,0x4
    80002dae:	00237597          	auipc	a1,0x237
    80002db2:	7da5a583          	lw	a1,2010(a1) # 8023a588 <sb+0x18>
    80002db6:	9dbd                	addw	a1,a1,a5
    80002db8:	4088                	lw	a0,0(s1)
    80002dba:	fffff097          	auipc	ra,0xfffff
    80002dbe:	7b4080e7          	jalr	1972(ra) # 8000256e <bread>
    80002dc2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002dc4:	05850593          	addi	a1,a0,88
    80002dc8:	40dc                	lw	a5,4(s1)
    80002dca:	8bbd                	andi	a5,a5,15
    80002dcc:	079a                	slli	a5,a5,0x6
    80002dce:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002dd0:	00059783          	lh	a5,0(a1)
    80002dd4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002dd8:	00259783          	lh	a5,2(a1)
    80002ddc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002de0:	00459783          	lh	a5,4(a1)
    80002de4:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002de8:	00659783          	lh	a5,6(a1)
    80002dec:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002df0:	459c                	lw	a5,8(a1)
    80002df2:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002df4:	03400613          	li	a2,52
    80002df8:	05b1                	addi	a1,a1,12
    80002dfa:	05048513          	addi	a0,s1,80
    80002dfe:	ffffd097          	auipc	ra,0xffffd
    80002e02:	48e080e7          	jalr	1166(ra) # 8000028c <memmove>
    brelse(bp);
    80002e06:	854a                	mv	a0,s2
    80002e08:	00000097          	auipc	ra,0x0
    80002e0c:	896080e7          	jalr	-1898(ra) # 8000269e <brelse>
    ip->valid = 1;
    80002e10:	4785                	li	a5,1
    80002e12:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002e14:	04449783          	lh	a5,68(s1)
    80002e18:	c399                	beqz	a5,80002e1e <ilock+0xb6>
    80002e1a:	6902                	ld	s2,0(sp)
    80002e1c:	b7bd                	j	80002d8a <ilock+0x22>
      panic("ilock: no type");
    80002e1e:	00005517          	auipc	a0,0x5
    80002e22:	64250513          	addi	a0,a0,1602 # 80008460 <etext+0x460>
    80002e26:	00003097          	auipc	ra,0x3
    80002e2a:	0b6080e7          	jalr	182(ra) # 80005edc <panic>

0000000080002e2e <iunlock>:
{
    80002e2e:	1101                	addi	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	e426                	sd	s1,8(sp)
    80002e36:	e04a                	sd	s2,0(sp)
    80002e38:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002e3a:	c905                	beqz	a0,80002e6a <iunlock+0x3c>
    80002e3c:	84aa                	mv	s1,a0
    80002e3e:	01050913          	addi	s2,a0,16
    80002e42:	854a                	mv	a0,s2
    80002e44:	00001097          	auipc	ra,0x1
    80002e48:	c86080e7          	jalr	-890(ra) # 80003aca <holdingsleep>
    80002e4c:	cd19                	beqz	a0,80002e6a <iunlock+0x3c>
    80002e4e:	449c                	lw	a5,8(s1)
    80002e50:	00f05d63          	blez	a5,80002e6a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002e54:	854a                	mv	a0,s2
    80002e56:	00001097          	auipc	ra,0x1
    80002e5a:	c30080e7          	jalr	-976(ra) # 80003a86 <releasesleep>
}
    80002e5e:	60e2                	ld	ra,24(sp)
    80002e60:	6442                	ld	s0,16(sp)
    80002e62:	64a2                	ld	s1,8(sp)
    80002e64:	6902                	ld	s2,0(sp)
    80002e66:	6105                	addi	sp,sp,32
    80002e68:	8082                	ret
    panic("iunlock");
    80002e6a:	00005517          	auipc	a0,0x5
    80002e6e:	60650513          	addi	a0,a0,1542 # 80008470 <etext+0x470>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	06a080e7          	jalr	106(ra) # 80005edc <panic>

0000000080002e7a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002e7a:	7179                	addi	sp,sp,-48
    80002e7c:	f406                	sd	ra,40(sp)
    80002e7e:	f022                	sd	s0,32(sp)
    80002e80:	ec26                	sd	s1,24(sp)
    80002e82:	e84a                	sd	s2,16(sp)
    80002e84:	e44e                	sd	s3,8(sp)
    80002e86:	1800                	addi	s0,sp,48
    80002e88:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002e8a:	05050493          	addi	s1,a0,80
    80002e8e:	08050913          	addi	s2,a0,128
    80002e92:	a021                	j	80002e9a <itrunc+0x20>
    80002e94:	0491                	addi	s1,s1,4
    80002e96:	01248d63          	beq	s1,s2,80002eb0 <itrunc+0x36>
    if(ip->addrs[i]){
    80002e9a:	408c                	lw	a1,0(s1)
    80002e9c:	dde5                	beqz	a1,80002e94 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002e9e:	0009a503          	lw	a0,0(s3)
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	910080e7          	jalr	-1776(ra) # 800027b2 <bfree>
      ip->addrs[i] = 0;
    80002eaa:	0004a023          	sw	zero,0(s1)
    80002eae:	b7dd                	j	80002e94 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002eb0:	0809a583          	lw	a1,128(s3)
    80002eb4:	ed99                	bnez	a1,80002ed2 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002eb6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002eba:	854e                	mv	a0,s3
    80002ebc:	00000097          	auipc	ra,0x0
    80002ec0:	de0080e7          	jalr	-544(ra) # 80002c9c <iupdate>
}
    80002ec4:	70a2                	ld	ra,40(sp)
    80002ec6:	7402                	ld	s0,32(sp)
    80002ec8:	64e2                	ld	s1,24(sp)
    80002eca:	6942                	ld	s2,16(sp)
    80002ecc:	69a2                	ld	s3,8(sp)
    80002ece:	6145                	addi	sp,sp,48
    80002ed0:	8082                	ret
    80002ed2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ed4:	0009a503          	lw	a0,0(s3)
    80002ed8:	fffff097          	auipc	ra,0xfffff
    80002edc:	696080e7          	jalr	1686(ra) # 8000256e <bread>
    80002ee0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002ee2:	05850493          	addi	s1,a0,88
    80002ee6:	45850913          	addi	s2,a0,1112
    80002eea:	a021                	j	80002ef2 <itrunc+0x78>
    80002eec:	0491                	addi	s1,s1,4
    80002eee:	01248b63          	beq	s1,s2,80002f04 <itrunc+0x8a>
      if(a[j])
    80002ef2:	408c                	lw	a1,0(s1)
    80002ef4:	dde5                	beqz	a1,80002eec <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80002ef6:	0009a503          	lw	a0,0(s3)
    80002efa:	00000097          	auipc	ra,0x0
    80002efe:	8b8080e7          	jalr	-1864(ra) # 800027b2 <bfree>
    80002f02:	b7ed                	j	80002eec <itrunc+0x72>
    brelse(bp);
    80002f04:	8552                	mv	a0,s4
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	798080e7          	jalr	1944(ra) # 8000269e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002f0e:	0809a583          	lw	a1,128(s3)
    80002f12:	0009a503          	lw	a0,0(s3)
    80002f16:	00000097          	auipc	ra,0x0
    80002f1a:	89c080e7          	jalr	-1892(ra) # 800027b2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002f1e:	0809a023          	sw	zero,128(s3)
    80002f22:	6a02                	ld	s4,0(sp)
    80002f24:	bf49                	j	80002eb6 <itrunc+0x3c>

0000000080002f26 <iput>:
{
    80002f26:	1101                	addi	sp,sp,-32
    80002f28:	ec06                	sd	ra,24(sp)
    80002f2a:	e822                	sd	s0,16(sp)
    80002f2c:	e426                	sd	s1,8(sp)
    80002f2e:	1000                	addi	s0,sp,32
    80002f30:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002f32:	00237517          	auipc	a0,0x237
    80002f36:	65e50513          	addi	a0,a0,1630 # 8023a590 <itable>
    80002f3a:	00003097          	auipc	ra,0x3
    80002f3e:	51c080e7          	jalr	1308(ra) # 80006456 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f42:	4498                	lw	a4,8(s1)
    80002f44:	4785                	li	a5,1
    80002f46:	02f70263          	beq	a4,a5,80002f6a <iput+0x44>
  ip->ref--;
    80002f4a:	449c                	lw	a5,8(s1)
    80002f4c:	37fd                	addiw	a5,a5,-1
    80002f4e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002f50:	00237517          	auipc	a0,0x237
    80002f54:	64050513          	addi	a0,a0,1600 # 8023a590 <itable>
    80002f58:	00003097          	auipc	ra,0x3
    80002f5c:	5b2080e7          	jalr	1458(ra) # 8000650a <release>
}
    80002f60:	60e2                	ld	ra,24(sp)
    80002f62:	6442                	ld	s0,16(sp)
    80002f64:	64a2                	ld	s1,8(sp)
    80002f66:	6105                	addi	sp,sp,32
    80002f68:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002f6a:	40bc                	lw	a5,64(s1)
    80002f6c:	dff9                	beqz	a5,80002f4a <iput+0x24>
    80002f6e:	04a49783          	lh	a5,74(s1)
    80002f72:	ffe1                	bnez	a5,80002f4a <iput+0x24>
    80002f74:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002f76:	01048913          	addi	s2,s1,16
    80002f7a:	854a                	mv	a0,s2
    80002f7c:	00001097          	auipc	ra,0x1
    80002f80:	ab4080e7          	jalr	-1356(ra) # 80003a30 <acquiresleep>
    release(&itable.lock);
    80002f84:	00237517          	auipc	a0,0x237
    80002f88:	60c50513          	addi	a0,a0,1548 # 8023a590 <itable>
    80002f8c:	00003097          	auipc	ra,0x3
    80002f90:	57e080e7          	jalr	1406(ra) # 8000650a <release>
    itrunc(ip);
    80002f94:	8526                	mv	a0,s1
    80002f96:	00000097          	auipc	ra,0x0
    80002f9a:	ee4080e7          	jalr	-284(ra) # 80002e7a <itrunc>
    ip->type = 0;
    80002f9e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002fa2:	8526                	mv	a0,s1
    80002fa4:	00000097          	auipc	ra,0x0
    80002fa8:	cf8080e7          	jalr	-776(ra) # 80002c9c <iupdate>
    ip->valid = 0;
    80002fac:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002fb0:	854a                	mv	a0,s2
    80002fb2:	00001097          	auipc	ra,0x1
    80002fb6:	ad4080e7          	jalr	-1324(ra) # 80003a86 <releasesleep>
    acquire(&itable.lock);
    80002fba:	00237517          	auipc	a0,0x237
    80002fbe:	5d650513          	addi	a0,a0,1494 # 8023a590 <itable>
    80002fc2:	00003097          	auipc	ra,0x3
    80002fc6:	494080e7          	jalr	1172(ra) # 80006456 <acquire>
    80002fca:	6902                	ld	s2,0(sp)
    80002fcc:	bfbd                	j	80002f4a <iput+0x24>

0000000080002fce <iunlockput>:
{
    80002fce:	1101                	addi	sp,sp,-32
    80002fd0:	ec06                	sd	ra,24(sp)
    80002fd2:	e822                	sd	s0,16(sp)
    80002fd4:	e426                	sd	s1,8(sp)
    80002fd6:	1000                	addi	s0,sp,32
    80002fd8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002fda:	00000097          	auipc	ra,0x0
    80002fde:	e54080e7          	jalr	-428(ra) # 80002e2e <iunlock>
  iput(ip);
    80002fe2:	8526                	mv	a0,s1
    80002fe4:	00000097          	auipc	ra,0x0
    80002fe8:	f42080e7          	jalr	-190(ra) # 80002f26 <iput>
}
    80002fec:	60e2                	ld	ra,24(sp)
    80002fee:	6442                	ld	s0,16(sp)
    80002ff0:	64a2                	ld	s1,8(sp)
    80002ff2:	6105                	addi	sp,sp,32
    80002ff4:	8082                	ret

0000000080002ff6 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ff6:	1141                	addi	sp,sp,-16
    80002ff8:	e422                	sd	s0,8(sp)
    80002ffa:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ffc:	411c                	lw	a5,0(a0)
    80002ffe:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003000:	415c                	lw	a5,4(a0)
    80003002:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003004:	04451783          	lh	a5,68(a0)
    80003008:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000300c:	04a51783          	lh	a5,74(a0)
    80003010:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003014:	04c56783          	lwu	a5,76(a0)
    80003018:	e99c                	sd	a5,16(a1)
}
    8000301a:	6422                	ld	s0,8(sp)
    8000301c:	0141                	addi	sp,sp,16
    8000301e:	8082                	ret

0000000080003020 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003020:	457c                	lw	a5,76(a0)
    80003022:	0ed7ef63          	bltu	a5,a3,80003120 <readi+0x100>
{
    80003026:	7159                	addi	sp,sp,-112
    80003028:	f486                	sd	ra,104(sp)
    8000302a:	f0a2                	sd	s0,96(sp)
    8000302c:	eca6                	sd	s1,88(sp)
    8000302e:	fc56                	sd	s5,56(sp)
    80003030:	f85a                	sd	s6,48(sp)
    80003032:	f45e                	sd	s7,40(sp)
    80003034:	f062                	sd	s8,32(sp)
    80003036:	1880                	addi	s0,sp,112
    80003038:	8baa                	mv	s7,a0
    8000303a:	8c2e                	mv	s8,a1
    8000303c:	8ab2                	mv	s5,a2
    8000303e:	84b6                	mv	s1,a3
    80003040:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003042:	9f35                	addw	a4,a4,a3
    return 0;
    80003044:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003046:	0ad76c63          	bltu	a4,a3,800030fe <readi+0xde>
    8000304a:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000304c:	00e7f463          	bgeu	a5,a4,80003054 <readi+0x34>
    n = ip->size - off;
    80003050:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003054:	0c0b0463          	beqz	s6,8000311c <readi+0xfc>
    80003058:	e8ca                	sd	s2,80(sp)
    8000305a:	e0d2                	sd	s4,64(sp)
    8000305c:	ec66                	sd	s9,24(sp)
    8000305e:	e86a                	sd	s10,16(sp)
    80003060:	e46e                	sd	s11,8(sp)
    80003062:	4981                	li	s3,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003064:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003068:	5cfd                	li	s9,-1
    8000306a:	a82d                	j	800030a4 <readi+0x84>
    8000306c:	020a1d93          	slli	s11,s4,0x20
    80003070:	020ddd93          	srli	s11,s11,0x20
    80003074:	05890613          	addi	a2,s2,88
    80003078:	86ee                	mv	a3,s11
    8000307a:	963a                	add	a2,a2,a4
    8000307c:	85d6                	mv	a1,s5
    8000307e:	8562                	mv	a0,s8
    80003080:	fffff097          	auipc	ra,0xfffff
    80003084:	a52080e7          	jalr	-1454(ra) # 80001ad2 <either_copyout>
    80003088:	05950d63          	beq	a0,s9,800030e2 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000308c:	854a                	mv	a0,s2
    8000308e:	fffff097          	auipc	ra,0xfffff
    80003092:	610080e7          	jalr	1552(ra) # 8000269e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003096:	013a09bb          	addw	s3,s4,s3
    8000309a:	009a04bb          	addw	s1,s4,s1
    8000309e:	9aee                	add	s5,s5,s11
    800030a0:	0769f863          	bgeu	s3,s6,80003110 <readi+0xf0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800030a4:	000ba903          	lw	s2,0(s7)
    800030a8:	00a4d59b          	srliw	a1,s1,0xa
    800030ac:	855e                	mv	a0,s7
    800030ae:	00000097          	auipc	ra,0x0
    800030b2:	8ae080e7          	jalr	-1874(ra) # 8000295c <bmap>
    800030b6:	0005059b          	sext.w	a1,a0
    800030ba:	854a                	mv	a0,s2
    800030bc:	fffff097          	auipc	ra,0xfffff
    800030c0:	4b2080e7          	jalr	1202(ra) # 8000256e <bread>
    800030c4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030c6:	3ff4f713          	andi	a4,s1,1023
    800030ca:	40ed07bb          	subw	a5,s10,a4
    800030ce:	413b06bb          	subw	a3,s6,s3
    800030d2:	8a3e                	mv	s4,a5
    800030d4:	2781                	sext.w	a5,a5
    800030d6:	0006861b          	sext.w	a2,a3
    800030da:	f8f679e3          	bgeu	a2,a5,8000306c <readi+0x4c>
    800030de:	8a36                	mv	s4,a3
    800030e0:	b771                	j	8000306c <readi+0x4c>
      brelse(bp);
    800030e2:	854a                	mv	a0,s2
    800030e4:	fffff097          	auipc	ra,0xfffff
    800030e8:	5ba080e7          	jalr	1466(ra) # 8000269e <brelse>
      tot = -1;
    800030ec:	59fd                	li	s3,-1
      break;
    800030ee:	6946                	ld	s2,80(sp)
    800030f0:	6a06                	ld	s4,64(sp)
    800030f2:	6ce2                	ld	s9,24(sp)
    800030f4:	6d42                	ld	s10,16(sp)
    800030f6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030f8:	0009851b          	sext.w	a0,s3
    800030fc:	69a6                	ld	s3,72(sp)
}
    800030fe:	70a6                	ld	ra,104(sp)
    80003100:	7406                	ld	s0,96(sp)
    80003102:	64e6                	ld	s1,88(sp)
    80003104:	7ae2                	ld	s5,56(sp)
    80003106:	7b42                	ld	s6,48(sp)
    80003108:	7ba2                	ld	s7,40(sp)
    8000310a:	7c02                	ld	s8,32(sp)
    8000310c:	6165                	addi	sp,sp,112
    8000310e:	8082                	ret
    80003110:	6946                	ld	s2,80(sp)
    80003112:	6a06                	ld	s4,64(sp)
    80003114:	6ce2                	ld	s9,24(sp)
    80003116:	6d42                	ld	s10,16(sp)
    80003118:	6da2                	ld	s11,8(sp)
    8000311a:	bff9                	j	800030f8 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000311c:	89da                	mv	s3,s6
    8000311e:	bfe9                	j	800030f8 <readi+0xd8>
    return 0;
    80003120:	4501                	li	a0,0
}
    80003122:	8082                	ret

0000000080003124 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003124:	457c                	lw	a5,76(a0)
    80003126:	10d7ee63          	bltu	a5,a3,80003242 <writei+0x11e>
{
    8000312a:	7159                	addi	sp,sp,-112
    8000312c:	f486                	sd	ra,104(sp)
    8000312e:	f0a2                	sd	s0,96(sp)
    80003130:	e8ca                	sd	s2,80(sp)
    80003132:	fc56                	sd	s5,56(sp)
    80003134:	f85a                	sd	s6,48(sp)
    80003136:	f45e                	sd	s7,40(sp)
    80003138:	f062                	sd	s8,32(sp)
    8000313a:	1880                	addi	s0,sp,112
    8000313c:	8b2a                	mv	s6,a0
    8000313e:	8c2e                	mv	s8,a1
    80003140:	8ab2                	mv	s5,a2
    80003142:	8936                	mv	s2,a3
    80003144:	8bba                	mv	s7,a4
  if(off > ip->size || off + n < off)
    80003146:	00e687bb          	addw	a5,a3,a4
    8000314a:	0ed7ee63          	bltu	a5,a3,80003246 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000314e:	00043737          	lui	a4,0x43
    80003152:	0ef76c63          	bltu	a4,a5,8000324a <writei+0x126>
    80003156:	e0d2                	sd	s4,64(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003158:	0c0b8d63          	beqz	s7,80003232 <writei+0x10e>
    8000315c:	eca6                	sd	s1,88(sp)
    8000315e:	e4ce                	sd	s3,72(sp)
    80003160:	ec66                	sd	s9,24(sp)
    80003162:	e86a                	sd	s10,16(sp)
    80003164:	e46e                	sd	s11,8(sp)
    80003166:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003168:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000316c:	5cfd                	li	s9,-1
    8000316e:	a091                	j	800031b2 <writei+0x8e>
    80003170:	02099d93          	slli	s11,s3,0x20
    80003174:	020ddd93          	srli	s11,s11,0x20
    80003178:	05848513          	addi	a0,s1,88
    8000317c:	86ee                	mv	a3,s11
    8000317e:	8656                	mv	a2,s5
    80003180:	85e2                	mv	a1,s8
    80003182:	953a                	add	a0,a0,a4
    80003184:	fffff097          	auipc	ra,0xfffff
    80003188:	9a4080e7          	jalr	-1628(ra) # 80001b28 <either_copyin>
    8000318c:	07950263          	beq	a0,s9,800031f0 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003190:	8526                	mv	a0,s1
    80003192:	00000097          	auipc	ra,0x0
    80003196:	780080e7          	jalr	1920(ra) # 80003912 <log_write>
    brelse(bp);
    8000319a:	8526                	mv	a0,s1
    8000319c:	fffff097          	auipc	ra,0xfffff
    800031a0:	502080e7          	jalr	1282(ra) # 8000269e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031a4:	01498a3b          	addw	s4,s3,s4
    800031a8:	0129893b          	addw	s2,s3,s2
    800031ac:	9aee                	add	s5,s5,s11
    800031ae:	057a7663          	bgeu	s4,s7,800031fa <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    800031b2:	000b2483          	lw	s1,0(s6)
    800031b6:	00a9559b          	srliw	a1,s2,0xa
    800031ba:	855a                	mv	a0,s6
    800031bc:	fffff097          	auipc	ra,0xfffff
    800031c0:	7a0080e7          	jalr	1952(ra) # 8000295c <bmap>
    800031c4:	0005059b          	sext.w	a1,a0
    800031c8:	8526                	mv	a0,s1
    800031ca:	fffff097          	auipc	ra,0xfffff
    800031ce:	3a4080e7          	jalr	932(ra) # 8000256e <bread>
    800031d2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031d4:	3ff97713          	andi	a4,s2,1023
    800031d8:	40ed07bb          	subw	a5,s10,a4
    800031dc:	414b86bb          	subw	a3,s7,s4
    800031e0:	89be                	mv	s3,a5
    800031e2:	2781                	sext.w	a5,a5
    800031e4:	0006861b          	sext.w	a2,a3
    800031e8:	f8f674e3          	bgeu	a2,a5,80003170 <writei+0x4c>
    800031ec:	89b6                	mv	s3,a3
    800031ee:	b749                	j	80003170 <writei+0x4c>
      brelse(bp);
    800031f0:	8526                	mv	a0,s1
    800031f2:	fffff097          	auipc	ra,0xfffff
    800031f6:	4ac080e7          	jalr	1196(ra) # 8000269e <brelse>
  }

  if(off > ip->size)
    800031fa:	04cb2783          	lw	a5,76(s6)
    800031fe:	0327fc63          	bgeu	a5,s2,80003236 <writei+0x112>
    ip->size = off;
    80003202:	052b2623          	sw	s2,76(s6)
    80003206:	64e6                	ld	s1,88(sp)
    80003208:	69a6                	ld	s3,72(sp)
    8000320a:	6ce2                	ld	s9,24(sp)
    8000320c:	6d42                	ld	s10,16(sp)
    8000320e:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003210:	855a                	mv	a0,s6
    80003212:	00000097          	auipc	ra,0x0
    80003216:	a8a080e7          	jalr	-1398(ra) # 80002c9c <iupdate>

  return tot;
    8000321a:	000a051b          	sext.w	a0,s4
    8000321e:	6a06                	ld	s4,64(sp)
}
    80003220:	70a6                	ld	ra,104(sp)
    80003222:	7406                	ld	s0,96(sp)
    80003224:	6946                	ld	s2,80(sp)
    80003226:	7ae2                	ld	s5,56(sp)
    80003228:	7b42                	ld	s6,48(sp)
    8000322a:	7ba2                	ld	s7,40(sp)
    8000322c:	7c02                	ld	s8,32(sp)
    8000322e:	6165                	addi	sp,sp,112
    80003230:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003232:	8a5e                	mv	s4,s7
    80003234:	bff1                	j	80003210 <writei+0xec>
    80003236:	64e6                	ld	s1,88(sp)
    80003238:	69a6                	ld	s3,72(sp)
    8000323a:	6ce2                	ld	s9,24(sp)
    8000323c:	6d42                	ld	s10,16(sp)
    8000323e:	6da2                	ld	s11,8(sp)
    80003240:	bfc1                	j	80003210 <writei+0xec>
    return -1;
    80003242:	557d                	li	a0,-1
}
    80003244:	8082                	ret
    return -1;
    80003246:	557d                	li	a0,-1
    80003248:	bfe1                	j	80003220 <writei+0xfc>
    return -1;
    8000324a:	557d                	li	a0,-1
    8000324c:	bfd1                	j	80003220 <writei+0xfc>

000000008000324e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000324e:	1141                	addi	sp,sp,-16
    80003250:	e406                	sd	ra,8(sp)
    80003252:	e022                	sd	s0,0(sp)
    80003254:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003256:	4639                	li	a2,14
    80003258:	ffffd097          	auipc	ra,0xffffd
    8000325c:	0a8080e7          	jalr	168(ra) # 80000300 <strncmp>
}
    80003260:	60a2                	ld	ra,8(sp)
    80003262:	6402                	ld	s0,0(sp)
    80003264:	0141                	addi	sp,sp,16
    80003266:	8082                	ret

0000000080003268 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003268:	7139                	addi	sp,sp,-64
    8000326a:	fc06                	sd	ra,56(sp)
    8000326c:	f822                	sd	s0,48(sp)
    8000326e:	f426                	sd	s1,40(sp)
    80003270:	f04a                	sd	s2,32(sp)
    80003272:	ec4e                	sd	s3,24(sp)
    80003274:	e852                	sd	s4,16(sp)
    80003276:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003278:	04451703          	lh	a4,68(a0)
    8000327c:	4785                	li	a5,1
    8000327e:	00f71a63          	bne	a4,a5,80003292 <dirlookup+0x2a>
    80003282:	892a                	mv	s2,a0
    80003284:	89ae                	mv	s3,a1
    80003286:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003288:	457c                	lw	a5,76(a0)
    8000328a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000328c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000328e:	e79d                	bnez	a5,800032bc <dirlookup+0x54>
    80003290:	a8a5                	j	80003308 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003292:	00005517          	auipc	a0,0x5
    80003296:	1e650513          	addi	a0,a0,486 # 80008478 <etext+0x478>
    8000329a:	00003097          	auipc	ra,0x3
    8000329e:	c42080e7          	jalr	-958(ra) # 80005edc <panic>
      panic("dirlookup read");
    800032a2:	00005517          	auipc	a0,0x5
    800032a6:	1ee50513          	addi	a0,a0,494 # 80008490 <etext+0x490>
    800032aa:	00003097          	auipc	ra,0x3
    800032ae:	c32080e7          	jalr	-974(ra) # 80005edc <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032b2:	24c1                	addiw	s1,s1,16
    800032b4:	04c92783          	lw	a5,76(s2)
    800032b8:	04f4f763          	bgeu	s1,a5,80003306 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032bc:	4741                	li	a4,16
    800032be:	86a6                	mv	a3,s1
    800032c0:	fc040613          	addi	a2,s0,-64
    800032c4:	4581                	li	a1,0
    800032c6:	854a                	mv	a0,s2
    800032c8:	00000097          	auipc	ra,0x0
    800032cc:	d58080e7          	jalr	-680(ra) # 80003020 <readi>
    800032d0:	47c1                	li	a5,16
    800032d2:	fcf518e3          	bne	a0,a5,800032a2 <dirlookup+0x3a>
    if(de.inum == 0)
    800032d6:	fc045783          	lhu	a5,-64(s0)
    800032da:	dfe1                	beqz	a5,800032b2 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    800032dc:	fc240593          	addi	a1,s0,-62
    800032e0:	854e                	mv	a0,s3
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	f6c080e7          	jalr	-148(ra) # 8000324e <namecmp>
    800032ea:	f561                	bnez	a0,800032b2 <dirlookup+0x4a>
      if(poff)
    800032ec:	000a0463          	beqz	s4,800032f4 <dirlookup+0x8c>
        *poff = off;
    800032f0:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800032f4:	fc045583          	lhu	a1,-64(s0)
    800032f8:	00092503          	lw	a0,0(s2)
    800032fc:	fffff097          	auipc	ra,0xfffff
    80003300:	73c080e7          	jalr	1852(ra) # 80002a38 <iget>
    80003304:	a011                	j	80003308 <dirlookup+0xa0>
  return 0;
    80003306:	4501                	li	a0,0
}
    80003308:	70e2                	ld	ra,56(sp)
    8000330a:	7442                	ld	s0,48(sp)
    8000330c:	74a2                	ld	s1,40(sp)
    8000330e:	7902                	ld	s2,32(sp)
    80003310:	69e2                	ld	s3,24(sp)
    80003312:	6a42                	ld	s4,16(sp)
    80003314:	6121                	addi	sp,sp,64
    80003316:	8082                	ret

0000000080003318 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003318:	711d                	addi	sp,sp,-96
    8000331a:	ec86                	sd	ra,88(sp)
    8000331c:	e8a2                	sd	s0,80(sp)
    8000331e:	e4a6                	sd	s1,72(sp)
    80003320:	e0ca                	sd	s2,64(sp)
    80003322:	fc4e                	sd	s3,56(sp)
    80003324:	f852                	sd	s4,48(sp)
    80003326:	f456                	sd	s5,40(sp)
    80003328:	f05a                	sd	s6,32(sp)
    8000332a:	ec5e                	sd	s7,24(sp)
    8000332c:	e862                	sd	s8,16(sp)
    8000332e:	e466                	sd	s9,8(sp)
    80003330:	1080                	addi	s0,sp,96
    80003332:	84aa                	mv	s1,a0
    80003334:	8b2e                	mv	s6,a1
    80003336:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003338:	00054703          	lbu	a4,0(a0)
    8000333c:	02f00793          	li	a5,47
    80003340:	02f70263          	beq	a4,a5,80003364 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003344:	ffffe097          	auipc	ra,0xffffe
    80003348:	d24080e7          	jalr	-732(ra) # 80001068 <myproc>
    8000334c:	15053503          	ld	a0,336(a0)
    80003350:	00000097          	auipc	ra,0x0
    80003354:	9da080e7          	jalr	-1574(ra) # 80002d2a <idup>
    80003358:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000335a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000335e:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003360:	4b85                	li	s7,1
    80003362:	a875                	j	8000341e <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80003364:	4585                	li	a1,1
    80003366:	4505                	li	a0,1
    80003368:	fffff097          	auipc	ra,0xfffff
    8000336c:	6d0080e7          	jalr	1744(ra) # 80002a38 <iget>
    80003370:	8a2a                	mv	s4,a0
    80003372:	b7e5                	j	8000335a <namex+0x42>
      iunlockput(ip);
    80003374:	8552                	mv	a0,s4
    80003376:	00000097          	auipc	ra,0x0
    8000337a:	c58080e7          	jalr	-936(ra) # 80002fce <iunlockput>
      return 0;
    8000337e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003380:	8552                	mv	a0,s4
    80003382:	60e6                	ld	ra,88(sp)
    80003384:	6446                	ld	s0,80(sp)
    80003386:	64a6                	ld	s1,72(sp)
    80003388:	6906                	ld	s2,64(sp)
    8000338a:	79e2                	ld	s3,56(sp)
    8000338c:	7a42                	ld	s4,48(sp)
    8000338e:	7aa2                	ld	s5,40(sp)
    80003390:	7b02                	ld	s6,32(sp)
    80003392:	6be2                	ld	s7,24(sp)
    80003394:	6c42                	ld	s8,16(sp)
    80003396:	6ca2                	ld	s9,8(sp)
    80003398:	6125                	addi	sp,sp,96
    8000339a:	8082                	ret
      iunlock(ip);
    8000339c:	8552                	mv	a0,s4
    8000339e:	00000097          	auipc	ra,0x0
    800033a2:	a90080e7          	jalr	-1392(ra) # 80002e2e <iunlock>
      return ip;
    800033a6:	bfe9                	j	80003380 <namex+0x68>
      iunlockput(ip);
    800033a8:	8552                	mv	a0,s4
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	c24080e7          	jalr	-988(ra) # 80002fce <iunlockput>
      return 0;
    800033b2:	8a4e                	mv	s4,s3
    800033b4:	b7f1                	j	80003380 <namex+0x68>
  len = path - s;
    800033b6:	40998633          	sub	a2,s3,s1
    800033ba:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    800033be:	099c5863          	bge	s8,s9,8000344e <namex+0x136>
    memmove(name, s, DIRSIZ);
    800033c2:	4639                	li	a2,14
    800033c4:	85a6                	mv	a1,s1
    800033c6:	8556                	mv	a0,s5
    800033c8:	ffffd097          	auipc	ra,0xffffd
    800033cc:	ec4080e7          	jalr	-316(ra) # 8000028c <memmove>
    800033d0:	84ce                	mv	s1,s3
  while(*path == '/')
    800033d2:	0004c783          	lbu	a5,0(s1)
    800033d6:	01279763          	bne	a5,s2,800033e4 <namex+0xcc>
    path++;
    800033da:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033dc:	0004c783          	lbu	a5,0(s1)
    800033e0:	ff278de3          	beq	a5,s2,800033da <namex+0xc2>
    ilock(ip);
    800033e4:	8552                	mv	a0,s4
    800033e6:	00000097          	auipc	ra,0x0
    800033ea:	982080e7          	jalr	-1662(ra) # 80002d68 <ilock>
    if(ip->type != T_DIR){
    800033ee:	044a1783          	lh	a5,68(s4)
    800033f2:	f97791e3          	bne	a5,s7,80003374 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800033f6:	000b0563          	beqz	s6,80003400 <namex+0xe8>
    800033fa:	0004c783          	lbu	a5,0(s1)
    800033fe:	dfd9                	beqz	a5,8000339c <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003400:	4601                	li	a2,0
    80003402:	85d6                	mv	a1,s5
    80003404:	8552                	mv	a0,s4
    80003406:	00000097          	auipc	ra,0x0
    8000340a:	e62080e7          	jalr	-414(ra) # 80003268 <dirlookup>
    8000340e:	89aa                	mv	s3,a0
    80003410:	dd41                	beqz	a0,800033a8 <namex+0x90>
    iunlockput(ip);
    80003412:	8552                	mv	a0,s4
    80003414:	00000097          	auipc	ra,0x0
    80003418:	bba080e7          	jalr	-1094(ra) # 80002fce <iunlockput>
    ip = next;
    8000341c:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000341e:	0004c783          	lbu	a5,0(s1)
    80003422:	01279763          	bne	a5,s2,80003430 <namex+0x118>
    path++;
    80003426:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003428:	0004c783          	lbu	a5,0(s1)
    8000342c:	ff278de3          	beq	a5,s2,80003426 <namex+0x10e>
  if(*path == 0)
    80003430:	cb9d                	beqz	a5,80003466 <namex+0x14e>
  while(*path != '/' && *path != 0)
    80003432:	0004c783          	lbu	a5,0(s1)
    80003436:	89a6                	mv	s3,s1
  len = path - s;
    80003438:	4c81                	li	s9,0
    8000343a:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000343c:	01278963          	beq	a5,s2,8000344e <namex+0x136>
    80003440:	dbbd                	beqz	a5,800033b6 <namex+0x9e>
    path++;
    80003442:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003444:	0009c783          	lbu	a5,0(s3)
    80003448:	ff279ce3          	bne	a5,s2,80003440 <namex+0x128>
    8000344c:	b7ad                	j	800033b6 <namex+0x9e>
    memmove(name, s, len);
    8000344e:	2601                	sext.w	a2,a2
    80003450:	85a6                	mv	a1,s1
    80003452:	8556                	mv	a0,s5
    80003454:	ffffd097          	auipc	ra,0xffffd
    80003458:	e38080e7          	jalr	-456(ra) # 8000028c <memmove>
    name[len] = 0;
    8000345c:	9cd6                	add	s9,s9,s5
    8000345e:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003462:	84ce                	mv	s1,s3
    80003464:	b7bd                	j	800033d2 <namex+0xba>
  if(nameiparent){
    80003466:	f00b0de3          	beqz	s6,80003380 <namex+0x68>
    iput(ip);
    8000346a:	8552                	mv	a0,s4
    8000346c:	00000097          	auipc	ra,0x0
    80003470:	aba080e7          	jalr	-1350(ra) # 80002f26 <iput>
    return 0;
    80003474:	4a01                	li	s4,0
    80003476:	b729                	j	80003380 <namex+0x68>

0000000080003478 <dirlink>:
{
    80003478:	7139                	addi	sp,sp,-64
    8000347a:	fc06                	sd	ra,56(sp)
    8000347c:	f822                	sd	s0,48(sp)
    8000347e:	f04a                	sd	s2,32(sp)
    80003480:	ec4e                	sd	s3,24(sp)
    80003482:	e852                	sd	s4,16(sp)
    80003484:	0080                	addi	s0,sp,64
    80003486:	892a                	mv	s2,a0
    80003488:	8a2e                	mv	s4,a1
    8000348a:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000348c:	4601                	li	a2,0
    8000348e:	00000097          	auipc	ra,0x0
    80003492:	dda080e7          	jalr	-550(ra) # 80003268 <dirlookup>
    80003496:	ed25                	bnez	a0,8000350e <dirlink+0x96>
    80003498:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000349a:	04c92483          	lw	s1,76(s2)
    8000349e:	c49d                	beqz	s1,800034cc <dirlink+0x54>
    800034a0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034a2:	4741                	li	a4,16
    800034a4:	86a6                	mv	a3,s1
    800034a6:	fc040613          	addi	a2,s0,-64
    800034aa:	4581                	li	a1,0
    800034ac:	854a                	mv	a0,s2
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	b72080e7          	jalr	-1166(ra) # 80003020 <readi>
    800034b6:	47c1                	li	a5,16
    800034b8:	06f51163          	bne	a0,a5,8000351a <dirlink+0xa2>
    if(de.inum == 0)
    800034bc:	fc045783          	lhu	a5,-64(s0)
    800034c0:	c791                	beqz	a5,800034cc <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800034c2:	24c1                	addiw	s1,s1,16
    800034c4:	04c92783          	lw	a5,76(s2)
    800034c8:	fcf4ede3          	bltu	s1,a5,800034a2 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    800034cc:	4639                	li	a2,14
    800034ce:	85d2                	mv	a1,s4
    800034d0:	fc240513          	addi	a0,s0,-62
    800034d4:	ffffd097          	auipc	ra,0xffffd
    800034d8:	e62080e7          	jalr	-414(ra) # 80000336 <strncpy>
  de.inum = inum;
    800034dc:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034e0:	4741                	li	a4,16
    800034e2:	86a6                	mv	a3,s1
    800034e4:	fc040613          	addi	a2,s0,-64
    800034e8:	4581                	li	a1,0
    800034ea:	854a                	mv	a0,s2
    800034ec:	00000097          	auipc	ra,0x0
    800034f0:	c38080e7          	jalr	-968(ra) # 80003124 <writei>
    800034f4:	872a                	mv	a4,a0
    800034f6:	47c1                	li	a5,16
  return 0;
    800034f8:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034fa:	02f71863          	bne	a4,a5,8000352a <dirlink+0xb2>
    800034fe:	74a2                	ld	s1,40(sp)
}
    80003500:	70e2                	ld	ra,56(sp)
    80003502:	7442                	ld	s0,48(sp)
    80003504:	7902                	ld	s2,32(sp)
    80003506:	69e2                	ld	s3,24(sp)
    80003508:	6a42                	ld	s4,16(sp)
    8000350a:	6121                	addi	sp,sp,64
    8000350c:	8082                	ret
    iput(ip);
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	a18080e7          	jalr	-1512(ra) # 80002f26 <iput>
    return -1;
    80003516:	557d                	li	a0,-1
    80003518:	b7e5                	j	80003500 <dirlink+0x88>
      panic("dirlink read");
    8000351a:	00005517          	auipc	a0,0x5
    8000351e:	f8650513          	addi	a0,a0,-122 # 800084a0 <etext+0x4a0>
    80003522:	00003097          	auipc	ra,0x3
    80003526:	9ba080e7          	jalr	-1606(ra) # 80005edc <panic>
    panic("dirlink");
    8000352a:	00005517          	auipc	a0,0x5
    8000352e:	08650513          	addi	a0,a0,134 # 800085b0 <etext+0x5b0>
    80003532:	00003097          	auipc	ra,0x3
    80003536:	9aa080e7          	jalr	-1622(ra) # 80005edc <panic>

000000008000353a <namei>:

struct inode*
namei(char *path)
{
    8000353a:	1101                	addi	sp,sp,-32
    8000353c:	ec06                	sd	ra,24(sp)
    8000353e:	e822                	sd	s0,16(sp)
    80003540:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003542:	fe040613          	addi	a2,s0,-32
    80003546:	4581                	li	a1,0
    80003548:	00000097          	auipc	ra,0x0
    8000354c:	dd0080e7          	jalr	-560(ra) # 80003318 <namex>
}
    80003550:	60e2                	ld	ra,24(sp)
    80003552:	6442                	ld	s0,16(sp)
    80003554:	6105                	addi	sp,sp,32
    80003556:	8082                	ret

0000000080003558 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003558:	1141                	addi	sp,sp,-16
    8000355a:	e406                	sd	ra,8(sp)
    8000355c:	e022                	sd	s0,0(sp)
    8000355e:	0800                	addi	s0,sp,16
    80003560:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003562:	4585                	li	a1,1
    80003564:	00000097          	auipc	ra,0x0
    80003568:	db4080e7          	jalr	-588(ra) # 80003318 <namex>
}
    8000356c:	60a2                	ld	ra,8(sp)
    8000356e:	6402                	ld	s0,0(sp)
    80003570:	0141                	addi	sp,sp,16
    80003572:	8082                	ret

0000000080003574 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003574:	1101                	addi	sp,sp,-32
    80003576:	ec06                	sd	ra,24(sp)
    80003578:	e822                	sd	s0,16(sp)
    8000357a:	e426                	sd	s1,8(sp)
    8000357c:	e04a                	sd	s2,0(sp)
    8000357e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003580:	00239917          	auipc	s2,0x239
    80003584:	ab890913          	addi	s2,s2,-1352 # 8023c038 <log>
    80003588:	01892583          	lw	a1,24(s2)
    8000358c:	02892503          	lw	a0,40(s2)
    80003590:	fffff097          	auipc	ra,0xfffff
    80003594:	fde080e7          	jalr	-34(ra) # 8000256e <bread>
    80003598:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000359a:	02c92603          	lw	a2,44(s2)
    8000359e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800035a0:	00c05f63          	blez	a2,800035be <write_head+0x4a>
    800035a4:	00239717          	auipc	a4,0x239
    800035a8:	ac470713          	addi	a4,a4,-1340 # 8023c068 <log+0x30>
    800035ac:	87aa                	mv	a5,a0
    800035ae:	060a                	slli	a2,a2,0x2
    800035b0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800035b2:	4314                	lw	a3,0(a4)
    800035b4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800035b6:	0711                	addi	a4,a4,4
    800035b8:	0791                	addi	a5,a5,4
    800035ba:	fec79ce3          	bne	a5,a2,800035b2 <write_head+0x3e>
  }
  bwrite(buf);
    800035be:	8526                	mv	a0,s1
    800035c0:	fffff097          	auipc	ra,0xfffff
    800035c4:	0a0080e7          	jalr	160(ra) # 80002660 <bwrite>
  brelse(buf);
    800035c8:	8526                	mv	a0,s1
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	0d4080e7          	jalr	212(ra) # 8000269e <brelse>
}
    800035d2:	60e2                	ld	ra,24(sp)
    800035d4:	6442                	ld	s0,16(sp)
    800035d6:	64a2                	ld	s1,8(sp)
    800035d8:	6902                	ld	s2,0(sp)
    800035da:	6105                	addi	sp,sp,32
    800035dc:	8082                	ret

00000000800035de <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800035de:	00239797          	auipc	a5,0x239
    800035e2:	a867a783          	lw	a5,-1402(a5) # 8023c064 <log+0x2c>
    800035e6:	0af05d63          	blez	a5,800036a0 <install_trans+0xc2>
{
    800035ea:	7139                	addi	sp,sp,-64
    800035ec:	fc06                	sd	ra,56(sp)
    800035ee:	f822                	sd	s0,48(sp)
    800035f0:	f426                	sd	s1,40(sp)
    800035f2:	f04a                	sd	s2,32(sp)
    800035f4:	ec4e                	sd	s3,24(sp)
    800035f6:	e852                	sd	s4,16(sp)
    800035f8:	e456                	sd	s5,8(sp)
    800035fa:	e05a                	sd	s6,0(sp)
    800035fc:	0080                	addi	s0,sp,64
    800035fe:	8b2a                	mv	s6,a0
    80003600:	00239a97          	auipc	s5,0x239
    80003604:	a68a8a93          	addi	s5,s5,-1432 # 8023c068 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003608:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000360a:	00239997          	auipc	s3,0x239
    8000360e:	a2e98993          	addi	s3,s3,-1490 # 8023c038 <log>
    80003612:	a00d                	j	80003634 <install_trans+0x56>
    brelse(lbuf);
    80003614:	854a                	mv	a0,s2
    80003616:	fffff097          	auipc	ra,0xfffff
    8000361a:	088080e7          	jalr	136(ra) # 8000269e <brelse>
    brelse(dbuf);
    8000361e:	8526                	mv	a0,s1
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	07e080e7          	jalr	126(ra) # 8000269e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003628:	2a05                	addiw	s4,s4,1
    8000362a:	0a91                	addi	s5,s5,4
    8000362c:	02c9a783          	lw	a5,44(s3)
    80003630:	04fa5e63          	bge	s4,a5,8000368c <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003634:	0189a583          	lw	a1,24(s3)
    80003638:	014585bb          	addw	a1,a1,s4
    8000363c:	2585                	addiw	a1,a1,1
    8000363e:	0289a503          	lw	a0,40(s3)
    80003642:	fffff097          	auipc	ra,0xfffff
    80003646:	f2c080e7          	jalr	-212(ra) # 8000256e <bread>
    8000364a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000364c:	000aa583          	lw	a1,0(s5)
    80003650:	0289a503          	lw	a0,40(s3)
    80003654:	fffff097          	auipc	ra,0xfffff
    80003658:	f1a080e7          	jalr	-230(ra) # 8000256e <bread>
    8000365c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000365e:	40000613          	li	a2,1024
    80003662:	05890593          	addi	a1,s2,88
    80003666:	05850513          	addi	a0,a0,88
    8000366a:	ffffd097          	auipc	ra,0xffffd
    8000366e:	c22080e7          	jalr	-990(ra) # 8000028c <memmove>
    bwrite(dbuf);  // write dst to disk
    80003672:	8526                	mv	a0,s1
    80003674:	fffff097          	auipc	ra,0xfffff
    80003678:	fec080e7          	jalr	-20(ra) # 80002660 <bwrite>
    if(recovering == 0)
    8000367c:	f80b1ce3          	bnez	s6,80003614 <install_trans+0x36>
      bunpin(dbuf);
    80003680:	8526                	mv	a0,s1
    80003682:	fffff097          	auipc	ra,0xfffff
    80003686:	0f4080e7          	jalr	244(ra) # 80002776 <bunpin>
    8000368a:	b769                	j	80003614 <install_trans+0x36>
}
    8000368c:	70e2                	ld	ra,56(sp)
    8000368e:	7442                	ld	s0,48(sp)
    80003690:	74a2                	ld	s1,40(sp)
    80003692:	7902                	ld	s2,32(sp)
    80003694:	69e2                	ld	s3,24(sp)
    80003696:	6a42                	ld	s4,16(sp)
    80003698:	6aa2                	ld	s5,8(sp)
    8000369a:	6b02                	ld	s6,0(sp)
    8000369c:	6121                	addi	sp,sp,64
    8000369e:	8082                	ret
    800036a0:	8082                	ret

00000000800036a2 <initlog>:
{
    800036a2:	7179                	addi	sp,sp,-48
    800036a4:	f406                	sd	ra,40(sp)
    800036a6:	f022                	sd	s0,32(sp)
    800036a8:	ec26                	sd	s1,24(sp)
    800036aa:	e84a                	sd	s2,16(sp)
    800036ac:	e44e                	sd	s3,8(sp)
    800036ae:	1800                	addi	s0,sp,48
    800036b0:	892a                	mv	s2,a0
    800036b2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800036b4:	00239497          	auipc	s1,0x239
    800036b8:	98448493          	addi	s1,s1,-1660 # 8023c038 <log>
    800036bc:	00005597          	auipc	a1,0x5
    800036c0:	df458593          	addi	a1,a1,-524 # 800084b0 <etext+0x4b0>
    800036c4:	8526                	mv	a0,s1
    800036c6:	00003097          	auipc	ra,0x3
    800036ca:	d00080e7          	jalr	-768(ra) # 800063c6 <initlock>
  log.start = sb->logstart;
    800036ce:	0149a583          	lw	a1,20(s3)
    800036d2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800036d4:	0109a783          	lw	a5,16(s3)
    800036d8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800036da:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800036de:	854a                	mv	a0,s2
    800036e0:	fffff097          	auipc	ra,0xfffff
    800036e4:	e8e080e7          	jalr	-370(ra) # 8000256e <bread>
  log.lh.n = lh->n;
    800036e8:	4d30                	lw	a2,88(a0)
    800036ea:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800036ec:	00c05f63          	blez	a2,8000370a <initlog+0x68>
    800036f0:	87aa                	mv	a5,a0
    800036f2:	00239717          	auipc	a4,0x239
    800036f6:	97670713          	addi	a4,a4,-1674 # 8023c068 <log+0x30>
    800036fa:	060a                	slli	a2,a2,0x2
    800036fc:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800036fe:	4ff4                	lw	a3,92(a5)
    80003700:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003702:	0791                	addi	a5,a5,4
    80003704:	0711                	addi	a4,a4,4
    80003706:	fec79ce3          	bne	a5,a2,800036fe <initlog+0x5c>
  brelse(buf);
    8000370a:	fffff097          	auipc	ra,0xfffff
    8000370e:	f94080e7          	jalr	-108(ra) # 8000269e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003712:	4505                	li	a0,1
    80003714:	00000097          	auipc	ra,0x0
    80003718:	eca080e7          	jalr	-310(ra) # 800035de <install_trans>
  log.lh.n = 0;
    8000371c:	00239797          	auipc	a5,0x239
    80003720:	9407a423          	sw	zero,-1720(a5) # 8023c064 <log+0x2c>
  write_head(); // clear the log
    80003724:	00000097          	auipc	ra,0x0
    80003728:	e50080e7          	jalr	-432(ra) # 80003574 <write_head>
}
    8000372c:	70a2                	ld	ra,40(sp)
    8000372e:	7402                	ld	s0,32(sp)
    80003730:	64e2                	ld	s1,24(sp)
    80003732:	6942                	ld	s2,16(sp)
    80003734:	69a2                	ld	s3,8(sp)
    80003736:	6145                	addi	sp,sp,48
    80003738:	8082                	ret

000000008000373a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000373a:	1101                	addi	sp,sp,-32
    8000373c:	ec06                	sd	ra,24(sp)
    8000373e:	e822                	sd	s0,16(sp)
    80003740:	e426                	sd	s1,8(sp)
    80003742:	e04a                	sd	s2,0(sp)
    80003744:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003746:	00239517          	auipc	a0,0x239
    8000374a:	8f250513          	addi	a0,a0,-1806 # 8023c038 <log>
    8000374e:	00003097          	auipc	ra,0x3
    80003752:	d08080e7          	jalr	-760(ra) # 80006456 <acquire>
  while(1){
    if(log.committing){
    80003756:	00239497          	auipc	s1,0x239
    8000375a:	8e248493          	addi	s1,s1,-1822 # 8023c038 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000375e:	4979                	li	s2,30
    80003760:	a039                	j	8000376e <begin_op+0x34>
      sleep(&log, &log.lock);
    80003762:	85a6                	mv	a1,s1
    80003764:	8526                	mv	a0,s1
    80003766:	ffffe097          	auipc	ra,0xffffe
    8000376a:	fc8080e7          	jalr	-56(ra) # 8000172e <sleep>
    if(log.committing){
    8000376e:	50dc                	lw	a5,36(s1)
    80003770:	fbed                	bnez	a5,80003762 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003772:	5098                	lw	a4,32(s1)
    80003774:	2705                	addiw	a4,a4,1
    80003776:	0027179b          	slliw	a5,a4,0x2
    8000377a:	9fb9                	addw	a5,a5,a4
    8000377c:	0017979b          	slliw	a5,a5,0x1
    80003780:	54d4                	lw	a3,44(s1)
    80003782:	9fb5                	addw	a5,a5,a3
    80003784:	00f95963          	bge	s2,a5,80003796 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003788:	85a6                	mv	a1,s1
    8000378a:	8526                	mv	a0,s1
    8000378c:	ffffe097          	auipc	ra,0xffffe
    80003790:	fa2080e7          	jalr	-94(ra) # 8000172e <sleep>
    80003794:	bfe9                	j	8000376e <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003796:	00239517          	auipc	a0,0x239
    8000379a:	8a250513          	addi	a0,a0,-1886 # 8023c038 <log>
    8000379e:	d118                	sw	a4,32(a0)
      release(&log.lock);
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	d6a080e7          	jalr	-662(ra) # 8000650a <release>
      break;
    }
  }
}
    800037a8:	60e2                	ld	ra,24(sp)
    800037aa:	6442                	ld	s0,16(sp)
    800037ac:	64a2                	ld	s1,8(sp)
    800037ae:	6902                	ld	s2,0(sp)
    800037b0:	6105                	addi	sp,sp,32
    800037b2:	8082                	ret

00000000800037b4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800037b4:	7139                	addi	sp,sp,-64
    800037b6:	fc06                	sd	ra,56(sp)
    800037b8:	f822                	sd	s0,48(sp)
    800037ba:	f426                	sd	s1,40(sp)
    800037bc:	f04a                	sd	s2,32(sp)
    800037be:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800037c0:	00239497          	auipc	s1,0x239
    800037c4:	87848493          	addi	s1,s1,-1928 # 8023c038 <log>
    800037c8:	8526                	mv	a0,s1
    800037ca:	00003097          	auipc	ra,0x3
    800037ce:	c8c080e7          	jalr	-884(ra) # 80006456 <acquire>
  log.outstanding -= 1;
    800037d2:	509c                	lw	a5,32(s1)
    800037d4:	37fd                	addiw	a5,a5,-1
    800037d6:	0007891b          	sext.w	s2,a5
    800037da:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800037dc:	50dc                	lw	a5,36(s1)
    800037de:	e7b9                	bnez	a5,8000382c <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    800037e0:	06091163          	bnez	s2,80003842 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    800037e4:	00239497          	auipc	s1,0x239
    800037e8:	85448493          	addi	s1,s1,-1964 # 8023c038 <log>
    800037ec:	4785                	li	a5,1
    800037ee:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800037f0:	8526                	mv	a0,s1
    800037f2:	00003097          	auipc	ra,0x3
    800037f6:	d18080e7          	jalr	-744(ra) # 8000650a <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800037fa:	54dc                	lw	a5,44(s1)
    800037fc:	06f04763          	bgtz	a5,8000386a <end_op+0xb6>
    acquire(&log.lock);
    80003800:	00239497          	auipc	s1,0x239
    80003804:	83848493          	addi	s1,s1,-1992 # 8023c038 <log>
    80003808:	8526                	mv	a0,s1
    8000380a:	00003097          	auipc	ra,0x3
    8000380e:	c4c080e7          	jalr	-948(ra) # 80006456 <acquire>
    log.committing = 0;
    80003812:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003816:	8526                	mv	a0,s1
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	0a2080e7          	jalr	162(ra) # 800018ba <wakeup>
    release(&log.lock);
    80003820:	8526                	mv	a0,s1
    80003822:	00003097          	auipc	ra,0x3
    80003826:	ce8080e7          	jalr	-792(ra) # 8000650a <release>
}
    8000382a:	a815                	j	8000385e <end_op+0xaa>
    8000382c:	ec4e                	sd	s3,24(sp)
    8000382e:	e852                	sd	s4,16(sp)
    80003830:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003832:	00005517          	auipc	a0,0x5
    80003836:	c8650513          	addi	a0,a0,-890 # 800084b8 <etext+0x4b8>
    8000383a:	00002097          	auipc	ra,0x2
    8000383e:	6a2080e7          	jalr	1698(ra) # 80005edc <panic>
    wakeup(&log);
    80003842:	00238497          	auipc	s1,0x238
    80003846:	7f648493          	addi	s1,s1,2038 # 8023c038 <log>
    8000384a:	8526                	mv	a0,s1
    8000384c:	ffffe097          	auipc	ra,0xffffe
    80003850:	06e080e7          	jalr	110(ra) # 800018ba <wakeup>
  release(&log.lock);
    80003854:	8526                	mv	a0,s1
    80003856:	00003097          	auipc	ra,0x3
    8000385a:	cb4080e7          	jalr	-844(ra) # 8000650a <release>
}
    8000385e:	70e2                	ld	ra,56(sp)
    80003860:	7442                	ld	s0,48(sp)
    80003862:	74a2                	ld	s1,40(sp)
    80003864:	7902                	ld	s2,32(sp)
    80003866:	6121                	addi	sp,sp,64
    80003868:	8082                	ret
    8000386a:	ec4e                	sd	s3,24(sp)
    8000386c:	e852                	sd	s4,16(sp)
    8000386e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003870:	00238a97          	auipc	s5,0x238
    80003874:	7f8a8a93          	addi	s5,s5,2040 # 8023c068 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003878:	00238a17          	auipc	s4,0x238
    8000387c:	7c0a0a13          	addi	s4,s4,1984 # 8023c038 <log>
    80003880:	018a2583          	lw	a1,24(s4)
    80003884:	012585bb          	addw	a1,a1,s2
    80003888:	2585                	addiw	a1,a1,1
    8000388a:	028a2503          	lw	a0,40(s4)
    8000388e:	fffff097          	auipc	ra,0xfffff
    80003892:	ce0080e7          	jalr	-800(ra) # 8000256e <bread>
    80003896:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003898:	000aa583          	lw	a1,0(s5)
    8000389c:	028a2503          	lw	a0,40(s4)
    800038a0:	fffff097          	auipc	ra,0xfffff
    800038a4:	cce080e7          	jalr	-818(ra) # 8000256e <bread>
    800038a8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800038aa:	40000613          	li	a2,1024
    800038ae:	05850593          	addi	a1,a0,88
    800038b2:	05848513          	addi	a0,s1,88
    800038b6:	ffffd097          	auipc	ra,0xffffd
    800038ba:	9d6080e7          	jalr	-1578(ra) # 8000028c <memmove>
    bwrite(to);  // write the log
    800038be:	8526                	mv	a0,s1
    800038c0:	fffff097          	auipc	ra,0xfffff
    800038c4:	da0080e7          	jalr	-608(ra) # 80002660 <bwrite>
    brelse(from);
    800038c8:	854e                	mv	a0,s3
    800038ca:	fffff097          	auipc	ra,0xfffff
    800038ce:	dd4080e7          	jalr	-556(ra) # 8000269e <brelse>
    brelse(to);
    800038d2:	8526                	mv	a0,s1
    800038d4:	fffff097          	auipc	ra,0xfffff
    800038d8:	dca080e7          	jalr	-566(ra) # 8000269e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800038dc:	2905                	addiw	s2,s2,1
    800038de:	0a91                	addi	s5,s5,4
    800038e0:	02ca2783          	lw	a5,44(s4)
    800038e4:	f8f94ee3          	blt	s2,a5,80003880 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800038e8:	00000097          	auipc	ra,0x0
    800038ec:	c8c080e7          	jalr	-884(ra) # 80003574 <write_head>
    install_trans(0); // Now install writes to home locations
    800038f0:	4501                	li	a0,0
    800038f2:	00000097          	auipc	ra,0x0
    800038f6:	cec080e7          	jalr	-788(ra) # 800035de <install_trans>
    log.lh.n = 0;
    800038fa:	00238797          	auipc	a5,0x238
    800038fe:	7607a523          	sw	zero,1898(a5) # 8023c064 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003902:	00000097          	auipc	ra,0x0
    80003906:	c72080e7          	jalr	-910(ra) # 80003574 <write_head>
    8000390a:	69e2                	ld	s3,24(sp)
    8000390c:	6a42                	ld	s4,16(sp)
    8000390e:	6aa2                	ld	s5,8(sp)
    80003910:	bdc5                	j	80003800 <end_op+0x4c>

0000000080003912 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003912:	1101                	addi	sp,sp,-32
    80003914:	ec06                	sd	ra,24(sp)
    80003916:	e822                	sd	s0,16(sp)
    80003918:	e426                	sd	s1,8(sp)
    8000391a:	e04a                	sd	s2,0(sp)
    8000391c:	1000                	addi	s0,sp,32
    8000391e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003920:	00238917          	auipc	s2,0x238
    80003924:	71890913          	addi	s2,s2,1816 # 8023c038 <log>
    80003928:	854a                	mv	a0,s2
    8000392a:	00003097          	auipc	ra,0x3
    8000392e:	b2c080e7          	jalr	-1236(ra) # 80006456 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003932:	02c92603          	lw	a2,44(s2)
    80003936:	47f5                	li	a5,29
    80003938:	06c7c563          	blt	a5,a2,800039a2 <log_write+0x90>
    8000393c:	00238797          	auipc	a5,0x238
    80003940:	7187a783          	lw	a5,1816(a5) # 8023c054 <log+0x1c>
    80003944:	37fd                	addiw	a5,a5,-1
    80003946:	04f65e63          	bge	a2,a5,800039a2 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000394a:	00238797          	auipc	a5,0x238
    8000394e:	70e7a783          	lw	a5,1806(a5) # 8023c058 <log+0x20>
    80003952:	06f05063          	blez	a5,800039b2 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003956:	4781                	li	a5,0
    80003958:	06c05563          	blez	a2,800039c2 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000395c:	44cc                	lw	a1,12(s1)
    8000395e:	00238717          	auipc	a4,0x238
    80003962:	70a70713          	addi	a4,a4,1802 # 8023c068 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003966:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003968:	4314                	lw	a3,0(a4)
    8000396a:	04b68c63          	beq	a3,a1,800039c2 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    8000396e:	2785                	addiw	a5,a5,1
    80003970:	0711                	addi	a4,a4,4
    80003972:	fef61be3          	bne	a2,a5,80003968 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003976:	0621                	addi	a2,a2,8
    80003978:	060a                	slli	a2,a2,0x2
    8000397a:	00238797          	auipc	a5,0x238
    8000397e:	6be78793          	addi	a5,a5,1726 # 8023c038 <log>
    80003982:	97b2                	add	a5,a5,a2
    80003984:	44d8                	lw	a4,12(s1)
    80003986:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003988:	8526                	mv	a0,s1
    8000398a:	fffff097          	auipc	ra,0xfffff
    8000398e:	db0080e7          	jalr	-592(ra) # 8000273a <bpin>
    log.lh.n++;
    80003992:	00238717          	auipc	a4,0x238
    80003996:	6a670713          	addi	a4,a4,1702 # 8023c038 <log>
    8000399a:	575c                	lw	a5,44(a4)
    8000399c:	2785                	addiw	a5,a5,1
    8000399e:	d75c                	sw	a5,44(a4)
    800039a0:	a82d                	j	800039da <log_write+0xc8>
    panic("too big a transaction");
    800039a2:	00005517          	auipc	a0,0x5
    800039a6:	b2650513          	addi	a0,a0,-1242 # 800084c8 <etext+0x4c8>
    800039aa:	00002097          	auipc	ra,0x2
    800039ae:	532080e7          	jalr	1330(ra) # 80005edc <panic>
    panic("log_write outside of trans");
    800039b2:	00005517          	auipc	a0,0x5
    800039b6:	b2e50513          	addi	a0,a0,-1234 # 800084e0 <etext+0x4e0>
    800039ba:	00002097          	auipc	ra,0x2
    800039be:	522080e7          	jalr	1314(ra) # 80005edc <panic>
  log.lh.block[i] = b->blockno;
    800039c2:	00878693          	addi	a3,a5,8
    800039c6:	068a                	slli	a3,a3,0x2
    800039c8:	00238717          	auipc	a4,0x238
    800039cc:	67070713          	addi	a4,a4,1648 # 8023c038 <log>
    800039d0:	9736                	add	a4,a4,a3
    800039d2:	44d4                	lw	a3,12(s1)
    800039d4:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800039d6:	faf609e3          	beq	a2,a5,80003988 <log_write+0x76>
  }
  release(&log.lock);
    800039da:	00238517          	auipc	a0,0x238
    800039de:	65e50513          	addi	a0,a0,1630 # 8023c038 <log>
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	b28080e7          	jalr	-1240(ra) # 8000650a <release>
}
    800039ea:	60e2                	ld	ra,24(sp)
    800039ec:	6442                	ld	s0,16(sp)
    800039ee:	64a2                	ld	s1,8(sp)
    800039f0:	6902                	ld	s2,0(sp)
    800039f2:	6105                	addi	sp,sp,32
    800039f4:	8082                	ret

00000000800039f6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800039f6:	1101                	addi	sp,sp,-32
    800039f8:	ec06                	sd	ra,24(sp)
    800039fa:	e822                	sd	s0,16(sp)
    800039fc:	e426                	sd	s1,8(sp)
    800039fe:	e04a                	sd	s2,0(sp)
    80003a00:	1000                	addi	s0,sp,32
    80003a02:	84aa                	mv	s1,a0
    80003a04:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003a06:	00005597          	auipc	a1,0x5
    80003a0a:	afa58593          	addi	a1,a1,-1286 # 80008500 <etext+0x500>
    80003a0e:	0521                	addi	a0,a0,8
    80003a10:	00003097          	auipc	ra,0x3
    80003a14:	9b6080e7          	jalr	-1610(ra) # 800063c6 <initlock>
  lk->name = name;
    80003a18:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003a1c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003a20:	0204a423          	sw	zero,40(s1)
}
    80003a24:	60e2                	ld	ra,24(sp)
    80003a26:	6442                	ld	s0,16(sp)
    80003a28:	64a2                	ld	s1,8(sp)
    80003a2a:	6902                	ld	s2,0(sp)
    80003a2c:	6105                	addi	sp,sp,32
    80003a2e:	8082                	ret

0000000080003a30 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003a30:	1101                	addi	sp,sp,-32
    80003a32:	ec06                	sd	ra,24(sp)
    80003a34:	e822                	sd	s0,16(sp)
    80003a36:	e426                	sd	s1,8(sp)
    80003a38:	e04a                	sd	s2,0(sp)
    80003a3a:	1000                	addi	s0,sp,32
    80003a3c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a3e:	00850913          	addi	s2,a0,8
    80003a42:	854a                	mv	a0,s2
    80003a44:	00003097          	auipc	ra,0x3
    80003a48:	a12080e7          	jalr	-1518(ra) # 80006456 <acquire>
  while (lk->locked) {
    80003a4c:	409c                	lw	a5,0(s1)
    80003a4e:	cb89                	beqz	a5,80003a60 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003a50:	85ca                	mv	a1,s2
    80003a52:	8526                	mv	a0,s1
    80003a54:	ffffe097          	auipc	ra,0xffffe
    80003a58:	cda080e7          	jalr	-806(ra) # 8000172e <sleep>
  while (lk->locked) {
    80003a5c:	409c                	lw	a5,0(s1)
    80003a5e:	fbed                	bnez	a5,80003a50 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003a60:	4785                	li	a5,1
    80003a62:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003a64:	ffffd097          	auipc	ra,0xffffd
    80003a68:	604080e7          	jalr	1540(ra) # 80001068 <myproc>
    80003a6c:	591c                	lw	a5,48(a0)
    80003a6e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003a70:	854a                	mv	a0,s2
    80003a72:	00003097          	auipc	ra,0x3
    80003a76:	a98080e7          	jalr	-1384(ra) # 8000650a <release>
}
    80003a7a:	60e2                	ld	ra,24(sp)
    80003a7c:	6442                	ld	s0,16(sp)
    80003a7e:	64a2                	ld	s1,8(sp)
    80003a80:	6902                	ld	s2,0(sp)
    80003a82:	6105                	addi	sp,sp,32
    80003a84:	8082                	ret

0000000080003a86 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003a86:	1101                	addi	sp,sp,-32
    80003a88:	ec06                	sd	ra,24(sp)
    80003a8a:	e822                	sd	s0,16(sp)
    80003a8c:	e426                	sd	s1,8(sp)
    80003a8e:	e04a                	sd	s2,0(sp)
    80003a90:	1000                	addi	s0,sp,32
    80003a92:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003a94:	00850913          	addi	s2,a0,8
    80003a98:	854a                	mv	a0,s2
    80003a9a:	00003097          	auipc	ra,0x3
    80003a9e:	9bc080e7          	jalr	-1604(ra) # 80006456 <acquire>
  lk->locked = 0;
    80003aa2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003aa6:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003aaa:	8526                	mv	a0,s1
    80003aac:	ffffe097          	auipc	ra,0xffffe
    80003ab0:	e0e080e7          	jalr	-498(ra) # 800018ba <wakeup>
  release(&lk->lk);
    80003ab4:	854a                	mv	a0,s2
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	a54080e7          	jalr	-1452(ra) # 8000650a <release>
}
    80003abe:	60e2                	ld	ra,24(sp)
    80003ac0:	6442                	ld	s0,16(sp)
    80003ac2:	64a2                	ld	s1,8(sp)
    80003ac4:	6902                	ld	s2,0(sp)
    80003ac6:	6105                	addi	sp,sp,32
    80003ac8:	8082                	ret

0000000080003aca <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003aca:	7179                	addi	sp,sp,-48
    80003acc:	f406                	sd	ra,40(sp)
    80003ace:	f022                	sd	s0,32(sp)
    80003ad0:	ec26                	sd	s1,24(sp)
    80003ad2:	e84a                	sd	s2,16(sp)
    80003ad4:	1800                	addi	s0,sp,48
    80003ad6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003ad8:	00850913          	addi	s2,a0,8
    80003adc:	854a                	mv	a0,s2
    80003ade:	00003097          	auipc	ra,0x3
    80003ae2:	978080e7          	jalr	-1672(ra) # 80006456 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003ae6:	409c                	lw	a5,0(s1)
    80003ae8:	ef91                	bnez	a5,80003b04 <holdingsleep+0x3a>
    80003aea:	4481                	li	s1,0
  release(&lk->lk);
    80003aec:	854a                	mv	a0,s2
    80003aee:	00003097          	auipc	ra,0x3
    80003af2:	a1c080e7          	jalr	-1508(ra) # 8000650a <release>
  return r;
}
    80003af6:	8526                	mv	a0,s1
    80003af8:	70a2                	ld	ra,40(sp)
    80003afa:	7402                	ld	s0,32(sp)
    80003afc:	64e2                	ld	s1,24(sp)
    80003afe:	6942                	ld	s2,16(sp)
    80003b00:	6145                	addi	sp,sp,48
    80003b02:	8082                	ret
    80003b04:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003b06:	0284a983          	lw	s3,40(s1)
    80003b0a:	ffffd097          	auipc	ra,0xffffd
    80003b0e:	55e080e7          	jalr	1374(ra) # 80001068 <myproc>
    80003b12:	5904                	lw	s1,48(a0)
    80003b14:	413484b3          	sub	s1,s1,s3
    80003b18:	0014b493          	seqz	s1,s1
    80003b1c:	69a2                	ld	s3,8(sp)
    80003b1e:	b7f9                	j	80003aec <holdingsleep+0x22>

0000000080003b20 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003b20:	1141                	addi	sp,sp,-16
    80003b22:	e406                	sd	ra,8(sp)
    80003b24:	e022                	sd	s0,0(sp)
    80003b26:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003b28:	00005597          	auipc	a1,0x5
    80003b2c:	9e858593          	addi	a1,a1,-1560 # 80008510 <etext+0x510>
    80003b30:	00238517          	auipc	a0,0x238
    80003b34:	65050513          	addi	a0,a0,1616 # 8023c180 <ftable>
    80003b38:	00003097          	auipc	ra,0x3
    80003b3c:	88e080e7          	jalr	-1906(ra) # 800063c6 <initlock>
}
    80003b40:	60a2                	ld	ra,8(sp)
    80003b42:	6402                	ld	s0,0(sp)
    80003b44:	0141                	addi	sp,sp,16
    80003b46:	8082                	ret

0000000080003b48 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003b48:	1101                	addi	sp,sp,-32
    80003b4a:	ec06                	sd	ra,24(sp)
    80003b4c:	e822                	sd	s0,16(sp)
    80003b4e:	e426                	sd	s1,8(sp)
    80003b50:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003b52:	00238517          	auipc	a0,0x238
    80003b56:	62e50513          	addi	a0,a0,1582 # 8023c180 <ftable>
    80003b5a:	00003097          	auipc	ra,0x3
    80003b5e:	8fc080e7          	jalr	-1796(ra) # 80006456 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b62:	00238497          	auipc	s1,0x238
    80003b66:	63648493          	addi	s1,s1,1590 # 8023c198 <ftable+0x18>
    80003b6a:	00239717          	auipc	a4,0x239
    80003b6e:	5ce70713          	addi	a4,a4,1486 # 8023d138 <ftable+0xfb8>
    if(f->ref == 0){
    80003b72:	40dc                	lw	a5,4(s1)
    80003b74:	cf99                	beqz	a5,80003b92 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003b76:	02848493          	addi	s1,s1,40
    80003b7a:	fee49ce3          	bne	s1,a4,80003b72 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003b7e:	00238517          	auipc	a0,0x238
    80003b82:	60250513          	addi	a0,a0,1538 # 8023c180 <ftable>
    80003b86:	00003097          	auipc	ra,0x3
    80003b8a:	984080e7          	jalr	-1660(ra) # 8000650a <release>
  return 0;
    80003b8e:	4481                	li	s1,0
    80003b90:	a819                	j	80003ba6 <filealloc+0x5e>
      f->ref = 1;
    80003b92:	4785                	li	a5,1
    80003b94:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003b96:	00238517          	auipc	a0,0x238
    80003b9a:	5ea50513          	addi	a0,a0,1514 # 8023c180 <ftable>
    80003b9e:	00003097          	auipc	ra,0x3
    80003ba2:	96c080e7          	jalr	-1684(ra) # 8000650a <release>
}
    80003ba6:	8526                	mv	a0,s1
    80003ba8:	60e2                	ld	ra,24(sp)
    80003baa:	6442                	ld	s0,16(sp)
    80003bac:	64a2                	ld	s1,8(sp)
    80003bae:	6105                	addi	sp,sp,32
    80003bb0:	8082                	ret

0000000080003bb2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003bb2:	1101                	addi	sp,sp,-32
    80003bb4:	ec06                	sd	ra,24(sp)
    80003bb6:	e822                	sd	s0,16(sp)
    80003bb8:	e426                	sd	s1,8(sp)
    80003bba:	1000                	addi	s0,sp,32
    80003bbc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003bbe:	00238517          	auipc	a0,0x238
    80003bc2:	5c250513          	addi	a0,a0,1474 # 8023c180 <ftable>
    80003bc6:	00003097          	auipc	ra,0x3
    80003bca:	890080e7          	jalr	-1904(ra) # 80006456 <acquire>
  if(f->ref < 1)
    80003bce:	40dc                	lw	a5,4(s1)
    80003bd0:	02f05263          	blez	a5,80003bf4 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003bd4:	2785                	addiw	a5,a5,1
    80003bd6:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003bd8:	00238517          	auipc	a0,0x238
    80003bdc:	5a850513          	addi	a0,a0,1448 # 8023c180 <ftable>
    80003be0:	00003097          	auipc	ra,0x3
    80003be4:	92a080e7          	jalr	-1750(ra) # 8000650a <release>
  return f;
}
    80003be8:	8526                	mv	a0,s1
    80003bea:	60e2                	ld	ra,24(sp)
    80003bec:	6442                	ld	s0,16(sp)
    80003bee:	64a2                	ld	s1,8(sp)
    80003bf0:	6105                	addi	sp,sp,32
    80003bf2:	8082                	ret
    panic("filedup");
    80003bf4:	00005517          	auipc	a0,0x5
    80003bf8:	92450513          	addi	a0,a0,-1756 # 80008518 <etext+0x518>
    80003bfc:	00002097          	auipc	ra,0x2
    80003c00:	2e0080e7          	jalr	736(ra) # 80005edc <panic>

0000000080003c04 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003c04:	7139                	addi	sp,sp,-64
    80003c06:	fc06                	sd	ra,56(sp)
    80003c08:	f822                	sd	s0,48(sp)
    80003c0a:	f426                	sd	s1,40(sp)
    80003c0c:	0080                	addi	s0,sp,64
    80003c0e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003c10:	00238517          	auipc	a0,0x238
    80003c14:	57050513          	addi	a0,a0,1392 # 8023c180 <ftable>
    80003c18:	00003097          	auipc	ra,0x3
    80003c1c:	83e080e7          	jalr	-1986(ra) # 80006456 <acquire>
  if(f->ref < 1)
    80003c20:	40dc                	lw	a5,4(s1)
    80003c22:	04f05c63          	blez	a5,80003c7a <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80003c26:	37fd                	addiw	a5,a5,-1
    80003c28:	0007871b          	sext.w	a4,a5
    80003c2c:	c0dc                	sw	a5,4(s1)
    80003c2e:	06e04263          	bgtz	a4,80003c92 <fileclose+0x8e>
    80003c32:	f04a                	sd	s2,32(sp)
    80003c34:	ec4e                	sd	s3,24(sp)
    80003c36:	e852                	sd	s4,16(sp)
    80003c38:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003c3a:	0004a903          	lw	s2,0(s1)
    80003c3e:	0094ca83          	lbu	s5,9(s1)
    80003c42:	0104ba03          	ld	s4,16(s1)
    80003c46:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003c4a:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003c4e:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003c52:	00238517          	auipc	a0,0x238
    80003c56:	52e50513          	addi	a0,a0,1326 # 8023c180 <ftable>
    80003c5a:	00003097          	auipc	ra,0x3
    80003c5e:	8b0080e7          	jalr	-1872(ra) # 8000650a <release>

  if(ff.type == FD_PIPE){
    80003c62:	4785                	li	a5,1
    80003c64:	04f90463          	beq	s2,a5,80003cac <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003c68:	3979                	addiw	s2,s2,-2
    80003c6a:	4785                	li	a5,1
    80003c6c:	0527fb63          	bgeu	a5,s2,80003cc2 <fileclose+0xbe>
    80003c70:	7902                	ld	s2,32(sp)
    80003c72:	69e2                	ld	s3,24(sp)
    80003c74:	6a42                	ld	s4,16(sp)
    80003c76:	6aa2                	ld	s5,8(sp)
    80003c78:	a02d                	j	80003ca2 <fileclose+0x9e>
    80003c7a:	f04a                	sd	s2,32(sp)
    80003c7c:	ec4e                	sd	s3,24(sp)
    80003c7e:	e852                	sd	s4,16(sp)
    80003c80:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003c82:	00005517          	auipc	a0,0x5
    80003c86:	89e50513          	addi	a0,a0,-1890 # 80008520 <etext+0x520>
    80003c8a:	00002097          	auipc	ra,0x2
    80003c8e:	252080e7          	jalr	594(ra) # 80005edc <panic>
    release(&ftable.lock);
    80003c92:	00238517          	auipc	a0,0x238
    80003c96:	4ee50513          	addi	a0,a0,1262 # 8023c180 <ftable>
    80003c9a:	00003097          	auipc	ra,0x3
    80003c9e:	870080e7          	jalr	-1936(ra) # 8000650a <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003ca2:	70e2                	ld	ra,56(sp)
    80003ca4:	7442                	ld	s0,48(sp)
    80003ca6:	74a2                	ld	s1,40(sp)
    80003ca8:	6121                	addi	sp,sp,64
    80003caa:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003cac:	85d6                	mv	a1,s5
    80003cae:	8552                	mv	a0,s4
    80003cb0:	00000097          	auipc	ra,0x0
    80003cb4:	3a2080e7          	jalr	930(ra) # 80004052 <pipeclose>
    80003cb8:	7902                	ld	s2,32(sp)
    80003cba:	69e2                	ld	s3,24(sp)
    80003cbc:	6a42                	ld	s4,16(sp)
    80003cbe:	6aa2                	ld	s5,8(sp)
    80003cc0:	b7cd                	j	80003ca2 <fileclose+0x9e>
    begin_op();
    80003cc2:	00000097          	auipc	ra,0x0
    80003cc6:	a78080e7          	jalr	-1416(ra) # 8000373a <begin_op>
    iput(ff.ip);
    80003cca:	854e                	mv	a0,s3
    80003ccc:	fffff097          	auipc	ra,0xfffff
    80003cd0:	25a080e7          	jalr	602(ra) # 80002f26 <iput>
    end_op();
    80003cd4:	00000097          	auipc	ra,0x0
    80003cd8:	ae0080e7          	jalr	-1312(ra) # 800037b4 <end_op>
    80003cdc:	7902                	ld	s2,32(sp)
    80003cde:	69e2                	ld	s3,24(sp)
    80003ce0:	6a42                	ld	s4,16(sp)
    80003ce2:	6aa2                	ld	s5,8(sp)
    80003ce4:	bf7d                	j	80003ca2 <fileclose+0x9e>

0000000080003ce6 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003ce6:	715d                	addi	sp,sp,-80
    80003ce8:	e486                	sd	ra,72(sp)
    80003cea:	e0a2                	sd	s0,64(sp)
    80003cec:	fc26                	sd	s1,56(sp)
    80003cee:	f44e                	sd	s3,40(sp)
    80003cf0:	0880                	addi	s0,sp,80
    80003cf2:	84aa                	mv	s1,a0
    80003cf4:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003cf6:	ffffd097          	auipc	ra,0xffffd
    80003cfa:	372080e7          	jalr	882(ra) # 80001068 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003cfe:	409c                	lw	a5,0(s1)
    80003d00:	37f9                	addiw	a5,a5,-2
    80003d02:	4705                	li	a4,1
    80003d04:	04f76863          	bltu	a4,a5,80003d54 <filestat+0x6e>
    80003d08:	f84a                	sd	s2,48(sp)
    80003d0a:	892a                	mv	s2,a0
    ilock(f->ip);
    80003d0c:	6c88                	ld	a0,24(s1)
    80003d0e:	fffff097          	auipc	ra,0xfffff
    80003d12:	05a080e7          	jalr	90(ra) # 80002d68 <ilock>
    stati(f->ip, &st);
    80003d16:	fb840593          	addi	a1,s0,-72
    80003d1a:	6c88                	ld	a0,24(s1)
    80003d1c:	fffff097          	auipc	ra,0xfffff
    80003d20:	2da080e7          	jalr	730(ra) # 80002ff6 <stati>
    iunlock(f->ip);
    80003d24:	6c88                	ld	a0,24(s1)
    80003d26:	fffff097          	auipc	ra,0xfffff
    80003d2a:	108080e7          	jalr	264(ra) # 80002e2e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003d2e:	46e1                	li	a3,24
    80003d30:	fb840613          	addi	a2,s0,-72
    80003d34:	85ce                	mv	a1,s3
    80003d36:	05093503          	ld	a0,80(s2)
    80003d3a:	ffffd097          	auipc	ra,0xffffd
    80003d3e:	eb8080e7          	jalr	-328(ra) # 80000bf2 <copyout>
    80003d42:	41f5551b          	sraiw	a0,a0,0x1f
    80003d46:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003d48:	60a6                	ld	ra,72(sp)
    80003d4a:	6406                	ld	s0,64(sp)
    80003d4c:	74e2                	ld	s1,56(sp)
    80003d4e:	79a2                	ld	s3,40(sp)
    80003d50:	6161                	addi	sp,sp,80
    80003d52:	8082                	ret
  return -1;
    80003d54:	557d                	li	a0,-1
    80003d56:	bfcd                	j	80003d48 <filestat+0x62>

0000000080003d58 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003d58:	7179                	addi	sp,sp,-48
    80003d5a:	f406                	sd	ra,40(sp)
    80003d5c:	f022                	sd	s0,32(sp)
    80003d5e:	e84a                	sd	s2,16(sp)
    80003d60:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003d62:	00854783          	lbu	a5,8(a0)
    80003d66:	cbc5                	beqz	a5,80003e16 <fileread+0xbe>
    80003d68:	ec26                	sd	s1,24(sp)
    80003d6a:	e44e                	sd	s3,8(sp)
    80003d6c:	84aa                	mv	s1,a0
    80003d6e:	89ae                	mv	s3,a1
    80003d70:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d72:	411c                	lw	a5,0(a0)
    80003d74:	4705                	li	a4,1
    80003d76:	04e78963          	beq	a5,a4,80003dc8 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d7a:	470d                	li	a4,3
    80003d7c:	04e78f63          	beq	a5,a4,80003dda <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d80:	4709                	li	a4,2
    80003d82:	08e79263          	bne	a5,a4,80003e06 <fileread+0xae>
    ilock(f->ip);
    80003d86:	6d08                	ld	a0,24(a0)
    80003d88:	fffff097          	auipc	ra,0xfffff
    80003d8c:	fe0080e7          	jalr	-32(ra) # 80002d68 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003d90:	874a                	mv	a4,s2
    80003d92:	5094                	lw	a3,32(s1)
    80003d94:	864e                	mv	a2,s3
    80003d96:	4585                	li	a1,1
    80003d98:	6c88                	ld	a0,24(s1)
    80003d9a:	fffff097          	auipc	ra,0xfffff
    80003d9e:	286080e7          	jalr	646(ra) # 80003020 <readi>
    80003da2:	892a                	mv	s2,a0
    80003da4:	00a05563          	blez	a0,80003dae <fileread+0x56>
      f->off += r;
    80003da8:	509c                	lw	a5,32(s1)
    80003daa:	9fa9                	addw	a5,a5,a0
    80003dac:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003dae:	6c88                	ld	a0,24(s1)
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	07e080e7          	jalr	126(ra) # 80002e2e <iunlock>
    80003db8:	64e2                	ld	s1,24(sp)
    80003dba:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003dbc:	854a                	mv	a0,s2
    80003dbe:	70a2                	ld	ra,40(sp)
    80003dc0:	7402                	ld	s0,32(sp)
    80003dc2:	6942                	ld	s2,16(sp)
    80003dc4:	6145                	addi	sp,sp,48
    80003dc6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003dc8:	6908                	ld	a0,16(a0)
    80003dca:	00000097          	auipc	ra,0x0
    80003dce:	3fa080e7          	jalr	1018(ra) # 800041c4 <piperead>
    80003dd2:	892a                	mv	s2,a0
    80003dd4:	64e2                	ld	s1,24(sp)
    80003dd6:	69a2                	ld	s3,8(sp)
    80003dd8:	b7d5                	j	80003dbc <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003dda:	02451783          	lh	a5,36(a0)
    80003dde:	03079693          	slli	a3,a5,0x30
    80003de2:	92c1                	srli	a3,a3,0x30
    80003de4:	4725                	li	a4,9
    80003de6:	02d76a63          	bltu	a4,a3,80003e1a <fileread+0xc2>
    80003dea:	0792                	slli	a5,a5,0x4
    80003dec:	00238717          	auipc	a4,0x238
    80003df0:	2f470713          	addi	a4,a4,756 # 8023c0e0 <devsw>
    80003df4:	97ba                	add	a5,a5,a4
    80003df6:	639c                	ld	a5,0(a5)
    80003df8:	c78d                	beqz	a5,80003e22 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80003dfa:	4505                	li	a0,1
    80003dfc:	9782                	jalr	a5
    80003dfe:	892a                	mv	s2,a0
    80003e00:	64e2                	ld	s1,24(sp)
    80003e02:	69a2                	ld	s3,8(sp)
    80003e04:	bf65                	j	80003dbc <fileread+0x64>
    panic("fileread");
    80003e06:	00004517          	auipc	a0,0x4
    80003e0a:	72a50513          	addi	a0,a0,1834 # 80008530 <etext+0x530>
    80003e0e:	00002097          	auipc	ra,0x2
    80003e12:	0ce080e7          	jalr	206(ra) # 80005edc <panic>
    return -1;
    80003e16:	597d                	li	s2,-1
    80003e18:	b755                	j	80003dbc <fileread+0x64>
      return -1;
    80003e1a:	597d                	li	s2,-1
    80003e1c:	64e2                	ld	s1,24(sp)
    80003e1e:	69a2                	ld	s3,8(sp)
    80003e20:	bf71                	j	80003dbc <fileread+0x64>
    80003e22:	597d                	li	s2,-1
    80003e24:	64e2                	ld	s1,24(sp)
    80003e26:	69a2                	ld	s3,8(sp)
    80003e28:	bf51                	j	80003dbc <fileread+0x64>

0000000080003e2a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003e2a:	00954783          	lbu	a5,9(a0)
    80003e2e:	12078963          	beqz	a5,80003f60 <filewrite+0x136>
{
    80003e32:	715d                	addi	sp,sp,-80
    80003e34:	e486                	sd	ra,72(sp)
    80003e36:	e0a2                	sd	s0,64(sp)
    80003e38:	f84a                	sd	s2,48(sp)
    80003e3a:	f052                	sd	s4,32(sp)
    80003e3c:	e85a                	sd	s6,16(sp)
    80003e3e:	0880                	addi	s0,sp,80
    80003e40:	892a                	mv	s2,a0
    80003e42:	8b2e                	mv	s6,a1
    80003e44:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003e46:	411c                	lw	a5,0(a0)
    80003e48:	4705                	li	a4,1
    80003e4a:	02e78763          	beq	a5,a4,80003e78 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003e4e:	470d                	li	a4,3
    80003e50:	02e78a63          	beq	a5,a4,80003e84 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003e54:	4709                	li	a4,2
    80003e56:	0ee79863          	bne	a5,a4,80003f46 <filewrite+0x11c>
    80003e5a:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003e5c:	0cc05463          	blez	a2,80003f24 <filewrite+0xfa>
    80003e60:	fc26                	sd	s1,56(sp)
    80003e62:	ec56                	sd	s5,24(sp)
    80003e64:	e45e                	sd	s7,8(sp)
    80003e66:	e062                	sd	s8,0(sp)
    int i = 0;
    80003e68:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80003e6a:	6b85                	lui	s7,0x1
    80003e6c:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003e70:	6c05                	lui	s8,0x1
    80003e72:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80003e76:	a851                	j	80003f0a <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80003e78:	6908                	ld	a0,16(a0)
    80003e7a:	00000097          	auipc	ra,0x0
    80003e7e:	248080e7          	jalr	584(ra) # 800040c2 <pipewrite>
    80003e82:	a85d                	j	80003f38 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003e84:	02451783          	lh	a5,36(a0)
    80003e88:	03079693          	slli	a3,a5,0x30
    80003e8c:	92c1                	srli	a3,a3,0x30
    80003e8e:	4725                	li	a4,9
    80003e90:	0cd76a63          	bltu	a4,a3,80003f64 <filewrite+0x13a>
    80003e94:	0792                	slli	a5,a5,0x4
    80003e96:	00238717          	auipc	a4,0x238
    80003e9a:	24a70713          	addi	a4,a4,586 # 8023c0e0 <devsw>
    80003e9e:	97ba                	add	a5,a5,a4
    80003ea0:	679c                	ld	a5,8(a5)
    80003ea2:	c3f9                	beqz	a5,80003f68 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80003ea4:	4505                	li	a0,1
    80003ea6:	9782                	jalr	a5
    80003ea8:	a841                	j	80003f38 <filewrite+0x10e>
      if(n1 > max)
    80003eaa:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80003eae:	00000097          	auipc	ra,0x0
    80003eb2:	88c080e7          	jalr	-1908(ra) # 8000373a <begin_op>
      ilock(f->ip);
    80003eb6:	01893503          	ld	a0,24(s2)
    80003eba:	fffff097          	auipc	ra,0xfffff
    80003ebe:	eae080e7          	jalr	-338(ra) # 80002d68 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003ec2:	8756                	mv	a4,s5
    80003ec4:	02092683          	lw	a3,32(s2)
    80003ec8:	01698633          	add	a2,s3,s6
    80003ecc:	4585                	li	a1,1
    80003ece:	01893503          	ld	a0,24(s2)
    80003ed2:	fffff097          	auipc	ra,0xfffff
    80003ed6:	252080e7          	jalr	594(ra) # 80003124 <writei>
    80003eda:	84aa                	mv	s1,a0
    80003edc:	00a05763          	blez	a0,80003eea <filewrite+0xc0>
        f->off += r;
    80003ee0:	02092783          	lw	a5,32(s2)
    80003ee4:	9fa9                	addw	a5,a5,a0
    80003ee6:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003eea:	01893503          	ld	a0,24(s2)
    80003eee:	fffff097          	auipc	ra,0xfffff
    80003ef2:	f40080e7          	jalr	-192(ra) # 80002e2e <iunlock>
      end_op();
    80003ef6:	00000097          	auipc	ra,0x0
    80003efa:	8be080e7          	jalr	-1858(ra) # 800037b4 <end_op>

      if(r != n1){
    80003efe:	029a9563          	bne	s5,s1,80003f28 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80003f02:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003f06:	0149da63          	bge	s3,s4,80003f1a <filewrite+0xf0>
      int n1 = n - i;
    80003f0a:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80003f0e:	0004879b          	sext.w	a5,s1
    80003f12:	f8fbdce3          	bge	s7,a5,80003eaa <filewrite+0x80>
    80003f16:	84e2                	mv	s1,s8
    80003f18:	bf49                	j	80003eaa <filewrite+0x80>
    80003f1a:	74e2                	ld	s1,56(sp)
    80003f1c:	6ae2                	ld	s5,24(sp)
    80003f1e:	6ba2                	ld	s7,8(sp)
    80003f20:	6c02                	ld	s8,0(sp)
    80003f22:	a039                	j	80003f30 <filewrite+0x106>
    int i = 0;
    80003f24:	4981                	li	s3,0
    80003f26:	a029                	j	80003f30 <filewrite+0x106>
    80003f28:	74e2                	ld	s1,56(sp)
    80003f2a:	6ae2                	ld	s5,24(sp)
    80003f2c:	6ba2                	ld	s7,8(sp)
    80003f2e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80003f30:	033a1e63          	bne	s4,s3,80003f6c <filewrite+0x142>
    80003f34:	8552                	mv	a0,s4
    80003f36:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003f38:	60a6                	ld	ra,72(sp)
    80003f3a:	6406                	ld	s0,64(sp)
    80003f3c:	7942                	ld	s2,48(sp)
    80003f3e:	7a02                	ld	s4,32(sp)
    80003f40:	6b42                	ld	s6,16(sp)
    80003f42:	6161                	addi	sp,sp,80
    80003f44:	8082                	ret
    80003f46:	fc26                	sd	s1,56(sp)
    80003f48:	f44e                	sd	s3,40(sp)
    80003f4a:	ec56                	sd	s5,24(sp)
    80003f4c:	e45e                	sd	s7,8(sp)
    80003f4e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80003f50:	00004517          	auipc	a0,0x4
    80003f54:	5f050513          	addi	a0,a0,1520 # 80008540 <etext+0x540>
    80003f58:	00002097          	auipc	ra,0x2
    80003f5c:	f84080e7          	jalr	-124(ra) # 80005edc <panic>
    return -1;
    80003f60:	557d                	li	a0,-1
}
    80003f62:	8082                	ret
      return -1;
    80003f64:	557d                	li	a0,-1
    80003f66:	bfc9                	j	80003f38 <filewrite+0x10e>
    80003f68:	557d                	li	a0,-1
    80003f6a:	b7f9                	j	80003f38 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    80003f6c:	557d                	li	a0,-1
    80003f6e:	79a2                	ld	s3,40(sp)
    80003f70:	b7e1                	j	80003f38 <filewrite+0x10e>

0000000080003f72 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003f72:	7179                	addi	sp,sp,-48
    80003f74:	f406                	sd	ra,40(sp)
    80003f76:	f022                	sd	s0,32(sp)
    80003f78:	ec26                	sd	s1,24(sp)
    80003f7a:	e052                	sd	s4,0(sp)
    80003f7c:	1800                	addi	s0,sp,48
    80003f7e:	84aa                	mv	s1,a0
    80003f80:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003f82:	0005b023          	sd	zero,0(a1)
    80003f86:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003f8a:	00000097          	auipc	ra,0x0
    80003f8e:	bbe080e7          	jalr	-1090(ra) # 80003b48 <filealloc>
    80003f92:	e088                	sd	a0,0(s1)
    80003f94:	cd49                	beqz	a0,8000402e <pipealloc+0xbc>
    80003f96:	00000097          	auipc	ra,0x0
    80003f9a:	bb2080e7          	jalr	-1102(ra) # 80003b48 <filealloc>
    80003f9e:	00aa3023          	sd	a0,0(s4)
    80003fa2:	c141                	beqz	a0,80004022 <pipealloc+0xb0>
    80003fa4:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003fa6:	ffffc097          	auipc	ra,0xffffc
    80003faa:	1fc080e7          	jalr	508(ra) # 800001a2 <kalloc>
    80003fae:	892a                	mv	s2,a0
    80003fb0:	c13d                	beqz	a0,80004016 <pipealloc+0xa4>
    80003fb2:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003fb4:	4985                	li	s3,1
    80003fb6:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003fba:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003fbe:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003fc2:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003fc6:	00004597          	auipc	a1,0x4
    80003fca:	58a58593          	addi	a1,a1,1418 # 80008550 <etext+0x550>
    80003fce:	00002097          	auipc	ra,0x2
    80003fd2:	3f8080e7          	jalr	1016(ra) # 800063c6 <initlock>
  (*f0)->type = FD_PIPE;
    80003fd6:	609c                	ld	a5,0(s1)
    80003fd8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003fdc:	609c                	ld	a5,0(s1)
    80003fde:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003fe2:	609c                	ld	a5,0(s1)
    80003fe4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003fe8:	609c                	ld	a5,0(s1)
    80003fea:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003fee:	000a3783          	ld	a5,0(s4)
    80003ff2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ff6:	000a3783          	ld	a5,0(s4)
    80003ffa:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ffe:	000a3783          	ld	a5,0(s4)
    80004002:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004006:	000a3783          	ld	a5,0(s4)
    8000400a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000400e:	4501                	li	a0,0
    80004010:	6942                	ld	s2,16(sp)
    80004012:	69a2                	ld	s3,8(sp)
    80004014:	a03d                	j	80004042 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004016:	6088                	ld	a0,0(s1)
    80004018:	c119                	beqz	a0,8000401e <pipealloc+0xac>
    8000401a:	6942                	ld	s2,16(sp)
    8000401c:	a029                	j	80004026 <pipealloc+0xb4>
    8000401e:	6942                	ld	s2,16(sp)
    80004020:	a039                	j	8000402e <pipealloc+0xbc>
    80004022:	6088                	ld	a0,0(s1)
    80004024:	c50d                	beqz	a0,8000404e <pipealloc+0xdc>
    fileclose(*f0);
    80004026:	00000097          	auipc	ra,0x0
    8000402a:	bde080e7          	jalr	-1058(ra) # 80003c04 <fileclose>
  if(*f1)
    8000402e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004032:	557d                	li	a0,-1
  if(*f1)
    80004034:	c799                	beqz	a5,80004042 <pipealloc+0xd0>
    fileclose(*f1);
    80004036:	853e                	mv	a0,a5
    80004038:	00000097          	auipc	ra,0x0
    8000403c:	bcc080e7          	jalr	-1076(ra) # 80003c04 <fileclose>
  return -1;
    80004040:	557d                	li	a0,-1
}
    80004042:	70a2                	ld	ra,40(sp)
    80004044:	7402                	ld	s0,32(sp)
    80004046:	64e2                	ld	s1,24(sp)
    80004048:	6a02                	ld	s4,0(sp)
    8000404a:	6145                	addi	sp,sp,48
    8000404c:	8082                	ret
  return -1;
    8000404e:	557d                	li	a0,-1
    80004050:	bfcd                	j	80004042 <pipealloc+0xd0>

0000000080004052 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004052:	1101                	addi	sp,sp,-32
    80004054:	ec06                	sd	ra,24(sp)
    80004056:	e822                	sd	s0,16(sp)
    80004058:	e426                	sd	s1,8(sp)
    8000405a:	e04a                	sd	s2,0(sp)
    8000405c:	1000                	addi	s0,sp,32
    8000405e:	84aa                	mv	s1,a0
    80004060:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004062:	00002097          	auipc	ra,0x2
    80004066:	3f4080e7          	jalr	1012(ra) # 80006456 <acquire>
  if(writable){
    8000406a:	02090d63          	beqz	s2,800040a4 <pipeclose+0x52>
    pi->writeopen = 0;
    8000406e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004072:	21848513          	addi	a0,s1,536
    80004076:	ffffe097          	auipc	ra,0xffffe
    8000407a:	844080e7          	jalr	-1980(ra) # 800018ba <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000407e:	2204b783          	ld	a5,544(s1)
    80004082:	eb95                	bnez	a5,800040b6 <pipeclose+0x64>
    release(&pi->lock);
    80004084:	8526                	mv	a0,s1
    80004086:	00002097          	auipc	ra,0x2
    8000408a:	484080e7          	jalr	1156(ra) # 8000650a <release>
    kfree((char*)pi);
    8000408e:	8526                	mv	a0,s1
    80004090:	ffffc097          	auipc	ra,0xffffc
    80004094:	f8c080e7          	jalr	-116(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80004098:	60e2                	ld	ra,24(sp)
    8000409a:	6442                	ld	s0,16(sp)
    8000409c:	64a2                	ld	s1,8(sp)
    8000409e:	6902                	ld	s2,0(sp)
    800040a0:	6105                	addi	sp,sp,32
    800040a2:	8082                	ret
    pi->readopen = 0;
    800040a4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800040a8:	21c48513          	addi	a0,s1,540
    800040ac:	ffffe097          	auipc	ra,0xffffe
    800040b0:	80e080e7          	jalr	-2034(ra) # 800018ba <wakeup>
    800040b4:	b7e9                	j	8000407e <pipeclose+0x2c>
    release(&pi->lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	00002097          	auipc	ra,0x2
    800040bc:	452080e7          	jalr	1106(ra) # 8000650a <release>
}
    800040c0:	bfe1                	j	80004098 <pipeclose+0x46>

00000000800040c2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800040c2:	711d                	addi	sp,sp,-96
    800040c4:	ec86                	sd	ra,88(sp)
    800040c6:	e8a2                	sd	s0,80(sp)
    800040c8:	e4a6                	sd	s1,72(sp)
    800040ca:	e0ca                	sd	s2,64(sp)
    800040cc:	fc4e                	sd	s3,56(sp)
    800040ce:	f852                	sd	s4,48(sp)
    800040d0:	f456                	sd	s5,40(sp)
    800040d2:	1080                	addi	s0,sp,96
    800040d4:	84aa                	mv	s1,a0
    800040d6:	8aae                	mv	s5,a1
    800040d8:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800040da:	ffffd097          	auipc	ra,0xffffd
    800040de:	f8e080e7          	jalr	-114(ra) # 80001068 <myproc>
    800040e2:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800040e4:	8526                	mv	a0,s1
    800040e6:	00002097          	auipc	ra,0x2
    800040ea:	370080e7          	jalr	880(ra) # 80006456 <acquire>
  while(i < n){
    800040ee:	0d405563          	blez	s4,800041b8 <pipewrite+0xf6>
    800040f2:	f05a                	sd	s6,32(sp)
    800040f4:	ec5e                	sd	s7,24(sp)
    800040f6:	e862                	sd	s8,16(sp)
  int i = 0;
    800040f8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800040fa:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800040fc:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004100:	21c48b93          	addi	s7,s1,540
    80004104:	a089                	j	80004146 <pipewrite+0x84>
      release(&pi->lock);
    80004106:	8526                	mv	a0,s1
    80004108:	00002097          	auipc	ra,0x2
    8000410c:	402080e7          	jalr	1026(ra) # 8000650a <release>
      return -1;
    80004110:	597d                	li	s2,-1
    80004112:	7b02                	ld	s6,32(sp)
    80004114:	6be2                	ld	s7,24(sp)
    80004116:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004118:	854a                	mv	a0,s2
    8000411a:	60e6                	ld	ra,88(sp)
    8000411c:	6446                	ld	s0,80(sp)
    8000411e:	64a6                	ld	s1,72(sp)
    80004120:	6906                	ld	s2,64(sp)
    80004122:	79e2                	ld	s3,56(sp)
    80004124:	7a42                	ld	s4,48(sp)
    80004126:	7aa2                	ld	s5,40(sp)
    80004128:	6125                	addi	sp,sp,96
    8000412a:	8082                	ret
      wakeup(&pi->nread);
    8000412c:	8562                	mv	a0,s8
    8000412e:	ffffd097          	auipc	ra,0xffffd
    80004132:	78c080e7          	jalr	1932(ra) # 800018ba <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004136:	85a6                	mv	a1,s1
    80004138:	855e                	mv	a0,s7
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	5f4080e7          	jalr	1524(ra) # 8000172e <sleep>
  while(i < n){
    80004142:	05495c63          	bge	s2,s4,8000419a <pipewrite+0xd8>
    if(pi->readopen == 0 || pr->killed){
    80004146:	2204a783          	lw	a5,544(s1)
    8000414a:	dfd5                	beqz	a5,80004106 <pipewrite+0x44>
    8000414c:	0289a783          	lw	a5,40(s3)
    80004150:	fbdd                	bnez	a5,80004106 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004152:	2184a783          	lw	a5,536(s1)
    80004156:	21c4a703          	lw	a4,540(s1)
    8000415a:	2007879b          	addiw	a5,a5,512
    8000415e:	fcf707e3          	beq	a4,a5,8000412c <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004162:	4685                	li	a3,1
    80004164:	01590633          	add	a2,s2,s5
    80004168:	faf40593          	addi	a1,s0,-81
    8000416c:	0509b503          	ld	a0,80(s3)
    80004170:	ffffd097          	auipc	ra,0xffffd
    80004174:	c20080e7          	jalr	-992(ra) # 80000d90 <copyin>
    80004178:	05650263          	beq	a0,s6,800041bc <pipewrite+0xfa>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000417c:	21c4a783          	lw	a5,540(s1)
    80004180:	0017871b          	addiw	a4,a5,1
    80004184:	20e4ae23          	sw	a4,540(s1)
    80004188:	1ff7f793          	andi	a5,a5,511
    8000418c:	97a6                	add	a5,a5,s1
    8000418e:	faf44703          	lbu	a4,-81(s0)
    80004192:	00e78c23          	sb	a4,24(a5)
      i++;
    80004196:	2905                	addiw	s2,s2,1
    80004198:	b76d                	j	80004142 <pipewrite+0x80>
    8000419a:	7b02                	ld	s6,32(sp)
    8000419c:	6be2                	ld	s7,24(sp)
    8000419e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800041a0:	21848513          	addi	a0,s1,536
    800041a4:	ffffd097          	auipc	ra,0xffffd
    800041a8:	716080e7          	jalr	1814(ra) # 800018ba <wakeup>
  release(&pi->lock);
    800041ac:	8526                	mv	a0,s1
    800041ae:	00002097          	auipc	ra,0x2
    800041b2:	35c080e7          	jalr	860(ra) # 8000650a <release>
  return i;
    800041b6:	b78d                	j	80004118 <pipewrite+0x56>
  int i = 0;
    800041b8:	4901                	li	s2,0
    800041ba:	b7dd                	j	800041a0 <pipewrite+0xde>
    800041bc:	7b02                	ld	s6,32(sp)
    800041be:	6be2                	ld	s7,24(sp)
    800041c0:	6c42                	ld	s8,16(sp)
    800041c2:	bff9                	j	800041a0 <pipewrite+0xde>

00000000800041c4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800041c4:	715d                	addi	sp,sp,-80
    800041c6:	e486                	sd	ra,72(sp)
    800041c8:	e0a2                	sd	s0,64(sp)
    800041ca:	fc26                	sd	s1,56(sp)
    800041cc:	f84a                	sd	s2,48(sp)
    800041ce:	f44e                	sd	s3,40(sp)
    800041d0:	f052                	sd	s4,32(sp)
    800041d2:	ec56                	sd	s5,24(sp)
    800041d4:	0880                	addi	s0,sp,80
    800041d6:	84aa                	mv	s1,a0
    800041d8:	892e                	mv	s2,a1
    800041da:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800041dc:	ffffd097          	auipc	ra,0xffffd
    800041e0:	e8c080e7          	jalr	-372(ra) # 80001068 <myproc>
    800041e4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800041e6:	8526                	mv	a0,s1
    800041e8:	00002097          	auipc	ra,0x2
    800041ec:	26e080e7          	jalr	622(ra) # 80006456 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041f0:	2184a703          	lw	a4,536(s1)
    800041f4:	21c4a783          	lw	a5,540(s1)
    if(pr->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800041f8:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800041fc:	02f71663          	bne	a4,a5,80004228 <piperead+0x64>
    80004200:	2244a783          	lw	a5,548(s1)
    80004204:	cb9d                	beqz	a5,8000423a <piperead+0x76>
    if(pr->killed){
    80004206:	028a2783          	lw	a5,40(s4)
    8000420a:	e38d                	bnez	a5,8000422c <piperead+0x68>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000420c:	85a6                	mv	a1,s1
    8000420e:	854e                	mv	a0,s3
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	51e080e7          	jalr	1310(ra) # 8000172e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004218:	2184a703          	lw	a4,536(s1)
    8000421c:	21c4a783          	lw	a5,540(s1)
    80004220:	fef700e3          	beq	a4,a5,80004200 <piperead+0x3c>
    80004224:	e85a                	sd	s6,16(sp)
    80004226:	a819                	j	8000423c <piperead+0x78>
    80004228:	e85a                	sd	s6,16(sp)
    8000422a:	a809                	j	8000423c <piperead+0x78>
      release(&pi->lock);
    8000422c:	8526                	mv	a0,s1
    8000422e:	00002097          	auipc	ra,0x2
    80004232:	2dc080e7          	jalr	732(ra) # 8000650a <release>
      return -1;
    80004236:	59fd                	li	s3,-1
    80004238:	a0a5                	j	800042a0 <piperead+0xdc>
    8000423a:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000423c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000423e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004240:	05505463          	blez	s5,80004288 <piperead+0xc4>
    if(pi->nread == pi->nwrite)
    80004244:	2184a783          	lw	a5,536(s1)
    80004248:	21c4a703          	lw	a4,540(s1)
    8000424c:	02f70e63          	beq	a4,a5,80004288 <piperead+0xc4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004250:	0017871b          	addiw	a4,a5,1
    80004254:	20e4ac23          	sw	a4,536(s1)
    80004258:	1ff7f793          	andi	a5,a5,511
    8000425c:	97a6                	add	a5,a5,s1
    8000425e:	0187c783          	lbu	a5,24(a5)
    80004262:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004266:	4685                	li	a3,1
    80004268:	fbf40613          	addi	a2,s0,-65
    8000426c:	85ca                	mv	a1,s2
    8000426e:	050a3503          	ld	a0,80(s4)
    80004272:	ffffd097          	auipc	ra,0xffffd
    80004276:	980080e7          	jalr	-1664(ra) # 80000bf2 <copyout>
    8000427a:	01650763          	beq	a0,s6,80004288 <piperead+0xc4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000427e:	2985                	addiw	s3,s3,1
    80004280:	0905                	addi	s2,s2,1
    80004282:	fd3a91e3          	bne	s5,s3,80004244 <piperead+0x80>
    80004286:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004288:	21c48513          	addi	a0,s1,540
    8000428c:	ffffd097          	auipc	ra,0xffffd
    80004290:	62e080e7          	jalr	1582(ra) # 800018ba <wakeup>
  release(&pi->lock);
    80004294:	8526                	mv	a0,s1
    80004296:	00002097          	auipc	ra,0x2
    8000429a:	274080e7          	jalr	628(ra) # 8000650a <release>
    8000429e:	6b42                	ld	s6,16(sp)
  return i;
}
    800042a0:	854e                	mv	a0,s3
    800042a2:	60a6                	ld	ra,72(sp)
    800042a4:	6406                	ld	s0,64(sp)
    800042a6:	74e2                	ld	s1,56(sp)
    800042a8:	7942                	ld	s2,48(sp)
    800042aa:	79a2                	ld	s3,40(sp)
    800042ac:	7a02                	ld	s4,32(sp)
    800042ae:	6ae2                	ld	s5,24(sp)
    800042b0:	6161                	addi	sp,sp,80
    800042b2:	8082                	ret

00000000800042b4 <exec>:

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset, uint sz);

int
exec(char *path, char **argv)
{
    800042b4:	df010113          	addi	sp,sp,-528
    800042b8:	20113423          	sd	ra,520(sp)
    800042bc:	20813023          	sd	s0,512(sp)
    800042c0:	ffa6                	sd	s1,504(sp)
    800042c2:	fbca                	sd	s2,496(sp)
    800042c4:	0c00                	addi	s0,sp,528
    800042c6:	892a                	mv	s2,a0
    800042c8:	dea43c23          	sd	a0,-520(s0)
    800042cc:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800042d0:	ffffd097          	auipc	ra,0xffffd
    800042d4:	d98080e7          	jalr	-616(ra) # 80001068 <myproc>
    800042d8:	84aa                	mv	s1,a0

  begin_op();
    800042da:	fffff097          	auipc	ra,0xfffff
    800042de:	460080e7          	jalr	1120(ra) # 8000373a <begin_op>

  if((ip = namei(path)) == 0){
    800042e2:	854a                	mv	a0,s2
    800042e4:	fffff097          	auipc	ra,0xfffff
    800042e8:	256080e7          	jalr	598(ra) # 8000353a <namei>
    800042ec:	c135                	beqz	a0,80004350 <exec+0x9c>
    800042ee:	f3d2                	sd	s4,480(sp)
    800042f0:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800042f2:	fffff097          	auipc	ra,0xfffff
    800042f6:	a76080e7          	jalr	-1418(ra) # 80002d68 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800042fa:	04000713          	li	a4,64
    800042fe:	4681                	li	a3,0
    80004300:	e5040613          	addi	a2,s0,-432
    80004304:	4581                	li	a1,0
    80004306:	8552                	mv	a0,s4
    80004308:	fffff097          	auipc	ra,0xfffff
    8000430c:	d18080e7          	jalr	-744(ra) # 80003020 <readi>
    80004310:	04000793          	li	a5,64
    80004314:	00f51a63          	bne	a0,a5,80004328 <exec+0x74>
    goto bad;
  if(elf.magic != ELF_MAGIC)
    80004318:	e5042703          	lw	a4,-432(s0)
    8000431c:	464c47b7          	lui	a5,0x464c4
    80004320:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004324:	02f70c63          	beq	a4,a5,8000435c <exec+0xa8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004328:	8552                	mv	a0,s4
    8000432a:	fffff097          	auipc	ra,0xfffff
    8000432e:	ca4080e7          	jalr	-860(ra) # 80002fce <iunlockput>
    end_op();
    80004332:	fffff097          	auipc	ra,0xfffff
    80004336:	482080e7          	jalr	1154(ra) # 800037b4 <end_op>
  }
  return -1;
    8000433a:	557d                	li	a0,-1
    8000433c:	7a1e                	ld	s4,480(sp)
}
    8000433e:	20813083          	ld	ra,520(sp)
    80004342:	20013403          	ld	s0,512(sp)
    80004346:	74fe                	ld	s1,504(sp)
    80004348:	795e                	ld	s2,496(sp)
    8000434a:	21010113          	addi	sp,sp,528
    8000434e:	8082                	ret
    end_op();
    80004350:	fffff097          	auipc	ra,0xfffff
    80004354:	464080e7          	jalr	1124(ra) # 800037b4 <end_op>
    return -1;
    80004358:	557d                	li	a0,-1
    8000435a:	b7d5                	j	8000433e <exec+0x8a>
    8000435c:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000435e:	8526                	mv	a0,s1
    80004360:	ffffd097          	auipc	ra,0xffffd
    80004364:	dcc080e7          	jalr	-564(ra) # 8000112c <proc_pagetable>
    80004368:	8b2a                	mv	s6,a0
    8000436a:	30050563          	beqz	a0,80004674 <exec+0x3c0>
    8000436e:	f7ce                	sd	s3,488(sp)
    80004370:	efd6                	sd	s5,472(sp)
    80004372:	e7de                	sd	s7,456(sp)
    80004374:	e3e2                	sd	s8,448(sp)
    80004376:	ff66                	sd	s9,440(sp)
    80004378:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000437a:	e7042d03          	lw	s10,-400(s0)
    8000437e:	e8845783          	lhu	a5,-376(s0)
    80004382:	14078563          	beqz	a5,800044cc <exec+0x218>
    80004386:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004388:	4481                	li	s1,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000438a:	4d81                	li	s11,0
    if((ph.vaddr % PGSIZE) != 0)
    8000438c:	6c85                	lui	s9,0x1
    8000438e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004392:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004396:	6a85                	lui	s5,0x1
    80004398:	a0b5                	j	80004404 <exec+0x150>
      panic("loadseg: address should exist");
    8000439a:	00004517          	auipc	a0,0x4
    8000439e:	1be50513          	addi	a0,a0,446 # 80008558 <etext+0x558>
    800043a2:	00002097          	auipc	ra,0x2
    800043a6:	b3a080e7          	jalr	-1222(ra) # 80005edc <panic>
    if(sz - i < PGSIZE)
    800043aa:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800043ac:	8726                	mv	a4,s1
    800043ae:	012c06bb          	addw	a3,s8,s2
    800043b2:	4581                	li	a1,0
    800043b4:	8552                	mv	a0,s4
    800043b6:	fffff097          	auipc	ra,0xfffff
    800043ba:	c6a080e7          	jalr	-918(ra) # 80003020 <readi>
    800043be:	2501                	sext.w	a0,a0
    800043c0:	26a49e63          	bne	s1,a0,8000463c <exec+0x388>
  for(i = 0; i < sz; i += PGSIZE){
    800043c4:	012a893b          	addw	s2,s5,s2
    800043c8:	03397563          	bgeu	s2,s3,800043f2 <exec+0x13e>
    pa = walkaddr(pagetable, va + i);
    800043cc:	02091593          	slli	a1,s2,0x20
    800043d0:	9181                	srli	a1,a1,0x20
    800043d2:	95de                	add	a1,a1,s7
    800043d4:	855a                	mv	a0,s6
    800043d6:	ffffc097          	auipc	ra,0xffffc
    800043da:	1d8080e7          	jalr	472(ra) # 800005ae <walkaddr>
    800043de:	862a                	mv	a2,a0
    if(pa == 0)
    800043e0:	dd4d                	beqz	a0,8000439a <exec+0xe6>
    if(sz - i < PGSIZE)
    800043e2:	412984bb          	subw	s1,s3,s2
    800043e6:	0004879b          	sext.w	a5,s1
    800043ea:	fcfcf0e3          	bgeu	s9,a5,800043aa <exec+0xf6>
    800043ee:	84d6                	mv	s1,s5
    800043f0:	bf6d                	j	800043aa <exec+0xf6>
    sz = sz1;
    800043f2:	e0843483          	ld	s1,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800043f6:	2d85                	addiw	s11,s11,1
    800043f8:	038d0d1b          	addiw	s10,s10,56 # fffffffffffff038 <end+0xffffffff7fdb5df8>
    800043fc:	e8845783          	lhu	a5,-376(s0)
    80004400:	06fddf63          	bge	s11,a5,8000447e <exec+0x1ca>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004404:	2d01                	sext.w	s10,s10
    80004406:	03800713          	li	a4,56
    8000440a:	86ea                	mv	a3,s10
    8000440c:	e1840613          	addi	a2,s0,-488
    80004410:	4581                	li	a1,0
    80004412:	8552                	mv	a0,s4
    80004414:	fffff097          	auipc	ra,0xfffff
    80004418:	c0c080e7          	jalr	-1012(ra) # 80003020 <readi>
    8000441c:	03800793          	li	a5,56
    80004420:	1ef51863          	bne	a0,a5,80004610 <exec+0x35c>
    if(ph.type != ELF_PROG_LOAD)
    80004424:	e1842783          	lw	a5,-488(s0)
    80004428:	4705                	li	a4,1
    8000442a:	fce796e3          	bne	a5,a4,800043f6 <exec+0x142>
    if(ph.memsz < ph.filesz)
    8000442e:	e4043603          	ld	a2,-448(s0)
    80004432:	e3843783          	ld	a5,-456(s0)
    80004436:	1ef66163          	bltu	a2,a5,80004618 <exec+0x364>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000443a:	e2843783          	ld	a5,-472(s0)
    8000443e:	963e                	add	a2,a2,a5
    80004440:	1ef66063          	bltu	a2,a5,80004620 <exec+0x36c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    80004444:	85a6                	mv	a1,s1
    80004446:	855a                	mv	a0,s6
    80004448:	ffffc097          	auipc	ra,0xffffc
    8000444c:	52a080e7          	jalr	1322(ra) # 80000972 <uvmalloc>
    80004450:	e0a43423          	sd	a0,-504(s0)
    80004454:	1c050a63          	beqz	a0,80004628 <exec+0x374>
    if((ph.vaddr % PGSIZE) != 0)
    80004458:	e2843b83          	ld	s7,-472(s0)
    8000445c:	df043783          	ld	a5,-528(s0)
    80004460:	00fbf7b3          	and	a5,s7,a5
    80004464:	1c079a63          	bnez	a5,80004638 <exec+0x384>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004468:	e2042c03          	lw	s8,-480(s0)
    8000446c:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004470:	00098463          	beqz	s3,80004478 <exec+0x1c4>
    80004474:	4901                	li	s2,0
    80004476:	bf99                	j	800043cc <exec+0x118>
    sz = sz1;
    80004478:	e0843483          	ld	s1,-504(s0)
    8000447c:	bfad                	j	800043f6 <exec+0x142>
    8000447e:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004480:	8552                	mv	a0,s4
    80004482:	fffff097          	auipc	ra,0xfffff
    80004486:	b4c080e7          	jalr	-1204(ra) # 80002fce <iunlockput>
  end_op();
    8000448a:	fffff097          	auipc	ra,0xfffff
    8000448e:	32a080e7          	jalr	810(ra) # 800037b4 <end_op>
  p = myproc();
    80004492:	ffffd097          	auipc	ra,0xffffd
    80004496:	bd6080e7          	jalr	-1066(ra) # 80001068 <myproc>
    8000449a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    8000449c:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    800044a0:	6985                	lui	s3,0x1
    800044a2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800044a4:	99a6                	add	s3,s3,s1
    800044a6:	77fd                	lui	a5,0xfffff
    800044a8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE)) == 0)
    800044ac:	6609                	lui	a2,0x2
    800044ae:	964e                	add	a2,a2,s3
    800044b0:	85ce                	mv	a1,s3
    800044b2:	855a                	mv	a0,s6
    800044b4:	ffffc097          	auipc	ra,0xffffc
    800044b8:	4be080e7          	jalr	1214(ra) # 80000972 <uvmalloc>
    800044bc:	892a                	mv	s2,a0
    800044be:	e0a43423          	sd	a0,-504(s0)
    800044c2:	e519                	bnez	a0,800044d0 <exec+0x21c>
  if(pagetable)
    800044c4:	e1343423          	sd	s3,-504(s0)
    800044c8:	4a01                	li	s4,0
    800044ca:	aa95                	j	8000463e <exec+0x38a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800044cc:	4481                	li	s1,0
    800044ce:	bf4d                	j	80004480 <exec+0x1cc>
  uvmclear(pagetable, sz-2*PGSIZE);
    800044d0:	75f9                	lui	a1,0xffffe
    800044d2:	95aa                	add	a1,a1,a0
    800044d4:	855a                	mv	a0,s6
    800044d6:	ffffc097          	auipc	ra,0xffffc
    800044da:	6ea080e7          	jalr	1770(ra) # 80000bc0 <uvmclear>
  stackbase = sp - PGSIZE;
    800044de:	7bfd                	lui	s7,0xfffff
    800044e0:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    800044e2:	e0043783          	ld	a5,-512(s0)
    800044e6:	6388                	ld	a0,0(a5)
    800044e8:	c52d                	beqz	a0,80004552 <exec+0x29e>
    800044ea:	e9040993          	addi	s3,s0,-368
    800044ee:	f9040c13          	addi	s8,s0,-112
    800044f2:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800044f4:	ffffc097          	auipc	ra,0xffffc
    800044f8:	eb0080e7          	jalr	-336(ra) # 800003a4 <strlen>
    800044fc:	0015079b          	addiw	a5,a0,1
    80004500:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004504:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004508:	13796463          	bltu	s2,s7,80004630 <exec+0x37c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000450c:	e0043d03          	ld	s10,-512(s0)
    80004510:	000d3a03          	ld	s4,0(s10)
    80004514:	8552                	mv	a0,s4
    80004516:	ffffc097          	auipc	ra,0xffffc
    8000451a:	e8e080e7          	jalr	-370(ra) # 800003a4 <strlen>
    8000451e:	0015069b          	addiw	a3,a0,1
    80004522:	8652                	mv	a2,s4
    80004524:	85ca                	mv	a1,s2
    80004526:	855a                	mv	a0,s6
    80004528:	ffffc097          	auipc	ra,0xffffc
    8000452c:	6ca080e7          	jalr	1738(ra) # 80000bf2 <copyout>
    80004530:	10054263          	bltz	a0,80004634 <exec+0x380>
    ustack[argc] = sp;
    80004534:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004538:	0485                	addi	s1,s1,1
    8000453a:	008d0793          	addi	a5,s10,8
    8000453e:	e0f43023          	sd	a5,-512(s0)
    80004542:	008d3503          	ld	a0,8(s10)
    80004546:	c909                	beqz	a0,80004558 <exec+0x2a4>
    if(argc >= MAXARG)
    80004548:	09a1                	addi	s3,s3,8
    8000454a:	fb8995e3          	bne	s3,s8,800044f4 <exec+0x240>
  ip = 0;
    8000454e:	4a01                	li	s4,0
    80004550:	a0fd                	j	8000463e <exec+0x38a>
  sp = sz;
    80004552:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004556:	4481                	li	s1,0
  ustack[argc] = 0;
    80004558:	00349793          	slli	a5,s1,0x3
    8000455c:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fdb5d50>
    80004560:	97a2                	add	a5,a5,s0
    80004562:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004566:	00148693          	addi	a3,s1,1
    8000456a:	068e                	slli	a3,a3,0x3
    8000456c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004570:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004574:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004578:	f57966e3          	bltu	s2,s7,800044c4 <exec+0x210>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000457c:	e9040613          	addi	a2,s0,-368
    80004580:	85ca                	mv	a1,s2
    80004582:	855a                	mv	a0,s6
    80004584:	ffffc097          	auipc	ra,0xffffc
    80004588:	66e080e7          	jalr	1646(ra) # 80000bf2 <copyout>
    8000458c:	0e054663          	bltz	a0,80004678 <exec+0x3c4>
  p->trapframe->a1 = sp;
    80004590:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004594:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004598:	df843783          	ld	a5,-520(s0)
    8000459c:	0007c703          	lbu	a4,0(a5)
    800045a0:	cf11                	beqz	a4,800045bc <exec+0x308>
    800045a2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800045a4:	02f00693          	li	a3,47
    800045a8:	a039                	j	800045b6 <exec+0x302>
      last = s+1;
    800045aa:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800045ae:	0785                	addi	a5,a5,1
    800045b0:	fff7c703          	lbu	a4,-1(a5)
    800045b4:	c701                	beqz	a4,800045bc <exec+0x308>
    if(*s == '/')
    800045b6:	fed71ce3          	bne	a4,a3,800045ae <exec+0x2fa>
    800045ba:	bfc5                	j	800045aa <exec+0x2f6>
  safestrcpy(p->name, last, sizeof(p->name));
    800045bc:	4641                	li	a2,16
    800045be:	df843583          	ld	a1,-520(s0)
    800045c2:	158a8513          	addi	a0,s5,344
    800045c6:	ffffc097          	auipc	ra,0xffffc
    800045ca:	dac080e7          	jalr	-596(ra) # 80000372 <safestrcpy>
  oldpagetable = p->pagetable;
    800045ce:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800045d2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800045d6:	e0843783          	ld	a5,-504(s0)
    800045da:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800045de:	058ab783          	ld	a5,88(s5)
    800045e2:	e6843703          	ld	a4,-408(s0)
    800045e6:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800045e8:	058ab783          	ld	a5,88(s5)
    800045ec:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800045f0:	85e6                	mv	a1,s9
    800045f2:	ffffd097          	auipc	ra,0xffffd
    800045f6:	bd6080e7          	jalr	-1066(ra) # 800011c8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800045fa:	0004851b          	sext.w	a0,s1
    800045fe:	79be                	ld	s3,488(sp)
    80004600:	7a1e                	ld	s4,480(sp)
    80004602:	6afe                	ld	s5,472(sp)
    80004604:	6b5e                	ld	s6,464(sp)
    80004606:	6bbe                	ld	s7,456(sp)
    80004608:	6c1e                	ld	s8,448(sp)
    8000460a:	7cfa                	ld	s9,440(sp)
    8000460c:	7d5a                	ld	s10,432(sp)
    8000460e:	bb05                	j	8000433e <exec+0x8a>
    80004610:	e0943423          	sd	s1,-504(s0)
    80004614:	7dba                	ld	s11,424(sp)
    80004616:	a025                	j	8000463e <exec+0x38a>
    80004618:	e0943423          	sd	s1,-504(s0)
    8000461c:	7dba                	ld	s11,424(sp)
    8000461e:	a005                	j	8000463e <exec+0x38a>
    80004620:	e0943423          	sd	s1,-504(s0)
    80004624:	7dba                	ld	s11,424(sp)
    80004626:	a821                	j	8000463e <exec+0x38a>
    80004628:	e0943423          	sd	s1,-504(s0)
    8000462c:	7dba                	ld	s11,424(sp)
    8000462e:	a801                	j	8000463e <exec+0x38a>
  ip = 0;
    80004630:	4a01                	li	s4,0
    80004632:	a031                	j	8000463e <exec+0x38a>
    80004634:	4a01                	li	s4,0
  if(pagetable)
    80004636:	a021                	j	8000463e <exec+0x38a>
    80004638:	7dba                	ld	s11,424(sp)
    8000463a:	a011                	j	8000463e <exec+0x38a>
    8000463c:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    8000463e:	e0843583          	ld	a1,-504(s0)
    80004642:	855a                	mv	a0,s6
    80004644:	ffffd097          	auipc	ra,0xffffd
    80004648:	b84080e7          	jalr	-1148(ra) # 800011c8 <proc_freepagetable>
  return -1;
    8000464c:	557d                	li	a0,-1
  if(ip){
    8000464e:	000a1b63          	bnez	s4,80004664 <exec+0x3b0>
    80004652:	79be                	ld	s3,488(sp)
    80004654:	7a1e                	ld	s4,480(sp)
    80004656:	6afe                	ld	s5,472(sp)
    80004658:	6b5e                	ld	s6,464(sp)
    8000465a:	6bbe                	ld	s7,456(sp)
    8000465c:	6c1e                	ld	s8,448(sp)
    8000465e:	7cfa                	ld	s9,440(sp)
    80004660:	7d5a                	ld	s10,432(sp)
    80004662:	b9f1                	j	8000433e <exec+0x8a>
    80004664:	79be                	ld	s3,488(sp)
    80004666:	6afe                	ld	s5,472(sp)
    80004668:	6b5e                	ld	s6,464(sp)
    8000466a:	6bbe                	ld	s7,456(sp)
    8000466c:	6c1e                	ld	s8,448(sp)
    8000466e:	7cfa                	ld	s9,440(sp)
    80004670:	7d5a                	ld	s10,432(sp)
    80004672:	b95d                	j	80004328 <exec+0x74>
    80004674:	6b5e                	ld	s6,464(sp)
    80004676:	b94d                	j	80004328 <exec+0x74>
  sz = sz1;
    80004678:	e0843983          	ld	s3,-504(s0)
    8000467c:	b5a1                	j	800044c4 <exec+0x210>

000000008000467e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000467e:	7179                	addi	sp,sp,-48
    80004680:	f406                	sd	ra,40(sp)
    80004682:	f022                	sd	s0,32(sp)
    80004684:	ec26                	sd	s1,24(sp)
    80004686:	e84a                	sd	s2,16(sp)
    80004688:	1800                	addi	s0,sp,48
    8000468a:	892e                	mv	s2,a1
    8000468c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000468e:	fdc40593          	addi	a1,s0,-36
    80004692:	ffffe097          	auipc	ra,0xffffe
    80004696:	b64080e7          	jalr	-1180(ra) # 800021f6 <argint>
    8000469a:	04054063          	bltz	a0,800046da <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000469e:	fdc42703          	lw	a4,-36(s0)
    800046a2:	47bd                	li	a5,15
    800046a4:	02e7ed63          	bltu	a5,a4,800046de <argfd+0x60>
    800046a8:	ffffd097          	auipc	ra,0xffffd
    800046ac:	9c0080e7          	jalr	-1600(ra) # 80001068 <myproc>
    800046b0:	fdc42703          	lw	a4,-36(s0)
    800046b4:	01a70793          	addi	a5,a4,26
    800046b8:	078e                	slli	a5,a5,0x3
    800046ba:	953e                	add	a0,a0,a5
    800046bc:	611c                	ld	a5,0(a0)
    800046be:	c395                	beqz	a5,800046e2 <argfd+0x64>
    return -1;
  if(pfd)
    800046c0:	00090463          	beqz	s2,800046c8 <argfd+0x4a>
    *pfd = fd;
    800046c4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800046c8:	4501                	li	a0,0
  if(pf)
    800046ca:	c091                	beqz	s1,800046ce <argfd+0x50>
    *pf = f;
    800046cc:	e09c                	sd	a5,0(s1)
}
    800046ce:	70a2                	ld	ra,40(sp)
    800046d0:	7402                	ld	s0,32(sp)
    800046d2:	64e2                	ld	s1,24(sp)
    800046d4:	6942                	ld	s2,16(sp)
    800046d6:	6145                	addi	sp,sp,48
    800046d8:	8082                	ret
    return -1;
    800046da:	557d                	li	a0,-1
    800046dc:	bfcd                	j	800046ce <argfd+0x50>
    return -1;
    800046de:	557d                	li	a0,-1
    800046e0:	b7fd                	j	800046ce <argfd+0x50>
    800046e2:	557d                	li	a0,-1
    800046e4:	b7ed                	j	800046ce <argfd+0x50>

00000000800046e6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800046e6:	1101                	addi	sp,sp,-32
    800046e8:	ec06                	sd	ra,24(sp)
    800046ea:	e822                	sd	s0,16(sp)
    800046ec:	e426                	sd	s1,8(sp)
    800046ee:	1000                	addi	s0,sp,32
    800046f0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800046f2:	ffffd097          	auipc	ra,0xffffd
    800046f6:	976080e7          	jalr	-1674(ra) # 80001068 <myproc>
    800046fa:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800046fc:	0d050793          	addi	a5,a0,208
    80004700:	4501                	li	a0,0
    80004702:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004704:	6398                	ld	a4,0(a5)
    80004706:	cb19                	beqz	a4,8000471c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80004708:	2505                	addiw	a0,a0,1
    8000470a:	07a1                	addi	a5,a5,8
    8000470c:	fed51ce3          	bne	a0,a3,80004704 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004710:	557d                	li	a0,-1
}
    80004712:	60e2                	ld	ra,24(sp)
    80004714:	6442                	ld	s0,16(sp)
    80004716:	64a2                	ld	s1,8(sp)
    80004718:	6105                	addi	sp,sp,32
    8000471a:	8082                	ret
      p->ofile[fd] = f;
    8000471c:	01a50793          	addi	a5,a0,26
    80004720:	078e                	slli	a5,a5,0x3
    80004722:	963e                	add	a2,a2,a5
    80004724:	e204                	sd	s1,0(a2)
      return fd;
    80004726:	b7f5                	j	80004712 <fdalloc+0x2c>

0000000080004728 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004728:	715d                	addi	sp,sp,-80
    8000472a:	e486                	sd	ra,72(sp)
    8000472c:	e0a2                	sd	s0,64(sp)
    8000472e:	fc26                	sd	s1,56(sp)
    80004730:	f84a                	sd	s2,48(sp)
    80004732:	f44e                	sd	s3,40(sp)
    80004734:	f052                	sd	s4,32(sp)
    80004736:	ec56                	sd	s5,24(sp)
    80004738:	0880                	addi	s0,sp,80
    8000473a:	8aae                	mv	s5,a1
    8000473c:	8a32                	mv	s4,a2
    8000473e:	89b6                	mv	s3,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004740:	fb040593          	addi	a1,s0,-80
    80004744:	fffff097          	auipc	ra,0xfffff
    80004748:	e14080e7          	jalr	-492(ra) # 80003558 <nameiparent>
    8000474c:	892a                	mv	s2,a0
    8000474e:	12050c63          	beqz	a0,80004886 <create+0x15e>
    return 0;

  ilock(dp);
    80004752:	ffffe097          	auipc	ra,0xffffe
    80004756:	616080e7          	jalr	1558(ra) # 80002d68 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000475a:	4601                	li	a2,0
    8000475c:	fb040593          	addi	a1,s0,-80
    80004760:	854a                	mv	a0,s2
    80004762:	fffff097          	auipc	ra,0xfffff
    80004766:	b06080e7          	jalr	-1274(ra) # 80003268 <dirlookup>
    8000476a:	84aa                	mv	s1,a0
    8000476c:	c539                	beqz	a0,800047ba <create+0x92>
    iunlockput(dp);
    8000476e:	854a                	mv	a0,s2
    80004770:	fffff097          	auipc	ra,0xfffff
    80004774:	85e080e7          	jalr	-1954(ra) # 80002fce <iunlockput>
    ilock(ip);
    80004778:	8526                	mv	a0,s1
    8000477a:	ffffe097          	auipc	ra,0xffffe
    8000477e:	5ee080e7          	jalr	1518(ra) # 80002d68 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004782:	4789                	li	a5,2
    80004784:	02fa9463          	bne	s5,a5,800047ac <create+0x84>
    80004788:	0444d783          	lhu	a5,68(s1)
    8000478c:	37f9                	addiw	a5,a5,-2
    8000478e:	17c2                	slli	a5,a5,0x30
    80004790:	93c1                	srli	a5,a5,0x30
    80004792:	4705                	li	a4,1
    80004794:	00f76c63          	bltu	a4,a5,800047ac <create+0x84>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80004798:	8526                	mv	a0,s1
    8000479a:	60a6                	ld	ra,72(sp)
    8000479c:	6406                	ld	s0,64(sp)
    8000479e:	74e2                	ld	s1,56(sp)
    800047a0:	7942                	ld	s2,48(sp)
    800047a2:	79a2                	ld	s3,40(sp)
    800047a4:	7a02                	ld	s4,32(sp)
    800047a6:	6ae2                	ld	s5,24(sp)
    800047a8:	6161                	addi	sp,sp,80
    800047aa:	8082                	ret
    iunlockput(ip);
    800047ac:	8526                	mv	a0,s1
    800047ae:	fffff097          	auipc	ra,0xfffff
    800047b2:	820080e7          	jalr	-2016(ra) # 80002fce <iunlockput>
    return 0;
    800047b6:	4481                	li	s1,0
    800047b8:	b7c5                	j	80004798 <create+0x70>
  if((ip = ialloc(dp->dev, type)) == 0)
    800047ba:	85d6                	mv	a1,s5
    800047bc:	00092503          	lw	a0,0(s2)
    800047c0:	ffffe097          	auipc	ra,0xffffe
    800047c4:	414080e7          	jalr	1044(ra) # 80002bd4 <ialloc>
    800047c8:	84aa                	mv	s1,a0
    800047ca:	c139                	beqz	a0,80004810 <create+0xe8>
  ilock(ip);
    800047cc:	ffffe097          	auipc	ra,0xffffe
    800047d0:	59c080e7          	jalr	1436(ra) # 80002d68 <ilock>
  ip->major = major;
    800047d4:	05449323          	sh	s4,70(s1)
  ip->minor = minor;
    800047d8:	05349423          	sh	s3,72(s1)
  ip->nlink = 1;
    800047dc:	4985                	li	s3,1
    800047de:	05349523          	sh	s3,74(s1)
  iupdate(ip);
    800047e2:	8526                	mv	a0,s1
    800047e4:	ffffe097          	auipc	ra,0xffffe
    800047e8:	4b8080e7          	jalr	1208(ra) # 80002c9c <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800047ec:	033a8a63          	beq	s5,s3,80004820 <create+0xf8>
  if(dirlink(dp, name, ip->inum) < 0)
    800047f0:	40d0                	lw	a2,4(s1)
    800047f2:	fb040593          	addi	a1,s0,-80
    800047f6:	854a                	mv	a0,s2
    800047f8:	fffff097          	auipc	ra,0xfffff
    800047fc:	c80080e7          	jalr	-896(ra) # 80003478 <dirlink>
    80004800:	06054b63          	bltz	a0,80004876 <create+0x14e>
  iunlockput(dp);
    80004804:	854a                	mv	a0,s2
    80004806:	ffffe097          	auipc	ra,0xffffe
    8000480a:	7c8080e7          	jalr	1992(ra) # 80002fce <iunlockput>
  return ip;
    8000480e:	b769                	j	80004798 <create+0x70>
    panic("create: ialloc");
    80004810:	00004517          	auipc	a0,0x4
    80004814:	d6850513          	addi	a0,a0,-664 # 80008578 <etext+0x578>
    80004818:	00001097          	auipc	ra,0x1
    8000481c:	6c4080e7          	jalr	1732(ra) # 80005edc <panic>
    dp->nlink++;  // for ".."
    80004820:	04a95783          	lhu	a5,74(s2)
    80004824:	2785                	addiw	a5,a5,1
    80004826:	04f91523          	sh	a5,74(s2)
    iupdate(dp);
    8000482a:	854a                	mv	a0,s2
    8000482c:	ffffe097          	auipc	ra,0xffffe
    80004830:	470080e7          	jalr	1136(ra) # 80002c9c <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004834:	40d0                	lw	a2,4(s1)
    80004836:	00004597          	auipc	a1,0x4
    8000483a:	d5258593          	addi	a1,a1,-686 # 80008588 <etext+0x588>
    8000483e:	8526                	mv	a0,s1
    80004840:	fffff097          	auipc	ra,0xfffff
    80004844:	c38080e7          	jalr	-968(ra) # 80003478 <dirlink>
    80004848:	00054f63          	bltz	a0,80004866 <create+0x13e>
    8000484c:	00492603          	lw	a2,4(s2)
    80004850:	00004597          	auipc	a1,0x4
    80004854:	d4058593          	addi	a1,a1,-704 # 80008590 <etext+0x590>
    80004858:	8526                	mv	a0,s1
    8000485a:	fffff097          	auipc	ra,0xfffff
    8000485e:	c1e080e7          	jalr	-994(ra) # 80003478 <dirlink>
    80004862:	f80557e3          	bgez	a0,800047f0 <create+0xc8>
      panic("create dots");
    80004866:	00004517          	auipc	a0,0x4
    8000486a:	d3250513          	addi	a0,a0,-718 # 80008598 <etext+0x598>
    8000486e:	00001097          	auipc	ra,0x1
    80004872:	66e080e7          	jalr	1646(ra) # 80005edc <panic>
    panic("create: dirlink");
    80004876:	00004517          	auipc	a0,0x4
    8000487a:	d3250513          	addi	a0,a0,-718 # 800085a8 <etext+0x5a8>
    8000487e:	00001097          	auipc	ra,0x1
    80004882:	65e080e7          	jalr	1630(ra) # 80005edc <panic>
    return 0;
    80004886:	84aa                	mv	s1,a0
    80004888:	bf01                	j	80004798 <create+0x70>

000000008000488a <sys_dup>:
{
    8000488a:	7179                	addi	sp,sp,-48
    8000488c:	f406                	sd	ra,40(sp)
    8000488e:	f022                	sd	s0,32(sp)
    80004890:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004892:	fd840613          	addi	a2,s0,-40
    80004896:	4581                	li	a1,0
    80004898:	4501                	li	a0,0
    8000489a:	00000097          	auipc	ra,0x0
    8000489e:	de4080e7          	jalr	-540(ra) # 8000467e <argfd>
    return -1;
    800048a2:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800048a4:	02054763          	bltz	a0,800048d2 <sys_dup+0x48>
    800048a8:	ec26                	sd	s1,24(sp)
    800048aa:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800048ac:	fd843903          	ld	s2,-40(s0)
    800048b0:	854a                	mv	a0,s2
    800048b2:	00000097          	auipc	ra,0x0
    800048b6:	e34080e7          	jalr	-460(ra) # 800046e6 <fdalloc>
    800048ba:	84aa                	mv	s1,a0
    return -1;
    800048bc:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800048be:	00054f63          	bltz	a0,800048dc <sys_dup+0x52>
  filedup(f);
    800048c2:	854a                	mv	a0,s2
    800048c4:	fffff097          	auipc	ra,0xfffff
    800048c8:	2ee080e7          	jalr	750(ra) # 80003bb2 <filedup>
  return fd;
    800048cc:	87a6                	mv	a5,s1
    800048ce:	64e2                	ld	s1,24(sp)
    800048d0:	6942                	ld	s2,16(sp)
}
    800048d2:	853e                	mv	a0,a5
    800048d4:	70a2                	ld	ra,40(sp)
    800048d6:	7402                	ld	s0,32(sp)
    800048d8:	6145                	addi	sp,sp,48
    800048da:	8082                	ret
    800048dc:	64e2                	ld	s1,24(sp)
    800048de:	6942                	ld	s2,16(sp)
    800048e0:	bfcd                	j	800048d2 <sys_dup+0x48>

00000000800048e2 <sys_read>:
{
    800048e2:	7179                	addi	sp,sp,-48
    800048e4:	f406                	sd	ra,40(sp)
    800048e6:	f022                	sd	s0,32(sp)
    800048e8:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048ea:	fe840613          	addi	a2,s0,-24
    800048ee:	4581                	li	a1,0
    800048f0:	4501                	li	a0,0
    800048f2:	00000097          	auipc	ra,0x0
    800048f6:	d8c080e7          	jalr	-628(ra) # 8000467e <argfd>
    return -1;
    800048fa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800048fc:	04054163          	bltz	a0,8000493e <sys_read+0x5c>
    80004900:	fe440593          	addi	a1,s0,-28
    80004904:	4509                	li	a0,2
    80004906:	ffffe097          	auipc	ra,0xffffe
    8000490a:	8f0080e7          	jalr	-1808(ra) # 800021f6 <argint>
    return -1;
    8000490e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004910:	02054763          	bltz	a0,8000493e <sys_read+0x5c>
    80004914:	fd840593          	addi	a1,s0,-40
    80004918:	4505                	li	a0,1
    8000491a:	ffffe097          	auipc	ra,0xffffe
    8000491e:	8fe080e7          	jalr	-1794(ra) # 80002218 <argaddr>
    return -1;
    80004922:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004924:	00054d63          	bltz	a0,8000493e <sys_read+0x5c>
  return fileread(f, p, n);
    80004928:	fe442603          	lw	a2,-28(s0)
    8000492c:	fd843583          	ld	a1,-40(s0)
    80004930:	fe843503          	ld	a0,-24(s0)
    80004934:	fffff097          	auipc	ra,0xfffff
    80004938:	424080e7          	jalr	1060(ra) # 80003d58 <fileread>
    8000493c:	87aa                	mv	a5,a0
}
    8000493e:	853e                	mv	a0,a5
    80004940:	70a2                	ld	ra,40(sp)
    80004942:	7402                	ld	s0,32(sp)
    80004944:	6145                	addi	sp,sp,48
    80004946:	8082                	ret

0000000080004948 <sys_write>:
{
    80004948:	7179                	addi	sp,sp,-48
    8000494a:	f406                	sd	ra,40(sp)
    8000494c:	f022                	sd	s0,32(sp)
    8000494e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004950:	fe840613          	addi	a2,s0,-24
    80004954:	4581                	li	a1,0
    80004956:	4501                	li	a0,0
    80004958:	00000097          	auipc	ra,0x0
    8000495c:	d26080e7          	jalr	-730(ra) # 8000467e <argfd>
    return -1;
    80004960:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004962:	04054163          	bltz	a0,800049a4 <sys_write+0x5c>
    80004966:	fe440593          	addi	a1,s0,-28
    8000496a:	4509                	li	a0,2
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	88a080e7          	jalr	-1910(ra) # 800021f6 <argint>
    return -1;
    80004974:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80004976:	02054763          	bltz	a0,800049a4 <sys_write+0x5c>
    8000497a:	fd840593          	addi	a1,s0,-40
    8000497e:	4505                	li	a0,1
    80004980:	ffffe097          	auipc	ra,0xffffe
    80004984:	898080e7          	jalr	-1896(ra) # 80002218 <argaddr>
    return -1;
    80004988:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000498a:	00054d63          	bltz	a0,800049a4 <sys_write+0x5c>
  return filewrite(f, p, n);
    8000498e:	fe442603          	lw	a2,-28(s0)
    80004992:	fd843583          	ld	a1,-40(s0)
    80004996:	fe843503          	ld	a0,-24(s0)
    8000499a:	fffff097          	auipc	ra,0xfffff
    8000499e:	490080e7          	jalr	1168(ra) # 80003e2a <filewrite>
    800049a2:	87aa                	mv	a5,a0
}
    800049a4:	853e                	mv	a0,a5
    800049a6:	70a2                	ld	ra,40(sp)
    800049a8:	7402                	ld	s0,32(sp)
    800049aa:	6145                	addi	sp,sp,48
    800049ac:	8082                	ret

00000000800049ae <sys_close>:
{
    800049ae:	1101                	addi	sp,sp,-32
    800049b0:	ec06                	sd	ra,24(sp)
    800049b2:	e822                	sd	s0,16(sp)
    800049b4:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800049b6:	fe040613          	addi	a2,s0,-32
    800049ba:	fec40593          	addi	a1,s0,-20
    800049be:	4501                	li	a0,0
    800049c0:	00000097          	auipc	ra,0x0
    800049c4:	cbe080e7          	jalr	-834(ra) # 8000467e <argfd>
    return -1;
    800049c8:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800049ca:	02054463          	bltz	a0,800049f2 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    800049ce:	ffffc097          	auipc	ra,0xffffc
    800049d2:	69a080e7          	jalr	1690(ra) # 80001068 <myproc>
    800049d6:	fec42783          	lw	a5,-20(s0)
    800049da:	07e9                	addi	a5,a5,26
    800049dc:	078e                	slli	a5,a5,0x3
    800049de:	953e                	add	a0,a0,a5
    800049e0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800049e4:	fe043503          	ld	a0,-32(s0)
    800049e8:	fffff097          	auipc	ra,0xfffff
    800049ec:	21c080e7          	jalr	540(ra) # 80003c04 <fileclose>
  return 0;
    800049f0:	4781                	li	a5,0
}
    800049f2:	853e                	mv	a0,a5
    800049f4:	60e2                	ld	ra,24(sp)
    800049f6:	6442                	ld	s0,16(sp)
    800049f8:	6105                	addi	sp,sp,32
    800049fa:	8082                	ret

00000000800049fc <sys_fstat>:
{
    800049fc:	1101                	addi	sp,sp,-32
    800049fe:	ec06                	sd	ra,24(sp)
    80004a00:	e822                	sd	s0,16(sp)
    80004a02:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a04:	fe840613          	addi	a2,s0,-24
    80004a08:	4581                	li	a1,0
    80004a0a:	4501                	li	a0,0
    80004a0c:	00000097          	auipc	ra,0x0
    80004a10:	c72080e7          	jalr	-910(ra) # 8000467e <argfd>
    return -1;
    80004a14:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a16:	02054563          	bltz	a0,80004a40 <sys_fstat+0x44>
    80004a1a:	fe040593          	addi	a1,s0,-32
    80004a1e:	4505                	li	a0,1
    80004a20:	ffffd097          	auipc	ra,0xffffd
    80004a24:	7f8080e7          	jalr	2040(ra) # 80002218 <argaddr>
    return -1;
    80004a28:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    80004a2a:	00054b63          	bltz	a0,80004a40 <sys_fstat+0x44>
  return filestat(f, st);
    80004a2e:	fe043583          	ld	a1,-32(s0)
    80004a32:	fe843503          	ld	a0,-24(s0)
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	2b0080e7          	jalr	688(ra) # 80003ce6 <filestat>
    80004a3e:	87aa                	mv	a5,a0
}
    80004a40:	853e                	mv	a0,a5
    80004a42:	60e2                	ld	ra,24(sp)
    80004a44:	6442                	ld	s0,16(sp)
    80004a46:	6105                	addi	sp,sp,32
    80004a48:	8082                	ret

0000000080004a4a <sys_link>:
{
    80004a4a:	7169                	addi	sp,sp,-304
    80004a4c:	f606                	sd	ra,296(sp)
    80004a4e:	f222                	sd	s0,288(sp)
    80004a50:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a52:	08000613          	li	a2,128
    80004a56:	ed040593          	addi	a1,s0,-304
    80004a5a:	4501                	li	a0,0
    80004a5c:	ffffd097          	auipc	ra,0xffffd
    80004a60:	7de080e7          	jalr	2014(ra) # 8000223a <argstr>
    return -1;
    80004a64:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a66:	12054663          	bltz	a0,80004b92 <sys_link+0x148>
    80004a6a:	08000613          	li	a2,128
    80004a6e:	f5040593          	addi	a1,s0,-176
    80004a72:	4505                	li	a0,1
    80004a74:	ffffd097          	auipc	ra,0xffffd
    80004a78:	7c6080e7          	jalr	1990(ra) # 8000223a <argstr>
    return -1;
    80004a7c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004a7e:	10054a63          	bltz	a0,80004b92 <sys_link+0x148>
    80004a82:	ee26                	sd	s1,280(sp)
  begin_op();
    80004a84:	fffff097          	auipc	ra,0xfffff
    80004a88:	cb6080e7          	jalr	-842(ra) # 8000373a <begin_op>
  if((ip = namei(old)) == 0){
    80004a8c:	ed040513          	addi	a0,s0,-304
    80004a90:	fffff097          	auipc	ra,0xfffff
    80004a94:	aaa080e7          	jalr	-1366(ra) # 8000353a <namei>
    80004a98:	84aa                	mv	s1,a0
    80004a9a:	c949                	beqz	a0,80004b2c <sys_link+0xe2>
  ilock(ip);
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	2cc080e7          	jalr	716(ra) # 80002d68 <ilock>
  if(ip->type == T_DIR){
    80004aa4:	04449703          	lh	a4,68(s1)
    80004aa8:	4785                	li	a5,1
    80004aaa:	08f70863          	beq	a4,a5,80004b3a <sys_link+0xf0>
    80004aae:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ab0:	04a4d783          	lhu	a5,74(s1)
    80004ab4:	2785                	addiw	a5,a5,1
    80004ab6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	1e0080e7          	jalr	480(ra) # 80002c9c <iupdate>
  iunlock(ip);
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	368080e7          	jalr	872(ra) # 80002e2e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004ace:	fd040593          	addi	a1,s0,-48
    80004ad2:	f5040513          	addi	a0,s0,-176
    80004ad6:	fffff097          	auipc	ra,0xfffff
    80004ada:	a82080e7          	jalr	-1406(ra) # 80003558 <nameiparent>
    80004ade:	892a                	mv	s2,a0
    80004ae0:	cd35                	beqz	a0,80004b5c <sys_link+0x112>
  ilock(dp);
    80004ae2:	ffffe097          	auipc	ra,0xffffe
    80004ae6:	286080e7          	jalr	646(ra) # 80002d68 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004aea:	00092703          	lw	a4,0(s2)
    80004aee:	409c                	lw	a5,0(s1)
    80004af0:	06f71163          	bne	a4,a5,80004b52 <sys_link+0x108>
    80004af4:	40d0                	lw	a2,4(s1)
    80004af6:	fd040593          	addi	a1,s0,-48
    80004afa:	854a                	mv	a0,s2
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	97c080e7          	jalr	-1668(ra) # 80003478 <dirlink>
    80004b04:	04054763          	bltz	a0,80004b52 <sys_link+0x108>
  iunlockput(dp);
    80004b08:	854a                	mv	a0,s2
    80004b0a:	ffffe097          	auipc	ra,0xffffe
    80004b0e:	4c4080e7          	jalr	1220(ra) # 80002fce <iunlockput>
  iput(ip);
    80004b12:	8526                	mv	a0,s1
    80004b14:	ffffe097          	auipc	ra,0xffffe
    80004b18:	412080e7          	jalr	1042(ra) # 80002f26 <iput>
  end_op();
    80004b1c:	fffff097          	auipc	ra,0xfffff
    80004b20:	c98080e7          	jalr	-872(ra) # 800037b4 <end_op>
  return 0;
    80004b24:	4781                	li	a5,0
    80004b26:	64f2                	ld	s1,280(sp)
    80004b28:	6952                	ld	s2,272(sp)
    80004b2a:	a0a5                	j	80004b92 <sys_link+0x148>
    end_op();
    80004b2c:	fffff097          	auipc	ra,0xfffff
    80004b30:	c88080e7          	jalr	-888(ra) # 800037b4 <end_op>
    return -1;
    80004b34:	57fd                	li	a5,-1
    80004b36:	64f2                	ld	s1,280(sp)
    80004b38:	a8a9                	j	80004b92 <sys_link+0x148>
    iunlockput(ip);
    80004b3a:	8526                	mv	a0,s1
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	492080e7          	jalr	1170(ra) # 80002fce <iunlockput>
    end_op();
    80004b44:	fffff097          	auipc	ra,0xfffff
    80004b48:	c70080e7          	jalr	-912(ra) # 800037b4 <end_op>
    return -1;
    80004b4c:	57fd                	li	a5,-1
    80004b4e:	64f2                	ld	s1,280(sp)
    80004b50:	a089                	j	80004b92 <sys_link+0x148>
    iunlockput(dp);
    80004b52:	854a                	mv	a0,s2
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	47a080e7          	jalr	1146(ra) # 80002fce <iunlockput>
  ilock(ip);
    80004b5c:	8526                	mv	a0,s1
    80004b5e:	ffffe097          	auipc	ra,0xffffe
    80004b62:	20a080e7          	jalr	522(ra) # 80002d68 <ilock>
  ip->nlink--;
    80004b66:	04a4d783          	lhu	a5,74(s1)
    80004b6a:	37fd                	addiw	a5,a5,-1
    80004b6c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004b70:	8526                	mv	a0,s1
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	12a080e7          	jalr	298(ra) # 80002c9c <iupdate>
  iunlockput(ip);
    80004b7a:	8526                	mv	a0,s1
    80004b7c:	ffffe097          	auipc	ra,0xffffe
    80004b80:	452080e7          	jalr	1106(ra) # 80002fce <iunlockput>
  end_op();
    80004b84:	fffff097          	auipc	ra,0xfffff
    80004b88:	c30080e7          	jalr	-976(ra) # 800037b4 <end_op>
  return -1;
    80004b8c:	57fd                	li	a5,-1
    80004b8e:	64f2                	ld	s1,280(sp)
    80004b90:	6952                	ld	s2,272(sp)
}
    80004b92:	853e                	mv	a0,a5
    80004b94:	70b2                	ld	ra,296(sp)
    80004b96:	7412                	ld	s0,288(sp)
    80004b98:	6155                	addi	sp,sp,304
    80004b9a:	8082                	ret

0000000080004b9c <sys_unlink>:
{
    80004b9c:	7151                	addi	sp,sp,-240
    80004b9e:	f586                	sd	ra,232(sp)
    80004ba0:	f1a2                	sd	s0,224(sp)
    80004ba2:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ba4:	08000613          	li	a2,128
    80004ba8:	f3040593          	addi	a1,s0,-208
    80004bac:	4501                	li	a0,0
    80004bae:	ffffd097          	auipc	ra,0xffffd
    80004bb2:	68c080e7          	jalr	1676(ra) # 8000223a <argstr>
    80004bb6:	1a054a63          	bltz	a0,80004d6a <sys_unlink+0x1ce>
    80004bba:	eda6                	sd	s1,216(sp)
  begin_op();
    80004bbc:	fffff097          	auipc	ra,0xfffff
    80004bc0:	b7e080e7          	jalr	-1154(ra) # 8000373a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004bc4:	fb040593          	addi	a1,s0,-80
    80004bc8:	f3040513          	addi	a0,s0,-208
    80004bcc:	fffff097          	auipc	ra,0xfffff
    80004bd0:	98c080e7          	jalr	-1652(ra) # 80003558 <nameiparent>
    80004bd4:	84aa                	mv	s1,a0
    80004bd6:	cd71                	beqz	a0,80004cb2 <sys_unlink+0x116>
  ilock(dp);
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	190080e7          	jalr	400(ra) # 80002d68 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004be0:	00004597          	auipc	a1,0x4
    80004be4:	9a858593          	addi	a1,a1,-1624 # 80008588 <etext+0x588>
    80004be8:	fb040513          	addi	a0,s0,-80
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	662080e7          	jalr	1634(ra) # 8000324e <namecmp>
    80004bf4:	14050c63          	beqz	a0,80004d4c <sys_unlink+0x1b0>
    80004bf8:	00004597          	auipc	a1,0x4
    80004bfc:	99858593          	addi	a1,a1,-1640 # 80008590 <etext+0x590>
    80004c00:	fb040513          	addi	a0,s0,-80
    80004c04:	ffffe097          	auipc	ra,0xffffe
    80004c08:	64a080e7          	jalr	1610(ra) # 8000324e <namecmp>
    80004c0c:	14050063          	beqz	a0,80004d4c <sys_unlink+0x1b0>
    80004c10:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004c12:	f2c40613          	addi	a2,s0,-212
    80004c16:	fb040593          	addi	a1,s0,-80
    80004c1a:	8526                	mv	a0,s1
    80004c1c:	ffffe097          	auipc	ra,0xffffe
    80004c20:	64c080e7          	jalr	1612(ra) # 80003268 <dirlookup>
    80004c24:	892a                	mv	s2,a0
    80004c26:	12050263          	beqz	a0,80004d4a <sys_unlink+0x1ae>
  ilock(ip);
    80004c2a:	ffffe097          	auipc	ra,0xffffe
    80004c2e:	13e080e7          	jalr	318(ra) # 80002d68 <ilock>
  if(ip->nlink < 1)
    80004c32:	04a91783          	lh	a5,74(s2)
    80004c36:	08f05563          	blez	a5,80004cc0 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004c3a:	04491703          	lh	a4,68(s2)
    80004c3e:	4785                	li	a5,1
    80004c40:	08f70963          	beq	a4,a5,80004cd2 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80004c44:	4641                	li	a2,16
    80004c46:	4581                	li	a1,0
    80004c48:	fc040513          	addi	a0,s0,-64
    80004c4c:	ffffb097          	auipc	ra,0xffffb
    80004c50:	5e4080e7          	jalr	1508(ra) # 80000230 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004c54:	4741                	li	a4,16
    80004c56:	f2c42683          	lw	a3,-212(s0)
    80004c5a:	fc040613          	addi	a2,s0,-64
    80004c5e:	4581                	li	a1,0
    80004c60:	8526                	mv	a0,s1
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	4c2080e7          	jalr	1218(ra) # 80003124 <writei>
    80004c6a:	47c1                	li	a5,16
    80004c6c:	0af51b63          	bne	a0,a5,80004d22 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80004c70:	04491703          	lh	a4,68(s2)
    80004c74:	4785                	li	a5,1
    80004c76:	0af70f63          	beq	a4,a5,80004d34 <sys_unlink+0x198>
  iunlockput(dp);
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffe097          	auipc	ra,0xffffe
    80004c80:	352080e7          	jalr	850(ra) # 80002fce <iunlockput>
  ip->nlink--;
    80004c84:	04a95783          	lhu	a5,74(s2)
    80004c88:	37fd                	addiw	a5,a5,-1
    80004c8a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffe097          	auipc	ra,0xffffe
    80004c94:	00c080e7          	jalr	12(ra) # 80002c9c <iupdate>
  iunlockput(ip);
    80004c98:	854a                	mv	a0,s2
    80004c9a:	ffffe097          	auipc	ra,0xffffe
    80004c9e:	334080e7          	jalr	820(ra) # 80002fce <iunlockput>
  end_op();
    80004ca2:	fffff097          	auipc	ra,0xfffff
    80004ca6:	b12080e7          	jalr	-1262(ra) # 800037b4 <end_op>
  return 0;
    80004caa:	4501                	li	a0,0
    80004cac:	64ee                	ld	s1,216(sp)
    80004cae:	694e                	ld	s2,208(sp)
    80004cb0:	a84d                	j	80004d62 <sys_unlink+0x1c6>
    end_op();
    80004cb2:	fffff097          	auipc	ra,0xfffff
    80004cb6:	b02080e7          	jalr	-1278(ra) # 800037b4 <end_op>
    return -1;
    80004cba:	557d                	li	a0,-1
    80004cbc:	64ee                	ld	s1,216(sp)
    80004cbe:	a055                	j	80004d62 <sys_unlink+0x1c6>
    80004cc0:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80004cc2:	00004517          	auipc	a0,0x4
    80004cc6:	8f650513          	addi	a0,a0,-1802 # 800085b8 <etext+0x5b8>
    80004cca:	00001097          	auipc	ra,0x1
    80004cce:	212080e7          	jalr	530(ra) # 80005edc <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004cd2:	04c92703          	lw	a4,76(s2)
    80004cd6:	02000793          	li	a5,32
    80004cda:	f6e7f5e3          	bgeu	a5,a4,80004c44 <sys_unlink+0xa8>
    80004cde:	e5ce                	sd	s3,200(sp)
    80004ce0:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ce4:	4741                	li	a4,16
    80004ce6:	86ce                	mv	a3,s3
    80004ce8:	f1840613          	addi	a2,s0,-232
    80004cec:	4581                	li	a1,0
    80004cee:	854a                	mv	a0,s2
    80004cf0:	ffffe097          	auipc	ra,0xffffe
    80004cf4:	330080e7          	jalr	816(ra) # 80003020 <readi>
    80004cf8:	47c1                	li	a5,16
    80004cfa:	00f51c63          	bne	a0,a5,80004d12 <sys_unlink+0x176>
    if(de.inum != 0)
    80004cfe:	f1845783          	lhu	a5,-232(s0)
    80004d02:	e7b5                	bnez	a5,80004d6e <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004d04:	29c1                	addiw	s3,s3,16
    80004d06:	04c92783          	lw	a5,76(s2)
    80004d0a:	fcf9ede3          	bltu	s3,a5,80004ce4 <sys_unlink+0x148>
    80004d0e:	69ae                	ld	s3,200(sp)
    80004d10:	bf15                	j	80004c44 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80004d12:	00004517          	auipc	a0,0x4
    80004d16:	8be50513          	addi	a0,a0,-1858 # 800085d0 <etext+0x5d0>
    80004d1a:	00001097          	auipc	ra,0x1
    80004d1e:	1c2080e7          	jalr	450(ra) # 80005edc <panic>
    80004d22:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80004d24:	00004517          	auipc	a0,0x4
    80004d28:	8c450513          	addi	a0,a0,-1852 # 800085e8 <etext+0x5e8>
    80004d2c:	00001097          	auipc	ra,0x1
    80004d30:	1b0080e7          	jalr	432(ra) # 80005edc <panic>
    dp->nlink--;
    80004d34:	04a4d783          	lhu	a5,74(s1)
    80004d38:	37fd                	addiw	a5,a5,-1
    80004d3a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d3e:	8526                	mv	a0,s1
    80004d40:	ffffe097          	auipc	ra,0xffffe
    80004d44:	f5c080e7          	jalr	-164(ra) # 80002c9c <iupdate>
    80004d48:	bf0d                	j	80004c7a <sys_unlink+0xde>
    80004d4a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004d4c:	8526                	mv	a0,s1
    80004d4e:	ffffe097          	auipc	ra,0xffffe
    80004d52:	280080e7          	jalr	640(ra) # 80002fce <iunlockput>
  end_op();
    80004d56:	fffff097          	auipc	ra,0xfffff
    80004d5a:	a5e080e7          	jalr	-1442(ra) # 800037b4 <end_op>
  return -1;
    80004d5e:	557d                	li	a0,-1
    80004d60:	64ee                	ld	s1,216(sp)
}
    80004d62:	70ae                	ld	ra,232(sp)
    80004d64:	740e                	ld	s0,224(sp)
    80004d66:	616d                	addi	sp,sp,240
    80004d68:	8082                	ret
    return -1;
    80004d6a:	557d                	li	a0,-1
    80004d6c:	bfdd                	j	80004d62 <sys_unlink+0x1c6>
    iunlockput(ip);
    80004d6e:	854a                	mv	a0,s2
    80004d70:	ffffe097          	auipc	ra,0xffffe
    80004d74:	25e080e7          	jalr	606(ra) # 80002fce <iunlockput>
    goto bad;
    80004d78:	694e                	ld	s2,208(sp)
    80004d7a:	69ae                	ld	s3,200(sp)
    80004d7c:	bfc1                	j	80004d4c <sys_unlink+0x1b0>

0000000080004d7e <sys_open>:

uint64
sys_open(void)
{
    80004d7e:	7131                	addi	sp,sp,-192
    80004d80:	fd06                	sd	ra,184(sp)
    80004d82:	f922                	sd	s0,176(sp)
    80004d84:	f526                	sd	s1,168(sp)
    80004d86:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d88:	08000613          	li	a2,128
    80004d8c:	f5040593          	addi	a1,s0,-176
    80004d90:	4501                	li	a0,0
    80004d92:	ffffd097          	auipc	ra,0xffffd
    80004d96:	4a8080e7          	jalr	1192(ra) # 8000223a <argstr>
    return -1;
    80004d9a:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80004d9c:	0c054463          	bltz	a0,80004e64 <sys_open+0xe6>
    80004da0:	f4c40593          	addi	a1,s0,-180
    80004da4:	4505                	li	a0,1
    80004da6:	ffffd097          	auipc	ra,0xffffd
    80004daa:	450080e7          	jalr	1104(ra) # 800021f6 <argint>
    80004dae:	0a054b63          	bltz	a0,80004e64 <sys_open+0xe6>
    80004db2:	f14a                	sd	s2,160(sp)

  begin_op();
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	986080e7          	jalr	-1658(ra) # 8000373a <begin_op>

  if(omode & O_CREATE){
    80004dbc:	f4c42783          	lw	a5,-180(s0)
    80004dc0:	2007f793          	andi	a5,a5,512
    80004dc4:	cfc5                	beqz	a5,80004e7c <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80004dc6:	4681                	li	a3,0
    80004dc8:	4601                	li	a2,0
    80004dca:	4589                	li	a1,2
    80004dcc:	f5040513          	addi	a0,s0,-176
    80004dd0:	00000097          	auipc	ra,0x0
    80004dd4:	958080e7          	jalr	-1704(ra) # 80004728 <create>
    80004dd8:	892a                	mv	s2,a0
    if(ip == 0){
    80004dda:	c959                	beqz	a0,80004e70 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004ddc:	04491703          	lh	a4,68(s2)
    80004de0:	478d                	li	a5,3
    80004de2:	00f71763          	bne	a4,a5,80004df0 <sys_open+0x72>
    80004de6:	04695703          	lhu	a4,70(s2)
    80004dea:	47a5                	li	a5,9
    80004dec:	0ce7ef63          	bltu	a5,a4,80004eca <sys_open+0x14c>
    80004df0:	ed4e                	sd	s3,152(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004df2:	fffff097          	auipc	ra,0xfffff
    80004df6:	d56080e7          	jalr	-682(ra) # 80003b48 <filealloc>
    80004dfa:	89aa                	mv	s3,a0
    80004dfc:	c965                	beqz	a0,80004eec <sys_open+0x16e>
    80004dfe:	00000097          	auipc	ra,0x0
    80004e02:	8e8080e7          	jalr	-1816(ra) # 800046e6 <fdalloc>
    80004e06:	84aa                	mv	s1,a0
    80004e08:	0c054d63          	bltz	a0,80004ee2 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004e0c:	04491703          	lh	a4,68(s2)
    80004e10:	478d                	li	a5,3
    80004e12:	0ef70a63          	beq	a4,a5,80004f06 <sys_open+0x188>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004e16:	4789                	li	a5,2
    80004e18:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004e1c:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004e20:	0129bc23          	sd	s2,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004e24:	f4c42783          	lw	a5,-180(s0)
    80004e28:	0017c713          	xori	a4,a5,1
    80004e2c:	8b05                	andi	a4,a4,1
    80004e2e:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e32:	0037f713          	andi	a4,a5,3
    80004e36:	00e03733          	snez	a4,a4
    80004e3a:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004e3e:	4007f793          	andi	a5,a5,1024
    80004e42:	c791                	beqz	a5,80004e4e <sys_open+0xd0>
    80004e44:	04491703          	lh	a4,68(s2)
    80004e48:	4789                	li	a5,2
    80004e4a:	0cf70563          	beq	a4,a5,80004f14 <sys_open+0x196>
    itrunc(ip);
  }

  iunlock(ip);
    80004e4e:	854a                	mv	a0,s2
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	fde080e7          	jalr	-34(ra) # 80002e2e <iunlock>
  end_op();
    80004e58:	fffff097          	auipc	ra,0xfffff
    80004e5c:	95c080e7          	jalr	-1700(ra) # 800037b4 <end_op>
    80004e60:	790a                	ld	s2,160(sp)
    80004e62:	69ea                	ld	s3,152(sp)

  return fd;
}
    80004e64:	8526                	mv	a0,s1
    80004e66:	70ea                	ld	ra,184(sp)
    80004e68:	744a                	ld	s0,176(sp)
    80004e6a:	74aa                	ld	s1,168(sp)
    80004e6c:	6129                	addi	sp,sp,192
    80004e6e:	8082                	ret
      end_op();
    80004e70:	fffff097          	auipc	ra,0xfffff
    80004e74:	944080e7          	jalr	-1724(ra) # 800037b4 <end_op>
      return -1;
    80004e78:	790a                	ld	s2,160(sp)
    80004e7a:	b7ed                	j	80004e64 <sys_open+0xe6>
    if((ip = namei(path)) == 0){
    80004e7c:	f5040513          	addi	a0,s0,-176
    80004e80:	ffffe097          	auipc	ra,0xffffe
    80004e84:	6ba080e7          	jalr	1722(ra) # 8000353a <namei>
    80004e88:	892a                	mv	s2,a0
    80004e8a:	c90d                	beqz	a0,80004ebc <sys_open+0x13e>
    ilock(ip);
    80004e8c:	ffffe097          	auipc	ra,0xffffe
    80004e90:	edc080e7          	jalr	-292(ra) # 80002d68 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004e94:	04491703          	lh	a4,68(s2)
    80004e98:	4785                	li	a5,1
    80004e9a:	f4f711e3          	bne	a4,a5,80004ddc <sys_open+0x5e>
    80004e9e:	f4c42783          	lw	a5,-180(s0)
    80004ea2:	d7b9                	beqz	a5,80004df0 <sys_open+0x72>
      iunlockput(ip);
    80004ea4:	854a                	mv	a0,s2
    80004ea6:	ffffe097          	auipc	ra,0xffffe
    80004eaa:	128080e7          	jalr	296(ra) # 80002fce <iunlockput>
      end_op();
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	906080e7          	jalr	-1786(ra) # 800037b4 <end_op>
      return -1;
    80004eb6:	54fd                	li	s1,-1
    80004eb8:	790a                	ld	s2,160(sp)
    80004eba:	b76d                	j	80004e64 <sys_open+0xe6>
      end_op();
    80004ebc:	fffff097          	auipc	ra,0xfffff
    80004ec0:	8f8080e7          	jalr	-1800(ra) # 800037b4 <end_op>
      return -1;
    80004ec4:	54fd                	li	s1,-1
    80004ec6:	790a                	ld	s2,160(sp)
    80004ec8:	bf71                	j	80004e64 <sys_open+0xe6>
    iunlockput(ip);
    80004eca:	854a                	mv	a0,s2
    80004ecc:	ffffe097          	auipc	ra,0xffffe
    80004ed0:	102080e7          	jalr	258(ra) # 80002fce <iunlockput>
    end_op();
    80004ed4:	fffff097          	auipc	ra,0xfffff
    80004ed8:	8e0080e7          	jalr	-1824(ra) # 800037b4 <end_op>
    return -1;
    80004edc:	54fd                	li	s1,-1
    80004ede:	790a                	ld	s2,160(sp)
    80004ee0:	b751                	j	80004e64 <sys_open+0xe6>
      fileclose(f);
    80004ee2:	854e                	mv	a0,s3
    80004ee4:	fffff097          	auipc	ra,0xfffff
    80004ee8:	d20080e7          	jalr	-736(ra) # 80003c04 <fileclose>
    iunlockput(ip);
    80004eec:	854a                	mv	a0,s2
    80004eee:	ffffe097          	auipc	ra,0xffffe
    80004ef2:	0e0080e7          	jalr	224(ra) # 80002fce <iunlockput>
    end_op();
    80004ef6:	fffff097          	auipc	ra,0xfffff
    80004efa:	8be080e7          	jalr	-1858(ra) # 800037b4 <end_op>
    return -1;
    80004efe:	54fd                	li	s1,-1
    80004f00:	790a                	ld	s2,160(sp)
    80004f02:	69ea                	ld	s3,152(sp)
    80004f04:	b785                	j	80004e64 <sys_open+0xe6>
    f->type = FD_DEVICE;
    80004f06:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004f0a:	04691783          	lh	a5,70(s2)
    80004f0e:	02f99223          	sh	a5,36(s3)
    80004f12:	b739                	j	80004e20 <sys_open+0xa2>
    itrunc(ip);
    80004f14:	854a                	mv	a0,s2
    80004f16:	ffffe097          	auipc	ra,0xffffe
    80004f1a:	f64080e7          	jalr	-156(ra) # 80002e7a <itrunc>
    80004f1e:	bf05                	j	80004e4e <sys_open+0xd0>

0000000080004f20 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f20:	7175                	addi	sp,sp,-144
    80004f22:	e506                	sd	ra,136(sp)
    80004f24:	e122                	sd	s0,128(sp)
    80004f26:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004f28:	fffff097          	auipc	ra,0xfffff
    80004f2c:	812080e7          	jalr	-2030(ra) # 8000373a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004f30:	08000613          	li	a2,128
    80004f34:	f7040593          	addi	a1,s0,-144
    80004f38:	4501                	li	a0,0
    80004f3a:	ffffd097          	auipc	ra,0xffffd
    80004f3e:	300080e7          	jalr	768(ra) # 8000223a <argstr>
    80004f42:	02054963          	bltz	a0,80004f74 <sys_mkdir+0x54>
    80004f46:	4681                	li	a3,0
    80004f48:	4601                	li	a2,0
    80004f4a:	4585                	li	a1,1
    80004f4c:	f7040513          	addi	a0,s0,-144
    80004f50:	fffff097          	auipc	ra,0xfffff
    80004f54:	7d8080e7          	jalr	2008(ra) # 80004728 <create>
    80004f58:	cd11                	beqz	a0,80004f74 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004f5a:	ffffe097          	auipc	ra,0xffffe
    80004f5e:	074080e7          	jalr	116(ra) # 80002fce <iunlockput>
  end_op();
    80004f62:	fffff097          	auipc	ra,0xfffff
    80004f66:	852080e7          	jalr	-1966(ra) # 800037b4 <end_op>
  return 0;
    80004f6a:	4501                	li	a0,0
}
    80004f6c:	60aa                	ld	ra,136(sp)
    80004f6e:	640a                	ld	s0,128(sp)
    80004f70:	6149                	addi	sp,sp,144
    80004f72:	8082                	ret
    end_op();
    80004f74:	fffff097          	auipc	ra,0xfffff
    80004f78:	840080e7          	jalr	-1984(ra) # 800037b4 <end_op>
    return -1;
    80004f7c:	557d                	li	a0,-1
    80004f7e:	b7fd                	j	80004f6c <sys_mkdir+0x4c>

0000000080004f80 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f80:	7135                	addi	sp,sp,-160
    80004f82:	ed06                	sd	ra,152(sp)
    80004f84:	e922                	sd	s0,144(sp)
    80004f86:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004f88:	ffffe097          	auipc	ra,0xffffe
    80004f8c:	7b2080e7          	jalr	1970(ra) # 8000373a <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004f90:	08000613          	li	a2,128
    80004f94:	f7040593          	addi	a1,s0,-144
    80004f98:	4501                	li	a0,0
    80004f9a:	ffffd097          	auipc	ra,0xffffd
    80004f9e:	2a0080e7          	jalr	672(ra) # 8000223a <argstr>
    80004fa2:	04054a63          	bltz	a0,80004ff6 <sys_mknod+0x76>
     argint(1, &major) < 0 ||
    80004fa6:	f6c40593          	addi	a1,s0,-148
    80004faa:	4505                	li	a0,1
    80004fac:	ffffd097          	auipc	ra,0xffffd
    80004fb0:	24a080e7          	jalr	586(ra) # 800021f6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004fb4:	04054163          	bltz	a0,80004ff6 <sys_mknod+0x76>
     argint(2, &minor) < 0 ||
    80004fb8:	f6840593          	addi	a1,s0,-152
    80004fbc:	4509                	li	a0,2
    80004fbe:	ffffd097          	auipc	ra,0xffffd
    80004fc2:	238080e7          	jalr	568(ra) # 800021f6 <argint>
     argint(1, &major) < 0 ||
    80004fc6:	02054863          	bltz	a0,80004ff6 <sys_mknod+0x76>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004fca:	f6841683          	lh	a3,-152(s0)
    80004fce:	f6c41603          	lh	a2,-148(s0)
    80004fd2:	458d                	li	a1,3
    80004fd4:	f7040513          	addi	a0,s0,-144
    80004fd8:	fffff097          	auipc	ra,0xfffff
    80004fdc:	750080e7          	jalr	1872(ra) # 80004728 <create>
     argint(2, &minor) < 0 ||
    80004fe0:	c919                	beqz	a0,80004ff6 <sys_mknod+0x76>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	fec080e7          	jalr	-20(ra) # 80002fce <iunlockput>
  end_op();
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	7ca080e7          	jalr	1994(ra) # 800037b4 <end_op>
  return 0;
    80004ff2:	4501                	li	a0,0
    80004ff4:	a031                	j	80005000 <sys_mknod+0x80>
    end_op();
    80004ff6:	ffffe097          	auipc	ra,0xffffe
    80004ffa:	7be080e7          	jalr	1982(ra) # 800037b4 <end_op>
    return -1;
    80004ffe:	557d                	li	a0,-1
}
    80005000:	60ea                	ld	ra,152(sp)
    80005002:	644a                	ld	s0,144(sp)
    80005004:	610d                	addi	sp,sp,160
    80005006:	8082                	ret

0000000080005008 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005008:	7135                	addi	sp,sp,-160
    8000500a:	ed06                	sd	ra,152(sp)
    8000500c:	e922                	sd	s0,144(sp)
    8000500e:	e14a                	sd	s2,128(sp)
    80005010:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005012:	ffffc097          	auipc	ra,0xffffc
    80005016:	056080e7          	jalr	86(ra) # 80001068 <myproc>
    8000501a:	892a                	mv	s2,a0
  
  begin_op();
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	71e080e7          	jalr	1822(ra) # 8000373a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005024:	08000613          	li	a2,128
    80005028:	f6040593          	addi	a1,s0,-160
    8000502c:	4501                	li	a0,0
    8000502e:	ffffd097          	auipc	ra,0xffffd
    80005032:	20c080e7          	jalr	524(ra) # 8000223a <argstr>
    80005036:	04054d63          	bltz	a0,80005090 <sys_chdir+0x88>
    8000503a:	e526                	sd	s1,136(sp)
    8000503c:	f6040513          	addi	a0,s0,-160
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	4fa080e7          	jalr	1274(ra) # 8000353a <namei>
    80005048:	84aa                	mv	s1,a0
    8000504a:	c131                	beqz	a0,8000508e <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000504c:	ffffe097          	auipc	ra,0xffffe
    80005050:	d1c080e7          	jalr	-740(ra) # 80002d68 <ilock>
  if(ip->type != T_DIR){
    80005054:	04449703          	lh	a4,68(s1)
    80005058:	4785                	li	a5,1
    8000505a:	04f71163          	bne	a4,a5,8000509c <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000505e:	8526                	mv	a0,s1
    80005060:	ffffe097          	auipc	ra,0xffffe
    80005064:	dce080e7          	jalr	-562(ra) # 80002e2e <iunlock>
  iput(p->cwd);
    80005068:	15093503          	ld	a0,336(s2)
    8000506c:	ffffe097          	auipc	ra,0xffffe
    80005070:	eba080e7          	jalr	-326(ra) # 80002f26 <iput>
  end_op();
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	740080e7          	jalr	1856(ra) # 800037b4 <end_op>
  p->cwd = ip;
    8000507c:	14993823          	sd	s1,336(s2)
  return 0;
    80005080:	4501                	li	a0,0
    80005082:	64aa                	ld	s1,136(sp)
}
    80005084:	60ea                	ld	ra,152(sp)
    80005086:	644a                	ld	s0,144(sp)
    80005088:	690a                	ld	s2,128(sp)
    8000508a:	610d                	addi	sp,sp,160
    8000508c:	8082                	ret
    8000508e:	64aa                	ld	s1,136(sp)
    end_op();
    80005090:	ffffe097          	auipc	ra,0xffffe
    80005094:	724080e7          	jalr	1828(ra) # 800037b4 <end_op>
    return -1;
    80005098:	557d                	li	a0,-1
    8000509a:	b7ed                	j	80005084 <sys_chdir+0x7c>
    iunlockput(ip);
    8000509c:	8526                	mv	a0,s1
    8000509e:	ffffe097          	auipc	ra,0xffffe
    800050a2:	f30080e7          	jalr	-208(ra) # 80002fce <iunlockput>
    end_op();
    800050a6:	ffffe097          	auipc	ra,0xffffe
    800050aa:	70e080e7          	jalr	1806(ra) # 800037b4 <end_op>
    return -1;
    800050ae:	557d                	li	a0,-1
    800050b0:	64aa                	ld	s1,136(sp)
    800050b2:	bfc9                	j	80005084 <sys_chdir+0x7c>

00000000800050b4 <sys_exec>:

uint64
sys_exec(void)
{
    800050b4:	7121                	addi	sp,sp,-448
    800050b6:	ff06                	sd	ra,440(sp)
    800050b8:	fb22                	sd	s0,432(sp)
    800050ba:	f34a                	sd	s2,416(sp)
    800050bc:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050be:	08000613          	li	a2,128
    800050c2:	f5040593          	addi	a1,s0,-176
    800050c6:	4501                	li	a0,0
    800050c8:	ffffd097          	auipc	ra,0xffffd
    800050cc:	172080e7          	jalr	370(ra) # 8000223a <argstr>
    return -1;
    800050d0:	597d                	li	s2,-1
  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    800050d2:	0e054a63          	bltz	a0,800051c6 <sys_exec+0x112>
    800050d6:	e4840593          	addi	a1,s0,-440
    800050da:	4505                	li	a0,1
    800050dc:	ffffd097          	auipc	ra,0xffffd
    800050e0:	13c080e7          	jalr	316(ra) # 80002218 <argaddr>
    800050e4:	0e054163          	bltz	a0,800051c6 <sys_exec+0x112>
    800050e8:	f726                	sd	s1,424(sp)
    800050ea:	ef4e                	sd	s3,408(sp)
    800050ec:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800050ee:	10000613          	li	a2,256
    800050f2:	4581                	li	a1,0
    800050f4:	e5040513          	addi	a0,s0,-432
    800050f8:	ffffb097          	auipc	ra,0xffffb
    800050fc:	138080e7          	jalr	312(ra) # 80000230 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005100:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005104:	89a6                	mv	s3,s1
    80005106:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005108:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000510c:	00391513          	slli	a0,s2,0x3
    80005110:	e4040593          	addi	a1,s0,-448
    80005114:	e4843783          	ld	a5,-440(s0)
    80005118:	953e                	add	a0,a0,a5
    8000511a:	ffffd097          	auipc	ra,0xffffd
    8000511e:	042080e7          	jalr	66(ra) # 8000215c <fetchaddr>
    80005122:	02054a63          	bltz	a0,80005156 <sys_exec+0xa2>
      goto bad;
    }
    if(uarg == 0){
    80005126:	e4043783          	ld	a5,-448(s0)
    8000512a:	c7b1                	beqz	a5,80005176 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    8000512c:	ffffb097          	auipc	ra,0xffffb
    80005130:	076080e7          	jalr	118(ra) # 800001a2 <kalloc>
    80005134:	85aa                	mv	a1,a0
    80005136:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000513a:	cd11                	beqz	a0,80005156 <sys_exec+0xa2>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000513c:	6605                	lui	a2,0x1
    8000513e:	e4043503          	ld	a0,-448(s0)
    80005142:	ffffd097          	auipc	ra,0xffffd
    80005146:	06c080e7          	jalr	108(ra) # 800021ae <fetchstr>
    8000514a:	00054663          	bltz	a0,80005156 <sys_exec+0xa2>
    if(i >= NELEM(argv)){
    8000514e:	0905                	addi	s2,s2,1
    80005150:	09a1                	addi	s3,s3,8
    80005152:	fb491de3          	bne	s2,s4,8000510c <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005156:	f5040913          	addi	s2,s0,-176
    8000515a:	6088                	ld	a0,0(s1)
    8000515c:	c12d                	beqz	a0,800051be <sys_exec+0x10a>
    kfree(argv[i]);
    8000515e:	ffffb097          	auipc	ra,0xffffb
    80005162:	ebe080e7          	jalr	-322(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005166:	04a1                	addi	s1,s1,8
    80005168:	ff2499e3          	bne	s1,s2,8000515a <sys_exec+0xa6>
  return -1;
    8000516c:	597d                	li	s2,-1
    8000516e:	74ba                	ld	s1,424(sp)
    80005170:	69fa                	ld	s3,408(sp)
    80005172:	6a5a                	ld	s4,400(sp)
    80005174:	a889                	j	800051c6 <sys_exec+0x112>
      argv[i] = 0;
    80005176:	0009079b          	sext.w	a5,s2
    8000517a:	078e                	slli	a5,a5,0x3
    8000517c:	fd078793          	addi	a5,a5,-48
    80005180:	97a2                	add	a5,a5,s0
    80005182:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005186:	e5040593          	addi	a1,s0,-432
    8000518a:	f5040513          	addi	a0,s0,-176
    8000518e:	fffff097          	auipc	ra,0xfffff
    80005192:	126080e7          	jalr	294(ra) # 800042b4 <exec>
    80005196:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005198:	f5040993          	addi	s3,s0,-176
    8000519c:	6088                	ld	a0,0(s1)
    8000519e:	cd01                	beqz	a0,800051b6 <sys_exec+0x102>
    kfree(argv[i]);
    800051a0:	ffffb097          	auipc	ra,0xffffb
    800051a4:	e7c080e7          	jalr	-388(ra) # 8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051a8:	04a1                	addi	s1,s1,8
    800051aa:	ff3499e3          	bne	s1,s3,8000519c <sys_exec+0xe8>
    800051ae:	74ba                	ld	s1,424(sp)
    800051b0:	69fa                	ld	s3,408(sp)
    800051b2:	6a5a                	ld	s4,400(sp)
    800051b4:	a809                	j	800051c6 <sys_exec+0x112>
  return ret;
    800051b6:	74ba                	ld	s1,424(sp)
    800051b8:	69fa                	ld	s3,408(sp)
    800051ba:	6a5a                	ld	s4,400(sp)
    800051bc:	a029                	j	800051c6 <sys_exec+0x112>
  return -1;
    800051be:	597d                	li	s2,-1
    800051c0:	74ba                	ld	s1,424(sp)
    800051c2:	69fa                	ld	s3,408(sp)
    800051c4:	6a5a                	ld	s4,400(sp)
}
    800051c6:	854a                	mv	a0,s2
    800051c8:	70fa                	ld	ra,440(sp)
    800051ca:	745a                	ld	s0,432(sp)
    800051cc:	791a                	ld	s2,416(sp)
    800051ce:	6139                	addi	sp,sp,448
    800051d0:	8082                	ret

00000000800051d2 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051d2:	7139                	addi	sp,sp,-64
    800051d4:	fc06                	sd	ra,56(sp)
    800051d6:	f822                	sd	s0,48(sp)
    800051d8:	f426                	sd	s1,40(sp)
    800051da:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800051dc:	ffffc097          	auipc	ra,0xffffc
    800051e0:	e8c080e7          	jalr	-372(ra) # 80001068 <myproc>
    800051e4:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    800051e6:	fd840593          	addi	a1,s0,-40
    800051ea:	4501                	li	a0,0
    800051ec:	ffffd097          	auipc	ra,0xffffd
    800051f0:	02c080e7          	jalr	44(ra) # 80002218 <argaddr>
    return -1;
    800051f4:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    800051f6:	0e054063          	bltz	a0,800052d6 <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    800051fa:	fc840593          	addi	a1,s0,-56
    800051fe:	fd040513          	addi	a0,s0,-48
    80005202:	fffff097          	auipc	ra,0xfffff
    80005206:	d70080e7          	jalr	-656(ra) # 80003f72 <pipealloc>
    return -1;
    8000520a:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    8000520c:	0c054563          	bltz	a0,800052d6 <sys_pipe+0x104>
  fd0 = -1;
    80005210:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005214:	fd043503          	ld	a0,-48(s0)
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	4ce080e7          	jalr	1230(ra) # 800046e6 <fdalloc>
    80005220:	fca42223          	sw	a0,-60(s0)
    80005224:	08054c63          	bltz	a0,800052bc <sys_pipe+0xea>
    80005228:	fc843503          	ld	a0,-56(s0)
    8000522c:	fffff097          	auipc	ra,0xfffff
    80005230:	4ba080e7          	jalr	1210(ra) # 800046e6 <fdalloc>
    80005234:	fca42023          	sw	a0,-64(s0)
    80005238:	06054963          	bltz	a0,800052aa <sys_pipe+0xd8>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000523c:	4691                	li	a3,4
    8000523e:	fc440613          	addi	a2,s0,-60
    80005242:	fd843583          	ld	a1,-40(s0)
    80005246:	68a8                	ld	a0,80(s1)
    80005248:	ffffc097          	auipc	ra,0xffffc
    8000524c:	9aa080e7          	jalr	-1622(ra) # 80000bf2 <copyout>
    80005250:	02054063          	bltz	a0,80005270 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005254:	4691                	li	a3,4
    80005256:	fc040613          	addi	a2,s0,-64
    8000525a:	fd843583          	ld	a1,-40(s0)
    8000525e:	0591                	addi	a1,a1,4
    80005260:	68a8                	ld	a0,80(s1)
    80005262:	ffffc097          	auipc	ra,0xffffc
    80005266:	990080e7          	jalr	-1648(ra) # 80000bf2 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000526a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000526c:	06055563          	bgez	a0,800052d6 <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005270:	fc442783          	lw	a5,-60(s0)
    80005274:	07e9                	addi	a5,a5,26
    80005276:	078e                	slli	a5,a5,0x3
    80005278:	97a6                	add	a5,a5,s1
    8000527a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000527e:	fc042783          	lw	a5,-64(s0)
    80005282:	07e9                	addi	a5,a5,26
    80005284:	078e                	slli	a5,a5,0x3
    80005286:	00f48533          	add	a0,s1,a5
    8000528a:	00053023          	sd	zero,0(a0)
    fileclose(rf);
    8000528e:	fd043503          	ld	a0,-48(s0)
    80005292:	fffff097          	auipc	ra,0xfffff
    80005296:	972080e7          	jalr	-1678(ra) # 80003c04 <fileclose>
    fileclose(wf);
    8000529a:	fc843503          	ld	a0,-56(s0)
    8000529e:	fffff097          	auipc	ra,0xfffff
    800052a2:	966080e7          	jalr	-1690(ra) # 80003c04 <fileclose>
    return -1;
    800052a6:	57fd                	li	a5,-1
    800052a8:	a03d                	j	800052d6 <sys_pipe+0x104>
    if(fd0 >= 0)
    800052aa:	fc442783          	lw	a5,-60(s0)
    800052ae:	0007c763          	bltz	a5,800052bc <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    800052b2:	07e9                	addi	a5,a5,26
    800052b4:	078e                	slli	a5,a5,0x3
    800052b6:	97a6                	add	a5,a5,s1
    800052b8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800052bc:	fd043503          	ld	a0,-48(s0)
    800052c0:	fffff097          	auipc	ra,0xfffff
    800052c4:	944080e7          	jalr	-1724(ra) # 80003c04 <fileclose>
    fileclose(wf);
    800052c8:	fc843503          	ld	a0,-56(s0)
    800052cc:	fffff097          	auipc	ra,0xfffff
    800052d0:	938080e7          	jalr	-1736(ra) # 80003c04 <fileclose>
    return -1;
    800052d4:	57fd                	li	a5,-1
}
    800052d6:	853e                	mv	a0,a5
    800052d8:	70e2                	ld	ra,56(sp)
    800052da:	7442                	ld	s0,48(sp)
    800052dc:	74a2                	ld	s1,40(sp)
    800052de:	6121                	addi	sp,sp,64
    800052e0:	8082                	ret
	...

00000000800052f0 <kernelvec>:
    800052f0:	7111                	addi	sp,sp,-256
    800052f2:	e006                	sd	ra,0(sp)
    800052f4:	e40a                	sd	sp,8(sp)
    800052f6:	e80e                	sd	gp,16(sp)
    800052f8:	ec12                	sd	tp,24(sp)
    800052fa:	f016                	sd	t0,32(sp)
    800052fc:	f41a                	sd	t1,40(sp)
    800052fe:	f81e                	sd	t2,48(sp)
    80005300:	fc22                	sd	s0,56(sp)
    80005302:	e0a6                	sd	s1,64(sp)
    80005304:	e4aa                	sd	a0,72(sp)
    80005306:	e8ae                	sd	a1,80(sp)
    80005308:	ecb2                	sd	a2,88(sp)
    8000530a:	f0b6                	sd	a3,96(sp)
    8000530c:	f4ba                	sd	a4,104(sp)
    8000530e:	f8be                	sd	a5,112(sp)
    80005310:	fcc2                	sd	a6,120(sp)
    80005312:	e146                	sd	a7,128(sp)
    80005314:	e54a                	sd	s2,136(sp)
    80005316:	e94e                	sd	s3,144(sp)
    80005318:	ed52                	sd	s4,152(sp)
    8000531a:	f156                	sd	s5,160(sp)
    8000531c:	f55a                	sd	s6,168(sp)
    8000531e:	f95e                	sd	s7,176(sp)
    80005320:	fd62                	sd	s8,184(sp)
    80005322:	e1e6                	sd	s9,192(sp)
    80005324:	e5ea                	sd	s10,200(sp)
    80005326:	e9ee                	sd	s11,208(sp)
    80005328:	edf2                	sd	t3,216(sp)
    8000532a:	f1f6                	sd	t4,224(sp)
    8000532c:	f5fa                	sd	t5,232(sp)
    8000532e:	f9fe                	sd	t6,240(sp)
    80005330:	cf9fc0ef          	jal	80002028 <kerneltrap>
    80005334:	6082                	ld	ra,0(sp)
    80005336:	6122                	ld	sp,8(sp)
    80005338:	61c2                	ld	gp,16(sp)
    8000533a:	7282                	ld	t0,32(sp)
    8000533c:	7322                	ld	t1,40(sp)
    8000533e:	73c2                	ld	t2,48(sp)
    80005340:	7462                	ld	s0,56(sp)
    80005342:	6486                	ld	s1,64(sp)
    80005344:	6526                	ld	a0,72(sp)
    80005346:	65c6                	ld	a1,80(sp)
    80005348:	6666                	ld	a2,88(sp)
    8000534a:	7686                	ld	a3,96(sp)
    8000534c:	7726                	ld	a4,104(sp)
    8000534e:	77c6                	ld	a5,112(sp)
    80005350:	7866                	ld	a6,120(sp)
    80005352:	688a                	ld	a7,128(sp)
    80005354:	692a                	ld	s2,136(sp)
    80005356:	69ca                	ld	s3,144(sp)
    80005358:	6a6a                	ld	s4,152(sp)
    8000535a:	7a8a                	ld	s5,160(sp)
    8000535c:	7b2a                	ld	s6,168(sp)
    8000535e:	7bca                	ld	s7,176(sp)
    80005360:	7c6a                	ld	s8,184(sp)
    80005362:	6c8e                	ld	s9,192(sp)
    80005364:	6d2e                	ld	s10,200(sp)
    80005366:	6dce                	ld	s11,208(sp)
    80005368:	6e6e                	ld	t3,216(sp)
    8000536a:	7e8e                	ld	t4,224(sp)
    8000536c:	7f2e                	ld	t5,232(sp)
    8000536e:	7fce                	ld	t6,240(sp)
    80005370:	6111                	addi	sp,sp,256
    80005372:	10200073          	sret
    80005376:	00000013          	nop
    8000537a:	00000013          	nop
    8000537e:	0001                	nop

0000000080005380 <timervec>:
    80005380:	34051573          	csrrw	a0,mscratch,a0
    80005384:	e10c                	sd	a1,0(a0)
    80005386:	e510                	sd	a2,8(a0)
    80005388:	e914                	sd	a3,16(a0)
    8000538a:	6d0c                	ld	a1,24(a0)
    8000538c:	7110                	ld	a2,32(a0)
    8000538e:	6194                	ld	a3,0(a1)
    80005390:	96b2                	add	a3,a3,a2
    80005392:	e194                	sd	a3,0(a1)
    80005394:	4589                	li	a1,2
    80005396:	14459073          	csrw	sip,a1
    8000539a:	6914                	ld	a3,16(a0)
    8000539c:	6510                	ld	a2,8(a0)
    8000539e:	610c                	ld	a1,0(a0)
    800053a0:	34051573          	csrrw	a0,mscratch,a0
    800053a4:	30200073          	mret
	...

00000000800053aa <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800053aa:	1141                	addi	sp,sp,-16
    800053ac:	e422                	sd	s0,8(sp)
    800053ae:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800053b0:	0c0007b7          	lui	a5,0xc000
    800053b4:	4705                	li	a4,1
    800053b6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800053b8:	0c0007b7          	lui	a5,0xc000
    800053bc:	c3d8                	sw	a4,4(a5)
}
    800053be:	6422                	ld	s0,8(sp)
    800053c0:	0141                	addi	sp,sp,16
    800053c2:	8082                	ret

00000000800053c4 <plicinithart>:

void
plicinithart(void)
{
    800053c4:	1141                	addi	sp,sp,-16
    800053c6:	e406                	sd	ra,8(sp)
    800053c8:	e022                	sd	s0,0(sp)
    800053ca:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053cc:	ffffc097          	auipc	ra,0xffffc
    800053d0:	c70080e7          	jalr	-912(ra) # 8000103c <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800053d4:	0085171b          	slliw	a4,a0,0x8
    800053d8:	0c0027b7          	lui	a5,0xc002
    800053dc:	97ba                	add	a5,a5,a4
    800053de:	40200713          	li	a4,1026
    800053e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053e6:	00d5151b          	slliw	a0,a0,0xd
    800053ea:	0c2017b7          	lui	a5,0xc201
    800053ee:	97aa                	add	a5,a5,a0
    800053f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800053f4:	60a2                	ld	ra,8(sp)
    800053f6:	6402                	ld	s0,0(sp)
    800053f8:	0141                	addi	sp,sp,16
    800053fa:	8082                	ret

00000000800053fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053fc:	1141                	addi	sp,sp,-16
    800053fe:	e406                	sd	ra,8(sp)
    80005400:	e022                	sd	s0,0(sp)
    80005402:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005404:	ffffc097          	auipc	ra,0xffffc
    80005408:	c38080e7          	jalr	-968(ra) # 8000103c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000540c:	00d5151b          	slliw	a0,a0,0xd
    80005410:	0c2017b7          	lui	a5,0xc201
    80005414:	97aa                	add	a5,a5,a0
  return irq;
}
    80005416:	43c8                	lw	a0,4(a5)
    80005418:	60a2                	ld	ra,8(sp)
    8000541a:	6402                	ld	s0,0(sp)
    8000541c:	0141                	addi	sp,sp,16
    8000541e:	8082                	ret

0000000080005420 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005420:	1101                	addi	sp,sp,-32
    80005422:	ec06                	sd	ra,24(sp)
    80005424:	e822                	sd	s0,16(sp)
    80005426:	e426                	sd	s1,8(sp)
    80005428:	1000                	addi	s0,sp,32
    8000542a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000542c:	ffffc097          	auipc	ra,0xffffc
    80005430:	c10080e7          	jalr	-1008(ra) # 8000103c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005434:	00d5151b          	slliw	a0,a0,0xd
    80005438:	0c2017b7          	lui	a5,0xc201
    8000543c:	97aa                	add	a5,a5,a0
    8000543e:	c3c4                	sw	s1,4(a5)
}
    80005440:	60e2                	ld	ra,24(sp)
    80005442:	6442                	ld	s0,16(sp)
    80005444:	64a2                	ld	s1,8(sp)
    80005446:	6105                	addi	sp,sp,32
    80005448:	8082                	ret

000000008000544a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000544a:	1141                	addi	sp,sp,-16
    8000544c:	e406                	sd	ra,8(sp)
    8000544e:	e022                	sd	s0,0(sp)
    80005450:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005452:	479d                	li	a5,7
    80005454:	06a7c863          	blt	a5,a0,800054c4 <free_desc+0x7a>
    panic("free_desc 1");
  if(disk.free[i])
    80005458:	00239717          	auipc	a4,0x239
    8000545c:	ba870713          	addi	a4,a4,-1112 # 8023e000 <disk>
    80005460:	972a                	add	a4,a4,a0
    80005462:	6789                	lui	a5,0x2
    80005464:	97ba                	add	a5,a5,a4
    80005466:	0187c783          	lbu	a5,24(a5) # 2018 <_entry-0x7fffdfe8>
    8000546a:	e7ad                	bnez	a5,800054d4 <free_desc+0x8a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    8000546c:	00451793          	slli	a5,a0,0x4
    80005470:	0023b717          	auipc	a4,0x23b
    80005474:	b9070713          	addi	a4,a4,-1136 # 80240000 <disk+0x2000>
    80005478:	6314                	ld	a3,0(a4)
    8000547a:	96be                	add	a3,a3,a5
    8000547c:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005480:	6314                	ld	a3,0(a4)
    80005482:	96be                	add	a3,a3,a5
    80005484:	0006a423          	sw	zero,8(a3)
  disk.desc[i].flags = 0;
    80005488:	6314                	ld	a3,0(a4)
    8000548a:	96be                	add	a3,a3,a5
    8000548c:	00069623          	sh	zero,12(a3)
  disk.desc[i].next = 0;
    80005490:	6318                	ld	a4,0(a4)
    80005492:	97ba                	add	a5,a5,a4
    80005494:	00079723          	sh	zero,14(a5)
  disk.free[i] = 1;
    80005498:	00239717          	auipc	a4,0x239
    8000549c:	b6870713          	addi	a4,a4,-1176 # 8023e000 <disk>
    800054a0:	972a                	add	a4,a4,a0
    800054a2:	6789                	lui	a5,0x2
    800054a4:	97ba                	add	a5,a5,a4
    800054a6:	4705                	li	a4,1
    800054a8:	00e78c23          	sb	a4,24(a5) # 2018 <_entry-0x7fffdfe8>
  wakeup(&disk.free[0]);
    800054ac:	0023b517          	auipc	a0,0x23b
    800054b0:	b6c50513          	addi	a0,a0,-1172 # 80240018 <disk+0x2018>
    800054b4:	ffffc097          	auipc	ra,0xffffc
    800054b8:	406080e7          	jalr	1030(ra) # 800018ba <wakeup>
}
    800054bc:	60a2                	ld	ra,8(sp)
    800054be:	6402                	ld	s0,0(sp)
    800054c0:	0141                	addi	sp,sp,16
    800054c2:	8082                	ret
    panic("free_desc 1");
    800054c4:	00003517          	auipc	a0,0x3
    800054c8:	13450513          	addi	a0,a0,308 # 800085f8 <etext+0x5f8>
    800054cc:	00001097          	auipc	ra,0x1
    800054d0:	a10080e7          	jalr	-1520(ra) # 80005edc <panic>
    panic("free_desc 2");
    800054d4:	00003517          	auipc	a0,0x3
    800054d8:	13450513          	addi	a0,a0,308 # 80008608 <etext+0x608>
    800054dc:	00001097          	auipc	ra,0x1
    800054e0:	a00080e7          	jalr	-1536(ra) # 80005edc <panic>

00000000800054e4 <virtio_disk_init>:
{
    800054e4:	1141                	addi	sp,sp,-16
    800054e6:	e406                	sd	ra,8(sp)
    800054e8:	e022                	sd	s0,0(sp)
    800054ea:	0800                	addi	s0,sp,16
  initlock(&disk.vdisk_lock, "virtio_disk");
    800054ec:	00003597          	auipc	a1,0x3
    800054f0:	12c58593          	addi	a1,a1,300 # 80008618 <etext+0x618>
    800054f4:	0023b517          	auipc	a0,0x23b
    800054f8:	c3450513          	addi	a0,a0,-972 # 80240128 <disk+0x2128>
    800054fc:	00001097          	auipc	ra,0x1
    80005500:	eca080e7          	jalr	-310(ra) # 800063c6 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005504:	100017b7          	lui	a5,0x10001
    80005508:	4398                	lw	a4,0(a5)
    8000550a:	2701                	sext.w	a4,a4
    8000550c:	747277b7          	lui	a5,0x74727
    80005510:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005514:	0ef71f63          	bne	a4,a5,80005612 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005518:	100017b7          	lui	a5,0x10001
    8000551c:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    8000551e:	439c                	lw	a5,0(a5)
    80005520:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005522:	4705                	li	a4,1
    80005524:	0ee79763          	bne	a5,a4,80005612 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005528:	100017b7          	lui	a5,0x10001
    8000552c:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000552e:	439c                	lw	a5,0(a5)
    80005530:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 1 ||
    80005532:	4709                	li	a4,2
    80005534:	0ce79f63          	bne	a5,a4,80005612 <virtio_disk_init+0x12e>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005538:	100017b7          	lui	a5,0x10001
    8000553c:	47d8                	lw	a4,12(a5)
    8000553e:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005540:	554d47b7          	lui	a5,0x554d4
    80005544:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005548:	0cf71563          	bne	a4,a5,80005612 <virtio_disk_init+0x12e>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000554c:	100017b7          	lui	a5,0x10001
    80005550:	4705                	li	a4,1
    80005552:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005554:	470d                	li	a4,3
    80005556:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005558:	10001737          	lui	a4,0x10001
    8000555c:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000555e:	c7ffe737          	lui	a4,0xc7ffe
    80005562:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47db551f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005566:	8ef9                	and	a3,a3,a4
    80005568:	10001737          	lui	a4,0x10001
    8000556c:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000556e:	472d                	li	a4,11
    80005570:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005572:	473d                	li	a4,15
    80005574:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80005576:	100017b7          	lui	a5,0x10001
    8000557a:	6705                	lui	a4,0x1
    8000557c:	d798                	sw	a4,40(a5)
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000557e:	100017b7          	lui	a5,0x10001
    80005582:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005586:	100017b7          	lui	a5,0x10001
    8000558a:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    8000558e:	439c                	lw	a5,0(a5)
    80005590:	2781                	sext.w	a5,a5
  if(max == 0)
    80005592:	cbc1                	beqz	a5,80005622 <virtio_disk_init+0x13e>
  if(max < NUM)
    80005594:	471d                	li	a4,7
    80005596:	08f77e63          	bgeu	a4,a5,80005632 <virtio_disk_init+0x14e>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000559a:	100017b7          	lui	a5,0x10001
    8000559e:	4721                	li	a4,8
    800055a0:	df98                	sw	a4,56(a5)
  memset(disk.pages, 0, sizeof(disk.pages));
    800055a2:	6609                	lui	a2,0x2
    800055a4:	4581                	li	a1,0
    800055a6:	00239517          	auipc	a0,0x239
    800055aa:	a5a50513          	addi	a0,a0,-1446 # 8023e000 <disk>
    800055ae:	ffffb097          	auipc	ra,0xffffb
    800055b2:	c82080e7          	jalr	-894(ra) # 80000230 <memset>
  *R(VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk.pages) >> PGSHIFT;
    800055b6:	00239697          	auipc	a3,0x239
    800055ba:	a4a68693          	addi	a3,a3,-1462 # 8023e000 <disk>
    800055be:	00c6d713          	srli	a4,a3,0xc
    800055c2:	2701                	sext.w	a4,a4
    800055c4:	100017b7          	lui	a5,0x10001
    800055c8:	c3b8                	sw	a4,64(a5)
  disk.desc = (struct virtq_desc *) disk.pages;
    800055ca:	0023b797          	auipc	a5,0x23b
    800055ce:	a3678793          	addi	a5,a5,-1482 # 80240000 <disk+0x2000>
    800055d2:	e394                	sd	a3,0(a5)
  disk.avail = (struct virtq_avail *)(disk.pages + NUM*sizeof(struct virtq_desc));
    800055d4:	00239717          	auipc	a4,0x239
    800055d8:	aac70713          	addi	a4,a4,-1364 # 8023e080 <disk+0x80>
    800055dc:	e798                	sd	a4,8(a5)
  disk.used = (struct virtq_used *) (disk.pages + PGSIZE);
    800055de:	0023a717          	auipc	a4,0x23a
    800055e2:	a2270713          	addi	a4,a4,-1502 # 8023f000 <disk+0x1000>
    800055e6:	eb98                	sd	a4,16(a5)
    disk.free[i] = 1;
    800055e8:	4705                	li	a4,1
    800055ea:	00e78c23          	sb	a4,24(a5)
    800055ee:	00e78ca3          	sb	a4,25(a5)
    800055f2:	00e78d23          	sb	a4,26(a5)
    800055f6:	00e78da3          	sb	a4,27(a5)
    800055fa:	00e78e23          	sb	a4,28(a5)
    800055fe:	00e78ea3          	sb	a4,29(a5)
    80005602:	00e78f23          	sb	a4,30(a5)
    80005606:	00e78fa3          	sb	a4,31(a5)
}
    8000560a:	60a2                	ld	ra,8(sp)
    8000560c:	6402                	ld	s0,0(sp)
    8000560e:	0141                	addi	sp,sp,16
    80005610:	8082                	ret
    panic("could not find virtio disk");
    80005612:	00003517          	auipc	a0,0x3
    80005616:	01650513          	addi	a0,a0,22 # 80008628 <etext+0x628>
    8000561a:	00001097          	auipc	ra,0x1
    8000561e:	8c2080e7          	jalr	-1854(ra) # 80005edc <panic>
    panic("virtio disk has no queue 0");
    80005622:	00003517          	auipc	a0,0x3
    80005626:	02650513          	addi	a0,a0,38 # 80008648 <etext+0x648>
    8000562a:	00001097          	auipc	ra,0x1
    8000562e:	8b2080e7          	jalr	-1870(ra) # 80005edc <panic>
    panic("virtio disk max queue too short");
    80005632:	00003517          	auipc	a0,0x3
    80005636:	03650513          	addi	a0,a0,54 # 80008668 <etext+0x668>
    8000563a:	00001097          	auipc	ra,0x1
    8000563e:	8a2080e7          	jalr	-1886(ra) # 80005edc <panic>

0000000080005642 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005642:	7159                	addi	sp,sp,-112
    80005644:	f486                	sd	ra,104(sp)
    80005646:	f0a2                	sd	s0,96(sp)
    80005648:	eca6                	sd	s1,88(sp)
    8000564a:	e8ca                	sd	s2,80(sp)
    8000564c:	e4ce                	sd	s3,72(sp)
    8000564e:	e0d2                	sd	s4,64(sp)
    80005650:	fc56                	sd	s5,56(sp)
    80005652:	f85a                	sd	s6,48(sp)
    80005654:	f45e                	sd	s7,40(sp)
    80005656:	f062                	sd	s8,32(sp)
    80005658:	ec66                	sd	s9,24(sp)
    8000565a:	1880                	addi	s0,sp,112
    8000565c:	8a2a                	mv	s4,a0
    8000565e:	8cae                	mv	s9,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005660:	00c52c03          	lw	s8,12(a0)
    80005664:	001c1c1b          	slliw	s8,s8,0x1
    80005668:	1c02                	slli	s8,s8,0x20
    8000566a:	020c5c13          	srli	s8,s8,0x20

  acquire(&disk.vdisk_lock);
    8000566e:	0023b517          	auipc	a0,0x23b
    80005672:	aba50513          	addi	a0,a0,-1350 # 80240128 <disk+0x2128>
    80005676:	00001097          	auipc	ra,0x1
    8000567a:	de0080e7          	jalr	-544(ra) # 80006456 <acquire>
  for(int i = 0; i < 3; i++){
    8000567e:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005680:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005682:	00239b97          	auipc	s7,0x239
    80005686:	97eb8b93          	addi	s7,s7,-1666 # 8023e000 <disk>
    8000568a:	6b09                	lui	s6,0x2
  for(int i = 0; i < 3; i++){
    8000568c:	4a8d                	li	s5,3
    8000568e:	a88d                	j	80005700 <virtio_disk_rw+0xbe>
      disk.free[i] = 0;
    80005690:	00fb8733          	add	a4,s7,a5
    80005694:	975a                	add	a4,a4,s6
    80005696:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000569a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000569c:	0207c563          	bltz	a5,800056c6 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    800056a0:	2905                	addiw	s2,s2,1
    800056a2:	0611                	addi	a2,a2,4 # 2004 <_entry-0x7fffdffc>
    800056a4:	1b590163          	beq	s2,s5,80005846 <virtio_disk_rw+0x204>
    idx[i] = alloc_desc();
    800056a8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800056aa:	0023b717          	auipc	a4,0x23b
    800056ae:	96e70713          	addi	a4,a4,-1682 # 80240018 <disk+0x2018>
    800056b2:	87ce                	mv	a5,s3
    if(disk.free[i]){
    800056b4:	00074683          	lbu	a3,0(a4)
    800056b8:	fee1                	bnez	a3,80005690 <virtio_disk_rw+0x4e>
  for(int i = 0; i < NUM; i++){
    800056ba:	2785                	addiw	a5,a5,1
    800056bc:	0705                	addi	a4,a4,1
    800056be:	fe979be3          	bne	a5,s1,800056b4 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    800056c2:	57fd                	li	a5,-1
    800056c4:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    800056c6:	03205163          	blez	s2,800056e8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056ca:	f9042503          	lw	a0,-112(s0)
    800056ce:	00000097          	auipc	ra,0x0
    800056d2:	d7c080e7          	jalr	-644(ra) # 8000544a <free_desc>
      for(int j = 0; j < i; j++)
    800056d6:	4785                	li	a5,1
    800056d8:	0127d863          	bge	a5,s2,800056e8 <virtio_disk_rw+0xa6>
        free_desc(idx[j]);
    800056dc:	f9442503          	lw	a0,-108(s0)
    800056e0:	00000097          	auipc	ra,0x0
    800056e4:	d6a080e7          	jalr	-662(ra) # 8000544a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056e8:	0023b597          	auipc	a1,0x23b
    800056ec:	a4058593          	addi	a1,a1,-1472 # 80240128 <disk+0x2128>
    800056f0:	0023b517          	auipc	a0,0x23b
    800056f4:	92850513          	addi	a0,a0,-1752 # 80240018 <disk+0x2018>
    800056f8:	ffffc097          	auipc	ra,0xffffc
    800056fc:	036080e7          	jalr	54(ra) # 8000172e <sleep>
  for(int i = 0; i < 3; i++){
    80005700:	f9040613          	addi	a2,s0,-112
    80005704:	894e                	mv	s2,s3
    80005706:	b74d                	j	800056a8 <virtio_disk_rw+0x66>
  disk.desc[idx[0]].next = idx[1];

  disk.desc[idx[1]].addr = (uint64) b->data;
  disk.desc[idx[1]].len = BSIZE;
  if(write)
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005708:	0023b717          	auipc	a4,0x23b
    8000570c:	8f873703          	ld	a4,-1800(a4) # 80240000 <disk+0x2000>
    80005710:	973e                	add	a4,a4,a5
    80005712:	00071623          	sh	zero,12(a4)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005716:	00239897          	auipc	a7,0x239
    8000571a:	8ea88893          	addi	a7,a7,-1814 # 8023e000 <disk>
    8000571e:	0023b717          	auipc	a4,0x23b
    80005722:	8e270713          	addi	a4,a4,-1822 # 80240000 <disk+0x2000>
    80005726:	6314                	ld	a3,0(a4)
    80005728:	96be                	add	a3,a3,a5
    8000572a:	00c6d583          	lhu	a1,12(a3)
    8000572e:	0015e593          	ori	a1,a1,1
    80005732:	00b69623          	sh	a1,12(a3)
  disk.desc[idx[1]].next = idx[2];
    80005736:	f9842683          	lw	a3,-104(s0)
    8000573a:	630c                	ld	a1,0(a4)
    8000573c:	97ae                	add	a5,a5,a1
    8000573e:	00d79723          	sh	a3,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005742:	20050593          	addi	a1,a0,512
    80005746:	0592                	slli	a1,a1,0x4
    80005748:	95c6                	add	a1,a1,a7
    8000574a:	57fd                	li	a5,-1
    8000574c:	02f58823          	sb	a5,48(a1)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005750:	00469793          	slli	a5,a3,0x4
    80005754:	00073803          	ld	a6,0(a4)
    80005758:	983e                	add	a6,a6,a5
    8000575a:	6689                	lui	a3,0x2
    8000575c:	03068693          	addi	a3,a3,48 # 2030 <_entry-0x7fffdfd0>
    80005760:	96b2                	add	a3,a3,a2
    80005762:	96c6                	add	a3,a3,a7
    80005764:	00d83023          	sd	a3,0(a6)
  disk.desc[idx[2]].len = 1;
    80005768:	6314                	ld	a3,0(a4)
    8000576a:	96be                	add	a3,a3,a5
    8000576c:	4605                	li	a2,1
    8000576e:	c690                	sw	a2,8(a3)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005770:	6314                	ld	a3,0(a4)
    80005772:	96be                	add	a3,a3,a5
    80005774:	4809                	li	a6,2
    80005776:	01069623          	sh	a6,12(a3)
  disk.desc[idx[2]].next = 0;
    8000577a:	6314                	ld	a3,0(a4)
    8000577c:	97b6                	add	a5,a5,a3
    8000577e:	00079723          	sh	zero,14(a5)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005782:	00ca2223          	sw	a2,4(s4)
  disk.info[idx[0]].b = b;
    80005786:	0345b423          	sd	s4,40(a1)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000578a:	6714                	ld	a3,8(a4)
    8000578c:	0026d783          	lhu	a5,2(a3)
    80005790:	8b9d                	andi	a5,a5,7
    80005792:	0786                	slli	a5,a5,0x1
    80005794:	96be                	add	a3,a3,a5
    80005796:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000579a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000579e:	6718                	ld	a4,8(a4)
    800057a0:	00275783          	lhu	a5,2(a4)
    800057a4:	2785                	addiw	a5,a5,1
    800057a6:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057aa:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057ae:	100017b7          	lui	a5,0x10001
    800057b2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057b6:	004a2783          	lw	a5,4(s4)
    800057ba:	02c79163          	bne	a5,a2,800057dc <virtio_disk_rw+0x19a>
    sleep(b, &disk.vdisk_lock);
    800057be:	0023b917          	auipc	s2,0x23b
    800057c2:	96a90913          	addi	s2,s2,-1686 # 80240128 <disk+0x2128>
  while(b->disk == 1) {
    800057c6:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800057c8:	85ca                	mv	a1,s2
    800057ca:	8552                	mv	a0,s4
    800057cc:	ffffc097          	auipc	ra,0xffffc
    800057d0:	f62080e7          	jalr	-158(ra) # 8000172e <sleep>
  while(b->disk == 1) {
    800057d4:	004a2783          	lw	a5,4(s4)
    800057d8:	fe9788e3          	beq	a5,s1,800057c8 <virtio_disk_rw+0x186>
  }

  disk.info[idx[0]].b = 0;
    800057dc:	f9042903          	lw	s2,-112(s0)
    800057e0:	20090713          	addi	a4,s2,512
    800057e4:	0712                	slli	a4,a4,0x4
    800057e6:	00239797          	auipc	a5,0x239
    800057ea:	81a78793          	addi	a5,a5,-2022 # 8023e000 <disk>
    800057ee:	97ba                	add	a5,a5,a4
    800057f0:	0207b423          	sd	zero,40(a5)
    int flag = disk.desc[i].flags;
    800057f4:	0023b997          	auipc	s3,0x23b
    800057f8:	80c98993          	addi	s3,s3,-2036 # 80240000 <disk+0x2000>
    800057fc:	00491713          	slli	a4,s2,0x4
    80005800:	0009b783          	ld	a5,0(s3)
    80005804:	97ba                	add	a5,a5,a4
    80005806:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000580a:	854a                	mv	a0,s2
    8000580c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005810:	00000097          	auipc	ra,0x0
    80005814:	c3a080e7          	jalr	-966(ra) # 8000544a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005818:	8885                	andi	s1,s1,1
    8000581a:	f0ed                	bnez	s1,800057fc <virtio_disk_rw+0x1ba>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000581c:	0023b517          	auipc	a0,0x23b
    80005820:	90c50513          	addi	a0,a0,-1780 # 80240128 <disk+0x2128>
    80005824:	00001097          	auipc	ra,0x1
    80005828:	ce6080e7          	jalr	-794(ra) # 8000650a <release>
}
    8000582c:	70a6                	ld	ra,104(sp)
    8000582e:	7406                	ld	s0,96(sp)
    80005830:	64e6                	ld	s1,88(sp)
    80005832:	6946                	ld	s2,80(sp)
    80005834:	69a6                	ld	s3,72(sp)
    80005836:	6a06                	ld	s4,64(sp)
    80005838:	7ae2                	ld	s5,56(sp)
    8000583a:	7b42                	ld	s6,48(sp)
    8000583c:	7ba2                	ld	s7,40(sp)
    8000583e:	7c02                	ld	s8,32(sp)
    80005840:	6ce2                	ld	s9,24(sp)
    80005842:	6165                	addi	sp,sp,112
    80005844:	8082                	ret
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005846:	f9042503          	lw	a0,-112(s0)
    8000584a:	00451613          	slli	a2,a0,0x4
  if(write)
    8000584e:	00238597          	auipc	a1,0x238
    80005852:	7b258593          	addi	a1,a1,1970 # 8023e000 <disk>
    80005856:	20050793          	addi	a5,a0,512
    8000585a:	0792                	slli	a5,a5,0x4
    8000585c:	97ae                	add	a5,a5,a1
    8000585e:	01903733          	snez	a4,s9
    80005862:	0ae7a423          	sw	a4,168(a5)
  buf0->reserved = 0;
    80005866:	0a07a623          	sw	zero,172(a5)
  buf0->sector = sector;
    8000586a:	0b87b823          	sd	s8,176(a5)
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000586e:	0023a717          	auipc	a4,0x23a
    80005872:	79270713          	addi	a4,a4,1938 # 80240000 <disk+0x2000>
    80005876:	6314                	ld	a3,0(a4)
    80005878:	96b2                	add	a3,a3,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000587a:	6789                	lui	a5,0x2
    8000587c:	0a878793          	addi	a5,a5,168 # 20a8 <_entry-0x7fffdf58>
    80005880:	97b2                	add	a5,a5,a2
    80005882:	97ae                	add	a5,a5,a1
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005884:	e29c                	sd	a5,0(a3)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005886:	631c                	ld	a5,0(a4)
    80005888:	97b2                	add	a5,a5,a2
    8000588a:	46c1                	li	a3,16
    8000588c:	c794                	sw	a3,8(a5)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    8000588e:	631c                	ld	a5,0(a4)
    80005890:	97b2                	add	a5,a5,a2
    80005892:	4685                	li	a3,1
    80005894:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[0]].next = idx[1];
    80005898:	f9442783          	lw	a5,-108(s0)
    8000589c:	6314                	ld	a3,0(a4)
    8000589e:	96b2                	add	a3,a3,a2
    800058a0:	00f69723          	sh	a5,14(a3)
  disk.desc[idx[1]].addr = (uint64) b->data;
    800058a4:	0792                	slli	a5,a5,0x4
    800058a6:	6314                	ld	a3,0(a4)
    800058a8:	96be                	add	a3,a3,a5
    800058aa:	058a0593          	addi	a1,s4,88
    800058ae:	e28c                	sd	a1,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    800058b0:	6318                	ld	a4,0(a4)
    800058b2:	973e                	add	a4,a4,a5
    800058b4:	40000693          	li	a3,1024
    800058b8:	c714                	sw	a3,8(a4)
  if(write)
    800058ba:	e40c97e3          	bnez	s9,80005708 <virtio_disk_rw+0xc6>
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058be:	0023a717          	auipc	a4,0x23a
    800058c2:	74273703          	ld	a4,1858(a4) # 80240000 <disk+0x2000>
    800058c6:	973e                	add	a4,a4,a5
    800058c8:	4689                	li	a3,2
    800058ca:	00d71623          	sh	a3,12(a4)
    800058ce:	b5a1                	j	80005716 <virtio_disk_rw+0xd4>

00000000800058d0 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058d0:	1101                	addi	sp,sp,-32
    800058d2:	ec06                	sd	ra,24(sp)
    800058d4:	e822                	sd	s0,16(sp)
    800058d6:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058d8:	0023b517          	auipc	a0,0x23b
    800058dc:	85050513          	addi	a0,a0,-1968 # 80240128 <disk+0x2128>
    800058e0:	00001097          	auipc	ra,0x1
    800058e4:	b76080e7          	jalr	-1162(ra) # 80006456 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058e8:	100017b7          	lui	a5,0x10001
    800058ec:	53b8                	lw	a4,96(a5)
    800058ee:	8b0d                	andi	a4,a4,3
    800058f0:	100017b7          	lui	a5,0x10001
    800058f4:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    800058f6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058fa:	0023a797          	auipc	a5,0x23a
    800058fe:	70678793          	addi	a5,a5,1798 # 80240000 <disk+0x2000>
    80005902:	6b94                	ld	a3,16(a5)
    80005904:	0207d703          	lhu	a4,32(a5)
    80005908:	0026d783          	lhu	a5,2(a3)
    8000590c:	06f70563          	beq	a4,a5,80005976 <virtio_disk_intr+0xa6>
    80005910:	e426                	sd	s1,8(sp)
    80005912:	e04a                	sd	s2,0(sp)
    __sync_synchronize();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005914:	00238917          	auipc	s2,0x238
    80005918:	6ec90913          	addi	s2,s2,1772 # 8023e000 <disk>
    8000591c:	0023a497          	auipc	s1,0x23a
    80005920:	6e448493          	addi	s1,s1,1764 # 80240000 <disk+0x2000>
    __sync_synchronize();
    80005924:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005928:	6898                	ld	a4,16(s1)
    8000592a:	0204d783          	lhu	a5,32(s1)
    8000592e:	8b9d                	andi	a5,a5,7
    80005930:	078e                	slli	a5,a5,0x3
    80005932:	97ba                	add	a5,a5,a4
    80005934:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005936:	20078713          	addi	a4,a5,512
    8000593a:	0712                	slli	a4,a4,0x4
    8000593c:	974a                	add	a4,a4,s2
    8000593e:	03074703          	lbu	a4,48(a4)
    80005942:	e731                	bnez	a4,8000598e <virtio_disk_intr+0xbe>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005944:	20078793          	addi	a5,a5,512
    80005948:	0792                	slli	a5,a5,0x4
    8000594a:	97ca                	add	a5,a5,s2
    8000594c:	7788                	ld	a0,40(a5)
    b->disk = 0;   // disk is done with buf
    8000594e:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005952:	ffffc097          	auipc	ra,0xffffc
    80005956:	f68080e7          	jalr	-152(ra) # 800018ba <wakeup>

    disk.used_idx += 1;
    8000595a:	0204d783          	lhu	a5,32(s1)
    8000595e:	2785                	addiw	a5,a5,1
    80005960:	17c2                	slli	a5,a5,0x30
    80005962:	93c1                	srli	a5,a5,0x30
    80005964:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005968:	6898                	ld	a4,16(s1)
    8000596a:	00275703          	lhu	a4,2(a4)
    8000596e:	faf71be3          	bne	a4,a5,80005924 <virtio_disk_intr+0x54>
    80005972:	64a2                	ld	s1,8(sp)
    80005974:	6902                	ld	s2,0(sp)
  }

  release(&disk.vdisk_lock);
    80005976:	0023a517          	auipc	a0,0x23a
    8000597a:	7b250513          	addi	a0,a0,1970 # 80240128 <disk+0x2128>
    8000597e:	00001097          	auipc	ra,0x1
    80005982:	b8c080e7          	jalr	-1140(ra) # 8000650a <release>
}
    80005986:	60e2                	ld	ra,24(sp)
    80005988:	6442                	ld	s0,16(sp)
    8000598a:	6105                	addi	sp,sp,32
    8000598c:	8082                	ret
      panic("virtio_disk_intr status");
    8000598e:	00003517          	auipc	a0,0x3
    80005992:	cfa50513          	addi	a0,a0,-774 # 80008688 <etext+0x688>
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	546080e7          	jalr	1350(ra) # 80005edc <panic>

000000008000599e <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000599e:	1141                	addi	sp,sp,-16
    800059a0:	e422                	sd	s0,8(sp)
    800059a2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059a4:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059a8:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059ac:	0037979b          	slliw	a5,a5,0x3
    800059b0:	02004737          	lui	a4,0x2004
    800059b4:	97ba                	add	a5,a5,a4
    800059b6:	0200c737          	lui	a4,0x200c
    800059ba:	1761                	addi	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    800059bc:	6318                	ld	a4,0(a4)
    800059be:	000f4637          	lui	a2,0xf4
    800059c2:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059c6:	9732                	add	a4,a4,a2
    800059c8:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059ca:	00259693          	slli	a3,a1,0x2
    800059ce:	96ae                	add	a3,a3,a1
    800059d0:	068e                	slli	a3,a3,0x3
    800059d2:	0023b717          	auipc	a4,0x23b
    800059d6:	62e70713          	addi	a4,a4,1582 # 80241000 <timer_scratch>
    800059da:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059dc:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059de:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059e0:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059e4:	00000797          	auipc	a5,0x0
    800059e8:	99c78793          	addi	a5,a5,-1636 # 80005380 <timervec>
    800059ec:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059f0:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059f4:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059f8:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059fc:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a00:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a04:	30479073          	csrw	mie,a5
}
    80005a08:	6422                	ld	s0,8(sp)
    80005a0a:	0141                	addi	sp,sp,16
    80005a0c:	8082                	ret

0000000080005a0e <start>:
{
    80005a0e:	1141                	addi	sp,sp,-16
    80005a10:	e406                	sd	ra,8(sp)
    80005a12:	e022                	sd	s0,0(sp)
    80005a14:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a16:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a1a:	7779                	lui	a4,0xffffe
    80005a1c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdb55bf>
    80005a20:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a22:	6705                	lui	a4,0x1
    80005a24:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a28:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a2a:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a2e:	ffffb797          	auipc	a5,0xffffb
    80005a32:	9a078793          	addi	a5,a5,-1632 # 800003ce <main>
    80005a36:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a3a:	4781                	li	a5,0
    80005a3c:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a40:	67c1                	lui	a5,0x10
    80005a42:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005a44:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a48:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a4c:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a50:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a54:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a58:	57fd                	li	a5,-1
    80005a5a:	83a9                	srli	a5,a5,0xa
    80005a5c:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a60:	47bd                	li	a5,15
    80005a62:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a66:	00000097          	auipc	ra,0x0
    80005a6a:	f38080e7          	jalr	-200(ra) # 8000599e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a6e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a72:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a74:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a76:	30200073          	mret
}
    80005a7a:	60a2                	ld	ra,8(sp)
    80005a7c:	6402                	ld	s0,0(sp)
    80005a7e:	0141                	addi	sp,sp,16
    80005a80:	8082                	ret

0000000080005a82 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a82:	715d                	addi	sp,sp,-80
    80005a84:	e486                	sd	ra,72(sp)
    80005a86:	e0a2                	sd	s0,64(sp)
    80005a88:	f84a                	sd	s2,48(sp)
    80005a8a:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a8c:	04c05663          	blez	a2,80005ad8 <consolewrite+0x56>
    80005a90:	fc26                	sd	s1,56(sp)
    80005a92:	f44e                	sd	s3,40(sp)
    80005a94:	f052                	sd	s4,32(sp)
    80005a96:	ec56                	sd	s5,24(sp)
    80005a98:	8a2a                	mv	s4,a0
    80005a9a:	84ae                	mv	s1,a1
    80005a9c:	89b2                	mv	s3,a2
    80005a9e:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005aa0:	5afd                	li	s5,-1
    80005aa2:	4685                	li	a3,1
    80005aa4:	8626                	mv	a2,s1
    80005aa6:	85d2                	mv	a1,s4
    80005aa8:	fbf40513          	addi	a0,s0,-65
    80005aac:	ffffc097          	auipc	ra,0xffffc
    80005ab0:	07c080e7          	jalr	124(ra) # 80001b28 <either_copyin>
    80005ab4:	03550463          	beq	a0,s5,80005adc <consolewrite+0x5a>
      break;
    uartputc(c);
    80005ab8:	fbf44503          	lbu	a0,-65(s0)
    80005abc:	00000097          	auipc	ra,0x0
    80005ac0:	7de080e7          	jalr	2014(ra) # 8000629a <uartputc>
  for(i = 0; i < n; i++){
    80005ac4:	2905                	addiw	s2,s2,1
    80005ac6:	0485                	addi	s1,s1,1
    80005ac8:	fd299de3          	bne	s3,s2,80005aa2 <consolewrite+0x20>
    80005acc:	894e                	mv	s2,s3
    80005ace:	74e2                	ld	s1,56(sp)
    80005ad0:	79a2                	ld	s3,40(sp)
    80005ad2:	7a02                	ld	s4,32(sp)
    80005ad4:	6ae2                	ld	s5,24(sp)
    80005ad6:	a039                	j	80005ae4 <consolewrite+0x62>
    80005ad8:	4901                	li	s2,0
    80005ada:	a029                	j	80005ae4 <consolewrite+0x62>
    80005adc:	74e2                	ld	s1,56(sp)
    80005ade:	79a2                	ld	s3,40(sp)
    80005ae0:	7a02                	ld	s4,32(sp)
    80005ae2:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80005ae4:	854a                	mv	a0,s2
    80005ae6:	60a6                	ld	ra,72(sp)
    80005ae8:	6406                	ld	s0,64(sp)
    80005aea:	7942                	ld	s2,48(sp)
    80005aec:	6161                	addi	sp,sp,80
    80005aee:	8082                	ret

0000000080005af0 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005af0:	711d                	addi	sp,sp,-96
    80005af2:	ec86                	sd	ra,88(sp)
    80005af4:	e8a2                	sd	s0,80(sp)
    80005af6:	e4a6                	sd	s1,72(sp)
    80005af8:	e0ca                	sd	s2,64(sp)
    80005afa:	fc4e                	sd	s3,56(sp)
    80005afc:	f852                	sd	s4,48(sp)
    80005afe:	f456                	sd	s5,40(sp)
    80005b00:	f05a                	sd	s6,32(sp)
    80005b02:	1080                	addi	s0,sp,96
    80005b04:	8aaa                	mv	s5,a0
    80005b06:	8a2e                	mv	s4,a1
    80005b08:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b0a:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80005b0e:	00243517          	auipc	a0,0x243
    80005b12:	63250513          	addi	a0,a0,1586 # 80249140 <cons>
    80005b16:	00001097          	auipc	ra,0x1
    80005b1a:	940080e7          	jalr	-1728(ra) # 80006456 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b1e:	00243497          	auipc	s1,0x243
    80005b22:	62248493          	addi	s1,s1,1570 # 80249140 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b26:	00243917          	auipc	s2,0x243
    80005b2a:	6b290913          	addi	s2,s2,1714 # 802491d8 <cons+0x98>
  while(n > 0){
    80005b2e:	0d305463          	blez	s3,80005bf6 <consoleread+0x106>
    while(cons.r == cons.w){
    80005b32:	0984a783          	lw	a5,152(s1)
    80005b36:	09c4a703          	lw	a4,156(s1)
    80005b3a:	0af71963          	bne	a4,a5,80005bec <consoleread+0xfc>
      if(myproc()->killed){
    80005b3e:	ffffb097          	auipc	ra,0xffffb
    80005b42:	52a080e7          	jalr	1322(ra) # 80001068 <myproc>
    80005b46:	551c                	lw	a5,40(a0)
    80005b48:	e7ad                	bnez	a5,80005bb2 <consoleread+0xc2>
      sleep(&cons.r, &cons.lock);
    80005b4a:	85a6                	mv	a1,s1
    80005b4c:	854a                	mv	a0,s2
    80005b4e:	ffffc097          	auipc	ra,0xffffc
    80005b52:	be0080e7          	jalr	-1056(ra) # 8000172e <sleep>
    while(cons.r == cons.w){
    80005b56:	0984a783          	lw	a5,152(s1)
    80005b5a:	09c4a703          	lw	a4,156(s1)
    80005b5e:	fef700e3          	beq	a4,a5,80005b3e <consoleread+0x4e>
    80005b62:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF];
    80005b64:	00243717          	auipc	a4,0x243
    80005b68:	5dc70713          	addi	a4,a4,1500 # 80249140 <cons>
    80005b6c:	0017869b          	addiw	a3,a5,1
    80005b70:	08d72c23          	sw	a3,152(a4)
    80005b74:	07f7f693          	andi	a3,a5,127
    80005b78:	9736                	add	a4,a4,a3
    80005b7a:	01874703          	lbu	a4,24(a4)
    80005b7e:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80005b82:	4691                	li	a3,4
    80005b84:	04db8a63          	beq	s7,a3,80005bd8 <consoleread+0xe8>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005b88:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b8c:	4685                	li	a3,1
    80005b8e:	faf40613          	addi	a2,s0,-81
    80005b92:	85d2                	mv	a1,s4
    80005b94:	8556                	mv	a0,s5
    80005b96:	ffffc097          	auipc	ra,0xffffc
    80005b9a:	f3c080e7          	jalr	-196(ra) # 80001ad2 <either_copyout>
    80005b9e:	57fd                	li	a5,-1
    80005ba0:	04f50a63          	beq	a0,a5,80005bf4 <consoleread+0x104>
      break;

    dst++;
    80005ba4:	0a05                	addi	s4,s4,1
    --n;
    80005ba6:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005ba8:	47a9                	li	a5,10
    80005baa:	06fb8163          	beq	s7,a5,80005c0c <consoleread+0x11c>
    80005bae:	6be2                	ld	s7,24(sp)
    80005bb0:	bfbd                	j	80005b2e <consoleread+0x3e>
        release(&cons.lock);
    80005bb2:	00243517          	auipc	a0,0x243
    80005bb6:	58e50513          	addi	a0,a0,1422 # 80249140 <cons>
    80005bba:	00001097          	auipc	ra,0x1
    80005bbe:	950080e7          	jalr	-1712(ra) # 8000650a <release>
        return -1;
    80005bc2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005bc4:	60e6                	ld	ra,88(sp)
    80005bc6:	6446                	ld	s0,80(sp)
    80005bc8:	64a6                	ld	s1,72(sp)
    80005bca:	6906                	ld	s2,64(sp)
    80005bcc:	79e2                	ld	s3,56(sp)
    80005bce:	7a42                	ld	s4,48(sp)
    80005bd0:	7aa2                	ld	s5,40(sp)
    80005bd2:	7b02                	ld	s6,32(sp)
    80005bd4:	6125                	addi	sp,sp,96
    80005bd6:	8082                	ret
      if(n < target){
    80005bd8:	0009871b          	sext.w	a4,s3
    80005bdc:	01677a63          	bgeu	a4,s6,80005bf0 <consoleread+0x100>
        cons.r--;
    80005be0:	00243717          	auipc	a4,0x243
    80005be4:	5ef72c23          	sw	a5,1528(a4) # 802491d8 <cons+0x98>
    80005be8:	6be2                	ld	s7,24(sp)
    80005bea:	a031                	j	80005bf6 <consoleread+0x106>
    80005bec:	ec5e                	sd	s7,24(sp)
    80005bee:	bf9d                	j	80005b64 <consoleread+0x74>
    80005bf0:	6be2                	ld	s7,24(sp)
    80005bf2:	a011                	j	80005bf6 <consoleread+0x106>
    80005bf4:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005bf6:	00243517          	auipc	a0,0x243
    80005bfa:	54a50513          	addi	a0,a0,1354 # 80249140 <cons>
    80005bfe:	00001097          	auipc	ra,0x1
    80005c02:	90c080e7          	jalr	-1780(ra) # 8000650a <release>
  return target - n;
    80005c06:	413b053b          	subw	a0,s6,s3
    80005c0a:	bf6d                	j	80005bc4 <consoleread+0xd4>
    80005c0c:	6be2                	ld	s7,24(sp)
    80005c0e:	b7e5                	j	80005bf6 <consoleread+0x106>

0000000080005c10 <consputc>:
{
    80005c10:	1141                	addi	sp,sp,-16
    80005c12:	e406                	sd	ra,8(sp)
    80005c14:	e022                	sd	s0,0(sp)
    80005c16:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c18:	10000793          	li	a5,256
    80005c1c:	00f50a63          	beq	a0,a5,80005c30 <consputc+0x20>
    uartputc_sync(c);
    80005c20:	00000097          	auipc	ra,0x0
    80005c24:	59c080e7          	jalr	1436(ra) # 800061bc <uartputc_sync>
}
    80005c28:	60a2                	ld	ra,8(sp)
    80005c2a:	6402                	ld	s0,0(sp)
    80005c2c:	0141                	addi	sp,sp,16
    80005c2e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c30:	4521                	li	a0,8
    80005c32:	00000097          	auipc	ra,0x0
    80005c36:	58a080e7          	jalr	1418(ra) # 800061bc <uartputc_sync>
    80005c3a:	02000513          	li	a0,32
    80005c3e:	00000097          	auipc	ra,0x0
    80005c42:	57e080e7          	jalr	1406(ra) # 800061bc <uartputc_sync>
    80005c46:	4521                	li	a0,8
    80005c48:	00000097          	auipc	ra,0x0
    80005c4c:	574080e7          	jalr	1396(ra) # 800061bc <uartputc_sync>
    80005c50:	bfe1                	j	80005c28 <consputc+0x18>

0000000080005c52 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c52:	1101                	addi	sp,sp,-32
    80005c54:	ec06                	sd	ra,24(sp)
    80005c56:	e822                	sd	s0,16(sp)
    80005c58:	e426                	sd	s1,8(sp)
    80005c5a:	1000                	addi	s0,sp,32
    80005c5c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c5e:	00243517          	auipc	a0,0x243
    80005c62:	4e250513          	addi	a0,a0,1250 # 80249140 <cons>
    80005c66:	00000097          	auipc	ra,0x0
    80005c6a:	7f0080e7          	jalr	2032(ra) # 80006456 <acquire>

  switch(c){
    80005c6e:	47d5                	li	a5,21
    80005c70:	0af48563          	beq	s1,a5,80005d1a <consoleintr+0xc8>
    80005c74:	0297c963          	blt	a5,s1,80005ca6 <consoleintr+0x54>
    80005c78:	47a1                	li	a5,8
    80005c7a:	0ef48c63          	beq	s1,a5,80005d72 <consoleintr+0x120>
    80005c7e:	47c1                	li	a5,16
    80005c80:	10f49f63          	bne	s1,a5,80005d9e <consoleintr+0x14c>
  case C('P'):  // Print process list.
    procdump();
    80005c84:	ffffc097          	auipc	ra,0xffffc
    80005c88:	efa080e7          	jalr	-262(ra) # 80001b7e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c8c:	00243517          	auipc	a0,0x243
    80005c90:	4b450513          	addi	a0,a0,1204 # 80249140 <cons>
    80005c94:	00001097          	auipc	ra,0x1
    80005c98:	876080e7          	jalr	-1930(ra) # 8000650a <release>
}
    80005c9c:	60e2                	ld	ra,24(sp)
    80005c9e:	6442                	ld	s0,16(sp)
    80005ca0:	64a2                	ld	s1,8(sp)
    80005ca2:	6105                	addi	sp,sp,32
    80005ca4:	8082                	ret
  switch(c){
    80005ca6:	07f00793          	li	a5,127
    80005caa:	0cf48463          	beq	s1,a5,80005d72 <consoleintr+0x120>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005cae:	00243717          	auipc	a4,0x243
    80005cb2:	49270713          	addi	a4,a4,1170 # 80249140 <cons>
    80005cb6:	0a072783          	lw	a5,160(a4)
    80005cba:	09872703          	lw	a4,152(a4)
    80005cbe:	9f99                	subw	a5,a5,a4
    80005cc0:	07f00713          	li	a4,127
    80005cc4:	fcf764e3          	bltu	a4,a5,80005c8c <consoleintr+0x3a>
      c = (c == '\r') ? '\n' : c;
    80005cc8:	47b5                	li	a5,13
    80005cca:	0cf48d63          	beq	s1,a5,80005da4 <consoleintr+0x152>
      consputc(c);
    80005cce:	8526                	mv	a0,s1
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	f40080e7          	jalr	-192(ra) # 80005c10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005cd8:	00243797          	auipc	a5,0x243
    80005cdc:	46878793          	addi	a5,a5,1128 # 80249140 <cons>
    80005ce0:	0a07a703          	lw	a4,160(a5)
    80005ce4:	0017069b          	addiw	a3,a4,1
    80005ce8:	0006861b          	sext.w	a2,a3
    80005cec:	0ad7a023          	sw	a3,160(a5)
    80005cf0:	07f77713          	andi	a4,a4,127
    80005cf4:	97ba                	add	a5,a5,a4
    80005cf6:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80005cfa:	47a9                	li	a5,10
    80005cfc:	0cf48b63          	beq	s1,a5,80005dd2 <consoleintr+0x180>
    80005d00:	4791                	li	a5,4
    80005d02:	0cf48863          	beq	s1,a5,80005dd2 <consoleintr+0x180>
    80005d06:	00243797          	auipc	a5,0x243
    80005d0a:	4d27a783          	lw	a5,1234(a5) # 802491d8 <cons+0x98>
    80005d0e:	0807879b          	addiw	a5,a5,128
    80005d12:	f6f61de3          	bne	a2,a5,80005c8c <consoleintr+0x3a>
    80005d16:	863e                	mv	a2,a5
    80005d18:	a86d                	j	80005dd2 <consoleintr+0x180>
    80005d1a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005d1c:	00243717          	auipc	a4,0x243
    80005d20:	42470713          	addi	a4,a4,1060 # 80249140 <cons>
    80005d24:	0a072783          	lw	a5,160(a4)
    80005d28:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d2c:	00243497          	auipc	s1,0x243
    80005d30:	41448493          	addi	s1,s1,1044 # 80249140 <cons>
    while(cons.e != cons.w &&
    80005d34:	4929                	li	s2,10
    80005d36:	02f70a63          	beq	a4,a5,80005d6a <consoleintr+0x118>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    80005d3a:	37fd                	addiw	a5,a5,-1
    80005d3c:	07f7f713          	andi	a4,a5,127
    80005d40:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d42:	01874703          	lbu	a4,24(a4)
    80005d46:	03270463          	beq	a4,s2,80005d6e <consoleintr+0x11c>
      cons.e--;
    80005d4a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d4e:	10000513          	li	a0,256
    80005d52:	00000097          	auipc	ra,0x0
    80005d56:	ebe080e7          	jalr	-322(ra) # 80005c10 <consputc>
    while(cons.e != cons.w &&
    80005d5a:	0a04a783          	lw	a5,160(s1)
    80005d5e:	09c4a703          	lw	a4,156(s1)
    80005d62:	fcf71ce3          	bne	a4,a5,80005d3a <consoleintr+0xe8>
    80005d66:	6902                	ld	s2,0(sp)
    80005d68:	b715                	j	80005c8c <consoleintr+0x3a>
    80005d6a:	6902                	ld	s2,0(sp)
    80005d6c:	b705                	j	80005c8c <consoleintr+0x3a>
    80005d6e:	6902                	ld	s2,0(sp)
    80005d70:	bf31                	j	80005c8c <consoleintr+0x3a>
    if(cons.e != cons.w){
    80005d72:	00243717          	auipc	a4,0x243
    80005d76:	3ce70713          	addi	a4,a4,974 # 80249140 <cons>
    80005d7a:	0a072783          	lw	a5,160(a4)
    80005d7e:	09c72703          	lw	a4,156(a4)
    80005d82:	f0f705e3          	beq	a4,a5,80005c8c <consoleintr+0x3a>
      cons.e--;
    80005d86:	37fd                	addiw	a5,a5,-1
    80005d88:	00243717          	auipc	a4,0x243
    80005d8c:	44f72c23          	sw	a5,1112(a4) # 802491e0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d90:	10000513          	li	a0,256
    80005d94:	00000097          	auipc	ra,0x0
    80005d98:	e7c080e7          	jalr	-388(ra) # 80005c10 <consputc>
    80005d9c:	bdc5                	j	80005c8c <consoleintr+0x3a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    80005d9e:	ee0487e3          	beqz	s1,80005c8c <consoleintr+0x3a>
    80005da2:	b731                	j	80005cae <consoleintr+0x5c>
      consputc(c);
    80005da4:	4529                	li	a0,10
    80005da6:	00000097          	auipc	ra,0x0
    80005daa:	e6a080e7          	jalr	-406(ra) # 80005c10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80005dae:	00243797          	auipc	a5,0x243
    80005db2:	39278793          	addi	a5,a5,914 # 80249140 <cons>
    80005db6:	0a07a703          	lw	a4,160(a5)
    80005dba:	0017069b          	addiw	a3,a4,1
    80005dbe:	0006861b          	sext.w	a2,a3
    80005dc2:	0ad7a023          	sw	a3,160(a5)
    80005dc6:	07f77713          	andi	a4,a4,127
    80005dca:	97ba                	add	a5,a5,a4
    80005dcc:	4729                	li	a4,10
    80005dce:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005dd2:	00243797          	auipc	a5,0x243
    80005dd6:	40c7a523          	sw	a2,1034(a5) # 802491dc <cons+0x9c>
        wakeup(&cons.r);
    80005dda:	00243517          	auipc	a0,0x243
    80005dde:	3fe50513          	addi	a0,a0,1022 # 802491d8 <cons+0x98>
    80005de2:	ffffc097          	auipc	ra,0xffffc
    80005de6:	ad8080e7          	jalr	-1320(ra) # 800018ba <wakeup>
    80005dea:	b54d                	j	80005c8c <consoleintr+0x3a>

0000000080005dec <consoleinit>:

void
consoleinit(void)
{
    80005dec:	1141                	addi	sp,sp,-16
    80005dee:	e406                	sd	ra,8(sp)
    80005df0:	e022                	sd	s0,0(sp)
    80005df2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005df4:	00003597          	auipc	a1,0x3
    80005df8:	8ac58593          	addi	a1,a1,-1876 # 800086a0 <etext+0x6a0>
    80005dfc:	00243517          	auipc	a0,0x243
    80005e00:	34450513          	addi	a0,a0,836 # 80249140 <cons>
    80005e04:	00000097          	auipc	ra,0x0
    80005e08:	5c2080e7          	jalr	1474(ra) # 800063c6 <initlock>

  uartinit();
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	354080e7          	jalr	852(ra) # 80006160 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e14:	00236797          	auipc	a5,0x236
    80005e18:	2cc78793          	addi	a5,a5,716 # 8023c0e0 <devsw>
    80005e1c:	00000717          	auipc	a4,0x0
    80005e20:	cd470713          	addi	a4,a4,-812 # 80005af0 <consoleread>
    80005e24:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e26:	00000717          	auipc	a4,0x0
    80005e2a:	c5c70713          	addi	a4,a4,-932 # 80005a82 <consolewrite>
    80005e2e:	ef98                	sd	a4,24(a5)
}
    80005e30:	60a2                	ld	ra,8(sp)
    80005e32:	6402                	ld	s0,0(sp)
    80005e34:	0141                	addi	sp,sp,16
    80005e36:	8082                	ret

0000000080005e38 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e38:	7179                	addi	sp,sp,-48
    80005e3a:	f406                	sd	ra,40(sp)
    80005e3c:	f022                	sd	s0,32(sp)
    80005e3e:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e40:	c219                	beqz	a2,80005e46 <printint+0xe>
    80005e42:	08054963          	bltz	a0,80005ed4 <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80005e46:	2501                	sext.w	a0,a0
    80005e48:	4881                	li	a7,0
    80005e4a:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e4e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e50:	2581                	sext.w	a1,a1
    80005e52:	00003617          	auipc	a2,0x3
    80005e56:	9ae60613          	addi	a2,a2,-1618 # 80008800 <digits>
    80005e5a:	883a                	mv	a6,a4
    80005e5c:	2705                	addiw	a4,a4,1
    80005e5e:	02b577bb          	remuw	a5,a0,a1
    80005e62:	1782                	slli	a5,a5,0x20
    80005e64:	9381                	srli	a5,a5,0x20
    80005e66:	97b2                	add	a5,a5,a2
    80005e68:	0007c783          	lbu	a5,0(a5)
    80005e6c:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e70:	0005079b          	sext.w	a5,a0
    80005e74:	02b5553b          	divuw	a0,a0,a1
    80005e78:	0685                	addi	a3,a3,1
    80005e7a:	feb7f0e3          	bgeu	a5,a1,80005e5a <printint+0x22>

  if(sign)
    80005e7e:	00088c63          	beqz	a7,80005e96 <printint+0x5e>
    buf[i++] = '-';
    80005e82:	fe070793          	addi	a5,a4,-32
    80005e86:	00878733          	add	a4,a5,s0
    80005e8a:	02d00793          	li	a5,45
    80005e8e:	fef70823          	sb	a5,-16(a4)
    80005e92:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e96:	02e05b63          	blez	a4,80005ecc <printint+0x94>
    80005e9a:	ec26                	sd	s1,24(sp)
    80005e9c:	e84a                	sd	s2,16(sp)
    80005e9e:	fd040793          	addi	a5,s0,-48
    80005ea2:	00e784b3          	add	s1,a5,a4
    80005ea6:	fff78913          	addi	s2,a5,-1
    80005eaa:	993a                	add	s2,s2,a4
    80005eac:	377d                	addiw	a4,a4,-1
    80005eae:	1702                	slli	a4,a4,0x20
    80005eb0:	9301                	srli	a4,a4,0x20
    80005eb2:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005eb6:	fff4c503          	lbu	a0,-1(s1)
    80005eba:	00000097          	auipc	ra,0x0
    80005ebe:	d56080e7          	jalr	-682(ra) # 80005c10 <consputc>
  while(--i >= 0)
    80005ec2:	14fd                	addi	s1,s1,-1
    80005ec4:	ff2499e3          	bne	s1,s2,80005eb6 <printint+0x7e>
    80005ec8:	64e2                	ld	s1,24(sp)
    80005eca:	6942                	ld	s2,16(sp)
}
    80005ecc:	70a2                	ld	ra,40(sp)
    80005ece:	7402                	ld	s0,32(sp)
    80005ed0:	6145                	addi	sp,sp,48
    80005ed2:	8082                	ret
    x = -xx;
    80005ed4:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ed8:	4885                	li	a7,1
    x = -xx;
    80005eda:	bf85                	j	80005e4a <printint+0x12>

0000000080005edc <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005edc:	1101                	addi	sp,sp,-32
    80005ede:	ec06                	sd	ra,24(sp)
    80005ee0:	e822                	sd	s0,16(sp)
    80005ee2:	e426                	sd	s1,8(sp)
    80005ee4:	1000                	addi	s0,sp,32
    80005ee6:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005ee8:	00243797          	auipc	a5,0x243
    80005eec:	3007ac23          	sw	zero,792(a5) # 80249200 <pr+0x18>
  printf("panic: ");
    80005ef0:	00002517          	auipc	a0,0x2
    80005ef4:	7b850513          	addi	a0,a0,1976 # 800086a8 <etext+0x6a8>
    80005ef8:	00000097          	auipc	ra,0x0
    80005efc:	02e080e7          	jalr	46(ra) # 80005f26 <printf>
  printf(s);
    80005f00:	8526                	mv	a0,s1
    80005f02:	00000097          	auipc	ra,0x0
    80005f06:	024080e7          	jalr	36(ra) # 80005f26 <printf>
  printf("\n");
    80005f0a:	00002517          	auipc	a0,0x2
    80005f0e:	11650513          	addi	a0,a0,278 # 80008020 <etext+0x20>
    80005f12:	00000097          	auipc	ra,0x0
    80005f16:	014080e7          	jalr	20(ra) # 80005f26 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f1a:	4785                	li	a5,1
    80005f1c:	00006717          	auipc	a4,0x6
    80005f20:	10f72023          	sw	a5,256(a4) # 8000c01c <panicked>
  for(;;)
    80005f24:	a001                	j	80005f24 <panic+0x48>

0000000080005f26 <printf>:
{
    80005f26:	7131                	addi	sp,sp,-192
    80005f28:	fc86                	sd	ra,120(sp)
    80005f2a:	f8a2                	sd	s0,112(sp)
    80005f2c:	e8d2                	sd	s4,80(sp)
    80005f2e:	f06a                	sd	s10,32(sp)
    80005f30:	0100                	addi	s0,sp,128
    80005f32:	8a2a                	mv	s4,a0
    80005f34:	e40c                	sd	a1,8(s0)
    80005f36:	e810                	sd	a2,16(s0)
    80005f38:	ec14                	sd	a3,24(s0)
    80005f3a:	f018                	sd	a4,32(s0)
    80005f3c:	f41c                	sd	a5,40(s0)
    80005f3e:	03043823          	sd	a6,48(s0)
    80005f42:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f46:	00243d17          	auipc	s10,0x243
    80005f4a:	2bad2d03          	lw	s10,698(s10) # 80249200 <pr+0x18>
  if(locking)
    80005f4e:	040d1463          	bnez	s10,80005f96 <printf+0x70>
  if (fmt == 0)
    80005f52:	040a0b63          	beqz	s4,80005fa8 <printf+0x82>
  va_start(ap, fmt);
    80005f56:	00840793          	addi	a5,s0,8
    80005f5a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f5e:	000a4503          	lbu	a0,0(s4)
    80005f62:	18050b63          	beqz	a0,800060f8 <printf+0x1d2>
    80005f66:	f4a6                	sd	s1,104(sp)
    80005f68:	f0ca                	sd	s2,96(sp)
    80005f6a:	ecce                	sd	s3,88(sp)
    80005f6c:	e4d6                	sd	s5,72(sp)
    80005f6e:	e0da                	sd	s6,64(sp)
    80005f70:	fc5e                	sd	s7,56(sp)
    80005f72:	f862                	sd	s8,48(sp)
    80005f74:	f466                	sd	s9,40(sp)
    80005f76:	ec6e                	sd	s11,24(sp)
    80005f78:	4981                	li	s3,0
    if(c != '%'){
    80005f7a:	02500b13          	li	s6,37
    switch(c){
    80005f7e:	07000b93          	li	s7,112
  consputc('x');
    80005f82:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f84:	00003a97          	auipc	s5,0x3
    80005f88:	87ca8a93          	addi	s5,s5,-1924 # 80008800 <digits>
    switch(c){
    80005f8c:	07300c13          	li	s8,115
    80005f90:	06400d93          	li	s11,100
    80005f94:	a0b1                	j	80005fe0 <printf+0xba>
    acquire(&pr.lock);
    80005f96:	00243517          	auipc	a0,0x243
    80005f9a:	25250513          	addi	a0,a0,594 # 802491e8 <pr>
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	4b8080e7          	jalr	1208(ra) # 80006456 <acquire>
    80005fa6:	b775                	j	80005f52 <printf+0x2c>
    80005fa8:	f4a6                	sd	s1,104(sp)
    80005faa:	f0ca                	sd	s2,96(sp)
    80005fac:	ecce                	sd	s3,88(sp)
    80005fae:	e4d6                	sd	s5,72(sp)
    80005fb0:	e0da                	sd	s6,64(sp)
    80005fb2:	fc5e                	sd	s7,56(sp)
    80005fb4:	f862                	sd	s8,48(sp)
    80005fb6:	f466                	sd	s9,40(sp)
    80005fb8:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80005fba:	00002517          	auipc	a0,0x2
    80005fbe:	6fe50513          	addi	a0,a0,1790 # 800086b8 <etext+0x6b8>
    80005fc2:	00000097          	auipc	ra,0x0
    80005fc6:	f1a080e7          	jalr	-230(ra) # 80005edc <panic>
      consputc(c);
    80005fca:	00000097          	auipc	ra,0x0
    80005fce:	c46080e7          	jalr	-954(ra) # 80005c10 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fd2:	2985                	addiw	s3,s3,1
    80005fd4:	013a07b3          	add	a5,s4,s3
    80005fd8:	0007c503          	lbu	a0,0(a5)
    80005fdc:	10050563          	beqz	a0,800060e6 <printf+0x1c0>
    if(c != '%'){
    80005fe0:	ff6515e3          	bne	a0,s6,80005fca <printf+0xa4>
    c = fmt[++i] & 0xff;
    80005fe4:	2985                	addiw	s3,s3,1
    80005fe6:	013a07b3          	add	a5,s4,s3
    80005fea:	0007c783          	lbu	a5,0(a5)
    80005fee:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80005ff2:	10078b63          	beqz	a5,80006108 <printf+0x1e2>
    switch(c){
    80005ff6:	05778a63          	beq	a5,s7,8000604a <printf+0x124>
    80005ffa:	02fbf663          	bgeu	s7,a5,80006026 <printf+0x100>
    80005ffe:	09878863          	beq	a5,s8,8000608e <printf+0x168>
    80006002:	07800713          	li	a4,120
    80006006:	0ce79563          	bne	a5,a4,800060d0 <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    8000600a:	f8843783          	ld	a5,-120(s0)
    8000600e:	00878713          	addi	a4,a5,8
    80006012:	f8e43423          	sd	a4,-120(s0)
    80006016:	4605                	li	a2,1
    80006018:	85e6                	mv	a1,s9
    8000601a:	4388                	lw	a0,0(a5)
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	e1c080e7          	jalr	-484(ra) # 80005e38 <printint>
      break;
    80006024:	b77d                	j	80005fd2 <printf+0xac>
    switch(c){
    80006026:	09678f63          	beq	a5,s6,800060c4 <printf+0x19e>
    8000602a:	0bb79363          	bne	a5,s11,800060d0 <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    8000602e:	f8843783          	ld	a5,-120(s0)
    80006032:	00878713          	addi	a4,a5,8
    80006036:	f8e43423          	sd	a4,-120(s0)
    8000603a:	4605                	li	a2,1
    8000603c:	45a9                	li	a1,10
    8000603e:	4388                	lw	a0,0(a5)
    80006040:	00000097          	auipc	ra,0x0
    80006044:	df8080e7          	jalr	-520(ra) # 80005e38 <printint>
      break;
    80006048:	b769                	j	80005fd2 <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000604a:	f8843783          	ld	a5,-120(s0)
    8000604e:	00878713          	addi	a4,a5,8
    80006052:	f8e43423          	sd	a4,-120(s0)
    80006056:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000605a:	03000513          	li	a0,48
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	bb2080e7          	jalr	-1102(ra) # 80005c10 <consputc>
  consputc('x');
    80006066:	07800513          	li	a0,120
    8000606a:	00000097          	auipc	ra,0x0
    8000606e:	ba6080e7          	jalr	-1114(ra) # 80005c10 <consputc>
    80006072:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006074:	03c95793          	srli	a5,s2,0x3c
    80006078:	97d6                	add	a5,a5,s5
    8000607a:	0007c503          	lbu	a0,0(a5)
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	b92080e7          	jalr	-1134(ra) # 80005c10 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006086:	0912                	slli	s2,s2,0x4
    80006088:	34fd                	addiw	s1,s1,-1
    8000608a:	f4ed                	bnez	s1,80006074 <printf+0x14e>
    8000608c:	b799                	j	80005fd2 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000608e:	f8843783          	ld	a5,-120(s0)
    80006092:	00878713          	addi	a4,a5,8
    80006096:	f8e43423          	sd	a4,-120(s0)
    8000609a:	6384                	ld	s1,0(a5)
    8000609c:	cc89                	beqz	s1,800060b6 <printf+0x190>
      for(; *s; s++)
    8000609e:	0004c503          	lbu	a0,0(s1)
    800060a2:	d905                	beqz	a0,80005fd2 <printf+0xac>
        consputc(*s);
    800060a4:	00000097          	auipc	ra,0x0
    800060a8:	b6c080e7          	jalr	-1172(ra) # 80005c10 <consputc>
      for(; *s; s++)
    800060ac:	0485                	addi	s1,s1,1
    800060ae:	0004c503          	lbu	a0,0(s1)
    800060b2:	f96d                	bnez	a0,800060a4 <printf+0x17e>
    800060b4:	bf39                	j	80005fd2 <printf+0xac>
        s = "(null)";
    800060b6:	00002497          	auipc	s1,0x2
    800060ba:	5fa48493          	addi	s1,s1,1530 # 800086b0 <etext+0x6b0>
      for(; *s; s++)
    800060be:	02800513          	li	a0,40
    800060c2:	b7cd                	j	800060a4 <printf+0x17e>
      consputc('%');
    800060c4:	855a                	mv	a0,s6
    800060c6:	00000097          	auipc	ra,0x0
    800060ca:	b4a080e7          	jalr	-1206(ra) # 80005c10 <consputc>
      break;
    800060ce:	b711                	j	80005fd2 <printf+0xac>
      consputc('%');
    800060d0:	855a                	mv	a0,s6
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	b3e080e7          	jalr	-1218(ra) # 80005c10 <consputc>
      consputc(c);
    800060da:	8526                	mv	a0,s1
    800060dc:	00000097          	auipc	ra,0x0
    800060e0:	b34080e7          	jalr	-1228(ra) # 80005c10 <consputc>
      break;
    800060e4:	b5fd                	j	80005fd2 <printf+0xac>
    800060e6:	74a6                	ld	s1,104(sp)
    800060e8:	7906                	ld	s2,96(sp)
    800060ea:	69e6                	ld	s3,88(sp)
    800060ec:	6aa6                	ld	s5,72(sp)
    800060ee:	6b06                	ld	s6,64(sp)
    800060f0:	7be2                	ld	s7,56(sp)
    800060f2:	7c42                	ld	s8,48(sp)
    800060f4:	7ca2                	ld	s9,40(sp)
    800060f6:	6de2                	ld	s11,24(sp)
  if(locking)
    800060f8:	020d1263          	bnez	s10,8000611c <printf+0x1f6>
}
    800060fc:	70e6                	ld	ra,120(sp)
    800060fe:	7446                	ld	s0,112(sp)
    80006100:	6a46                	ld	s4,80(sp)
    80006102:	7d02                	ld	s10,32(sp)
    80006104:	6129                	addi	sp,sp,192
    80006106:	8082                	ret
    80006108:	74a6                	ld	s1,104(sp)
    8000610a:	7906                	ld	s2,96(sp)
    8000610c:	69e6                	ld	s3,88(sp)
    8000610e:	6aa6                	ld	s5,72(sp)
    80006110:	6b06                	ld	s6,64(sp)
    80006112:	7be2                	ld	s7,56(sp)
    80006114:	7c42                	ld	s8,48(sp)
    80006116:	7ca2                	ld	s9,40(sp)
    80006118:	6de2                	ld	s11,24(sp)
    8000611a:	bff9                	j	800060f8 <printf+0x1d2>
    release(&pr.lock);
    8000611c:	00243517          	auipc	a0,0x243
    80006120:	0cc50513          	addi	a0,a0,204 # 802491e8 <pr>
    80006124:	00000097          	auipc	ra,0x0
    80006128:	3e6080e7          	jalr	998(ra) # 8000650a <release>
}
    8000612c:	bfc1                	j	800060fc <printf+0x1d6>

000000008000612e <printfinit>:
    ;
}

void
printfinit(void)
{
    8000612e:	1101                	addi	sp,sp,-32
    80006130:	ec06                	sd	ra,24(sp)
    80006132:	e822                	sd	s0,16(sp)
    80006134:	e426                	sd	s1,8(sp)
    80006136:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    80006138:	00243497          	auipc	s1,0x243
    8000613c:	0b048493          	addi	s1,s1,176 # 802491e8 <pr>
    80006140:	00002597          	auipc	a1,0x2
    80006144:	58858593          	addi	a1,a1,1416 # 800086c8 <etext+0x6c8>
    80006148:	8526                	mv	a0,s1
    8000614a:	00000097          	auipc	ra,0x0
    8000614e:	27c080e7          	jalr	636(ra) # 800063c6 <initlock>
  pr.locking = 1;
    80006152:	4785                	li	a5,1
    80006154:	cc9c                	sw	a5,24(s1)
}
    80006156:	60e2                	ld	ra,24(sp)
    80006158:	6442                	ld	s0,16(sp)
    8000615a:	64a2                	ld	s1,8(sp)
    8000615c:	6105                	addi	sp,sp,32
    8000615e:	8082                	ret

0000000080006160 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006160:	1141                	addi	sp,sp,-16
    80006162:	e406                	sd	ra,8(sp)
    80006164:	e022                	sd	s0,0(sp)
    80006166:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80006168:	100007b7          	lui	a5,0x10000
    8000616c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006170:	10000737          	lui	a4,0x10000
    80006174:	f8000693          	li	a3,-128
    80006178:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000617c:	468d                	li	a3,3
    8000617e:	10000637          	lui	a2,0x10000
    80006182:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006186:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000618a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000618e:	10000737          	lui	a4,0x10000
    80006192:	461d                	li	a2,7
    80006194:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006198:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000619c:	00002597          	auipc	a1,0x2
    800061a0:	53458593          	addi	a1,a1,1332 # 800086d0 <etext+0x6d0>
    800061a4:	00243517          	auipc	a0,0x243
    800061a8:	06450513          	addi	a0,a0,100 # 80249208 <uart_tx_lock>
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	21a080e7          	jalr	538(ra) # 800063c6 <initlock>
}
    800061b4:	60a2                	ld	ra,8(sp)
    800061b6:	6402                	ld	s0,0(sp)
    800061b8:	0141                	addi	sp,sp,16
    800061ba:	8082                	ret

00000000800061bc <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800061bc:	1101                	addi	sp,sp,-32
    800061be:	ec06                	sd	ra,24(sp)
    800061c0:	e822                	sd	s0,16(sp)
    800061c2:	e426                	sd	s1,8(sp)
    800061c4:	1000                	addi	s0,sp,32
    800061c6:	84aa                	mv	s1,a0
  push_off();
    800061c8:	00000097          	auipc	ra,0x0
    800061cc:	242080e7          	jalr	578(ra) # 8000640a <push_off>

  if(panicked){
    800061d0:	00006797          	auipc	a5,0x6
    800061d4:	e4c7a783          	lw	a5,-436(a5) # 8000c01c <panicked>
    800061d8:	eb85                	bnez	a5,80006208 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061da:	10000737          	lui	a4,0x10000
    800061de:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800061e0:	00074783          	lbu	a5,0(a4)
    800061e4:	0207f793          	andi	a5,a5,32
    800061e8:	dfe5                	beqz	a5,800061e0 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061ea:	0ff4f513          	zext.b	a0,s1
    800061ee:	100007b7          	lui	a5,0x10000
    800061f2:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800061f6:	00000097          	auipc	ra,0x0
    800061fa:	2b4080e7          	jalr	692(ra) # 800064aa <pop_off>
}
    800061fe:	60e2                	ld	ra,24(sp)
    80006200:	6442                	ld	s0,16(sp)
    80006202:	64a2                	ld	s1,8(sp)
    80006204:	6105                	addi	sp,sp,32
    80006206:	8082                	ret
    for(;;)
    80006208:	a001                	j	80006208 <uartputc_sync+0x4c>

000000008000620a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000620a:	00006797          	auipc	a5,0x6
    8000620e:	e167b783          	ld	a5,-490(a5) # 8000c020 <uart_tx_r>
    80006212:	00006717          	auipc	a4,0x6
    80006216:	e1673703          	ld	a4,-490(a4) # 8000c028 <uart_tx_w>
    8000621a:	06f70f63          	beq	a4,a5,80006298 <uartstart+0x8e>
{
    8000621e:	7139                	addi	sp,sp,-64
    80006220:	fc06                	sd	ra,56(sp)
    80006222:	f822                	sd	s0,48(sp)
    80006224:	f426                	sd	s1,40(sp)
    80006226:	f04a                	sd	s2,32(sp)
    80006228:	ec4e                	sd	s3,24(sp)
    8000622a:	e852                	sd	s4,16(sp)
    8000622c:	e456                	sd	s5,8(sp)
    8000622e:	e05a                	sd	s6,0(sp)
    80006230:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006232:	10000937          	lui	s2,0x10000
    80006236:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006238:	00243a97          	auipc	s5,0x243
    8000623c:	fd0a8a93          	addi	s5,s5,-48 # 80249208 <uart_tx_lock>
    uart_tx_r += 1;
    80006240:	00006497          	auipc	s1,0x6
    80006244:	de048493          	addi	s1,s1,-544 # 8000c020 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80006248:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000624c:	00006997          	auipc	s3,0x6
    80006250:	ddc98993          	addi	s3,s3,-548 # 8000c028 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006254:	00094703          	lbu	a4,0(s2)
    80006258:	02077713          	andi	a4,a4,32
    8000625c:	c705                	beqz	a4,80006284 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000625e:	01f7f713          	andi	a4,a5,31
    80006262:	9756                	add	a4,a4,s5
    80006264:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80006268:	0785                	addi	a5,a5,1
    8000626a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000626c:	8526                	mv	a0,s1
    8000626e:	ffffb097          	auipc	ra,0xffffb
    80006272:	64c080e7          	jalr	1612(ra) # 800018ba <wakeup>
    WriteReg(THR, c);
    80006276:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000627a:	609c                	ld	a5,0(s1)
    8000627c:	0009b703          	ld	a4,0(s3)
    80006280:	fcf71ae3          	bne	a4,a5,80006254 <uartstart+0x4a>
  }
}
    80006284:	70e2                	ld	ra,56(sp)
    80006286:	7442                	ld	s0,48(sp)
    80006288:	74a2                	ld	s1,40(sp)
    8000628a:	7902                	ld	s2,32(sp)
    8000628c:	69e2                	ld	s3,24(sp)
    8000628e:	6a42                	ld	s4,16(sp)
    80006290:	6aa2                	ld	s5,8(sp)
    80006292:	6b02                	ld	s6,0(sp)
    80006294:	6121                	addi	sp,sp,64
    80006296:	8082                	ret
    80006298:	8082                	ret

000000008000629a <uartputc>:
{
    8000629a:	7179                	addi	sp,sp,-48
    8000629c:	f406                	sd	ra,40(sp)
    8000629e:	f022                	sd	s0,32(sp)
    800062a0:	e052                	sd	s4,0(sp)
    800062a2:	1800                	addi	s0,sp,48
    800062a4:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800062a6:	00243517          	auipc	a0,0x243
    800062aa:	f6250513          	addi	a0,a0,-158 # 80249208 <uart_tx_lock>
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	1a8080e7          	jalr	424(ra) # 80006456 <acquire>
  if(panicked){
    800062b6:	00006797          	auipc	a5,0x6
    800062ba:	d667a783          	lw	a5,-666(a5) # 8000c01c <panicked>
    800062be:	c391                	beqz	a5,800062c2 <uartputc+0x28>
    for(;;)
    800062c0:	a001                	j	800062c0 <uartputc+0x26>
    800062c2:	ec26                	sd	s1,24(sp)
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062c4:	00006717          	auipc	a4,0x6
    800062c8:	d6473703          	ld	a4,-668(a4) # 8000c028 <uart_tx_w>
    800062cc:	00006797          	auipc	a5,0x6
    800062d0:	d547b783          	ld	a5,-684(a5) # 8000c020 <uart_tx_r>
    800062d4:	02078793          	addi	a5,a5,32
    800062d8:	02e79f63          	bne	a5,a4,80006316 <uartputc+0x7c>
    800062dc:	e84a                	sd	s2,16(sp)
    800062de:	e44e                	sd	s3,8(sp)
      sleep(&uart_tx_r, &uart_tx_lock);
    800062e0:	00243997          	auipc	s3,0x243
    800062e4:	f2898993          	addi	s3,s3,-216 # 80249208 <uart_tx_lock>
    800062e8:	00006497          	auipc	s1,0x6
    800062ec:	d3848493          	addi	s1,s1,-712 # 8000c020 <uart_tx_r>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062f0:	00006917          	auipc	s2,0x6
    800062f4:	d3890913          	addi	s2,s2,-712 # 8000c028 <uart_tx_w>
      sleep(&uart_tx_r, &uart_tx_lock);
    800062f8:	85ce                	mv	a1,s3
    800062fa:	8526                	mv	a0,s1
    800062fc:	ffffb097          	auipc	ra,0xffffb
    80006300:	432080e7          	jalr	1074(ra) # 8000172e <sleep>
    if(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006304:	00093703          	ld	a4,0(s2)
    80006308:	609c                	ld	a5,0(s1)
    8000630a:	02078793          	addi	a5,a5,32
    8000630e:	fee785e3          	beq	a5,a4,800062f8 <uartputc+0x5e>
    80006312:	6942                	ld	s2,16(sp)
    80006314:	69a2                	ld	s3,8(sp)
      uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006316:	00243497          	auipc	s1,0x243
    8000631a:	ef248493          	addi	s1,s1,-270 # 80249208 <uart_tx_lock>
    8000631e:	01f77793          	andi	a5,a4,31
    80006322:	97a6                	add	a5,a5,s1
    80006324:	01478c23          	sb	s4,24(a5)
      uart_tx_w += 1;
    80006328:	0705                	addi	a4,a4,1
    8000632a:	00006797          	auipc	a5,0x6
    8000632e:	cee7bf23          	sd	a4,-770(a5) # 8000c028 <uart_tx_w>
      uartstart();
    80006332:	00000097          	auipc	ra,0x0
    80006336:	ed8080e7          	jalr	-296(ra) # 8000620a <uartstart>
      release(&uart_tx_lock);
    8000633a:	8526                	mv	a0,s1
    8000633c:	00000097          	auipc	ra,0x0
    80006340:	1ce080e7          	jalr	462(ra) # 8000650a <release>
    80006344:	64e2                	ld	s1,24(sp)
}
    80006346:	70a2                	ld	ra,40(sp)
    80006348:	7402                	ld	s0,32(sp)
    8000634a:	6a02                	ld	s4,0(sp)
    8000634c:	6145                	addi	sp,sp,48
    8000634e:	8082                	ret

0000000080006350 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006350:	1141                	addi	sp,sp,-16
    80006352:	e422                	sd	s0,8(sp)
    80006354:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80006356:	100007b7          	lui	a5,0x10000
    8000635a:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    8000635c:	0007c783          	lbu	a5,0(a5)
    80006360:	8b85                	andi	a5,a5,1
    80006362:	cb81                	beqz	a5,80006372 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80006364:	100007b7          	lui	a5,0x10000
    80006368:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000636c:	6422                	ld	s0,8(sp)
    8000636e:	0141                	addi	sp,sp,16
    80006370:	8082                	ret
    return -1;
    80006372:	557d                	li	a0,-1
    80006374:	bfe5                	j	8000636c <uartgetc+0x1c>

0000000080006376 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from trap.c.
void
uartintr(void)
{
    80006376:	1101                	addi	sp,sp,-32
    80006378:	ec06                	sd	ra,24(sp)
    8000637a:	e822                	sd	s0,16(sp)
    8000637c:	e426                	sd	s1,8(sp)
    8000637e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006380:	54fd                	li	s1,-1
    80006382:	a029                	j	8000638c <uartintr+0x16>
      break;
    consoleintr(c);
    80006384:	00000097          	auipc	ra,0x0
    80006388:	8ce080e7          	jalr	-1842(ra) # 80005c52 <consoleintr>
    int c = uartgetc();
    8000638c:	00000097          	auipc	ra,0x0
    80006390:	fc4080e7          	jalr	-60(ra) # 80006350 <uartgetc>
    if(c == -1)
    80006394:	fe9518e3          	bne	a0,s1,80006384 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80006398:	00243497          	auipc	s1,0x243
    8000639c:	e7048493          	addi	s1,s1,-400 # 80249208 <uart_tx_lock>
    800063a0:	8526                	mv	a0,s1
    800063a2:	00000097          	auipc	ra,0x0
    800063a6:	0b4080e7          	jalr	180(ra) # 80006456 <acquire>
  uartstart();
    800063aa:	00000097          	auipc	ra,0x0
    800063ae:	e60080e7          	jalr	-416(ra) # 8000620a <uartstart>
  release(&uart_tx_lock);
    800063b2:	8526                	mv	a0,s1
    800063b4:	00000097          	auipc	ra,0x0
    800063b8:	156080e7          	jalr	342(ra) # 8000650a <release>
}
    800063bc:	60e2                	ld	ra,24(sp)
    800063be:	6442                	ld	s0,16(sp)
    800063c0:	64a2                	ld	s1,8(sp)
    800063c2:	6105                	addi	sp,sp,32
    800063c4:	8082                	ret

00000000800063c6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800063c6:	1141                	addi	sp,sp,-16
    800063c8:	e422                	sd	s0,8(sp)
    800063ca:	0800                	addi	s0,sp,16
  lk->name = name;
    800063cc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063ce:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063d2:	00053823          	sd	zero,16(a0)
}
    800063d6:	6422                	ld	s0,8(sp)
    800063d8:	0141                	addi	sp,sp,16
    800063da:	8082                	ret

00000000800063dc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063dc:	411c                	lw	a5,0(a0)
    800063de:	e399                	bnez	a5,800063e4 <holding+0x8>
    800063e0:	4501                	li	a0,0
  return r;
}
    800063e2:	8082                	ret
{
    800063e4:	1101                	addi	sp,sp,-32
    800063e6:	ec06                	sd	ra,24(sp)
    800063e8:	e822                	sd	s0,16(sp)
    800063ea:	e426                	sd	s1,8(sp)
    800063ec:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063ee:	6904                	ld	s1,16(a0)
    800063f0:	ffffb097          	auipc	ra,0xffffb
    800063f4:	c5c080e7          	jalr	-932(ra) # 8000104c <mycpu>
    800063f8:	40a48533          	sub	a0,s1,a0
    800063fc:	00153513          	seqz	a0,a0
}
    80006400:	60e2                	ld	ra,24(sp)
    80006402:	6442                	ld	s0,16(sp)
    80006404:	64a2                	ld	s1,8(sp)
    80006406:	6105                	addi	sp,sp,32
    80006408:	8082                	ret

000000008000640a <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    8000640a:	1101                	addi	sp,sp,-32
    8000640c:	ec06                	sd	ra,24(sp)
    8000640e:	e822                	sd	s0,16(sp)
    80006410:	e426                	sd	s1,8(sp)
    80006412:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006414:	100024f3          	csrr	s1,sstatus
    80006418:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000641c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000641e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006422:	ffffb097          	auipc	ra,0xffffb
    80006426:	c2a080e7          	jalr	-982(ra) # 8000104c <mycpu>
    8000642a:	5d3c                	lw	a5,120(a0)
    8000642c:	cf89                	beqz	a5,80006446 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000642e:	ffffb097          	auipc	ra,0xffffb
    80006432:	c1e080e7          	jalr	-994(ra) # 8000104c <mycpu>
    80006436:	5d3c                	lw	a5,120(a0)
    80006438:	2785                	addiw	a5,a5,1
    8000643a:	dd3c                	sw	a5,120(a0)
}
    8000643c:	60e2                	ld	ra,24(sp)
    8000643e:	6442                	ld	s0,16(sp)
    80006440:	64a2                	ld	s1,8(sp)
    80006442:	6105                	addi	sp,sp,32
    80006444:	8082                	ret
    mycpu()->intena = old;
    80006446:	ffffb097          	auipc	ra,0xffffb
    8000644a:	c06080e7          	jalr	-1018(ra) # 8000104c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    8000644e:	8085                	srli	s1,s1,0x1
    80006450:	8885                	andi	s1,s1,1
    80006452:	dd64                	sw	s1,124(a0)
    80006454:	bfe9                	j	8000642e <push_off+0x24>

0000000080006456 <acquire>:
{
    80006456:	1101                	addi	sp,sp,-32
    80006458:	ec06                	sd	ra,24(sp)
    8000645a:	e822                	sd	s0,16(sp)
    8000645c:	e426                	sd	s1,8(sp)
    8000645e:	1000                	addi	s0,sp,32
    80006460:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006462:	00000097          	auipc	ra,0x0
    80006466:	fa8080e7          	jalr	-88(ra) # 8000640a <push_off>
  if(holding(lk))
    8000646a:	8526                	mv	a0,s1
    8000646c:	00000097          	auipc	ra,0x0
    80006470:	f70080e7          	jalr	-144(ra) # 800063dc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006474:	4705                	li	a4,1
  if(holding(lk))
    80006476:	e115                	bnez	a0,8000649a <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80006478:	87ba                	mv	a5,a4
    8000647a:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000647e:	2781                	sext.w	a5,a5
    80006480:	ffe5                	bnez	a5,80006478 <acquire+0x22>
  __sync_synchronize();
    80006482:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006486:	ffffb097          	auipc	ra,0xffffb
    8000648a:	bc6080e7          	jalr	-1082(ra) # 8000104c <mycpu>
    8000648e:	e888                	sd	a0,16(s1)
}
    80006490:	60e2                	ld	ra,24(sp)
    80006492:	6442                	ld	s0,16(sp)
    80006494:	64a2                	ld	s1,8(sp)
    80006496:	6105                	addi	sp,sp,32
    80006498:	8082                	ret
    panic("acquire");
    8000649a:	00002517          	auipc	a0,0x2
    8000649e:	23e50513          	addi	a0,a0,574 # 800086d8 <etext+0x6d8>
    800064a2:	00000097          	auipc	ra,0x0
    800064a6:	a3a080e7          	jalr	-1478(ra) # 80005edc <panic>

00000000800064aa <pop_off>:

void
pop_off(void)
{
    800064aa:	1141                	addi	sp,sp,-16
    800064ac:	e406                	sd	ra,8(sp)
    800064ae:	e022                	sd	s0,0(sp)
    800064b0:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800064b2:	ffffb097          	auipc	ra,0xffffb
    800064b6:	b9a080e7          	jalr	-1126(ra) # 8000104c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800064be:	8b89                	andi	a5,a5,2
  if(intr_get())
    800064c0:	e78d                	bnez	a5,800064ea <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800064c2:	5d3c                	lw	a5,120(a0)
    800064c4:	02f05b63          	blez	a5,800064fa <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800064c8:	37fd                	addiw	a5,a5,-1
    800064ca:	0007871b          	sext.w	a4,a5
    800064ce:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800064d0:	eb09                	bnez	a4,800064e2 <pop_off+0x38>
    800064d2:	5d7c                	lw	a5,124(a0)
    800064d4:	c799                	beqz	a5,800064e2 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064d6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800064da:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064de:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800064e2:	60a2                	ld	ra,8(sp)
    800064e4:	6402                	ld	s0,0(sp)
    800064e6:	0141                	addi	sp,sp,16
    800064e8:	8082                	ret
    panic("pop_off - interruptible");
    800064ea:	00002517          	auipc	a0,0x2
    800064ee:	1f650513          	addi	a0,a0,502 # 800086e0 <etext+0x6e0>
    800064f2:	00000097          	auipc	ra,0x0
    800064f6:	9ea080e7          	jalr	-1558(ra) # 80005edc <panic>
    panic("pop_off");
    800064fa:	00002517          	auipc	a0,0x2
    800064fe:	1fe50513          	addi	a0,a0,510 # 800086f8 <etext+0x6f8>
    80006502:	00000097          	auipc	ra,0x0
    80006506:	9da080e7          	jalr	-1574(ra) # 80005edc <panic>

000000008000650a <release>:
{
    8000650a:	1101                	addi	sp,sp,-32
    8000650c:	ec06                	sd	ra,24(sp)
    8000650e:	e822                	sd	s0,16(sp)
    80006510:	e426                	sd	s1,8(sp)
    80006512:	1000                	addi	s0,sp,32
    80006514:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006516:	00000097          	auipc	ra,0x0
    8000651a:	ec6080e7          	jalr	-314(ra) # 800063dc <holding>
    8000651e:	c115                	beqz	a0,80006542 <release+0x38>
  lk->cpu = 0;
    80006520:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006524:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006528:	0310000f          	fence	rw,w
    8000652c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006530:	00000097          	auipc	ra,0x0
    80006534:	f7a080e7          	jalr	-134(ra) # 800064aa <pop_off>
}
    80006538:	60e2                	ld	ra,24(sp)
    8000653a:	6442                	ld	s0,16(sp)
    8000653c:	64a2                	ld	s1,8(sp)
    8000653e:	6105                	addi	sp,sp,32
    80006540:	8082                	ret
    panic("release");
    80006542:	00002517          	auipc	a0,0x2
    80006546:	1be50513          	addi	a0,a0,446 # 80008700 <etext+0x700>
    8000654a:	00000097          	auipc	ra,0x0
    8000654e:	992080e7          	jalr	-1646(ra) # 80005edc <panic>
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
