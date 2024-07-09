package com.logIngestor.yashu.Log.Ingestor.repositories;


import com.logIngestor.yashu.Log.Ingestor.entities.LogEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LogRepository extends JpaRepository<LogEntity, Long> {

    @Query("SELECT l FROM LogEntity l where " +
            "(:level IS NULL OR l.level = :level) AND " +
            "(:message IS NULL OR l.message = :message) AND " +
            "(:resourceId IS NULL OR l.resourceId = :resourceId) AND " +
            "(:timestamp IS NULL OR l.timestamp = :timestamp) AND " +
            "(:traceId IS NULL OR l.traceId = :traceId) AND" +
            "(:spanId IS NULL OR l.spanId = :spanId) AND " +
            "(:commit IS NULL OR l.commit = :commit) AND " +
            "(:metadata IS NULL OR l.metadata = :metadata)")
    List<LogEntity> searchLogs(@Param("level") String level,
                               @Param("message") String message,
                               @Param("resourceId") String resourceId,
                               @Param("timestamp") String timestamp,
                               @Param("traceId") String traceId,
                               @Param("spanId") String spanId,
                               @Param("commit") String commit,
                               @Param("metadata") String metadata);
}
