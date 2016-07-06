# gns3-docker
Release Information

Official Releases

    v1.5.0 -- Official Alpha release for GNS3 Server v1.5.0
    development -- Testing new functionality, view https://github.com/gcasella/gns3-docker/tree/development for details.
    Details
    This docker container will host the most up to date version of GNS3 (1.5.0) along with the following;

    iou
    qemu
    vpcs
    dynamips

This container is in an Alpha phase, this should only be used for testing purposes for the time being.
How To Run

To run this docker instance several types of commands can be used to run the docker image.
The iterations of the commands below are only used if you wish to use it that way.

To run the docker image as a standard image using your default docker0 bridge interface use the command;
docker run --privileged --cap-add SYS_ADMIN -itd gcasella/gns3-docker:v1.5.0

If you want to use your own user defined network with a static IP Address you can use the following command;
docker run --privileged --cap-add SYS_ADMIN --net=<net-name> --ip=<ip-addr> -itd gcasella/gns3-docker:v1.5.0
Run Development

To test the new features for the gcasella/gns3-docker:development branch use the following command;
docker run --privileged --cap-add SYS_ADMIN -itd -v /lib/modules:/lib/modules gcasella/gns3-docker:development

