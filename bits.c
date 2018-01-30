
/* 
Jeff McMillan
bits practice

/* 
 * bitXor - x^y using only ~ and & 
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
  // returns 1 in positions where x and y have different values
  int a= x&y; // 1 where x and y are both 1
  int b= ~x;
  int c= ~y;
  int d= b&c; // 1 where x and y are both 0
  int e= ~d;
  int f= ~a;
  int g= e&f; // 1 where x and y are not the same
  return g; 
  
}
/* 
 * fitsShort - return 1 if x can be represented as a 
 *   16-bit, two's complement integer.
 *   Examples: fitsShort(33000) = 0, fitsShort(-32768) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 8
 *   Rating: 1
 */
int fitsShort(int x) {
  // it fits if all bits left of 15th bit is the same
  int z= x >> 15; // either -1 or 0 if it fits
  int a = !(z | 0); // 1 if z is 0
  int b = !((z+1) | 0); // 1 if z is -1
  return a | b; // fits if z is either 0 or -1
  
}
/* 
 * thirdBits - return word with every third bit (starting from the LSB) set to 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 8
 *   Rating: 1
 */
int thirdBits(void) {
  //begins with first two sequences of third bit and adds shifted sequence until all is in third bits
  int x = 0x24;
  x=x+(x<<6);
  x=x+(x<<12);
  x=x+(x<<24);
  return (x<<1)+1;
}
/* 
 * upperBits - pads n upper bits with 1's
 *  You may assume 0 <= n <= 32
 *  Example: upperBits(4) = 0xF0000000
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 10
 *  Rating: 1
 */
int upperBits(int n) {
  // gets 0x80000000 only if n!=0 and then shifts n-1 bits to fill n bits 
  int x = n & 0x3f;
  return ((!!x) << 31) >> (n+(~0));
  
}
/* 
 * fitsBits - return 1 if x can be represented as an 
 *  n-bit, two's complement integer.
 *   1 <= n <= 32
 *   Examples: fitsBits(5,3) = 0, fitsBits(-4,3) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 2
 */
int fitsBits(int x, int n) {
  //fits if all bits left of n-1 position are the same
  int z= x >> (n + ~0);
  int a = !(z | 0);
  int b = !((z+1)|0);
  return a | b;
}
/* 
 * implication - return x -> y in propositional logic - 0 for false, 1
 * for true
 *   Example: implication(1,1) = 1
 *            implication(1,0) = 0
 *   Legal ops: ! ~ ^ |
 *   Max ops: 5
 *   Rating: 2
 if a is true b must be true, if a is false, b can be either
 
 
 */
int implication(int x, int y) {
	//true if x is 0 or y is 1
	int a= !x; // 1 if x=0
    return y|a; // return 1 if x=0 or y=1
}
/* 
 * leastBitPos - return a mask that marks the position of the
 *               least significant 1 bit. If x == 0, return 0
 *   Example: leastBitPos(96) = 0x20
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 6
 *   Rating: 2 
 */
int leastBitPos(int x) {
  // subtracting 1 puts 0 in least bit position. the inverse and original can only be true in least bit position
  return x & ~(x+ ~0);
}
/* 
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
  // true only if x satisfies comparison for both ends of acceptable range
  int z= 1 << 31;
  int a= !((x + (~0x30+1)) & z); // 0 if x < 0x30, 1 if x > 0x30
  int b= !!((x + (~0x39)) & z); // 0 if x>39, 1 if x<39
  return a & b;
}
/*
 * satMul2 - multiplies by 2, saturating to Tmin or Tmax if overflow
 *   Examples: satMul2(0x30000000) = 0x60000000
 *             satMul2(0x40000000) = 0x7FFFFFFF (saturate to TMax)
 *             satMul2(0x60000000) = 0x80000000 (saturate to TMin)
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 */
int satMul2(int x) {
  // uses mask to make value tmax if overflow and original if not, then shifts by either -1,0,or 1 to get final value
  int sign= !(x & (1<<31)); // 0 if x negitive
  int a= ((x<<1) ^ x) >> 31; // 1 if overflow
  int z= (a<<31) >> 31;
  int mask= ~(1<<31); // 0x7fffffff
  int b= 0 + (mask & z); // 0 or mask
  int ret= (x & (~z)) + b;
  int s= sign | !a;
  return ret << (z+s);
}
/* 
 * rotateLeft - Rotate x to the left by n
 *   Can assume that 0 <= n <= 31
 *   Examples: rotateLeft(0x87654321,4) = 0x76543218
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 25
 *   Rating: 3 
 */
