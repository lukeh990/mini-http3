#include <iostream>
#include "version.h"

int main() {
  std::cout << "Starting Mini-HTTP/3 v" << RELEASE_VERSION << std::endl
  << "BUILD: " << BUILD_VERSION << std::endl;
  return 0;
}
