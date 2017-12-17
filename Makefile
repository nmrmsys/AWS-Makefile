include AWS-Makefile.mk

KEY_NAME=your-key-name
CW_NAME_TAG=customweb:latest

all: MyCustomWeb

MyCustomWeb: MyNetwork MyCustomWebAmi MyCustomWebStack

MyCustomWebStack: CW_AMI_ID = $(shell ./amibake id $(CW_NAME_TAG))
MyCustomWebStack: CC_OPTS = --parameters ParameterKey=NetworkStackName,ParameterValue=MyNetwork ParameterKey=MyCustomWebAmiId,ParameterValue=$(CW_AMI_ID) ParameterKey=KeyName,ParameterValue=$(KEY_NAME)
MyCustomWebStack: $(DAM)/MyCustomWeb.stack

MyCustomWebAmi: AB_NAME_TAG = $(CW_NAME_TAG)
MyCustomWebAmi: $(DAM)/MyCustomWeb.ami

MyNetwork: $(DAM)/MyNetwork.stack

clean:
	@./cfn_delete.sh --wait MyCustomWeb
	./amibake rmi $(CW_NAME_TAG)
	@./cfn_delete.sh --wait MyNetwork
	@rm -f $(DAM)/*.stack $(DAM)/*.ami
