package main

// Poor demo for accessing UCP API
// Thanks to: https://gist.github.com/michaljemala/d6f4e01c4834bf47a9c4
import (
	"crypto/tls"
	"crypto/x509"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

var (
	certFile, keyFile, caFile string
	dockerCertPath            = os.Getenv("DOCKER_CERT_PATH")
	dockerHost                = os.Getenv("DOCKER_HOST")
	client                    *http.Client
)

func init() {
	if dockerCertPath == "" || dockerHost == "" {
		log.Fatalln("Error: Please set env with your UCP client bundle before running this program.")
	}
	dockerHost = strings.Replace(dockerHost, "tcp:", "https:", 1)
	fmt.Println("DOCKER_HOST: " + dockerHost)
	if dockerCertPath != "" {
		caFile = filepath.Join(dockerCertPath, "ca.pem")
		certFile = filepath.Join(dockerCertPath, "cert.pem")
		keyFile = filepath.Join(dockerCertPath, "key.pem")
	}
	flag.StringVar(&caFile, "cacert", caFile, "PEM eoncoded CA's certificate file")
	flag.StringVar(&certFile, "cert", certFile, "PEM eoncoded certificate file")
	flag.StringVar(&keyFile, "key", keyFile, "PEM encoded private key file.")
	flag.Parse()

	fmt.Printf("Args:\nCertFile: %q\nCaFile: %q\nKeyFile: %q\n", certFile, caFile, keyFile)

	// Load client cert
	cert, err := tls.LoadX509KeyPair(certFile, keyFile)
	if err != nil {
		log.Fatal(err)
	}

	// Load CA cert
	caCert, err := ioutil.ReadFile(caFile)
	if err != nil {
		log.Fatal(err)
	}
	caCertPool := x509.NewCertPool()
	caCertPool.AppendCertsFromPEM(caCert)

	// Setup HTTPS client
	tlsConfig := &tls.Config{
		Certificates:       []tls.Certificate{cert},
		RootCAs:            caCertPool,
		InsecureSkipVerify: false,
	}

	tlsConfig.BuildNameToCertificate()
	transport := &http.Transport{TLSClientConfig: tlsConfig}
	client = &http.Client{Transport: transport}

}

func doGet(urlctx string) *[]byte {
	// Do GET something
	resp, err := client.Get(dockerHost + "/" + urlctx)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	// Dump response
	data, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println(string(data))
	return &data
}

func main() {
	doGet("api/banner")
	doGet("nodes")
}
