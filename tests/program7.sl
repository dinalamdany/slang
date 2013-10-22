/*should not be accepted*/
main() {
  init {}
  always {}
  always {
    init {}
  }
}
