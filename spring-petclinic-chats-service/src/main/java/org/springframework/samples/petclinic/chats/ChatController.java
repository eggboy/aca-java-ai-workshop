package org.springframework.samples.petclinic.chats;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChatController {
    @PostMapping("/chatclient")
    public String chatClient() {
        return "Return from Chat client";
    }
}