int rotateLeft(int x, int n) {
  // creates one value for bits shifted off and one for bits remaining and adds them together making sure there aren't extra 1's in wrong place 
  int a= x << n; // right end of final value put left
  int b= (1 << 31) >> (n + ~0);
  int c=(x & b) >> (32 + (~n+1));
  int d= ~((1<<31)>>(32+(~n))) & c; // necessary to remove possible extra 1's in left end put right
  return a + d;
}
/* 
 * subOK - Determine if can compute x-y without overflow
 *   Example: subOK(0x80000000,0x80000000) = 1,
 *            subOK(0x80000000,0x70000000) = 0, 
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 3
 
	if two positive numbers are added, overflow will be negitive or 0
	if two negitive numbers are added, overflow will be positive or 0
	
 */
int subOK(int x, int y) {
  // overflow occurs if x and y have different signs and x-y and y have same sign
  int z= x+(~y +1);
  int a= x^y; // last pos 1 if x and y are different signs
  int b= ~(z^y); // last pos 1 if z and y same sign
  return !((a & b) >> 31);
  
}
/*
 * bitParity - returns 1 if x contains an odd number of 0's
 *   Examples: bitParity(5) = 0, bitParity(7) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 4
 */
int bitParity(int x) {
  // the XOR removes 1s that are in the same position, so by XORing all shifts, a 1 can remain only if there is an odd number 1s, and if theres odd 1s there must be odd 0s
  x= x^ (x >> 16);
  x= x^ (x >> 8);
  x= x^ (x >> 4);
  x= x^ (x >> 2);
  x= x^ (x >> 1);
  //return x & 1 ;
  
  int a=2;
  int b=3;
  int z= a < b;
  return z; 
}
/*
 * isPower2 - returns 1 if x is a power of 2, and 0 otherwise
 *   Examples: isPower2(5) = 0, isPower2(8) = 1, isPower2(0) = 0
 *   Note that no negative number is a power of 2.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 20
 *   Rating: 4
 */
int isPower2(int x) {
  // power of 2 only if there is no 1s after least significant 1 but only if the left most bit is 0 and x is not 0
  int z= ~(x & ~(x+ ~0)); // inverse power of 2 from least significant 1
  int y= !!(x & z); // 0 if success
  int zero= !(x & ~0); // 0 if x != 0 
  int neg= (1 << 31) & x; // 0 if x is positive
  return !(y | zero | neg); 
  
}
/*
 * leftBitCount - returns count of number of consective 1's in
 *     left-hand (most significant) end of word.
 *   Examples: leftBitCount(-1) = 32, leftBitCount(0xFFF0F0F0) = 12
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 50
 *   Rating: 4
 */
int leftBitCount(int x) {
   // checks if all bits are 1s in groups of three then sums amount of groups that were all 1's. Sum multiplied by 3 and two additional spots checked and added to sum if appropriate  
  int first_3= (1<<31) >> 2;
  int a= !((x ^ first_3)>>29) ; // 1 if first 3 all ones
  int second_3= first_3 >> 3;
  int b= !((x ^ second_3) >>26);// 1 if first 6 all ones
  int third_3= second_3 >> 3;
  int c= !((x ^ third_3) >>23);
  int fourth_3= third_3 >>3;
  int d= !((x ^ fourth_3)>>20);
  int fifth_3= fourth_3 >> 3;
  int e= !((x ^ fifth_3)>>17);
  int sixth_3= fifth_3 >> 3;
  int f= !((x ^ sixth_3)>>14);
  int seventh_3= sixth_3 >> 3;
  int g= !((x ^ seventh_3)>>11);
  int eighth_3= seventh_3 >> 3;
  int h= !((x ^ eighth_3) >>8);
  int ninth_3= eighth_3 >> 3;
  int i= !((x ^ ninth_3)>>5);
  int tenth_3= ninth_3 >>3;
  int j= !((x ^ tenth_3)>>2);// 1 if all 32 are ones
  
  int sum= a+b+c+d+e+f+g+h+i+j;
  int pos= 31 + ((~((sum << 1) + (sum+1)))+1); // position for additional checking
  int one=  !!((1 << (pos+1)) & x);
  int two= one & (!!((1 << pos) & x));
  return (sum<<1) + sum + one + two; 
}
/* Extra credit */
/* 
 * float_neg - Return bit-level equivalent of expression -f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representations of
 *   single-precision floating point values.
 *   When argument is NaN, return argument.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 10
 *   Rating: 2
 */
unsigned float_neg(unsigned uf) {
	// NaN if exp bits all 1s and fraction bits all 0. Otherwise it switches left most bit
	int a= (((uf<<1) ^ 0xff000000)>>24); // if 0, nan
	int b= !(uf & 0x7fffff); // if 0, nan 
	if( a | b ){	 
		if( uf >> 31 == 0){
			return uf + 0x80000000;
		}else{
			return uf & 0x7fffffff;
		}
	}else{
		return uf;
	}
}
/* 
 * float_i2f - Return bit-level equivalent of expression (float) x
 *   Result is returned as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point values.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_i2f(int x) {
   return 2;
}
/* 
 * float_twice - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned float_twice(unsigned uf) {
  return 2;
}
