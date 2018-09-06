#!/bin/bash
set -e
echo "Building XML::Parser.."
echo "Approximate build time: less than 0.1 SBU"
echo "Required disk space: 2.1 MB"

# 6.41. The XML::Parser module is a Perl interface to James Clark's
# XML parser, Expat.
tar -xf /sources/XML-Parser-*.tar.gz -C /tmp/ \
  && mv /tmp/XML-Parser-* /tmp/XML-Parser \
  && pushd /tmp/XML-Parser

# Prepare XML::Parser for compilation:
perl Makefile.PL

# Compile the package:
make

# To test the results, issue:
if [ $LFS_TEST -eq 1 ]; then make test; fi

# Install the package:
make install

# Cleanup
popd \
  && rm -rf /tmp/XML-Parser
