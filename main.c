void printchar(char c);

void printstr(char* str) {
	while (*str != '\0') {
		printchar(*str);
		if (*str == '\n') {
			printchar('\r');
		}
		str++;
	}
	return;
}

void c_func() {
	printchar('A');
	printchar('B');
	printchar('C');
	printchar(' ');
	printstr("Hello, World!\n");
	return;
}
