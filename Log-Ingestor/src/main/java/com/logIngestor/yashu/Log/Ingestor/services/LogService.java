package com.logIngestor.yashu.Log.Ingestor.services;



import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.logIngestor.yashu.Log.Ingestor.dto.LogDTO;
import com.logIngestor.yashu.Log.Ingestor.entities.LogEntity;
import com.logIngestor.yashu.Log.Ingestor.repositories.LogRepository;
import jakarta.transaction.Transactional;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Time;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class LogService {


    final LogRepository logRepository;
    final ModelMapper modelMapper;

    public LogService(LogRepository logRepository, ModelMapper modelMapper) {
        this.logRepository = logRepository;
        this.modelMapper = modelMapper;
    }


    public LogDTO getLogsById(Long id) {
        LogEntity logEntity = logRepository.getById(id);
        return  modelMapper.map(logEntity, LogDTO.class);
    }

    @Transactional
    public List<LogDTO> createNewLogs(List<LogDTO> logDTOs) {
        List<LogEntity> logEntities =  logDTOs.stream()
                .map(logDTO -> modelMapper.map(logDTO, LogEntity.class))
                .collect(Collectors.toList());
        List<LogEntity> savedLogs = logRepository.saveAll(logEntities);
        return savedLogs.stream()
                .map(logEntity -> modelMapper.map(logEntity,LogDTO.class))
                .collect(Collectors.toList());
    }

    @Transactional
    public LogDTO createNewLog(LogDTO logDTO) {
        LogEntity logEntity = modelMapper.map(logDTO,LogEntity.class);
        return modelMapper.map(logRepository.save(logEntity),LogDTO.class);
    }

    public List<LogDTO> getAllLogs() {
        return logRepository
                .findAll()
                .stream()
                .map(logEntity -> modelMapper.map(logEntity, LogDTO.class))
                .collect(Collectors.toList());
    }

    public boolean deleteLogsById(Long id) {
        boolean isPresent = logRepository.existsById(id);
        if (!isPresent) return false;
        logRepository.deleteById(id);
        return true;
    }

    public List<LogDTO> searchLogs(String level,
                                   String message,
                                   String resourceId,
                                   String timestamp,
                                   String traceId,
                                   String spanId,
                                   String commit,
                                   String metadata,
                                   LocalDateTime startDate,
                                   LocalDateTime endDate) {
        List<LogEntity> logEntities = logRepository.searchLogs(level, message, resourceId, timestamp, traceId, spanId, commit, metadata);
        return logEntities.stream()
                .map(logEntity -> modelMapper.map(logEntity, LogDTO.class))
                .collect(Collectors.toList());
    }

    @Transactional
    public List<LogDTO> ingestLogsFromJsonFile(MultipartFile file) throws IOException {
        ObjectMapper objectMapper = new ObjectMapper();
        InputStream inputStream = file.getInputStream();
        List<LogDTO> logDTOs = objectMapper.readValue(inputStream, new TypeReference<List<LogDTO>>() {});

        List<LogEntity> logEntities = logDTOs.stream()
                .map(logDTO -> modelMapper.map(logDTO, LogEntity.class))
                .collect(Collectors.toList());

        List<LogEntity> savedLogs = logRepository.saveAll(logEntities);

        return savedLogs.stream()
                .map(logEntity -> modelMapper.map(logEntity, LogDTO.class))
                .collect(Collectors.toList());

    }

}
