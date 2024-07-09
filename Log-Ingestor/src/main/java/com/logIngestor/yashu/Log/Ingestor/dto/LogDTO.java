package com.logIngestor.yashu.Log.Ingestor.dto;

import lombok.*;

import javax.annotation.processing.Generated;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class LogDTO {

    private Long id;
    private String level;
    private String message;
    private String resourceId;
    private LocalDateTime timestamp;
    private String traceId;
    private String spanId;
    private String commit;
    private String metadata;
}

