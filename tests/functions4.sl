func int foo(int c) {
    return c+2;
}
func int bar(int a) {
    int b = a;
    return foo(b);
}
main() {
    init{
        int e = bar(60);
        print(e);
    }
}
