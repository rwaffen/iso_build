#!/bin/bash
vagrant destroy -f
rm -rf centos7.iso
vagrant up
vagrant destroy -f
