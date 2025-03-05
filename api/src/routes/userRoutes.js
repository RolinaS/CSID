import express from 'express';
import { userController } from '../controllers/userController.js';
import { authMiddleware } from '../middleware/authMiddleware.js';
import { validateUser } from '../middleware/validation.js';

const router = express.Router();

// Public routes
router.post('/login', userController.login);

// Protected routes
router.use(authMiddleware);
router.get('/', userController.getUsers);
router.get('/:id', userController.getUserById);
router.post('/', validateUser, userController.createUser);
router.put('/:id', validateUser, userController.updateUser);
router.delete('/:id', userController.deleteUser);

export default router;
