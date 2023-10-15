FROM openjdk:8
ADD jarstaging/com/valaxy1/demo-workshop/2.1.2/demo-workshop-2.1.2.jar ttrend.jar 
    jarstaging/com/valaxy1/demo-workshop/2.1.2/demo-workshop-2.1.2.jar
ENTRYPOINT [ "java", "-jar", "ttrend.jar" ]
