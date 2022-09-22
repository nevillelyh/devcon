#!/bin/bash

export HADOOP_OS_TYPE=${HADOOP_OS_TYPE:-$(uname -s)}
export HADOOP_OPTIONAL_TOOLS="hadoop-aws"
