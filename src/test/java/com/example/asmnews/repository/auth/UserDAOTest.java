package com.example.asmnews.repository.auth;

import com.example.asmnews.entity.auth.User;
import org.testng.Assert;
import org.testng.annotations.AfterClass;
import org.testng.annotations.BeforeClass;
import org.testng.annotations.Test;

import java.util.Date;
import java.util.UUID;

/**
 * Unit test class using TestNG to verify UserDAO functionality
 * including Premium features, AI summary limit, and duplicate registration checks.
 */
public class UserDAOTest {

    private UserDAO userDAO;
    private String testUserId;
    private String testEmail;
    private String testMobile;
    private User testUser;

    @BeforeClass
    public void setUp() {
        userDAO = new UserDAO();
        // Generate unique credentials for test isolation
        String randomSuffix = UUID.randomUUID().toString().substring(0, 8);
        testUserId = "test_" + randomSuffix;
        testEmail = "test_" + randomSuffix + "@gmail.com";
        testMobile = "09" + String.format("%08d", (int) (Math.random() * 100000000));

        testUser = new User();
        testUser.setId(testUserId);
        testUser.setPassword("Password123!");
        testUser.setFullname("Test User " + randomSuffix);
        testUser.setEmail(testEmail);
        testUser.setMobile(testMobile);
        testUser.setRole(User.ROLE_READER);
        testUser.setActive(true);
        testUser.setPremium(false);
        testUser.setFreeSummaryCount(4);
    }

    @Test(priority = 1)
    public void testInsertUser() {
        boolean result = userDAO.insert(testUser);
        Assert.assertTrue(result, "Thêm user thử nghiệm phải thành công");
    }

    @Test(priority = 2, dependsOnMethods = "testInsertUser")
    public void testExistsUser() {
        boolean exists = userDAO.exists(testUserId);
        Assert.assertTrue(exists, "User mới tạo phải tồn tại");
    }

    @Test(priority = 3, dependsOnMethods = "testInsertUser")
    public void testDuplicateEmailCheck() {
        boolean emailExists = userDAO.emailExists(testEmail);
        Assert.assertTrue(emailExists, "Email đã sử dụng phải được nhận diện là tồn tại");
        
        boolean nonExistentEmail = userDAO.emailExists("nonexistent_" + testEmail);
        Assert.assertFalse(nonExistentEmail, "Email chưa sử dụng phải báo không tồn tại");
    }

    @Test(priority = 4, dependsOnMethods = "testInsertUser")
    public void testDuplicateMobileCheck() {
        boolean mobileExists = userDAO.mobileExists(testMobile);
        Assert.assertTrue(mobileExists, "Số điện thoại đã sử dụng phải được nhận diện là tồn tại");
        
        boolean nonExistentMobile = userDAO.mobileExists("0000000000");
        Assert.assertFalse(nonExistentMobile, "Số điện thoại chưa sử dụng phải báo không tồn tại");
    }

    @Test(priority = 5, dependsOnMethods = "testInsertUser")
    public void testAIFreeSummaryLimit() {
        // Fetch user from DB to verify initial state
        User userFromDB = userDAO.findById(testUserId);
        Assert.assertNotNull(userFromDB);
        Assert.assertEquals(userFromDB.getFreeSummaryCount(), 4, "Lượt tóm tắt ban đầu phải là 4");

        // Decrement 1 time
        boolean dec1 = userDAO.decrementFreeSummaryCount(testUserId);
        Assert.assertTrue(dec1, "Trừ lượt tóm tắt lần 1 phải thành công");

        User updatedUser = userDAO.findById(testUserId);
        Assert.assertEquals(updatedUser.getFreeSummaryCount(), 3, "Số lượt tóm tắt còn lại phải là 3");
    }

    @Test(priority = 6, dependsOnMethods = "testInsertUser")
    public void testUpgradeToPremium() {
        // Fetch user initial Premium state
        User userFromDB = userDAO.findById(testUserId);
        Assert.assertFalse(userFromDB.isPremium(), "Ban đầu người dùng thường không phải Premium");

        // Upgrade
        boolean upgradeResult = userDAO.upgradeToPremium(testUserId);
        Assert.assertTrue(upgradeResult, "Nâng cấp Premium phải thành công");

        // Verify updated state
        User vipUser = userDAO.findById(testUserId);
        Assert.assertTrue(vipUser.isPremium(), "Người dùng sau khi nâng cấp phải có trạng thái Premium = true");
    }

    @AfterClass
    public void tearDown() {
        if (testUserId != null && userDAO != null) {
            // Cleanup database by deleting the test user
            userDAO.delete(testUserId);
        }
    }
}
