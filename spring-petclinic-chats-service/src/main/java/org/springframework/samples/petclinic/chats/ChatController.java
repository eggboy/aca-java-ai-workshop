package org.springframework.samples.petclinic.chats;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChatController {
    @PostMapping("/chatclient")
    public String chat(@RequestBody String prompt) {
        return "Return from Chat client";
    }
}