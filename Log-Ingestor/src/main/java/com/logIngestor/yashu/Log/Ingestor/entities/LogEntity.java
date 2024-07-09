package com.logIngestor.yashu.Log.Ingestor.entities;

import com.logIngestor.yashu.Log.Ingestor.dto.LogDTO;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;


@Entity
@Table(name = "Logs")
@Data
@AllArgsConstructor
@NoArgsConstructor

public class LogEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
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
