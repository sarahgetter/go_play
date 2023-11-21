.PHONY: build-datastream run-datastream clean-datastream \
        build-csv run-csv clean-csv clean-all

# Paths
DATASTREAM_PATH := /Users/sarahgetter/dev/go_play/scripts/datastream_processor/datastream_processor.go
CSV_NORMALIZATION_PATH := /Users/sarahgetter/dev/go_play/scripts/csv_normalization/csv_normalization.go

# Data Stream Processor
build-datastream:
    @echo "Building the data stream processor..."
    go build -o datastream_processor $(DATASTREAM_PATH)

run-datastream: build-datastream
    @echo "Running the data stream processor..."
    ./datastream_processor

clean-datastream:
    @echo "Cleaning up data stream processor..."
    rm -f datastream_processor

# CSV Normalization
build-csv:
    @echo "Building the CSV normalization script..."
    go build -o csv_normalizer $(CSV_NORMALIZATION_PATH)

run-csv: build-csv
    @echo "Running the CSV normalization script..."
    ./csv_normalizer

clean-csv:
    @echo "Cleaning up CSV normalization script..."
    rm -f csv_normalizer

# Clean All
clean-all: clean-datastream clean-csv
