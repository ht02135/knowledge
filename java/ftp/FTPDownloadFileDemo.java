import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
 
import org.apache.commons.net.ftp.FTP;
import org.apache.commons.net.ftp.FTPClient;
import org.apache.commons.net.ftp.FTPReply;
 
/**
 * A program demonstrates how to upload files from local computer to a remote
 * FTP server using Apache Commons Net API.
 * @author www.codejava.net
 */
public class FTPDownloadFileDemo {
 
    public static void main(String[] args) {
        String server = "xxxxx";
        int port = 21;
        String user = "xxxx";
        String pass = "xxxx";
        String dir = "/";
 
        FTPClient ftpClient = new FTPClient();
        try {
 
            ftpClient.connect(server, port);
            int reply = ftpClient.getReplyCode();
            System.out.println("connect reply="+reply);
			if(!FTPReply.isPositiveCompletion(reply)) {
				ftpClient.disconnect();
				System.out.println("FTP server refused connection ="+reply);
			}
            
            ftpClient.login(user, pass);
            reply = ftpClient.getReplyCode();
            System.out.println("login reply="+reply);
			if(!FTPReply.isPositiveCompletion(reply)) {
				ftpClient.disconnect();
				System.out.println("FTP server refused connection ="+reply);
			}
            
            ftpClient.enterLocalPassiveMode();
            reply = ftpClient.getReplyCode();
            System.out.println("enterLocalPassiveMode reply="+reply);
			if(!FTPReply.isPositiveCompletion(reply)) {
				ftpClient.disconnect();
				System.out.println("FTP server refused connection ="+reply);
			}
            
            ftpClient.setFileType(FTP.BINARY_FILE_TYPE);
            reply = ftpClient.getReplyCode();
            System.out.println("setFileType reply="+reply);
			if(!FTPReply.isPositiveCompletion(reply)) {
				ftpClient.disconnect();
				System.out.println("FTP server refused connection ="+reply);
			}
            
            ftpClient.changeWorkingDirectory(dir);
            reply = ftpClient.getReplyCode();
            System.out.println("changeWorkingDirectory reply="+reply);
			if(!FTPReply.isPositiveCompletion(reply)) {
				ftpClient.disconnect();
				System.out.println("FTP server refused connection ="+reply);
			}
 
        } catch (IOException ex) {
            System.out.println("Error: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            try {
                if (ftpClient.isConnected()) {
                    ftpClient.logout();
                    ftpClient.disconnect();
                }
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }
}
