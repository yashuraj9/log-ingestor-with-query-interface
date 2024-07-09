package com.logIngestor.yashu.Log.Ingestor.controllers;

//Operations
// GET all logs /logs
// POST /logs
//DELETE /employees/{id}

import com.logIngestor.yashu.Log.Ingestor.dto.LogDTO;
import com.logIngestor.yashu.Log.Ingestor.services.LogService;
import lombok.extern.java.Log;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpStatusCode;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping(path = "/logs")
@CrossOrigin(origins = "http://localhost:52399/")
public class LogController {

    private final LogService logService;

    public LogController(LogService logService) {
        this.logService = logService;
    }

    @GetMapping
    public List<LogDTO> getAllLogs() {
        return logService.getAllLogs();
    }


    @GetMapping(path = "/{id}")
    public LogDTO getLogsById(@PathVariable("id") Long logId) {
        //LocalDateTime timestamp = LocalDateTime.now()
        // LogDTO.Metadata metadata = new LogDTO.Metadata("server-0987");
        return logService.getLogsById(logId);
    }

    @PostMapping("/bulk")
    public List<LogDTO> createNewLogs(@RequestBody List<LogDTO> logDTO) {
        return logService.createNewLogs(logDTO);
    }

    @PostMapping
    public LogDTO createNewLog(@RequestBody LogDTO logDTO) {
        return logService.createNewLog(logDTO);
    }

    @DeleteMapping(path = "/{id}")
    public boolean deleteLogsById(@PathVariable Long id) {
        return logService.deleteLogsById(id);
    }

    @GetMapping(path = "/search")
    public List<LogDTO>  searchLogs(
            @RequestParam(required = false) String level,
            @RequestParam(required = false) String message,
            @RequestParam(required = false) String resourceId,
            @RequestParam(required = false) String timestamp,
            @RequestParam(required = false) String traceId,
            @RequestParam(required = false) String spanId,
            @RequestParam(required = false) String commit,
            @RequestParam(required = false) String metadata,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate) {
        return logService.searchLogs(level, message, resourceId, timestamp,traceId, spanId, commit, metadata, startDate, endDate);
    }

    @PostMapping("/ingest")
    public ResponseEntity<List<LogDTO>> ingestLogsFromJsonFile(@RequestParam("file")MultipartFile file) {
        try{
            List<LogDTO> savedLogs = logService.ingestLogsFromJsonFile(file);
            return ResponseEntity.ok(savedLogs);
        } catch (IOException e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
